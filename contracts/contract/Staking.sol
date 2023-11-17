// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "../interfaces/IERC20.sol";
import "../utils/Data.sol";
import "./WBNC.sol";
import "./LPToken.sol";
import "./Token.sol";

contract Staking is Ownable, ReentrancyGuard { 
    
    struct UserInfo {
        uint256 amount;
        uint256 exactRewardCal;
        uint256 pendingReward;
        uint256 stakingStartTime;
    }

    struct PoolInfo {
        IERC20 lpToken;
        uint256 allocPoint; 
        uint256 lastRewardBlock; 
        uint256 accBNCPerShare;
        uint256 stakingPoolEndTime;
        uint256 stakingPoolStartTime;
    }

    struct NinjaInfo {
        uint256 totalLPToken; // 탈주자가 총 예치했던 LP수량
        uint256 totalNinjaReward; // 탈주자가 남긴 리워드
        uint256 stakingLeftTime; // 풀에서 떠난 시간 기록
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

    mapping(uint256 => mapping(address => NinjaInfo)) public ninjaInfo;
    
    mapping(uint256 => address[]) public stakingUsers; // 풀별 스테이킹 유저 목록

    uint256 public AlltotalNinjaReward = 0;
    uint256 public totalAllocPoint = 0;
    uint256 public startBlock;
    
    event SetDev0Address(address indexed dev0Addr);
    event UpdateBNCPerBlock(uint256 BNCPerBlock);
    event SetPercent(uint256 stakingPercent, uint256 dev0Percent);
    event Deposit(address indexed user, uint256 indexed pid, uint256 amount, uint256 stakingStartTime);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount); // 일반 출금
    event MaturedWithdrawWithdraw(address user, uint256 pid, uint256 LP, uint256 BNC);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount); // 보상 못받고 자기것만 긴급 출금, 탈주닌자
    event ClaimBNC(address indexed user, uint256 indexed pid, uint256 amount);
    event DistributeRewards (uint256 _pid, uint256 pendingReward, uint256 totalStaked); // 탈주닌자 리워드 처리 기록
    event AddStakingPool (uint256 _allocPoint, address _lpToken, uint256 stakingPoolStartTime, uint256 stakingEndTime); // 스테이킹 풀
    event NinjaLiftInfo(address _Ninja, uint256 _totalLPToken, uint256 _totalNinjaReward, uint256 _stakingLeftTime, uint256 _ninjaRewardRate);
    event MyAllReward(uint256 _pendingBNC, uint256 _userBlockRewardPerBlock, uint256 _estimatedUserRewardFromNinjs);
    modifier vaildPool (uint256 _pid) {
        require(_pid < poolInfo.length, "pool not exist");
        _;
    }

    constructor(
        address _BNCToken, 
        address _dev0Addr, 
        uint256 _dev0Percent,
        uint256 _stakingPercent,
        uint256 _BNCPerBlock,
        uint256 _startBlock,
        address _initialOwner
    ) Ownable(_initialOwner) public {
        BNC = WBNC(_BNCToken);
        dev0Addr = _dev0Addr;
        dev0Percent = _dev0Percent;
        stakingPercent = _stakingPercent;
        BNCPerBlock = _BNCPerBlock;
        startBlock = _startBlock; // 보상 시작 블록
        lastBlockDevWithdraw = _startBlock; // 개발자가 보상을 받기 위한 첫 블록을 기록
    }
    // 블록 당 보상 생성 속도 수정 (오너가)
    function updateBNCPerBlock (uint256 newAmount) public onlyOwner {
        require(newAmount <= 100 * 1e18, "Max per block 100 BNC");
        require(newAmount >= 1 * 1e15, "Min per block 0.001 BNC");
        BNCPerBlock = newAmount;
        emit UpdateBNCPerBlock(BNCPerBlock);
    }
    // 보상 받을 개발자 주소 변경 (오너가)
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
    function withdrawDevFee() public onlyOwner {
        require(lastBlockDevWithdraw < block.number, "wait for new block");
        uint256 BNCReward = (block.number - lastBlockDevWithdraw) * BNCPerBlock;
        BNC._mint(dev0Addr, BNCReward * dev0Percent / percentDec);
        lastBlockDevWithdraw = block.number;
    }
    // 스테이킹 풀 생성 (오너가)
    function addStakingPool (uint256 _allocPoint, address _lpToken, uint256 _endDays) public onlyOwner {
        _checkPoolDuplicate(_lpToken);
        massUpdatePools();
        uint256 lastRewardBlock = block.number < startBlock ? startBlock : block.number;
        totalAllocPoint = totalAllocPoint + _allocPoint;
        uint256 stakingPoolStartTime = block.timestamp;
        uint256 stakingPoolEndTime = block.timestamp + _endDays * 1 days;
        poolInfo.push(
            PoolInfo({
                lpToken : IERC20(_lpToken),
                allocPoint : _allocPoint,
                lastRewardBlock : lastRewardBlock,
                accBNCPerShare : 0, // 누적된 BNC당 주식 값, 처음 생성시는 없으므로 0
                stakingPoolEndTime : 0, // 0으로 설정해놓고
                stakingPoolStartTime : stakingPoolStartTime
            })
        );
        PoolInfo storage pool = poolInfo[poolInfo.length - 1];
        pool.stakingPoolEndTime = stakingPoolEndTime; // 여기서 푸쉬
        emit AddStakingPool(_allocPoint, _lpToken, pool.stakingPoolStartTime, pool.stakingPoolEndTime);
    }
    // 스테이킹 종료 일수 수정 (오너가) 테스트를 위해 seconds로 변경 해놓음 
    function setStakingEndDays(uint256 _pid, uint256 _days) public onlyOwner vaildPool(_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        uint256 endTime = block.timestamp + _days * 1 seconds; // 1days == 86400초
        require(endTime > block.timestamp, "End Time must be in the future");
        pool.stakingPoolEndTime = endTime; // 해당 풀의 종료 시간
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
    function _checkPoolDuplicate(address _lpToken) view internal {
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
    // 사용자의 리워드 업데이트 
    function updatePendingBNC(uint256 _pid, address _user) public vaildPool(_pid) returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accBNCPerShare = pool.accBNCPerShare;
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));

        if(block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 BNCReward = multiplier * BNCPerBlock * pool.allocPoint / totalAllocPoint * stakingPercent / percentDec;
            accBNCPerShare = accBNCPerShare + BNCReward * 1e12 / lpSupply;
        }
        uint256 pendingReward = user.pendingReward + user.amount * accBNCPerShare / 1e12 - user.exactRewardCal;
        user.pendingReward = user.pendingReward + pendingReward;
        return user.pendingReward;
    }
    // 프론트엔드에서 사용자가 보상으로 쌓인 BNC 조회
    function pendingBNC(uint256 _pid, address _user) public vaildPool(_pid) view returns (uint256) {
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
    // 블록당 100개의 토큰의 예상 보상 계산
    function rewardPer100Tokens (uint256 _pid) public view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        uint256 poolRewardPerBlock = BNCPerBlock * pool.allocPoint / totalAllocPoint;
        uint256 totalStakedInPool = pool.lpToken.balanceOf(address(this));
        // 100개 토큰에 대한 예상 보상 계산 (스테이킹 물량이 0일때는 계산 되지 않음)
        // totalStakedInPool 값이 변화될 때마다 보상량은 바뀜 (이 함수가 호출될 때마다)
        uint256 rewardPerTokens = totalStakedInPool > 0 ? poolRewardPerBlock * 1e18 / totalStakedInPool * 100 : 0;
        return rewardPerTokens;
    }
    // 특정 사용자가 풀에서 블록당 받을 수 있는 보상 계산
    function userBlockRewardPerBlock(uint256 _pid, address _user) public view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 poolReward = perBlockReward(_pid);
        uint256 userShare = user.amount * 1e12 / pool.lpToken.balanceOf(address(this));
        uint256 userRewardPerBlock = poolReward * userShare / 1e12;
        return userRewardPerBlock;
    }
    // 해당 풀의 블록당 보상 계산
    function perBlockReward (uint256 _pid) public view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        uint256 poolReward = BNCPerBlock * pool.allocPoint / totalAllocPoint;
        return poolReward;
    }
    // LP토큰 예치 
    function deposit(uint256 _pid, uint256 _amount) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        addPendingBNC(_pid, msg.sender); // 미지급 BNC가 있다면 업데이트

        // 하려는 예치량이 0이상이고 가진 예치량이 없다면 스테이킹 목록에 추가
        if(_amount > 0 && user.amount == 0) {
        stakingUsers[_pid].push(msg.sender);
        }

        if(_amount > 0) {
            IERC20 lpToken = IERC20(pool.lpToken);
            lpToken.transferFrom(msg.sender, address(this), _amount);
            user.amount = user.amount + _amount;
        }

        user.exactRewardCal = user.amount * pool.accBNCPerShare / 1e12;
        // 처음 예치했던 시간 기록
        if(user.stakingStartTime == 0) {
            user.stakingStartTime = block.timestamp;
        }
        emit Deposit(msg.sender, _pid, _amount, user.stakingStartTime);

    }
    // 일반 출금
    function withdraw(uint256 _pid, uint256 _amount) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(block.timestamp >= pool.stakingPoolEndTime, "Staking period not yet ended"); // 해당 날짜가 지나야 출금 가능
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
    // 만기 출금
    function maturedWithdraw(uint256 _pid) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(block.timestamp >= pool.stakingPoolEndTime, "Staking period not yet ended"); // 해당 날짜가 지나야 출금 가능
        updatePool(_pid);
        addPendingBNC(_pid, msg.sender);

        if(user.amount > 0) {
            pool.lpToken.transfer(address(msg.sender), user.amount);
        }
        
        if(user.pendingReward > 0) {
            safeBNCTransfer(msg.sender, user.pendingReward);
        }
        
        user.amount = 0;
        user.pendingReward = 0;
        user.exactRewardCal = 0;
        // user.stakingStartTime = 0;
        
        emit MaturedWithdrawWithdraw(msg.sender, _pid, user.amount, user.pendingReward);
    }
    // 사용자의 보상을 업데이트하는 함수
    function updateUserReward(uint256 _pid, address _user) internal vaildPool(_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];

        uint256 newReward = user.amount * pool.accBNCPerShare / 1e12;
        uint256 pending = newReward - user.exactRewardCal;
        if (pending > 0) {
            user.pendingReward = user.pendingReward + pending;
        }
        user.exactRewardCal = newReward;
    }
    // 긴급 전부 출금 함수
    function emergencyWithdraw(uint256 _pid) public nonReentrant vaildPool(_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];

        updatePendingBNC(_pid, msg.sender);

        uint256 userAmount = user.amount;
        uint256 pendingReward = user.pendingReward;
        uint256 totalStaked = pool.lpToken.balanceOf(address(this)) - userAmount;

        // 탈주자들 기록 저장
        NinjaInfo storage ninja = ninjaInfo[_pid][msg.sender];
        ninja.totalLPToken = userAmount;
        ninja.totalNinjaReward = pendingReward;
        ninja.stakingLeftTime = block.timestamp;

        AlltotalNinjaReward += pendingReward; // 탈주자 총 리워드 저장

        // 탈주자 리워드 비율 계산 및 저장
        uint256 ninjaRewardRate = (pendingReward > 0 && totalStaked > 0)
            ? pendingReward * 1e12 / stakingUsers[_pid].length // 스테이킹 하고 있는 유저의 수
            : 0;
        getLastNinjaRewardInfo(ninjaRewardRate);
        emit NinjaLiftInfo(msg.sender, ninja.totalLPToken, ninja.totalNinjaReward, ninja.stakingLeftTime, ninjaRewardRate);

        // 사용자의 출금 전 출금 가능한 보상이 있는 경우 재분배
        if (totalStaked > 0 && pendingReward > 0) {
            distributeRewards(_pid, pendingReward, totalStaked);
        }

        pool.lpToken.transfer(msg.sender, userAmount);
        emit EmergencyWithdraw(msg.sender, _pid, userAmount);

        user.amount = 0;
        user.pendingReward = 0;
        user.exactRewardCal = 0;
        user.stakingStartTime = 0;

        _removeUserFromStakingUsers(_pid, msg.sender); // 스테이킹 유저 목록에서 사용자 제거
    }
    // 탈주자가 쌓고 떠난 리워드 재분배
    function distributeRewards (uint256 _pid, uint256 _reward, uint256 _totalStaked) internal {
        uint256 length = stakingUsers[_pid].length;
        for (uint256 i = 0; i < length; ++i) {
            address userAddress = stakingUsers[_pid][i];
            UserInfo storage stakeUser = userInfo[_pid][userAddress]; // 스테이킹 중인 유저들 추출
            uint256 userShare = stakeUser.amount * 1e12 / _totalStaked;
            uint256 userReward = _reward * userShare / 1e12;

            stakeUser.pendingReward += userReward; // 보상 분배
        }
        emit DistributeRewards(_pid, _reward, _totalStaked);
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
    // 현재 스테이킹 중인 모든 유저들 조회
    function getStakingUsers(uint256 _pid) public view returns (address[] memory) {
        return stakingUsers[_pid];
    }
    // 마지막 탈주자의 리워드 비율 조회
    function getLastNinjaRewardInfo (uint256 _lasttotalNinjaRewardRate) public pure returns (uint256) {
        return _lasttotalNinjaRewardRate;
    }
    // 모든 탈주자가 남기고 간 총 누적 리워드
    function getAllTotalNinjaReward () public view returns (uint256) {
        return AlltotalNinjaReward;
    }
    // 해당 pool에 누적된 LP당 유저가 받을 수 있는 BNC양 계산
    function getAccBNCPerShareFromUser (uint256 _pid, address _user) public view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];

        uint256 BNCperShareFromUser = user.amount * pool.accBNCPerShare / 1e12;
        return BNCperShareFromUser;
    }
    // 탈주 닌자가 주고 간 예상 보상 (사용자당) 총 누적 된 탈주금
    function estimatedUserRewardFromNinjs(uint256 _pid, address _user) public view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];

        uint256 totalStaked = pool.lpToken.balanceOf(address(this));
        uint256 userShare = user.amount * 1e12 / totalStaked; // 유저의 스테이킹 비율

        // 예상 탈주 닌자 보상 계산
        uint256 estimatedReward = AlltotalNinjaReward * userShare / 1e12;
        return estimatedReward;
    }
    // 안전 장치 (claimBNC에서 딱 1번 사용)
    function safeBNCTransfer(address _to, uint256 _amount) internal {
        uint256 BNCBal= BNC.balances(address(this)); 
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
        require(block.timestamp >= pool.stakingPoolEndTime, "Staking period not yet ended");
        // 유저가 청구할 수 있는 쌓인 보상이 있다면
        if(user.pendingReward > 0) {
            uint256 amount = user.pendingReward; // amount에 담고
            user.pendingReward = 0; // 0으로 만들고
            safeBNCTransfer(msg.sender, amount); // 담은거 보냄
            
            emit ClaimBNC(msg.sender, _pid, amount);
        }
    }
    // 쌓인 리워드 갯수, 블록당 받는 리워드 갯수, 탈주자가 남기고간 리워드 중 내 몫 반환
    function myAllReward (uint256 _pid, address _user) public view returns (uint256, uint256, uint256) {
        uint256 pendingBNCValue = pendingBNC(_pid, _user);
        uint256 userBlockRewardPerBlockValue = userBlockRewardPerBlock(_pid, _user);
        uint256 estimatedUserRewardFromNinjsVlaue = estimatedUserRewardFromNinjs(_pid, _user);

         return (pendingBNCValue, userBlockRewardPerBlockValue, estimatedUserRewardFromNinjsVlaue);
         
    }
}