// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IERC20.sol";
import "./interfaces/IFactory.sol";

import "./Token.sol";
import "./WBNC.sol";

import "./libraries/Calculate.sol";
import "./libraries/Hooks/sol";
import "./libraries/Math.sol";
import "./libraries/UQ112x112.sol";
import "./libraries/SafeMath.sol";


contract Pair is Token {
    using UQ112x112 for uint224;

    uint public constant MINIMUM_LIQUIDITY = 10**3;
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));

    address public factory;
    address public token0;
    address public token1;

    uint112 private reserve0;           // uses single storage slot, accessible via getReserves
    uint112 private reserve1;           // uses single storage slot, accessible via getReserves
    uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves

    uint public price0CumulativeLast;
    uint public price1CumulativeLast;
    uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event

    // 재진입 공격 방지를 위한 lock 정의
    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'UniswapV2: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    mapping (uint blockStamp => uint volume) public volumePerTransaction0; // token0의 volume
    mapping (uint blockStamp => uint volume) public volumePerTransaction1;


    function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }

    function _safeTransfer(address token, address to, uint value) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
    }

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Sync(uint112 reserve0, uint112 reserve1);


    // uint112 private constant MAX_UINT112 = uint112(uint112(-1));
    uint112 private constant MAX_UINT112 = uint112((2**112) - 1);

    constructor( string memory _name, string memory _symbol, uint _initialAmount, string memory _uri) Token(_name, _symbol, _initialAmount, _uri) {
        factory = msg.sender;
    }

    // called once by the factory at time of deployment
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }

    // update reserves and, on the first call per block, price accumulators
    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) internal {
        // require(balance0 <= uint112(-1) && balance1 <= uint112(-1), "UniswapV2: OVERFLOW");
        require(balance0 <= MAX_UINT112 && balance1 <= MAX_UINT112, "UniswapV2: OVERFLOW");
        uint32 blockTimestamp = uint32(block.timestamp % 2**32);
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
            // * never overflows, and + overflow is desired
            price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
            price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
        }
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = blockTimestamp;
        emit Sync(reserve0, reserve1);
    }

    // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
    function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
        address feeTo = IBounswapFactory(factory).feeTo();
        feeOn = feeTo != address(0);
        uint _kLast = kLast; // gas savings
        if (feeOn) {
            if (_kLast != 0) {
                uint rootK = Math.sqrt(SafeMath.mul(uint(_reserve0), _reserve1));
                // uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
                uint rootKLast = Math.sqrt(_kLast);
                if (rootK > rootKLast) {
                    
                    uint numerator = SafeMath.mul(_totalSupply, SafeMath.sub(rootK, rootKLast));
                    // uint numerator = totalSupply.mul(rootK.sub(rootKLast));
                    // uint denominator = rootK.mul(5).add(rootKLast);
                    uint denominator = SafeMath.add(SafeMath.mul(rootK, 5), rootKLast);
                    uint liquidity = numerator / denominator;
                    if (liquidity > 0) _mint(feeTo, liquidity);
                }
            }
        } else if (_kLast != 0) {
            kLast = 0;
        }
    }

    // this low-level function should be called from a contract which performs important safety checks
    function mint(address to) external lock returns (uint liquidity) {
        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
        uint balance0 = Token(token0).balanceOf(address(this));
        uint balance1 = Token(token1).balanceOf(address(this));
        uint amount0 = SafeMath.sub(balance0, _reserve0);
        uint amount1 = SafeMath.sub(balance1, _reserve1);
        // uint amount0 = balance0.sub(_reserve0);
        // uint amount1 = balance1.sub(_reserve1);

        bool feeOn = _mintFee(_reserve0, _reserve1);
        // uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
        // uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
        if (_totalSupply == 0) {
            liquidity = SafeMath.sub(Math.sqrt(SafeMath.mul(amount0, amount1)), MINIMUM_LIQUIDITY);
           _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
        } else {
            liquidity = Math.min(SafeMath.mul(amount0, _totalSupply) / _reserve0, SafeMath.mul(amount1, _totalSupply) / _reserve1);
        }
        require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');
        _mint(to, liquidity);

        _update(balance0, balance1, _reserve0, _reserve1);
        if (feeOn) kLast = SafeMath.mul(uint(reserve0), reserve1); // reserve0 and reserve1 are up-to-date
        // if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
        emit Mint(msg.sender, amount0, amount1);

        // 공급자 -> pool 정보 확인용
        // 이 Pool을 처음 생성하는 것이라면?
        if(poolDataForValidator[msg.sender].lpToken == 0) {
            Data memory data = Data(token0, amount0, token1, amount1, liquidity);
            // Data memory data = new Data(token0, amount0, token1, amount1, liquidity);
            poolDataForValidator[msg.sender] = data;
        }else { // 기존에 생성한 pool에 추가하는 것이라면?
            poolDataForValidator[msg.sender].token0Amount += amount0;
            poolDataForValidator[msg.sender].token1Amount += amount1;
            poolDataForValidator[msg.sender].lpToken += liquidity;
        }
    }

    function burn(address to, uint percentage) external lock returns (uint amount0, uint amount1) {
        (uint112 _reserve0, uint112 _reserve1,) = getReserves();
        address _token0 = token0;                                
        address _token1 = token1;                                
        uint balance0 = Token(_token0).balanceOf(address(this));
        uint balance1 = Token(_token1).balanceOf(address(this));
        uint liquidity = balanceOf(address(this)); // pair 가 가지고 있는 Lp

        bool feeOn = _mintFee(_reserve0, _reserve1);
        // uint _totalSupply = totalSupply; // 전체 lp

        uint userLiquidity = (liquidity * percentage) / 100; // 사용자가 원하는 비율로 소각
        require(userLiquidity > 0, 'INSUFFICIENT_LIQUIDITY_BURNED');

        // 사용자에게 돌려줄 토큰의 양
        amount0 = SafeMath.mul(userLiquidity, balance0) / _totalSupply; 
        amount1 = SafeMath.mul(userLiquidity, balance1) / _totalSupply; 

        require(amount0 > 0 && amount1 > 0, 'INSUFFICIENT_LIQUIDITY_BURNED');
        _burn(address(this), userLiquidity);
        _safeTransfer(_token0, to, amount0);
        _safeTransfer(_token1, to, amount1);
        balance0 = Token(_token0).balanceOf(address(this));
        balance1 = Token(_token1).balanceOf(address(this));

        // 공급자의 pool data 수정
        poolDataForValidator[msg.sender].token0Amount -= amount0;
        poolDataForValidator[msg.sender].token1Amount -= amount1;
        poolDataForValidator[msg.sender].lpToken -= userLiquidity;

        // 만약 공급자가 모든 LpToken을 소각시켰으면 전체 공급자 배열에서 제외
        if(poolDataForValidator[msg.sender].lpToken == 0) {   
            for(uint i=0; i<validatorArr.length; i++) {
                if(validatorArr[i] == msg.sender) {
                    uint lastIndex = validatorArr.length - 1;
                    validatorArr[i] = validatorArr[lastIndex];
                    validatorArr.pop();
                }
            }
        }

        _update(balance0, balance1, _reserve0, _reserve1);
        if (feeOn) kLast = SafeMath.mul(uint(reserve0), reserve1);
        // if (feeOn) kLast = uint(reserve0).mul(reserve1);
        emit Burn(msg.sender, amount0, amount1, to);
    }

    // input 넣었을 때 output 계산하는 함수
    function getOutputAmount(uint inputAmount, address inputToken) public view returns (uint outputAmount) {
        (uint inputReserve, uint outputReserve) = (inputToken == token0) ? (reserve0, reserve1) : (reserve1, reserve0);
        return Calculate.calOutputAmount(inputAmount, inputReserve, outputReserve);
    }
    // output 넣었을 때 input 계산하는 함수
    function getInputAmount(uint outputAmount, address outputToken) public view returns (uint inputAmount) {
        (uint inputReserve, uint outputReserve) = (outputToken == token0) ? (reserve1, reserve0) : (reserve0, reserve1);
        return Calculate.calInputAmount(outputAmount, inputReserve, outputReserve);
    }

    // input 값을 넣어서 ouput 값을 받고 싶을 때 == 받고 싶은 값이 0.5% 이하로 떨어지면 실행 안함
    function beforeSwapInput(address tokenAddress, uint inputAmount, uint minToken) public returns (uint) {

        (uint amount0Out, amount1Out) = tokenAddress == token0 ? (amount0Out = inputAmount, amount1Out = 0);
    }

    // output 값을 넣어서 input 값을 받고 싶을 때 == 지불하고 싶은 값이 0.5% 이상으로 올라가면 실행 안함
    function beforeSwapOutput(uint outputAmount) public returns (uint) {
    }

    function swap(uint amount0Out, uint amount1Out, address to) external lock {
        // output 이 둘 중에 하나는 0 보다 커야함
        require(amount0Out > 0 || amount1Out > 0, 'INSUFFICIENT_OUTPUT_AMOUNT');

        // BNC <-> WBNC
        if(msg.value > 0) {
            WBNC(factory.allTokens[0]).deposit(msg.value);
        }


        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
        require(amount0Out < _reserve0 && amount1Out < _reserve1, 'INSUFFICIENT_LIQUIDITY');

        uint balance0;
        uint balance1;
        { // scope for _token{0,1}, avoids stack too deep errors
        address _token0 = token0;
        address _token1 = token1;
        require(to != _token0 && to != _token1, 'INVALID_TO');
        if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
        if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
        // if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
        balance0 = Token(_token0).balanceOf(address(this));
        balance1 = Token(_token1).balanceOf(address(this));
        }
        uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
        uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
        require(amount0In > 0 || amount1In > 0, 'INSUFFICIENT_INPUT_AMOUNT');

        { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
        uint balance0Adjusted = SafeMath.sub(SafeMath.mul(balance0, 1000), SafeMath.mul(amount0In, 3));
        uint balance1Adjusted = SafeMath.sub(SafeMath.mul(balance1, 1000), SafeMath.mul(amount1In, 3));
        // uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
        // uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
        require(SafeMath.mul(balance0Adjusted, balance1Adjusted) >= SafeMath.mul(SafeMath.mul(uint(_reserve0), _reserve1), 1000**2), 'UniswapV2: K');
        }

        // unclaimed fee 누적시키기
        for(uint i=0; i<validatorArr.length; i++) {
            uint userLiquidity = poolDataForValidator[validatorArr[i]].lpToken;
            uint liquidity = balanceOf(address(this));
            
            userlUnclaimedFees[validatorArr[i]].token0Amount += SafeMath.mul(amount0In, 3) * userLiquidity / liquidity;
            userlUnclaimedFees[validatorArr[i]].token1Amount += SafeMath.mul(amount1In, 3) * userLiquidity / liquidity;
            // userlUnclaimedFees[validatorArr[i]].token0Amount += amount0In.mul(3) * userLiquidity / liquidity;
            // userlUnclaimedFees[validatorArr[i]].token1Amount += amount1In.mul(3) * userLiquidity / liquidity;
        }


        _update(balance0, balance1, _reserve0, _reserve1);
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);

        // Volume 누적시키기
        volumePerTransaction0[block.timestamp] = amount0In;
        volumePerTransaction0[block.timestamp] += amount0Out;
        volumePerTransaction1[block.timestamp] = amount1In;
        volumePerTransaction1[block.timestamp] += amount1Out;
    }






    // 토큰 당 totalVolume 계산
    function getTotalVolume(address tokenAddress, uint blockStampNow, uint blockStamp24hBefore) public returns (uint) {
        require(tokenAddress == token0 || tokenAddress == token1, "Invalid token address");
        uint totalVolume = 0;

        if (tokenAddress == token0) {
            for (uint i = blockStamp24hBefore; i <= blockStampNow; i++) {
                totalVolume += volumePerTransaction0[i];
            }
        } else {
            for (uint i = blockStamp24hBefore; i <= blockStampNow; i++) {
                totalVolume += volumePerTransaction1[i];
            }
        }

        return totalVolume;
    }



    function skim(address to) external lock {
        address _token0 = token0; // gas savings
        address _token1 = token1; // gas savings
        _safeTransfer(_token0, to, SafeMath.sub(Token(_token0).balanceOf(address(this)), reserve0));
        _safeTransfer(_token1, to, SafeMath.sub(Token(_token1).balanceOf(address(this)), reserve1));
    }

    function sync() external lock {
        _update(Token(token0).balanceOf(address(this)), Token(token1).balanceOf(address(this)), reserve0, reserve1);
    }
}