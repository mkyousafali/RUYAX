CREATE SEQUENCE public.multi_shift_weekday_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: multi_shift_weekday_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.multi_shift_weekday_id_seq OWNED BY public.multi_shift_weekday.id;


--
-- Name: mv_expiry_products; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

