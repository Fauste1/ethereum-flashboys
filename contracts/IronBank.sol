pragma solidity ^0.8.0;

import './IDummyToken.sol';
import './IIronBank.sol';

contract IronBank is IIronBank {
    
    mapping(address => uint) internal _debtOf;
    mapping(address => uint) internal _availableCredit;
    IDummyToken dummyToken;
    IDummyToken collateralToken;
    
    constructor(address dummyTokenContract_, address collateralTokenContract_) {
        dummyToken = IDummyToken(dummyTokenContract_);
        collateralToken = IDummyToken(collateralTokenContract_);
    }
    
    function debtOf(address debtor) external view override returns (uint debt) {
        return(_debtOf[debtor]);
    }
    
    // deposit collateral
    function depositCollateral(uint amount) external override {
        // transfer collateral token from caller to the bank
        collateralToken.transferFrom(msg.sender, address(this), amount);
        
        // increase available credit (the dummy token) for the caller
        _availableCredit[msg.sender] += amount;
    }
    
    function depositCollateralFrom(address depositor, uint amount) external override {
        // transfer collateral token from caller to the bank
        collateralToken.transferFrom(depositor, address(this), amount);
        
        // increase available credit (the dummy token) for the caller
        _availableCredit[depositor] += amount;
    }
    
    // get available credit of a debtor
    function availableCredit(address debtor) external view override returns (uint) {
        return _availableCredit[debtor];
    }
    
    // borrow DummyToken
    function borrow(uint amount) external override {
        require(_availableCredit[msg.sender] >= amount, "not enough available credit");
        _availableCredit[msg.sender] -= amount;
        dummyToken.transfer(msg.sender, amount);
    }
    
    function borrowFrom(address borrower, uint amount) external override {
        require(_availableCredit[borrower] >= amount, "not enough available credit");
        _availableCredit[borrower] -= amount;
        dummyToken.transfer(borrower, amount);
    }
    
    // repay a loan
    function repay(uint amount) external override {
        dummyToken.transferFrom(msg.sender, address(this), amount);
        _availableCredit[msg.sender] += amount;
    }
    
    function repayFrom(address debtor, uint amount) external override {
        dummyToken.transferFrom(debtor, address(this), amount);
        _availableCredit[debtor] += amount;
    }
    
    // withdraw collateral
    function withdrawCollateral(uint amount) external override {
        // check if the caller has enough available collateral for withdrawal
        require(_availableCredit[msg.sender] >= amount, "no available collateral for withdrawal");
        _availableCredit[msg.sender] -= amount;
        collateralToken.transferFrom(address(this), msg.sender, amount);
    }
    
    function withdrawCollateralFrom(address owner, uint amount) external override {
        // check if the caller has enough available collateral for withdrawal
        require(_availableCredit[owner] >= amount, "no available collateral for withdrawal");
        _availableCredit[owner] -= amount;
        collateralToken.transferFrom(address(this), owner, amount);
    }
    
    function dummyWarchest() external view override returns (uint) {
        return dummyToken.balanceOf(address(this));
    }
    
    function collateralWarchest() external view override returns (uint) {
        return collateralToken.balanceOf(address(this));
    }
}