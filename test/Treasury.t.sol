// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/modules/AuthorizationManager.sol";
import "../src/modules/ProposalManager.sol";
import "../src/modules/TimelockController.sol";
import "../src/core/TreasuryCore.sol";
import "../src/modules/ContributorDistributor.sol";

contract TreasuryTest is Test {

    AuthorizationManager auth;
    ProposalManager proposalManager;
    TimelockController timelock;
    TreasuryCore treasury;
    ContributorDistributor distributor;

    address governance = address(1);
    address executor = address(2);
    address contributor = address(3);

    function setUp() public {

        vm.startPrank(governance);

        auth = new AuthorizationManager(governance);

        proposalManager = new ProposalManager();

        timelock = new TimelockController();

        treasury = new TreasuryCore(
            address(auth),
            address(proposalManager),
            address(timelock)
        );

        distributor = new ContributorDistributor();

        auth.grantRole(auth.EXECUTOR_ROLE(), executor);

        vm.stopPrank();
    }

    function testProposalCreation() public {

        uint256 eta = block.timestamp + 2 days;

        uint256 id = proposalManager.createProposal(
            address(0xBEEF),
            1 ether,
            "",
            eta
        );

        (
            address target,
            uint256 value,
            ,
            ,
            uint256 storedEta
        ) = proposalManager.proposals(id);

        assertEq(target, address(0xBEEF));
        assertEq(value, 1 ether);
        assertEq(storedEta, eta);
    }

    function testTimelockPreventsEarlyExecution() public {

        uint256 eta = block.timestamp + 2 days;

        uint256 id = proposalManager.createProposal(
            address(0xBEEF),
            0,
            "",
            eta
        );

        vm.prank(executor);

        vm.expectRevert();

        treasury.executeProposal(id);
    }

    function testExecutionAfterDelay() public {

        uint256 eta = block.timestamp + 2 days;

        uint256 id = proposalManager.createProposal(
            address(this),
            0,
            abi.encodeWithSignature("dummy()"),
            eta
        );

        vm.warp(block.timestamp + 3 days);

        vm.prank(executor);

        treasury.executeProposal(id);
    }

    function dummy() external {}

    function testContributorRewardClaim() public {

        distributor.addReward(contributor, 1 ether);

        vm.deal(address(distributor), 1 ether);

        vm.prank(contributor);

        distributor.claim();

        assertEq(contributor.balance, 1 ether);
    }

}