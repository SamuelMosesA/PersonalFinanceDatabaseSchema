alter table transactions.credit_card_transactions
add column recurrence character varying(255),
add  CONSTRAINT credit_transactions_recurrence_check CHECK (((recurrence)::text = ANY ((ARRAY['Monthly'::character varying, 'Yearly'::character varying])::text[])));

alter table transactions.manual_transactions
add column recurrence character varying(255),
add  CONSTRAINT manual_transactions_recurrence_check CHECK (((recurrence)::text = ANY ((ARRAY['Monthly'::character varying, 'Yearly'::character varying])::text[])));