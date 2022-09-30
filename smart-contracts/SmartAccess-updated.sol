// SPDX-License-Identifier: MIT
//// ================================================================ ////
pragma solidity =0.8.7;
//// ================================================================ ////

//// ================================================================ ////
//// ================================================================ ////
//   =============== Policies Smart Contract (PAPSC) ================   //
contract Policies {
    // The policies are a combination of attributes
    // The struct contains policies as uint8, however each number represents an array of attributes. 
    // For example 255 represents [1 1 1 1 1 1 1 1]
    
    Attributes attributes_contract;    
    address attributes_contract_addr;

    struct Policy {
        uint256 uuid;
        string context_expression;
        uint8 policy;
        // uint8[] policies;
        // string encrypted_mask; // encrypted_mask = example: {0: "Call centre professional", 1: "Ambulance professional" etc ...}
        bool conventional_access;
        bool emergency_access;
        // bool public_health_access
    }

    // Policies
    mapping(uint256 => Policy[]) internal _policies;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    event queriedPolicies(uint256 hash, Policy[] policy); 
    event createdPolicy(uint256 hash, Policy policy); 
    event changedPolicy(uint256 hash, Policy policy); 
    event deletedPolicy(uint256 hash, Policy policy); 
    event failedEvent(string description);


    function setAttributesContractAddr(address _address) public {
        require(msg.sender == owner);

        attributes_contract_addr = _address;
        return;
    }

    function getAttributesContractAddr() public view returns(address) {
        return attributes_contract_addr;
    }

    // Creates a hash based on _context_expression to create the policy
    function hashPolicy(string memory _context_expression, uint8 _actions)
        public
        pure
        returns (uint256)
    {
        // require(msg.sender == owner);
        bytes32 val;
        val = sha256(abi.encodePacked(_context_expression, _actions));
        uint256 i = uint256(val);
        return i;
    }

    // function contains(address sender) public returns(bool){
    //     attributes_contract = Attributes(attributes_contract_addr);
    //     address[] memory controllers = attributes_contract.getControllers();
    //     for (uint i=0; i < controllers.length; i++) {
    //         if (sender == controllers[i]) {
    //             return true;
                
    //         }
    //     } return false;
    // }

    // Create a new policy with the number/array-of-attributes
    function createPolicy(string memory _context_expression, uint8 _actions, uint8 _policy, bool _conventional_access, bool _emergency_access) public{        
        attributes_contract = Attributes(attributes_contract_addr);
        require(attributes_contract.isAddrOfController(msg.sender) || msg.sender == owner);

        uint256 hash = hashPolicy(_context_expression, _actions);

        // if (getPolicy(hash)) {
        //     emit failedEvent("createPolicy: Policy already exists");
        //     return;
        // }

        Policy memory tmp_policy = Policy(
            hash,
            _context_expression,
            _policy,
            _conventional_access,
            _emergency_access

        );

        _policies[hash].push(tmp_policy);

        emit createdPolicy(hash, tmp_policy);
        return;

    }    

    // Queries the policy that matches the hash
    function loadPolicies(string memory _context_expression, uint8 _actions)
        public
        returns (Policy[] memory)
    {
        // require(msg.sender == owner);
        uint256 hash = hashPolicy(_context_expression, _actions);
        if (getPolicy(hash)) {
            emit queriedPolicies(hash, _policies[hash]);
            return _policies[hash];
        }
        emit failedEvent("loadPolicies: Policies for context expression not found");
    }

    function changePolicy(uint256 _uuid, uint8 _policy, uint i) public {
        attributes_contract = Attributes(attributes_contract_addr);
        require(attributes_contract.isAddrOfController(msg.sender) || msg.sender == owner);

        // if (getPolicy(_uuid)) {
        //     emit changedPolicy(_uuid, _policies[_uuid][i]);
        //     _policies[_uuid][i].policy = _policy;      
        //     return;
        // }
        // emit failedEvent("changePolicy: Policy not found");
        emit changedPolicy(_uuid, _policies[_uuid][i]);
        _policies[_uuid][i].policy = _policy;      
        return;
    }

    function removePolicy(uint256 _uuid, uint i) public {
        attributes_contract = Attributes(attributes_contract_addr);
        require(attributes_contract.isAddrOfController(msg.sender) || msg.sender == owner);
        
        // if (getPolicy(_uuid)) {
        //     emit deletedPolicy(_uuid, _policies[_uuid][i]);
        //     delete _policies[_uuid];
        //     return;
        // }
        // emit failedEvent("deletePolicy: Policy not found for deletion");

        emit deletedPolicy(_uuid, _policies[_uuid][i]);
        delete _policies[_uuid];
        return;
    }

    // Help functions
    function getPolicy(uint256 _uuid) internal view returns (bool) {
        if (_policies[_uuid].length > 0) {
            return true;
        }
        return false;
    }

    // Retrieves the policy that matches the uuid
    function retrievePolicies(uint256 _uuid) public returns (Policy[] memory) {
        attributes_contract = Attributes(attributes_contract_addr);
        require(attributes_contract.isAddrOfController(msg.sender) || msg.sender == owner);

        if (getPolicy(_uuid)) {
            emit queriedPolicies(_uuid, _policies[_uuid]);
            return _policies[_uuid];            
        }
        emit failedEvent("retrievePolicies: Policies for given uuid not found");
    }
}
//// ================================================================ ////
//// ================================================================ ////


