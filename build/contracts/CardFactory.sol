pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract CardFactory is Ownable {

    uint randNonce = 0;
    uint8 cardsTotal = 52;
    
    string[] suits = ["H", "S", "C", "D"];
    string[] deck  = ["A", "K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2"];
    
    uint8 suitsTotal = uint8(suits.length);
    
    uint8 cardsBySuit = cardsTotal / suitsTotal;

    struct Card {
        uint8 id;
        string  suit;
        string  value;
        bool    initialized;
    }
    Card[] public cards;
    
    mapping(address => uint8) internal userFirstCard;
    mapping(address => uint8) internal userSecondCard;
    
    // populates database with every card combination
    // should ideally only be executed once
    function populateCards() external onlyOwner() {
        uint8 cardId = 0;
        for (uint8 i = 0; i <= suits.length - 1; i++) {
            for (uint8 j = 0; j < 13; j++) {
                cards.push(Card(cardId, suits[i], deck[j], true));
            }
        }
    }
    
    // draws a random card from the current deck and 
    function drawCard(address user) public view returns(Card memory) {
        require(user == msg.sender && cards.length != 0);
        Card[] memory availableCards = cards;
        uint256 firstCardId  = userFirstCard[user];
        uint256 secondCardId = userSecondCard[user];
        for (uint8 i = 0; i <= availableCards.length - 1; i++) {
            if (availableCards[i].id == firstCardId 
                || availableCards[i].id == secondCardId) {
                // make sure we don't get any 0 elements in our array by copying and deleting our last element - order doesn't matter because
                // we'll be randomizing when fetching cards
                availableCards[i] = availableCards[availableCards.length - 1];
                delete(availableCards[availableCards.length - 1]);
                // recalculate our array length - resorting to assembly here as $availableCards is a memory array
                assembly { mstore(availableCards, sub(mload(availableCards), 1)) }
            }
        }
        return availableCards[randomNumber(availableCards.length - 1)];
    }
    
    // generates a random number based on block variables.
    // OBVIOUS ATTACK VECTOR HERE - NEED TO USE AN ORACLE IN PRODUCTION
    function randomNumber(uint size) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % size;
    }

}