
// Node
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:8545'); // your geth

policies_experiments_results = {
    "loadPolicy" : {},
    "createPolicy" : {}
}

attributes_experiments_results = {
    "addController" : {},
    "deleteController" : {},
    "addStorage" : {},
    "deleteStorage" : {},
    "setPublicKey" : {},
    "retrievePublicKey" : {},
    "deletePublicKey" : {},
    "isAddressOfController" : {},
}

data_access_experiments_results = {
    "evaluateRequest" : {},
    "grantAccess" : {},
    "verifyAccess" : {},
    "revokeAccess" : {}
}

decision_experiments_results = {
    "startSmartContract" : {}
}

deployment_experiment_results = {
    "policiesContract" : {},
    "dataAccessContract" : {},
    "decisionContract": {},
    "attributesContract" : {}
}
main();

async function main(){
    // ============================================================== //
    // Read transactions and get gas | bytes
    // let contracts_json = fs.readFileSync("contracts.json");
    // let contracts = JSON.parse(contracts_json);
    // deploy_contracts_transactions(contracts); 

    // await sleep(2000);
    // save_json();

    // ============================================================== //
    // ============================================================== //
    
    // Read transactions and get gas | bytes
    // let policies_transactions_json = fs.readFileSync("policies-transactions.json");
    // policies_transactions_json = JSON.parse(policies_transactions_json);
    // policies_transactions(policies_transactions_json) ;

    // await sleep(2000);
    // save_json();

    // ============================================================== //
    // ============================================================== //
    // Read transactions and get gas | bytes
    // let attributes_transactions_json = fs.readFileSync("attributes-transactions.json");
    // attributes_transactions_json = JSON.parse(attributes_transactions_json);
    // attributes_transactions(attributes_transactions_json) ;

    // await sleep(2000);
    // save_json();

    // ============================================================== //
    // ============================================================== //
    // Read transactions and get gas | bytes
    // let data_access_transactions_json = fs.readFileSync("data-access-transactions.json");
    // data_access_transactions_json = JSON.parse(data_access_transactions_json);
    // data_access_transactions(data_access_transactions_json) ;

    // await sleep(2000);
    // save_json();

    // ============================================================== //
    // ============================================================== //
    // Read transactions and get gas | bytes
    let decision_transactions_json = fs.readFileSync("decision-transactions.json");
    decision_transactions_json = JSON.parse(decision_transactions_json);
    decision_transactions(decision_transactions_json) ;

    await sleep(2000);
    save_json();
}


