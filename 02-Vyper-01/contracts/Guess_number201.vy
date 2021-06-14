# @version ^0.2.0

#Contract Guess Number
#Contrac should support multiple guess the number games. 
#Creator of games should risk 10 ETH to start a new game. 
#A secret number is established during game creation
#The secret number should be between 0-100.
#The game creator cannot play in the games he created.
#Each guess of the number in a game will cost 1 Eth.
#Each game should allow only 10 guesses, once the tenth guess is made
#the game will expire and the funds will go to the game creator.
#Whoever makes the right guess will win the balance of the game.
#Once the right guess is made a game should not allow people to play.
#Once a game makes a payment 1% of the amount will go to the contract creator as a fee.

event Game_created:
    owner: indexed(address)
    game_index: uint256
    time: uint256

event Game_solved:
    solver: indexed(address)
    game_index: uint256
    time: uint256

struct game:
    game_owner: address
    secret_number: uint256
    game_balance: uint256
    guess_count: uint256
    is_active: bool

curr_id: uint256

game_index: HashMap[uint256, game]

contract_owner: address

@external
def __init__():
    self.contract_owner = msg.sender
    self.curr_id = 0

@external
@payable
def create_game(_secret_number:uint256) -> bool:
    assert msg.value == 10*(10**18), "You should pay 10 ether to create game"
    assert (_secret_number >= 0) and (_secret_number <= 100), "The secret number should be within 0-100"
    self.game_index[self.curr_id].game_owner = msg.sender
    self.game_index[self.curr_id].game_balance = self.game_index[self.curr_id].game_balance + msg.value
    self.game_index[self.curr_id].secret_number = _secret_number
    self.game_index[self.curr_id].guess_count = 0
    self.game_index[self.curr_id].is_active = True
    self.curr_id = self.curr_id + 1
    log Game_created(msg.sender, self.curr_id - 1, block.timestamp)
    return True

@external
@view
def get_game_balance(_game_id: uint256) -> uint256:
    return self.game_index[_game_id].game_balance

@external
@view
def get_game_guesses(_game_id: uint256) -> uint256:
    return self.game_index[_game_id].guess_count

@external
@view
def is_game_active(_game_id: uint256) -> bool:
    return self.game_index[_game_id].is_active

@external
@payable
def play_game(_game_id: uint256, _guessed_number:uint256) -> bool:
    assert msg.value == 10**18
    assert msg.sender != self.game_index[_game_id].game_owner
    assert (_guessed_number >= 0) and (_guessed_number<= 100)
    assert self.game_index[_game_id].is_active == True
    self.game_index[_game_id].game_balance = self.game_index[_game_id].game_balance + msg.value
    self.game_index[_game_id].guess_count = self.game_index[_game_id].guess_count + 1
    if _guessed_number == self.game_index[_game_id].secret_number:
        send(msg.sender, (self.game_index[_game_id].game_balance * 99) / 100 )
        send(self.contract_owner, self.game_index[_game_id].game_balance / 100)
        self.game_index[_game_id].game_balance = 0
        self.game_index[_game_id].is_active = False
        log Game_solved(msg.sender, _game_id, block.timestamp)
    else:
        if self.game_index[_game_id].guess_count == 10:
            send(self.game_index[_game_id].game_owner, (self.game_index[_game_id].game_balance * 99)/100)
            send(self.contract_owner, self.game_index[_game_id].game_balance / 100)
            self.game_index[_game_id].game_balance = 0
            self.game_index[_game_id].is_active = False
    return True