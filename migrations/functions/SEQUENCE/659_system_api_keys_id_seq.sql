CREATE SEQUENCE public.system_api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.system_api_keys_id_seq OWNED BY public.system_api_keys.id;


--
-- Name: task_assignments; Type: TABLE; Schema: public; Owner: -
--

