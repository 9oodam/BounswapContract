// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "hardhat/console.sol";

import "../routers/Data.sol";
import "./Pool.sol";
import "./Token.sol";
import "./WBNC.sol";

contract Swap {
    Data dataParams;
    WBNC wbncParams;
    address wbncAddress;

    uint _amount0In;
    uint _amount1In;
    uint _amount0Out;
    uint _amount1Out;

    constructor(address _dataAddress, address _wbncAddress) {
        dataParams = Data(_dataAddress);
        wbncParams = WBNC(_wbncAddress);
        wbncAddress = _wbncAddress;
    }

    // 재진입 공격 방지를 위한 lock 정의
    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    // event Swap(
    //     address indexed user,
    //     address indexed pair,
    //     uint amount0In,
    //     uint amount1In,
    //     uint amount0Out,
    //     uint amount1Out
    // );

    // minToken 계산
    function getMinToken(address pairAddress, uint inputAmount, address[2] memory path) external view returns (uint minToken) {
        uint amount = getAmountOut(pairAddress, inputAmount, path); // output
        minToken = amount * 995 / 1000;
    }
    // maxToken 계산
    function getMaxToken(address pairAddress, uint outputAmount, address[2] memory path) external view returns (uint maxToken) {
        uint amount = getAmountIn(pairAddress, outputAmount, path);
        maxToken = amount / 995 * 1000;
    }

    // 사용자가 input에 숫자 넣었을 떄 out에 나올 예상량 계산
    function getAmountOut(
        address pairAddress,
        uint inputAmount, // A
        address[2] memory path
    ) internal view returns (uint amountOut) { // B 
        // CPMM => AY / (A+X) = B 
        require(inputAmount > 0, "INSUFFICIENT_INPUT_AMOUNT");
        Pool pool = Pool(pairAddress);
        (uint reserve0, uint reserve1, ) = pool.getReserves();
        (uint reserveIn, uint reserveOut) = pool.token0() == path[0] ? (reserve0, reserve1) : (reserve1, reserve0);
        uint amountInWithFee = inputAmount * 997; // 수수료 0.3%
        uint numerator = amountInWithFee * reserveOut;
        uint denominator = (reserveIn * 1000) + amountInWithFee; // 수수료 고려안한 원래 금액 + 수수료
        amountOut = numerator / denominator;
        console.log('getAmountOut : ', reserveIn, reserveOut, amountOut);
    }
    // 사용자가 ouput에 숫자 넣었을 때 in에 나올 예상량 계산
    function getAmountIn(
        address pairAddress,
        uint outputAmount, // B
        address[2] memory path
    ) internal view returns (uint amountIn) { // A
        // CPMM => XB / (Y - B) = A
        require(outputAmount > 0, "INSUFFICIENT_OUTPUT_AMOUNT");
        Pool pool = Pool(pairAddress);
        (uint reserve0, uint reserve1, ) = pool.getReserves();
        (uint reserveIn, uint reserveOut) = pool.token0() == path[0] ? (reserve0, reserve1) : (reserve1, reserve0);
        require(reserveIn > 0 && reserveOut > 0, "INSUFFICIENT)LIQUIDITY");
        uint numerator = reserveIn * outputAmount * 1000;
        uint denominator = (reserveOut - outputAmount) * 997;
        amountIn = (numerator / denominator) + 1; // 나눗셈 손실을 보상하기 위해 1을 더함
    }

    // input 값을 지정, 계산된 ouput 값을 받음 / 받을 값이 0.5% 이하로 떨어지면 실행 안함
    function exactTokensForTokens(
        address pairAddress,
        uint inputAmount, // 사용자가 입력하는 A값
        uint minToken, // 슬리피지 방지를 위한 최솟값
        address[2] calldata path, // 프론트에서 셀렉한 토큰 2개
        address to
    ) public returns (bool) {
        uint amount = getAmountOut(pairAddress, inputAmount, path); // output
        require(amount >= minToken, "INSUFFICIENT_OUTPUT_AMOUNT");
        Token(path[0]).transferFromTo(to, pairAddress, inputAmount); // 사용자 -> 페어로 토큰 전송
        _swap(to, pairAddress, amount, path, to);
        return true;
    }
    function exactTokensForBNC(
        address pairAddress,
        uint inputAmount,
        uint minToken,
        address[2] calldata path,
        address to
    ) public payable returns (bool) {
        console.log('run??');
        require(path[1] == wbncAddress, 'INVALID_PATH'); // output이 wbnc
        uint amount = getAmountOut(pairAddress, inputAmount, path);
        require(amount >= minToken, "INSUFFICIENT_OUTPUT_AMOUNT");
        // 권한 위임 확인 필요
        Token(path[0]).transferFromTo(to, pairAddress, inputAmount);
        _swap(to, pairAddress, amount, path, address(this)); // 이 컨트랙트로 wbnc 소유주 바꿈
        wbncParams.withdraw(pairAddress, amount, to); // 이 컨트랙트가 보유한 wbnc 소각
        console.log('bnc for user : ', amount);
    }
    function exactBNCForTokens(
        address pairAddress,
        uint minToken,
        address[2] calldata path,
        address to
    ) public payable {
        // require(path[0] == wbncAddress, 'INVALID_PATH'); // input값이 wbnc
        uint amount = getAmountOut(pairAddress, msg.value, path);
        require(amount >= minToken, "INSUFFICIENT_OUTPUT_AMOUNT");
        wbncParams.deposit{value: msg.value}(pairAddress, msg.value); // 사용자가 넣은 bnc를 wbnc 컨트랙트로 보내고 wbnc 발행
        _swap(to, pairAddress, amount, path, to);
    }

    // output 값을 지정, 계산된 input 값을 받음 / 지불하고 싶은 값이 0.5% 이상으로 올라가면 실행 안함
    function tokensForExactTokens(
        address pairAddress,
        uint outputAmount,
        uint maxToken,
        address[2] calldata path,
        address to
    ) public returns (bool) {
        uint amount = getAmountIn(pairAddress, outputAmount, path);
        require(amount <= maxToken, "INSUFFICIENT_INPUT_AMOUNT");
        Token(path[0]).transferFromTo(to, pairAddress, amount);
        _swap(to, pairAddress, outputAmount, path, to);
        return true;
    }
    function tokensForExactBNC(
        address pairAddress,
        uint outputAmount,
        uint maxToken,
        address[2] calldata path,
        address to
    ) public returns (bool) {
        require(path[1] == wbncAddress, 'INVALID_PATH');
        uint amount = getAmountIn(pairAddress, outputAmount, path);
        require(amount <= maxToken, "INSUFFICIENT_INPUT_AMOUNT");
        Token(path[0]).transferFromTo(to, pairAddress, amount);
        _swap(to, pairAddress, outputAmount, path, address(this));
        wbncParams.withdraw(pairAddress, outputAmount, to); // 이 컨트랙트가 보유한 wbnc 소각
        console.log('bnc for user : ', outputAmount);
    }
    function bNCForExactTokens(
        address pairAddress,
        uint outputAmount,
        address[2] calldata path,
        address to
    ) public payable returns (bool) {
        require(path[0] == wbncAddress, 'INVALID_PATH');
        uint amount = getAmountIn(pairAddress, outputAmount, path);
        require(amount <= msg.value, 'EXCESSIVE_INPUT_AMOUNT'); // 계산된 input 값보다 사용자가 실제 보낸 value 값이 더 많아야 함
        wbncParams.deposit{value: amount}(pairAddress, amount); // 페어 소유로 wbnc를 발행
        _swap(to, pairAddress, outputAmount, path, to);
        // 실제 받은 value가 계산된 값보다 큰 경우 사용자에게 돌려줌
        if (msg.value > amount) to.call{value: msg.value - amount}("");
    }


    // input/ouput => token0/token1 지정해주는 부분
    function _swap(address userAddress, address pairAddress, uint amount, address[2] memory path, address _to) internal virtual {
        (address input, address output) = (path[0], path[1]);
        (address token0, address token1) = input < output ? (input, output) : (output, input);
        (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amount) : (amount, uint(0));
        swap(userAddress, pairAddress, amount0Out, amount1Out, _to);
    }

    // 사용자가 계산된 amount를 돌려받는 부분 (to == 사용자)
    function swap(address userAddress, address pairAddress, uint amount0Out, uint amount1Out, address to) internal lock {
        require(amount0Out > 0 || amount1Out > 0, "INSUFFICIENT_OUTPUT_AMOUNT");
        Pool pair = Pool(pairAddress);
        (uint112 _reserve0, uint112 _reserve1, ) = pair.getReserves();
        require(amount0Out < _reserve0 && amount1Out < _reserve1, "INSUFFICIENT_LIQUIDITY");

        uint balance0 = 0; 
        uint balance1 = 0;
        {
        address _token0 = pair.token0();
        address _token1 = pair.token1();
        require(to != _token0 && to != _token1, "INVALID_TO");
        if (amount0Out > 0) Token(_token0).transferFromTo(pairAddress, to, amount0Out); 
        if (amount1Out > 0) Token(_token1).transferFromTo(pairAddress, to, amount1Out); 
        // if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); 
        // if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out);
        balance0 = Token(_token0).balanceOf(pairAddress);
        balance1 = Token(_token1).balanceOf(pairAddress);
        }

        // 사용자가 token0을 유동성 풀에 추가했을 때만 amount0In을 계산 아니면 0
        uint amount0In = balance0 > _reserve0 - amount0Out
            ? balance0 - (_reserve0 - amount0Out) // 사용자가 풀에 추가한 token0의 양
            : 0;
        uint amount1In = balance1 > _reserve1 - amount1Out
            ? balance1 - (_reserve1 - amount1Out)
            : 0;
        require(amount0In > 0 || amount1In > 0, "INSUFFICIENT_INPUT_AMOUNT");
        
        { 
        // 불변성 확인용 코드, x * y = k            
        uint balance0Adjusted = SafeMath.sub(
            SafeMath.mul(balance0, 1000),
            SafeMath.mul(amount0In, 3)
        );
        uint balance1Adjusted = SafeMath.sub(
            SafeMath.mul(balance1, 1000),
            SafeMath.mul(amount1In, 3)
        );
        require(SafeMath.mul(balance0Adjusted, balance1Adjusted) >= SafeMath.mul(SafeMath.mul(uint(_reserve0), _reserve1), 1000 ** 2), "K");
        }

        pair._update(balance0, balance1, _reserve0, _reserve1);
        // emit Swap(userAddress, pairAddress, amount0In, amount1In, amount0Out, amount1Out);
        _amount0In = amount0In;
        _amount1In = amount1In;
        _amount0Out = amount0Out;
        _amount1Out = amount1Out;
        console.log('swap succeed : ', amount0In+amount0Out, amount1In+amount1Out);

        // Swap의 0.3% 수수료를 풀 공급자에게 배분
        addUnclaimedFee(pairAddress, SafeMath.mul(amount0In, 3), SafeMath.mul(amount1In, 3));
    }

    function getSwapAmount() external view returns (uint, uint, uint, uint) {
        return (_amount0In, _amount1In, _amount0Out, _amount1Out);
    }

    // unclaimed fee 누적시키기
    function addUnclaimedFee(address pairAddress, uint fee0, uint fee1) internal {
        for (uint i = 0; i < dataParams.validatorArrLength(pairAddress); i++) {
            address validator = dataParams.getValidatorArr(pairAddress)[i]; // 공급자
            uint liquidity = Pool(pairAddress).totalSupply(); // lp token 총량
            uint userLiquidity = Pool(pairAddress).balanceOf(validator); // 공급자의 Lp token 개수
            (uint256 lastUserFee0, uint256 lastUserFee1) = dataParams.getUnclaimedFee(validator, pairAddress); // 최근 누적된 보상

            // swap 한 수량의 0.3%를 유저의 유동성만큼 계산해서 누적시키기
            uint256 userFee0 = (fee0 * userLiquidity) / liquidity + lastUserFee0;
            uint256 userFee1 = (fee1 * userLiquidity) / liquidity + lastUserFee1;
            
            dataParams.setUnclaimedFee(validator, pairAddress, userFee0, userFee1);
        }
    }
}
