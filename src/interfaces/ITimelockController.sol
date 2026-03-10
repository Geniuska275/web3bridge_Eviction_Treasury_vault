// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITimelockController {

    function MIN_DELAY() external view returns (uint256);

    function validateExecution(uint256 eta) external view;
}