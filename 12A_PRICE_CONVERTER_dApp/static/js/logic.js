//initializing Moralis
Moralis.initialize(""); // Application id from moralis.io
Moralis.serverURL = ""; //Server url from moralis.io

/*Creating a contract object
This contract is pointing directly to the Chainlink Price Aggregator Dapp*/
window.web3 = new Web3(window.ethereum);
const priceAggregatorABI = [{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"description","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint80","name":"_roundId","type":"uint80"}],"name":"getRoundData","outputs":[{"internalType":"uint80","name":"roundId","type":"uint80"},{"internalType":"int256","name":"answer","type":"int256"},{"internalType":"uint256","name":"startedAt","type":"uint256"},{"internalType":"uint256","name":"updatedAt","type":"uint256"},{"internalType":"uint80","name":"answeredInRound","type":"uint80"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"latestRoundData","outputs":[{"internalType":"uint80","name":"roundId","type":"uint80"},{"internalType":"int256","name":"answer","type":"int256"},{"internalType":"uint256","name":"startedAt","type":"uint256"},{"internalType":"uint256","name":"updatedAt","type":"uint256"},{"internalType":"uint80","name":"answeredInRound","type":"uint80"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"version","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]
const priceContract = new window.web3.eth.Contract(priceAggregatorABI,/*'PRICE FEED CONTRACT ACCORDING TO YOUR PAIR, CHECK CHAINLINK DOCS'*/);

//dApp frontend logic
async function convert(){
    priceContract.methods.latestRoundData().call().then(convert_populate);
}

function convert_populate(_value){
    const amountToken = document.getElementById('amountToken').value
    const priceToken = _value.answer
    const result = (priceToken*amountToken)/(10**8);
    document.getElementById("amountUSD").setAttribute("value", result);
}

async function login(){
    document.getElementById('submit').setAttribute("disabled", null);
    document.getElementById('username').setAttribute("disabled", null);
    document.getElementById('useremail').setAttribute("disabled", null);
    Moralis.Web3.authenticate().then(function (user) {
        user.set("name",document.getElementById('username').value);
		user.set("email",document.getElementById('useremail').value);
		user.save();
        document.getElementById("amountToken").removeAttribute("disabled");
        document.getElementById("convert").removeAttribute("disabled");
    })
}