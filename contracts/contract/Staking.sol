// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "../interfaces/IERC20.sol";
import "../utils/Data.sol";
import "./WBNC.sol";

contract Staking is Ownable, ReentrancyGuard { 
    
    struct UserInfo {
        uint256 amount;
        uint256 exactRewardCal;
        uint256 pendingReward;
    }

    struct PoolInfo {
        IERC20 lpToken;
        uint256 allocPoint; 
        uint256 lastRewardBlock; 
        uint256 accBNCPerShare;
    }
    
    WBNC public BNC; // 보상은 BNC로
    Data public data;
    uint256 public percentDec = 10000;
    uint256 public stakingPercent;

    uint256 public dev0Percent;

    address public dev0Addr;

    uint256 public BNCPerBlock; 

    uint256 public BONUS_MULTIPLIER = 1; 

    uint256 public lastBlockDevWithdraw;

    PoolInfo[] public poolInfo;

    mapping(uint256 => mapping(address => UserInfo)) public userInfo;
    
    uint256 public totalAllocPoint = 0;
    uint256 public startBlock;

    event SetDev0Address(address indexed dev0Addr);
    event UpdateBNCPerBlock(uint256 BNCPerBlock);
    event SetPercent(uint256 stakingPercent, uint256 dev0Percent);
    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount); // 쌓인 리워드 받으면서 출금하는 일반 출금
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount); // 보상 못받고 자기것만 긴급 출금, 탈주닌자
    event ClaimBNC(address indexed user, uint256 indexed pid, uint256 amount);
    
    modifier vaildPool (uint256 _pid) {
        require(_pid < poolInfo.length, "pool not exist");
        _;
    }

    constructor(
        address _BNCToken, 
        address _data,
        address _dev0Addr, 
        uint256 _dev0Percent,
        uint256 _stakingPercent,
        uint256 _BNCPerBlock,
        uint256 _startBlock,
        address _initialOwner
    ) Ownable(_initialOwner) public {
        BNC = WBNC(_BNCToken);
        data = Data(_data);
        dev0Addr = _dev0Addr;
        dev0Percent = _dev0Percent;
        stakingPercent = _stakingPercent;
        BNCPerBlock = _BNCPerBlock;
        startBlock = _startBlock; // 보상 시작 블록
        lastBlockDevWithdraw = _startBlock; // 개발자가 보상을 받기 위한 첫 블록을 기록
    }
    
    function updateBNCPerBlock (uint256 newAmount) public onlyOwner {
        require(newAmount <= 100 * 1e18, "Max per block 100 BNC");
        require(newAmount >= 1 * 1e15, "Min per block 0.001 BNC");
        BNCPerBlock = newAmount;
        emit UpdateBNCPerBlock(BNCPerBlock);
    }

    function setDevAddress(address _dev0Addr) public onlyOwner {
        require(_dev0Addr != address(0), "Zero");
        dev0Addr = _dev0Addr;
        emit SetDev0Address(dev0Addr);
    }

    function setPercent (uint256 _stakingPercent, uint256 _dev0Percent) public onlyOwner {
        uint256 devPercent = _dev0Percent;
        require(_stakingPercent + devPercent <= percentDec, "Percent Sum");
        stakingPercent = _stakingPercent;
        dev0Percent = _dev0Percent;
        emit SetPercent(stakingPercent, dev0Percent);
    }

    function withdrawDevFee() public {
        require(lastBlockDevWithdraw < block.number, "wait for new block");
        uint256 BNCReward = (block.number - lastBlockDevWithdraw) * BNCPerBlock;
        BNC._mint(dev0Addr, BNCReward * dev0Percent / percentDec);
        lastBlockDevWithdraw = block.number;
    }

    function addStakingPool (uint256 _allocPoint, address _lpToken) public onlyOwner {
        _checkPoolDuplicate(_lpToken);
        massUpdatePools();
        uint256 lastRewardBlock = block.number < startBlock ? startBlock : block.number;
        totalAllocPoint = totalAllocPoint + _allocPoint;
        poolInfo.push(
            PoolInfo({
                lpToken : IERC20(_lpToken),
                allocPoint : _allocPoint,
                lastRewardBlock : lastRewardBlock,
                accBNCPerShare : 0 // 누적된 BNC당 주식 값, 처음 생성시는 없으므로 0
            })
        );
    }

    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

    function set(uint256 _pid, uint256 _allocPoint) public onlyOwner vaildPool(_pid) {
        massUpdatePools();
        totalAllocPoint = totalAllocPoint - poolInfo[_pid].allocPoint + _allocPoint;
        poolInfo[_pid].allocPoint = _allocPoint;
    }

    function _checkPoolDuplicate(address _lpToken) view internal {
        uint256 length = poolInfo.length;
        for(uint256 pid = 0; pid < length; ++pid) {
            require(poolInfo[pid].lpToken != IERC20(_lpToken), "pool existed");
        }
    }

    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for(uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }

    function updatePool(uint256 _pid) public vaildPool(_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        if(block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if(lpSupply <= 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 BNCReward = multiplier * BNCPerBlock * pool.allocPoint / totalAllocPoint * stakingPercent / percentDec;
        BNC._mint(address(this), BNCReward);
        pool.accBNCPerShare = pool.accBNCPerShare + BNCReward * 1e12 / lpSupply;
        pool.lastRewardBlock = block.number;
    }

    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        return _to - _from * BONUS_MULTIPLIER;
    }

    function pendingBNC(uint256 _pid, address _user) public view vaildPool(_pid) returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accBNCPerShare = pool.accBNCPerShare;
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));

        if(block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 BNCReward = multiplier * BNCPerBlock * pool.allocPoint / totalAllocPoint * stakingPercent / percentDec;
            accBNCPerShare = accBNCPerShare + BNCReward * 1e12 / lpSupply;
        }
        return user.pendingReward + user.amount * accBNCPerShare / 1e12 - user.exactRewardCal;
    }

    function addPendingBNC(uint256 _pid, address _user) internal vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 pending = user.amount * pool.accBNCPerShare / 1e12 - user.exactRewardCal;
        if (pending > 0 ) {
            user.pendingReward = user.pendingReward + pending;
        }
    }
    
    function deposit(uint256 _pid, uint256 _amount) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        addPendingBNC(_pid, msg.sender); // 미지급 BNC가 있다면 업데이트

        if(_amount > 0) {
            pool.lpToken.transferFrom(address(msg.sender), address(this), _amount);
            user.amount = user.amount + _amount;
        }

        user.exactRewardCal = user.amount * pool.accBNCPerShare / 1e12;
        emit Deposit(msg.sender, _pid, _amount);
    }

    // 일반 출금
    function withdraw(uint256 _pid, uint256 _amount) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        addPendingBNC(_pid, msg.sender);

        if(_amount > 0) {
            user.amount = user.amount - _amount;
            pool.lpToken.transfer(address(msg.sender), _amount);
        }
        user.exactRewardCal = user.amount * pool.accBNCPerShare / 1e12;
        
        emit Withdraw(msg.sender, _pid, _amount);
    }

    function emergencyWithdraw (uint256 _pid) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];

        pool.lpToken.transfer(address(msg.sender), user.amount);
        emit EmergencyWithdraw(msg.sender, _pid, user.amount);

        user.amount = 0; 
        user.exactRewardCal = 0;
        user.pendingReward = 0;
    }

    function safeBNCTransfer(address _to, uint256 _amount) internal {
        uint256 BNCBal= BNC.balances(address(this)); // 이게 맞나???
        if (_amount > BNCBal) {
            BNC.transfer(_to, BNCBal);
        } else {
            BNC.transfer(_to, _amount);
        }
    }

    function claimBNC(uint256 _pid) public nonReentrant vaildPool(_pid) {
        updatePool(_pid);
        addPendingBNC(_pid, msg.sender);
        UserInfo storage user = userInfo[_pid][msg.sender];
        // 유저가 청구할 수 있는 쌓인 보상이 있다면
        if(user.pendingReward > 0) {
            uint256 amount = user.pendingReward; // amount에 담고
            user.pendingReward = 0; // 0으로 만들고
            safeBNCTransfer(msg.sender, amount); // 담은거 보냄
            
            emit ClaimBNC(msg.sender, _pid, amount);
        }
    }
}