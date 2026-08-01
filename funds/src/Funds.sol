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
  address owner;

  constructor(address _priceFeed){
    priceFeed = AggregatorV3Interface(_priceFeed);
    owner = msg.sender;
  }

  modifier onlyOwner(){
    require(owner == msg.sender, "Your are not the owner");
    _;
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

  function refundAll() public onlyOwner {
    for(uint256 i=0 ; i<userAddress.length ; i++){
      address funder = userAddress[i];
      uint256 amount = addressToAmountFunded[funder];
      addressToAmountFunded[funder]=0;
      (bool success, ) = payable(funder).call{value: amount}("");
      require(success, "Call failed");
    }
    userAddress = new address[](0);
    // there are different ways to pass eth to other acc
    // .transfer -> limited gas if failed throws error and reversed authomatically
    // .send -> limited gas, returns a bool so we need to reverse manually
    // .call -> unlimited gas, returns a tupple (bool, bytes mem data), also reverse manually
  }
}