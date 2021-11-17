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
let decision_abi_source = fs.readFileSync("../bin/smart-contracts/Decision.abi");
let decision_bin_source = fs.readFileSync("../bin/smart-contracts/Decision.bin");
let contract_abi = JSON.parse(decision_abi_source);

const DecisionContract = new web3.eth.Contract(contract_abi, "0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84");

decision_transactions = {
    "startSmartContract" : [],    
}

startSmartContract();

// ============================================================== //
// ============================================================== //
function startSmartContract(){    
    transact = DecisionContract.methods.startSmartContract().send({from: owner_account})
    .on('transactionHash', function(hash){
        decision_transactions["startSmartContract"].push(hash)
    })
}

// ============================================================== //
// ============================================================== //
function save_json(){
    var jsonContent = JSON.stringify(attributes_transactions);
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
// ============================================================== //