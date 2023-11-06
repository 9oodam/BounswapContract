// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import './Pair.sol';
import '../utils/Data.sol';

contract Factory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    // address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);


    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;

        // 토큰 4개 발행 (WBND, ETH, USDT, BNB)
        // WBNC wbnc = new WBNC('Wrapped Bounce Coin', 'WBNC', 10000, "");
		// Token eth = new Token('ethereum', 'ETH', 10000, "");
		// Token usdt = new Token('Tether', 'USDT', 10000, "");
		// Token bnb = new Token ('Binance Coin', 'BNB', 10000, "");

        // Data.allTokens.push(address(wbnc), address(eth), address(usdt), address(bnb));
    }

    // function allPairsLength() external view returns (uint) {
    //     return allPairs.length;
    // }

    function initialPlay(bytes[] memory) public returns () {
        // 1) 만약 2개 토큰 중 bnc가 포함이면 Wrapping.
    }

    // pair 처음 생성할 때 실행
    function createPairAddress(address tokenA, address tokenB) internal returns (address pair) {
        bytes memory bytecode = type(Pair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        // 초기화
        Pair(pair).initialize(token0, token1);

        // getPair, allPairs 에 새로 생긴 pairAddress 저장
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair;
        Data.allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);

        // 새로 생긴 pair 주소로 LP token CA 생성
        // 1) BNC/ETH - NoJam, NJM
        // 2) BNC/USDT - Steak, STK
        // 3) BNC/BNB - ImGovernance, IMG → Bonus, BNS
        new BounswapPair("name", "symbol", 0, "uri");

        /*
        if (!isExists) {
            CheckToken memory newPool = CheckToken(_token1, _token2);
            poolData[_contractAddress][poolIndex] = newPool;
            poolDataNum.push(poolIndex);
            poolIndex += 1;
            if (keccak256(bytes(_tokenName)) == keccak256(bytes("ARB"))) {
                ArbLpToken = new SelfToken("ARBLP", "LP");
                ArbLpaddress = address(ArbLpToken);
                // ARBtokenAddress = _token1;
            } else if (
                keccak256(bytes(_tokenName)) == keccak256(bytes("USDT"))
            ) {
                UsdtLpToken = new SelfToken("USDTLP", "LP");
                UsdtLpaddress = address(UsdtLpToken);
                // USDTtokenAddress = _token1;
            } else if (
                keccak256(bytes(_tokenName)) == keccak256(bytes("ETH"))
            ) {
                EthLpToken = new SelfToken("ETHLP", "LP");
                EthLpaddress = address(UsdtLpToken);
                // ETHtokenAddress = _token1;
            }
        }
        */

        return pair;
    }

    // 사용자가 New position 누르면 실행
    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'same token');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'zero address');

        // 처음 생성하는 경우
        if(getPair[token0][token1] == address(0)) {
            pair = createPairAddress(tokenA, tokenB);
        }else {
            pair = getPair[token0][token1];
        }  

        // lp token minting
        Pair(pair).mint(msg.sender);

        // 특정 유저의 Pool arr에 추가
        // 이미 있으면 중복 안되게, 삭제되면 pop
        bool isDuplicated = false;
        for(uint i=0; i<Data.validatorPoolArr[msg.sender].length; i++) {
            if(Data.validatorPoolArr[msg.sender][i] == pair) {
                isDuplicated == true;
                break;
            }
        }
        require(isDupulicated == false);
        Data.validatorPoolArr[msg.sender].push(pair);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}