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
const account = null;
// unlockOwnerAccount(owner_account);

main();
async function main(){

    console.log("Deploying contracts...");
    // read contracts abi and byte codes
    let decision_abi_source = fs.readFileSync("../bin/smart-contracts/Decision.abi");
    let decision_bin_source = fs.readFileSync("../bin/smart-contracts/Decision.bin");
    deployContract("Decision", decision_abi_source, decision_bin_source);
    await sleep(2000);

    // unlockOwnerAccount(owner_account);
    let policies_abi_source = fs.readFileSync("../bin/smart-contracts/Policies.abi");
    let policies_bin_source = fs.readFileSync("../bin/smart-contracts/Policies.bin");
    deployContract("Policies", policies_abi_source, policies_bin_source);
    await sleep(2000);

    // unlockOwnerAccount(owner_account);
    let data_access_abi_source = fs.readFileSync("../bin/smart-contracts/Data_Access.abi");
    let data_access_bin_source = fs.readFileSync("../bin/smart-contracts/Data_Access.bin");
    deployContract("Data-Access", data_access_abi_source, data_access_bin_source);
    await sleep(2000);
    // web3.eth.personal.unlockAccount(owner_account, password, null);	

    // unlockOwnerAccount(owner_account);
    let attributes_abi_source = fs.readFileSync("../bin/smart-contracts/Attributes.abi");
    let attributes_bin_source = fs.readFileSync("../bin/smart-contracts/Attributes.bin");
    deployContract("Attributes", attributes_abi_source, attributes_bin_source, save=true);
}
// unlockOwnerAccount(owner_account);

// console.log(contracts);

// function unlockOwnerAccount(owner_account, unlock_duration_sec) {
// 	if (typeof (unlock_duration_sec) === 'undefined') unlock_duration_sec = "0x000000000000000000000000000000";

// 	let account = web3.eth.personal.unlockAccount(owner_account, password);	
//     console.log(account);

//     return account;
// }
function sleep(ms) {
    return new Promise(
      resolve => setTimeout(resolve, ms)
    );
  }

function save_json(){
    var jsonContent = JSON.stringify(contracts);
    // console.log(jsonContent);
    fs.writeFile("contracts.json", jsonContent, 'utf8', function (err) {
        if (err) {
            console.log("An error occured while writing JSON Object to File.");
            return console.log(err);
        }
        console.log("JSON file has been saved.");
    });
}

function deployContract(contract_name, abi, bin, save=false) {

    web3.eth.personal.unlockAccount(owner_account, password, null);	

    let contract_abi = JSON.parse(abi);
    let contract_bin = "0x" + bin;

    let myContract = new web3.eth.Contract(contract_abi);
    myContract
    .deploy({data: contract_bin})
    .send({from: owner_account, gas: 2296521})
    .on('transactionHash', function(transactionHash){ 
        contracts[contract_name+"-tx"] = transactionHash;
     })
    .then(function(newContractInstance){
        // console.log("Contract address = ",newContractInstance.options.address);
        contracts[contract_name] = newContractInstance.options.address;
        console.log(newContractInstance);
        if(save){
            save_json();
        }
    })

    // Transaction has entered to geth memory pool
    console.log("Your contract is being deployed in transaction at http://localhost:8540");
    // console.log("Contract = ", deployedContract);    
    return;
}