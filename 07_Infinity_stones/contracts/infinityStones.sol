// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC1155/ERC1155.sol";

contract infinityGems is ERC1155 {
    uint256 public constant SPACE = 0;
    uint256 public constant TIME = 1;
    uint256 public constant SOUL = 2;
    uint256 public constant REALITY = 3;
    uint256 public constant MIND = 4;
    uint256 public constant POWER = 5;

    constructor() ERC1155("https://to6yj724p7wc.moralis.io:2053/server/classes/InfinityStones") {
        _mint(msg.sender, SPACE, 1, "");
        _mint(msg.sender, MIND, 1, "");
        _mint(msg.sender, TIME, 1, "");
        _mint(msg.sender, POWER, 1, "");
        _mint(msg.sender, REALITY, 1, "");
        _mint(msg.sender, SOUL, 1, "");
    }
}