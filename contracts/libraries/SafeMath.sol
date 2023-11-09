// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint) {
    // function add(uint x, uint y) internal pure returns (uint z) {
        uint z = x + y;
        require((z = x + y) >= x, 'ds-math-add-overflow');
        return z;
    }

    // function sub(uint x, uint y) internal pure returns (uint z) {
    function sub(uint x, uint y) internal pure returns (uint) {
        uint z = x - y;
        require((z = x - y) <= x, 'ds-math-sub-underflow');
        return z;
    }

    // function mul(uint x, uint y) internal pure returns (uint z) {
    function mul(uint x, uint y) internal pure returns (uint) {
        uint z = x * y;
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
        return z;
    }
}