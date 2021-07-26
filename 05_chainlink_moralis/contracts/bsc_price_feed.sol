pragma solidity ^0.6.6;
import "smartcontractkit/chainlink-brownie-contracts@1.0.2/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract Price_BNB{

    AggregatorV3Interface internal priceFeed;

    constructor() public {
        priceFeed = AggregatorV3Interface(0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE);
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