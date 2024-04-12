## PlsSql-Project-One
# YearDifference Function
The YearDifference function calculates the difference in years between two given dates based on the specified payment frequency.

# Parameters:

 startDate: Start date of the contract.
 endDate: End date of the contract.
 payment: Payment frequency, which can be 'QUARTER', 'ANNUAL', 'HALF_ANNUAL', or any other value.
## Returns:

 diff_between: The number of years between the start and end dates, based on the specified payment frequency.
 FirstDate Function
The FirstDate function computes the date of the first installment based on the given start date and payment frequency.

# Parameters:

startDate: Start date of the contract.
 payment: Payment frequency, which can be 'QUARTER', 'HALF_ANNUAL', 'MONTHLY', or any other value.

# Returns:
 MonthDate: The date of the first installment based on the given start date and payment frequency.
InsertData Procedure
The InsertData procedure inserts installment payment details into the HR.INSTALLMENTS_PAID table.

# Parameters:
p_contract_id: Contract ID.
p_INSTALLMENT_DATE: Date of the installment.
p_INSTALLMENT_AMOUNT: Amount of the installment.

# Main Block
The main block of PL/SQL code iterates over contracts, calculates installment amounts, and inserts installment payment details into the HR.INSTALLMENTS_PAID table.

# Variables:

contractCursor: Cursor to fetch contract details.
startDate, diff_between, finalFees, contractTotal, date_contract: Variables used for computation and iteration.
Execution:

The code calculates installment amounts based on the contract total fees, deposit fees, and payment frequency.
It iterates over each contract, calculates installment amounts, and inserts payment details into the HR.INSTALLMENTS_PAID table.
The loop continues until the start date of the contract reaches its end date.

# -For any assistance or queries, contact [mariammarco646@gmail.com].





