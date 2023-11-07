// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Wrapping.sol";
import "./Factory.sol";
import "./Pair.sol";
import "./Swap.sol";

contract InitialProxy {

    // 인스턴스 담을 변수
    Wrapping wrappingParams;
    Factory factoryParams;
    Pool poolParams;
    Swap swapParams;

    // initialPlay를 실행하다가 중간에 reject되는지 체크하는 변수
    bool isSucceed = true;

    constructor(address _wrappingAddress, address _factoryAddress, address _swapAddress) {
        wrappingParams = new Wrapping(_wrappingAddress);
        factoryParams = new Factory(_factoryAddress);
        swapParams = new Swap(_swapAddress);
        poolParams = new Pool(); // 인스턴스만 생성하고 동적으로 address 넣어서 실행 예정
    }

    // 초기 실행 함수
    // 매개변수로 받은 data를 반복문으로 돌면서 컨트랙트 내 함수 실행
    function initialPlay(bytes[] memory data, address pairAddress) public payable returns (bool) {
        for (uint i = 0; i < data.length; i++) {
            require(isSucceed == true, "Function failed");
            bool result = address(this).call(data[i]);
            isSucceed = result; // 함수 순서대로 실행 중 실패하면
        }
        if(isSucceed == false) {
            address(this).wrappingWithdrawal();
        }
        return true;
    }

    // 예시
    // function playFirst(bytes memory parameters) public returns (uint256) {
    //     (address pairAddress, string memory str, uint256 num) = abi.decode(parameters, (address, string, uint256));
    //     uint256 result = Pool(pairAddress).addLiquidity(str, num);
    //     return result;
    // }

    // Wrapping.sol
    function wrappingDeposit(address pairAddress, uint256 bncAmount) internal payable returns (bool) {
        bool result = wrappingParams.depositWBNC{value : bncAmount}(pairAddress);
        return result;
    }
    function wrappingWithdraw(address userAddress, address pairAddress, uint256 wbncAmount) internal returns (bool) {
        bool result = wrappingParams.withdrawWBNC(userAddress, pairAddress, wbncAmount);
    }

    // Factory.sol
    function factoryCreatePair(address tokenA, address tokenB) internal returns (bool) {
        bool result = factoryParams.createPair(tokenA, tokenB);
        return result;
    }

    // Pool.sol
    function poolMint(address tokenA, address tokenB) public returns (bool) {
        // getPair 로 pair address 얻고
        // 해당 페어에 콜
        // lp 토큰 민팅의 주체는 사용자
    }
}