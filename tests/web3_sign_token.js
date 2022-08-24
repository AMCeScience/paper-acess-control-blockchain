// const Accounts = require('web3-eth-accounts');
const Web3 = require("web3");

// const public_key = "043ab";
const public_key = "043ab";
const signerAddress = "";
const pwd = "";
const attributes = 255
// var accounts = new Accounts('ws://localhost:8546');

// Setup web3 client to localhost private network
var web3 = new Web3('http://127.0.0.1:22000'); // your geth

// ===================================================================== //
///////////////  This section signs a message ( attributes + public key)

console.log(Date.now());
generateSignedAuthToken(attributes, public_key, signerAddress, pwd)
// ===================================================================== //

async function generateSignedAuthToken(attributes, public_key, address, password) {
	accounts = await web3.eth.getAccounts(); 
	const encoded = web3.eth.abi.encodeParameters(['uint8', 'string'], [attributes, public_key]);
	console.log("Encoded = ", encoded)
	const hash = web3.utils.sha3(encoded, { encoding: 'hex' });
	console.log("Generated hash = ", hash);
	var signedMessage = await web3.eth.personal.sign(hash, accounts[4], password);
	console.log("Signed message = ", signedMessage.toString('hex'));
	var recoveredAddress = await web3.eth.personal.ecRecover(hash, signedMessage.toString('hex'))
	console.log(recoveredAddress);

	// console.log("hex = ", web3.utils.asciiToHex(hash))
	// console.log("bytes32 = ", web3.utils.hexToBytes(web3.utils.asciiToHex(hash)).length)	
}