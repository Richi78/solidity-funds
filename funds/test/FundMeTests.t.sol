//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "src/Funds.sol";
import {MockV3Aggregator} from "src/mock/mockV3Aggregator.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    MockV3Aggregator mock;

    function setUp() public {
      mock = new MockV3Aggregator();
      fundMe = new FundMe(address(mock));
    }

    function testGetVersion() public {
      uint version = fundMe.getVersion();
      assertEq(version, 4);
    }

    function testGetPrice() public {
      uint256 price = fundMe.getPrice();
      assertEq(price, 1953e18);
    }

    function testFundExpectedRevert() public {
      vm.expectRevert();
      fundMe.fund();
    }
}
