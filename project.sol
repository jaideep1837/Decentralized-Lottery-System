// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Lottery {
    address public manager;
    address payable[] public players;

    constructor() {
        manager = msg.sender;
    }

    // Function to enter the lottery
    function enter() public payable {
        require(msg.value >= 0.01 ether, "Minimum 0.01 ETH required to join");
        players.push(payable(msg.sender));
    }

    // Function to get the total number of players
    function getPlayersCount() public view returns (uint) {
        return players.length;
    }

    // Function to pick a random winner (only manager can call)
    function pickWinner() public restricted {
        require(players.length > 0, "No players in the lottery");

        uint index = random() % players.length;
        address payable winner = players[index];

        winner.transfer(address(this).balance);

        // Reset the lottery
        // players = new address payable ;
    }

    // Helper function to generate pseudo-random number
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, players)));
    }

    // Restrict certain functions to only manager
    modifier restricted() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    // Get contract balance (for manager)
    function getBalance() public view restricted returns (uint) {
        return address(this).balance;
    }
}
