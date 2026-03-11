
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IAuthorizationManager.sol";
import "../interfaces/IProposalManager.sol";
import "../interfaces/ITimelockController.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract TreasuryCore is AccessControl {

    IAuthorizationManager public auth;
    IProposalManager public proposalManager;
    ITimelockController public timelock;
    bytes32 public constant EXECUTOR_ROLE = keccak256("EXECUTOR_ROLE");

    constructor(
         address governance,
        address _proposalManager,
        address _timelock
        
    ) {
          _grantRole(DEFAULT_ADMIN_ROLE, governance);
        _grantRole(EXECUTOR_ROLE, governance);
         proposalManager = IProposalManager(_proposalManager);
        timelock = ITimelockController(_timelock);
    }

        receive() external payable {}

    function executeProposal(uint256 proposalId)
        external
        onlyRole(EXECUTOR_ROLE)
    {

        (
            address target,
            uint256 value,
            bytes memory data,
            bool executed,
            uint256 eta
        ) = proposalManager.proposals(proposalId);

        require(!executed, "Already executed");

        timelock.validateExecution(eta);

        (bool success,) = target.call{value: value}(data);
        require(success, "Execution failed");
    }


}