//// ================================================================ ////
//// ================================================================ ////
//   =============== Decision Smart Contract (PDPSC) ================   //
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
    event invalidHashComparison(uint8 _attributes, string _public_key, bytes32 _hash);
    event validHashComparison(uint8 _attributes, string _public_key, bytes32 _hash);
    event attrsComplyingWithPolicy(Policies.Policy _policy, uint8 _attributes);
    event attrsNotComplyingWithPolicy(Policies.Policy _policy, uint8 _attributes);
    event attrsNotComplyingWithAnyPolicy(Policies.Policy[] _policies, uint8 _attributes);
    event addressSetted(address _contract, address _contract_address);
    event signerAddress(address _signerAddress);
    event numbers(uint8 v, bytes32 r, bytes32 s);
    event failedEvent(string _description);

    function setPoliciesContractAddr(address _address) public {
        require(msg.sender == owner);

        policies_contract_addr = _address;
        return;
    }    

    function setAttributesContractAddr(address _address) public {
        require(msg.sender == owner);

        attributes_contract_addr = _address;
        return;
    }

    // function setAddressPubKeyMappingAddr(address _address) public {
    //     address_pubk_mapping_addr = _address;
    // }

    function setDataAccessContractAddr(address _address) public {
        require(msg.sender == owner);

        data_access_contract_addr = _address;
        return;
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

    function evaluateRequest(string memory _context_expression, uint256 _resource_id, uint8 _actions, bytes32 _hashed_token, bytes memory _signed_token, uint8 _attributes, address _processor_addr) public {        

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

    // Help functions
    function orgSignValidated(address _signer_address, bytes memory _signed_token) public returns (bool) {
        // attributes_contract = Attributes(attributes_contract_addr);
        if (attributes_contract.isAddrOfController(_signer_address)) {
            emit validOrganisationSignature(_signer_address, _signed_token);
            return true;
        } else {
            emit invalidOrganisationSignature(_signer_address, _signed_token);
            return false;
        }
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

    function verifyPolicy(string memory _context_expression, string memory _public_key, uint256 _resource_id, uint8 _actions, uint8 _attributes) public {        
        Policies.Policy[] memory loaded_policy = loadPolicies(_context_expression, _actions);
        if(policyCompliant(loaded_policy, _attributes)){
            data_access_contract = DataAccess(data_access_contract_addr);
            data_access_contract.saveDecision(_public_key, _context_expression, _resource_id, _actions, true);
        } else {
            data_access_contract.saveDecision(_public_key, _context_expression, _resource_id, _actions, false);
        }
        return;
    }

    function loadPolicies(string memory _context_expression, uint8 _actions)
        public
        returns (Policies.Policy[] memory)
    {
        policies_contract = Policies(policies_contract_addr);
        return policies_contract.loadPolicies(_context_expression, _actions);
    }    

    function policyCompliant(Policies.Policy[] memory loaded_policies, uint8 _attrs) public returns(bool){
        for (uint i=0; i<loaded_policies.length; i++) {
            if ((bytes1(loaded_policies[i].policy) & bytes1(_attrs)) == bytes1(loaded_policies[i].policy)){
                if(loaded_policies[i].conventional_access){
                    if(attributes_contract.getContextualAttribute(1, msg.sender, msg.sender)){
                        emit attrsComplyingWithPolicy(loaded_policies[i], _attrs);
                        return true;
                    } else {
                        emit attrsNotComplyingWithPolicy(loaded_policies[i], _attrs);
                        return false;                          
                    }                
                }

                if(loaded_policies[i].emergency_access){
                    if(attributes_contract.getContextualAttribute(0, msg.sender, msg.sender)){
                        emit attrsComplyingWithPolicy(loaded_policies[i], _attrs);
                        return true;
                    } else {
                        emit attrsNotComplyingWithPolicy(loaded_policies[i], _attrs);
                        return false;
                    }
                }
                emit attrsComplyingWithPolicy(loaded_policies[i], _attrs);
                return true;
            }
        }
        emit attrsNotComplyingWithAnyPolicy(loaded_policies, _attrs);
        return false;
    }    
}

//// ================================================================ ////
//// ================================================================ ////
//// ============= Information Smart Contract (PIPSC) ===============   //
contract Attributes {
    event publicKeyAdded(address _controller_addr, address _processor_addr, string _processor_pk); // Event
    event publicKeyRetrieved( address _controller_addr, address _processor_addr, string _processor_pk); // Event
    event publicKeyDeleted(address _controller_addr, address _processor_addr, string _processor_pk); // Event
    event publicKeyNotFound(address _controller_addr, address _processor_addr);
    event organisationAddressFound(address _controller_addr);
    event organisationAddressNotFound(address _controller_addr); // Event
    event controllerAdded(address _sender, address _controller_addr);
    event controllerDeleted(address _sender, address _controller_addr);
    event storageAdded(address _sender, address _storage_addr);
    event storageDeleted(address _sender, address _storage_addr);
    event failedEvent(string _description);

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
    // address[] controllers_list;

    address owner;

    constructor() {
        owner = msg.sender;
    }
    
    // Contextual attributes mapping
    mapping(address => Emergency_Access) internal emergency_attributes;
    mapping(address => Conventional_Access) internal conventional_acess_attributes;


    function addContextAttr(uint8 _context_expression, address _processor_addr, address _data_subject_addr, uint256 _resource_id, bool _start_emergency, bool _end_emergency) public {
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

    function getContextAttr(uint8 _context_expression, address _processor_addr, address _data_subject_addr) public view returns(bool){
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

    function revokeContextAttr(uint8 _context_expression, address _data_subject_addr) public {
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

    function addNode(address _node_addr, string _node_type, string _processor_addr, string _processor_public_key) public{
        if (_node_type == "controller"){
            require(isAddrOfController(msg.sender) || msg.sender == owner);
            controllers[_node_addr] = true;
            emit controllerAdded(msg.sender, _node_addr);
            return;
            
        }

        if (_node_type == "storage"){
            require(isAddrOfController(msg.sender) || msg.sender == owner);
            controllers[_node_addr] = true;
            emit storageAdded(msg.sender, _node_addr);
            return;
            
        }

        if (_node_type == "processor"){
            require(isAddrOfController(msg.sender) || msg.sender == owner);
            address_pubk[_node_addr][_processor_addr] = _processor_pk;
            emit publicKeyAdded(_node_addr, _processor_addr, _processor_pk);
            return;
            
        }

        return;
    }

    function removeNode(address _node_addr, string _node_type, string _processor_addr, string _processor_public_key) public
        if (_node_type == "controller"){
            require(isAddrOfController(msg.sender) || msg.sender == owner);
            delete controllers[_node_addr];
            emit controllerDeleted(msg.sender, _node_addr);
            return;

        }

        if (_node_type == "storage"){
            require(isAddrOfController(msg.sender) || msg.sender == owner);
            delete controllers[_node_addr];
            emit storageDeleted(msg.sender, _node_addr);
            return;
            
        }

        if (_node_type == "processor"){
            require(isAddrOfController(msg.sender) || msg.sender == owner);                        
            emit publicKeyDeleted(_node_addr ,_processor_addr, address_pubk[_node_addr][_processor_addr]);
            delete address_pubk[_controller_addr][_processor_addr];
            return;
        }

        return;

    }

    // Functions to add nodes independtly (addNode and removenNode already implements these functionalities)
    function addController(address _controller_addr) public {
        require(isAddrOfController(msg.sender) || msg.sender == owner);
        
        controllers[_controller_addr] = true;
        emit controllerAdded(msg.sender, _controller_addr);
        return;
    }

    function deleteController(address _controller_addr) public {
        require(isAddrOfController(msg.sender) || msg.sender == owner);

        delete controllers[_controller_addr];
        emit controllerDeleted(msg.sender, _controller_addr);
        return;        
    }

    function addStorage(address _storage_addr) public {
        require(isAddrOfController(msg.sender) || msg.sender == owner);

        controllers[_storage_addr] = true;
        emit storageAdded(msg.sender, _storage_addr);
        return;
    }

    function deleteStorage(address _storage_addr) public {
        require(msg.sender == owner);

        delete controllers[_storage_addr];
        emit storageDeleted(msg.sender, _storage_addr);
        return;
    }

    function setPublicKey(address _controller_addr, address _processor_addr,string memory _processor_pk) public {
        require(isAddrOfController(msg.sender) || msg.sender == owner);
        require(isAddrOfController((_controller_addr)));

        address_pubk[_controller_addr][_processor_addr] = _processor_pk;
        emit publicKeyAdded(_controller_addr, _processor_addr, _processor_pk);
        return;
    }

    function retrievePKp(address _controller_addr, address _processor_addr) public returns (string memory){
        emit publicKeyRetrieved(_controller_addr, _processor_addr, address_pubk[_controller_addr][_processor_addr]);
        return address_pubk[_controller_addr][_processor_addr];
    }

    function deletePublicKey(address _controller_addr , address _processor_addr) public{        
        require(isAddrOfController(msg.sender) || msg.sender == owner);
        require(isAddrOfController((_controller_addr)));

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

    function isAddrOfController(address _signer_address) public view returns (bool){
        if (controllers[_signer_address]) {
            return true;
        }
        return false;
    }

    function isSenderController(address _signer_address) internal view returns (bool){
        if (controllers[_signer_address]) {
            return true;
        }
        return false;
    }
}


//// ================================================================ ////
//// ================================================================ ////
//   ============= Enforcement Smart Contract (PEPSC) =============== //
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
        expiration_time = 1800;
    }

    event accessGranted(string _public_key, string _context_expression, uint8 _actions, uint256 _resource_id, uint256 _access_expiration_timestamp);
    event accessDenied(string _public_key, string _context_expression, uint8 _actions, uint256 _resource_id);
    event verifyAccessSucess(string _public_key, string _context_expression, uint8 _actions, uint256 _resource_id);
    event verifyAccessFailed(string _public_key, string _context_expression, uint8 _actions, uint256 _resource_id);
    event accessRevoked(string _public_key, string _context_expression, uint8 _actions, uint256 _resource_id);

    event failedEvent(string _description);

    event log(
        string _context_expression, 
        uint8 _actions, 
        string _outcome, 
        string _agent,
        string _source_ip,
        string _country,
        string _city,
        address _processor_addr, 
        uint _resource_id
    );

    // mapping(string => Access) internal accesses;
    mapping(string => mapping(uint256 => Access)) internal accesses;

    function setDecisionContractAddr(address _address) public {
        require(msg.sender == owner);

        decision_contract_addr = _address;
        return;
    }
    
    function setAttributesContractAddr(address _address) public {
        require(msg.sender == owner);

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
        require(msg.sender == owner);

        expiration_time = _expiration_time;
        return;
    }

    function requestAccess(string memory _context_expression, uint256 _resource_id, uint8 _actions, bytes32 _hashed_token, bytes memory _signed_token, uint8 _attributes) public{
        decision_contract = Decision(decision_contract_addr);
        decision_contract.evaluateRequest(_context_expression, _resource_id, _actions, _hashed_token, _signed_token, _attributes, msg.sender);    
        return;
    }

    function saveDecision(string memory _public_key, string memory _context_expression, uint256 _resource_id, uint8 _actions, bool success) public {        
        if (success){
            uint256 access_attempt_timestamp = block.timestamp;
            uint256 access_expiration_timestamp = access_attempt_timestamp + expiration_time;        
            uint256 i = hashIndex(_context_expression, _resource_id, _actions);
            accesses[_public_key][i] = Access(_context_expression, _resource_id, _actions, true, access_attempt_timestamp, access_expiration_timestamp);
            emit accessGranted(_public_key, _context_expression, _actions, _resource_id, access_expiration_timestamp);
        } else {
            // Add description why was denied
            emit accessDenied(_public_key, _context_expression, _actions, _resource_id);
        }
        
        return;
    }
    
    function verifyDecision(string memory _public_key, uint256 _resource_id, string memory _context_expression, uint8 _actions, uint256 _access_timestamp) public returns (bool) {
        attributes_contract = Attributes(attributes_contract_addr);
        require(attributes_contract.isAddrOfController(msg.sender));

        // uint256 verification_timestamp = block.timestamp;
        if (getGrantedAccess(_public_key, _resource_id, _context_expression, _actions, _access_timestamp)) {
            emit verifyAccessSucess(_public_key, _context_expression, _actions, _resource_id);
            return true;
        } else {
            emit verifyAccessFailed(_public_key, _context_expression, _actions, _resource_id);
            return false;
        }
    }

    function revokeAccess(string memory _public_key, uint256 _resource_id, string memory _context_expression, uint8 _actions) public {
        // uint256 revocation_timestamp = block.timestamp;
        uint256 i = hashIndex(_context_expression, _resource_id, _actions);
        delete accesses[_public_key][i];
        emit accessRevoked(_public_key, _context_expression, _actions, _resource_id);
        return;
    }

    function saveRequestLogObligation(string memory _context_expression, uint8 _actions, string memory _outcome, string memory _agent, string memory _source_ip, string memory _country, string memory _city, address _processor_addr, uint _resource_id) public{
        emit log(_context_expression, 
            _actions, _outcome, _agent,
            _source_ip, _country, _city, 
            _processor_addr, _resource_id
        );
    }

    // Help functions
    function getGrantedAccess(string memory _public_key, uint256 _resource_id, string memory _context_expression, uint8 _actions, uint256 _access_timestamp) view internal returns (bool) {
        uint256 i = hashIndex(_context_expression, _resource_id, _actions);
        if (accesses[_public_key][i].expiration_timestamp >= _access_timestamp){
            return true;
        }
        return false;
    }

    function hashIndex(string memory _context_expression, uint _resource_id, uint8 _actions) internal pure returns (uint256){
        bytes32 index;
        index = sha256(abi.encodePacked(_context_expression, _actions, _resource_id));
        return(uint256(index));        
    }
    

}
//// ================================================================ ////