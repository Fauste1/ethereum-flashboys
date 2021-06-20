pragma solidity ^0.8.0;

interface IDummyExchange {
    function arbitrageOpportunity(uint amountIn) external;
    function arbitrageOpportunityFrom(address owner, uint amountIn) external;
    function swapDummyToCollateral(uint amount) external;
    function swapDummyToCollateralFrom(address owner, uint amount) external;
    function swapCollateralToDummy(uint amount) external;
    function swapCollateralToDummyFrom(address owner, uint amount) external;
    function dummyWarchest() external view returns (uint);
    function collateralWarchest() external view returns (uint);
}