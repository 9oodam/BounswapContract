// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contract/Pool.sol";
import "../contract/Token.sol";

contract Data {
    address[] public allPairs; // 모든 페어의 주소 배열
    address[] public allTokens; // 모든 토큰의 주소 배열

    // 특정 공급자가 가지고 있는 모든 페어 배열
    mapping (address validator => address[] pairAddress) public validatorPoolArr;
    struct PoolDetail {
        address pairAddress;
        address token0;
        address token1;
        string token0Uri;
        string token1Uri;
        string token0Symbol;
        string token1Symbol;
        uint256 tvl;
        uint balance;
    }
    struct TokenDetail {
        address tokenAddress;
        string name;
        string symbol;
        string uri;
        uint256 tvl;
        uint balance;
    }

    // blockTimeStamp로 blockNumber 찾기
    mapping (uint32 blockTimeStamp => uint32 blockNumber) public blockNumbers;

    // pool 예치해서 발생한 fee (미청구)
    mapping (address pairAddress => address[] validator) public validatorArr;
    mapping (address validator => mapping (address pairAddress => UnclaimedFeeData)) public userUnclaimedFee;
    struct UnclaimedFeeData {
        uint256 token0FeeAmount;
        uint256 token1FeeAmount;
    }

    constructor() {
    }

    // 확인 필요
    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function addPair(address pairAddress) external {
        allPairs.push(pairAddress);
    }

    // 확인 필요 임의로 추가함
    // validatorPoolArr 반환
    function getValidatorPoolArr(address to) public view returns (address[] memory) {
        return validatorPoolArr[to];
    }

    function validatorPoolArrLength(address validator) public view returns (uint256) {
        return validatorPoolArr[validator].length;
    }

    // validatorPoolArr 설정
    function addValidatorPoolArr(address to, address pool) public {
        validatorPoolArr[to].push(pool);
    }
    function subValidatorPoolArr(address to, address pool) public {
        uint lastIndex = validatorPoolArr[to].length - 1;
        for(uint i=0; i<validatorPoolArr[to].length; i++) {
            if(validatorPoolArr[to][i] == pool) {
                validatorPoolArr[to][i] = validatorPoolArr[to][lastIndex];
            }
        }
        validatorPoolArr[to].pop();
    }

    function getValidatorArr(address pairAddress) public view returns (address[] memory) {
        return validatorArr[pairAddress];
    }

    function validatorArrLength(address pairAdress) public view returns (uint256) {
        return validatorArr[pairAdress].length;
    }

    function addValidatorArr(address pair, address validator) public {
        validatorArr[pair].push(validator);
    }
    function subValidatorArr(address pair, address validator) public {
        uint lastIndex = validatorArr[pair].length - 1;
        for(uint i=0; i<validatorArr[pair].length; i++) {
            if(validatorArr[pair][i] == validator) {
                validatorArr[pair][i] = validatorArr[pair][lastIndex];
            }
        }
        validatorArr[pair].pop();
    }

    // 모든 페어 주소 배열 반환
    function getAllPairAddress() public view returns (address[] memory) {
        return allPairs;
    }

    // All pool dash board 목록 반환
    function getAllPools() public view returns (PoolDetail[] memory) {
        PoolDetail[] memory arr = new PoolDetail[](allPairs.length); 
        for (uint i=0; i<allPairs.length; i++) {
            arr[i] = getEachPool(allPairs[i], address(0));
        }
        return arr;
    }

    // My pool dash board 목록 반환
    function getUserPools(address userAddress) public view returns (PoolDetail[] memory) {
        address[] memory userPool = validatorPoolArr[userAddress];
        PoolDetail[] memory arr = new PoolDetail[](userPool.length);
        for (uint i=0; i<userPool.length; i++) {
            arr[i] = getEachPool(userPool[i], userAddress);
        }
        return arr;
    }

    // 각 pool detail 정보
    function getEachPool(address pairAddress, address userAddress) public view returns (PoolDetail memory) {
        Pool pool = Pool(pairAddress);
        Token token0 = Token(pool.token0());
        Token token1 = Token(pool.token1());
        (uint112 reserve0, uint112 reserve1,) = pool.getReserves();
        uint256 tvl = reserve0 + reserve1;

        if (userAddress == address(0)) {
            return PoolDetail(pairAddress, pool.token0(), pool.token1(), token0.uri(), token1.uri(), token0.symbol(), token1.symbol(), tvl, 0);
        } else {
            return PoolDetail(pairAddress, pool.token0(), pool.token1(), token0.uri(), token1.uri(), token0.symbol(), token1.symbol(), tvl, Pool(pairAddress).balanceOf(userAddress));
        }
    }

    // pool detail page에서 사용자가 아직 미청구한 수수료
    function getUnclaimedFee(address validator, address pairAddress) public view returns (uint256, uint256) {
        return (userUnclaimedFee[validator][pairAddress].token0FeeAmount, userUnclaimedFee[validator][pairAddress].token1FeeAmount);
    }
    
    // 확인 필요 userUnclaimedFee 초기화 
    function setUnclaimedFee(address validator, address pairAddress, uint256 amount0, uint256 amount1) public {
        userUnclaimedFee[validator][pairAddress] = UnclaimedFeeData(amount0, amount1);
    }

    // 모든 토큰 주소 배열
    function getAllTokenAddress() public view returns (address[] memory) {
        return allTokens;
    }
    function isGovPair(address tokenA, address tokenB, address to, uint amount, bool isMint) external {
        if(tokenA == allTokens[0] && tokenB == allTokens[4] || tokenB == allTokens[0] && tokenA == allTokens[4]) {
            if(isMint == true) {
                Token(allTokens[1])._mint(to, amount);
                console.log('gov token mint', amount);
            }else if(isMint == false) {
                uint govAmount = Token(allTokens[1]).balanceOf(to);
                if(amount > govAmount) Token(allTokens[1])._burn(to, govAmount);
                if(amount < govAmount) Token(allTokens[1])._burn(to, amount);
                console.log('gov token burn', amount);
            }
        }
    }

    // 사용자가 보유하고 있는 토큰 목록
    function getUserTokens(address validator) public view returns (TokenDetail[] memory) {
        TokenDetail[] memory arr = new TokenDetail[](allTokens.length);
        for(uint i=0; i<allTokens.length; i++) {
            arr[i] = getEachToken(allTokens[i], Token(allTokens[i]).balanceOf(validator));
        }
        return arr;
    }

    // 토큰 배열에 토큰 추가
    function addToken(address token) public {
        allTokens.push(token);
    }

    // 플랫폼 내 모든 토큰을 반환하는 함수
    function getAllTokens() public view returns (TokenDetail[] memory) {
        TokenDetail[] memory arr = new TokenDetail[](allTokens.length);
        for(uint i=0; i<allTokens.length; i++) {
            arr[i] = getEachToken(allTokens[i], 0);
        }
        return arr;
    }

    // 특정 토큰 정보 반환하는 함수
    function getEachToken(address tokenAddress, uint balance) public view returns (TokenDetail memory) {
        Token token = Token(tokenAddress);
        uint256 tvl = 0;
        for(uint i=0; i<allPairs.length; i++) {
            (uint112 reserve0, uint112 reserve1,) = Pool(allPairs[i]).getReserves();
            if(tokenAddress == Pool(allPairs[i]).token0()) {
                tvl += reserve0;
            }else if(tokenAddress == Pool(allPairs[i]).token1()) {
                tvl += reserve1;
            }
        }
        
        return TokenDetail(tokenAddress, token.name(), token.symbol(), token.uri(), tvl, balance);
    }

    // 24시간/7일 전부터 현재까지 발생한 Block number 반환
    function getBlockNumber(uint32 timeStampNow, uint32 timeStampBefore) public view returns (uint32[] memory) {
        uint32[] memory arr = new uint32[](timeStampNow - timeStampBefore);
        for(uint32 i=timeStampBefore; i<timeStampNow; i++) {
            if(blockNumbers[i] != 0) arr[i] = blockNumbers[i];
        }
        return arr;
    }
}