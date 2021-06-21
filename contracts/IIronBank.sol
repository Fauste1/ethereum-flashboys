// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IIronBank {
    function depositCollateral(uint amount) external;
    function depositCollateralFrom(address depositor, uint amount) external;
    function availableCredit(address debtor) external view returns (uint);
    function borrow(uint amount) external;
    function borrowFrom(address borrower, uint amount) external;
    function repay(uint amount) external;
    function repayFrom(address debtor, uint amount) external;
    function withdrawCollateral(uint amount) external;
    function withdrawCollateralFrom(address owner, uint amount) external;
    function dummyWarchest() external view returns (uint);
    function collateralWarchest() external view returns (uint);
}