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
    mapping(uint => Policy) internal Policies;    

    address public owner;
    
    constructor (){
        owner = msg.sender;        
    }
    
    event queriedPolicy(uint hash, Policy policy); // Event
    event createdPolicy(uint hash, Policy policy); // Event
    event changedPolicy(uint hash, Policy policy); // Event
    event deletedPolicy(uint hash, Policy policy); // Event
    
    
    // Creates a hash based on _access_type to create the policy
    function hashPolicy(string memory _access_type) public returns (uint){
        // require(msg.sender == owner);
        bytes32 val;
        val = sha256(abi.encodePacked(_access_type));
        uint256 i = uint(val);
        return i;
    }
    
    // Create a new policy
    function createPolicy(string memory _access_type, bool[] memory _attrs) public {
        require(msg.sender == owner);
        uint hash = hashPolicy(_access_type);
        if(getPolicy(hash)){
            return;
        }
        Policies[hash] = Policy(hash, _access_type, _attrs[0], _attrs[1], _attrs[2], _attrs[3], _attrs[4], _attrs[5], _attrs[6], _attrs[7]);
        emit createdPolicy(hash, Policies[hash]);
        return;
    }
    
    // Queries the policy that matches the hash
    function queryPolicy(string memory _access_type) public returns (Policy memory){
        // require(msg.sender == owner);
        uint hash = hashPolicy(_access_type);
        if(getPolicy(hash)){
            emit queriedPolicy(hash, Policies[hash]);
            return Policies[hash];
        }
        return Policies[hash];
    }
    
    // Retrieves the policy that matches the uuid   
    function retrievePolicy(uint _uuid) public returns (Policy memory){
        require(msg.sender == owner);
        if(getPolicy(_uuid)){
            emit queriedPolicy(_uuid, Policies[_uuid]);
            return Policies[_uuid];
            // NEED TO IMPROVE THIS USE CASE
        }
        return Policies[_uuid];
    }
    
    function changePolicy(uint _uuid, bool[] memory _attrs) public{
        require(msg.sender == owner);
        if(getPolicy(_uuid)){
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
    
    function deletePolicy(uint _uuid) public{
        require(msg.sender == owner);
        if(getPolicy(_uuid)){
            delete Policies[_uuid];
        }
    }
    
    function getPolicy(uint _uuid) internal returns (bool){
        if (Policies[_uuid].uuid == _uuid){
            return true;
        }
        return false;
    }
}

//
// The information if there is any data avilable is inside the system where the patient's data is stored
// Before going through the ABAC, the user can ask if there is any data available for the patient XXX
//

// This contract maps Address to Public Key
contract Address_PubKey_Mapping{
    
    event publicKeyAdded(address _org_address, address _user_address, string _key); // Event
    event publicKeyRetrieved(address _org_address, address _user_address, string _key); // Event
    event publicKeyDeleted(address _org_address, address _user_address, string _key); // Event
    event publicKeyNotFound(address _org_address, address _user_address);
    event organisationAddressNotFound(address _org_address);// Event
    
    // Maps address to pubkey
    mapping(address => mapping( address => string)) internal address_pubk;
    
    function setPublicKey(address _org_address, address _user_address, string memory _pub_key) public{
        address_pubk[_org_address][_user_address] = _pub_key;
        emit publicKeyAdded(_org_address, _user_address, _pub_key);
        return;
    }
    
    function retrievePublicKey(address _org_address, address _user_address) public returns(string memory){
        emit publicKeyRetrieved(_org_address, _user_address, address_pubk[_org_address][_user_address]);
        return address_pubk[_org_address][_user_address];
    }
    
    // function deletePublicKey(address _address) public{
    //     emit publicKeyDeleted(_address, address_pubk[_address]);
    //     delete address_pubk[_address];
    //     return;
    // }
    
    function getPublicKey(address _org_address, address _user_address) public returns (bool){
        return true;
    }
    
    function isAddressAnOrg(address _signer_address) public returns (bool){
        return true;
    }

}

// Contract for the main access control
contract ABAC_Access_Control{
    
    ABAC_Policies abac_policies;
    // KeyManagement keys;
    Address_PubKey_Mapping addr_pubk_map;
    Cloud_Accesses cloud_accesses;
    
    
    address abac_policies_addr;
    // address keys_management_addr;
    address emergency_attr_addr;
    address address_pubk_mapping_addr;
    address cloud_accesses_addr;
    
    string[] cloudTokens;
    
    uint organisation_uuid;
    uint admin;
    
    constructor (){
    }

    event invalidSignature(address _address, string _key); // Event
    event invalidHashComparison(address _address, string _key); // Event    
     
    function setABACPoliciesAddr(address _address) public{
        abac_policies_addr = _address;
    }
    
    // function setKeyManagementAddr(address _address) public{
    //     keys_management_addr = _address;
    // }
    
    function setEmergencyAttributesAddr(address _address) public{
        emergency_attr_addr = _address;
    }
    
    function setAddressPubKeyMappingAddr(address _address) public{
        address_pubk_mapping_addr = _address;
    }
    
    function setCloudAccesses(address _address) public{
        cloud_accesses_addr = _address;
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
        uint8[] memory _attr = attributes;
        
        uint8 v;
        bytes32 r;
        bytes32 s;
    
        (v, r, s) = splitSignature(_hashed_token);
        
        address _signer_address = ecrecover(_hashed_token, v, r, s);
        addr_pubk_map = Address_PubKey_Mapping(address_pubk_mapping_addr);
        
        // Was signed by org?
        if (orgSignValidated(_signer_address)){
            
            //Verify if the hash(attributes + msg.sender public key) matches the _hashed_token created by the organisation
            // string memory signer_pk = addr_pubk_map.retrievePublicKey(_signer_address);
            string memory sender_pk = addr_pubk_map.retrievePublicKey(_signer_address, msg.sender);
            if (signatureAndProfessionalVerification(_hashed_token, _attr, sender_pk)){
                // If everything is right with the authentication token, the requestAccess begins
                requestAccess(_access_type, sender_pk, _patient_uuid, _actions, _attr);
            }   
        }else{
            return;
        }
    }
    
    function orgSignValidated(address _signer_address) public returns(bool){
        addr_pubk_map = Address_PubKey_Mapping(address_pubk_mapping_addr);
        if (addr_pubk_map.isAddressAnOrg(_signer_address)){
            return true;
        }
        else{
            return false;
        }
    }
    
    function signatureAndProfessionalVerification(bytes32 _hashed_token, uint8[] memory _attr, string memory _pubKey) public pure returns(bool){
        bytes32 c = keccak256(abi.encode(_attr, _pubKey));
        return c == _hashed_token;
    }
    
    function requestAccess(string memory _access_type, string memory _public_key, uint _patient_uuid, string[] memory _actions, uint8[] memory _attributes) public{
        ABAC_Policies.Policy memory tmp_policy = loadPolicy(_access_type);
            // if(policyCompliant(tmp_policy, _attributes)){
            //     Cloud_Accesses.grantAccess(_public_key, _access_type, _patient_uuid, _actions);
            // }
        return;
    }

    function loadPolicy(string memory _access_type) public returns(ABAC_Policies.Policy memory){
        abac_policies = ABAC_Policies(abac_policies_addr);
        return abac_policies.queryPolicy(_access_type);
    }
    
    // function loadKey(uint _patient_uuid) public returns(string memory){
    //     keys = KeyManagement(keys_management_addr);
    //     return keys.retrieveEncryptedKey(_patient_uuid);
    // }
    
    // function policyCompliant(ABAC_Policies.Policy memory policy, uint8[] memory _attrs) public returns(bool){
    //     for (uint i=0; i<_attrs.length; i++) {
    //         if (policy.attr1 != _attrs[i]){
    //             return false;
    //         }
    //     }
    //     return true;
    // }
    
    function generateCloudToken() public{
        cloudTokens.push("NewToken");
    }
}

//
// THIS WORKS AS PIP IN THE ABAC
//
contract Contextual_Attributes{
    struct Extra_Info{
        uint uuid;
        bool attr6;
        bool attr7;
        bool attr8;
        bool attr9;
        bool attr10;
    }
    
    // Attributes mapping
    mapping(uint => Extra_Info) internal attributes;
    
    function addExtraInfo() public {
        //TODO   
    }
    
    function changeExtraInfo() public {
        // TODO
    }
    
    function deleteExtraInfo(uint _emergency_uuid) public {
        // TODO
    }
    
}

// contract KeyManagement{
    
//     struct Keys{
//         uint uuid;
//         string key;
//     }
    
//     mapping(uint => Keys) internal keys;
    
//     // Add encrypted keys to the blockchain indexed by uuid
//     function addEncryptedKey(uint _uuid, string memory _encrypted_key) public {
//         if (getKey(_uuid)){
//             return;
//         }
//         keys[_uuid] = Keys(_uuid, _encrypted_key);
//         return;
//     }
    
//     function retrieveEncryptedKey(uint _uuid) public returns(string memory ){
//         if (getKey(_uuid)){
//             Keys memory k = keys[_uuid];
//             return k.key;
//         } 
//         return "";
//     }

//     function changeEncryptedKey(uint _uuid, string memory _new_encrypted_key) public{
//         if (getKey(_uuid)){
//             Keys memory k = keys[_uuid];
//             k.key = _new_encrypted_key;
//             return;
//         } 
//         return;
//     }
    
//     function getKey(uint _uuid) internal returns (bool){
//         if (keys[_uuid].uuid == _uuid){
//             return true;
//         }
//         return false;
//     }
    
// }

contract Cloud_Accesses{
    struct Access{
        string access_type;
        uint patient_uuid;
        bool access_granted;
        uint256 creation_timestamp;
        uint256 expiration_timestamp;
    }
    
    event accessGranted(string _public_key, string _access_type); // Event
    event verificationSuccess(string _public_key);
    event verificationFailed(string _public_key);
    event accessRevoked(string _public_key);
    
    mapping(string => Access) internal accesses;
    
    // _public_key, _access_type, _patient_uuid, _actions
    function grantAccess(string memory _public_key, string memory _access_type, uint _patient_uuid, string[] memory _actions) public{
        accesses[_public_key] = Access(_access_type, _patient_uuid, true, block.timestamp, block.timestamp);
        emit accessGranted(_public_key, _access_type);
        return;
    }
    
    // 1st Verification
    function wasAccessGranted(string memory _public_key, uint _patient_uuid, string memory _access_type, string[] memory _actions) public returns(bool){
        if (getGrantedAccess(_public_key, _patient_uuid, _access_type, _actions)){
            emit verificationSuccess(_public_key);
            return true;
        }
        else{
            emit verificationFailed(_public_key);
            return false;
        }
    }
    
    // 2nd
    // How to log that the cloud really delivered the data to the professional

    function revokeAccess(string memory _public_key) public{
        delete accesses[_public_key];
        emit accessRevoked(_public_key);
        return;
    }

    function getGrantedAccess(string memory _public_key, uint _patient_uuid, string memory _access_type, string[] memory _actions) internal returns (bool){
        return true;
    }
}