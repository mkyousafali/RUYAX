CREATE SEQUENCE public.recurring_schedule_check_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recurring_schedule_check_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recurring_schedule_check_log_id_seq OWNED BY public.recurring_schedule_check_log.id;


--
-- Name: regular_shift; Type: TABLE; Schema: public; Owner: -
--

