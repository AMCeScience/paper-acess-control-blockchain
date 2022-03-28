// imports and setup
const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const fs = require("fs");
const { mainModule } = require('process');
var EthUtil = require('ethereumjs-util');

let local_ganache_provider_url = "http://127.0.0.1:7545"
let quorum_provider_url = "http://localhost:22000"

// const web3 = new Web3(local_ganache_provider_url);
const web3 = new Web3(quorum_provider_url);


const attributes_interface = fs.readFileSync("../bin/smart-contracts/Attributes.abi");
const attributes_bytecode = fs.readFileSync("../bin/smart-contracts/Attributes.bin");

const policies_interface = fs.readFileSync("../bin/smart-contracts/Policies.abi");
const policies_bytecode = fs.readFileSync("../bin/smart-contracts/Policies.bin");

const data_access_interface = fs.readFileSync("../bin/smart-contracts/DataAccess.abi");
const data_access_bytecode = fs.readFileSync("../bin/smart-contracts/DataAccess.bin");

const decision_interface = fs.readFileSync("../bin/smart-contracts/Decision.abi");
const decision_bytecode = fs.readFileSync("../bin/smart-contracts/Decision.bin");




let accounts;
let attributes;
let policies;
let data_access;
let decision;
let gaslimit = 3000000

main();

function main(){
    runSetupTests();
    runAccessTests()
}


function runSetupTests(){
    beforeEach(async () => {        
        accounts = await web3.eth.getAccounts();        
        let bytecode = "0x" + attributes_bytecode;
        attributes = await new web3.eth.Contract(JSON.parse(attributes_interface))
            .deploy({ data: bytecode })
            .send({ from: accounts[0], gas: '3000000' });        
    });
    
    beforeEach(async () => {
        accounts = await web3.eth.getAccounts();    
        let bytecode = "0x" + policies_bytecode;
        policies = await new web3.eth.Contract(JSON.parse(policies_interface))
            .deploy({ data: bytecode })
            .send({ from: accounts[0], gas: '3000000' });
    });

    beforeEach(async () => {
        accounts = await web3.eth.getAccounts();    
        let bytecode = "0x" + data_access_bytecode;
        data_access = await new web3.eth.Contract(JSON.parse(data_access_interface))
            .deploy({ data: bytecode })
            .send({ from: accounts[0], gas: '3000000' });
    });

    beforeEach(async () => {
        accounts = await web3.eth.getAccounts();    
        let bytecode = "0x" + decision_bytecode;
        decision = await new web3.eth.Contract(JSON.parse(decision_interface))
            .deploy({ data: bytecode })
            .send({ from: accounts[0], gas: '3000000' });
    });



    describe('Attributes (PIP) contract', () => {
        it('deploys the Attributes contract', () => {              
            assert.ok(attributes.options.address);          
        });

        it('adds a controller', async () => {
            await attributes.methods.addController(accounts[0]).send({
              from: accounts[0]
            });
        
            const controller_bool = await attributes.methods.isAddressAnOrg(accounts[0]).call();
            assert(controller_bool);            
        });
        it('adds a processor under the controller', async () => {
            let pk = "043ab";
            await attributes.methods.setPublicKey(accounts[0], accounts[0], pk).send({
              from: accounts[0],
              gas: gaslimit
            });
        
            const retrieved_pk = await attributes.methods.retrieveProcessorPublicKey(accounts[0], accounts[0]).call();
            assert.equal(pk, retrieved_pk);            
        });
    });

    describe('Policies (PAP) contract', () => {
        it('deploys the Policies contract', async () => {        
            assert.ok(policies.options.address);
          
        });
        it('creates a policy', async () => {
            let context_expression = "1";
            let actions = 224;
            let resource_id = 123456789;
            let policy = 255;
            let conventional_access = true;
            let emergency_access = false;           
            await policies.methods.createPolicy(context_expression, actions, resource_id, policy, conventional_access, emergency_access).send({
              from: accounts[0],
              gas: gaslimit
            });
        
            const loaded_policy = await policies.methods.loadPolicy(context_expression, actions, resource_id).call();            
            assert.equal(loaded_policy["context_expression"], context_expression);
            assert.equal(loaded_policy["policy"], policy);
            assert.equal(loaded_policy["conventional_access"], conventional_access);
            assert.equal(loaded_policy["emergency_access"], emergency_access);

        });
    });

    describe('DataAccess (PEP) contract', () => {
        it('deploys the Data Access contract', () => {        
            assert.ok(data_access.options.address);          
        });        
        it('sets Attributes Contract address', async () => {
            await data_access.methods.setAttributesContractAddr(attributes.options.address).send({
              from: accounts[0]
            });
        
            const attributes_addr = await data_access.methods.getAttributesContractAddr().call();
        
            assert.strictEqual(attributes.options.address, attributes_addr);            
        });

        it('sets Decision Contract address', async () => {        
            await data_access.methods.setDecisionContractAddr(decision.options.address).send({
                from: accounts[0]
              });
          
              const decision_addr = await data_access.methods.getDecisionContractAddr().call();
          
              assert.strictEqual(decision.options.address, decision_addr);                     
        });
    });

    describe('Decision (PDP) contract', () => {
        it('deploys the Decision contract', () => {        
            assert.ok(decision.options.address);          
        });
        it('sets Attributes Contract address', async () => {
            await decision.methods.setAttributesContractAddr(attributes.options.address).send({
              from: accounts[0]
            });
        
            const attributes_addr = await decision.methods.getAttributesContractAddr().call();
        
            assert.strictEqual(attributes.options.address, attributes_addr);            
        });

        it('sets Policies Contract address', async () => {        
            await decision.methods.setPoliciesContractAddr(policies.options.address).send({
                from: accounts[0]
              });
          
              const policies_addr = await decision.methods.getPoliciesContractAddr().call();
          
              assert.strictEqual(policies.options.address, policies_addr);                     
        });

        it('sets DataAccess Contract address', async () => {        
            await decision.methods.setDataAccessContractAddr(data_access.options.address).send({
                from: accounts[0]
              });
          
              const data_access_addr = await decision.methods.getDataAccessContractAddr().call();
          
              assert.strictEqual(data_access.options.address, data_access_addr);                     
        });
    });
}

