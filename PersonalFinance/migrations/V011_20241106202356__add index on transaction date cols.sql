CREATE INDEX ix_debit_tx_date on transactions.debit_transactions using btree(tx_date);
CREATE INDEX ix_credit_tx_date on transactions.credit_card_transactions using btree(tx_date);
CREATE INDEX ix_manual_tx_date on transactions.manual_transactions using btree(tx_date);
CREATE INDEX ix_manual_correction_tx_date on transactions.manual_transactions using btree(correcting_tx_date);
CREATE INDEX ix_loan_tx_date ON transactions.loans using btree(tx_date);