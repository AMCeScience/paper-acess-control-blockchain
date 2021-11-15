// SPDX-License-Identifier: MIT
//// ============================================================ ////
pragma solidity =0.8.7;
//// ============================================================ ////

//// ============================================================ ////
//// ============================================================ ////
//// Contract for policies
contract Policies {
    // The policies are a combination of attributes
    struct Policy {
        uint256 uuid;
        string access_type;
        bool attr1;
        bool attr2;
        bool attr3;
        bool attr4;
        bool attr5;
        bool attr6;
        bool attr7;
        bool attr8;
        
    }

    // Policies
    mapping(uint256 => Policy) internal Policies;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    event queriedPolicy(uint256 hash, Policy policy); // Event
    event createdPolicy(uint256 hash, Policy policy); // Event
    event changedPolicy(uint256 hash, Policy policy); // Event
    event deletedPolicy(uint256 hash, Policy policy); // Event

    // Creates a hash based on _access_type to create the policy
    function hashPolicy(string memory _access_type)
        public
        pure
        returns (uint256)
    {
        // require(msg.sender == owner);
        bytes32 val;
        val = sha256(abi.encodePacked(_access_type));
        uint256 i = uint256(val);
        return i;
    }

    // Create a new policy
    function createPolicy(string memory _access_type, bool[] memory _attrs)public{
        require(msg.sender == owner);
        uint256 hash = hashPolicy(_access_type);
        if (getPolicy(hash)) {
            return;
        }
        Policies[hash] = Policy(
            hash,
            _access_type,
            _attrs[0],
            _attrs[1],
            _attrs[2],
            _attrs[3],
            _attrs[4],
            _attrs[5],
            _attrs[6],
            _attrs[7]
        );
        emit createdPolicy(hash, Policies[hash]);
        return;
    }

    // Queries the policy that matches the hash
    function queryPolicy(string memory _access_type)
        public
        returns (Policy memory)
    {
        // require(msg.sender == owner);
        uint256 hash = hashPolicy(_access_type);
        if (getPolicy(hash)) {
            emit queriedPolicy(hash, Policies[hash]);
            return Policies[hash];
        }
        return Policies[hash];
    }

    // Retrieves the policy that matches the uuid
    function retrievePolicy(uint256 _uuid) public returns (Policy memory) {
        require(msg.sender == owner);
        if (getPolicy(_uuid)) {
            emit queriedPolicy(_uuid, Policies[_uuid]);
            return Policies[_uuid];
            // NEED TO IMPROVE THIS USE CASE
        }
        return Policies[_uuid];
    }

    function changePolicy(uint256 _uuid, bool[] memory _attrs) public {
        require(msg.sender == owner);
        if (getPolicy(_uuid)) {
            Policies[_uuid].attr1 = _attrs[0];
            Policies[_uuid].attr2 = _attrs[1];
            Policies[_uuid].attr3 = _attrs[2];
            Policies[_uuid].attr4 = _attrs[3];
            Policies[_uuid].attr5 = _attrs[4];
            Policies[_uuid].attr6 = _attrs[5];
            Policies[_uuid].attr7 = _attrs[6];
            Policies[_uuid].attr8 = _attrs[7];
            return;
        }
        return;
    }

    function deletePolicy(uint256 _uuid) public {
        require(msg.sender == owner);
        if (getPolicy(_uuid)) {
            delete Policies[_uuid];
        }
    }

    function getPolicy(uint256 _uuid) internal view returns (bool) {
        if (Policies[_uuid].uuid == _uuid) {
            return true;
        }
        return false;
    }
}

//
// The information if there is any data avilable is inside the system where the patient's data is stored
// Before going through the ABAC, the user can ask if there is any data available for the patient XXX
//

//// ============================================================ ////
//// ============================================================ ////


