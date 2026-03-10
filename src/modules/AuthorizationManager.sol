

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract AuthorizationManager is AccessControl {

    bytes32 public constant EXECUTOR_ROLE = keccak256("EXECUTOR_ROLE");

    constructor(address governance) {

        _grantRole(DEFAULT_ADMIN_ROLE, governance);
        _grantRole(EXECUTOR_ROLE, governance);
    }

    function addExecutor(address executor)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _grantRole(EXECUTOR_ROLE, executor);
    }

    function removeExecutor(address executor)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _revokeRole(EXECUTOR_ROLE, executor);
    }
}