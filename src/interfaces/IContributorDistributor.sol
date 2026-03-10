// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IContributorDistributor {

    function pendingRewards(address user)
        external
        view
        returns (uint256);

    function addReward(address contributor, uint256 amount) external;

    function claim() external;
}