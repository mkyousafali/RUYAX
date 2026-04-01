CREATE SEQUENCE public.denomination_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: denomination_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.denomination_types_id_seq OWNED BY public.denomination_types.id;


--
-- Name: denomination_user_preferences; Type: TABLE; Schema: public; Owner: -
--

