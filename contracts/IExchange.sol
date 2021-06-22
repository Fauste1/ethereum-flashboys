// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IExchange {
    
    // mock arbitrage opportunity
    // gives msg.sender 2 dummy tokens for each collateral token traded
    function arbitrageOpportunity(uint amountIn) external;
    
    // mock arbitrage opportunity triggered via allowance
    // gives owner 2 dummy tokens for each collateral token traded
    function arbitrageOpportunityFrom(address owner, uint amountIn) external;
    
    // gives msg.sender 1 collateralToken for each dummyToken sent
    function swapDummyToCollateral(uint amount) external;
    
    // gives owner 1 collateralToken for each dummyToken sent via allowance
    function swapDummyToCollateralFrom(address owner, uint amount) external;
    
    // gives msg.sender 1 dummyToken for each collateralToken sent
    function swapCollateralToDummy(uint amount) external;
    
    // gives owner 1 dummyToken for each collateralToken sent via allowance
    function swapCollateralToDummyFrom(address owner, uint amount) external;
    
    // returns current balance of dummyToken held by the exchange
    function dummyWarchest() external view returns (uint);
    
    // returns current balance of collateralToken held by the exchange
    function collateralWarchest() external view returns (uint);
}
