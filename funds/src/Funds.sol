// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe{
  // Get funds from users
  // Withdraw funds
  // Set a minimum funding value in USD

  uint256 public minimumUsd = 5;
  AggregatorV3Interface public priceFeed;

  constructor(address _priceFeed){
    priceFeed = AggregatorV3Interface(_priceFeed);
  }

  function fund() public payable{
    // Allow users to send $
    // Have a minimum $ sent
    // how do we send ETH to this contract?
    require(msg.value > 5 * 1e18, "Didn't sent enought ETH"); // 1e18 = 1ETH = 1000000000000000000 wei 
    
    // What is reverting?
    // it undoes any actions that have been done ans sends the remaining gas back to the caller 


  }

  function getPrice() public view returns (uint80,int256,uint256,uint256,uint80){
    // address of the contract 0x694AA1769357215DE4FAC081bf1f309aDC325306 chainlink price feed
    // ABI
    return priceFeed.latestRoundData();
  }

  function getVersion() public view returns (uint256){
    return priceFeed.version();
  }
  function getConversionRate() public {

  }

  function withdraw() public {

  }
}