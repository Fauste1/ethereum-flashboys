pragma solidity ^0.8.0;

import './IDummyToken.sol';
import './IIronBank.sol';
import './IDummyExchange.sol';

contract FlashBoys {

    address internal _originAddress;
    address internal _transitionAddress;
    IDummyToken dummyToken;
    IDummyToken collateralToken;
    IIronBank ironBank;
    IDummyExchange dummyExchange;
    
    constructor(
        address originAddress_,
        address dummyTokenContract_,
        address collateralTokenContract_,
        address ironBankContract_,
        address exchangeContract_
    ){
        // set the "flashloan" addresses
        _originAddress = originAddress_;
        
        // set the infrastructure addresses
        dummyToken = IDummyToken(dummyTokenContract_);
        collateralToken = IDummyToken(collateralTokenContract_);
        ironBank = IIronBank(ironBankContract_);
        dummyExchange = IDummyExchange(exchangeContract_);
    }
    
    function batchTransaction(uint amount) external {
        ironBank.depositCollateralFrom(_originAddress, amount);
        ironBank.borrowFrom(_originAddress, amount);
        dummyExchange.swapDummyToCollateralFrom(_originAddress, amount);
        dummyExchange.arbitrageOpportunityFrom(_originAddress, amount);
        ironBank.repayFrom(_originAddress, amount);
        ironBank.withdrawCollateralFrom(_originAddress, amount);
    }
}

