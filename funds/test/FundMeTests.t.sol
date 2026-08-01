//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "src/Funds.sol";
import {MockV3Aggregator} from "src/mock/mockV3Aggregator.sol";

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "src/PriceConverter.sol";

contract FundMeTest is Test {
    using PriceConverter for AggregatorV3Interface;
    address owner = makeAddr("owner");
    address user = makeAddr("user");
    FundMe fundMe;
    MockV3Aggregator mock;

    function setUp() public {
      mock = new MockV3Aggregator();

      vm.startPrank(owner);
      fundMe = new FundMe(address(mock));
      vm.stopPrank();

    }

    function testGetVersion() public {
      uint version = fundMe.priceFeed().getVersion();
      assertEq(version, 4);
    }

    function testGetPrice() public {
      uint256 price = fundMe.priceFeed().getPrice();
      assertEq(price, 1953e18);
    }

    function testFundExpectedRevert() public {
      vm.expectRevert();
      fundMe.fund();
    }

    function testFundSuccess() public {
      address alice = makeAddr("alice");
      vm.deal(alice, 2 ether);
      vm.prank(alice);
      uint256 current = address(fundMe).balance;
      fundMe.fund{value: 1 ether}();
      assertEq(address(fundMe).balance, current + 1 ether);
      assertEq(alice.balance, 1 ether);
    }

    function testRefundAllOwner() public {
      vm.prank(owner);
      fundMe.refundAll();
      assertEq(address(fundMe).balance, 0);
      assertEq(fundMe.getFundersLength(), 0);
    }

    function testRefundAllNotOwner() public {
      vm.expectRevert(FundMe.NotOwner.selector);
      vm.prank(user);
      fundMe.refundAll();
    }

    function testReceiveCallsFund() public {
      address alice = makeAddr("alice");
      vm.deal(alice, 5 ether);
      vm.prank(alice);
      (bool success, ) = address(fundMe).call{value: 0.1 ether}("");
      assertTrue(success);
      assertEq(fundMe.addressToAmountFunded(alice), 0.1 ether);
      assertEq(fundMe.userAddress(0), alice);
      assertEq(address(fundMe).balance, 0.1 ether);
    }

    function testFallbackCallsFund() public {
      address alice = makeAddr("alice");
      vm.deal(alice, 5 ether);
      vm.prank(alice);
      (bool success, ) = address(fundMe).call{value: 0.1 ether}(abi.encodeWithSignature("functionDoesNotExist()"));
      assertTrue(success);
      assertEq(fundMe.addressToAmountFunded(alice), 0.1 ether);
      assertEq(fundMe.userAddress(0), alice);
      assertEq(address(fundMe).balance, 0.1 ether);
    }
}
