// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Data {
    Pair pairParams;

    address[] public allPairs;
    address[] public allTokens;

    // 특정 공급자가 가지고 있는 모든 페어 배열
    mapping (address validator => address[] pairAddress) public validatorPoolArr;

    constructor() {
        pairParams = new Pair();
    }


    // 모든 페어 주소 배열
    function getAllPairAddress() public view returns (address[]) {
        return allPairs;
    }

    // All pool dash board 목록 반환
    function getAllPools(uint blockStampNow, uint blockStamp24hBefore) public returns (allPoolData[]) {
        for (uint i=0; i<allPairs.length; i++) {
            arr[i] = getEachPool(allPairs[i], blockStampNow, blockStamp24hBefore);
        }
        return arr;
    }

    // My pool dash board 목록 반환
    function getUserPools(uint blockStampNow, uint blockStamp24hBefore) public returns (allPoolData[]) {
        address[] userPool = validatorPoolArr[msg.sender];

        for (uint i=0; i<userPool.length; i++) {
            arr[i] = getEachPool(allPairs[i], blockStampNow, blockStamp24hBefore);
        }
        return arr;
    }

    // pool detail 정보
    function getEachPool(address pa, uint blockStampNow, uint blockStamp24hBefore) public returns (allPoolData) {
        // 24H tvl 계산
        // volume 계산
        return allPoolData(pa, pairParams[pa].getAllData(), tvl, volume);
    }

    // my pool detail page에서 보여줄 정보
    function getUserPoolDetail(address pa) public returns (Data[]) {
        return BounswapPair(pa).getUserLiquidity(msg.sender);
    }




    // 모든 토큰 주소 배열
    function getAllTokenAddress() public view returns (address[]) {
        return allTokens;
    }

    // 플랫폼 내 모든 토큰을 반환하는 함수
    function getAllTokens(uint blockStampNow, uint blockStamp24hBefore) public returns (TokenData[] memory) {
        for(uint i=0; i<allTokens.length; i++) {
            arr[i] = getEachToken(allTokens[i]);
        }
        return arr;
    }

    // 특정 토큰 정보 반환하는 함수
    function getEachToken(address tokenAddress, uint blockStampNow, uint blockStamp24hBefore) public returns (TokenData) {
        Token token = Token(tokenAddress);

        // volume 계산
        uint totalVolume = 0;
        for(uint i=0; i<allPairs.length; i++) {
            totalVolume += BounswapPair(allPairs[i]).getTotalVolume(tokenAddress, blockStampNow, blockStamp24hBefore);
        } 
        return TokenData(tokenAddress, token.name, token.symbol, token.uri,
            token.totalSupply, totalVolume);
    }

}