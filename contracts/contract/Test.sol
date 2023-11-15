// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "hardhat/console.sol";

contract Test {

    uint256 numForCheck = 10;

    constructor() {}

    function check(bytes[] memory data) public {
        console.log('in');
        for(uint i=0; i<data.length; i++) {
            (bool result, ) = address(this).call(data[i]);
        }
    }

    function checkcheck(uint num) public returns (bool) {
        console.log(num);
        numForCheck += num;
        return true;
    }

    function getNum() public view returns (uint256) {
        return numForCheck;
    }
}