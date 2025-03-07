## Voting System Smart Contract

This project implements a Voting System smart contract using Solidity and Foundry. The contract allows users to register to vote, cast votes for different options, and retrieve voting results. It includes comprehensive unit tests and fuzz tests to ensure security and reliability.

## Features
1.) Voter Registration: Only the admin can register voters.

2.) Voting: Registered voters can cast one vote for a valid option.

3.) Results Retrieval: Voting results can be retrieved after voting is closed.

4.) Security: Includes checks to prevent double voting, unregistered voting, and invalid option selection.

5.) Fuzz Testing: Comprehensive fuzz tests to ensure robustness against edge cases.

## Requirements

1.) Foundry

2.) Node.js (optional, for additional tooling)

3.) An Ethereum wallet (for deployment)

## Setup

1.) Setup Foundry:
```bash
curl -L https://getfoundry.sh | bash
foundryup
```

2.) Clone the repository:
```bash
git clone https://github.com/Amaze09/Voting.git
cd Voting
```

3.) Compile the contract:
```bash
forge build
```

## Running Tests
The project includes both unit tests and fuzz tests to ensure the contract behaves as expected.

Run All Tests
```bash
forge test
```

## Deployment
To deploy the contract, follow these steps:

Run the Deployment Script:
```bash
forge script script/DeployVotingSystem.s.sol:DeployVotingSystem --broadcast --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --verify --etherscan-api-key <API_KEY>
```

## Contract Details

registerVoter(address voterAddress): Registers a voter (admin only).

castVote(uint256 optionIndex): Allows a registered voter to cast a vote.

closeVoting(): Closes the voting process (admin only).

getResults(): Retrieves the voting results (only after voting is closed).

VoterRegistered(address voter): Emitted when a voter is registered.

VoteCast(address voter, uint256 optionIndex): Emitted when a voter casts a vote.

VotingClosed(): Emitted when voting is closed.


## Deployed Address

0x9A950a431Bff92eF1E97e6343C9CCd657dFaD4ac (Sepolia)

