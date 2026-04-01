CREATE SEQUENCE public.employee_checklist_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_checklist_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employee_checklist_assignments_id_seq OWNED BY public.employee_checklist_assignments.id;


--
-- Name: employee_fine_payments; Type: TABLE; Schema: public; Owner: -
--

