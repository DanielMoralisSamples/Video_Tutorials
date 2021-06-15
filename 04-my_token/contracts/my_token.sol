// SDPX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC20/ERC20.sol";


contract DanielToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Daniel", "Dan") {
        _mint(msg.sender, initialSupply);
    }
}