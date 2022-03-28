// Node
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:8545'); // your geth

const password = "";
var owner_account = '0x00a329c0648769A73afAc7F9381E08FB43dBEA72';

var DecisionContract = null;
var DataAccessContract = null;

var contracts = null;
main(); 
async function main(){
    let contracts_json = fs.readFileSync("contracts.json");
    contracts = JSON.parse(contracts_json);

    let decision_abi_source = fs.readFileSync("../bin/smart-contracts/Decision.abi");
    let decision_contract_abi = JSON.parse(decision_abi_source);

    let data_access_abi_source = fs.readFileSync("../bin/smart-contracts/Data_Access.abi");    
    let data_access_contract_abi = JSON.parse(data_access_abi_source);

    DecisionContract = new web3.eth.Contract(decision_contract_abi, contracts["Decision"]);
    DataAccessContract = new web3.eth.Contract(data_access_contract_abi, contracts["Data-Access"]);

    set_contract_addresses_1();
    await sleep(2000);

    set_contract_addresses_2();
    await sleep(2000);

    set_contract_addresses_3();
    await sleep(2000);

    set_contract_addresses_4();
    await sleep(2000);

    set_contract_addresses_5();
    await sleep(2000);
}

function set_contract_addresses_1(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    transact = DataAccessContract.methods.setDecisionContractAddr(contracts["Decision"]).send({from: owner_account})
    .on('receipt', function(result){
        console.log(result);
    });
}

function set_contract_addresses_2(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    transact = DataAccessContract.methods.setAttributesContractAddr(contracts["Attributes"]).send({from: owner_account})
    .on('receipt', function(result){
        console.log(result);
    });
}

function set_contract_addresses_3(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    transact = DecisionContract.methods.setAttributesContractAddr(contracts["Attributes"]).send({from: owner_account})
    .on('receipt', function(result){
        console.log(result);
    });
}

function set_contract_addresses_4(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    transact = DecisionContract.methods.setDataAccessContractAddr(contracts["Data-Access"]).send({from: owner_account})
    .on('receipt', function(result){
        console.log(result);
    });
}

function set_contract_addresses_5(){
    web3.eth.personal.unlockAccount(owner_account, password, null);
    transact = DecisionContract.methods.setPoliciesContractAddr(contracts["Policies"]).send({from: owner_account})
    .on('receipt', function(result){
        console.log(result);
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