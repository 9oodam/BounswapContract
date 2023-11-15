// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Factory.sol";
import "./Pool.sol";
import "./WBNC.sol";
import "./Token.sol";
import "../utils/Data.sol";

contract InitialDeploy {

    Data dataParams;
    Factory factoryParams;

    address[] tokenAddress;

    constructor(address _dataAddress, address _factyroAddress) {
        // 토큰 컨트랙트 생성 및 배포
        WBNC wbnc = new WBNC('Wrapped Bounce Coin', 'WBNC', 10000, "");
        Token gov = new Token('Governance', 'GOV', 0, "");
		Token eth = new Token('ethereum', 'ETH', 10000, "");
		Token usdt = new Token('Tether', 'USDT', 10000, "");
		Token bnb = new Token ('Binance Coin', 'BNB', 10000, "");

        factoryParams = Factory(_factyroAddress);
        dataParams = Data(_dataAddress);

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
                address pairAddress = factoryParams.createPair(tokenAddress[i], tokenAddress[j]);
                console.log(pairAddress);
                // 생성된 페어로 토큰 송금
                // Token(tokenAddress[i]).transfer(address(this), pairAddress, 100 * (10 ** 18));
                // Token(tokenAddress[j]).transfer(address(this), pairAddress, 100 * (10 ** 18));
                // console.log(Token(tokenAddress[i]).balanceOf(pairAddress));
                // console.log(Token(tokenAddress[j]).balanceOf(pairAddress));
                // 유동성 공급
                // uint amount = 100 * (10 ** 18);
                // uint amountMin = 95 * (10 ** 18);
                // (uint amountA, uint amountB, uint liquidity) = Pool(pairAddress).addLiquidity(tokenAddress[i], tokenAddress[j], amount, amount, amountMin, amountMin, address(this));
                // console.log(amountA, amountB, liquidity);
            }
        }
    }
}