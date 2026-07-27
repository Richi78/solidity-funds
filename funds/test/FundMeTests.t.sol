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
      (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) = fundMe.getPrice();
      assertEq(roundId, 1);
      assertEq(answer, 3000e8);
      assertEq(startedAt, block.timestamp);
      assertEq(updatedAt, block.timestamp);
      assertEq(answeredInRound, 1);

        // return (1, 3000e8, block.timestamp, block.timestamp, 1);
    }

    function testGetPriceJustAnswer() public {
      (, int256 answer, , , ) = fundMe.getPrice();
      assertEq(answer, 3000e8);
    }
}
