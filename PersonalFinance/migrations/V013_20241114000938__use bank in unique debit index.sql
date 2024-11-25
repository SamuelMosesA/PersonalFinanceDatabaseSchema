DROP INDEX transactions.uix_debit_transactions;
DROP INDEX transactions.ix_debit_stmt_bank;
CREATE UNIQUE INDEX uix_debit_transactions ON transactions.debit_transactions USING btree (bank, tx_date, tx_amount, start_balance, end_balance, account, currency, description);
