// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import './Token.sol';

contract WBNC is Token {
    event Deposit(address indexed from, uint256 amount);

    event Withdrawal(address indexed to, uint256 amount);

    constructor(string memory _name, string memory _symbol, string memory _uri) Token(_name, _symbol, 0, _uri) {
    }

    function deposit(uint value, address pairAddress) public virtual {
        _mint(address(this), value);
        address(this).transfer(pairAddress, value);

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(address pairAddress, uint256 amount) public virtual {
        pairAddress.transfer(address(this), bncAmount);
        _burn(address(this), amount);

        emit Withdrawal(msg.sender, amount);
    }
}