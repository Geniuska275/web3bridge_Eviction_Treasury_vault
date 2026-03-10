// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimelockController {

    uint256 public constant MIN_DELAY = 2 days;

    function validateExecution(uint256 eta) external view {
        require(block.timestamp >= eta, "Timelock not expired");
    }

}