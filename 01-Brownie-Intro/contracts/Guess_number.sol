/* This contracts are offered for learning purposes only, to illustrate certain aspects of development regarding web3, 
   they are not audited of course and not for use in any production environment. 
   They are not aiming to illustrate true randomness or reentrancy control, as a general rule they use transfer() instead of call() to avoid reentrancy,
   which of course only works is the recipient is not intended to be a contract that executes complex logic on transfer.
*/

pragma solidity ^0.8.1;

contract Guess_number {

    address payable player;
    enum State {OPEN, COMPLETE}
    State public currState;
    uint private secretNumber;
    uint public balance;

    constructor (uint _secretNumber) payable {
        require(msg.value == 10*10**18, 'contract needs to be funded with at least 10 eth');
        secretNumber = _secretNumber;
        currState = State.OPEN;
        balance = balance + msg.value;
    }

    function getBalance() public view returns (uint) {
        return balance;
    }
    

    function play(uint guessedNumber, address _player) external payable{
        require(msg.value == 10**18, 'you most pay to play');
        require (currState == State.OPEN);
        player = payable(_player);
        balance = balance + msg.value;
        if (guessedNumber == secretNumber) {
            currState = State.COMPLETE;
            balance = 0;
            player.transfer(address(this).balance);
        }
    }
}
