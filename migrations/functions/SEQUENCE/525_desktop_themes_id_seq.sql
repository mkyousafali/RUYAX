CREATE SEQUENCE public.desktop_themes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: desktop_themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.desktop_themes_id_seq OWNED BY public.desktop_themes.id;


--
-- Name: edge_functions_cache; Type: TABLE; Schema: public; Owner: -
--

