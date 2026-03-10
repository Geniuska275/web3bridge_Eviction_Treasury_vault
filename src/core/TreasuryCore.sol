
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IAuthorizationManager.sol";
import "../interfaces/IProposalManager.sol";
import "../interfaces/ITimelockController.sol";

contract TreasuryCore {

    IAuthorizationManager public auth;
    IProposalManager public proposalManager;
    ITimelockController public timelock;

    constructor(
        address _auth,
        address _proposalManager,
        address _timelock
    ) {
        auth = IAuthorizationManager(_auth);
        proposalManager = IProposalManager(_proposalManager);
        timelock = ITimelockController(_timelock);
    }

    receive() external payable {}

    function executeProposal(uint256 proposalId) external {

        require(
            auth.authorizedExecutors(msg.sender),
            "Not executor"
        );

        (
            address target,
            uint256 value,
            bytes memory data,
            bool executed,
            uint256 eta
        ) = proposalManager.proposals(proposalId);

        require(!executed, "Already executed");

        timelock.validateExecution(eta);

        (bool success,) = target.call{value:value}(data);

        require(success, "Execution failed");
    }
}