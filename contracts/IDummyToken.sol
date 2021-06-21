// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IDummyToken {
    function transfer(address recipient, uint amount) external;
    function transferFrom(address sender, address recipient, uint amount) external;
    function balanceOf(address owner) external view returns (uint balance);
}