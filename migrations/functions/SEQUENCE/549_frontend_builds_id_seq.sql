CREATE SEQUENCE public.frontend_builds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: frontend_builds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.frontend_builds_id_seq OWNED BY public.frontend_builds.id;


--
-- Name: hr_analysed_attendance_data; Type: TABLE; Schema: public; Owner: -
--

