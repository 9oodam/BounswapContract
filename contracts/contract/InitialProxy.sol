// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Wrapping.sol";
import "./Factory.sol";
import "./Pair.sol";
import "./Swap.sol";
import "./Token.sol";

contract InitialProxy {

    // 인스턴스 담을 변수
    Wrapping wrappingParams;
    Factory factoryParams;
    Pool poolParams;
    Swap swapParams;

    address wbncAddress;

    // initialPlay를 실행하다가 중간에 reject되는지 체크하는 변수
    bool isSucceed = true;
    bool isSucceedPayable = true;

    constructor(address _wrappingAddress, address _factoryAddress, address _swapAddress, address _wbncAddress) {
        wrappingParams = new Wrapping(_wrappingAddress);
        factoryParams = new Factory(_factoryAddress);
        swapParams = new Swap(_swapAddress);
        poolParams = new Pool(); // 인스턴스만 생성하고 동적으로 address 넣어서 실행 예정

        wbncAddress = _wbncAddress;
    }

    // 최초 실행 함수
    // 매개변수로 받은 data를 반복문으로 돌면서 컨트랙트 내 함수 실행
    function initialPlay(bytes[] memory data) public returns (bool) {
        for (uint i = 0; i < data.length; i++) {
            require(isSucceed == true, "Function failed");
            bool result = address(this).call(data[i]);
            isSucceed = result; // 함수 순서대로 실행 중 실패하면
        }
        // if(isSucceed == false) {
        //     address(this).wrappingWithdrawal();
        // }
        return true;
    }

    // 최초 실행 함수 (payable)
    function initialPlayPayable(bytes[] memory data) public payable returns (bool) {
        for (uint i = 0; i < data.length; i++) {
            require(isSucceedPayable == true, "Function failed");
            bool result = address(this).call(data[i]);
            isSucceedPayable = result;
        }
        return true;
    }

    // Wrapping.sol
    // 사용자에게 bnc 받아서 wbnc 발행
    function wrappingDeposit(address userAddress, uint256 bncAmount) internal payable returns (bool) {
        bool result = wrappingParams.depositWBNC{value : bncAmount}(userAddress);
        return result;
    }
    // wbnc 소각 후 bnc 사용자에게 전송
    function wrappingWithdraw(address userAddress, address pairAddress) internal returns (bool) {
        bool result = wrappingParams.withdrawWBNC(userAddress, pairAddress);
    }

    // Factory.sol
    // Pair 생성
    function factoryCreatePair(address tokenA, address tokenB) internal returns (bool) {
        bool result = factoryParams.createPair(tokenA, tokenB);
        return result;
    }
    // 공급자가 가지고 있는 Pool 배열
    function factorySetValidator(address tokenA, address tokenB) internal returns (bool) {
        bool result = factoryParams.setValidatorPoolArr(tokenA, tokenB);
        return result;
    }

    // Pool.sol
    // add Liquidity & lp token 민팅
    function poolMint(address userAddress, address tokenA, address tokenB) internal returns (bool) {
        // getPair 로 pair address 얻고
        address pairAddress = factoryParams.getPair[tokenA][tokenB];
        // lp 토큰 민팅의 주체는 사용자
        bool result = poolParams(pairAddress).mint(userAddress);
        return result;
    }
    // remove Liquidity & lp token 소각
    function poolBurn(address userAddress, address pairAddress, uint percentage) internal returns (bool) {
        bool result = poolParams(pairAddress).burn(userAddress, percentage);
        return result;
    }
    // 수수료 청구
    function poolClaimFee(address userAddress, address pairAddress) internal returns (bool) {
        bool result = poolParams(pairAddress).claimFee(userAddress);
        return result;
    }

    // Swap.sol

    // 1) input 값을 지정해서 스왑
    // token -> token
    function swapExactTokensForTokens(address pairAddress, uint inputAmount, uint minToken, address inputToken, address outputToken, address userAddress) internal returns (bool result) {
        result = swapParams.exactTokensForTokens(pairAddress, inputAmount, minToken, [inputToken, outputToken], userAddress);
    }
    // token -> bnc
    function swapExactTokensForBNC(address pairAddress, uint inputAmount, uint minToken, address inputToken, address outputToken, address userAddress) internal returns (bool result) {
        result = swapParams.exactTokensForBNC(pairAddress, inputAmount, minToken, [inputToken, outputToken], userAddress);
    }
    // bnc -> token
    function swapExactBNCForTokens(address pairAddress, uint inputAmount, uint minToken, address inputToken, address outputToken, address userAddress) internal payable returns (bool result) {
        result = swapParams.exactBNCForTokens(pairAddress, inputAmount, minToken, [inputToken, outputToken], userAddress).value(inputAmount);
    }

    // 2) output 값을 지정해서 스왑
    // token -> token
    function swapTokensForExactTokens(address pairAddress, uint outputAmount, uint maxToken, address inputToken, address outputToken, address userAddress) internal returns (bool result) {
        result = swapParams.tokensForExactTokens(pairAddress, outputAmount, maxToken, [inputToken, outputToken], userAddress);
    }
    // token -> bnc
    function swapTokensForExactBNC(address pairAddress, uint outputAmount, uint maxToken, address inputToken, address outputToken, address userAddress) internal returns (bool result) {
        result = swapParams.tokensForExactBNC(pairAddress, outputAmount, maxToken, [inputToken, outputToken], userAddress);
    }
    // bnc -> tokdn
    function swapBNCForExactTokens(address pairAddress, uint outputAmount, uint maxToken, address inputToken, address outputToken, address userAddress) internal payable returns (bool result) {
        result = swapParams.bNCForExactTokens(pairAddress, outputAmount, maxToken, [inputToken, outputToken], userAddress).value(maxToken);
    }
}