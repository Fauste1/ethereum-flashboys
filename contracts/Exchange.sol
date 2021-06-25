// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import './IExchange.sol';

/**
* TODO: Incorporate a trading fee
*/

contract Exchange is IExchange {
    
    IERC20 dToken; // dummy token for trading purposes
    IERC20 cToken; // dummy token for collateral purposes
    
    constructor(address dTokenContract_, address cTokenContract_) {
        dToken = IERC20(dTokenContract_);
        cToken = IERC20(cTokenContract_);
    }
    
    // mock arbitrage opportunity giving sender 2 dummy tokens for each collateral token traded
    function arbitrageOpportunity(uint amountIn) external override {
        cToken.transferFrom(msg.sender, address(this), amountIn);
        
        uint amountOut = amountIn * 2;
        
        dToken.transfer(msg.sender, amountOut);
    }
    
    // mock arbitrage opportunity triggered via allowance
    // gives owner 2 dummy tokens for each collateral token traded
    function arbitrageOpportunityFrom(address owner, uint amountIn) external override {
        cToken.transferFrom(owner, address(this), amountIn);
        
        uint amountOut = amountIn * 2;
        
        dToken.transfer(owner, amountOut);
    }
    
    // swaps callers dToken 1:1 for cToken
    function swapDummyToCollateral(uint amount) external override {
        dToken.transferFrom(msg.sender, address(this), amount);
        cToken.transfer(msg.sender, amount);
    }
    
    // swaps owner's dToken 1:1 for cToken via allowance
    function swapDummyToCollateralFrom(address owner, uint amount) external override {
        dToken.transferFrom(owner, address(this), amount);
        cToken.transfer(owner, amount);
    }
    
    // swaps callers cToken 1:1 for dToken
    function swapCollateralToDummy(uint amount) external override {
        cToken.transferFrom(msg.sender, address(this), amount);
        dToken.transfer(msg.sender, amount);
    }
    
    // swaps owners cToken 1:1 for dToken via allowance
    function swapCollateralToDummyFrom(address owner, uint amount) external override {
        cToken.transferFrom(owner, address(this), amount);
        dToken.transfer(owner, amount);
    }
    
    // returns the current balance of dummy tokens on the exchange
    function dummyWarchest() external view override returns (uint) {
        return dToken.balanceOf(address(this));
    }
    
    // returns the current amount of collateral tokens on the exchange
    function collateralWarchest() external view override returns (uint) {
        return cToken.balanceOf(address(this));
    }
}