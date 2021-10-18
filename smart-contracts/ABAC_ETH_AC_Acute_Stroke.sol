pragma solidity = 0.8.7;

// Perguntas
// Attributos do usuario vao ser inseridos, por token, ou inseridos na blockchain. Contract User_Attributes
// How to enable access on cloud? token generation?? 


// BRAINSTORM
// SMART CONTRACT SENDING A REQUEST TO CLOUD. 
//// SC encrypst msg with ENCRYPT_PUBK(MSG) and sends request + encrypted msg to the Cloud
// CLOUD GENERATES PATH + TOKEN (HTTPS://URL/uuid + TOKEN(TYPES: READ, WRITE, UPDATE, DELETE))
// SMART CONTRACT DEVOLVE PATH + TOKEN 


// Contract for policies
contract ABAC_Policies{
    // Each policy is applied to a combination of operation + data_type
    struct Policy{
        uint uuid;
        string access_type; // Read or Write/Update, GET or POST
        string role; // Professional role inside organisation
        string organisation; // Organisation type
        string[] actions; // Data type for acute care should be "EMR"        
        bool belongs_to_emergency_team; // Boolean : Should be evaluated?
        bool timestamp_between_work_shift; // Boolean : Should be evaluated?
        bool patient_picked_up; // Boolean: Should be evaluted?
    }
    
    // Policies created
    mapping(uint => Policy) internal Policies;
    // Policy[] policies;
    
    // mapping(string => bool) internal entries;
    
    uint admin;
    address public owner;
    
    constructor (uint _admin){
        owner = msg.sender;
        // admin = _admin;
    }
    
    function hashPolicy(string memory _access_type, string calldata _role, string calldata _organisation, string[] calldata _actions) public returns (uint){
        require(msg.sender == owner);
        bytes32 val;
        val = sha256(abi.encodePacked(_access_type, _role, _organisation, _actions[0], _actions[1]));
        uint256 i = uint(val);
        return i;
    }
    
    // Create a new policy (Need to input some security where only the admin of the contract can create policies)
    function createPolicy(uint _uuid, string memory _access_type, string calldata _role, string calldata _organisation, string[] calldata _actions, bool _belongs_to_emergency_team, bool _timestamp_between_work_shift, bool _patient_picked_up) public {
        require(msg.sender == owner);
        uint hash = hashPolicy(_access_type, _role, _organisation, _actions);
        if(getPolicy(hash)){
            return;
        }
        Policies[hash] = Policy(_uuid, _access_type, _role, _organisation, _actions, _belongs_to_emergency_team, _timestamp_between_work_shift, _patient_picked_up);
        return;
    }
    // Queries the policy that matches the hash
    function queryPolicy(string memory _access_type, string calldata _role, string calldata _organisation, string[] calldata _actions) public returns (Policy memory){
        require(msg.sender == owner);
        uint hash = hashPolicy(_access_type, _role, _organisation, _actions);
        if(getPolicy(hash)){
            return Policies[hash];
            // NEED TO IMPROVE THIS USE CASE
        }
        return Policies[hash];
    }
    
    // Retrieves the policy that matches the uuid   
    function retrievePolicy(uint _uuid) public returns (Policy memory){
        require(msg.sender == owner);
        if(getPolicy(_uuid)){
            return Policies[_uuid];
            // NEED TO IMPROVE THIS USE CASE
        }
        return Policies[_uuid];
    }
    
    function changePolicy(uint _uuid) public{
        require(msg.sender == owner);
        if(getPolicy(_uuid)){
            // Change policy here
            return;    
        }
        return;
    }
    
    function getPolicy(uint _uuid) internal returns (bool){
        if (Policies[_uuid].uuid == _uuid){
            return true;
        }
        return false;
    }
}

contract Address_PubKey_Mapping{
    
    // Policies created
    mapping(address => string) internal address_pubk;
    
    function setPubKey(address _address, string memory _pub_key) public{
        address_pubk[_address] = _pub_key;
    }
    
    function retrievePubKey(address _address) public returns(string memory){
        return address_pubk[_address];
    }
}

