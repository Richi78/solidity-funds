// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "src/PriceConverter.sol";

contract FundMe{
  // Get funds from users
  // Withdraw funds
  // Set a minimum funding value in USD
  using PriceConverter for uint256;
  using PriceConverter for AggregatorV3Interface;

  uint256 public constant MINIMUN_USD = 5e18;
  AggregatorV3Interface public priceFeed;
  mapping(address => uint256) public addressToAmountFunded;
  address[] public userAddress;

  constructor(address _priceFeed){
    priceFeed = AggregatorV3Interface(_priceFeed);
  }

  function fund() public payable{
    // Allow users to send $
    // Have a minimum $ sent
    // how do we send ETH to this contract?
    require(msg.value.getConversionRate(priceFeed) > MINIMUN_USD, "Didn't send enought ETH"); // 1e18 = 1ETH = 1000000000000000000 wei 
    
    // What is reverting?
    // it undoes any actions that have been done ans sends the remaining gas back to the caller 
    if(addressToAmountFunded[msg.sender] == 0){
      userAddress.push(msg.sender);
    }
    addressToAmountFunded[msg.sender] += msg.value;
  }

  function getVersion() public view returns (uint256){
    return priceFeed.version();
  }

  function withdraw() public {

  }
}