// Node
const { create } = require("domain");
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:8545'); // your geth
// console.log(web3);

contracts = {}

const password = "node0";

// Unlock the coinbase account to make transactions out of it
console.log("Unlocking contract owner account...");
var owner_account = '0x00a329c0648769A73afAc7F9381E08FB43dBEA72';
web3.eth.personal.unlockAccount(owner_account, password, null);	
const account = null;
// unlockOwnerAccount(owner_account);

console.log("Deploying contracts...");
//// read contracts abi and byte codes
let attributes_abi_source = fs.readFileSync("../bin/smart-contracts/Attributes.abi");
let attributes_bin_source = fs.readFileSync("../bin/smart-contracts/Attributes.bin");
let contract_abi = JSON.parse(attributes_abi_source);

const AttributesContract = new web3.eth.Contract(contract_abi, "0x7C276DcAab99BD16163c1bcce671CaD6A1ec0945");

attributes_transactions = {
    "addController" : [],
    "setPublicKey" : [],
    "retrievePublicKey" : [],
    "isAddressOfController" : []
}

addController();
setPublicKey();
retrievePublicKey();
isAddressOfController();

// ============================================================== //
function addController(){
    for (let i = 0; i < 1; i++) {        
        AttributesContract.methods.addOrganisation().send({from: owner_account})
        .on('transactionHash', function(hash){
            policies_transactions["addController"].push(hash)
        })    
    }    
}
// ============================================================== //
// ============================================================== //
function setPublicKey(){
    for (let i = 0; i < 1; i++) {
        AttributesContract.methods.setPublicKey().send({from: owner_account})
        .on('transactionHash', function(hash){
            policies_transactions["setPublicKey"].push(hash)
        })
    }
}
// ============================================================== //
// ============================================================== //
function retrievePublicKey(){
    for (let i = 0; i < 1; i++) {
        AttributesContract.methods.retrievePublicKey().send({from: owner_account})
        .on('transactionHash', function(hash){
            policies_transactions["retrievePublicKey"].push(hash)
        })
    }
}
// ============================================================== //
// ============================================================== //
function isAddressOfController(){
    for (let i = 0; i < 1; i++) {
        AttributesContract.methods.isAddressOfController().send({from: owner_account})
        .on('transactionHash', function(hash){
            policies_transactions["isAddressOfController"].push(hash)
        })
    }
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