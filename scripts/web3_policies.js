// ============================================================== //
const { create } = require("domain");
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:8545'); // your geth
// console.log(web3);

contracts = {}

const password = "";
var PoliciesContract = null;


// Unlock the coinbase account to make transactions out of it
console.log("Unlocking contract owner account...");
var owner_account = '0x00a329c0648769A73afAc7F9381E08FB43dBEA72';

main ();

// ============================================================== //
// ============================================================== //
//// read contracts abi and byte codes
async function main(){
    let policies_abi_source = fs.readFileSync("../bin/smart-contracts/Policies.abi");
    let policies_bin_source = fs.readFileSync("../bin/smart-contracts/Policies.bin");
    let contract_abi = JSON.parse(policies_abi_source);

    let contracts_json = fs.readFileSync("contracts.json");
    let contracts = JSON.parse(contracts_json);

    PoliciesContract = new web3.eth.Contract(contract_abi, contracts["Policies"]);

    policies_transactions = {
        "createPolicy" : [],
        "loadPolicy" : [],
        "retrievePolicy" : [],
        "changePolicy" : [],
        "deletePolicy" : []
    }

    createPolicy();

    await sleep(2000);

    loadPolicy();

    await sleep(2000);
    
    // changePolicy("");

    await sleep(2000);

    // deletePolicy("");

    await sleep(2000);

    save_json();
}

// ============================================================== //
// ============================================================== //
function createPolicy(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    PoliciesContract.methods.createPolicy("consent", 2, 1234567890, 7, true, false ).send({from: owner_account})
    .on('transactionHash', function(hash){
        policies_transactions["createPolicy"].push(hash)
    })
    .on('receipt', function(receipt){
        console.log(receipt);
    })
}

// ============================================================== //
// ============================================================== //
function loadPolicy(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    PoliciesContract.methods.loadPolicy("consent", 2, 1234567890).send({from: owner_account})
    .on('transactionHash', function(hash){
        policies_transactions["loadPolicy"].push(hash)
    })
    .on('receipt', function(receipt){
        console.log(receipt);
    })
}
// ============================================================== //
// ============================================================== //
function retrievePolicy(){
    return;
}

function changePolicy(uuid){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    PoliciesContract.methods.changePolicy(uuid, 7).send({from: owner_account})
    .on('transactionHash', function(hash){
        policies_transactions["changePolicy"].push(hash)
    })
    .on('receipt', function(receipt){
        console.log(receipt);
    })
}

function changePolicy(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    PoliciesContract.methods.deletePolicy("").send({from: owner_account})
    .on('transactionHash', function(hash){
        policies_transactions["deletePolicy"].push(hash)
    })
    .on('receipt', function(receipt){
        console.log(receipt);
    })
}
// ============================================================== //
// ============================================================== //
function save_json(){    
    var jsonContent = JSON.stringify(policies_transactions);
    // console.log(jsonContent);
    fs.writeFile("policies-transactions.json", jsonContent, 'utf8', function (err) {
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