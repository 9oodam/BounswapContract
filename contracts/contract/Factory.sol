// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "hardhat/console.sol";

import "./Token.sol";
import "./Pool.sol";
import "../utils/Data.sol";

contract Factory {
    Data dataParams;
    // address private wbncAddress;

    address public feeTo;
    address private feeToSetter;

    mapping(address => mapping(address => address)) private getPair;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _dataAddress, address _feeToSetter) public {
        feeToSetter = _feeToSetter;
        dataParams = Data(_dataAddress);
    }

    function getPairAddress(address tokenA, address tokenB) public view returns (address) {
        return getPair[tokenA][tokenB];
    }

    function createPair(address tokenA, address tokenB) external returns (address) {
        require(tokenA != tokenB, 'same token');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'token is zero address');
        require(getPair[token0][token1] == address(0), 'pair already exists');
        console.log('available token address, create pair');

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
        
        address[] memory tokenAddressArr = dataParams.getAllTokenAddress();
        address wbncAddress = tokenAddressArr[0];
        Pool pairInstance = new Pool(wbncAddress, combinedName, combinedSymbol);
        address pairAddress = address(pairInstance);
        Pool(pairAddress).initialize(token0, token1);

        // getPair에 pair 주소 저장
        getPair[token0][token1] = pairAddress;
        getPair[token1][token0] = pairAddress;
        // Data.sol allPairs 배열에 추가
        dataParams.addPair(pairAddress);

        emit PairCreated(token0, token1, pairAddress, dataParams.allPairsLength());
        return pairAddress;
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