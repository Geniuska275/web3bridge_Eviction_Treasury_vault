// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProposalManager {

    struct Proposal {
        address target;
        uint256 value;
        bytes data;
        bool executed;
        uint256 eta;
    }

    uint256 public proposalCount;

    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(
        uint256 proposalId,
        address target,
        uint256 value
    );

    function createProposal(
        address target,
        uint256 value,
        bytes calldata data,
        uint256 eta
    ) external returns (uint256) {

        proposalCount++;

        proposals[proposalCount] = Proposal({
            target: target,
            value: value,
            data: data,
            executed: false,
            eta: eta
        });

        emit ProposalCreated(proposalCount, target, value);

        return proposalCount;
    }
}