CREATE SEQUENCE public.erp_sync_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: erp_sync_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.erp_sync_logs_id_seq OWNED BY public.erp_sync_logs.id;


--
-- Name: erp_synced_products; Type: TABLE; Schema: public; Owner: -
--

