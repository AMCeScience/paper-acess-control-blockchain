// SPDX-License-Identifier: MIT
//// ================================================================ ////
pragma solidity =0.8.7;
//// ================================================================ ////

//// ================================================================ ////
//// ================================================================ ////
//   ==================== Contract for policies =====================   //
contract Policies {
    // The policies are a combination of attributes
    // The struct contains policies as uint8, however each number represents an array of attributes. 
    // For example 255 represents [1 1 1 1 1 1 1 1]
    struct Policy {
        uint256 uuid;
        string context_expression;
        uint128 policy;
        // uint8[] policies;
        // string encrypted_mask; // encrypted_mask = example: {0: "Call centre professional", 1: "Ambulance professional" etc ...}
        bool conventional_access;
        bool emergency_access;
    }

    // Policies
    mapping(uint256 => Policy) internal _policies;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    event queriedPolicy(uint256 hash, Policy policy); // Event
    event createdPolicy(uint256 hash, Policy policy); // Event
    event changedPolicy(uint256 hash, Policy policy); // Event
    event deletedPolicy(uint256 hash, Policy policy); // Event
    event failedEvent(string description);


    // Creates a hash based on _context_expression to create the policy
    function hashPolicy(string memory _context_expression, uint8 _actions, uint256 _resource_id)
        public
        pure
        returns (uint256)
    {
        // require(msg.sender == owner);
        bytes32 val;
        val = sha256(abi.encodePacked(_context_expression, _actions, _resource_id));
        uint256 i = uint256(val);
        return i;
    }

    // Create a new policy with the number/array-of-attributes
    function createPolicy(string memory _context_expression, uint8 _actions, uint256 _resource_id, uint128 _policy, bool _conventional_access, bool _emergency_access)public{
    // function createPolicy(string memory _context_expression)public{
        require(msg.sender == owner);
        uint256 hash = hashPolicy(_context_expression, _actions, _resource_id);
        if (getPolicy(hash)) {
            emit failedEvent("createPolicy: Policy already exists");
            return;
        }
        _policies[hash] = Policy(
            hash,
            _context_expression,
            _policy,
            _conventional_access,
            _emergency_access

        );

        emit createdPolicy(hash, _policies[hash]);
        return;
    }

    // Queries the policy that matches the hash
    function loadPolicy(string memory _context_expression, uint8 _actions, uint256 _resource_id)
        public
        returns (Policy memory)
    {
        // require(msg.sender == owner);
        uint256 hash = hashPolicy(_context_expression, _actions, _resource_id);
        if (getPolicy(hash)) {
            emit queriedPolicy(hash, _policies[hash]);
            return _policies[hash];
        }
        return _policies[hash];
    }

    // Retrieves the policy that matches the uuid
    function retrievePolicy(uint256 _uuid) public returns (Policy memory) {
        require(msg.sender == owner);
        if (getPolicy(_uuid)) {
            emit queriedPolicy(_uuid, _policies[_uuid]);
            return _policies[_uuid];
            // NEED TO IMPROVE THIS USE CASE
        }
        return _policies[_uuid];
    }

    function changePolicy(uint256 _uuid, uint128 _policy) public {
        require(msg.sender == owner);
        if (getPolicy(_uuid)) {
            emit changedPolicy(_uuid, _policies[_uuid]);
            _policies[_uuid].policy = _policy;      
            return;
        }
        return;
    }

    function deletePolicy(uint256 _uuid) public {
        require(msg.sender == owner);
        if (getPolicy(_uuid)) {
            emit deletedPolicy(_uuid, _policies[_uuid]);
            delete _policies[_uuid];            
            return;
        }
    }

    function getPolicy(uint256 _uuid) internal view returns (bool) {
        if (_policies[_uuid].uuid == _uuid) {
            return true;
        }
        return false;
    }
}
//// ================================================================ ////
//// ================================================================ ////


