import pytest
from brownie import Wei, accounts, Guess_number201

@pytest.fixture
def guess_number():
    guess_number = Guess_number201.deploy({'from':accounts[0]})
    guess_number.create_game(9, {'from':accounts[5],'value':'10 ether'})
    return guess_number

def test_wrong_guess(guess_number):
    pre_game_balance = guess_number.get_game_balance(0)
    pre_player_balance = accounts[2].balance()
    pre_guess_count = guess_number.get_game_guesses(0)
    guess_number.play_game(0,8,{'from':accounts[2],'value':'1 ether'})
    assert guess_number.get_game_balance(0) == pre_game_balance + Wei('1 ether'), 'The game balance is not correct'
    assert accounts[2].balance() == pre_player_balance - Wei('1 ether'), 'The player balance is incorrect'
    assert guess_number.get_game_guesses(0) == pre_guess_count + 1
    assert guess_number.is_game_active(0) == True

def test_right_guess(guess_number):
    pre_game_balance = guess_number.get_game_balance(0)
    pre_player_balance = accounts[2].balance()
    pre_contract_owner_balance = accounts[0].balance()
    guess_number.play_game(0,9,{'from':accounts[2],'value':'1 ether'})
    assert guess_number.get_game_balance(0) == 0, 'Balance of the game is not reset'
    assert accounts[0].balance() == pre_contract_owner_balance + (pre_game_balance + Wei('1 ether')) / 100, 'The commision is incorrect'
    assert accounts[2].balance() == (pre_player_balance - Wei('1 ether')) + (pre_game_balance + Wei('1 ether')) * 99 / 100, 'the player balance is not correct'
    assert guess_number.is_game_active(0) == False, 'Game status is not correct'