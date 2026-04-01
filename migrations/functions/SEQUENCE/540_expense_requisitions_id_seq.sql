CREATE SEQUENCE public.expense_requisitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expense_requisitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.expense_requisitions_id_seq OWNED BY public.expense_requisitions.id;


--
-- Name: expense_scheduler; Type: TABLE; Schema: public; Owner: -
--

