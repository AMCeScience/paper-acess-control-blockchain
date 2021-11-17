// SPDX-License-Identifier: MIT
//// ============================================================ ////
pragma solidity =0.8.7;
//// ============================================================ ////

contract BitsAndPieces{

    event printValue(bytes1 value);
    function and(uint8 a, uint8 b) public{        

        bytes1 a_bytes = bytes1(a);
        bytes1 b_bytes = bytes1(b);
        emit printValue(a_bytes);
        emit printValue(b_bytes);
        emit printValue(a_bytes & b_bytes);        
    }
}