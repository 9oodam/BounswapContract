// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./WBNC.sol";
import "./Token.sol";
import "../utils/Data.sol";

contract InitialDeploy {

    Data dataParams;

    constructor(address _dataAddress) {
        // 토큰 4개 생성
        WBNC wbnc = new WBNC('Wrapped Bounce Coin', 'WBNC', 0, "");
		Token eth = new Token('ethereum', 'ETH', 10000, "");
		Token usdt = new Token('Tether', 'USDT', 10000, "");
		Token bnb = new Token ('Binance Coin', 'BNB', 10000, "");
        // Data.sol에 있는 allTokens 배열에 추가
        dataParams = new Data(_dataAddress);
        dataParams.allTokens.push(address(wbnc));
		dataParams.allTokens.push(address(eth));
		dataParams.allTokens.push(address(usdt));
		dataParams.allTokens.push(address(bnb));
    }
}