CREATE SEQUENCE public.user_theme_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_theme_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_theme_assignments_id_seq OWNED BY public.user_theme_assignments.id;


--
-- Name: user_voice_preferences; Type: TABLE; Schema: public; Owner: -
--

