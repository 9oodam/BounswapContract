// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../interfaces/IERC20.sol";

contract Token is IERC20 {

    string public name;
    string public symbol;
    string public uri;

    uint internal decimals = 18;
    uint public totalSupply;

    mapping (address => uint) public balances;
    mapping (address => mapping (address => uint)) public allowances;

    constructor(string memory _name, string memory _symbol,  uint _amount, string memory _uri) {
        name = _name;
        symbol = _symbol;
        uri = tokenURI(_uri);

        address deployer = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

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
    function transferFromTo(address from, address to, uint amount) public returns (bool) {
        balances[from] -= amount;
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
        // require(allowances[from][msg.sender] >= value);
        // allowances[from][msg.sender] -= value;
        balances[from] -= value;
        balances[to] += value;
        return true;
    }

    // function transferFrom(address from, address from1, address to, uint value) public returns (bool) {
    //     require(allowances[from][msg.sender] >= value);
    //     allowances[from][msg.sender] -= value;
    //     balances[from] -= value;
    //     balances[to] += value;
    //     return true;
    // }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }


    function tokenURI(string memory _imageUri) public pure returns (string memory) {
        return string.concat(_baseURI(), _imageUri);
    }
    function _baseURI() internal pure returns (string memory) {
        return "https://apricot-wrong-platypus-336.mypinata.cloud/ipfs/Qmeov8cQBLhbtVP9WxbjW1TyePQWcTxQbvAWsmbrS82JJs/";
    }
}