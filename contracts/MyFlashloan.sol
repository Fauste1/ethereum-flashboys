// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './IExchange.sol';
import './IMyFlashloan.sol';

contract MyFlashloan is IMyFlashloan {

    IExchange internal exchange;
    
    constructor(address exchangeContract_) {
        exchange = IExchange(exchangeContract_);
    }
    
    function tradingStrategy(address trader, uint amount) external override {
        // get required collateralTokens
        exchange.swapDummyToCollateralFrom(trader, amount);
        
        // execute arb opportunity & get dummyTokens
        exchange.arbitrageOpportunityFrom(trader, amount);
    }   
}

