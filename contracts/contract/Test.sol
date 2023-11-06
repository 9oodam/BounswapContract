// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Test2.sol";

contract Test {

    address test2Address;
    Test2 test2Params;

    constructor(address _test2Address) {
        test2Address = _test2Address;
        test2Params = new Test2();
    }

    function initialPlay(bytes[] memory data) public payble {
        for (uint i = 0; i < data.length; i++) {
            address(this).call(data[i]);
        }
    }


    function test2PlayFirst(bytes memory parameters) public returns (uint256) {
        (string memory str, uint256 num) = abi.decode(parameters, (string, uint256));
        uint256 result = Test2(test2Address).firstFunction(str, num);
        return result;
    }

    function test2PlaySecond(uint256 num) public returns (uint256) {
        uint256 result = Test2(test2Address).secondFunction(num);
        return result;
    }
}