// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VotingSystem.sol";

contract VotingSystemTest is Test {
    VotingSystem votingSystem;
    address admin = address(0x1);
    address voter1 = address(0x2);
    address voter2 = address(0x3);

    function setUp() public {
        // Deploy the VotingSystem contract with initial options
        vm.prank(admin);
        string[] memory optionNames = new string[](3);
        optionNames[0] = "Option1";
        optionNames[1] = "Option2";
        optionNames[2] = "Option3";
        votingSystem = new VotingSystem(optionNames);
    }

    // Test: Admin can register voters
    function testAdminCanRegisterVoters() public {
        vm.prank(admin);
        votingSystem.registerVoter(voter1);

        (bool isRegistered, bool hasVoted, uint256 votedOption) = votingSystem.voters(voter1);
        assertTrue(isRegistered, "Voter should be registered");
        assertFalse(hasVoted, "Voter should not have voted yet");
        assertEq(votedOption, type(uint256).max, "Voter's voted option should be initialized to sentinel value");
    }

    // Test: Non-admin cannot register voters
    function testNonAdminCannotRegisterVoters() public {
        vm.prank(voter1);
        vm.expectRevert("Only admin can perform this action");
        votingSystem.registerVoter(voter2);
    }

    // Test: Registered voter can cast a vote
    function testRegisteredVoterCanCastVote() public {
        vm.prank(admin);
        votingSystem.registerVoter(voter1);

        vm.prank(voter1);
        votingSystem.castVote(1);

        (, bool hasVoted, uint256 votedOption) = votingSystem.voters(voter1);
        assertTrue(hasVoted, "Voter should have voted");
        assertEq(votedOption, 1, "Voter should have voted for option 1");
    }

    // Test: Unregistered voter cannot cast a vote
    function testUnregisteredVoterCannotCastVote() public {
        vm.prank(voter1);
        vm.expectRevert("Voter is not registered");
        votingSystem.castVote(1);
    }

    // Test: Voter cannot vote twice
    function testVoterCannotVoteTwice() public {
        vm.prank(admin);
        votingSystem.registerVoter(voter1);

        vm.prank(voter1);
        votingSystem.castVote(1);

        vm.prank(voter1);
        vm.expectRevert("Voter has already voted");
        votingSystem.castVote(2);
    }

    // Test: Admin can close voting
    function testAdminCanCloseVoting() public {
        vm.prank(admin);
        votingSystem.closeVoting();

        bool isVotingOpen = votingSystem.votingOpen();
        assertFalse(isVotingOpen, "Voting should be closed");
    }

    // Test: Non-admin cannot close voting
    function testNonAdminCannotCloseVoting() public {
        vm.prank(voter1);
        vm.expectRevert("Only admin can perform this action");
        votingSystem.closeVoting();
    }

    // Test: Retrieve voting results after voting is closed
    function testRetrieveVotingResults() public {
        // Register voters
        vm.prank(admin);
        votingSystem.registerVoter(voter1);
        vm.prank(admin);
        votingSystem.registerVoter(voter2);

        // Cast votes
        vm.prank(voter1);
        votingSystem.castVote(0); // Voter1 votes for Option1
        vm.prank(voter2);
        votingSystem.castVote(1); // Voter2 votes for Option2

        // Close voting
        vm.prank(admin);
        votingSystem.closeVoting();

        // Retrieve results
        VotingSystem.Option[] memory results = votingSystem.getResults();
        assertEq(results[0].voteCount, 1, "Option1 should have 1 vote");
        assertEq(results[1].voteCount, 1, "Option2 should have 1 vote");
        assertEq(results[2].voteCount, 0, "Option3 should have 0 votes");
    }

    // Test: Cannot retrieve results while voting is open
    function testCannotRetrieveResultsWhileVotingOpen() public {
        vm.expectRevert("Voting is still open");
        votingSystem.getResults();
    }
}