// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

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
        uint256 stakingEndTime;
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
    
    mapping(uint256 => address[]) private stakingUsers; // 풀별 스테이킹 유저 목록

    uint256 public totalAllocPoint = 0;
    uint256 public startBlock;

    event SetDev0Address(address indexed dev0Addr);
    event UpdateBNCPerBlock(uint256 BNCPerBlock);
    event SetPercent(uint256 stakingPercent, uint256 dev0Percent);
    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount); // 쌓인 리워드 받으면서 출금하는 일반 출금
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount); // 보상 못받고 자기것만 긴급 출금, 탈주닌자
    event ClaimBNC(address indexed user, uint256 indexed pid, uint256 amount);
    event DistributeRewards (uint256 _pid, uint256 pendingReward, uint256 totalStaked); // 탈주닌자 리워드 처리 기록
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
    // 블록 당 보상 생성 속도 정의 (오너가)
    function updateBNCPerBlock (uint256 newAmount) public onlyOwner {
        require(newAmount <= 100 * 1e18, "Max per block 100 BNC");
        require(newAmount >= 1 * 1e15, "Min per block 0.001 BNC");
        BNCPerBlock = newAmount;
        emit UpdateBNCPerBlock(BNCPerBlock);
    }
    // 개발자 주소 세팅 (오너가)
    function setDevAddress(address _dev0Addr) public onlyOwner {
        require(_dev0Addr != address(0), "Zero");
        dev0Addr = _dev0Addr;
        emit SetDev0Address(dev0Addr);
    }
    // 각각의 주체가 받을 퍼센트 정의 (오너가)
    function setPercent (uint256 _stakingPercent, uint256 _dev0Percent) public onlyOwner {
        uint256 devPercent = _dev0Percent;
        require(_stakingPercent + devPercent <= percentDec, "Percent Sum");
        stakingPercent = _stakingPercent;
        dev0Percent = _dev0Percent;
        emit SetPercent(stakingPercent, dev0Percent);
    }
    // 이 함수를 호출할 때마다 설정한 Percent만큼 민팅되어 각각의 개발자 주소에 저장됌
    function withdrawDevFee() public {
        require(lastBlockDevWithdraw < block.number, "wait for new block");
        uint256 BNCReward = (block.number - lastBlockDevWithdraw) * BNCPerBlock;
        BNC._mint(dev0Addr, BNCReward * dev0Percent / percentDec);
        lastBlockDevWithdraw = block.number;
    }
    // 스테이킹 풀 생성 (오너가)
    function addStakingPool (uint256 _allocPoint, IERC20 _lpToken) public onlyOwner {
        _checkPoolDuplicate(_lpToken);
        massUpdatePools();
        uint256 lastRewardBlock = block.number < startBlock ? startBlock : block.number;
        totalAllocPoint = totalAllocPoint + _allocPoint;
        poolInfo.push(
            PoolInfo({
                lpToken : IERC20(_lpToken),
                allocPoint : _allocPoint,
                lastRewardBlock : lastRewardBlock,
                accBNCPerShare : 0, // 누적된 BNC당 주식 값, 처음 생성시는 없으므로 0
                stakingEndTime : 0
            })
        );
    }
    // 스테이킹 종료 일수 설정 (오너가)
    function setStakingEndDays(uint256 _pid, uint256 _days) public onlyOwner vaildPool(_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        uint256 endTime = block.timestamp + _days * 1 days; // 1days == 86400초
        require(endTime > block.timestamp, "End Time must be in the future");
        pool.stakingEndTime = endTime; // 해당 풀의 종료 시간
    }

    // LP 풀의 갯수 확인 
    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }
    // 해당 풀의 BNC 할당 점수 업데이트 (오너가)
    function set(uint256 _pid, uint256 _allocPoint) public onlyOwner vaildPool(_pid) {
        massUpdatePools();
        totalAllocPoint = totalAllocPoint - poolInfo[_pid].allocPoint + _allocPoint;
        poolInfo[_pid].allocPoint = _allocPoint;
    }
    // 같은 LP토큰으로 2번이상 풀이 생성되는 것을 방지, pid = Pool ID
    function _checkPoolDuplicate(IERC20 _lpToken) view internal {
        uint256 length = poolInfo.length;
        for(uint256 pid = 0; pid < length; ++pid) {
            require(poolInfo[pid].lpToken != IERC20(_lpToken), "pool existed");
        }
    }
    // 모든 풀 업데이트
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for(uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }
    // 풀의 보상 변수들을 최신상태로 업데이트
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
    // 보상을 계산하기 위해 사용, _from과 _to는 블록 범위
    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        return _to - _from * BONUS_MULTIPLIER;
    }
    // 프론트엔드에서 사용자가 보상으로 쌓인 BNC 조회
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
    // 사용자가 풀에서 자신의 몫을 정확하게 받도록 하게 하는 함수
    function addPendingBNC(uint256 _pid, address _user) internal vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 pending = user.amount * pool.accBNCPerShare / 1e12 - user.exactRewardCal;
        if (pending > 0 ) {
            user.pendingReward = user.pendingReward + pending;
        }
    }
    // LP토큰 예치 
    function deposit(uint256 _pid, uint256 _amount) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        addPendingBNC(_pid, msg.sender); // 미지급 BNC가 있다면 업데이트

        if(_amount > 0) {
            pool.lpToken.transferFrom(address(msg.sender), address(this), _amount);
            user.amount = user.amount + _amount;
        }

        // 하려는 예치량이 0이상이고 가진 예치량이 없다면 스테이킹 목록에 추가
        if(_amount > 0 && user.amount == 0) {
        stakingUsers[_pid].push(msg.sender);
        }

        user.exactRewardCal = user.amount * pool.accBNCPerShare / 1e12;
        emit Deposit(msg.sender, _pid, _amount);
    }

    // 일반 출금
    function withdraw(uint256 _pid, uint256 _amount) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(block.timestamp >= pool.stakingEndTime, "Staking period not yet ended"); // 해당 날짜가 지나야 출금 가능
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
    // 긴급 전부 출금 (탈주 닌자)
    function emergencyWithdraw (uint256 _pid) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];

        pool.lpToken.transfer(address(msg.sender), user.amount);
        emit EmergencyWithdraw(msg.sender, _pid, user.amount);

        uint256 pendingReward = user.pendingReward;
        uint256 totalStaked = pool.lpToken.balanceOf(address(this)) - user.amount;
        if(totalStaked > 0 && pendingReward > 0) {
            distributeRewards(_pid, pendingReward, totalStaked);
        }

        user.amount = 0; 
        user.exactRewardCal = 0;
        user.pendingReward = 0;
        _removeUserFromStakingUsers(_pid, msg.sender);
    }

    // 탈주닌자가 쌓고 떠난 리워드 재분배
    function distributeRewards (uint256 _pid, uint256 _reward, uint256 _totalStaked) internal {
        uint256 length = stakingUsers[_pid].length;
        for(uint256 i = 0; i < length; ++i) {
            address userAddress = stakingUsers[_pid][i];
            UserInfo storage stakeUser = userInfo[_pid][userAddress]; // 현재 시점에 스테이킹 중인 유저들
            uint256 userShare = stakeUser.amount * 1e12 / _totalStaked; // 유저 별 스테이크 비율
            stakeUser.pendingReward += _reward * userShare / 1e12; // 유저 별 보상 재분배 (많이 넣은 사람이 더 많이 받게)
        }
        emit DistributeRewards (_pid, _reward, _totalStaked);
    }

    // stakingUsers 배열에서 사용자 제거
    function _removeUserFromStakingUsers(uint256 _pid, address _user) internal {
        uint256 length = stakingUsers[_pid].length;
        for (uint256 i = 0; i < length; i++) {
            if (stakingUsers[_pid][i] == _user) {
                stakingUsers[_pid][i] = stakingUsers[_pid][length - 1];
                stakingUsers[_pid].pop();
                break;
            }
        }
    }

    // 안전 장치 (claimBNC에서 딱 1번 사용)
    function safeBNCTransfer(address _to, uint256 _amount) internal {
        uint256 BNCBal= BNC.balances(address(this)); // 기획 취지에 맞는지 확인
        if (_amount > BNCBal) {
            BNC.transfer(_to, BNCBal);
        } else {
            BNC.transfer(_to, _amount);
        }
    }
    // 쌓인 보상 청구 (스테이킹으로 얻은 보상만 청구)
    function claimBNC(uint256 _pid) public nonReentrant vaildPool(_pid) {
        updatePool(_pid);
        addPendingBNC(_pid, msg.sender);
        UserInfo storage user = userInfo[_pid][msg.sender];
        PoolInfo storage pool = poolInfo[_pid];
        require(block.timestamp >= pool.stakingEndTime, "Staking period not yet ended");
        // 유저가 청구할 수 있는 쌓인 보상이 있다면
        if(user.pendingReward > 0) {
            uint256 amount = user.pendingReward; // amount에 담고
            user.pendingReward = 0; // 0으로 만들고
            safeBNCTransfer(msg.sender, amount); // 담은거 보냄
            
            emit ClaimBNC(msg.sender, _pid, amount);
        }
    }
}