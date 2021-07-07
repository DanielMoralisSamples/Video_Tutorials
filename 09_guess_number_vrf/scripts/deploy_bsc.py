from brownie import accounts, GuessNumber
from dotenv import load_dotenv
import os

def main():
    load_dotenv()
    account = accounts.load(os.environ['DEPLOY_ACCOUNT'])
    GuessNumber.deploy(os.environ['VRF_BSC'],os.environ['LINK_BSC'],os.environ['KEY_HASH_BSC'], 0.1*(10**18),{'from':account})
    deployments = len(GuessNumber)
    print(f"number of deployments {deployments}, address of last deployment {GuessNumber[deployments-1].address}")

