// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './IDummyExchange.sol';
import './IMyFlashloan.sol';

contract MyFlashloan is IMyFlashloan {

    IDummyExchange internal dummyExchange;
    
    constructor(address exchangeContract_) {
        dummyExchange = IDummyExchange(exchangeContract_);
    }
    
    function tradingStrategy(address trader, uint amount) external override {
        // get required collateralTokens
        dummyExchange.swapDummyToCollateralFrom(trader, amount);
        
        // execute arb opportunity & get dummyTokens
        dummyExchange.arbitrageOpportunityFrom(trader, amount);
    }   
}

