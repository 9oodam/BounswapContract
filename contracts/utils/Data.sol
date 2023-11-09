// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Pool.sol";
import "./Token.sol";

contract Data {
    address[] public allPairs; // 모든 페어의 주소 배열
    address[] public allTokens; // 모든 토큰의 주소 배열

    // 특정 공급자가 가지고 있는 모든 페어 배열
    mapping (address validator => address[] pairAddress) public validatorPoolArr;
    struct PoolDetail {
        address pairAddress,
        string token0Uri,
        string token1Uri,
        string token0Symbol,
        string token1Symbol,
        uint256 tvl
    }
    struct MyPoolDetail {
        PoolDetail pooldetail,
        uint256 token0Amount,
        uint256 token1Amount
    }
    struct TokenDetail {
        address tokenAddress,
        string name,
        string symbol,
        string uri,
        uint256 tvl
    }


    // blockTimeStamp로 blockNumber 찾기
    mapping (uint32 blockTimeStamp => uint32 blockNumber) public blockNumbers;

    // pool 예치해서 발생한 fee (미청구)
    mapping (address validator => mapping (address pairAddress => UnclaimedFeeData)) public userUnclaimedFee;
    struct UnclaimedFeeData {
        uint256 token0FeeAmount;
        uint256 token1FeeAmount;
    }

    constructor() {}

    // 모든 페어 주소 배열 반환
    function getAllPairAddress() public view returns (address[]) {
        return allPairs;
    }

    // All pool dash board 목록 반환
    function getAllPools() public returns (PoolDetail[] memory) {
        for (uint i=0; i<allPairs.length; i++) {
            arr[i] = getEachPool(allPairs[i]);
        }
        return arr;
    }

    // My pool dash board 목록 반환
    function getUserPools() public returns (PoolDetail[] memory) {
        address[] userPool = validatorPoolArr[msg.sender];
        for (uint i=0; i<userPool.length; i++) {
            arr[i] = getEachPool(userPool[i]);
        }
        return arr;
    }

    // 각 pool detail 정보
    function getEachPool(address pairAddress) public returns (PoolDetail memory) {
        Pool pool = Pool(pairAddress);
        Token token0 = Token(pool.token0);
        Token token1 = Token(pool.token1);
        uint256 tvl = pool.reserve0 + pool.reserve1;
        return PoolDetail(pairAddress, token0.uri, token1.uri, token0.symbol, token1.symbol, tvl);
    }

    // my pool detail page에서 보여줄 정보
    function getUserPoolDetail(address pairAddress) public returns (MyPoolDetail memory) {
        return MyPoolDetail(getEachPool(pairAddress), Pool(pairAddress).getUserLiquidity(msg.sender));
    }

    // pool detail page에서 사용자가 아직 미청구한 수수료
    function getUnclaimedFee(address pairAddress) public returns (UnclaimedFeeData memory) {
        return userUnclaimedFee[msg.sender][pairAddress];
    }


    // 모든 토큰 주소 배열
    function getAllTokenAddress() public view returns (address[]) {
        return allTokens;
    }

    // 플랫폼 내 모든 토큰을 반환하는 함수
    function getAllTokens() public returns (TokenDetail[] memory) {
        for(uint i=0; i<allTokens.length; i++) {
            arr[i] = getEachToken(allTokens[i]);
        }
        return arr;
    }

    // 특정 토큰 정보 반환하는 함수
    function getEachToken(address tokenAddress) public returns (TokenDetail) {
        Token token = Token(tokenAddress);
        uint256 tvl = 0;
        for(uint i=0; i<allPairs.length; i++) {
            volume = (allPairs[i] == Pool(allPairs[i]).token0) ? reserve0 : reserve1;
            tvl += volume;
        }
        return TokenDetail(tokenAddress, token.name, token.symbol, token.uri, tvl);
    }

    // 24시간/7일 전부터 현재까지 발생한 Block number 반환
    function getBlockNumber(uint timeStampNow, uint timeStampBefore) public returns (uin32[]) {
        for(uint i=timeStampBefore; i<timeStampNow; i++) {
            if(blockNumbers[i] !== 0) arr[i] = blockNumbers[i];
        }
        return arr;
    }
}