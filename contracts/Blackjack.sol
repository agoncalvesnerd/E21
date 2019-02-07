pragma experimental ABIEncoderV2;

import "./helpers/safemath.sol";

contract Blackjack {

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    struct User {
        uint32 winningHands;
        uint32 losingHands;
        uint256 registerDate;
    }

    // simple mapping of user data
    mapping (address => User) users;

    

}