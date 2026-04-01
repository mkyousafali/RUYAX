CREATE SEQUENCE public.approver_branch_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approver_branch_access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approver_branch_access_id_seq OWNED BY public.approver_branch_access.id;


--
-- Name: approver_visibility_config; Type: TABLE; Schema: public; Owner: -
--

