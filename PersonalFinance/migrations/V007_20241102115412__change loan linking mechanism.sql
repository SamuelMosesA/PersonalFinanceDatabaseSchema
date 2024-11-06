ALTER TABLE transactions.credit_card_transactions
DROP COLUMN loan_reference CASCADE;

ALTER TABLE transactions.manual_transactions
DROP COLUMN loan_reference CASCADE;

ALTER TABLE transactions.debit_transactions
DROP COLUMN loan_reference CASCADE;

ALTER TABLE transactions.loans
ADD COLUMN debit_tx_reference int4 REFERENCES transactions.debit_transactions(id),
ADD COLUMN credit_tx_stmt_file_ref text,
ADD COLUMN credit_tx_stmt_id_ref int4,
ADD COLUMN manual_tx_reference int4 REFERENCES transactions.manual_transactions(id),
ADD CONSTRAINT credit_card_loan_link FOREIGN KEY (credit_tx_stmt_file_ref,
credit_tx_stmt_id_ref) REFERENCES transactions.credit_card_transactions(statement_file_name,
statement_id_in_file);