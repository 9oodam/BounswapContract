// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../routers/Data.sol";
import "./Factory.sol";
import "./PoolConnector.sol";
import "./WBNC.sol";
import "./Token.sol";

contract InitialDeploy {

    Data dataParams;
    Factory factoryParams;
    PoolConnector poolConnectorParams;

    address[] tokenAddress;

    constructor(address _dataAddress, address _factyroAddress, address _poolConnectorAddress) {
        // 토큰 컨트랙트 생성 및 배포
        WBNC wbnc = new WBNC('Bounce Coin', 'BNC', 10000, "BNC.png");
        Token gov = new Token('Governance', 'GOV', 0, "GOV.png");
		Token eth = new Token('Ether', 'ETH', 10000, "ETH.png");
		Token usdt = new Token('Tether USD', 'USDT', 10000, "USDT.png");
		Token bnb = new Token ('Binance Coin', 'BNB', 10000, "BNB.png");

        factoryParams = Factory(_factyroAddress);
        dataParams = Data(_dataAddress);
        poolConnectorParams = PoolConnector(_poolConnectorAddress);

        // Data.sol에 있는 allTokens 배열에 추가
        dataParams.addToken(address(wbnc));
        dataParams.addToken(address(gov));
		dataParams.addToken(address(eth));
		dataParams.addToken(address(usdt));
		dataParams.addToken(address(bnb));

        tokenAddress = [address(wbnc), address(eth), address(usdt), address(bnb)];

        initialPairCreated();
    }

    function initialPairCreated() internal {
        for(uint i=0; i<tokenAddress.length; i++) {
            for(uint j=i+1; j<tokenAddress.length; j++) {
                // 페어 생성
                factoryParams.createPair(tokenAddress[i], tokenAddress[j]);
                // 유동성 공급
                uint amount = 1000 * (10 ** 18);
                poolConnectorParams.addLiquidity(tokenAddress[i], tokenAddress[j], amount, amount, address(this));
            }
        }
    }
}