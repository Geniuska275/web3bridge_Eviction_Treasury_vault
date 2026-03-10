// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IProposalManager {

    struct Proposal {
        address target;
        uint256 value;
        bytes data;
        bool executed;
        uint256 eta;
    }

    function proposalCount() external view returns (uint256);

    function proposals(uint256 id)
        external
        view
        returns (
            address target,
            uint256 value,
            bytes memory data,
            bool executed,
            uint256 eta
        );

    function createProposal(
        address target,
        uint256 value,
        bytes calldata data,
        uint256 eta
    ) external returns (uint256);
}