// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "hardhat/console.sol";

import "../contract/Factory.sol";
import "../contract/PoolConnector.sol";
import "../contract/Swap.sol";
import "../contract/Token.sol";

contract InitialProxy {

    // 인스턴스 담을 변수
    Factory factoryParams;
    PoolConnector poolConnectorParams;
    Swap swapParams;

    address wbncAddress;

    // initialPlay를 실행하다가 중간에 reject되는지 체크하는 변수
    bool isSucceed = true;
    bool isSucceedPayable = true;

    uint256 numForCheck = 10;

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
    // function factoryCreatePair(address tokenA, address tokenB) internal returns (bool) {
    //     console.log('1 : ', tokenA, tokenB);
    //     bool result = factoryParams.createPair(tokenA, tokenB);
    //     console.log('1 : ', result);
    //     return result;
    // }
    // // 공급자가 가지고 있는 Pool 배열
    // function factorySetValidator(address userAddress, address tokenA, address tokenB) public returns (bool) {
    //     console.log('2 : ', userAddress, tokenA, tokenB);
    //     bool result = factoryParams.setValidatorPoolArr(userAddress, tokenA, tokenB);
    //     console.log('2 : ', result);
    //     return result;
    // }

    // PoolConnector.sol
    function poolAddLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired) public {
        (uint amountA, uint amountB, uint liquidity) = poolConnectorParams.addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, msg.sender);
        console.log('addLiquidity Succeed : ', amountA, amountB, liquidity);
    }
    function poolAddLiquidityBNC(address token, uint amountDesired) public payable {
        (uint amountToken, uint amountBNC, uint liquidity) = poolConnectorParams.addLiquidityBNC{value: msg.value}(token, wbncAddress, amountDesired, msg.sender);
        console.log('addLiquidity Succeed : ', amountToken, amountBNC, liquidity);
    }
    function poolRemoveLiquidity(address tokenA, address tokenB, uint percentage) public {
        (uint amountA, uint amountB) = poolConnectorParams.removeLiquidity(tokenA, tokenB, percentage, msg.sender);
        console.log('removeLiquidity Succeed : ', amountA, amountB);
    }
    function poolRemoveLiquidityBNC(address token, uint percentage) public {
        (uint amountToken, uint amountBNC) = poolConnectorParams.removeLiquidityBNC(token, wbncAddress, percentage, msg.sender);
        console.log('removeLiquidity Succeed : ', amountToken, amountBNC);
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
    // 1) input 값을 지정해서 스왑
    // token -> token
    function swapExactTokensForTokens(address pairAddress, uint inputAmount, uint minToken, address inputToken, address outputToken, address userAddress) internal returns (bool result) {
        address[2] memory path = [inputToken, outputToken];
        result = swapParams.exactTokensForTokens(pairAddress, inputAmount, minToken, path, userAddress);
    }
    // token -> bnc
    function swapExactTokensForBNC(address pairAddress, uint inputAmount, uint minToken, address inputToken, address outputToken, address userAddress) internal returns (bool result) {
        address[2] memory path = [inputToken, outputToken];
        result = swapParams.exactTokensForBNC(pairAddress, inputAmount, minToken, path, userAddress);
    }
    // bnc -> token
    function swapExactBNCForTokens(address pairAddress, uint inputAmount, uint minToken, address inputToken, address outputToken, address userAddress) public payable returns (bool result) {
        address[2] memory path = [inputToken, outputToken];
        // 확인 필요
        swapParams.exactBNCForTokens{value : inputAmount}(pairAddress, inputAmount, minToken, path, userAddress);
        // swapParams.exactBNCForTokens(pairAddress, inputAmount, minToken, path, userAddress).value(inputAmount);
    }

    // 2) output 값을 지정해서 스왑 
    // token -> token
    function swapTokensForExactTokens(address pairAddress, uint outputAmount, uint maxToken, address inputToken, address outputToken, address userAddress) internal returns (bool result) {
        address[2] memory path = [inputToken, outputToken];
        result = swapParams.tokensForExactTokens(pairAddress, outputAmount, maxToken, path, userAddress);
    }
    // token -> bnc
    function swapTokensForExactBNC(address pairAddress, uint outputAmount, uint maxToken, address inputToken, address outputToken, address userAddress) internal returns (bool result) {
        address[2] memory path = [inputToken, outputToken];
        result = swapParams.tokensForExactBNC(pairAddress, outputAmount, maxToken, path, userAddress);
    }
    // bnc -> tokdn
    function swapBNCForExactTokens(address pairAddress, uint outputAmount, uint maxToken, address inputToken, address outputToken, address userAddress) public payable returns (bool result) {
        address[2] memory path = [inputToken, outputToken];
        result = swapParams.bNCForExactTokens{value : maxToken}(pairAddress, outputAmount, path, userAddress);
        // result = swapParams.bNCForExactTokens(pairAddress, outputAmount, maxToken, path, userAddress).value(maxToken);
    }
}