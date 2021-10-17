pragma solidity ^0.5.0;
 
/**
 * @notice Minimal contract for testing purposes.
 */
contract TestContract {
    event AnchorCreated(string indexed blockHash, uint256 blockHeight);
 
    constructor() public {
    }
 
    function createAnchor(string memory _blockHash, uint256 _blockHeight) public {
        emit AnchorCreated(_blockHash, _blockHeight);
    }
}