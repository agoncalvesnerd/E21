pragma experimental ABIEncoderV2;

// randomization helpers
contract R11n {
    
    // generates a random number based on block variables.
    // OBVIOUS ATTACK VECTOR HERE - NEED TO USE AN ORACLE IN PRODUCTION
    function randomNumber(uint size) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % size;
    }

}