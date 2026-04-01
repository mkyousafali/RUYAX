CREATE SEQUENCE public.user_mobile_theme_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_mobile_theme_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_mobile_theme_assignments_id_seq OWNED BY public.user_mobile_theme_assignments.id;


--
-- Name: user_password_history; Type: TABLE; Schema: public; Owner: -
--

