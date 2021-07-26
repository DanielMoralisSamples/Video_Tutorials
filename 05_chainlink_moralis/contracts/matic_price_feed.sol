pragma solidity ^0.6.6;
import "smartcontractkit/chainlink-brownie-contracts@1.0.2/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract Price_MATIC{

    AggregatorV3Interface internal priceFeed;

    constructor() public {
        priceFeed = AggregatorV3Interface(0xAB594600376Ec9fD91F8e885dADF0CE036862dE0);
    }

    /**
     * Returns the latest price
     */
    function getThePrice() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}