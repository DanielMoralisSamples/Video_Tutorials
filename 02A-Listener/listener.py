import os
from web3 import Web3
from dotenv import load_dotenv
import time
import json

load_dotenv()
node_provider = os.environ['NODE_PROVIDER']
web3_connection = Web3(Web3.HTTPProvider(node_provider))

def are_we_connected():
    return web3_connection.isConnected()

def set_event(contract_address, abi_path):
    with open(abi_path) as f:
        abiJson = json.load(f)
    contract = web3_connection.eth.contract(address=contract_address, abi=abiJson['abi'])
    event_of_interest = contract.events.Transfer()
    return event_of_interest

def handle_event(event, event_of_interest):
    receipt = web3_connection.eth.waitForTransactionReceipt(event['transactionHash'])
    result = event_of_interest.processReceipt(receipt)
    print(result)

def log_loop(event_filter, poll_interval, event_of_interest):
    while True:
        for event in event_filter.get_new_entries():
            handle_event(event, event_of_interest)
            time.sleep(poll_interval)

def listen(contract_address, abi_path):
     block_filter = web3_connection.eth.filter({'fromBlock':'latest','address':contract_address})
     log_loop(block_filter, 2, set_event(contract_address, abi_path))

