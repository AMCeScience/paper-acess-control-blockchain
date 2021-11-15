
// Node
const fs = require("fs");
const Web3 = require('web3'); 

var web3 = new Web3('http://127.0.0.1:8545'); // your geth

web3.eth.getTransaction("0x328763d91bde1cad765e6f99ed405ce646872c5131a64ca183c1627d83fd8908", function (error, result){
    console.log(result);
    console.log(Buffer.byteLength(result.raw, 'utf8'));
}); 
