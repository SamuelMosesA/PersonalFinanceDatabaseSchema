alter table transactions.loans
add column settling_loan_tx_link integer NULL references transactions.loans(id);