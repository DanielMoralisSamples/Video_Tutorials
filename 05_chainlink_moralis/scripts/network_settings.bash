#!/bin/bash
brownie networks add Ethereum rinkeby_test host='YOUR LINK' name="Eth Rinkeby Moralis" chainid=4 explorer='https://api-rinkeby.etherscan.io/api'
brownie networks add "Binance Smart Chain" bsc_test_moralis host='YOUR LINK' name="Testnet (Moralis)" chainid=97 explorer='https://api-testnet.bscscan.com/api'
brownie networks add Polygon mumbai_moralis host='YOUR LINK' name='Mumbai (Moralis)' chainid=80001 explorer='https://explorer-mumbai.maticvigil.com/'