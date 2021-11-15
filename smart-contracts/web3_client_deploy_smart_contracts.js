// Node
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://localhost:8541'); // your geth
console.log(web3);

contracts = {}

const password = "node0";

// Unlock the coinbase account to make transactions out of it
console.log("Unlocking contract owner account...");
var owner_account = '0x00Bd138aBD70e2F00903268F3Db08f2D25677C9e';
const account = null;
// unlockOwnerAccount(owner_account);

console.log("Deploying contracts...");
//// read contracts abi and byte codes
let core_abi_source = fs.readFileSync("../bin/smart-contracts/ABAC_Access_Control.abi");
let core_bin_source = fs.readFileSync("../bin/smart-contracts/ABAC_Access_Control.bin");
deployContract("Core", core_abi_source, core_bin_source);

// // unlockOwnerAccount(owner_account);
// let abac_policies_abi_source = fs.readFileSync("../bin/smart-contracts/ABAC_Policies.abi");
// let abac_policies_bin_source = fs.readFileSync("../bin/smart-contracts/ABAC_Policies.bin");
// deployContract("Policies", abac_policies_abi_source, abac_policies_bin_source);

// // unlockOwnerAccount(owner_account);
// let address_pubk_mapping_abi_source = fs.readFileSync("../bin/smart-contracts/Address_PubKey_Mapping.abi");
// let address_pubk_mapping_bin_source = fs.readFileSync("../bin/smart-contracts/Address_PubKey_Mapping.bin");
// deployContract("Address-to-Public-Key Mapping", address_pubk_mapping_abi_source, address_pubk_mapping_bin_source);

// // unlockOwnerAccount(owner_account);
// let cloud_access_abi_source = fs.readFileSync("../bin/smart-contracts/Cloud_Accesses.abi");
// let cloud_access_bin_source = fs.readFileSync("../bin/smart-contracts/Cloud_Accesses.bin");
// deployContract("Cloud Access", cloud_access_abi_source, cloud_access_bin_source);

// // unlockOwnerAccount(owner_account);
// let contextual_attributes_abi_source = fs.readFileSync("../bin/smart-contracts/Contextual_Attributes.abi");
// let contextual_attributes_bin_source = fs.readFileSync("../bin/smart-contracts/Contextual_Attributes.bin");
// deployContract("Contextual Attributes", contextual_attributes_abi_source, cloud_access_bin_source);
// // unlockOwnerAccount(owner_account);

console.log(contracts);

// function unlockOwnerAccount(owner_account, unlock_duration_sec) {
// 	if (typeof (unlock_duration_sec) === 'undefined') unlock_duration_sec = "0x000000000000000000000000000000";

// 	let account = web3.eth.personal.unlockAccount(owner_account, password);	
//     console.log(account);

//     return account;
// }

function deployContract(contract_name, abi, bin){

    web3.eth.personal.unlockAccount(owner_account, password, null);	

    let contract_abi = JSON.parse(abi);
    let contract_bin = "0x" + bin;    

    let myContract = new web3.eth.Contract(contract_abi);
    myContract
    .deploy({data: contract_bin})
    .send({from: owner_account})
    .then(function(newContractInstance){
        // console.log("Contract address = ",newContractInstance.options.address);
        contracts[contract_name] = newContractInstance.options.address;
    })

    // Transaction has entered to geth memory pool
    console.log("Your contract is being deployed in transaction at http://localhost:8545");
    // console.log("Contract = ", deployedContract);
    return;
}