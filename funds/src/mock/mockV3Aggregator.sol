//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract MockV3Aggregator is AggregatorV3Interface {
    function version() external pure returns (uint256) {
        return 4;
    }

    function decimals() external pure override returns (uint8) {
        return 8;
    }

    function latestRoundData()
        external
        view
        override
        returns (uint80, int256, uint256, uint256, uint80)
    {
        return (1, 1953e8, block.timestamp, block.timestamp, 1);
    }

    function description() external pure override returns (string memory) {
        return "Mock ETH/USD";
    }

    function getRoundData(
        uint80 /* _roundId */
    )
        external
        view
        override
        returns (uint80, int256, uint256, uint256, uint80)
    {
        return (1, 3000e8, block.timestamp, block.timestamp, 1);
    }
}
