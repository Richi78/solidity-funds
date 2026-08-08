//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "src/Funds.sol";
import {HelperConfig} from "script/Helperconfig.s.sol";

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "src/PriceConverter.sol";

contract FundMeTest is Test {
    using PriceConverter for AggregatorV3Interface;
    address owner = makeAddr("owner");
    FundMe fundMe;

    function setUp() public {
      (address priceFeed) = (new HelperConfig()).activeNetworkConfig();
      vm.startPrank(owner);
      fundMe = new FundMe(priceFeed);
      vm.stopPrank();
    }

    function testGetVersion() public {
      uint version = fundMe.getPriceFeed().getVersion();
      assertEq(version, 4);
    }

    function testGetPrice() public {
      uint256 price = fundMe.getPriceFeed().getPrice();
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
      address user = makeAddr("user");
      vm.prank(user);
      fundMe.refundAll();
    }

    function testReceiveCallsFund() public {
      address alice = makeAddr("alice");
      vm.deal(alice, 5 ether);
      vm.prank(alice);
      (bool success, ) = address(fundMe).call{value: 0.1 ether}("");
      assertTrue(success);
      assertEq(fundMe.getAddressToAmountFunded(alice), 0.1 ether);
      assertEq(fundMe.getUserAddress(0), alice);
      assertEq(address(fundMe).balance, 0.1 ether);
    }

    function testFallbackCallsFund() public {
      address alice = makeAddr("alice");
      vm.deal(alice, 5 ether);
      vm.prank(alice);
      (bool success, ) = address(fundMe).call{value: 0.1 ether}(abi.encodeWithSignature("functionDoesNotExist()"));
      assertTrue(success);
      assertEq(fundMe.getAddressToAmountFunded(alice), 0.1 ether);
      assertEq(fundMe.getUserAddress(0), alice);
      assertEq(address(fundMe).balance, 0.1 ether);
    }
}
