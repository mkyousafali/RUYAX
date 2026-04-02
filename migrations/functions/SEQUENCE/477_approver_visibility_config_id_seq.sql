CREATE SEQUENCE public.approver_visibility_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approver_visibility_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approver_visibility_config_id_seq OWNED BY public.approver_visibility_config.id;


--
-- Name: asset_main_categories; Type: TABLE; Schema: public; Owner: -
--

