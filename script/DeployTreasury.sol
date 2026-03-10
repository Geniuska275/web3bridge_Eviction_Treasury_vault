// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/modules/AuthorizationManager.sol";
import "../src/modules/ProposalManager.sol";
import "../src/modules/TimelockController.sol";
import "../src/core/TreasuryCore.sol";
import "../src/modules/ContributorDistributor.sol";

contract DeployTreasury is Script {

    function run() external {

        vm.startBroadcast();

        address governance = msg.sender;

        AuthorizationManager auth = new AuthorizationManager(governance);

        ProposalManager proposalManager = new ProposalManager();

        TimelockController timelock = new TimelockController();

        TreasuryCore treasury = new TreasuryCore(
            address(auth),
            address(proposalManager),
            address(timelock)
        );

        ContributorDistributor distributor = new ContributorDistributor();

        vm.stopBroadcast();

        console.log("Authorization:", address(auth));
        console.log("ProposalManager:", address(proposalManager));
        console.log("Timelock:", address(timelock));
        console.log("Treasury:", address(treasury));
        console.log("Distributor:", address(distributor));
    }
}