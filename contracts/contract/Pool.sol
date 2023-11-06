// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Pool {
    // 총 발생한 fee
    mapping (address validator => UnclaimedFeeData) userlUnclaimedFees;

    struct UnclaimedFeeData {
        uint token0FeeAmount;
        uint token1FeeAmount;
    }

    // pool detail page에서 사용자가 아직 미청구한 수수료
    function getUnclaimedFee() public returns (UnclaimedFeeData memory) {
        return userlUnclaimedFees[msg.sender];
    }

    // 미청구 수수료 청구하는 함수
    function claimFee() public returns (bool) {
        Token(token0).transfer(msg.sender, userlUnclaimedFees[msg.sender].token0Amount);
        Token(token1).transfer(msg.sender, userlUnclaimedFees[msg.sender].token1Amount);
        userlUnclaimedFees[msg.sender].token0Amount = 0;
        userlUnclaimedFees[msg.sender].token1Amount = 0;
        return true;
    }
    
    // 유저가 해당 풀에 공급중인 예치량 계산해서 반환
    function getUserLiquidity(address validator) public view returns (Data memory) {
        // lptoken 개수로 token0, token1 예치량 역계산

        return ();
    }
}