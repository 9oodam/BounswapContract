// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contract/Token.sol";

// 거버넌스 
contract Governance {
    address private govToken;
    uint private proposalCount;

    // 투표 기간 7일
    uint private votingPeriod = 1 days; 

    // 제안
    struct Proposal {
        uint id;
        address proposer;
        bytes title;
        bytes description;
        uint quorumVotes;
        uint forVotes;
        uint againstVotes;
        uint startTime;
        uint endTime;
        ProposalState state;
    }

    // 제안 id => 사용자 => receipt
    mapping(uint => mapping(address => Receipt)) private receipts;

    // 투표 내용
    struct Receipt {
        bool hasVoted;
        bool support;
        uint votes;
    }

    // Proposal 상태
    enum ProposalState {
        Active, // 투표 중
        Defeated, // 투표 통과 X
        Succeeded // 투표 통과 O
    }

    // 제안 배열
    mapping (uint => Proposal) public proposals;

    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, "LOCKED");
        unlocked = 0;
        _;
        unlocked = 1;
    }   

    /// @notice 의제 제출했을 때 발생하는 이벤트
    /// @param id 제안서 id
    /// @param proposer 제출자
    /// @param quorumVotes 최소 찬성 투표 수 
    /// @param startTime 제출 시각
    /// @param endTime 투표 마감 시간
    /// @param state 제안 상태 (0 : 투표 중, 1 : 투표 통과 X, 2 : 투표 통과 O)
    /// @param contents 제안 내용. contents[0] = "title", contents[1] = "description"
    event ProposalCreated(uint id, address proposer, uint quorumVotes, uint startTime, uint endTime, ProposalState state, bytes[] contents);

    /// @notice 투표했을 때 발생하는 이벤트
    /// @param voter 투표한 사용자 address 
    /// @param proposalId 제안서 id
    /// @param support 해당 의제 지지 여부
    /// @param votes 투표에 참여한 거버넌스 토큰의 양
    event VoteCast(address voter, uint proposalId, bool support, uint votes);

    /// @notice 제안서 상태 변경되었을 때 (투표 결과 나왔을 때) 발생하는 이벤트
    /// @param id 제안서 id
    /// @param state 제안 상태 (0 : 투표 중, 1 : 투표 통과 X, 2 : 투표 통과 O)
    event ProposalStateChange(uint id, ProposalState state);

    /// @notice governance 컨트랙트 생성자 함수
    /// @param _govToken 거버넌스 토큰 CA address
    constructor(address _govToken) {
        govToken = _govToken;
    }
    
    /// @notice 의제 제출하는 메서드
    /// @param _proposer 제출자 address
    /// @param contents 제안서 내용. contents[0] = "제안서 제목 (title)", contents[1] = "제안서 설명 (description)"
    function propose(address _proposer, bytes[] memory contents) public {
        // 의제 제출에 필요한 거버넌스 토큰 있는지 확인
        require(Token(govToken).balanceOf(_proposer) >= 1, "govToken");
        
        proposalCount++;
        // 최소 찬성 투표수 계산(현재 거버넌스 토큰 발행량의 10%)
        uint quorumVotes = Token(govToken).totalSupply() / 10;

        Proposal memory proposal = Proposal(proposalCount, _proposer, contents[0], contents[1], quorumVotes, 0, 0, block.timestamp, block.timestamp + votingPeriod, ProposalState.Active);
        proposals[proposalCount] = proposal;
        receipts[proposalCount][_proposer].hasVoted = true;
        receipts[proposalCount][_proposer].support = true;

        // 거버넌스 토큰 burn
        Token(govToken)._burn(_proposer, 1 * (10**18));

        emit ProposalCreated(proposal.id, _proposer, proposal.quorumVotes, proposal.startTime, proposal.endTime, proposal.state, contents);
    }

    /// @notice 의제(제안서) 목록 반환하는 메서드
    /// @return Proposal 배열 Proposal : (id, proposer (제출자), title, description, quorumVotes (최소 찬성 투표수), forVotes (찬성 투표 수), againstVotes (반대 투표 수), startTime, endTime, state (0 : 투표중, 1 : 투표 통과 X, 2 : 투표 통과 O))
    function getProposals() external view returns (Proposal[] memory) {
        Proposal[] memory proposalArr = new Proposal[](proposalCount);
        for (uint i = 1; i <= proposalCount; i++) {
            proposalArr[i - 1] = proposals[i];
        }
        return proposalArr;
    }

    /// @notice 해당 제안서 투표 내역 반환하는 메서드
    /// @param _id 제안서 id
    /// @param voter 투표한 address
    /// @return 투표 내역 (hasVoted : 투표 여부, support : 찬반 여부, votes : 투표에 참여한 거버넌스 토큰의 양)
    function getReceipt(uint _id, address voter) external view returns (Receipt memory) {
        return receipts[_id][voter];
    }
    
    /// @notice 투표하는 메서드
    /// @param _id 제안서 id
    /// @param voter 투표할 사용자 address
    /// @param _support 해당 의제 지지 여부
    function vote(uint _id, address voter, bool _support) external lock returns (bool) {
        uint256 voterBalance = Token(govToken).balanceOf(voter);
        require(voterBalance > 0, "govToken");
        state(_id);
        // 투표 가능한 제안인지 확인
        if (proposals[_id].state != ProposalState.Active) {
            return false;
        }
        // 투표 여부 확인
        if (receipts[_id][voter].hasVoted == true) {
            return false;
        }

        if (_support) {
            proposals[_id].forVotes += voterBalance;    
        } else {
            proposals[_id].againstVotes += voterBalance;    
        }
        
        receipts[_id][voter].hasVoted = true;
        receipts[_id][voter].support = _support;
        receipts[_id][voter].votes = voterBalance;

        // 투표하는 계정의 모든 거버넌스 토큰 burn
        Token(govToken)._burn(voter, voterBalance);

        emit VoteCast(voter, _id, _support, voterBalance);
        return true;
    }

    /// @notice 제안서 상태 변경하는 메서드
    /// @param _id 변경할 제안서 id
    function state(uint _id) internal returns (bool) {
        Proposal storage proposal = proposals[_id];
        if (proposal.state != ProposalState.Active || block.timestamp <= proposal.endTime) {
            return false;
        }
        if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < proposal.quorumVotes) {
            proposal.state = ProposalState.Defeated; 
            emit ProposalStateChange(_id, ProposalState.Defeated);
            return true;
        } else {
            proposal.state = ProposalState.Succeeded;
            emit ProposalStateChange(_id, ProposalState.Succeeded);
            return true;
        }
    }

}