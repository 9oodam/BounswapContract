// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Factory.sol";

contract InitialProxy {

    Factory factoryParams;
    Pool poolParams;
    Swap swapParams;

    constructor(address _factoryAddress, address _swapAddress) {
        factoryParams = new Factory(_factoryAddress);
        swapParams = new Swap(_swapAddress);
        poolParams = new Pool();
    }

    function initialPlay(bytes[] memory data, address pairAddress) public payable {
        for (uint i = 0; i < data.length; i++) {
            address(this).call(data[i]);
        }
    }


    function playFirst(bytes memory parameters) public returns (uint256) {
        (address pairAddress, string memory str, uint256 num) = abi.decode(parameters, (address, string, uint256));
        uint256 result = Pool(pairAddress).addLiquidity(str, num);
        return result;
    }
}