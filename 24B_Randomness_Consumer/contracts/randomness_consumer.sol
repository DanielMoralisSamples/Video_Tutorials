// SPDX-License-Identifier: MIT
pragma solidity 0.6.6;

import "smartcontractkit/chainlink-brownie-contracts@0.2.2/contracts/src/v0.6/VRFConsumerBase.sol";

contract RandomnessConsumer is VRFConsumerBase {
    using SafeMathChainlink for uint256;

    uint256 private constant ROLL_IN_PROGRESS = 50;

    bytes32 private keyHash;
    uint256 private fee;
    address private owner;
    mapping(bytes32 => address) private rollers;
    mapping(address => uint256) private results;

    event DiceRolled(bytes32 indexed requestId, address indexed roller);
    event DiceLanded(bytes32 indexed requestId, uint256 indexed result);

    constructor(address _vrfCoordinator, address _link, bytes32 _keyHash, uint256 _fee)
        public
        VRFConsumerBase(_vrfCoordinator, _link)
    {
        keyHash = _keyHash;
        fee = _fee;
        owner = msg.sender;
        
    }

    function rollDice() public returns (bytes32 requestId) {
        address roller = msg.sender;
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK to pay fee");
        requestId = requestRandomness(keyHash, fee);
        rollers[requestId] = roller;
        results[roller] = ROLL_IN_PROGRESS;
        emit DiceRolled(requestId, roller);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        results[rollers[requestId]] = randomness;
        emit DiceLanded(requestId, randomness);
    }

    function getResults(address roller) external view returns (uint256){
        require(msg.sender == owner, "this is an only owner function");
        return results[roller];
    } 

    function setFee(uint256 _fee) external returns (bool){
        require(msg.sender == owner, "this is an only owner function");
        fee = _fee;
        return true;
    }
    
    function getFee () external view returns (uint256) {
        return fee;
    }
}