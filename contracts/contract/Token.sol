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

    constructor(string memory _name, string memory _symbol, string memory _uri, uint _amount) {
        name = _name;
        symbol = _symbol;
        uri = tokenURI(_uri);

        _mint(_amount * (10 ** decimals));
    }

    // 토큰 발행
    function _mint(uint amount) internal {
        balances[msg.sender] += amount;
        totalSupply += amount;
    }


    function tokenURI(string memory _imageUri) public view returns (string memory) {
        return string.concat(_baseURI(), _imageUri);
    }
    function _baseURI() internal view returns (string memory) {
        return "https://crimson-generous-ant-395.mypinata.cloud/ipfs/";
    }
}