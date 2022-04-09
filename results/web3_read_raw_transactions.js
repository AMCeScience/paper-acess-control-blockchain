
// Node
const { NONAME } = require("dns");
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:22000'); // your geth

// results = {
//     "transactions" : {
//         "latencyAvg" : null,
//         "gasUsed" : [],
//         "size" : null
//     },
//     "blocks" : {},
//     "tps" : null,
//     "latency" : [],
// }

results = {
    0 : {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },
    1 : {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },
    2 : {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },
    3 : {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },
    4 : {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },
    5 : {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },
    6 : {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },
    7 : {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },
    8 : {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },
    9 : {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },
    10 : {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },
    11: {
        "transactions" : {
            "latencyAvg" : null,
            "gasUsed" : [],
            "size" : null
        },
        "blocks" : {},
        "tps" : null,
        "latency" : [],
    },

}

main();

async function main(){
    // Read results transactiosn and get relevant metrics
    let transaction_results = fs.readFileSync("results-output-request-IBFT-uint256.json");
    transaction_results = JSON.parse(transaction_results);    
    await read(transaction_results);
    save_json("processed-results/request-IBFT-uint256.json")
    
}

// ============================================================== //
// ============================================================== //
// async function read(transaction_results){
//     //timestamp from python3 ex 1648638306.705707
//     let i = 0
//     let tps = 0
//     let tmp_block = null
//     let latency = 0
//     for (const [key, value] of Object.entries(transaction_results)) {        
//         result = await web3.eth.getTransactionReceipt(key);
//         // console.log(result);                  
//         block = await web3.eth.getBlock(result.blockNumber) 
//         if (block != tmp_block){
//             tps += block.transactions.length
//             tmp_block = block
//             results["blocks"][result.blockNumber] = {
//                 "transactions" : block.transactions.length,
//                 "size" : block.size,
//                 "gasUsed" : block.gasUsed,                
//             }
//         }
//         i += 1;
//         latency += result.blockNumber - value["txSentCurrentBlockNumber"]        
//         results["latency"].push((result.blockNumber - value["txSentCurrentBlockNumber"]))
//         results["transactions"]["gasUsed"].push(result.gasUsed)
//         // results["latency"].append(result.blockNumber - value["txSentCurrentBlockNumber"])
//     }
    
//     results["transactions"]["size"] = Buffer.byteLength(JSON.stringify(result), 'utf8')
//     results["transactions"]["latencyAvg"] = latency / i
//     results["tps"] = tps / i

// }

// ============================================================== //
// ============================================================== //
async function read(transaction_results){
    //timestamp from python3 ex 1648638306.705707    
    for (let j = 1; j < 11; j++) { 
        let i = 0
        let tps = 0
        let tmp_block = null
        let latency = 0
        for (const [key, value] of Object.entries(transaction_results[j])) {        
            result = await web3.eth.getTransactionReceipt(key);
            // console.log(result);                  
            block = await web3.eth.getBlock(result.blockNumber) 
            if (block != tmp_block){
                tps += block.transactions.length
                tmp_block = block
                results[j]["blocks"][result.blockNumber] = {
                    "transactions" : block.transactions.length,
                    "size" : block.size,
                    "gasUsed" : block.gasUsed,                
                }
            }
            i += 1;
            latency += result.blockNumber - value["txSentCurrentBlockNumber"]        
            results[j]["latency"].push((result.blockNumber - value["txSentCurrentBlockNumber"]))
            results[j]["transactions"]["gasUsed"].push(result.gasUsed)
            // results["latency"].append(result.blockNumber - value["txSentCurrentBlockNumber"])
        }
        results[j]["transactions"]["size"] = Buffer.byteLength(JSON.stringify(result), 'utf8')
        results[j]["transactions"]["latencyAvg"] = latency / i
        results[j]["tps"] = tps / i
    }            

}

function save_json(filename){
    let data = JSON.stringify(results);
    fs.writeFileSync(filename, data);
}