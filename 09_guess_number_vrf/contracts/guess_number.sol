/* This contracts are offered for learning purposes only, to illustrate certain aspects of development regarding web3, 
   they are not audited of course and not for use in any production environment. 
   As a general rule they use transfer() instead of call() to avoid reentrancy,
   which of course only works is the recipient is not intended to be a contract that executes complex logic on transfer.
*/


// SPDX-License-Identifier: MIT
pragma solidity 0.6.6;

import "smartcontractkit/chainlink-brownie-contracts@1.0.2/contracts/src/v0.6/VRFConsumerBase.sol";

/* Contract Guess Number
Contract should support multiple guess the number games. 
Creator of games should risk an ammounts of tokens to start a new game. 
A secret number is established during game creation by calling chainlink
The secret number should be between 1-100.
Each guess of the number in a game will cost an amount of tokens
Each game should allow only 10 guesses, once the tenth guess is made
the game will expire and the funds will go to the game creator.
Whoever makes the right guess will win the balance of the game.
Once the right guess is made a game should not allow people to play.
Once a game makes a payment 1% of the amount will go to the contract creator as a fee. */

contract GuessNumber is VRFConsumerBase {
    using SafeMathChainlink for uint256;

    uint256 private constant ROLL_IN_PROGRESS = 1000;
    bytes32 private s_keyHash;
    uint256 private s_fee;

    event Dice_rolled(bytes32 indexed requestId, uint256 indexed roller);
    event Game_created(address indexed owner, uint256 game_index, uint256 time);
    event Game_served(bytes32 indexed requestId, uint256 indexed game_id);
    event Game_solved(address indexed solver, uint256 game_index, uint256 time);
    event Game_expired(address indexed creator, uint256 game_index, uint256 time);
    
    struct game {
        address game_owner;
        uint256 secret_number;
        uint256 game_balance;
        uint256 guess_count;
        bool is_active;
    }

    uint256 curr_id;

    mapping (bytes32 => uint256) private rolls;
    mapping (uint256 => game) game_index;

    address payable contract_owner;

    constructor(address vrfCoordinator, address link, bytes32 keyHash, uint256 fee)
        public
        VRFConsumerBase(vrfCoordinator, link)
        {
            s_keyHash = keyHash;
            s_fee = fee;
            contract_owner = msg.sender;
            curr_id = 0;
        }
    
    function create_game() public payable returns(bool){
        require (msg.value == 0.0001*(10**18), "You should pay 0.0001 tokens to create game");
        game_index[curr_id].game_owner = msg.sender;
        game_index[curr_id].game_balance = msg.value;
        game_index[curr_id].guess_count = 0;
        rollDice(curr_id, curr_id+10);
        curr_id = curr_id + 1;
        emit Game_created(msg.sender,curr_id-1, block.timestamp);
    }

    function rollDice(uint256 game_id, uint256 seed) public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= s_fee, "Not enough LINK to pay fee");
        require(game_index[game_id].secret_number == 0, "Already served");
        requestId = requestRandomness(s_keyHash, s_fee, seed);
        rolls[requestId] = game_id;
        game_index[game_id].secret_number = ROLL_IN_PROGRESS;
        emit Dice_rolled(requestId, game_id);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        uint256 served_game = rolls[requestId];
        uint256 d10Value = randomness.mod(100).add(1);
        game_index[served_game].secret_number = d10Value;
        game_index[served_game].is_active = true;
        emit Game_served(requestId, served_game);
    }

    function play_game(uint256 game_id, uint256 guessed_number) public payable returns (bool) {
        require (msg.value == 0.00001*(10**18), "you must payh 0.00001 tokens to play");
        require (guessed_number >= 1 && guessed_number<= 100, "Guessed number should be within 1 to 100");
        require (game_index[game_id].is_active == true);
        game_index[game_id].game_balance = game_index[game_id].game_balance + msg.value;
        game_index[game_id].guess_count = game_index[game_id].guess_count + 1;
        address payable player = payable(msg.sender);
        address payable creator = payable(game_index[game_id].game_owner);
        uint _game_balance = game_index[game_id].game_balance;
        if (guessed_number == game_index[game_id].secret_number) {
            game_index[game_id].game_balance = 0;
            game_index[game_id].is_active = false;
            player.transfer((_game_balance * 99) / 100);
            contract_owner.transfer(_game_balance / 100);
            emit Game_solved(msg.sender, game_id, block.timestamp);
        }
        else {
            if (game_index[game_id].guess_count == 10){
                game_index[game_id].game_balance = 0;
                game_index[game_id].is_active = false;
                creator.transfer((_game_balance * 99) / 100);
                contract_owner.transfer(_game_balance / 100);
                emit Game_expired(game_index[game_id].game_owner, game_id, block.timestamp);
            }
        }
    }

    function get_game_balance(uint256 game_id) public view returns(uint256) {
        return game_index[game_id].game_balance;
    }

    function get_game_guesses(uint256 game_id) public view returns(uint256) {
        return game_index[game_id].guess_count;
    }

    function is_game_active (uint game_id) public view returns (bool) {
        return game_index[game_id].is_active;
    }


// the functions below are for pure testing purposes these should be deleted to actually make this a dApp
    function get_game_number_test(uint256 game_id) public view returns(uint256) {
        return game_index[game_id].secret_number;
    }

    function cancelGame(uint256 game_id) public returns (bool){
        require(msg.sender == game_index[game_id].game_owner);
        address payable creator = payable(msg.sender);
        uint _game_balance = game_index[game_id].game_balance;
        game_index[game_id].game_balance = 0;
        creator.transfer(_game_balance);
        return true;
    }
}
