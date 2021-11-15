// Node
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:8545'); // your geth
console.log(web3);

contracts = {}

const password = "";

// Unlock the coinbase account to make transactions out of it
console.log("Unlocking contract owner account...");
var owner_account = '0x00a329c0648769A73afAc7F9381E08FB43dBEA72';
web3.eth.personal.unlockAccount(owner_account, password, null);	
const account = null;
// unlockOwnerAccount(owner_account);

console.log("Deploying contracts...");
//// read contracts abi and byte codes
let data_access_abi_source = fs.readFileSync("../bin/smart-contracts/Data_Access.abi");
let data_access_bin_source = fs.readFileSync("../bin/smart-contracts/Data_Access.bin");
let contract_abi = JSON.parse(data_access_abi_source);

const DataAccessContract = new web3.eth.Contract(contract_abi, "0x3f85D0b6119B38b7E6B119F7550290fec4BE0e3c");

data_access_transactions = {
    "evaluateRequest" : [],
    "grantAccess" : [],
    "verifyAccess" : [],
    "revokeAccess" : []
}

// ============================================================== //
// ============================================================== //
function evaluateRequest(){
    transact = DataAccessContract.methods.evaluateRequest().send({from: owner_account})
    .on('transactionHash', function(hash){
        data_access_transactions["evaluateRequest"].push(hash)
    })
}
// ============================================================== //
// ============================================================== //
function grantAccess(){
    transact = DataAccessContract.methods.grantAccess().send({from: owner_account})
    .on('transactionHash', function(hash){
        data_access_transactions["grantAccess"].push(hash)
    })
}
// ============================================================== //
// ============================================================== //
function verifyAccess(){
    transact = DataAccessContract.methods.verifyAccess().send({from: owner_account})
    .on('transactionHash', function(hash){
        data_access_transactions["verifyAccess"].push(hash)
    })
}
// ============================================================== //
// ============================================================== //
function revokeAccess(){
    transact = DataAccessContract.methods.revokeAccess().send({from: owner_account})
    .on('transactionHash', function(hash){
        data_access_transactions["revokeAccess"].push(hash)
    })
}
// ============================================================== //
// ============================================================== //
function save_json(){
    var jsonContent = JSON.stringify(data_access_transactions);
    // console.log(jsonContent);
    fs.writeFile("data-access-transactions.json", jsonContent, 'utf8', function (err) {
        if (err) {
            console.log("An error occured while writing JSON Object to File.");
            return console.log(err);
        }
        console.log("JSON file has been saved.");
    });
}
// ============================================================== //