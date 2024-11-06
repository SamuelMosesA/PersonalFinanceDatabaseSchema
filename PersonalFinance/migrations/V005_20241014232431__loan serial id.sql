--
-- Name: loans_id_seq; Type: SEQUENCE; Schema: transactions; Owner: postgres
--

CREATE SEQUENCE transactions.loans_id_seq	
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE transactions.loans_id_seq OWNER TO postgres;

--
-- Name: loans_id_seq; Type: SEQUENCE OWNED BY; Schema: transactions; Owner: postgres
--

ALTER SEQUENCE transactions.loans_id_seq OWNED BY transactions.loans.id;