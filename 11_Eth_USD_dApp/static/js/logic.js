//initializing Moralis
Moralis.initialize(""); // Application id from moralis.io
Moralis.serverURL = ""; //Server url from moralis.io

/*Creating a contract object
This is a sample contract found in the 05_chainlink_moralis brownie project discussed in the following video https://youtu.be/s79cWDT1oaY, feel free to deploy your own to have a more realistic feel of the project*/
window.web3 = new Web3(window.ethereum);
const Price_ETHAbi = [{"inputs": [], "stateMutability": "nonpayable", "type": "constructor", "name": "constructor"}, {"inputs": [], "name": "getThePrice", "outputs": [{"internalType": "int256", "name": "", "type": "int256"}], "stateMutability": "view", "type": "function"}];
const PriceETH = new window.web3.eth.Contract(Price_ETHAbi,'0xF6c976a00d85c675f7ec730E48c3cae3bE161AB7');

//dApp frontend logic
async function convertEth(){
    PriceETH.methods.getThePrice().call().then(convert_populate);
}

function convert_populate(_value){
    const amountEth = document.getElementById('amountEth').value
    const result = (_value*amountEth)/(10**8);
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
        document.getElementById("amountEth").removeAttribute("disabled");
        document.getElementById("convert").removeAttribute("disabled");
    })
}