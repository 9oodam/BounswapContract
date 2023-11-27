// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "hardhat/console.sol";

import "../contract/Factory.sol";
import "../contract/PoolConnector.sol";
import "../contract/Swap.sol";
import "../contract/Pool.sol";
import "../contract/Token.sol";

contract InitialProxy {

    // 인스턴스 담을 변수
    Factory factoryParams;
    PoolConnector poolConnectorParams;
    Swap swapParams;

    address wbncAddress;

    // initialPlay를 실행하다가 중간에 reject되는지 체크하는 변수
    // bool isSucceed = true;
    // bool isSucceedPayable = true;

    event Mint(
        address indexed sender, address pairAddress,
        address token0, address token1,
        uint amount0, uint amount1, uint liquidity,
        uint price0, uint price1, uint totalSupply,
        uint timestamp);
    event Burn(
        address indexed sender, address pairAddress,
        address token0, address token1,
        uint amount0, uint amount1,
        uint price0, uint price1, uint totalSupply,
        uint timestamp);
    // event Sync(uint112 reserve0, uint112 reserve1, uint price0CumulativeLast, uint price1CumulativeLast);
    event SwapAmount(
        address indexed sender, address pairAddress,
        address token0, address token1,
        uint amount0In, uint amount1In, uint amount0Out, uint amount1Out,
        uint timestamp
    );

    constructor(address _factoryAddress, address _poolConnectorAddress, address _swapAddress, address _wbncAddress) {
        factoryParams = Factory(_factoryAddress);
        poolConnectorParams = PoolConnector(_poolConnectorAddress);
        swapParams = Swap(_swapAddress);
        wbncAddress = _wbncAddress;
    }

    // 최초 실행 함수
    // 매개변수로 받은 data를 반복문으로 돌면서 컨트랙트 내 함수 실행
    // function initialPlay(bytes[] memory data) public returns (bool) {
    //     for (uint i = 0; i < data.length; i++) {
    //         // require(isSucceed == true, "Function failed");
    //         address(this).call(data[i]);
    //         // bool result = address(this).call(data[i]);
    //     }
    //     // if(isSucceed == false) {
    //     //     address(this).wrappingWithdrawal();
    //     // }
    //     // return isSucceed;
    // }

    // 최초 실행 함수 (payable)
    // function initialPlayPayable(bytes[] memory data) public payable returns (bool) {
    //     for (uint i = 0; i < data.length; i++) {
    //         require(isSucceedPayable == true, "Function failed");
    //         (bool result, ) = address(this).call(data[i]);
    //         // bool result = address(this).call(data[i]);
    //         isSucceedPayable = result;
    //     }
    //     return true;
    // }


    // Factory.sol
    // Pair 생성
    function factoryCreatePair(address tokenA, address tokenB) public {
        factoryParams.createPair(tokenA, tokenB);
    }
    // pairAddress 반환
    function factoryGetPairAddress(address tokenA, address tokenB) public view returns (address) {
        address pairAddress = factoryParams.getPairAddress(tokenA, tokenB);
        return pairAddress;
    }


    // PoolConnector.sol
    // 유동성 공급시 토큰 1:1 계산
    function poolGetPairAmount(address tokenA, address tokenB, uint tokenAamount) public view returns (uint) {
        uint tokenBamount = poolConnectorParams.getPairAmount(tokenA, tokenB, tokenAamount);
        return tokenBamount;
    }
    // 유동성 제거시 퍼센테이지 계산
    function poolGetRemoveAmount(address pairAddress, uint percentage, address to) public view returns (uint, uint) {
        (uint amount0, uint amount1) = poolConnectorParams.getRemoveAmount(pairAddress, percentage, to);
        return (amount0, amount1);
    }

    function poolAddLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired) public {
        (address pairAddress, uint amountA, uint amountB, uint liquidity) = poolConnectorParams.addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, msg.sender);
        (address token0, address token1, uint price0, uint price1, uint totalSupply) = Pool(pairAddress).getPriceTotalSupply();
        console.log('addLiquidity Succeed : ', amountA, amountB, liquidity);
        emit Mint(msg.sender, pairAddress, token0, token1, amountA, amountB, liquidity, price0, price1, totalSupply, block.timestamp);
    }
    function poolAddLiquidityBNC(address token, uint amountDesired) public payable {
        (address pairAddress, uint amountToken, uint amountBNC, uint liquidity) = poolConnectorParams.addLiquidityBNC{value: msg.value}(token, wbncAddress, amountDesired, msg.sender);
        (address token0, address token1, uint price0, uint price1, uint totalSupply) = Pool(pairAddress).getPriceTotalSupply();
        console.log('addLiquidity Succeed : ', amountToken, amountBNC, liquidity);
        console.log(price0, price1);
        emit Mint(msg.sender, pairAddress, token0, token1, amountToken, amountBNC, liquidity, price0, price1, totalSupply, block.timestamp);
    }
    function poolRemoveLiquidity(address tokenA, address tokenB, uint percentage) public {
        (address pairAddress, uint amount0, uint amount1) = poolConnectorParams.removeLiquidity(tokenA, tokenB, percentage, msg.sender);
        (address token0, address token1, uint price0, uint price1, uint totalSupply) = Pool(pairAddress).getPriceTotalSupply();
        console.log('removeLiquidity Succeed : ', amount0, amount1);
        emit Burn(msg.sender, pairAddress, token0, token1, amount0, amount1, price0, price1, totalSupply, block.timestamp);
    }
    function poolRemoveLiquidityBNC(address token, uint percentage) public {
        (address pairAddress, uint amount0, uint amount1) = poolConnectorParams.removeLiquidityBNC(token, wbncAddress, percentage, msg.sender);
        (address token0, address token1, uint price0, uint price1, uint totalSupply) = Pool(pairAddress).getPriceTotalSupply();
        console.log('removeLiquidity Succeed : ', amount0, amount1);
        emit Burn(msg.sender, pairAddress, token0, token1, amount0, amount1, price0, price1, totalSupply, block.timestamp);
    }

    // 유저가 공급 중인 예치량 반환
    function poolGetUserLiquidity(address pairAddress) public view returns (uint256, uint256) {
        (uint256 amount0, uint256 amount1) = poolConnectorParams.getUserLiquidity(msg.sender, pairAddress);
        return (amount0, amount1);
    }
    // 수수료 청구
    function poolClaimFee(address pairAddress) public {
        poolConnectorParams.claimFee(msg.sender, pairAddress);
    }



    // Swap.sol

    // getInputAmount / getOutputAmount 계산
    function swapGetAmountOut(address pairAddress, uint inputAmount, address inputToken, address outputToken) public view returns (uint) {
        address[2] memory path = [inputToken, outputToken];
        uint amountOut = swapParams.getAmountOut(pairAddress, inputAmount, path);
        return amountOut;
    }
    function swapGetAmountIn(address pairAddress, uint outputAmount, address inputToken, address outputToken) public view returns (uint) {
        address[2] memory path = [inputToken, outputToken];
        uint amountIn = swapParams.getAmountIn(pairAddress, outputAmount, path);
        return amountIn;
    }
    // ouputToken의 reserve 반환 (이 이하로만 교환 가능)
    function poolGetOutputReserve(address pairAddress, address outputToken) public view returns (uint112) {
        (uint112 reserve0, uint112 reserve1,) = Pool(pairAddress).getReserves();
        uint112 outputReserve = (Pool(pairAddress).token0() == outputToken) ? reserve0 : reserve1;
        return outputReserve;
    }

    // 1) input 값을 지정해서 스왑
    // token -> token
    function swapExactTokensForTokens(address pairAddress, uint inputAmount, uint minToken, address inputToken, address outputToken) public {
        address[2] memory path = [inputToken, outputToken];
        swapParams.exactTokensForTokens(pairAddress, inputAmount, minToken, path, msg.sender);
        (address token0, address token1, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out) = swapParams.getSwapAmount();
        emit SwapAmount(msg.sender, pairAddress, token0, token1, amount0In, amount1In, amount0Out, amount1Out, block.timestamp);
    }
    // token -> bnc
    function swapExactTokensForBNC(address pairAddress, uint inputAmount, uint minToken, address inputToken, address outputToken) public {
        address[2] memory path = [inputToken, outputToken];
        swapParams.exactTokensForBNC(pairAddress, inputAmount, minToken, path, msg.sender);
        (address token0, address token1, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out) = swapParams.getSwapAmount();
        emit SwapAmount(msg.sender, pairAddress, token0, token1, amount0In, amount1In, amount0Out, amount1Out, block.timestamp);
    }
    // bnc -> token
    function swapExactBNCForTokens(address pairAddress, uint minToken, address inputToken, address outputToken) public payable {
        address[2] memory path = [inputToken, outputToken];
        swapParams.exactBNCForTokens{value : msg.value}(pairAddress, minToken, path, msg.sender);
        (address token0, address token1, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out) = swapParams.getSwapAmount();
        emit SwapAmount(msg.sender, pairAddress, token0, token1, amount0In, amount1In, amount0Out, amount1Out, block.timestamp);
    }

    // 2) output 값을 지정해서 스왑 
    // token -> token
    function swapTokensForExactTokens(address pairAddress, uint outputAmount, uint maxToken, address inputToken, address outputToken) public {
        address[2] memory path = [inputToken, outputToken];
        swapParams.tokensForExactTokens(pairAddress, outputAmount, maxToken, path, msg.sender);
        (address token0, address token1, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out) = swapParams.getSwapAmount();
        emit SwapAmount(msg.sender, pairAddress, token0, token1, amount0In, amount1In, amount0Out, amount1Out, block.timestamp);
    }
    // token -> bnc
    function swapTokensForExactBNC(address pairAddress, uint outputAmount, uint maxToken, address inputToken, address outputToken) public {
        address[2] memory path = [inputToken, outputToken];
        swapParams.tokensForExactBNC(pairAddress, outputAmount, maxToken, path, msg.sender);
        (address token0, address token1, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out) = swapParams.getSwapAmount();
        emit SwapAmount(msg.sender, pairAddress, token0, token1, amount0In, amount1In, amount0Out, amount1Out, block.timestamp);
    }
    // bnc -> tokdn
    function swapBNCForExactTokens(address pairAddress, uint outputAmount, address inputToken, address outputToken) public payable {
        address[2] memory path = [inputToken, outputToken];
        swapParams.bNCForExactTokens{value : msg.value}(pairAddress, outputAmount, path, msg.sender);
        (address token0, address token1, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out) = swapParams.getSwapAmount();
        emit SwapAmount(msg.sender, pairAddress, token0, token1, amount0In, amount1In, amount0Out, amount1Out, block.timestamp);
    }
}