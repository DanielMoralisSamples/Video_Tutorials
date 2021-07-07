from brownie import accounts, GuessNumber
from dotenv import load_dotenv
import os

def main():
    load_dotenv()
    account = accounts.load(os.environ['DEPLOY_ACCOUNT'])
    GuessNumber.deploy(os.environ['VRF_POLY'],os.environ['LINK_POLY'],os.environ['KEY_HASH_POLY'], 0.0001*(10**18),{'from':account})
    deployments = len(GuessNumber)
    print(f"number of deployments {deployments}, address of last deployment {GuessNumber[deployments-1].address}")

