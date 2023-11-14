// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Token.sol";

// LP 토큰
contract LPToken is Token{
    address private minter;

    constructor(address _minter, string memory _name, string memory _symbol, uint _amount, string memory _uri) Token(_name, _symbol, _amount, _uri) {
        minter = _minter;
    }

    function mint(address to, uint amount) public {
        require(msg.sender == minter, "not minter");
        _mint(to, amount);
    }

    function burn(address owner, uint amount) public {
        require(msg.sender == minter, "not minter");
        _burn(owner, amount);
    }
}