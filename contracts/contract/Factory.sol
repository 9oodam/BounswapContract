// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";
import "./Pool.sol";
import "../utils/Data.sol";

contract Factory {
    Data dataParams;
    address private dataAddress;

    address public feeTo;
    address private feeToSetter;

    mapping(address => mapping(address => address)) private getPair;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _dataAddress, address _feeToSetter) public {
        feeToSetter = _feeToSetter;
        dataAddress = _dataAddress;
        dataParams = Data(_dataAddress);
    }

    function getPairAddress(address tokenA, address tokenB) public returns (address) {
        return getPair[tokenA][tokenB];
    }

    function createPair(address tokenA, address tokenB) external returns (bool) {
        require(tokenA != tokenB, 'same token');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'token is zero address');
        require(getPair[token0][token1] == address(0), 'pair already exists');

        // token0, 1로 새로운 pair 주소 생성 & create2로 contract 배포
        // bytes memory bytecode = type(Pool).creationCode;
        // bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        // assembly {
        //     pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        // }
        
        // 새로 생긴 pair 주소로 LP token CA 생성
        string memory nameA = Token(tokenA).name();
        string memory nameB = Token(tokenB).name();
        string memory symbolA = Token(tokenA).symbol();
        string memory symbolB = Token(tokenB).symbol();
        string memory combinedName = string(abi.encodePacked(nameA, "-", nameB));
        string memory combinedSymbol = string(abi.encodePacked(symbolA, symbolB));
        Pool pairInstance = new Pool(combinedName, combinedSymbol);
        address pairAddress = address(pairInstance);
        Pool(pairAddress).initialize(token0, token1);
        // Pool(pair).initialize(token0, token1, combinedName, combinedSymbol);

        // getPair에 pair 주소 저장
        getPair[token0][token1] = pairAddress;
        getPair[token1][token0] = pairAddress;
        // Data.sol allPairs 배열에 추가
        dataParams.addPair(pairAddress);

        emit PairCreated(token0, token1, pairAddress, dataParams.allPairsLength());
        return true;
    }

    // 공급자가 가지고 있는 pool 배열
    function setValidatorPoolArr(address tokenA, address tokenB) public returns(bool) {
        address pair = getPair[tokenA][tokenB];
        // 이미 있으면 중복 안되게, 삭제되면 pop
        bool isDuplicated = false;
        for(uint i=0; i<dataParams.validatorPoolArrLength(msg.sender); i++) {
            if(dataParams.getValidatorPoolArr(msg.sender)[i] == pair) {
                isDuplicated == true;
                break;
            }
        }
        require(isDuplicated == false);
        dataParams.addValidatorPoolArr(msg.sender, pair);
        return true;
    }

    // 확인 필요 
    // type(Pool).creationCode 부분 에러나서 작성
    function getCreationCode() public pure returns (bytes memory) {
        return type(Pool).creationCode;
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