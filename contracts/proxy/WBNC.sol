// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WBNC {
    event Deposit(address indexed from, uint256 amount);

    event Withdrawal(address indexed to, uint256 amount);

    function deposit(uint value) public virtual {
        _mint(msg.sender, value);

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public virtual {
        _burn(msg.sender, amount);

        emit Withdrawal(msg.sender, amount);
    }
}

// front swap 버튼 누름
// WBNC contract로 bnc를 보내요
// receive() -> 


// 사용자가 swap을 누름 -> 사용자의 bnc가 이 컨트랙트로 들어옴 -> receive() 실행 -> min/max Token 계산함수
// -> 통과되면 -> swap()
// -> 통과 안되면 -> bnc 반환

// 사용자가 swap을 누름 -> min/max Token 계산함수
// -> 통과되면 -> bnc 반환
// -> 통과 안되면 -> 토큰 반환