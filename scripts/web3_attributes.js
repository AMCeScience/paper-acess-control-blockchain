// Node
const { create } = require("domain");
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:8545'); // your geth
// console.log(web3);

contracts = {}

var random_address = '0x008036356E4E87d8AC7abEC090340b549a905d9f';
var controller_address = '0x00a329c0648769A73afAc7F9381E08FB43dBEA72';

const password = "";

// Unlock the coinbase account to make transactions out of it
console.log("Unlocking contract owner account...");
var owner_account = '0x00a329c0648769A73afAc7F9381E08FB43dBEA72';
// web3.eth.personal.unlockAccount(owner_account, password, null);	
const account = null;

var PoliciesContract = null;
main ();

// ============================================================== //
// ============================================================== //

async function main(){
    //// read contracts abi and byte codes
    let attributes_abi_source = fs.readFileSync("../bin/smart-contracts/Attributes.abi");
    let attributes_bin_source = fs.readFileSync("../bin/smart-contracts/Attributes.bin");
    let contract_abi = JSON.parse(attributes_abi_source);

    let contracts_json = fs.readFileSync("contracts.json");
    let contracts = JSON.parse(contracts_json);

    AttributesContract = new web3.eth.Contract(contract_abi, contracts["Attributes"]);

    attributes_transactions = {
        "addController" : [],
        "deleteController" : [],
        "addStorage" : [],
        "deleteStorage" : [],
        "setPublicKey" : [],
        "retrievePublicKey" : [],
        "deletePublicKey" : [],
        "isAddressOfController" : []
    }
    
    addController();
    await sleep(2000);

    deleteController();
    await sleep(2000);

    addStorage();
    await sleep(2000);

    deleteStorage();
    await sleep(2000);
    
    setPublicKey();
    await sleep(2000);
    
    retrievePublicKey();
    await sleep(2000);

    deletePublicKey();
    await sleep(2000);

    isAddressOfController();
    await sleep(2000);

    save_json();
}


// ============================================================== //
function addController(){  
    web3.eth.personal.unlockAccount(owner_account, password, null);      
    AttributesContract.methods.addController(random_address).send({from: owner_account})
    .on('transactionHash', function(hash){
        attributes_transactions["addController"].push(hash);
    })    
}

function deleteController(){        
    web3.eth.personal.unlockAccount(owner_account, password, null);
    AttributesContract.methods.deleteController(random_address).send({from: owner_account})
    .on('transactionHash', function(hash){
        attributes_transactions["deleteController"].push(hash);
    })    
}
// ============================================================== //
// ============================================================== //
function addStorage(){        
    web3.eth.personal.unlockAccount(owner_account, password, null);
    AttributesContract.methods.addStorage(random_address).send({from: owner_account})
    .on('transactionHash', function(hash){
        attributes_transactions["addStorage"].push(hash);
    })    
}

function deleteStorage(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    AttributesContract.methods.deleteStorage(random_address).send({from: owner_account})
    .on('transactionHash', function(hash){
        attributes_transactions["deleteStorage"].push(hash);
    })    
}
// ============================================================== //
// ============================================================== //
// ============================================================== //
function setPublicKey(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    AttributesContract.methods.setPublicKey(random_address, random_address, "random-public-key").send({from: owner_account})
    .on('transactionHash', function(hash){
        attributes_transactions["setPublicKey"].push(hash)
    })    
}

// ============================================================== //
function retrievePublicKey(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    AttributesContract.methods.retrieveProcessorPublicKey(random_address, random_address).send({from: owner_account})
    .on('transactionHash', function(hash){
        attributes_transactions["retrievePublicKey"].push(hash)
    })    
}
// ============================================================== //
function deletePublicKey(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    AttributesContract.methods.deletePublicKey(random_address, random_address).send({from: owner_account})
    .on('transactionHash', function(hash){
        attributes_transactions["deletePublicKey"].push(hash)
    })    
}
// ============================================================== //
// ============================================================== //
function isAddressOfController(){
    web3.eth.personal.unlockAccount(owner_account, password, null);    
    AttributesContract.methods.isAddressAnOrg(random_address).send({from: owner_account})
    .on('transactionHash', function(hash){
        attributes_transactions["isAddressOfController"].push(hash)
    })    
}

// ============================================================== //
// ============================================================== //
function save_json(){
    var jsonContent = JSON.stringify(attributes_transactions);
    // console.log(jsonContent);
    fs.writeFile("attributes-transactions.json", jsonContent, 'utf8', function (err) {
        if (err) {
            console.log("An error occured while writing JSON Object to File.");
            return console.log(err);
        }
        console.log("JSON file has been saved.");
    });
}

// ============================================================== //
// ============================================================== //
function sleep(ms) {
    return new Promise(
      resolve => setTimeout(resolve, ms)
    );
}

// ============================================================== //
// ============================================================== //