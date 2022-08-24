# Smart Access: Attribute-Based Access Control System based on Smart Contracts
This repo contains the source code for the Smart Access: Attribute-Based Access Control System based on Smart Contracts and relevant scripts to test & evaluate the implementation.

### Smart contracts
The smart-contracts folder contains.
1. The latest version of the SmartAccess contract: ```SmartAccessContract_AuditPoliciesFixed.sol```
2. Contracts used for tests inside smart-contracts/TESTS folder: ```BaselineContract.sol, BaselineContractCH.sol, TestAccessControlContract.sol, TestOPcodesContract.sol``` and different SmartAccessContract versions

### Tests
The tests folder contains:
1. The ```test-contract.js``` script that deploys each contract defined inside the ```SmartAccessContract.sol``` and tests each function necessary to setup the contracts storage and perform the access control. This test must be adapted for the latest version of the SmartAccess ```SmartAccessContract_AuditPoliciesFixed.sol```
2. The ```web3_sign_token.js``` script that generates an access token. The token is a required parameter to perform the access control

Before running the ```test-contract.js```. First it is necessary to deploy a ganache client or a quorum and set the correct provider/url inside the ```test-contract.js```. Then, just run the test-contract with nodeJS.


- #### Results
The ```results``` folder contains raw and processed data from tests regarding aspects of latency, scalability, transactions per second and gas consumed.
The tests were done using the ChainHammer framework.