// node
const EthCrypto = require('eth-crypto');
const Accounts = require('web3-eth-accounts');
const Web3 = require("web3");

const public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAi3z2yJ+VAn81XSLLpHtbfzCo4RtuxdgAS+n33TEU3l4s3lk2NY0I2dG15lufQgv4ahZXJ7phXL00yoERKswF2X4eldk58g0OEGYU9nxDCgyO68BqYyZ23+G+otFpySGWXhpTuClA3M9cK60DB5GxKpreI9DDkIO1+53bsXcwRlybOVSXUfFgQ47jZjCX+c2EF9KE8i4JZcOXUBX75BshwIlt27RaSdY2KdGVD9otdnERyM0dLvl8SeDhccFOgRNzsqd2h0orgJZ/IRxXXU/hEBgJdYsYEpUCEs5I0GheZSMctkeeOmM51vYhReP/HG0BbmnoSQW0nEODOdf/6Pm+xQIDAQAB";
const pwd = "123";
// var accounts = new Accounts('ws://localhost:8546');

// Setup web3 client to localhost private network
var web3 = new Web3('http://localhost:8545'); // your geth

// const artifactsPath = `browser/contracts/artifacts/${contractName}.json` // Change this for different path
let source = fs.readFileSync("ABAC_Ethereum_new.json");
let contracts = JSON.parse(source)["contracts"];
// ABI description as JSON structure
let abi = JSON.parse(contracts.SampleContract.abi);
// Create Contract proxy class
let SampleContract = web3.eth.contract(abi);

// ===================================================================== //
////////////// This section creates a local account
// var accounts = new Accounts('http://localhost:8545');
// var account = web3.eth.accounts.create();
// console.log(account);
// ===================================================================== //


// ===================================================================== //
////////////// This section creates the accounts on the nodes
// acc = accounts.create();
// var account = web3.eth.accounts.create();
// for (let i = 0; i < 2; i++) {
// 	var account = web3.eth.personal.newAccount("#123456!?");
// 	console.log(account);
// }

// List accounts
// accounts = web3.eth.getAccounts();
// accounts.then(e => console.log(e));
// ===================================================================== //


// ===================================================================== //
/////////////////  This section unlocks all accounts permanently
// var accs = [
//   // '0x00a329c0648769A73afAc7F9381E08FB43dBEA72',
//   '0x080bE823c56D003422d66140d23B8605111b9b2F',
//   '0x19179E830d98f9B24cE5F3349BFf1f87855Dc064',
//   '0x23C3330d6264ae7c4216777869c9B2d1894AC7dE',
//   '0x403c96eB53046Db1fE0e868427EAC06F8FfCb058',
//   '0x48d1Ed6227771F36a1dd41D43fCa3677d47c96b7',
//   '0x4f327e102D92c5687c96e8765368298d3116b09f',
//   '0x540AAA384A391C25430Fe2089937098e84734E6c',
//   '0x5647b32744933cD65E1ed3241e93027c3639F603',
//   '0x73b1923fbaf01458C29767579eD732b6B5f3064A',
//   '0x8a3b26c4feBA3Fd8c0E973bd25a5Ba77D8Ed5365',
//   '0xd19b92317E574aA1E8F67015F9B29d2752cAE900',
//   '0xdb5d44F8c1aB2e24c8757863A36c38D75D4af6fc',
//   '0xF6A5AD7b59898F1e0715C7C2F6Aa4A96105874c3'
// ]

// unlockAccounts(accs, "0x00000000000000000000000000012c");
// ===================================================================== //


// ===================================================================== //
/////////////////  This section signs a message ( attributes + public key)
generateSignedAuthToken(32, public_key, '0xd19b92317E574aA1E8F67015F9B29d2752cAE900', pwd)
// ===================================================================== //


function generateSignedAuthToken(attributes, public_key, address, password){
	const encoded = web3.eth.abi.encodeParameters(['uint8', 'string'],[attributes, public_key]);
	const hash = web3.utils.sha3(encoded, {encoding: 'hex'});
	console.log("Generated hash = ", hash);
	var signedMessage = web3.eth.personal.sign(hash, address, password).then(e => console.log("Signed hash =", e));
	var recoveredAddress = web3.eth.personal.ecRecover(hash, "0xc8e3109431ad4485c707ed75c8f86e355ab9d81ec8497626deaddc86aefd8d2774587b1763dce8b02f7b676209dcd226b6f5106f2c92ff4d8c807379acb686f01b").then(e => console.log("Recovered access = ", e));
}


function unlockAccounts(accounts, unlock_duration_sec) {
    if (typeof(unlock_duration_sec)==='undefined') unlock_duration_sec = "0x00000000000000000000000000012c";
    
    for (let i = 0; i < accounts.length; i++) {
		var account = web3.eth.personal.unlockAccount(accounts[i], pwd, null);		
	}
    
}