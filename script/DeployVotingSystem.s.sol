// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/VotingSystem.sol";

contract DeployVotingSystem is Script {
    function run() public {
        vm.startBroadcast();

        // Initialize voting options
        string[] memory optionNames = new string[](3);
        optionNames[0] = "IceCream";
        optionNames[1] = "Cake";
        optionNames[2] = "Cookies";

        // Deploy the contract
        VotingSystem votingSystem = new VotingSystem(optionNames);

        vm.stopBroadcast();

        // Log the deployed contract address
        console.log("VotingSystem deployed at:", address(votingSystem));
    }
}