// SPDX-License-Identifier: MIT
//credits Todd Proebsting

pragma solidity ^0.6.0;

import "./ierc20token.sol";

contract Loan {
    address payable public lender;
    address public borrower;
    IERC20 public token;
    uint256 public collateralAmount;
    uint256 public payoffAmount;
    uint256 public dueDate;

    constructor(
        address payable _lender,
        address _borrower,
        IERC20 _token,
        uint256 _collateralAmount,
        uint256 _payoffAmount,
        uint256 loanDuration
    )
        public
    {
        lender = _lender;
        borrower = _borrower;
        token = _token;
        collateralAmount = _collateralAmount;
        payoffAmount = _payoffAmount;
        dueDate = now + loanDuration;
    }

    event LoanPaid();

    function payLoan() public payable {
        require(now <= dueDate, "You can pay loans only till the due date");
        require(msg.value == payoffAmount, "Please enter the compelete payoff amount");

        require(token.transfer(borrower, collateralAmount), "No loan found in your name");
        emit LoanPaid();
        selfdestruct(lender);
    }

    function repossess() public {
        require(now > dueDate, "Please let the time be greater than the due date");

        require(token.transfer(lender, collateralAmount), "Requires lender to possess the collateral amount");
        selfdestruct(lender);
    }
}


