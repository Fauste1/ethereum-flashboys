pragma solidity ^0.8.0;

import './IDummyToken.sol';

contract CollateralToken is IDummyToken {
    mapping(address => uint) internal _balanceOf;
    
    constructor() {
        _balanceOf[msg.sender] = 1000;
    }
    
    function transfer(address recipient, uint amount) external virtual override {
        _transfer(msg.sender, recipient, amount);
    }
    
    function transferFrom(address sender, address recipient, uint amount) external virtual override {
        _transfer(sender, recipient, amount);
    }
    
    function _transfer(address _sender, address _recipient, uint _amount) internal {
        require(_balanceOf[_sender] >= _amount, "insufficient balance for transfer");
        
        // Execute the transfer
        _balanceOf[_sender] -= _amount;
        _balanceOf[_recipient] += _amount;
    }
    
    function myBalance() external view returns (uint balance) {
        return _balanceOf[msg.sender];
    }
    
    function balanceOf(address owner) external view override returns (uint balance) {
        return _balanceOf[owner];
    }
}