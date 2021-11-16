
// Node
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:8545'); // your geth


// ============================================================== //
// Read transactions and get gas | bytes
// let contracts_json = fs.readFileSync("contracts.json");
// let contracts = JSON.parse(contracts_json);
// deploy_contracts_transactions(contracts); 
// ============================================================== //

// ============================================================== //
// Read transactions and get gas | bytes
let policies_transactions_json = fs.readFileSync("policies-transactions.json");
policies_transactions_json = JSON.parse(policies_transactions_json);
policies_transactions(policies_transactions_json) ;
// ========= //

// ============================================================== //
// ============================================================== //
function policies_transactions(transactions){
    console.log(transactions["createPolicy"]);
    console.log(transactions["queryPolicy"]);
    web3.eth.getTransaction(transactions["createPolicy"][0], function (error, result){
        // console.log(result);
        console.log(result.gas);
        console.log(Buffer.byteLength(result.raw, 'utf8'));
    });

    web3.eth.getTransaction(transactions["queryPolicy"][0], function (error, result){
        // console.log(result);
        console.log(result.gas);
        console.log(Buffer.byteLength(result.raw, 'utf8'));
    });

    web3.eth.getTransactionReceipt(transactions["queryPolicy"][0], function (error, result){
        console.log(result);
    });
}

// ============================================================== //
// ============================================================== //
function deploy_contracts_transactions(contracts){
    web3.eth.getTransaction(contracts["Decision-tx"], function (error, result){
        // console.log(result);
        console.log(result.gas);
        console.log(Buffer.byteLength(result.raw, 'utf8'));
    });

    web3.eth.getTransaction(contracts["Policies-tx"], function (error, result){
        // console.log(result);
        console.log(result.gas);
        console.log(Buffer.byteLength(result.raw, 'utf8'));
    });

    web3.eth.getTransaction(contracts["Data-Access-tx"], function (error, result){
        // console.log(result);
        console.log(result.gas);
        console.log(Buffer.byteLength(result.raw, 'utf8'));
    });

    web3.eth.getTransaction(contracts["Attributes-tx"], function (error, result){
        // console.log(result);
        console.log(result.gas);
        console.log(Buffer.byteLength(result.raw, 'utf8'));
    });
}
// ============================================================== //