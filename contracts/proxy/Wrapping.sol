// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC20.sol"; // ERC20 인터페이스
import "./WBNC.sol"; // Wrapped BNC 스마트 계약

contract Wrapping is IERC20 {
    address public owner;
    WBNC public wbncContract;

    constructor(address _wbncContract) {
        owner = msg.sender;
        wbncContract = WBNC(_wbncContract);
    }

    // receive() external payable {
    //     uint256 bncAmount = msg.value;
    //     wbncContract.deposit{value: bncAmount}();
    //     wbncContract.transfer(msg.sender, bncAmount);
    // }

    // 사용자가 지불한 BNC를 WBNC contract로 전송하고 민팅한 WBNC를 Pair에 transfer
    function depositWBNC(address pairAddress) public {
        uint256 bncAmount = msg.value;
        wbncContract.deposit{value: bncAmount}();
        address(this).transfer(pairAddress, bncAmount);
    }

    // WBNC를 반납하고 BNC를 받음
    function withdrawWBNC(uint256 wbncAmount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        wbncContract.withdraw(wbncAmount);
        payable(owner).transfer(wbncAmount);
    }
}
