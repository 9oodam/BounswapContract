// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./GovToken.sol";

// 거버넌스 
contract Governance {
    address private govToken;
    uint private proposalCount;

    // 임의로 설정
    // 투표 기간
    // 15초에 블록 하나 생성된다고 가정할 때 7일
    uint private votingPeriod = 40_320;    

    // 임의로 설정
    // 제안서 통과되는 최소 투표 수
    uint private quorumVotes = 100;    

    // 제안
    struct Proposal {
        uint id;
        address proposer;
        uint forVotes;
        uint againstVotes;
        uint startBlock;
        uint endBlock;
        ProposalState state;
        // 추가 작성
        // // 사용자 => receipt
        // mapping(address => Receipt) receipts;
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
    Proposal[] private proposals;

    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }   

    // 제안서 제출했을때
    event ProposalCreated(uint id, address proposer, uint startBlock, uint endBlock, ProposalState state, string[] contents);

    // 투표했을때
    event VoteCast(address voter, uint proposalId, bool support, uint votes);

    // 투표 결과 나왔을때
    event ProposalStateChange(uint id, ProposalState state);

    constructor(address _govToken) {
        govToken = _govToken;
    }

    
    // 의제 제출
    function propose(address _proposer, string[] memory contents) public {
        // 의제 제출에 필요한 거버넌스 토큰 있는지 확인
        require(GovToken(govToken).balanceOf(_proposer) >= 1, "govToken");
        
        proposalCount++;
        Proposal storage proposal = proposals[proposalCount];
        proposal.id = proposalCount;
        proposal.proposer = _proposer;
        proposal.startBlock = block.number;
        proposal.endBlock = block.number + votingPeriod;
        proposal.state = ProposalState.Active;
        // proposal.forVotes = 0;
        // proposal.againstVotes = 0;

        // 거버넌스 토큰 burn
        GovToken(govToken).burn(_proposer, 1);

        emit ProposalCreated(proposal.id, _proposer, proposal.startBlock, proposal.endBlock, proposal.state, contents);
    }

    // // 제안서 반환
    // function getProposal(uint _id) external view returns (Proposal memory) {
    //     return (proposals[_id]);
    // }

    // 제안서 목록 반환
    function getProposals() external view returns (Proposal[] memory) {
        return proposals;
    }

    // 투표 여부 반환
    function getReceipt(uint _id, address voter) public view returns (Receipt memory) {
        // return proposals[_id].receipts[voter];
        return receipts[_id][voter];
    }


    // 투표하기
    function vote(uint _id, address voter, bool _support) external lock {
        uint256 voterBalance = GovToken(govToken).balanceOf(voter);
        require(voterBalance > 0, "govToken");
        state(_id);
        // 투표 가능한 제안인지 확인
        require(proposals[_id].state == ProposalState.Active, "state");
        // 투표 여부 확인
        // require(proposals[_id].receipts[voter].hasVoted == false, "already voted");
        require(receipts[_id][voter].hasVoted == false, "already voted");

        if (_support) {
            proposals[_id].forVotes += voterBalance;    
        } else {
            proposals[_id].againstVotes += voterBalance;    
        }
        
        // proposals[_id].receipts[voter].hasVoted = true;
        // proposals[_id].receipts[voter].support = _support;
        receipts[_id][voter].hasVoted = true;
        receipts[_id][voter].support = _support;
        receipts[_id][voter].votes = voterBalance;

        // 투표하는 계정의 모든 거버넌스 토큰 burn
        GovToken(govToken).burn(voter, voterBalance);

        emit VoteCast(voter, _id, _support, voterBalance);
    }

    // 제안서 상태 변경
    function state(uint _id) internal returns (bool) {
        Proposal storage proposal = proposals[_id];
        if (proposal.state != ProposalState.Active || block.number <= proposal.endBlock) {
            return false;
        }

        if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes) {
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