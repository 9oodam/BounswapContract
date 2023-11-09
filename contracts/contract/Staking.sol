// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Staking is Ownable {

    struct UserInfo {
        uint256 amount;
        uint256 exactReward;
        uint256 pendingReward;
    }

    struct PoolInfo {
        ????? lptoken // lp 토큰 주소 넣어야 함
        uint256 allocPoint; // 넣을지 뺼지 결정해야 함. (기획)
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

    uint256 public dev0Addr;
    uint256 public dev1Addr;
    uint256 public dev2Addr;
    uint256 public dev3Addr;
    uint256 public dev4Addr;

    uint256 public BNCPerBlock; 
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
        startBlock = _startBlock;
        lastBlockDevWithdraw = _startBlock; // 개발자가 보상을 받기 위한 첫 블록을 기록
    }

    // LP 풀의 숫자 확인 
    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }
    
    // 개발자가 쌓인 수수료 출금
    function withdrawDevFee() public {
        require(lastBlockDevWithdraw < block.number, "wait for new block");
        BNCReward = (block.number - lastBlockDevWithdraw).mul(BNCPerBlock);

        BNC.mint(dev0Addr, BNCReward.mul(dev0Percent).div(percentDec));
        BNC.mint(dev1Addr, BNCReward.mul(dev1Percent).div(percentDec));
        BNC.mint(dev2Addr, BNCReward.mul(dev2Percent).div(percentDec));
        BNC.mint(dev3Addr, BNCReward.mul(dev3Percent).div(percentDec));
        BNC.mint(dev4Addr, BNCReward.mul(dev4Percent).div(percentDec));

        lastBlockDevWithdraw = block.number;
    }

    // 소유자가 스테이킹 풀 생성
    function add(uint256 _allocPoint, ???? _lptoken) public onlyOwner {
        _checkPoolDuplicate(_lptoken);


    }

    // 같은 LP토큰으로 2번이상 풀이 생성되는 것을 방지
    function _checkPoolDuplicate(???? _lptoken) view internal {
        uint256 length == poolInfo.length;
        for(uint256 pid = 0; pid < length; pid++) {
            require(poolInfo[pid].lptoken != _lptoken, "pool existed");
        }
    }

    







}



// LP토큰을 스테이킹하여 자체토큰 BNC를 보상을 받는다.
// 자체 BNC토큰 단일 페어 스테이킹하여 BNC토큰을 보상 받는다.