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

  // variables

  uint256 public constant MINIMUN_USD = 5e18;
  AggregatorV3Interface private priceFeed;
  mapping(address => uint256) private s_addressToAmountFunded;
  address[] private s_userAddress;
  address immutable i_owner;

  constructor(address _priceFeed){
    priceFeed = AggregatorV3Interface(_priceFeed);
    i_owner = msg.sender;
  }

  // events

  // errors 
  error NotOwner();

  // modifiers

  modifier onlyOwner(){
    // require(i_owner == msg.sender, "Must be owner");
    if(msg.sender != i_owner){ revert NotOwner(); }
    _;
  }

  // functions

  function fund() public payable{
    require(msg.value.getConversionRate(priceFeed) > MINIMUN_USD, "Didn't send enought ETH"); // 1e18 = 1ETH = 1000000000000000000 wei 
    
    if(s_addressToAmountFunded[msg.sender] == 0){
      s_userAddress.push(msg.sender);
    }
    s_addressToAmountFunded[msg.sender] += msg.value;
  }

  function refundAll() public onlyOwner {
    for(uint256 i=0 ; i<s_userAddress.length ; i++){
      address funder = s_userAddress[i];
      uint256 amount = s_addressToAmountFunded[funder];
      s_addressToAmountFunded[funder]=0;
      (bool success, ) = payable(funder).call{value: amount}("");
      require(success, "Call failed");
    }
    s_userAddress = new address[](0);
  }

  function getFundersLength() public view returns (uint256){
    return s_userAddress.length;
  }

  receive() external payable {
    fund();
  }

  fallback() external payable {
    fund();
  }

  /**
   * View / Pure functions (Getters)
   */

  function getAddressToAmountFunded(address fundingAddress) external view returns (uint256){
    return s_addressToAmountFunded[fundingAddress];
  }

  function getUserAddress(uint256 index) external view returns (address){
    return s_userAddress[index];
  }

  function getPriceFeed() external view returns (AggregatorV3Interface){
    return priceFeed;
  }
}