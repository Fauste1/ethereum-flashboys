// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IMyFlashloan {
    // executes a custom trading strategy
    function tradingStrategy(address trader, uint amount) external;
}