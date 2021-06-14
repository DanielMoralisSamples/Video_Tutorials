import pytest
from brownie import Wei, accounts, Guess_number

@pytest.fixture
def guess_number():
    return Guess_number.deploy(7,{'from':accounts[0],'value':'10 ether'})

def test_play_wrong_guess(guess_number):
    pre_contract_balance = guess_number.getBalance()
    pre_player_balance = accounts[1].balance()
    guess_number.play(6,accounts[1].address, {'from':accounts[1], 'value':'1 ether'})

    assert guess_number.getBalance() == pre_contract_balance + Wei('1 ether')
    assert accounts[1].balance() == pre_player_balance - Wei('1 ether')
    assert guess_number.currState() == 0

def test_play_right_guess(guess_number):
    pre_contract_balance = guess_number.getBalance()
    pre_player_balance = accounts[1].balance()
    guess_number.play(7,accounts[1].address, {'from':accounts[1], 'value':'1 ether'})

    assert accounts[1].balance() == pre_player_balance + pre_contract_balance
    assert guess_number.currState() == 1
    assert guess_number.getBalance() == 0