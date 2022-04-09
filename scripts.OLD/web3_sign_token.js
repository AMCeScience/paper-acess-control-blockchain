// const Accounts = require('web3-eth-accounts');
const Web3 = require("web3");

const public_key = "043ca2e15917499a0c7de20f03a17b82a0aab1450dcaa0d704c5d969090bc10a2b1e3e60ef1d17b5201b2c35b124058cb1e034305574dfccdffda9e895a813672b";
const signerAddress = "0x3A45EE1ED4625bE56074a8722c1bdf7a8B42dfB5";
const pwd = "";
const attributes = 255
// var accounts = new Accounts('ws://localhost:8546');

// Setup web3 client to localhost private network
var web3 = new Web3('http://127.0.0.1:22000'); // your geth

// ===================================================================== //
///////////////  This section signs a message ( attributes + public key)
generateSignedAuthToken(attributes, public_key, signerAddress, pwd)
// ===================================================================== //

function generateSignedAuthToken(attributes, public_key, address, password) {
	const encoded = web3.eth.abi.encodeParameters(['uint8', 'string'], [attributes, public_key]);
	const hash = web3.utils.sha3(encoded, { encoding: 'hex' });
	console.log("Generated hash = ", hash);
	var signedMessage = web3.eth.personal.sign(hash, address, password).then(e => console.log("Signed authToken =", e));
   console.log(signedMessage);
	var recoveredAddress = web3.eth.personal.ecRecover(hash, "0xcc49b1b96f2cfafb0b876caac37f23de7e9db46bfb353d9a25b4f717d85fbfa949147635cc790559b2165c92028c7645c3b32f95becf4ba971801f3dcbb1a39c1b").then(e => console.log("Recovered address = ", e));
	console.log(recoveredAddress);

}