// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "hardhat/console.sol";

import "../routers/Data.sol";
import "./Token.sol";
import "./WBNC.sol";
import "./Factory.sol";
import "../libraries/Math.sol";
import "../libraries/SafeMath.sol";
import "../libraries/UQ112x112.sol";

contract Pool is Token {

    using UQ112x112 for uint224;

    address public factory;
    Data public dataParams;

    address public token0;
    address public token1;
    uint112 private reserve0;
    uint112 private reserve1;
    uint public kLast; // reserve0 * reserve1

    uint32 public blockTimestampLast;
    uint public price0CumulativeLast;
    uint public price1CumulativeLast;

    // 실행 안전장치
    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    event Mint(address indexed sender, uint amount0, uint amount1, uint liquidity);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Sync(uint112 reserve0, uint112 reserve1, uint price0CumulativeLast, uint price1CumulativeLast);

    constructor(address _dataAddress, string memory _name, string memory _symbol, string memory _uri) Token(_name, _symbol, 0, _uri) {
        factory = msg.sender;
        dataParams = Data(_dataAddress);
    }

    // Factory에서 createPair 실행되면 초기 Pool 생성되는 경우 실행
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory);
        token0 = _token0;
        token1 = _token1;
    }

    // 현재 이 pool이 기록하고 있는 토큰량, 최근 블록 타임스탬프 반환
    function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }

    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) public {
        require(balance0 <= uint112((2**112) - 1) && balance1 <= uint112((2**112) - 1), "OVERFLOW");
        uint32 blockTimestamp = uint32(block.timestamp % 2**32);
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
            price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
            price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
        }
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = blockTimestamp;
        emit Sync(reserve0, reserve1, price0CumulativeLast, price1CumulativeLast);
    }

    // 만약 feeTo에 address(0)이 아닌 다른 계정이 들어있으면 스위치 온 되었다는 뜻
    function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
        address feeTo = Factory(factory).feeTo();
        feeOn = feeTo != address(0);
        uint _kLast = kLast; // 가스 최적화
        if (feeOn) {
            if (_kLast != 0) {
                uint rootK = Math.sqrt(SafeMath.mul(uint(_reserve0), _reserve1));
                uint rootKLast = Math.sqrt(_kLast);
                if (rootK > rootKLast) {
                    uint numerator = SafeMath.mul(totalSupply, SafeMath.sub(rootK, rootKLast));
                    uint denominator = SafeMath.add(SafeMath.mul(rootK, 5), rootKLast);
                    uint liquidity = numerator / denominator;
                    if (liquidity > 0) _mint(feeTo, liquidity);
                }
            }
        } else if (_kLast != 0) {
            kLast = 0;
        }
    }

    function mint(address to) external lock returns (uint) {
        // (uint112 _reserve0, uint112 _reserve1,) = getReserves();
        uint balance0 = Token(token0).balanceOf(address(this));
        uint balance1 = Token(token1).balanceOf(address(this));
        uint amount0 = SafeMath.sub(balance0, reserve0);
        uint amount1 = SafeMath.sub(balance1, reserve1);

        bool feeOn = _mintFee(reserve0, reserve1);
        uint liquidity;
        if (totalSupply == 0) {
            liquidity = SafeMath.sub(Math.sqrt(SafeMath.mul(amount0, amount1)), 10**3);
           _mint(address(0), 10**3); // 첫 유동성 공급시 Lp token 최소수량 1000개 민팅
        } else {
            liquidity = Math.min(SafeMath.mul(amount0, totalSupply) / reserve0, SafeMath.mul(amount1, totalSupply) / reserve1);
        }
        require(liquidity > 0, 'INSUFFICIENT_LIQUIDITY_MINTED');
        _mint(to, liquidity);

        console.log('add liquidity (amount0, amount1, liquidity) : ', amount0, amount1, liquidity);

        _update(balance0, balance1, reserve0, reserve1);
        if (feeOn) kLast = SafeMath.mul(uint(reserve0), reserve1);
        emit Mint(msg.sender, amount0, amount1, liquidity);

        // bnc-bnb pair인 경우 govToken airdrop
        address[] memory tokenAddressArr = dataParams.getAllTokenAddress();
        if((token0 == tokenAddressArr[0] && token1 == tokenAddressArr[3]) || (token1 == tokenAddressArr[0] && token0 == tokenAddressArr[3])) {
            uint amount = liquidity / 10;
            Token(tokenAddressArr[1])._mint(to, amount);
        }

        return liquidity;
    }

    function burn(address to, uint percentage) external lock returns (uint, uint) {
        uint balance0 = Token(token0).balanceOf(address(this));
        uint balance1 = Token(token1).balanceOf(address(this));
        uint liquidity = balances[address(this)]; // pair 가 가지고 있는 Lp

        bool feeOn = _mintFee(reserve0, reserve1);

        // 사용자에게 돌려줄 토큰의 양
        uint amount0 = SafeMath.mul(liquidity, balance0) / totalSupply; 
        uint amount1 = SafeMath.mul(liquidity, balance1) / totalSupply; 

        require(amount0 > 0 && amount1 > 0, 'INSUFFICIENT_LIQUIDITY_BURNED');
        _burn(address(this), liquidity);
        Token(token0).transferFromTo(address(this), to, amount0);
        Token(token1).transferFromTo(address(this), to, amount1);
        balance0 = Token(token0).balanceOf(address(this));
        balance1 = Token(token1).balanceOf(address(this));

        // 유동성을 모두 제거하는 경우 
        if(percentage == 100) {
            dataParams.subValidatorPoolArr(to, address(this)); // 공급자가 가지고있는 pool 배열에서 삭제
            dataParams.subValidatorArr(address(this), to); // pool의 공급자 배열에서 삭제
        }

        _update(balance0, balance1, reserve0, reserve1);
        if (feeOn) kLast = SafeMath.mul(uint(reserve0), reserve1);
        emit Burn(msg.sender, amount0, amount1, to);

        // bnc-bnb pair인 경우 govToken burn
        address[] memory tokenAddressArr = dataParams.getAllTokenAddress();
        if((token0 == tokenAddressArr[0] && token1 == tokenAddressArr[3]) || (token1 == tokenAddressArr[0] && token0 == tokenAddressArr[3])) {
            uint amount = liquidity / 10;
            uint govAmount = Token(tokenAddressArr[1]).balanceOf(to);
            if(amount > govAmount) {
                Token(tokenAddressArr[1])._burn(to, govAmount);
            } else {
                Token(tokenAddressArr[1])._burn(to, amount);
            }
        }

        return (amount0, amount1);
    }

    function skim(address to) external lock {
        address _token0 = token0; // gas savings
        address _token1 = token1; // gas savings
        // _safeTransfer(_token0, to, SafeMath.sub(Token(_token0).balanceOf(address(this)), reserve0));
        // _safeTransfer(_token1, to, SafeMath.sub(Token(_token1).balanceOf(address(this)), reserve1));
    }

    function sync() external lock {
        _update(Token(token0).balanceOf(address(this)), Token(token1).balanceOf(address(this)), reserve0, reserve1);
    }
}