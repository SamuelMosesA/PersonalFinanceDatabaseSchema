ALTER TABLE transactions.manual_transactions
ADD COLUMN correcting_debit_tx_ref int4 REFERENCES transactions.debit_transactions(id),
ADD COLUMN correcting_tx_date date;