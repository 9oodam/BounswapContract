// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./WBNC.sol";
import "./Token.sol";
import "../utils/Data.sol";

contract InitialDeploy {

    Data dataParams;

    constructor(address _dataAddress) {
        // 토큰 4개 생성
        WBNC wbnc = new WBNC('Wrapped Bounce Coin', 'WBNC', "");
		Token eth = new Token('ethereum', 'ETH', 10000, "");
		Token usdt = new Token('Tether', 'USDT', 10000, "");
		Token bnb = new Token ('Binance Coin', 'BNB', 10000, "");
        // Data.sol에 있는 allTokens 배열에 추가
        dataParams = Data(_dataAddress);

        dataParams.addToken(address(wbnc));
		dataParams.addToken(address(eth));
		dataParams.addToken(address(usdt));
		dataParams.addToken(address(bnb));
    }
}