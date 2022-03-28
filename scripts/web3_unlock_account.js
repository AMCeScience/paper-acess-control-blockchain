// Node

const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:8545'); // your geth

contracts = {}

const password = "";

// Unlock the coinbase account to make transactions out of it
console.log("Unlocking contract owner account...");
var owner_account = '0x00a329c0648769A73afAc7F9381E08FB43dBEA72';
web3.eth.personal.unlockAccount(owner_account, password, null);	
// unlockOwnerAccount(owner_account);