// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './IDummyToken.sol';
import './IIronBank.sol';
import './IMyFlashloan.sol';

contract IronBank is IIronBank {
    
    mapping(address => uint) internal _availableCredit;
    IDummyToken     dummyToken;
    IDummyToken     collateralToken;
    IMyFlashloan    flashloan;
    
    
    constructor(
        address dummyTokenContract_,
        address collateralTokenContract_
    ) {
        dummyToken = IDummyToken(dummyTokenContract_);
        collateralToken = IDummyToken(collateralTokenContract_);
    }
    
    
    // get available credit of a debtor
    // returns an amount of dummyTokens the depositor can borrow
    function availableCredit(address depositor) external view override returns (uint) {
        return _availableCredit[depositor];
    }
    
    // returns the current amount of dummyTokens available in the bank
    function dummyWarchest() external view override returns (uint) {
        return dummyToken.balanceOf(address(this));
    }
    
    // returns the current amount of collateralTokens available in the bank
    function collateralWarchest() external view override returns (uint) {
        return collateralToken.balanceOf(address(this));
    }
    
    // deposit collateralToken
    // increases available credit for borrowing
    function depositCollateral(uint amount) external override {
        _depositCollateral(msg.sender, amount);
    }
    
    // deposit collateralToken via allowance
    // increases available credit for the depositor by the amount deposited
    function depositCollateralFrom(address depositor, uint amount) external override {
        _depositCollateral(depositor, amount);
    }
    
    
    // borrow DummyToken
    // decreases available credit for the borrower by the amount borrowed
    function borrow(uint amount) external override {
        require(_availableCredit[msg.sender] >= amount, "not enough available credit");
        _borrow(msg.sender, amount);
    }
    
    // borrow dummyToken via allowance
    // decreases available credit for the borrower by the amount borrowed
    function borrowFrom(address borrower, uint amount) external override {
        require(_availableCredit[borrower] >= amount, "not enough available credit");
        _borrow(borrower, amount);
    }
    
    
    // repay a loan
    // increases the amount of available credit
    function repay(uint amount) external override {
        _repay(msg.sender, amount);
    }
    
    // repay a loan via allowance
    // increases the amount of available credit of the debtor
    function repayFrom(address debtor, uint amount) external override {
        _repay(debtor, amount);
    }
    
    // withdraws deposited collateralToken
    // can only withdraw tokens that are not being used as a collateral for an active loan
    function withdrawCollateral(uint amount) external override {
        _withdrawCollateral(msg.sender, amount);
    }
    
    // withdraws deposited collateralToken via allowance
    // can only withdraw tokens that are not being used as a collateral for an active loan
    function withdrawCollateralFrom(address depositor, uint amount) external override {
        _withdrawCollateral(depositor, amount);
    }
    
    // FLASHLOANS
    
    function flashloanOperation(address flashloanContract, uint amount) external {
        // initiate the flashloan contract instance
        flashloan = IMyFlashloan(flashloanContract);
        
        // temporarily grants the caller an extra available credit for the flashloan accounting purposes
        _availableCredit[msg.sender] += amount;
        
        // flash borrow dummyToken without the need for a collateral deposit
        _borrow(msg.sender, amount);
        
        // execute the custom trading strategy
        flashloan.tradingStrategy(msg.sender, amount);
        
        // repay the entire borrowed amount
        _repay(msg.sender, amount);
        
        // Make sure the flashloan caller doesn't leave behind bad debt
        require(_availableCredit[msg.sender] >= 0, "Haven't paid back enough");
        
        // takes back the initially issued available credit
        _availableCredit[msg.sender] -= amount;
    }
    
    
    // INTERNAL FUNCTIONS
    
    // Internal function to handle collateral deposits
    function _depositCollateral(address _depositor, uint _amount) internal {
        // transfer collateral token from caller to the bank
        collateralToken.transferFrom(_depositor, address(this), _amount);
        
        // increase available credit (the dummy token) for the caller
        _availableCredit[_depositor] += _amount;
    }
    
    // Internal function to handle loan issuance
    function _borrow(address _borrower, uint _amount) internal {
        _availableCredit[_borrower] -= _amount;
        dummyToken.transfer(_borrower, _amount);
    }
    
    // repays a specified _amount of a loan the _debtor owes to the bank
    function _repay(address _debtor, uint _amount) internal {
        dummyToken.transferFrom(_debtor, address(this), _amount);
        
        // free up the repaid amount for further borrowing
        _availableCredit[_debtor] += _amount;
    }
    
    function _withdrawCollateral(address _depositor, uint _amount) internal {
        // check if the caller has enough available collateral to be withdrawn
        require(_availableCredit[_depositor] >= _amount, "no available collateral for withdrawal");
        
        // decrease available credit of the _depositor
        _availableCredit[_depositor] -= _amount;
        
        // transfers collateralToken from the bank to the depositor
        collateralToken.transferFrom(address(this), _depositor, _amount);
    }
}