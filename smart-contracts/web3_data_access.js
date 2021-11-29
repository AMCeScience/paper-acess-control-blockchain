// Node
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:8545'); // your geth
// console.log(web3);

contracts = {}

const password = "";

var DataAccessContract = null;

var authToken = "0x5e6512e0e140308e7ca43c17aa6f7b462cad5587251a440fa8a93f07c45d0315";
var signedAuthToken = "0x997197c8e37b3b469e7606252effb8889d2a3f16f4569389bc605a08f9697cd018e95de57aef7efee1d8cc02b3ec4fa793b98d75c5bd4e7837f0779df76ca3831b";

// Unlock the coinbase account to make transactions out of it
console.log("Unlocking contract owner account...");
var owner_account = '0x00a329c0648769A73afAc7F9381E08FB43dBEA72';
const account = null;
// unlockOwnerAccount(owner_account);

main ();

// ============================================================== //
// ============================================================== //

async function main(){
    //// read contracts abi and byte codes
    let data_access_abi_source = fs.readFileSync("../bin/smart-contracts/Data_Access.abi");
    let data_access_bin_source = fs.readFileSync("../bin/smart-contracts/Data_Access.bin");
    let contract_abi = JSON.parse(data_access_abi_source);

    let contracts_json = fs.readFileSync("contracts.json");
    let contracts = JSON.parse(contracts_json);
    
    DataAccessContract = new web3.eth.Contract(contract_abi, contracts["Data-Access"]);

    data_access_transactions = {
        "evaluateRequest" : [],
        "grantAccess" : [],
        "verifyAccess" : [],
        "revokeAccess" : []
    }

    evaluateRequest();
    await sleep(2000);

    // grantAccess();
    // await sleep(2000);

    // verifyAccess();
    // await sleep(2000);

    // revokeAccess();
    // await sleep(2000);

    save_json();
}
// ============================================================== //
// ============================================================== //
function evaluateRequest(){
    web3.eth.personal.unlockAccount(owner_account, password, null);	
    transact = DataAccessContract.methods.evaluateRequest("", 123456789, 3, authToken, signedAuthToken, 255).send({from: owner_account})
    .on('transactionHash', function(hash){
        data_access_transactions["evaluateRequest"].push(hash)        
    })
    .on('receipt', function(result){
        console.log(result);
    });
}

// ============================================================== //
// ============================================================== //
function grantAccess(){
    web3.eth.personal.unlockAccount(owner_account, password, null);	
    transact = DataAccessContract.methods.grantAccess("random-public-key", "emergency", 123456789, 3).send({from: owner_account})
    .on('transactionHash', function(hash){
        data_access_transactions["grantAccess"].push(hash)
    })
}

// ============================================================== //
// ============================================================== //
function verifyAccess(){
    web3.eth.personal.unlockAccount(owner_account, password, null);	
    transact = DataAccessContract.methods.verifyAccess("random-public-key", 123456789, "emergency", 3, 1000).send({from: owner_account})
    .on('transactionHash', function(hash){
        data_access_transactions["verifyAccess"].push(hash)
    })
}

// ============================================================== //
// ============================================================== //
function revokeAccess(){
    web3.eth.personal.unlockAccount(owner_account, password, null);	
    transact = DataAccessContract.methods.revokeAccess("random-public-key", 123456789, "emergency", 3).send({from: owner_account})
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
// ============================================================== //
function sleep(ms) {
    return new Promise(
      resolve => setTimeout(resolve, ms)
    );
}

// ============================================================== //
// ============================================================== //