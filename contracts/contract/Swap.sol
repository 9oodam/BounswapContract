// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Pool.sol";
import "./Token.sol";
import "./WBNC.sol";
import "../utils/Data.sol";

contract Swap {
    Data dataParams;
    WBNC wbncParams;
    address wbncAddress;

    constructor(address _dataAddress, address _wbncAddress) {
        dataParams = Data(_dataAddress);
        wbncParams = WBNC(_wbncAddress);
        wbncAddress = _wbncAddress;
    }

    // 재진입 공격 방지를 위한 lock 정의
    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'UniswapV2: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );

    // 사용자가 input에 숫자 넣었을 떄 out에 나올 예상량 계산
    function getAmountOut(
        address pairAddress,
        uint inputAmount, // A
        address[2] memory path
    ) public view returns (uint amountOut) { // B 
        // CPMM => AY / (A+X) = B 
        require(inputAmount > 0, "INSUFFICIENT_INPUT_AMOUNT");
        Pool pool = Pool(pairAddress);
        (uint reserve0, uint reserve1, ) = pool.getReserves();
        (uint reserveIn, uint reserveOut) = pool.token0() == path[0] ? (reserve0, reserve1) : (reserve1, reserve0);
        uint amountInWithFee = inputAmount * 997; // 수수료 0.3%
        uint numerator = amountInWithFee * reserveOut;
        uint denominator = (reserveIn * 1000) + amountInWithFee; // 수수료 고려안한 원래 금액 + 수수료
        amountOut = numerator / denominator;
    }
    // 사용자가 ouput에 숫자 넣었을 때 in에 나올 예상량 계산
    function getAmountIn(
        address pairAddress,
        uint outputAmount, // B
        address[2] memory path
    ) public view returns (uint amountIn) { // A
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
        Token(path[0]).transferFrom(to, pairAddress, inputAmount); // 사용자 -> 페어로 토큰 전송
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
        require(path[1] == wbncAddress, 'INVALID_PATH'); // output이 wbnc
        uint amount = getAmountOut(pairAddress, inputAmount, path);
        require(amount >= minToken, "INSUFFICIENT_OUTPUT_AMOUNT");
        // 권한 위임 확인 필요
        Token(path[0]).transferFrom(to, pairAddress, inputAmount);
        _swap(to, pairAddress, amount, path, address(this)); // 이 컨트랙트로 wbnc 소유주 바꿈
        wbncParams.withdraw(amount); // 이 컨트랙트가 보유한 wbnc 소각
        (bool success, ) = to.call{value: amount}(""); // 사용자에게 bnc 전송
        require(success, "TransferHelper: ETH transfer failed");
    }
    function exactBNCForTokens(
        address pairAddress,
        uint inputAmount,
        uint minToken,
        address[2] calldata path,
        address to
    ) public payable {
        require(path[0] == wbncAddress, 'INVALID_PATH'); // input값이 wbnc
        uint amount = getAmountOut(pairAddress, inputAmount, path);
        require(amount >= minToken, "INSUFFICIENT_OUTPUT_AMOUNT");
        wbncParams.deposit{value: inputAmount}(inputAmount); // 사용자가 넣은 bnc를 wbnc 컨트랙트로 보내고 wbnc 발행
        assert(wbncParams.transfer(pairAddress, inputAmount)); // 발행된 wbnc 소유주를 페어로
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
        Token(path[0]).transferFrom(to, pairAddress, amount);
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
        Token(path[0]).transferFrom(to, pairAddress, amount);
        _swap(to, pairAddress, outputAmount, path, address(this));
        wbncParams.withdraw(outputAmount); // 이 컨트랙트가 보유한 wbnc 소각
        (bool success, ) = to.call{value: outputAmount}(""); // 사용자에게 bnc 전송
        require(success, "TransferHelper: ETH transfer failed");
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
        wbncParams.deposit{value: amount}(amount);
        assert(wbncParams.transfer(pairAddress, amount)); // 발행된 wbnc를 페어 소유로
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
        if (amount0Out > 0) Token(_token0).transfer(to, amount0Out); 
        if (amount1Out > 0) Token(_token1).transfer(to, amount1Out); 
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
        require(SafeMath.mul(balance0Adjusted, balance1Adjusted) >= SafeMath.mul(SafeMath.mul(uint(_reserve0), _reserve1), 1000 ** 2), "UniswapV2: K");
        }

        pair._update(balance0, balance1, _reserve0, _reserve1);
        emit Swap(userAddress, amount0In, amount1In, amount0Out, amount1Out, pairAddress);
    }

    // unclaimed fee 누적시키기
    // function addUnclaimedFee(address pairAddress, address userAddress) internal {
    //     for (uint i = 0; i < dataParams.validatorArr[pairAddress].length; i++) {
    //         uint userLiquidity = Pool(pairAddress).balanceOf()

    //         userlUnclaimedFees[validatorArr[i]].token0Amount +=
    //             (SafeMath.mul(amount0In, 3) * userLiquidity) /
    //             liquidity;
    //         userlUnclaimedFees[validatorArr[i]].token1Amount +=
    //             (SafeMath.mul(amount1In, 3) * userLiquidity) /
    //             liquidity;
    //         userlUnclaimedFees[validatorArr[i]].token0Amount += amount0In.mul(3) * userLiquidity / liquidity;
    //         userlUnclaimedFees[validatorArr[i]].token1Amount += amount1In.mul(3) * userLiquidity / liquidity;
        
    // }
}
