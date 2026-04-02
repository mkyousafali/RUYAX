CREATE SEQUENCE public.asset_sub_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: asset_sub_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.asset_sub_categories_id_seq OWNED BY public.asset_sub_categories.id;


--
-- Name: assets; Type: TABLE; Schema: public; Owner: -
--

