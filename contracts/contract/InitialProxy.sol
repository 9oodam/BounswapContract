// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "hardhat/console.sol";

import "./Wrapping.sol";
import "./Factory.sol";
import "./Pool.sol";
import "./Swap.sol";
import "./Token.sol";

contract InitialProxy {

    // 인스턴스 담을 변수
    // Wrapping wrappingParams;
    Factory factoryParams;
    Swap swapParams;

    address wbncAddress;

    // initialPlay를 실행하다가 중간에 reject되는지 체크하는 변수
    bool isSucceed = true;
    bool isSucceedPayable = true;

    uint256 numForCheck = 10;

    // constructor(address _wrappingAddress, address _factoryAddress, address _swapAddress, address _wbncAddress) {
    constructor(address _factoryAddress, address _swapAddress, address _wbncAddress) {
        // wrappingParams = Wrapping(_wrappingAddress);
        factoryParams = Factory(_factoryAddress);
        swapParams = Swap(_swapAddress);

        wbncAddress = _wbncAddress;
    }

    function check(bytes[] memory data) public returns (bool) {
        for(uint i=0; i<data.length; i++) {
            console.log('check start : ', i);
            (bool result, ) = address(this).call(data[i]);
        }
    }

    function checkcheck(uint num) public returns (bool) {
        console.log('num : ', num);
        numForCheck++;
        return true;
    }

    function getNum() public view returns (uint256) {
        console.log(numForCheck);
        return numForCheck;
    }

    // 최초 실행 함수
    // 매개변수로 받은 data를 반복문으로 돌면서 컨트랙트 내 함수 실행
    function initialPlay(bytes[] memory data) public returns (bool) {
        console.log('in');
        for (uint i = 0; i < data.length; i++) {
            console.log(i);
            // require(isSucceed == true, "Function failed");
            address(this).call(data[i]);
            // bool result = address(this).call(data[i]);
        }
        // if(isSucceed == false) {
        //     address(this).wrappingWithdrawal();
        // }
        // return isSucceed;
    }

    // 최초 실행 함수 (payable)
    function initialPlayPayable(bytes[] memory data) public payable returns (bool) {
        for (uint i = 0; i < data.length; i++) {
            require(isSucceedPayable == true, "Function failed");
            (bool result, ) = address(this).call(data[i]);
            // bool result = address(this).call(data[i]);
            isSucceedPayable = result;
        }
        return true;
    }

    // Wrapping.sol
    // 사용자에게 bnc 받아서 wbnc 발행
    // function wrappingDeposit(address userAddress, uint256 bncAmount) public payable returns (bool) {
    //     bool result = wrappingParams.depositWBNC{value : bncAmount}(userAddress);
    //     return result;
    // }
    // // wbnc 소각 후 bnc 사용자에게 전송
    // function wrappingWithdraw(address userAddress, address pairAddress) internal returns (bool) {
    //     bool result = wrappingParams.withdrawWBNC(userAddress, pairAddress);
    // }

    // Factory.sol
    // Pair 생성
    function factoryCreatePair(address tokenA, address tokenB) public returns (bool) {
        console.log(tokenA, tokenB);
        bool result = factoryParams.createPair(tokenA, tokenB);
        console.log(result);
        return result;
    }
    // 공급자가 가지고 있는 Pool 배열
    function factorySetValidator(address userAddress, address tokenA, address tokenB) public returns (bool) {
        bool result = factoryParams.setValidatorPoolArr(userAddress, tokenA, tokenB);
        return result;
    }

    // Pool.sol
    // add Liquidity & lp token 민팅
    function poolMint(address userAddress, address tokenA, address tokenB) public returns (bool) {
        // getPair 로 pair address 얻고
        address pairAddress = factoryParams.getPairAddress(tokenA, tokenB);

        // lp 토큰 민팅의 주체는 사용자
        bool result = Pool(pairAddress).mint(userAddress);
        return result;
    }
    // remove Liquidity & lp token 소각
    function poolBurn(address userAddress, address pairAddress, uint percentage) internal returns (bool) {
        bool result = Pool(pairAddress).burn(userAddress, percentage);
        return result;
    }
    // 수수료 청구
    function poolClaimFee(address userAddress, address pairAddress) internal returns (bool) {
        bool result = Pool(pairAddress).claimFee(userAddress);
        return result;
    }

    // Swap.sol

    // 사용자가 컨트랙트한테 권한 위임하는 부분
    // 거래 전에 권한을 위임하시겠습니까? 그 부분

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