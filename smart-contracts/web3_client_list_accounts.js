// node packages
const Web3 = require("web3");

// Setup web3 client to localhost private network
var web3 = new Web3('http://localhost:8541'); // your geth

// This script list all accounts
console.log("Accounts on network:")
accounts = web3.eth.getAccounts();
accounts.then(e => console.log(e));