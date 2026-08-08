//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {MockV3Aggregator} from "src/mock/mockV3Aggregator.sol";

contract HelperConfig {

  struct NetworkConfig{
    address priceFeed; // ETH/USD price feed address
  }

  NetworkConfig public activeNetworkConfig;
  MockV3Aggregator mock;

  constructor(){
    mock = new MockV3Aggregator();
    if(block.chainid == 1){ // mainnet
      activeNetworkConfig = getMainnetEthConfig();
    } else if(block.chainid == 11155111){ // sepolia testnet
      activeNetworkConfig = getSepoliaEthConfig();
    } else if(block.chainid == 31337) { // local anvil
      activeNetworkConfig = getAnvilEthConfig();
    }
  }

  function getMainnetEthConfig() public pure returns (NetworkConfig memory){
    NetworkConfig memory mainnetConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
    return mainnetConfig;
  }

  function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
    NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    return sepoliaConfig;
  }

  function getAnvilEthConfig() public view returns (NetworkConfig memory){
    NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mock)});
    return anvilConfig;
  }

}