// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "hardhat/console.sol";

import "./Token.sol";
import "./WBNC.sol";
import "./Factory.sol";
import "../utils/Data.sol";
import "../libraries/Math.sol";
import "../libraries/SafeMath.sol";
import "../libraries/UQ112x112.sol";

contract Pool is Token {

    using UQ112x112 for uint224;

    address public factory;
    address private dataAddress;
    address private wbncAddress;

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

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Sync(uint112 reserve0, uint112 reserve1);

    constructor(address _wbncAddress, string memory _name, string memory _symbol) Token(_name, _symbol, 0, "") {
        factory = msg.sender;
        wbncAddress = _wbncAddress;
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

    function _addLiquidity(
        address tokenA, address tokenB,
        uint amountADesired, uint amountBDesired,
        uint amountAMin, uint amountBMin
    ) internal returns (uint amountA, uint amountB) {
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        (uint reserveA, uint reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            uint amountBOptimal = SafeMath.mul(amountADesired, reserveB) / reserveA;
            if (amountBOptimal <= amountBDesired) {
                require(amountBOptimal >= amountBMin, 'INSUFFICIENT_B_AMOUNT');
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                // uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
                uint amountAOptimal = SafeMath.mul(amountBDesired, reserveA) / reserveB;
                assert(amountAOptimal <= amountADesired);
                require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
    }

    // token-token
    function addLiquidity(
        address tokenA, address tokenB,
        uint amountADesired, uint amountBDesired,
        uint amountAMin, uint amountBMin,
        address to
    ) public returns (uint amountA, uint amountB, uint liquidity) {
        (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
        Token(tokenA).transfer(to, address(this), amountA);
        Token(tokenB).transfer(to, address(this), amountB);
        liquidity = mint(to);
    }
    function removeLiquidity(
        address tokenA, address tokenB,
        uint percentage,
        uint amountAMin, uint amountBMin,
        address to
    ) public returns (uint amountA, uint amountB) {
        uint removeAmount = balanceOf(to) * percentage; // 유저가 가지고 있는 수량에서 몇퍼센트 제거할건지
        transfer(to, address(this), removeAmount);
        (uint amount0, uint amount1) = burn(to, percentage);
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
        require(amountA >= amountAMin, 'INSUFFICIENT_A_AMOUNT');
        require(amountB >= amountBMin, 'INSUFFICIENT_B_AMOUNT');
    }
    // bnc-token
    function addLiquidityBNC(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin, uint amountBNCMin,
        address to
    ) public payable returns (uint amountToken, uint amountBNC, uint liquidity) {
        (amountToken, amountBNC) = _addLiquidity(
            token, wbncAddress,
            amountTokenDesired, msg.value,
            amountTokenMin, amountBNCMin
        );
        Token(token).transfer(to, address(this), amountToken);
        WBNC(wbncAddress).deposit{value: amountBNC}(amountBNC);
        liquidity = mint(to);
        if (msg.value > amountBNC) to.call{value: msg.value - amountBNC}("");
    }
    function removeLiquidityBNC(
        address token,
        uint percentage,
        uint amountTokenMin, uint amountBNCMin,
        address to
    ) public returns (uint amountToken, uint amountBNC) {
        (amountToken, amountBNC) = removeLiquidity(
            token, wbncAddress,
            percentage,
            amountTokenMin, amountBNCMin,
            address(this)
        );
        Token(token).transfer(address(this), to, amountToken);
        WBNC(wbncAddress).withdraw(amountBNC);
        to.call{value: amountBNC}("");
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
        emit Sync(reserve0, reserve1);
    }

    // 만약 feeTo에 address(0)이 아닌 다른 계정이 들어있으면 스위치 온 되었다는 뜻
    // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
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

    function mint(address to) internal lock returns (uint) {
        // (uint112 _reserve0, uint112 _reserve1,) = getReserves();
        uint balance0 = Token(token0).balanceOf(address(this));
        uint balance1 = Token(token1).balanceOf(address(this));
        uint amount0 = SafeMath.sub(balance0, reserve0);
        uint amount1 = SafeMath.sub(balance1, reserve1);
        console.log('amount0 : ', amount0);
        console.log('amount1 : ', amount1);

        bool feeOn = _mintFee(reserve0, reserve1);
        uint liquidity;
        if (totalSupply == 0) {
            liquidity = SafeMath.sub(Math.sqrt(SafeMath.mul(amount0, amount1)), 10**3);
            console.log('totalSupply == 0 : ', liquidity);
           _mint(address(0), 10**3); // permanently lock the first MINIMUM_LIQUIDITY tokens
        } else {
            console.log('totalSupply > 0 : ', liquidity);
            liquidity = Math.min(SafeMath.mul(amount0, totalSupply) / reserve0, SafeMath.mul(amount1, totalSupply) / reserve1);
        }
        require(liquidity > 0, 'INSUFFICIENT_LIQUIDITY_MINTED');
        _mint(to, liquidity);
        console.log('lp token minting');
        Data(dataAddress).addValidatorArr(address(this), to);

        _update(balance0, balance1, reserve0, reserve1);
        if (feeOn) kLast = SafeMath.mul(uint(reserve0), reserve1); // reserve0 and reserve1 are up-to-date
        emit Mint(msg.sender, amount0, amount1);

        return liquidity;
    }

    function burn(address to, uint percentage) internal lock returns (uint, uint) {
        uint balance0 = Token(token0).balanceOf(address(this));
        uint balance1 = Token(token1).balanceOf(address(this));
        uint liquidity = balances[address(this)]; // pair 가 가지고 있는 Lp

        bool feeOn = _mintFee(reserve0, reserve1);

        // uint userLiquidity = (liquidity * percentage) / 100; // 사용자가 원하는 비율로 소각
        // require(userLiquidity > 0, 'INSUFFICIENT_LIQUIDITY_BURNED');

        // 사용자에게 돌려줄 토큰의 양
        uint amount0 = SafeMath.mul(liquidity, balance0) / totalSupply; 
        uint amount1 = SafeMath.mul(liquidity, balance1) / totalSupply; 

        require(amount0 > 0 && amount1 > 0, 'INSUFFICIENT_LIQUIDITY_BURNED');
        _burn(address(this), liquidity);
        Token(token0).transfer(to, amount0);
        Token(token1).transfer(to, amount1);
        balance0 = Token(token0).balanceOf(address(this));
        balance1 = Token(token1).balanceOf(address(this));

        // 유동성을 모두 제거하는 경우 
        if(percentage == 100) {
            Data(dataAddress).subValidatorPoolArr(to, address(this)); // 공급자가 가지고있는 pool 배열에서 삭제
            Data(dataAddress).subValidatorArr(address(this), to); // pool의 공급자 배열에서 삭제
        }

        _update(balance0, balance1, reserve0, reserve1);
        if (feeOn) kLast = SafeMath.mul(uint(reserve0), reserve1);
        emit Burn(msg.sender, amount0, amount1, to);

        return (amount0, amount1);
    }

    // 공급자가 가지고 있는 pool 배열
    // function setValidatorPoolArr(address userAddress, address tokenA, address tokenB) public returns(bool) {
    //     address pair = getPair[tokenA][tokenB];
    //     console.log(pair);
    //     // 이미 있으면 중복 안되게, 삭제되면 pop
    //     bool isDuplicated = false;
    //     for(uint i=0; i<dataParams.validatorPoolArrLength(userAddress); i++) {
    //         if(dataParams.getValidatorPoolArr(userAddress)[i] == pair) {
    //             isDuplicated == true;
    //             break;
    //         }
    //     }
    //     console.log('isDuplicated : ', isDuplicated);
    //     require(isDuplicated == false);
    //     dataParams.addValidatorPoolArr(msg.sender, pair);
    //     return true;
    // }

    // 미청구 수수료 청구하는 함수
    function claimFee(address validator) public returns (bool) {
        (uint256 token0FeeAmount, uint256 token1FeeAmount) = Data(dataAddress).getUnclaimedFee(validator, address(this));
        
        // 누적된 미청구 수수료가 0 이상 있어야 함
        require(token0FeeAmount > 0 || token1FeeAmount > 0, "No fees to claim");
        Token(token0).transfer(validator, token0FeeAmount);
        Token(token1).transfer(validator, token1FeeAmount);
        Data(dataAddress).setUnclaimedFee(validator, address(this), 0, 0);
        return true;
    }

    // 유저가 해당 풀에 공급중인 예치량 계산해서 반환
    function getUserLiquidity(address validator) public view returns (uint256, uint256) {
        // lptoken 개수로 token0, token1 예치량 역계산
        uint256 lpTokenAmount = balances[validator];
        uint256 amount0 = SafeMath.mul(lpTokenAmount, reserve0) / totalSupply; 
        uint256 amount1 = SafeMath.mul(lpTokenAmount, reserve1) / totalSupply; 
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