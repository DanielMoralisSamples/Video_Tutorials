from brownie import GuessNumber

def main():
    with open("source.sol","w+") as f:
        source = GuessNumber.get_verification_info()["flattened_source"]
        for line in source:
            f.write(line)