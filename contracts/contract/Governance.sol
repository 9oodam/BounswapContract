// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";

// 거버넌스 
contract Governance {
    address govToken;
    uint proposalCount;

    // 투표 기간

    // 기간 설정해서 startblock, endblock 추가하고, 투표할 때 endblock 보다 시간 지났으면 투표 불가능하게

    // 제안서 통과되는 최소 투표 수

    // 이벤트 함수
    // 제안서 제출
    // 제안 투표
    // 제안 투표 결과(미달, 통과)

    // 제안
    struct Proposal {
        uint id;
        address proposer;
        uint forVotes;
        uint againstVotes;
        uint startBlock;
        uint endBlock;
        // 추가 작성
        // 사용자 => receipt
        mapping(address => Receipt) receipts;
    }

    // 투표 내용
    struct Receipt {
        bool hasVoted;
        bool support;
    }



    // Proposal 상태
    enum ProposalState {
        Pending,
        Active, // 투표 중
        Canceled // 취소
        // Defeated, // 투표 ㄴ
        // Succeeded, // 투표 ㅇㅋ 
        // Queued, // 대기중(실행되기 전 상태 같음)
        // Expired, // 만료됨
        // Executed // 실행됨
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

    constructor(address _govToken) {
        govToken = _govToken;
    }

    // 투표 기간
    // 15초에 블록 하나 생성된다고 가정할 때 7일
    function votingPeriod() public pure returns (uint) { return 40_320; }

    // 의제 제출
    function propose(address _proposer) public {
        // 의제 제출에 필요한 거버넌스 토큰 있는지 확인
        require(Token(govToken).balanceOf(_proposer) >= 1, "govToken");
        
        proposalCount++;
        Proposal storage proposal = proposals[proposalCount];
        proposal.id = proposalCount;
        proposal.proposer = _proposer;
        proposal.startBlock = block.number;
        proposal.endBlock = block.number + votingPeriod();
        // proposal.forVotes = 0;
        // proposal.againstVotes = 0;

        // 거버넌스 토큰 burn
        Token(govToken)._burn(_proposer, 1);
    }

    // 제안서 반환
    function getProposal(uint _id) external view returns (uint, address, uint, uint) {
        return (proposals[_id].id, proposals[_id].proposer, proposals[_id].forVotes, proposals[_id].againstVotes);
    }

    // // 제안서 목록 반환
    // function getProposals() external view returns (Proposal[] memory) {
    //     return proposals;
    // }

    // 투표하기
    function vote(uint _id, address voter, bool _support) external lock {
        uint256 voterBalance = Token(govToken).balanceOf(voter);
        require(voterBalance >= 1, "govToken");
        
        // 투표 가능한 기간인지 확인

        require(proposals[_id].receipts[voter].hasVoted == false, "already voted");

        if (_support) {
            proposals[_id].forVotes += voterBalance;    
        } else {
            proposals[_id].againstVotes += voterBalance;    
        }
        
        proposals[_id].receipts[voter].hasVoted = true;
        proposals[_id].receipts[voter].support = _support;

        // 투표하는 계정의 모든 거버넌스 토큰 burn
        Token(govToken)._burn(voter, voterBalance);
    }
}