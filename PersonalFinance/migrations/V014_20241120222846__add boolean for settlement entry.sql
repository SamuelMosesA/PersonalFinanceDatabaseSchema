ALTER TABLE transactions.loans 
ADD COLUMN is_settlement bool NOT NULL DEFAULT FALSE;