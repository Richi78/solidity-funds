//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "src/Funds.sol";
import "src/mock/mockV3Aggregator.sol";

contract DeployFunds is Script{

  function deploy() public returns(FundMe) {
    MockV3Aggregator mockV3Aggregator = new MockV3Aggregator();
    FundMe fundMe = new FundMe(address(mockV3Aggregator));
    return fundMe;
  }

  function run() external {
    uint256 privateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast();
    deploy();
    vm.stopBroadcast();

  }
}