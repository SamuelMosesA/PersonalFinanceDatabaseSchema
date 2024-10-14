--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.2)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: transactions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA transactions;


ALTER SCHEMA transactions OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: credit_card_transactions; Type: TABLE; Schema: transactions; Owner: postgres
--

CREATE TABLE transactions.credit_card_transactions (
    statement_id_in_file integer NOT NULL,
    statement_file_name text NOT NULL,
    card_number text,
    tx_date date NOT NULL,
    descriptions text NOT NULL,
    country_code text NOT NULL,
    exchange_rate double precision,
    foreign_currency text,
    foreign_amount double precision,
    direct_debit_link integer,
    tx_amount numeric NOT NULL,
    loan_reference integer,
    tx_category integer
);


ALTER TABLE transactions.credit_card_transactions OWNER TO postgres;

--
-- Name: debit_transactions; Type: TABLE; Schema: transactions; Owner: postgres
--

CREATE TABLE transactions.debit_transactions (
    id integer NOT NULL,
    tx_amount numeric NOT NULL,
    currency character(6) NOT NULL,
    desc_json jsonb NOT NULL,
    description text NOT NULL,
    start_balance numeric NOT NULL,
    end_balance numeric NOT NULL,
    loan_reference integer,
    tx_category integer,
    tx_date date NOT NULL,
    audit_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    remarks text,
    account text NOT NULL,
    recurrence character varying(255),
    CONSTRAINT debit_transactions_recurrence_check CHECK (((recurrence)::text = ANY ((ARRAY['Monthly'::character varying, 'Yearly'::character varying])::text[])))
);


ALTER TABLE transactions.debit_transactions OWNER TO postgres;

--
-- Name: debit_transactions_id_seq; Type: SEQUENCE; Schema: transactions; Owner: postgres
--

CREATE SEQUENCE transactions.debit_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE transactions.debit_transactions_id_seq OWNER TO postgres;

--
-- Name: debit_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: transactions; Owner: postgres
--

ALTER SEQUENCE transactions.debit_transactions_id_seq OWNED BY transactions.debit_transactions.id;


--
-- Name: loans; Type: TABLE; Schema: transactions; Owner: postgres
--

CREATE TABLE transactions.loans (
    id integer NOT NULL,
    tx_amount_borrowed numeric NOT NULL,
    currency character(6) DEFAULT 'EUR'::bpchar NOT NULL,
    counterparty text NOT NULL,
    remarks text,
    foreign_amt_borrowed numeric
);


ALTER TABLE transactions.loans OWNER TO postgres;

--
-- Name: manual_transactions; Type: TABLE; Schema: transactions; Owner: postgres
--

CREATE TABLE transactions.manual_transactions (
    id integer NOT NULL,
    tx_amount numeric NOT NULL,
    currency character(6) DEFAULT 'EUR'::bpchar NOT NULL,
    desc_json jsonb NOT NULL,
    description text NOT NULL,
    loan_reference integer,
    tx_category integer,
    tx_date date NOT NULL,
    audit_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    remarks text
);


ALTER TABLE transactions.manual_transactions OWNER TO postgres;

--
-- Name: manual_transactions_id_seq; Type: SEQUENCE; Schema: transactions; Owner: postgres
--

CREATE SEQUENCE transactions.manual_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE transactions.manual_transactions_id_seq OWNER TO postgres;

--
-- Name: manual_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: transactions; Owner: postgres
--

ALTER SEQUENCE transactions.manual_transactions_id_seq OWNED BY transactions.manual_transactions.id;


--
-- Name: tx_categories; Type: TABLE; Schema: transactions; Owner: postgres
--

CREATE TABLE transactions.tx_categories (
    id integer NOT NULL,
    category text NOT NULL,
    subcategory text NOT NULL
);


ALTER TABLE transactions.tx_categories OWNER TO postgres;

--
-- Name: tx_categories_id_seq; Type: SEQUENCE; Schema: transactions; Owner: postgres
--

CREATE SEQUENCE transactions.tx_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE transactions.tx_categories_id_seq OWNER TO postgres;

