CREATE SEQUENCE public.offer_usage_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offer_usage_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offer_usage_logs_id_seq OWNED BY public.offer_usage_logs.id;


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -
--

