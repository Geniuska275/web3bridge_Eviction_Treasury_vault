// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AuthorizationManager {

    address public governance;

    mapping(address => bool) public authorizedExecutors;

    modifier onlyGovernance() {
        require(msg.sender == governance, "Not governance");
        _;
    }

    modifier onlyAuthorized() {
        require(
            msg.sender == governance || authorizedExecutors[msg.sender],
            "Not authorized"
        );
        _;
    }

    constructor(address _governance) {
        governance = _governance;
    }

    function setExecutor(address executor, bool allowed)
        external
        onlyGovernance
    {
        authorizedExecutors[executor] = allowed;
    }
}