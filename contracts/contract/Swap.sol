// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Pool.sol";
import "./Token.sol";

contract Swap {
    address wbncAddress;

    constructor(address _wbncAddress) {
        wbncAddress = _wbncAddress;
    }

    // token0, token1의 volume
    // mapping(uint blockStamp => uint volume) public volumePerTransaction0; 
    // mapping(uint blockStamp => uint volume) public volumePerTransaction1;

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

    // input 값을 지정, 계산된 ouput 값을 받음 / 받을 값이 0.5% 이하로 떨어지면 실행 안함
    function beforeSwapInput(
        address pairAddress,
        uint inputAmount, // 사용자가 입력하는 A값
        uint minToken // 슬리피지 방지를 위한 최솟값
        address[] calldata path, // 프론트에서 셀렉한 토큰 2개
        address to
    ) public returns (bool) {
        Pool pool = Pool(pairAddress);
        uint amount = getAmountOut(inputAmount, pool.reserve0, pool.reserve1);
        require(amount >= minToken, "INSUFFICIENT_OUTPUT_AMOUNT");
        Token(path[0]).transfer(to, pairAddress, inputAmount); // 사용자 -> 페어로 토큰 전송

        _swap(amount, path, to);
        return true;
    }

    // 사용자가 input에 숫자 넣었을 떄 out에 나올 예상량 계산
    function getAmountOut(
        uint inputAmount, // A
        uint reserveIn, // X
        uint reserveOut // Y
    ) public pure returns (uint amountOut) { // B 
        // CPMM
        // AY / (A+X) = B 
        require(inputAmount > 0, "INSUFFICIENT_INPUT_AMOUNT");
        uint amountInWithFee = inputAmount * 997; // 수수료 0.3%
        uint numerator = amountInWithFee * reserveOut;
        uint denominator = (reserveIn * 1000) + amountInWithFee; // 수수료 고려안한 원래 금액 + 수수료
        amountOut = numerator / denominator;
    }

    // output 값을 지정, 계산된 input 값을 받음
    // 지불하고 싶은 값이 0.5% 이상으로 올라가면 실행 안함
    function beforeSwapOutput(
        address userAddress,
        address pairAddress,
        address outputTokenAddress,
        uint outputAmount,
        uint maxToken
    ) public returns (bool) {
        Pool pair = Pool(pairAddress);

        (uint112 reserve0, uint112 reserve1) = pair.getReserves();

        uint inputAmount;
        if (outputTokenAddress == pair.token0()) {
            inputAmount = getAmountIn(outputAmount, reserve1, reserve0);
        } else if (outputTokenAddress == pair.token1()) {
            inputAmount = getAmountIn(outputAmount, reserve0, reserve1);
        } else {
            revert("Invalid token address");
        }

        // output으로 input(내꺼) 계산이니까 많아지면 손해
        uint maxAmountWithSlippage = (inputAmount * 1005) / 1000;
        require(maxAmountWithSlippage <= maxToken, "EXCESSIVE_INPUT_AMOUNT");

        if (tokenAddress == pair.token0()) {
            swap(userAddress, inputAmount, 0, pairAddress);
        }else {
            swap(userAddress, 0, inputAmount, pairAddress);
        }
        return true;
    }

    function getAmountIn(
        uint outputAmount, // B
        uint reserveIn, // X
        uint reserveOut // Y
    ) public pure returns (uint amountIn) { // A
        // CPMM output으로 input값 계산할 때
        // B값이 고정되어 있을 때, A를 찾는 것
        // XB / (Y - B) = A
        require(outputAmount > 0, "INSUFFICIENT_OUTPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "INSUFFICIENT)LIQUIDITY");
        uint numerator = reserveIn * outputAmount * 1000;
        uint denominator = (reserveOut - outputAmount) * 997;
        amountIn = (numerator / denominator) + 1; // 나눗셈 손실을 보상하기 위해 1을 더함

        return amountIn;
    }




    // input/ouput => token0/token1 지정해주는 부분
    function _swap(uint amount, address[] memory path, address _to) internal virtual {{
        (address input, address output) = (path[0], path[1]);
        (address token0, address token1) = input < output? (input, ouput) : (ouput, input);
        (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amount) : (amount, uint(0));
        swap(amount0Out, amount1Out, _to);
    }

    // 사용자가 계산된 amount를 돌려받는 부분 (to == 사용자)
    function swap(uint amount0Out, uint amount1Out, address to) external lock {
        require(amount0Out > 0 || amount1Out > 0, "INSUFFICIENT_OUTPUT_AMOUNT");
        (uint112 _reserve0, uint112 _reserve1, ) = pair.getReserves();
        require(amount0Out < _reserve0 && amount1Out < _reserve1, "INSUFFICIENT_LIQUIDITY");

        uint balance0 = 0; 
        uint balance1 = 0;

        {
        address _token0 = pair.token0();
        address _token1 = pair.token1();
        require(to != _token0 && to != _token1, "INVALID_TO");
        if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); 
        if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out);
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

        // unclaimed fee 누적시키기
        
        // for (uint i = 0; i < validatorArr.length; i++) {
        //     uint userLiquidity = poolDataForValidator[validatorArr[i]].lpToken;
        //     uint liquidity = balanceOf(address(this));

        //     userlUnclaimedFees[validatorArr[i]].token0Amount +=
        //         (SafeMath.mul(amount0In, 3) * userLiquidity) /
        //         liquidity;
        //     userlUnclaimedFees[validatorArr[i]].token1Amount +=
        //         (SafeMath.mul(amount1In, 3) * userLiquidity) /
        //         liquidity;
            // userlUnclaimedFees[validatorArr[i]].token0Amount += amount0In.mul(3) * userLiquidity / liquidity;
            // userlUnclaimedFees[validatorArr[i]].token1Amount += amount1In.mul(3) * userLiquidity / liquidity;
        

        pair._update(balance0, balance1, _reserve0, _reserve1);
        emit Swap(userAddress, amount0In, amount1In, amount0Out, amount1Out, pairAddress);
    }
}
