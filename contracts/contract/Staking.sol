// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IERC20.sol";

contract Staking is Ownable { 

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
    
    ????? public BNC; // BNC로 보상받게 해야함, WBNC 로직 이해 필요
    uint256 public percentDec = 10000;
    uint256 public stakingPercent;

    uint256 public dev0Percent;
    uint256 public dev1Percent;
    uint256 public dev2Percent;
    uint256 public dev3Percent;
    uint256 public dev4Percent;

    address public dev0Addr;
    address public dev1Addr;
    address public dev2Addr;
    address public dev3Addr;
    address public dev4Addr;

    uint256 public BNCPerBlock; 

    uint256 public BONUS_MULTIPLIER = 1; 

    uint256 public lastDevBlockWithdraw;

    PoolInfo[] public poolInfo;

    mapping(uint256 => mapping(address => UserInfo)) public userInfo;
    
    uint256 public totalocPoint = 0;
    uint256 public startBlock;

	// 사용할 이벤트 정리
    // indexed 파라미터 3개가 최대라서 나눔
    event SetDev012Address(address indexed dev0Addr, address indexed dev1Addr, address indexed dev2Addr);
    event SetDev34Address(address indexed dev3Addr, address indexed dev4Addr);

    event UpdateBNCPerBlock(uint256 BNCPerBlock);
    event SetPercent(uint256 stakingPercent, uint256 dev0Percent, uint256 dev1Percent, uint256 dev2Percent, uint256 dev3Percent, uint256 dev4Percent);
    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount); // 쌓인 리워드 받으면서 출금하는 일반 출금
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount); // 보상 못받고 자기것만 긴급 출금, 탈주닌자
    event ClaimBNC(address indexed user, uint256 indexed pid, uint256 amount);
    
    modifier vaildPool (uint256 _pid) {
        require(_pid < poolInfo.length, "pool not exist");
        _;
    }

    constructor(
        ?????? _BNCToken, 
        address _dev0Addr, 
        address _dev1Addr, 
        address _dev2Addr, 
        address _dev3Addr, 
        address _dev4Addr, 
        uint256 _dev0Percent,
        uint256 _dev1Percent,
        uint256 _dev2Percent,
        uint256 _dev3Percent,
        uint256 _dev4Percent,
        uint256 _stakingPercent,
        uint256 _BNCPerBlock,
        uint256 _startBlock,
    ) public {
        BNC = _BNCToken;
        dev0Addr = _dev0Addr;
        dev1Addr = _dev1Addr;
        dev2Addr = _dev2Addr;
        dev3Addr = _dev3Addr;
        dev4Addr = _dev4Addr;
        dev0Percent = _dev0Percent;
        dev1Percent = _dev1Percent;
        dev2Percent = _dev2Percent;
        dev3Percent = _dev3Percent;
        dev4Percent = _dev4Percent;
        stakingPercent = _stakingPercent;
        BNCPerBlock = _BNCPerBlock;
        startBlock = _startBlock; // 보상 시작 블록
        lastBlockDevWithdraw = _startBlock; // 개발자가 보상을 받기 위한 첫 블록을 기록
    }
    
    // 블록 당 보상 생성 속도 정의 (오너가)
    function updateBNCPerBlock (uint256 newAmount) public onlyOwner {
        // 한 블록당 최대 생성 100
        require(newAmount <= 100 * 1e18, "Max per block 100 BNC");
        require(newAmount >= 1 * 1e15, "Min per block 0.001 BNC");
        BNCperBlock = newAmount;
        emit UpdateBNCPerBlock(BNCperBlock);
    }

    // 개발자 주소 세팅 (오너가)
    function setDevAddress(address _dev0Addr, address _dev1Addr, address _dev2Addr, address _dev3Addr, address _dev4Addr) public onlyOwner {
        require(_dev0Addr != address(0) && _dev1Addr != address(0) && _dev2Addr != address(0) && _dev3Addr != address(0) && _dev4Addr != address(0), "Zero");
        dev0Addr = _dev0Addr;
        dev1Addr = _dev1Addr;
        dev2Addr = _dev2Addr;
        dev3Addr = _dev3Addr;
        dev4Addr = _dev4Addr;
        emit SetDev012Address(dev0Addr, dev1Addr, dev2Addr);
        emit SetDev34Address(dev3Addr, dev4Addr)
    }

    // 각각의 주체가 받을 퍼센트 정의 (오너가)
    function setPercent (uint256 _stakingPercent, uint256 _dev0Percent, uint256 _dev1Percent, uint256 _dev2Percent, uint256 _dev3Percent, uint256 _dev4Percent) public onlyOwner {
        uint256 devPercent = _dev0Percent.add(_dev1Percent).add(_dev2Percent).add(_dev3Percent).add(_dev4Percent);
        // percentDec === 100%(10000), stakingPercent + devPercent가 percentDec이하로 설정되어야만 함
        require(_stakingPercent.add(devPercent) <= percentDec, "Percent Sum");
        stakingPercent = _stakingPercent;
        dev0Percent = _dev0Percent;
        dev1Percent = _dev1Percent;
        dev2Percent = _dev2Percent;
        dev3Percent = _dev3Percent;
        dev4Percent = _dev4Percent;
        emit SetPercent(stakingPercent, dev0Percent, dev1Percent, dev2Percent, dev3Percent, dev4Percent);
    }

    // 이 함수를 호출할 때마다 설정한 Percent만큼 민팅되어 각각의 개발자 주소에 저장됌
    function withdrawDevFee() public {
        require(lastBlockDevWithdraw < block.number, "wait for new block");
        // ex) 5 - 3 * 100 = 200
        BNCReward = (block.number - lastBlockDevWithdraw).mul(BNCPerBlock);
        // dev0's BNC = 200 BNC * 2500 / 10000 = 50 BNC
        // dev1's BNC = 200 BNC * 2500 / 10000 = 50 BNC
        // dev2's BNC = 200 BNC * 2000 / 10000 = 40 BNC
        // dev3's BNC = 200 BNC * 1500 / 10000 = 30 BNC
        // dev4's BNC = 200 BNC * 1500 / 10000 = 30 BNC
        BNC.mint(dev0Addr, BNCReward.mul(dev0Percent).div(percentDec));
        BNC.mint(dev1Addr, BNCReward.mul(dev1Percent).div(percentDec));
        BNC.mint(dev2Addr, BNCReward.mul(dev2Percent).div(percentDec));
        BNC.mint(dev3Addr, BNCReward.mul(dev3Percent).div(percentDec));
        BNC.mint(dev4Addr, BNCReward.mul(dev4Percent).div(percentDec));
        // 보상 받았으니까 현재 블록으로 초기화
        lastBlockDevWithdraw = block.number;
    }

    // 스테이킹 풀 생성 (오너가)
    function addStakingPool (uint256 _allocPoint, IBEP20 _lpToken) public onlyOwner {
        // 동일한 LP토큰이 있는지 검사
        _checkPoolDuplicate(_lpToken);
        // 전체 스테이킹 풀 업데이트
        massUpdatePools();
        // 마지막 보상 블록을 현재 블록 번호와 시작 블록 중 더 큰 값으로 설정
        // 이더리움 네트워크에서 생성되고있는 많은 블록중에 스테이킹이 시작된 블록을 설정해야 하기 때문.
        uint256 lastRewardBlock = block.number < startBlock ? startBlock : block.number;
        // 총 할당 포인트에 이 풀에 대한 할당 포인트를 추가
        // 단 하나의 풀만 생성된다면 그 풀이 100%를 할당받음
        // 만약 다른 풀이 추가 된다면 그 풀과 할당 포인트를 비교하여 나눠서 받음 
        // ex) A : 10, B : 20 Total = 30 / A : 10/30 = 33.33% B : 20/30 = 66.67%
        uint256 totalAllocPoint = totalAllocPoint.add(_accocPoint);
        // PoolInfo에 push
        poolInfo.push(
            PoolInfo({
                lpToken = _lpToken,
                allocPoint = _allocPoint,
                lastRewardBlock = lastRewardBlock,
                accBNCPerShare = 0; // 누적된 BNC당 주식 값, 처음 생성시는 없으므로 0
            })
        );
    }

    // LP 풀의 갯수 확인 
    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

    // 해당 풀의 BNC 할당 점수 업데이트 (오너가)
    function set(uint256 _pid, uint256 _allocPoint) public onlyOwner validPool(_pid) {
        massUpdatePools();
        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
        poolInfo[_pid].allocPoint = _allocPoint;
    }

    // 같은 LP토큰으로 2번이상 풀이 생성되는 것을 방지, pid = Pool ID
    function _checkPoolDuplicate(IBEP20 _lpToken) view internal {
        uint256 length == poolInfo.length;
        for(uint256 pid = 0; pid < length; ++pid) {
            require(poolInfo[pid].lpToken != _lpToken, "pool existed");
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
        // Pool Id를 기반으로 원하는 풀을 검색
        PoolInfo storage pool = poolInfo[_pid];
        // 현재 블록까지의 보상을 계산했다면 종료
        if(block.number <= pool.lastRewardBlock) {
            return;
        }
        // Pool에 스테이킹된 LP토큰의 총 잔액을 가져옴
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        // Pool에 스테이킹된 LP토큰이 없다면 lastRewardBlock를 현재 블록으로 업데이트하고 종료
        if(lpSupply <= 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        // lastRewardBlock을 통해 해당 풀에 대한 보상이 마지막으로 처리된 시점을 추적
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        // BNCReward 계산(차례대로 계산됌), BNCPerBlock * allocPoint / totalAllocPoint * stakingPercent / percentDec
        uint256 BNCReward = multiplier.mul(BNCPerBlock).mul(pool.allocPoint).div(totalAllocPoint).mul(stakingPercent).div(percentDec);
        // 계산된 BNCReward를 사용자에게 분배하기 위해 CA 자체에 민팅. ???
        BNC.mint(address(this), BNCReward);
        // 풀에 누적된 LC 당 주식을 업데이트(각 LP토큰이 받을 수 있는 BNC의 양)
        // 솔리디티는 소수점을 지원하지 않기 때문에 1e12로 확장하여 소수점 이하의 BNC 토큰도 계산할 수 있게 한다.
        pool.accBNCPerShare = pool.accBNCPerShare.add(BNCReward.mul(1e12).div(lpSupply));
        // lastRewardBlock를 현재 블록 번호로 업데이트
        pool.lastRewardBlock = block.number;
    }

    // 보상을 계산하기 위해 사용, _from과 _to는 블록 범위
    // BONUS_MULTIPLIER = 1로 설정되어 있음, 개발의 목적(프로모션, 이벤트 등)에 따라 설정 바꿀 수 있음
    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        return _to.sub(_from).mul(BONUS_MULTIPLIER);
    }

    // 프론트엔드에서 사용자가 보상으로 쌓인 BNC 조회
    function pendingBNC(uint256 _pid, address _user) public view vaildPool(_pid) returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accBNCPerShare = pool.accBNCPerShare;
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));

        // 현재 블록 번호가 풀의 마지막 보상 블록보다 크고, LP 토큰의 공급량이 0이 아닌 경우 누적된 BNC당 주식(accLCPerShare) 업데이트
        if(block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 BNCReward = multiplier.mul(BNCPerBlock).mul(pool.allocPoint).div(totalAllocPoint).mul(stakingPercent).div(percentDec);
            accBNCPerShare = accBNCPerShare.add(BNCReward.mul(1e12).div(lpSupply));
        }
        return user.pendingReward.add(user.amount.mul(accBNCPerShare).div(1e12).sub(user.exactRewardCal));
    }

    // 사용자가 풀에서 자신의 몫을 정확하게 받도록 하게 하는 함수
    function addPendingBNC(uint256 _pid, address _user) internal validPool (_pod) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        // 사용자가 받을 미지급 BNC양 계산
        uint256 pending = user.amount.mul(pool.accBNCPerShare).div(1e12).sub(user.exactRewardCal);
        // 만약 미지급 BNC가 0보다 크면(사용자가 보상을 받을 잔여 BNC가 있다면)
        if (pending > 0 ) {
            // 해당 사용자 스토리지에 추가
            user.pendingReward = user.pendingReward.add(pending);
        }
    }
    
    // LP토큰 예치 
    // nonReentrant : 중복 호출 방지를 위한 안전 장치
    function deposit(uint256 _pid, uint256 _amount) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        addPendingBNC(_pid, msg.sender); // 미지급 BNC가 있다면 업데이트

        // 실제로 예치할 금액이 있으면, 이전 후 잔고 업데이트
        if(_amount > 0) {
            pool.lpToken.transferFrom(address(msg.sender), address(this), _amount);
            user.amount = user.amount.add(_amount);
        }

        // 사용자 보상 부채 업데이트
        user.exactRewardCal = user.amount.mul(pool.accBNCPerShare).div(1e12);
        // 누가 어느 풀에 얼마를 기록했는지 
        emit Deposit(msg.sender, _pid, _amount);
    }

    // 일반 출금
    function withdraw(uint256 _pid, uint256 _amount) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        addPengdingBNC(_pid, msg.sender);

        if(_amount > 0) {
            user.amount = user.amount.sub(_amount);
            pool.lpToken.transfer(address(msg.sender), _amount);
        }
        user.exactRewardCal = user.amount.mul(pool.accBNCPerShare).div(1e12);
        
        emit Withdraw(msg.sender, _pid, _amount);
    }

    // 긴급 전부 출금 (탈주 닌자 처리 필요)
    function emergencyWithdraw (uint256 _pid) public nonReentrant vaildPool (_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];

        pool.lpToken.transfer(address(msg.sender), user.amount);
        emit EmergencyWithdraw(msg.sender, _pid, user.amount);

        // 탈주에 대한 리워드, 수정 필요
        user.amount = ???; 
        user.exactRewardCal;
        user.pendingReward = ???;
    }

    // 안전 장치 (claimBNC에서 딱 1번 사용)
    function safeBNCTransfer(address _to, uint256 _amount) internal {
        uint256 BNCBal= BNC.balanceOf(address(this));
        // 잔액이 유저가 요청한 잔액보다 부족할 경우 CA에 있는 잔액 전부 해당 유저에게 송금
        if (_amount > BNCBal) {
            BNC.transfer(_to, BNCBal);
        } else {
            BNC.transfer(_to, _amount);
        }
    }

    // 쌓인 보상 청구 (스테이킹으로 얻은 보상만 청구)
    function claimBNC(uint256 _pid) public nonReetrant valiPool(_pid) {
        updatePool(_pid);
        addPendingBNC(_pid, msg.sender);
        UserInfo storage user = userInfo[_pid][msg.sender];
        // 유저가 청구할 수 있는 쌓인 보상이 있다면
        if(user.pendingReward > 0) {
            uint256 amount = user.pendingReward;
            user.pendingReward = 0; 
            safeBNCTransfer(msg.sender, amount);
            
            emit ClaimBNC(msg.sender, _pid, amount);
        }
    }
}