// Contract for the main access control
contract ABAC_Access_Control{
    
    ABAC_Policies abac_policies;
    KeyManagement keys;
    Address_PubKey_Mapping addr_pubk_map;
    
    
    address abac_policies_addr;
    address keys_management_addr;
    address emergency_attr_addr;
    address address_pubk_mapping_addr;
    
    string[] cloudTokens;
    
    uint organisation_uuid;
    uint admin;
    
    constructor (uint _admin){
        admin = _admin;
    }
     
    function setABACPoliciesAddr(address _address) public{
        abac_policies_addr = _address;
    }
    
    function setKeyManagementAddr(address _address) public{
        keys_management_addr = _address;
    }
    
    function setEmergencyAttributesAddr(address _address) public{
        emergency_attr_addr = _address;
    }
    
    function setAddressPubKeyMappingAddr(address _address) public{
        address_pubk_mapping_addr = _address;
    }
    
    function splitSignature(bytes32 sig) internal pure returns (uint8, bytes32, bytes32) {
        require(sig.length == 65);
    
        bytes32 r;
        bytes32 s;
        uint8 v;
    
        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }
    
        return (v, r, s);
    }
    
    function toBytes(address a) public pure returns (bytes memory) {
        return abi.encodePacked(a);
    }
    
    function startSmartContract(string memory _access_type, uint _patient_uuid, string[] memory _actions, bytes32 _hashed_token, bytes memory _signed_token, uint8[] memory attributes) public{
        uint8[] memory a = attributes;
        
        uint8 v;
        bytes32 r;
        bytes32 s;
    
        (v, r, s) = splitSignature(_hashed_token);
        address _signer_address = ecrecover(_hashed_token, v, r, s);
        addr_pubk_map = Address_PubKey_Mapping(address_pubk_mapping_addr);
        string memory signer_pk = addr_pubk_map.retrievePubKey(_signer_address);
        string memory sender_pk = addr_pubk_map.retrievePubKey(msg.sender);
        if (signatureAndProfessionalVerification(_hashed_token, a, sender_pk)){
            requestAccess(_access_type, _patient_uuid, _actions, a);
        }
        
    }
    
    function signatureAndProfessionalVerification(bytes32 _hashed_token, uint8[] memory _a, string memory _pubKey) public returns(bool){
        bytes32 c = keccak256(abi.encodePacked(_a, _pubKey));
        return c == _hashed_token;
    }
    
    function requestAccess(string memory _access_type, uint _patient_uuid, string[] memory _actions, uint8[] memory _attributes) public returns(string memory, string memory){
        string memory role = "roleX";
        string memory organisation = "organisationY"; 
        ABAC_Policies.Policy memory tmp_policy = loadPolicy(_access_type, _actions, role, organisation);
        string memory tmp_encrypted_key = loadKey(_patient_uuid);
        return ("puzzle", tmp_encrypted_key);
    }

    function loadPolicy(string memory _access_type, string[] memory _actions, string memory _role, string memory _organisation) public returns(ABAC_Policies.Policy memory){
        abac_policies = ABAC_Policies(abac_policies_addr);
        return abac_policies.queryPolicy(_access_type, _role, _organisation, _actions);
    }
    
    function loadKey(uint _patient_uuid) public returns(string memory){
        keys = KeyManagement(keys_management_addr);
        return keys.retrieveEncryptedKey(_patient_uuid);
    }
    
    function verifyABAC(string[] memory _policy, string[] memory _user_attributes) public {
        // Policy evaluation : For each boolean inside policy struct that has YES as value, we evaluate the respective "IF"
        // if(_policy.belongs_to_emergency_team){
                
        // }
        
        // if(_policy.timestamp_between_work_shift){
                
        // }
    }
    
    function generateCloudToken() public{
        cloudTokens.push("NewToken");
    }
}

contract Emergency_Attributes{
    struct Emergency_Info{
        uint patient_uuid;
        uint[] healthcare_teams;
        uint[] organisations;
        bool is_active;
        uint started_timestamp;
        uint ended_timestamp;
    }
    
    // Policies created
    // mapping(uint => Emergency_Info[]) internal Emergencies;
    mapping(uint => uint) internal emergencies;
    mapping(uint => mapping (uint => Emergency_Info)) internal Emergencies;
    
    function createEmergency(uint _patient_uuid, uint _healthcare_team, uint _organisation) public {
        // Emergencies[_patient_uuid].push(Emergency_Info(_patient_uuid, new uint[](_healthcare_team), new uint[](_organisation), true));
        Emergencies[_patient_uuid][emergencies[_patient_uuid]] = Emergency_Info(_patient_uuid, new uint[](_healthcare_team), new uint[](_organisation), true, block.timestamp, 0);
        emergencies[_patient_uuid] = emergencies[_patient_uuid] + 1;
    }
    
    function addTeam(uint _patient_uuid, uint _healthcare_team, uint _organisation) public {
        //TODO   
    }
    
    function revokeTeam() public {
        // TODO
    }
    
    function finaliseEmergency(uint _emergency_uuid) public {
        // TODO
    }
    
}

contract KeyManagement{
    
    struct Keys{
        uint uuid;
        string key;
    }
    
    mapping(uint => Keys) internal keys;
    
    // Add encrypted keys to the blockchain indexed by uuid
    function addEncryptedKey(uint _uuid, string memory _encrypted_key) public {
        if (getKey(_uuid)){
            return;
        }
        keys[_uuid] = Keys(_uuid, _encrypted_key);
        return;
    }
    
    function retrieveEncryptedKey(uint _uuid) public returns(string memory ){
        if (getKey(_uuid)){
            Keys memory k = keys[_uuid];
            return k.key;
        } 
        return "";
    }

    function changeEncryptedKey(uint _uuid, string memory _new_encrypted_key) public{
        if (getKey(_uuid)){
            Keys memory k = keys[_uuid];
            k.key = _new_encrypted_key;
            return;
        } 
        return;
    }
    
    function getKey(uint _uuid) internal returns (bool){
        if (keys[_uuid].uuid == _uuid){
            return true;
        }
        return false;
    }
    
}

contract Cloud_Accesses{
    struct Access{
        string access_type;
        uint patient_uuid;
        bool access_granted;
    }
    
    mapping(string => Access) internal accesses;
    
    function grantAccess(string memory _pubKey) public{
        accesses[_pubKey] = Access("", 1, true);
    }
    
    function wasAccessGranted(string memory _pubKey) public returns(bool){
        return accesses[_pubKey].access_granted;
    }
    
    function revokeAccess(string memory _pubKey) public{
        delete accesses[_pubKey];
    }
}