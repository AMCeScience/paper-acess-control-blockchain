pragma solidity =0.8.7;
 
/**
 * @notice Minimal contract for testing purposes.
 */
contract TestContract {
    event AnchorCreated(string indexed blockHash, uint256 blockHeight);
    
    event validOrganisationSignature(address _controller_addr, bytes _signed_message);
    event invalidOrganisationSignature(address _controller_addr, bytes _signed_message);
    event invalidHashComparison(uint8 _attributes, string _public_key, bytes32 _hash);
    event validHashComparison(uint8 _attributes, string _public_key, bytes32 _hash);
    event attrsComplyingWithPolicy();
    event attrsNotComplyingWithPolicy();
    event addressSetted(address _contract, address _contract_address);

    event signerAddress(address _signerAddress);
    
    constructor() public {        
    }
    
    function splitSignature(bytes32 sig) internal pure returns(uint8, bytes32, bytes32) {
        require(sig.length == 65);

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {            
            r := mload(add(sig, 32))            
            s := mload(add(sig, 64))            
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function toBytes(address _address) public pure returns (bytes memory) {
        return abi.encodePacked(_address);
    }

    function startSmartContract(string memory _context_expression, uint256 _resource_id, uint8 _actions, bytes32 _hashed_token, bytes memory _signed_token, uint8 _attributes) public {        

        uint8 v;
        bytes32 r;
        bytes32 s;

        (v, r, s) = splitSignature(_hashed_token);

        address _signer_address = ecrecover(_hashed_token, v, r, s);
        // attributes_contract = Attributes(attributes_contract_addr);

        emit signerAddress(_signer_address);
        
        // if (orgSignValidated(_signer_address, _signed_token)) {            
        //     string memory sender_pk = attributes_contract.retrieveProcessorPublicKey(_signer_address,msg.sender);
        //     if (signatureAndProfessionalVerification(_hashed_token, _attributes, sender_pk)) {                
        //         requestAccess(_context_expression, sender_pk, _resource_id, _actions, _attributes);
        //         return;
        //     }
        // } else {
        //     return;
        // }
    }

    function signatureAndProfessionalVerification(bytes32 _hashed_token, uint8 _attr, string memory _public_key) public returns (bool) {
        bytes32 c = keccak256(abi.encode(_attr, _public_key));
        if (c == _hashed_token){
            emit validHashComparison(_attr, _public_key, _hashed_token);
            return true;
        }
        emit invalidHashComparison(_attr, _public_key, _hashed_token);
        return false;
    }
}