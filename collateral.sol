// SPDX-License-Identifier: MIT
//credits Todd Proebsting


pragma solidity ^0.6.0;

import "./ierc20token.sol";
import "./loan.sol";

contract LoanRequest{
    address payable public borrower;// = msg.sender;
    IERC20 public token;
    uint256 public collateralAmount;
    uint256 public loanAmount;
    uint256 public payoffAmount;
    uint256 public loanDuration;

    constructor(
        address payable _borrower,
        IERC20 _token,
        uint256 _collateralAmount,
        uint256 _loanAmount,
        uint256 _payoffAmount,
        uint256 _loanDuration
    )
        public
    {
        borrower = _borrower;
        token = IERC20(_token);
        collateralAmount = _collateralAmount;
        loanAmount = _loanAmount;
        payoffAmount = _payoffAmount;
        loanDuration = _loanDuration;
    }

    event LoanRequestAccepted(address loan);
    function lendEther() public payable {
        require(msg.value == loanAmount, "Please send the compelete amount of requested loan");
        Loan loan = new Loan(
            msg.sender,
            borrower,
            token,
            collateralAmount,
            payoffAmount,
            loanDuration
        );

        token.approve(address(loan), collateralAmount);
        token.approve(address(loan), collateralAmount);
        require(token.transferFrom(address(borrower), address(loan), collateralAmount), "Please transfer the collateral amount first");
        borrower.transfer(loanAmount);
        emit LoanRequestAccepted(address(loan));
    }
}
