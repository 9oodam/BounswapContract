// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Test2 {

    uint256 ffff = 0;
    uint256 ssss = 10;

    function firstFunction(string memory str, uint256 num) public returns (uint256) {
        return ffff++;
    }

    function secondFunction(uint256 num) public returns (uint256) {
        return ssss++;
    }

    function getFirstValue() public view returns (uint256) {
        return ffff;
    }

    function getSecondValue() public view returns(uint256) {
        return ssss;
    }
}