// ============================================================== //
// ============================================================== //
function policies_transactions(transactions){
    web3.eth.getTransaction(transactions["createPolicy"][0], function (error, result){        
        policies_experiments_results["createPolicy"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });    

    web3.eth.getTransactionReceipt(transactions["createPolicy"][0], function (error, result){
        policies_experiments_results["createPolicy"]["gas-used"] = result.gasUsed;
        policies_experiments_results["createPolicy"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    web3.eth.getTransaction(transactions["loadPolicy"][0], function (error, result){
        policies_experiments_results["loadPolicy"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });

    web3.eth.getTransactionReceipt(transactions["loadPolicy"][0], function (error, result){
        policies_experiments_results["loadPolicy"]["gas-used"] = result.gasUsed;
        policies_experiments_results["loadPolicy"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });
}

// ============================================================== //
// ============================================================== //
function attributes_transactions(transactions){
    web3.eth.getTransaction(transactions["addController"][0], function (error, result){        
        attributes_experiments_results["addController"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });    

    web3.eth.getTransactionReceipt(transactions["addController"][0], function (error, result){
        attributes_experiments_results["addController"]["gas-used"] = result.gasUsed;
        attributes_experiments_results["addController"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    web3.eth.getTransaction(transactions["deleteController"][0], function (error, result){
        attributes_experiments_results["deleteController"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });

    web3.eth.getTransactionReceipt(transactions["deleteController"][0], function (error, result){
        attributes_experiments_results["deleteController"]["gas-used"] = result.gasUsed;
        attributes_experiments_results["deleteController"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    // ===== 

    web3.eth.getTransaction(transactions["addStorage"][0], function (error, result){        
        attributes_experiments_results["addStorage"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });    

    web3.eth.getTransactionReceipt(transactions["addStorage"][0], function (error, result){
        attributes_experiments_results["addStorage"]["gas-used"] = result.gasUsed;
        attributes_experiments_results["addStorage"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    web3.eth.getTransaction(transactions["deleteStorage"][0], function (error, result){
        attributes_experiments_results["deleteStorage"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });

    web3.eth.getTransactionReceipt(transactions["deleteStorage"][0], function (error, result){
        attributes_experiments_results["deleteStorage"]["gas-used"] = result.gasUsed;
        attributes_experiments_results["deleteStorage"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    // ===== 

    web3.eth.getTransaction(transactions["setPublicKey"][0], function (error, result){        
        attributes_experiments_results["setPublicKey"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });    

    web3.eth.getTransactionReceipt(transactions["setPublicKey"][0], function (error, result){
        attributes_experiments_results["setPublicKey"]["gas-used"] = result.gasUsed;
        attributes_experiments_results["setPublicKey"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    web3.eth.getTransaction(transactions["retrievePublicKey"][0], function (error, result){
        attributes_experiments_results["retrievePublicKey"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });

    web3.eth.getTransactionReceipt(transactions["retrievePublicKey"][0], function (error, result){
        attributes_experiments_results["retrievePublicKey"]["gas-used"] = result.gasUsed;
        attributes_experiments_results["retrievePublicKey"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    web3.eth.getTransaction(transactions["deletePublicKey"][0], function (error, result){
        attributes_experiments_results["deletePublicKey"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });

    web3.eth.getTransactionReceipt(transactions["deletePublicKey"][0], function (error, result){
        attributes_experiments_results["deletePublicKey"]["gas-used"] = result.gasUsed;
        attributes_experiments_results["deletePublicKey"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    // ===== 

    web3.eth.getTransaction(transactions["isAddressOfController"][0], function (error, result){        
        attributes_experiments_results["isAddressOfController"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });    

    web3.eth.getTransactionReceipt(transactions["isAddressOfController"][0], function (error, result){
        attributes_experiments_results["isAddressOfController"]["gas-used"] = result.gasUsed;
        attributes_experiments_results["isAddressOfController"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });    

}
// ============================================================== //
// ============================================================== //
function data_access_transactions(transactions){
    // web3.eth.getTransaction(transactions["evaluateRequest"][0], function (error, result){        
    //     data_access_experiments_results["evaluateRequest"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    // });    

    // web3.eth.getTransactionReceipt(transactions["evaluateRequest"][0], function (error, result){
    //     data_access_experiments_results["evaluateRequest"]["gas-used"] = result.gasUsed;
    //     data_access_experiments_results["evaluateRequest"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    // });

    web3.eth.getTransaction(transactions["grantAccess"][0], function (error, result){
        data_access_experiments_results["grantAccess"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });

    web3.eth.getTransactionReceipt(transactions["grantAccess"][0], function (error, result){
        data_access_experiments_results["grantAccess"]["gas-used"] = result.gasUsed;
        data_access_experiments_results["grantAccess"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    web3.eth.getTransaction(transactions["verifyAccess"][0], function (error, result){
        data_access_experiments_results["verifyAccess"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });

    web3.eth.getTransactionReceipt(transactions["verifyAccess"][0], function (error, result){
        data_access_experiments_results["verifyAccess"]["gas-used"] = result.gasUsed;
        data_access_experiments_results["verifyAccess"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    web3.eth.getTransaction(transactions["revokeAccess"][0], function (error, result){
        data_access_experiments_results["revokeAccess"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });

    web3.eth.getTransactionReceipt(transactions["revokeAccess"][0], function (error, result){
        data_access_experiments_results["revokeAccess"]["gas-used"] = result.gasUsed;
        data_access_experiments_results["revokeAccess"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

}
// ============================================================== //
// ============================================================== //
function decision_transactions(transactions){
    web3.eth.getTransaction(transactions["startSmartContract"][0], function (error, result){
        decision_experiments_results["startSmartContract"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });

    web3.eth.getTransactionReceipt(transactions["startSmartContract"][0], function (error, result){
        decision_experiments_results["startSmartContract"]["gas-used"] = result.gasUsed;
        decision_experiments_results["startSmartContract"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
        console.log(result);
    });
}


// ============================================================== //
// ============================================================== //
function deploy_contracts_transactions(contracts){
    // Decision smart contract transactions
    web3.eth.getTransaction(contracts["Decision-tx"], function (error, result){                
        deployment_experiment_results["decisionContract"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');   
        console.log(result);
    });

    web3.eth.getTransactionReceipt(contracts["Decision-tx"], function (error, result){
        deployment_experiment_results["decisionContract"]["gas-used"] = result.gasUsed; 
        deployment_experiment_results["decisionContract"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
        console.log(result);
    });

    // Policies smart contract transactions
    web3.eth.getTransaction(contracts["Policies-tx"], function (error, result){        
        deployment_experiment_results["policiesContract"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');   
    });

    web3.eth.getTransactionReceipt(contracts["Policies-tx"], function (error, result){
        deployment_experiment_results["policiesContract"]["gas-used"] = result.gasUsed; 
        deployment_experiment_results["policiesContract"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    // Data Access smart contract transactions
    web3.eth.getTransaction(contracts["Data-Access-tx"], function (error, result){        
        deployment_experiment_results["dataAccessContract"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });

    web3.eth.getTransactionReceipt(contracts["Data-Access-tx"], function (error, result){
        deployment_experiment_results["dataAccessContract"]["gas-used"] = result.gasUsed; 
        deployment_experiment_results["dataAccessContract"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });

    // Attributes smart contract transactions
    web3.eth.getTransaction(contracts["Attributes-tx"], function (error, result){                
        deployment_experiment_results["attributesContract"]["tx-size"] = Buffer.byteLength(result.raw, 'utf8');
    });

    web3.eth.getTransactionReceipt(contracts["Attributes-tx"], function (error, result){        
        deployment_experiment_results["attributesContract"]["gas-used"] = result.gasUsed; 
        deployment_experiment_results["attributesContract"]["tx-receipt-size"] = Buffer.byteLength(JSON.stringify(result), 'utf8');
    });
}

function save_json(){    
    var jsonContent = JSON.stringify(decision_experiments_results);
    // console.log(jsonContent);
    fs.writeFile("decision-experiments-results.json", jsonContent, 'utf8', function (err) {
        if (err) {
            console.log("An error occured while writing JSON Object to File.");
            return console.log(err);
        }
        console.log("JSON file has been saved.");
    });
}
// ============================================================== //

function sleep(ms) {
    return new Promise(
      resolve => setTimeout(resolve, ms)
    );
  }