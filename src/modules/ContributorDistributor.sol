// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract ContributorDistributor is ReentrancyGuard {

    mapping(address => uint256) public pendingRewards;
    event RewardClaimed(address user, uint256 amount);

    function claim() external nonReentrant {

        uint256 reward = pendingRewards[msg.sender];

        require(reward > 0, "No reward");

        pendingRewards[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: reward}("");
        require(success, "Transfer failed");

        emit RewardClaimed(msg.sender, reward);
    }
}