function runAccessTests(){
    let hash;
    let signedMessage;
    let recoveredAddress;
    let attrs;
    let msgHash;
    let signature;
    let pk;
    let private_key;

    describe('Access request', () => {
        it('generate access token', async () => {
            attrs = 255;            
            pk = "043ab";
            private_key = "7742f83a16bd514c3e7633705a51fea771deeecf5d498d305eb69e2c8bbd3dd3"            

            const encoded = web3.eth.abi.encodeParameters(['uint8', 'string'], [attrs, pk]);                     

            // Quorum
            hash = web3.utils.sha3(encoded, { encoding: 'hex' });            
            signedMessage = await web3.eth.personal.sign(hash, accounts[0], "")            
            recoveredAddress = await web3.eth.personal.ecRecover(hash, signedMessage.toString('hex'))            

            // Ganache
            // const encoded = await web3.eth.abi.encodeParameters(['uint8', 'string'], [attributes, pk]);
            // const hash = await web3.utils.sha3(encoded, { encoding: 'hex' });                                            
            // msgHash = EthUtil.hashPersonalMessage(new Buffer(encoded));
            // signature = EthUtil.ecsign(msgHash, new Buffer(private_key, 'hex')); 
            // let signatureRPC = EthUtil.toRpcSig(signature.v, signature.r, signature.s)

            assert(accounts[0], recoveredAddress);            
        });



        it('request access', async () => {                            
            await data_access.methods.requestAccess("1", 123456789, 224, web3.utils.hexToBytes(web3.utils.asciiToHex(hash)), web3.utils.hexToBytes(web3.utils.asciiToHex(signedMessage)), attrs).send({
                from: accounts[0],
                gas: gaslimit
            });
          
            assert(true);
        });

        it('verify access', async () => {                            
            await data_access.methods.requestAccess(pk, 123456789, "1", 224, new Date.now()).send({
                from: accounts[0],
                gas: gaslimit
            });
          
            assert(true);                     
        });
    });
}