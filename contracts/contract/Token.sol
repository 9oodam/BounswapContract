// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IERC20.sol";

abstract contract Token is IERC20 {

    string public name;
    string public symbol;
    string public uri;

    uint internal decimals = 18;
    uint public totalSupply;

    mapping (address => uint) public balances;
    mapping (address => mapping (address => uint)) public allowances;

    constructor(string memory _name, string memory _symbol, string memory _uri, uint _amount) {
        name = _name;
        symbol = _symbol;
        uri = tokenURI(_uri);

        _mint(msg.sender, _amount * (10 ** decimals));
    }

    // 토큰 발행
    function _mint(address to, uint amount) public {
        balances[to] += amount;
        totalSupply += amount;
    }

    // 토큰 소각
    function _burn(address owner, uint amount) public {
        balances[owner] -= amount;
        totalSupply -= amount;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }


    // 토큰 이전
    function transfer(address to, uint amount) public returns (bool) {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        return true;
    }

    // 토큰 위임
    function approve(address spender, uint amount) public returns (bool) {
        allowances[msg.sender][spender] = amount;
        return true;
    }


    // 위임 받은 토큰을 전송
    function transferFrom(address from, address to, uint value) public returns (bool) {
        require(allowances[from][msg.sender] >= value);
        allowances[from][msg.sender] -= value;
        balances[from] -= value;
        balances[to] += value;
        return true;
    }


    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }


    function tokenURI(string memory _imageUri) public pure returns (string memory) {
        return string.concat(_baseURI(), _imageUri);
    }
    function _baseURI() internal pure returns (string memory) {
        return "https://crimson-generous-ant-395.mypinata.cloud/ipfs/";
    }
}