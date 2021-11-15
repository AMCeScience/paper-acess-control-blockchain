// node packages
const Web3 = require("web3");

// Setup web3 client to localhost private network
var web3 = new Web3('http://127.0.0.1:8545'); // your geth

// This script list all accounts
console.log("Accounts on network:")
accounts = web3.eth.getAccounts();
accounts.then(e => console.log(e));
// accounts = web3.eth.getAccounts();
// accounts.then(e => console.log(e));