//// ============================================================ ////
//// ============================================================ ////
// Contract for the main access control
contract Decision {
    Policies policies_contract;    
    // Address_PubKey_Mapping addr_pubk_map;
    Data_Access data_access_contract;    
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

    event validOrganisationSignature(address _org_address, bytes _signed_message);
    event invalidOrganisationSignature(address _org_address, bytes _signed_message);
    event invalidHashComparison(uint8[] _attributes, string _public_key, bytes32 _hash);
    event validHashComparison(uint8[] _attributes, string _public_key, bytes32 _hash);
    event attrsComplyingWithPolicy(Policies.Policy _policy, uint8[] _attributes);
    event attrsNotComplyingWithPolicy(Policies.Policy _policy, uint8[] _attributes);
    event addressSetted(address _contract, address _contract_address);

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

    function startSmartContract(string memory _access_type, uint256 _data_subject_id, string[] memory _actions, bytes32 _hashed_token, bytes memory _signed_token, uint8[] memory attributes) public {
        uint8[] memory _attr = attributes;

        uint8 v;
        bytes32 r;
        bytes32 s;

        (v, r, s) = splitSignature(_hashed_token);

        address _signer_address = ecrecover(_hashed_token, v, r, s);
        attributes_contract = Attributes(attributes_contract_addr);
        
        if (orgSignValidated(_signer_address, _signed_token)) {            
            string memory sender_pk = attributes_contract.retrievePublicKey(_signer_address,msg.sender);
            if (signatureAndProfessionalVerification(_hashed_token, _attr, sender_pk)) {                
                requestAccess(_access_type, sender_pk, _data_subject_id, _actions, _attr);
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

    function signatureAndProfessionalVerification(bytes32 _hashed_token, uint8[] memory _attr, string memory _public_key) public returns (bool) {
        bytes32 c = keccak256(abi.encode(_attr, _public_key));
        if (c == _hashed_token){
            emit validHashComparison(_attr, _public_key, _hashed_token);
            return true;
        }
        emit invalidHashComparison(_attr, _public_key, _hashed_token);
        return false;
    }

    function requestAccess(string memory _access_type, string memory _public_key, uint256 _data_subject_id, string[] memory _actions, uint8[] memory _attributes) public {
        Policies.Policy memory loaded_policy = loadPolicy(_access_type);
        if(policyCompliant(loaded_policy, _attributes)){
            data_access_contract = Data_Access(data_access_contract_addr);
            data_access_contract.grantAccess(_public_key, _access_type, _data_subject_id, _actions);
        }
        return;
    }

    function loadPolicy(string memory _access_type)
        public
        returns (Policies.Policy memory)
    {
        policies_contract = Policies(policies_contract_addr);
        return policies_contract.queryPolicy(_access_type);
    }    

    function policyCompliant(Policies.Policy memory loaded_policy, uint8[] memory _attrs) public returns(bool){
        bool comply = true;
        if (loaded_policy.attr1 != attr_map[_attrs[0]]){
            comply = false;
        }
        if (loaded_policy.attr2 != attr_map[_attrs[1]]){
            comply = false;
        }
        if (loaded_policy.attr3 != attr_map[_attrs[2]]){
            comply = false;
        }
        if (loaded_policy.attr4 != attr_map[_attrs[3]]){
            comply = false;
        }
        if (loaded_policy.attr5 != attr_map[_attrs[4]]){
            comply = false;
        }
        if (loaded_policy.attr6 != attr_map[_attrs[5]]){
            comply = false;
        }
        if (loaded_policy.attr7 != attr_map[_attrs[6]]){
            comply = false;
        }
        if (loaded_policy.attr8 != attr_map[_attrs[7]]){
            comply = false;
        }
        
        if (comply){
            emit attrsComplyingWithPolicy(loaded_policy, _attrs);
            return true;
        } else{
            emit attrsNotComplyingWithPolicy(loaded_policy, _attrs);
            return false;
        }        
    }    
}

//// ============================================================ ////
//// ============================================================ ////
//// Contract for contextual attributes if needed
contract Attributes {
    event publicKeyAdded(address _org_address, address _user_address, string _key); // Event
    event publicKeyRetrieved( address _org_address, address _user_address, string _key); // Event
    event publicKeyDeleted(address _org_address, address _user_address, string _key); // Event
    event publicKeyNotFound(address _org_address, address _user_address);
    event organisationAddressNotFound(address _org_address); // Event

    struct Extra_Info {
        uint256 uuid;
        bool attr6;
        bool attr7;
        bool attr8;
        bool attr9;
        bool attr10;
    }

    // Maps address to pubkey
    mapping(address => mapping(address => string)) internal address_pubk;
    mapping(address => bool) internal orgs;

    address owner;

    constructor() {
        owner = msg.sender;
    }

    // Map consent given by the patient to the professional
    // 
    // { 
    // Patient Address,
    // Professional Address,
    // Consent: Yes 
    // }

    // Attributes mapping
    mapping(uint256 => Extra_Info) internal attributes;

    function addExtraInfo() public {
        //TODO
    }

    function changeExtraInfo() public {
        // TODO
    }

    function deleteExtraInfo(uint256 _emergency_uuid) public {
        // TODO
    }    

    function addOrganisation(address _org_address) public {
        require(msg.sender == owner);
        orgs[_org_address] = true;
        return;
    }

    function setPublicKey(address _org_address, address _user_address,string memory _pub_key) public {
        require(isAddressAnOrg((_org_address)));
        address_pubk[_org_address][_user_address] = _pub_key;
        emit publicKeyAdded(_org_address, _user_address, _pub_key);
        return;
    }

    function retrievePublicKey(address _org_address, address _user_address) public returns (string memory){
        emit publicKeyRetrieved(_org_address, _user_address, address_pubk[_org_address][_user_address]);
        return address_pubk[_org_address][_user_address];
    }

    function deletePublicKey(address _org_address , address _user_address) public{
        require(isAddressAnOrg((_org_address)));
        delete address_pubk[_org_address][_user_address];
        emit publicKeyDeleted(_org_address ,_user_address, address_pubk[_org_address][_user_address]);
        return;
    }

    function getPublicKey(address _org_address, address _user_address) internal view returns (bool){
        if (bytes(address_pubk[_org_address][_user_address]).length>0) {
            return true;
        }
        return false;
    }

    function isAddressAnOrg(address _signer_address) public view returns (bool){
        if (orgs[_signer_address]) {
            return true;
        }
        return false;
    }

    function isSenderAnOrg(address _signer_address) internal view returns (bool){
        if (orgs[_signer_address]) {
            return true;
        }
        return false;
    }
}


//// ============================================================ ////
//// ============================================================ ////
//// Contract for granted accesses and verification by the cloud
contract Data_Access {
    
    Decision decision_contract;
    Attributes attributes_contract;

    address decision_contract_addr;        
    address attributes_contract_addr;

    struct Access {
        string access_type;    
        uint256 patient_uuid;
        string[] actions;
        bool access_granted;
        uint256 creation_timestamp;
        uint256 expiration_timestamp;
    }

    uint expiration_time;

    address owner;

    constructor() {
        owner = msg.sender;
        expiration_time = 300;
    }

    event accessGranted(string _public_key, string _access_type, string[] _actions, uint256 _data_subject_id, uint256 _access_given_timestamp, uint256 _access_expiration_timestamp); // Event
    event verificationSuccess(string _public_key);
    event verificationFailed(string _public_key);
    event accessRevoked(string _public_key);

    // mapping(string => Access) internal accesses;
    mapping(string => mapping(uint256 => Access)) internal accesses;

    function hashIndex(string memory _access_type, uint _data_subject_id, string[] memory _actions) internal pure returns (uint256){
        bytes32 index;
        index = sha256(abi.encodePacked(_access_type, _data_subject_id, _actions[0], _actions[1]));
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

    function setExpirationTime(uint _expiration_time) public{
        expiration_time = _expiration_time;
        return;
    }

    function evaluateRequest(string memory _access_type, uint256 _data_subject_id, string[] memory _actions, bytes32 _hashed_token, bytes memory _signed_token, uint8[] memory attributes) public{
        decision_contract = Decision(decision_contract_addr);
        decision_contract.startSmartContract(_access_type, _data_subject_id, _actions, _hashed_token, _signed_token, attributes);    
        return;
    }

    function grantAccess(string memory _public_key, string memory _access_type, uint256 _data_subject_id, string[] memory _actions) public {
        uint256 access_given_timestamp = block.timestamp;
        uint256 access_expiration_timestamp = access_given_timestamp + expiration_time;        
        uint256 i = hashIndex(_access_type, _data_subject_id, _actions);
        accesses[_public_key][i] = Access(_access_type, _data_subject_id, _actions, true, access_given_timestamp, access_expiration_timestamp);
        emit accessGranted(_public_key, _access_type, _actions, _data_subject_id, access_given_timestamp, access_expiration_timestamp);
        return;
    }
    
    function verifyAccess(string memory _public_key, uint256 _data_subject_id, string memory _access_type, string[] memory _actions, uint256 _access_timestamp) public returns (bool) {
        if (getGrantedAccess(_public_key, _data_subject_id, _access_type, _actions, _access_timestamp)) {
            emit verificationSuccess(_public_key);
            return true;
        } else {
            emit verificationFailed(_public_key);
            return false;
        }
    }

    function revokeAccess(string memory _public_key, uint256 _data_subject_id, string memory _access_type, string[] memory _actions) public {
        uint256 i = hashIndex(_access_type, _data_subject_id, _actions);
        delete accesses[_public_key][i];
        emit accessRevoked(_public_key);
        return;
    }

    function getGrantedAccess(string memory _public_key, uint256 _data_subject_id, string memory _access_type, string[] memory _actions, uint256 _access_timestamp) view internal returns (bool) {
        uint256 i = hashIndex(_access_type, _data_subject_id, _actions);
        if (accesses[_public_key][i].expiration_timestamp >= _access_timestamp){
            return true;
        }
        return false;
    }
}
