// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";

contract Pool is Token {
    // 총 발생한 fee
    mapping (address validator => UnclaimedFeeData) userUnclaimedFee;

    constructor() {
        factory = msg.sender;
    }

    struct UnclaimedFeeData {
        uint256 token0FeeAmount;
        uint256 token1FeeAmount;
    }

    // Factory에서 createPair 실행되면 초기 Pool 생성되는 경우 실행
    function initialize(address _token0, address _token1, string memory _name, string memory _symbol) external {
        require(msg.sender == factory);
        token0 = _token0;
        token1 = _token1;
        name = _name;
        symbol = _symbol;
    }

    // function setValidatorPoolArr() internal {
    //     // 이미 있으면 중복 안되게, 삭제되면 pop
    //     bool isDuplicated = false;
    //     for(uint i=0; i<dataParams.validatorPoolArr[msg.sender].length; i++) {
    //         if(dataParams.validatorPoolArr[msg.sender][i] == pair) {
    //             isDuplicated == true;
    //             break;
    //         }
    //     }
    //     require(isDupulicated == false);
    //     dataParams.validatorPoolArr[msg.sender].push(pair);
    // }

    // pool detail page에서 사용자가 아직 미청구한 수수료
    function getUnclaimedFee() public returns (UnclaimedFeeData memory) {
        return userUnclaimedFee[msg.sender];
    }

    // 미청구 수수료 청구하는 함수
    function claimFee() public returns (bool) {
        // 누적된 미청구 수수료가 0 이상 있어야 함
        uint256 token0Amount = userUnclaimedFee[msg.sender].token0Amount;
        uint256 token1Amount = userUnclaimedFee[msg.sender].token1Amount;
        require(token0Amount > 0 || token1Amount > 0);

        Token(token0).transfer(msg.sender, token0Amount);
        Token(token1).transfer(msg.sender, token1Amount);
        userUnclaimedFee[msg.sender].token0Amount = 0;
        userUnclaimedFee[msg.sender].token1Amount = 0;
        return true;
    }

    // 유저가 해당 풀에 공급중인 예치량 계산해서 반환
    // function getUserLiquidity(address validator) public view returns (Data memory) {
    //     // lptoken 개수로 token0, token1 예치량 역계산

    //     return ();
    // }
}