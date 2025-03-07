// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    // Struct to represent a voter
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedOption;
    }

    // Struct to represent a voting option
    struct Option {
        string name;
        uint256 voteCount;
    }

    // State variables
    address public admin; // Admin address to manage the contract
    mapping(address => Voter) public voters; // Mapping of voter addresses to Voter struct
    Option[] public options; // Array of voting options
    bool public votingOpen; // Flag to indicate if voting is open

    // Events
    event VoterRegistered(address voter);
    event VoteCast(address voter, uint256 optionIndex);
    event VotingClosed();

    // Modifier to restrict access to the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // Modifier to ensure voting is open
    modifier votingIsOpen() {
        require(votingOpen, "Voting is closed");
        _;
    }

    // Constructor to initialize the contract
    constructor(string[] memory optionNames) {
        admin = msg.sender;
        votingOpen = true;

        // Initialize voting options
        for (uint256 i = 0; i < optionNames.length; i++) {
            options.push(Option({name: optionNames[i], voteCount: 0}));
        }
    }

    // Function to register a voter
    function registerVoter(address voterAddress) public onlyAdmin {
        require(!voters[voterAddress].isRegistered, "Voter is already registered");
        voters[voterAddress] = Voter({
            isRegistered: true,
            hasVoted: false,
            votedOption: type(uint256).max // Sentinel value indicating no vote
        });
        emit VoterRegistered(voterAddress);
    }

    // Function to cast a vote
    function castVote(uint256 optionIndex) public votingIsOpen {
        require(voters[msg.sender].isRegistered, "Voter is not registered");
        require(!voters[msg.sender].hasVoted, "Voter has already voted");
        require(optionIndex < options.length, "Invalid option index");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedOption = optionIndex; // Set the actual voted option
        options[optionIndex].voteCount += 1;

        emit VoteCast(msg.sender, optionIndex);
    }

    // Function to close voting
    function closeVoting() public onlyAdmin {
        require(votingOpen, "Voting is already closed");
        votingOpen = false;
        emit VotingClosed();
    }

    // Function to retrieve voting results
    function getResults() public view returns (Option[] memory) {
        require(!votingOpen, "Voting is still open");
        return options;
    }
}