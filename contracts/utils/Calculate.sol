// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Calculate {
    // input 넣었을 때 output 계산하는 함수
    function calOutputAmount(address pairAddress, uint inputAmount, uint inputReserve, uint outputReserve) public view returns (uint outputAmount) {
        address token0 = Pair(pairAddress).token0;
        address token1 = Pair(pairAddress).token1;
        uint (reserve0, reserve1) = Pair(pairAddress).getReserve();

        (uint inputReserve, uint outputReserve) = (inputToken == token0) ? (reserve0, reserve1) : (reserve1, reserve0);

        uint outputAmountWithFee = (inputAmount * outputReserve) / (inputAmount + inputReserve);
        return (outputAmountWithFee * 997) / 1000; // 0.3% 제외
    }
    // output 넣었을 때 input 계산하는 함수
    function calInputAmount(uint outputAmount, uint inputReserve, uint outputReserve) public view returns (uint inputAmount) {
        uint inputAmountWithoutFee = (inputReserve * outputAmount) / (outputReserve - outputAmount);
        return (inputAmountWithoutFee * 1000) / 997; // 3% 포함
    }

}