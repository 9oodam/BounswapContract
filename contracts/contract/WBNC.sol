// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;
pragma solidity ^0.8.19;

import "./Token.sol";

contract WBNC is Token {
    event Deposit(address indexed from, uint256 amount);

    event Withdrawal(address indexed to, uint256 amount);

    constructor(string memory _name, string memory _symbol, string memory _uri) Token(_name, _symbol, 0, _uri) {
    }

    function deposit(uint value) public payable virtual {
        _mint(msg.sender, value);

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public virtual {
        _burn(msg.sender, amount);

        emit Withdrawal(msg.sender, amount);
    }
}