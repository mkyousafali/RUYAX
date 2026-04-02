CREATE SEQUENCE public.break_reasons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: break_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.break_reasons_id_seq OWNED BY public.break_reasons.id;


--
-- Name: break_register; Type: TABLE; Schema: public; Owner: -
--

