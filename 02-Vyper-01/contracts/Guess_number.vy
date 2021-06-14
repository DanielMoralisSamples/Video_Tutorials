# @version ^0.2.0

#Contract Guess Number
#Contract should take a secret number upon deployment. 
#The secret number should be within the range 0-100.
#It should cost 10 eth to deploy the contract.
#Contract should allow people to guess the secret number
#Each guess that players make will cost 1 eth.
#Whoever makes the right guess will have the balance of the contract transfer to his ethereum address.
#Once the right guess is made, the contract should not allow people to play.

secret_number: uint256
curr_balance: public(uint256)
active: public(bool)

@external
@payable
def __init__(_secret_number: uint256):
    assert msg.value == 10*(10**18), "You should pay 10 ether to deploy"
    assert (_secret_number>=0) and (_secret_number<=100), "The secret number is outside the allowed range"
    self.secret_number = _secret_number
    self.curr_balance = self.curr_balance + msg.value
    self.active = True

@external
@payable
def play(_guessed_number:uint256):
    assert msg.value == 10**18, "You should pay 1 ether to play"
    assert self.active == True, "The contract is unfortunately already void"
    if _guessed_number == self.secret_number:
        send(msg.sender, self.balance)
        self.curr_balance =  0
        self.active = False


