// Node
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:8545'); // your geth
// console.log(web3);

contracts = {}

const password = "";


var owner_account = '0x00a329c0648769A73afAc7F9381E08FB43dBEA72';
const account = null;
// unlockOwnerAccount(owner_account);

console.log("Deploying contracts...");
//// read contracts abi and byte codes
let decision_abi_source = fs.readFileSync("../bin/smart-contracts/Decision.abi");
let decision_bin_source = fs.readFileSync("../bin/smart-contracts/Decision.bin");
let contract_abi = JSON.parse(decision_abi_source);

let contracts_json = fs.readFileSync("contracts.json");
var contracts = JSON.parse(contracts_json);

var DecisionContract = new web3.eth.Contract(contract_abi, contracts["Decision"]);

decision_transactions = {
    "startSmartContract" : [],    
}

startSmartContract();

// ============================================================== //
// ============================================================== //
function startSmartContract(){  
    web3.eth.personal.unlockAccount(owner_account, password, null);	  
    transact = DecisionContract.methods.startSmartContract("",123456789,3,"0x5e6512e0e140308e7ca43c17aa6f7b462cad5587251a440fa8a93f07c45d0315","0x997197c8e37b3b469e7606252effb8889d2a3f16f4569389bc605a08f9697cd018e95de57aef7efee1d8cc02b3ec4fa793b98d75c5bd4e7837f0779df76ca3831b",255).send({from: owner_account})
    .on('transactionHash', function(hash){
        decision_transactions["startSmartContract"].push(hash)
    })
    .on('receipt', function(result){
        console.log(result);
    });
}

// ============================================================== //
// ============================================================== //
function save_json(){
    var jsonContent = JSON.stringify(attributes_transactions);
    // console.log(jsonContent);
    fs.writeFile("decision-transactions.json", jsonContent, 'utf8', function (err) {
        if (err) {
            console.log("An error occured while writing JSON Object to File.");
            return console.log(err);
        }
        console.log("JSON file has been saved.");
    });
}

// ============================================================== //
// ============================================================== //