// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Token.sol";

contract WBNC is Token {
    event Deposit(address indexed from, uint256 amount);

    event Withdrawal(address indexed to, uint256 amount);

    constructor(string memory _name, string memory _symbol, uint _amount, string memory _uri) Token(_name, _symbol, _amount, _uri) {
    }

    function deposit(address to, uint value) public payable virtual {
        _mint(to, value);

        emit Deposit(to, value);
    }

    function withdraw(address owner, uint256 amount, address to) public virtual {
        _burn(owner, amount);
        to.call{value: amount}(new bytes(0));

        emit Withdrawal(owner, amount);
    }
}