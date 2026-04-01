CREATE SEQUENCE public.ai_chat_guide_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ai_chat_guide_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ai_chat_guide_id_seq OWNED BY public.ai_chat_guide.id;


--
-- Name: app_icons; Type: TABLE; Schema: public; Owner: -
--

