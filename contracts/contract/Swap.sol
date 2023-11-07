// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Pool.sol";
import "./Token.sol";

contract Swap {

    constructor() {}

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

    // input 값을 넣어서 ouput 값을 받고 싶을 때 == 받고 싶은 값이 0.5% 이하로 떨어지면 실행 안함
    function beforeSwapInput(
        address userAddress,
        address pairAddress,
        address tokenAddress, // 프론트에서 토큰 셀렉부분
        uint inputAmount, // 사용자가 입력하는 A값
        uint minToken // 슬리피지 방지를 위해 사용자가 입력하는 값 ? 
    ) public returns (bool) {
        Pool pair = Pool(pairAddress);
        // 토큰 주소 확인해서 해당하는 토큰의 출력량 설정
        (uint amount0Out, uint amount1Out) = (0, 0); // 초기 값 할당
        if (tokenAddress == pair.token0()) {
            // token 주소를 반환
            amount0Out = inputAmount;
        } else if (tokenAddress == pair.token1()) {
            amoun1Out = inputAmount;
        } else {
            revert("Invalid token address");
        }

        // 예치량 가져와서 출력량 계산
        (uint112 reserve0, uint112 reserve1) = pair.getReserves();

        // 예상 출력량 계산
        uint outputAmount;
        if (amount0Out > 0) {
            outputAmount = getAmountOut(inputAmount, reserve0, reserve1);
        } else {
            outputAmount = getAmountOut(inputAmount, reserve1, reserve0);
        }

        // 사용자가 100개 원할 시 최소 99.5개는 되야 실행되게
        uint minAmountWithSlippage = (outputAmount * 995) / 1000;

        // 사용자가 받고 싶어하는 최소량보다 실제 출력량이 적으면 트랜잭션 되돌림
        // ex) input에 100개 넣고 minToken에 80개 넣으면 정상 실행
        require(
            minAmountWithSlippage >= minToken,
            "INSUFFICIENT_OUTPUT_AMOUNT"
        );

        if (tokenAddress == pair.token0()) {
            swap(userAddress, inputAmount, 0, pairAddress);
        }else {
            swap(userAddress, 0, inputAmount, pairAddress);
        }
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

    // output 값을 넣어서 input 값을 받고 싶을 때 == 지불하고 싶은 값이 0.5% 이상으로 올라가면 실행 안함
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

    function swap(address userAddress, uint amount0Out, uint amount1Out, address to) external lock {
        // output 이 둘 중에 하나는 0 보다 커야함
        require(amount0Out > 0 || amount1Out > 0, "INSUFFICIENT_OUTPUT_AMOUNT");

        (uint112 _reserve0, uint112 _reserve1, ) = pair.getReserves();
        require(
            amount0Out < _reserve0 && amount1Out < _reserve1,
            "INSUFFICIENT_LIQUIDITY"
        );

        uint balance0 = 0; 
        uint balance1 = 0;

        {
            address _token0 = pair.token0();
            address _token1 = pair.token1();
            require(to != _token0 && to != _token1, "INVALID_TO");
            if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); 
            if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out);
            // if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);

            // 현재 잔액
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
            // uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
            // uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
            require(
                SafeMath.mul(balance0Adjusted, balance1Adjusted) >=
                    SafeMath.mul(
                        SafeMath.mul(uint(_reserve0), _reserve1),
                        1000 ** 2
                    ),
                "UniswapV2: K"
            );
        }

        // unclaimed fee 누적시키기 ( 유동성 관련 lp ) - LP에 대한 부분 이야기하고 작성
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
        }

        pair._update(balance0, balance1, _reserve0, _reserve1);
        emit Swap(userAddress, amount0In, amount1In, amount0Out, amount1Out, pairAddress);

        // Volume 누적시키기
        volumePerTransaction0[block.timestamp] = amount0In;
        volumePerTransaction0[block.timestamp] += amount0Out;
        volumePerTransaction1[block.timestamp] = amount1In;
        volumePerTransaction1[block.timestamp] += amount1Out;

    // 토큰 당 totalVolume 계산
    function getTotalVolume(
        address tokenAddress,
        uint blockStampNow,
        uint blockStamp24hBefore
    ) public returns (uint) {
        require(
            tokenAddress == token0 || tokenAddress == token1,
            "Invalid token address"
        );
        uint totalVolume = 0;

        if (tokenAddress == token0) {
            for (uint i = blockStamp24hBefore; i <= blockStampNow; i++) {
                totalVolume += volumePerTransaction0[i];
            }
        } else {
            for (uint i = blockStamp24hBefore; i <= blockStampNow; i++) {
                totalVolume += volumePerTransaction1[i];
            }
        }

        return totalVolume;
    }
}
