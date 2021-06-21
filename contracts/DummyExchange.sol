// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './IDummyToken.sol';
import './IDummyExchange.sol';

contract Exchange is IDummyExchange {
    
    IDummyToken dummyToken;
    IDummyToken collateralToken;
    
    constructor(address dummyTokenContract_, address collateralTokenContract_) {
        dummyToken = IDummyToken(dummyTokenContract_);
        collateralToken = IDummyToken(collateralTokenContract_);
    }
    
    // mock arbitrage opportunity giving sender 2 dummy tokens for each collateral token traded
    function arbitrageOpportunity(uint amountIn) external override {
        collateralToken.transferFrom(msg.sender, address(this), amountIn);
        
        uint amountOut = amountIn * 2;
        
        dummyToken.transfer(msg.sender, amountOut);
    }
    
    // mock arbitrage opportunity triggered via allowance
    // gives owner 2 dummy tokens for each collateral token traded
    function arbitrageOpportunityFrom(address owner, uint amountIn) external override {
        collateralToken.transferFrom(owner, address(this), amountIn);
        
        uint amountOut = amountIn * 2;
        
        dummyToken.transfer(owner, amountOut);
    }
    
    // swaps callers collateralToken 1:1 for dummyToken
    function swapDummyToCollateral(uint amount) external override {
        dummyToken.transferFrom(msg.sender, address(this), amount);
        collateralToken.transfer(msg.sender, amount);
    }
    
    function swapDummyToCollateralFrom(address owner, uint amount) external override {
        dummyToken.transferFrom(owner, address(this), amount);
        collateralToken.transfer(owner, amount);
    }
    
    // swaps callers dummyToken 1:1 for collateralToken
    function swapCollateralToDummy(uint amount) external override {
        collateralToken.transferFrom(msg.sender, address(this), amount);
        dummyToken.transfer(msg.sender, amount);
    }
    
    function swapCollateralToDummyFrom(address owner, uint amount) external override {
        collateralToken.transferFrom(owner, address(this), amount);
        dummyToken.transfer(owner, amount);
    }
    
    // returns the current balance of dummy tokens on the exchange
    function dummyWarchest() external view override returns (uint) {
        return dummyToken.balanceOf(address(this));
    }
    
    // returns the current amount of collateral tokens on the exchange
    function collateralWarchest() external view override returns (uint) {
        return collateralToken.balanceOf(address(this));
    }
}