//// ================================================================ ////
//// ================================================================ ////
//   ============ Contract for the main access control ==============   //
contract Decision {
    Policies policies_contract;    
    // Address_PubKey_Mapping addr_pubk_map;
    DataAccess data_access_contract;    
    Attributes attributes_contract;

    address policies_contract_addr;    
    address attributes_contract_addr;
    // address address_pubk_mapping_addr;
    address data_access_contract_addr;

    // string[] cloudTokens;

    uint256 organisation_uuid;
    uint256 admin;


    mapping (uint => bool) attr_map;

    address owner;

    constructor() {
        owner = msg.sender;
        attr_map[1] = true;
        attr_map[0] = false;
    }

    event validOrganisationSignature(address _controller_addr, bytes _signed_message);
    event invalidOrganisationSignature(address _controller_addr, bytes _signed_message);
    event invalidHashComparison(uint128 _attributes, string _public_key, bytes32 _hash);
    event validHashComparison(uint128 _attributes, string _public_key, bytes32 _hash);
    event attrsComplyingWithPolicy(Policies.Policy _policy, uint128 _attributes);
    event attrsNotComplyingWithPolicy(Policies.Policy _policy, uint128 _attributes);
    event addressSetted(address _contract, address _contract_address);

    event signerAddress(address _signerAddress);
    event numbers(uint8 v, bytes32 r, bytes32 s);

    function setPoliciesContractAddr(address _address) public {
        policies_contract_addr = _address;
    }    

    function setAttributesContractAddr(address _address) public {
        attributes_contract_addr = _address;
    }

    // function setAddressPubKeyMappingAddr(address _address) public {
    //     address_pubk_mapping_addr = _address;
    // }

    function setDataAccessContractAddr(address _address) public {
        data_access_contract_addr = _address;
    }
    
    function getAttributesContractAddr() public view returns(address){
        return attributes_contract_addr;
    }

    function getPoliciesContractAddr() public view returns(address){
        return policies_contract_addr;
    }

    function getDataAccessContractAddr() public view returns(address){
        return data_access_contract_addr;
    }

    function splitSignature(bytes memory sig) internal pure returns(uint8, bytes32, bytes32) {
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

    function evaluateRequest(string memory _context_expression, uint256 _resource_id, uint8 _actions, bytes32 _hashed_token, bytes memory _signed_token, uint128 _attributes, address _processor_addr) public {        

        uint8 v;
        bytes32 r;
        bytes32 s;

        (v, r, s) = splitSignature(_signed_token);
        emit numbers(v,r,s);

        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 _prefixed_hash = keccak256(abi.encodePacked(prefix, _hashed_token));

        address _signer_address = ecrecover(_prefixed_hash, v, r, s);
        attributes_contract = Attributes(attributes_contract_addr);

        emit signerAddress(_signer_address);
        
        if (orgSignValidated(_signer_address, _signed_token)) {            
            string memory sender_pk = attributes_contract.retrieveProcessorPublicKey(_signer_address, _processor_addr);
            if (signatureAndProfessionalVerification(_hashed_token, _attributes, sender_pk)) {                
                verifyPolicy(_context_expression, sender_pk, _resource_id, _actions, _attributes);
                return;
            }
        } else {
            return;
        }
    }

    function orgSignValidated(address _signer_address, bytes memory _signed_token) public returns (bool) {
        // attributes_contract = Attributes(attributes_contract_addr);
        if (attributes_contract.isAddressAnOrg(_signer_address)) {
            emit validOrganisationSignature(_signer_address, _signed_token);
            return true;
        } else {
            emit invalidOrganisationSignature(_signer_address, _signed_token);
            return false;
        }
    }

    function signatureAndProfessionalVerification(bytes32 _hashed_token, uint128 _attr, string memory _public_key) public returns (bool) {
        bytes32 c = keccak256(abi.encode(_attr, _public_key));
        if (c == _hashed_token){
            emit validHashComparison(_attr, _public_key, _hashed_token);
            return true;
        }
        emit invalidHashComparison(_attr, _public_key, _hashed_token);
        return false;
    }

    function verifyPolicy(string memory _context_expression, string memory _public_key, uint256 _resource_id, uint8 _actions, uint128 _attributes) public {
        Policies.Policy memory loaded_policy = loadPolicy(_context_expression, _actions, _resource_id);
        if(policyCompliant(loaded_policy, _attributes)){
            data_access_contract = DataAccess(data_access_contract_addr);
            data_access_contract.saveDecision(_public_key, _context_expression, _resource_id, _actions);
        }
        return;
    }

    function loadPolicy(string memory _context_expression, uint8 _actions, uint256 _resource_id)
        public
        returns (Policies.Policy memory)
    {
        policies_contract = Policies(policies_contract_addr);
        return policies_contract.loadPolicy(_context_expression, _actions, _resource_id);
    }    

    function policyCompliant(Policies.Policy memory loaded_policy, uint128 _attrs) public returns(bool){
        if ((bytes16(loaded_policy.policy) & bytes16(_attrs)) == bytes16(loaded_policy.policy)){
            if(loaded_policy.conventional_access){
                if(attributes_contract.getContextualAttribute(0, msg.sender, msg.sender)){
                    emit attrsComplyingWithPolicy(loaded_policy, _attrs);
                    return true;
                }                
            }

            if(loaded_policy.emergency_access){
                if(attributes_contract.getContextualAttribute(0, msg.sender, msg.sender)){
                    emit attrsComplyingWithPolicy(loaded_policy, _attrs);
                    return true;
                }                
            }
            emit attrsComplyingWithPolicy(loaded_policy, _attrs);
            return true;
        }else{
            emit attrsNotComplyingWithPolicy(loaded_policy, _attrs);
            return false;
        }                         
    }    
}

//// ================================================================ ////
//// ================================================================ ////
//// ======== Contract containing attributes and contextual =========   //
//   ======== attributes for emergency and conventional access =======   //
contract Attributes {
    event publicKeyAdded(address _controller_addr, address _processor_addr, string _processor_pk); // Event
    event publicKeyRetrieved( address _controller_addr, address _processor_addr, string _processor_pk); // Event
    event publicKeyDeleted(address _controller_addr, address _processor_addr, string _processor_pk); // Event
    event publicKeyNotFound(address _controller_addr, address _processor_addr);
    event organisationAddressNotFound(address _controller_addr); // Event    

    struct Emergency_Access {        
        address[] professionals;        
    }

    struct Conventional_Access {        
        address processor_addr;
        uint256 resource_id;        
    }


    // Controllers addresses and processors public keys attribuets mapping
    mapping(address => mapping(address => string)) internal address_pubk;
    mapping(address => bool) internal controllers;

    address owner;

    constructor() {
        owner = msg.sender;
    }
    
    // Contextual attributes mapping
    mapping(address => Emergency_Access) internal emergency_attributes;
    mapping(address => Conventional_Access) internal conventional_acess_attributes;


    function addContextualAttribute(uint8 _context_expression, address _processor_addr, address _data_subject_addr, uint256 _resource_id, bool _start_emergency, bool _end_emergency) public {
        if ((_context_expression) == 0){
            if(_start_emergency){                   
                emergency_attributes[_data_subject_addr] = Emergency_Access(new address[](5));
                emergency_attributes[_data_subject_addr].professionals.push(_processor_addr);
                return;
            }

            if(_end_emergency){
                delete emergency_attributes[_data_subject_addr];
                return;
            }
        }

        if ((_context_expression) == 1){
            conventional_acess_attributes[msg.sender] = Conventional_Access(_processor_addr, _resource_id);
        }
        return;
    }

    function getContextualAttribute(uint8 _context_expression, address _processor_addr, address _data_subject_addr) public view returns(bool){
        if ((_context_expression) == 0){
            for (uint i=0; i<emergency_attributes[_data_subject_addr].professionals.length; i++) {
                if(emergency_attributes[_data_subject_addr].professionals[i] == msg.sender){
                    return true;
                }
            }
        }

        if ((_context_expression) == 1){
            if(conventional_acess_attributes[_data_subject_addr].processor_addr == msg.sender){
                return true;
            }
        } 

        return false;
    }

    function revokeContextualAttribute(uint8 _context_expression, address _data_subject_addr) public {
        if ((_context_expression) == 0){
            for (uint i=0; i<emergency_attributes[_data_subject_addr].professionals.length; i++) {
                if(emergency_attributes[_data_subject_addr].professionals[i] == msg.sender){
                    delete emergency_attributes[_data_subject_addr].professionals[i-1];
                }
            }
        }

        if ((_context_expression) == 1){
            delete conventional_acess_attributes[msg.sender];
        }
        return;
    }

    function addController(address _controller_addr) public {
        require(msg.sender == owner);
        controllers[_controller_addr] = true;
        return;
    }

    function deleteController(address _controller_addr) public {
        require(msg.sender == owner);
        delete controllers[_controller_addr];
        return;        
    }

    function addStorage(address _storage_addr) public {
        require(msg.sender == owner);
        controllers[_storage_addr] = true;
        return;
    }

    function deleteStorage(address _storage_addr) public {
        require(msg.sender == owner);
        delete controllers[_storage_addr];
        return;
    }

    function setPublicKey(address _controller_addr, address _processor_addr,string memory _processor_pk) public {
        // require(isAddressAnOrg((_controller_addr)));
        address_pubk[_controller_addr][_processor_addr] = _processor_pk;
        emit publicKeyAdded(_controller_addr, _processor_addr, _processor_pk);
        return;
    }

    function retrieveProcessorPublicKey(address _controller_addr, address _processor_addr) public returns (string memory){
        emit publicKeyRetrieved(_controller_addr, _processor_addr, address_pubk[_controller_addr][_processor_addr]);
        return address_pubk[_controller_addr][_processor_addr];
    }

    function deletePublicKey(address _controller_addr , address _processor_addr) public{
        // require(isAddressAnOrg((_controller_addr)));
        delete address_pubk[_controller_addr][_processor_addr];
        emit publicKeyDeleted(_controller_addr ,_processor_addr, address_pubk[_controller_addr][_processor_addr]);
        return;
    }

    function getPublicKey(address _controller_addr, address _processor_addr) internal view returns (bool){
        if (bytes(address_pubk[_controller_addr][_processor_addr]).length>0) {
            return true;
        }
        return false;
    }

    function isAddressAnOrg(address _signer_address) public view returns (bool){
        if (controllers[_signer_address]) {
            return true;
        }
        return false;
    }

    function isSenderAnOrg(address _signer_address) internal view returns (bool){
        if (controllers[_signer_address]) {
            return true;
        }
        return false;
    }
}


//// ================================================================ ////
//// ================================================================ ////
// Contract for granted accesses and verification by the data storages  //
contract DataAccess {
    
    Decision decision_contract;
    Attributes attributes_contract;

    address decision_contract_addr;        
    address attributes_contract_addr;

    struct Access {
        string context_expression;    
        uint256 resource_id;
        uint8 actions;
        bool access_granted;
        uint256 creation_timestamp;
        uint256 expiration_timestamp;
    }

    uint expiration_time;

    address owner;

    constructor() {
        owner = msg.sender;
        expiration_time = 300000;
    }

    event accessGranted(string _public_key, string _context_expression, uint8 _actions, uint256 _resource_id, uint256 _access_given_timestamp, uint256 _access_expiration_timestamp); // Event
    event verificationSuccess(string _public_key);
    event verificationFailed(string _public_key);
    event accessRevoked(string _public_key);

    event checkPoint(string msg);

    // mapping(string => Access) internal accesses;
    mapping(string => mapping(uint256 => Access)) internal accesses;

    function hashIndex(string memory _context_expression, uint _resource_id, uint8 _actions) internal pure returns (uint256){
        bytes32 index;
        index = sha256(abi.encodePacked(_context_expression, _actions, _resource_id));
        return(uint256(index));        
    }

    function setDecisionContractAddr(address _address) public {
        decision_contract_addr = _address;
        return;
    }
    
    function setAttributesContractAddr(address _address) public {
        attributes_contract_addr = _address;
        return;
    }

    function getDecisionContractAddr() public view returns(address){
        return decision_contract_addr;
    }

    function getAttributesContractAddr() public view returns(address){
        return attributes_contract_addr;
    }

    function setExpirationTime(uint _expiration_time) public{
        expiration_time = _expiration_time;
        return;
    }

    function requestAccess(string memory _context_expression, uint256 _resource_id, uint8 _actions, bytes32 _hashed_token, bytes memory _signed_token, uint128 _attributes) public{
        decision_contract = Decision(decision_contract_addr);
        decision_contract.evaluateRequest(_context_expression, _resource_id, _actions, _hashed_token, _signed_token, _attributes, msg.sender);    
        return;
    }

    function saveDecision(string memory _public_key, string memory _context_expression, uint256 _resource_id, uint8 _actions) public {
        uint256 access_given_timestamp = block.timestamp;
        uint256 access_expiration_timestamp = access_given_timestamp + expiration_time;        
        uint256 i = hashIndex(_context_expression, _resource_id, _actions);
        accesses[_public_key][i] = Access(_context_expression, _resource_id, _actions, true, access_given_timestamp, access_expiration_timestamp);
        emit accessGranted(_public_key, _context_expression, _actions, _resource_id, access_given_timestamp, access_expiration_timestamp);
        return;
    }
    
    function verifyAccess(string memory _public_key, uint256 _resource_id, string memory _context_expression, uint8 _actions, uint256 _access_timestamp) public returns (bool) {
        if (getGrantedAccess(_public_key, _resource_id, _context_expression, _actions, _access_timestamp)) {
            emit verificationSuccess(_public_key);
            return true;
        } else {
            emit verificationFailed(_public_key);
            return false;
        }
    }

    function revokeAccess(string memory _public_key, uint256 _resource_id, string memory _context_expression, uint8 _actions) public {
        uint256 i = hashIndex(_context_expression, _resource_id, _actions);
        delete accesses[_public_key][i];
        emit accessRevoked(_public_key);
        return;
    }

    function getGrantedAccess(string memory _public_key, uint256 _resource_id, string memory _context_expression, uint8 _actions, uint256 _access_timestamp) view internal returns (bool) {
        uint256 i = hashIndex(_context_expression, _resource_id, _actions);
        if (accesses[_public_key][i].expiration_timestamp >= _access_timestamp){
            return true;
        }
        return false;
    }
}
//// ================================================================ ////