--
-- Name: tx_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: transactions; Owner: postgres
--

ALTER SEQUENCE transactions.tx_categories_id_seq OWNED BY transactions.tx_categories.id;


--
-- Name: debit_transactions id; Type: DEFAULT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.debit_transactions ALTER COLUMN id SET DEFAULT nextval('transactions.debit_transactions_id_seq'::regclass);


--
-- Name: manual_transactions id; Type: DEFAULT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.manual_transactions ALTER COLUMN id SET DEFAULT nextval('transactions.manual_transactions_id_seq'::regclass);


--
-- Name: tx_categories id; Type: DEFAULT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.tx_categories ALTER COLUMN id SET DEFAULT nextval('transactions.tx_categories_id_seq'::regclass);



--
-- Name: credit_card_transactions credit_card_transactions_pk_81228c; Type: CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.credit_card_transactions
    ADD CONSTRAINT credit_card_transactions_pk_81228c PRIMARY KEY (statement_file_name, statement_id_in_file);


--
-- Name: debit_transactions debit_transactions_pkey; Type: CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.debit_transactions
    ADD CONSTRAINT debit_transactions_pkey PRIMARY KEY (id);


--
-- Name: loans loans_pk_5d2904; Type: CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.loans
    ADD CONSTRAINT loans_pk_5d2904 PRIMARY KEY (id);


--
-- Name: manual_transactions manual_transactions_pk_8f85eb_4c6066; Type: CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.manual_transactions
    ADD CONSTRAINT manual_transactions_pk_8f85eb_4c6066 PRIMARY KEY (id);


--
-- Name: tx_categories tx_categories_pk_481e5d; Type: CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.tx_categories
    ADD CONSTRAINT tx_categories_pk_481e5d PRIMARY KEY (id);



--
-- Name: uix_category_subcategory; Type: INDEX; Schema: transactions; Owner: postgres
--

CREATE UNIQUE INDEX uix_category_subcategory ON transactions.tx_categories USING btree (category, subcategory);


--
-- Name: uix_debit_transactions; Type: INDEX; Schema: transactions; Owner: postgres
--

CREATE UNIQUE INDEX uix_debit_transactions ON transactions.debit_transactions USING btree (tx_date, tx_amount, start_balance, end_balance, account, currency, description);


--
-- Name: credit_card_transactions credit_card_direct_debit_link; Type: FK CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.credit_card_transactions
    ADD CONSTRAINT credit_card_direct_debit_link FOREIGN KEY (direct_debit_link) REFERENCES transactions.debit_transactions(id);


--
-- Name: credit_card_transactions credit_card_loan_link; Type: FK CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.credit_card_transactions
    ADD CONSTRAINT credit_card_loan_link FOREIGN KEY (loan_reference) REFERENCES transactions.loans(id);


--
-- Name: credit_card_transactions credit_card_tx_category; Type: FK CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.credit_card_transactions
    ADD CONSTRAINT credit_card_tx_category FOREIGN KEY (tx_category) REFERENCES transactions.tx_categories(id);


--
-- Name: debit_transactions debit_tx_category; Type: FK CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.debit_transactions
    ADD CONSTRAINT debit_tx_category FOREIGN KEY (tx_category) REFERENCES transactions.tx_categories(id);


--
-- Name: debit_transactions loan_reference; Type: FK CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.debit_transactions
    ADD CONSTRAINT loan_reference FOREIGN KEY (loan_reference) REFERENCES transactions.loans(id);


--
-- Name: manual_transactions manual_transactions_loan_link; Type: FK CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.manual_transactions
    ADD CONSTRAINT manual_transactions_loan_link FOREIGN KEY (loan_reference) REFERENCES transactions.loans(id);


--
-- Name: manual_transactions manual_tx_category; Type: FK CONSTRAINT; Schema: transactions; Owner: postgres
--

ALTER TABLE ONLY transactions.manual_transactions
    ADD CONSTRAINT manual_tx_category FOREIGN KEY (tx_category) REFERENCES transactions.tx_categories(id);


--
-- PostgreSQL database dump complete
--

