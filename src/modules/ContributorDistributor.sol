//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

pragma solidity ^0.8.20;

contract ContributorDistributor is ReentrancyGuard {

    mapping(address => uint256) public pendingRewards;

    event RewardAdded(address contributor, uint256 amount);
    event RewardClaimed(address contributor, uint256 amount);

    function addReward(address contributor, uint256 amount) external {
        pendingRewards[contributor] += amount;
        emit RewardAdded(contributor, amount);
    }

    function claim() external nonReentrant {

        uint256 reward = pendingRewards[msg.sender];

        require(reward > 0, "No reward");

        pendingRewards[msg.sender] = 0;

        (bool success,) = payable(msg.sender).call{value: reward}("");
        require(success, "ETH transfer failed");

        emit RewardClaimed(msg.sender, reward);
    }
}