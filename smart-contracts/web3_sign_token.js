// const Accounts = require('web3-eth-accounts');
const Web3 = require("web3");

const public_key = "random-public-key";
const signerAddress = "0x00a329c0648769A73afAc7F9381E08FB43dBEA72";
const pwd = "";
// var accounts = new Accounts('ws://localhost:8546');

// Setup web3 client to localhost private network
var web3 = new Web3('http://127.0.0.1:8545'); // your geth

// ===================================================================== //
///////////////  This section signs a message ( attributes + public key)
generateSignedAuthToken(255, public_key, signerAddress, pwd)
// ===================================================================== //

function generateSignedAuthToken(attributes, public_key, address, password) {
	const encoded = web3.eth.abi.encodeParameters(['uint8', 'string'], [attributes, public_key]);
	const hash = web3.utils.sha3(encoded, { encoding: 'hex' });
	console.log("Generated hash = ", hash);
	var signedMessage = web3.eth.personal.sign(hash, address, password).then(e => console.log("Signed authToken =", e));
   console.log(signedMessage);
	var recoveredAddress = web3.eth.personal.ecRecover(hash, "0x997197c8e37b3b469e7606252effb8889d2a3f16f4569389bc605a08f9697cd018e95de57aef7efee1d8cc02b3ec4fa793b98d75c5bd4e7837f0779df76ca3831b").then(e => console.log("Recovered address = ", e));

}