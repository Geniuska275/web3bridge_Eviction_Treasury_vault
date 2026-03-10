// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAuthorizationManager {

    function governance() external view returns (address);

    function authorizedExecutors(address executor)
        external
        view
        returns (bool);

    function setExecutor(address executor, bool allowed) external;
}