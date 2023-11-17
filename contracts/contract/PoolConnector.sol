// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "hardhat/console.sol";

import "../routers/Data.sol";
import "./Factory.sol";
import "./Pool.sol";

contract PoolConnector {

    Data dataParams;
    Factory factoryParams;

    constructor(address _dataAddress, address _factoryAddress) {
        factoryParams = Factory(_factoryAddress);
        dataParams = Data(_dataAddress);
    }

    function _addLiquidity(
        address pairAddress,
        address tokenA, address tokenB,
        uint amountADesired, uint amountBDesired
    ) internal view returns (uint amountA, uint amountB) {
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        (uint112 reserve0, uint112 reserve1, ) = Pool(pairAddress).getReserves();
        (uint reserveA, uint reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            uint amountBOptimal = SafeMath.mul(amountADesired, reserveB) / reserveA;
            if (amountBOptimal <= amountBDesired) {
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                // uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
                uint amountAOptimal = SafeMath.mul(amountBDesired, reserveA) / reserveB;
                assert(amountAOptimal <= amountADesired);
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
    }

    // token-token
    function addLiquidity(
        address tokenA, address tokenB,
        uint amountADesired, uint amountBDesired,
        address to
    ) public returns (uint amountA, uint amountB, uint liquidity) {
        address pairAddress = factoryParams.getPairAddress(tokenA, tokenB);
        (amountA, amountB) = _addLiquidity(pairAddress, tokenA, tokenB, amountADesired, amountBDesired);
        Token(tokenA).transferFromTo(to, pairAddress, amountA);
        Token(tokenB).transferFromTo(to, pairAddress, amountB);
        liquidity = Pool(pairAddress).mint(to);
        setValidatorPoolArr(pairAddress, to);
    }
    function removeLiquidity(
        address tokenA, address tokenB,
        uint percentage,
        address to
    ) public returns (uint amountA, uint amountB) {
        address pairAddress = factoryParams.getPairAddress(tokenA, tokenB);
        uint removeAmount = Pool(pairAddress).balanceOf(to) * percentage; // 유저가 가지고 있는 수량에서 몇퍼센트 제거할건지
        Pool(pairAddress).transferFromTo(to, pairAddress, removeAmount);
        (uint amount0, uint amount1) = Pool(pairAddress).burn(to, percentage);
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
    }

    // bnc-token
    function addLiquidityBNC(
        address token, address wbnc,
        uint amountTokenDesired,
        address to
    ) public payable returns (uint amountToken, uint amountBNC, uint liquidity) {
        address pairAddress = factoryParams.getPairAddress(token, wbnc);
        (amountToken, amountBNC) = _addLiquidity(
            pairAddress,
            token, wbnc,
            amountTokenDesired, msg.value
        );
        Token(token).transferFromTo(to, pairAddress, amountToken);
        WBNC(wbnc).deposit{value: amountBNC}(pairAddress, amountBNC);
        liquidity = Pool(pairAddress).mint(to);
        if (msg.value > amountBNC) to.call{value: msg.value - amountBNC}("");
        setValidatorPoolArr(pairAddress, to);
    }
    function removeLiquidityBNC(
        address token, address wbnc,
        uint percentage,
        address to
    ) public returns (uint amountToken, uint amountBNC) {
        address pairAddress = factoryParams.getPairAddress(token, wbnc);
        (amountToken, amountBNC) = removeLiquidity(
            token, wbnc,
            percentage,
            to
        );
        Token(token).transferFromTo(pairAddress, to, amountToken);
        WBNC(wbnc).withdraw(pairAddress, amountBNC);
        to.call{value: amountBNC}("");
    }

    // 유저가 해당 풀에 공급중인 예치량 계산해서 반환
    function getUserLiquidity(address validator, address pairAddress) public view returns (uint256, uint256) {
        // lptoken 개수로 token0, token1 예치량 역계산
        uint256 lpTokenAmount = Pool(pairAddress).balanceOf(validator);
        (uint112 reserve0, uint112 reserve1, ) = Pool(pairAddress).getReserves();
        uint256 amount0 = SafeMath.mul(lpTokenAmount, reserve0) / Pool(pairAddress).totalSupply(); 
        uint256 amount1 = SafeMath.mul(lpTokenAmount, reserve1) / Pool(pairAddress).totalSupply(); 
        return (amount0, amount1);
    }

    // 미청구 수수료 청구하는 함수
    function claimFee(address validator, address pairAddress) public returns (bool) {
        (uint256 token0FeeAmount, uint256 token1FeeAmount) = dataParams.getUnclaimedFee(validator, pairAddress);
        address token0 = Pool(pairAddress).token0();
        address token1 = Pool(pairAddress).token1();
        // 누적된 미청구 수수료가 0 이상 있어야 함
        require(token0FeeAmount > 0 || token1FeeAmount > 0, "No fees to claim");
        Token(token0).transferFromTo(pairAddress, validator, token0FeeAmount);
        Token(token1).transferFromTo(pairAddress, validator, token1FeeAmount);
        dataParams.setUnclaimedFee(validator, pairAddress, 0, 0);
        return true;
    }

    // 공급자가 가지고 있는 pool 배열
    function setValidatorPoolArr(address pairAddress, address userAddress) internal {
        // 이미 있으면 중복 안되게, 삭제되면 pop
        bool isDuplicated = false;
        for(uint i=0; i<dataParams.validatorPoolArrLength(userAddress); i++) {
            if(dataParams.getValidatorPoolArr(userAddress)[i] == pairAddress) {
                isDuplicated == true;
                break;
            }
        }
        require(isDuplicated == false);
        dataParams.addValidatorPoolArr(userAddress, pairAddress);
        dataParams.addValidatorArr(pairAddress, userAddress);
    }
}