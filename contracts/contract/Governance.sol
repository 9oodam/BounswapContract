// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Token.sol";

// 거버넌스 
contract Governance {
    address private govToken;
    uint private proposalCount;

    // 투표 기간 7일
    // uint private votingPeriod = 7 days; 
    uint private votingPeriod = 2 minutes; 

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

    // 제안서 제출했을때
    event ProposalCreated(uint id, address proposer, uint quorumVotes, uint startTime, uint endTime, ProposalState state, bytes[] contents);

    // 투표했을때
    event VoteCast(address voter, uint proposalId, bool support, uint votes);

    // 투표 결과 나왔을때
    event ProposalStateChange(uint id, ProposalState state);

    constructor(address _govToken) {
        govToken = _govToken;
    }
    
    // 의제 제출
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

    function getProposals() external view returns (Proposal[] memory) {
        Proposal[] memory proposalArr = new Proposal[](proposalCount);
        for (uint i = 1; i <= proposalCount; i++) {
            proposalArr[i - 1] = proposals[i];
        }
        return proposalArr;
    }

    function getReceipt(uint _id, address voter) external view returns (Receipt memory) {
        return receipts[_id][voter];
    }
    
    // 투표하기
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

    // 제안서 상태 변경
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