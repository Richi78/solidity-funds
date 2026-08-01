//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

  function getVersion(AggregatorV3Interface _priceFeed) public view returns (uint256){
    return _priceFeed.version();
  }

  function getPrice(AggregatorV3Interface _priceFeed) public view returns (uint256 ){
    (, int256 price, , , ) = _priceFeed.latestRoundData();
    return uint256(price * 1e10); 
  }

  function getConversionRate(uint256 ethAmount, AggregatorV3Interface _priceFeed) public view returns (uint256){
    uint256 ethPrice = getPrice(_priceFeed);
    return (ethPrice * ethAmount) / 1e18;
  }
}