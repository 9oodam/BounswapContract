// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WBNC.sol"; // Wrapped BNC 스마트 계약

contract Wrapping {
    address public owner; // initialProxy contract
    WBNC public wbncContract;

    constructor(address _wbncContract) {
        owner = msg.sender;
        wbncContract = WBNC(_wbncContract);
    }

    // 사용자가 지불한 BNC를 WBNC contract로 전송하고 민팅한 WBNC를 Pair에 transfer
    function depositWBNC(address userAddress) public payable returns (bool) {
        uint256 bncAmount = msg.value;
        wbncContract.deposit{value: bncAmount}(userAddress);
        return true;
    }

    // WBNC를 반납하고 BNC를 받음
    function withdrawWBNC(address userAddress, uint256 wbncAmount) public payable returns (bool) {
        require(msg.sender == owner, "Only owner can withdraw");
        wbncContract.withdraw(userAddress, wbncAmount);
        payable(userAddress).transfer(wbncAmount);
        return true;
    }
}
