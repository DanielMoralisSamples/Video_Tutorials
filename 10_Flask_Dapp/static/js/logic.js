//initializing Moralis
Moralis.initialize(""); // Application id from moralis.io
Moralis.serverURL = ""; //Server url from moralis.io


/*Creating a contract object
This is a sample contract found in the 09_guess_number_vrf brownie project, feel free to deploy your own to have a more realistic feel of the project*/
window.web3 = new Web3(window.ethereum);
const GuessNumberAbi = [{"inputs": [{"internalType": "address", "name": "vrfCoordinator", "type": "address"}, {"internalType": "address", "name": "link", "type": "address"}, {"internalType": "bytes32", "name": "keyHash", "type": "bytes32"}, {"internalType": "uint256", "name": "fee", "type": "uint256"}], "stateMutability": "nonpayable", "type": "constructor", "name": "constructor"}, {"anonymous": false, "inputs": [{"indexed": true, "internalType": "bytes32", "name": "requestId", "type": "bytes32"}, {"indexed": true, "internalType": "uint256", "name": "roller", "type": "uint256"}], "name": "Dice_rolled", "type": "event"}, {"anonymous": false, "inputs": [{"indexed": true, "internalType": "address", "name": "owner", "type": "address"}, {"indexed": false, "internalType": "uint256", "name": "game_index", "type": "uint256"}, {"indexed": false, "internalType": "uint256", "name": "time", "type": "uint256"}], "name": "Game_created", "type": "event"}, {"anonymous": false, "inputs": [{"indexed": true, "internalType": "address", "name": "creator", "type": "address"}, {"indexed": false, "internalType": "uint256", "name": "game_index", "type": "uint256"}, {"indexed": false, "internalType": "uint256", "name": "time", "type": "uint256"}], "name": "Game_expired", "type": "event"}, {"anonymous": false, "inputs": [{"indexed": true, "internalType": "bytes32", "name": "requestId", "type": "bytes32"}, {"indexed": true, "internalType": "uint256", "name": "game_id", "type": "uint256"}], "name": "Game_served", "type": "event"}, {"anonymous": false, "inputs": [{"indexed": true, "internalType": "address", "name": "solver", "type": "address"}, {"indexed": false, "internalType": "uint256", "name": "game_index", "type": "uint256"}, {"indexed": false, "internalType": "uint256", "name": "time", "type": "uint256"}], "name": "Game_solved", "type": "event"}, {"inputs": [{"internalType": "uint256", "name": "game_id", "type": "uint256"}], "name": "cancelGame", "outputs": [{"internalType": "bool", "name": "", "type": "bool"}], "stateMutability": "nonpayable", "type": "function"}, {"inputs": [], "name": "create_game", "outputs": [{"internalType": "bool", "name": "", "type": "bool"}], "stateMutability": "payable", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "game_id", "type": "uint256"}], "name": "get_game_balance", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "game_id", "type": "uint256"}], "name": "get_game_guesses", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "game_id", "type": "uint256"}], "name": "get_game_number_test", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "game_id", "type": "uint256"}], "name": "is_game_active", "outputs": [{"internalType": "bool", "name": "", "type": "bool"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "game_id", "type": "uint256"}, {"internalType": "uint256", "name": "guessed_number", "type": "uint256"}], "name": "play_game", "outputs": [{"internalType": "bool", "name": "", "type": "bool"}], "stateMutability": "payable", "type": "function"}, {"inputs": [{"internalType": "bytes32", "name": "requestId", "type": "bytes32"}, {"internalType": "uint256", "name": "randomness", "type": "uint256"}], "name": "rawFulfillRandomness", "outputs": [], "stateMutability": "nonpayable", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "game_id", "type": "uint256"}, {"internalType": "uint256", "name": "seed", "type": "uint256"}], "name": "rollDice", "outputs": [{"internalType": "bytes32", "name": "requestId", "type": "bytes32"}], "stateMutability": "nonpayable", "type": "function"}];
const GuessNumber = new window.web3.eth.Contract(GuessNumberAbi,'');//Guess the number game address

//dApp frontend logic
async function game_balance(){
    GuessNumber.methods.get_game_balance(document.getElementById('gameid').value).call().then(balance_populate);
}

function balance_populate(_value){
    const amount = _value/(10**18);
    document.getElementById("gamebalance").setAttribute("value", amount);
}

async function login(){
    document.getElementById('submit').setAttribute("disabled", null);
    document.getElementById('username').setAttribute("disabled", null);
    document.getElementById('useremail').setAttribute("disabled", null);
    Moralis.Web3.authenticate().then(function (user) {
        user.set("name",document.getElementById('username').value);
		user.set("email",document.getElementById('useremail').value);
		user.save();
        document.getElementById("gameid").removeAttribute("disabled");
        document.getElementById("balance").removeAttribute("disabled");
        document.getElementById("gamebalance").removeAttribute("disabled");
    })
}