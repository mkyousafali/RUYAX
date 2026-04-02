CREATE SEQUENCE public.approval_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_permissions_id_seq OWNED BY public.approval_permissions.id;


--
-- Name: approver_branch_access; Type: TABLE; Schema: public; Owner: -
--

