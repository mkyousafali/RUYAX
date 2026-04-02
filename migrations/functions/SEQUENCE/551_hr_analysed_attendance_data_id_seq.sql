CREATE SEQUENCE public.hr_analysed_attendance_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hr_analysed_attendance_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hr_analysed_attendance_data_id_seq OWNED BY public.hr_analysed_attendance_data.id;


--
-- Name: hr_basic_salary; Type: TABLE; Schema: public; Owner: -
--

