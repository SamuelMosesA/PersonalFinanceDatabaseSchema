ALTER TABLE  transactions.debit_transactions
add column bank text not null default 'abn_current';

create index ix_debit_stmt_bank on transactions.debit_transactions using btree(bank);