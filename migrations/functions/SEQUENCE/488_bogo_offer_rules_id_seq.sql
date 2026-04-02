CREATE SEQUENCE public.bogo_offer_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bogo_offer_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bogo_offer_rules_id_seq OWNED BY public.bogo_offer_rules.id;


--
-- Name: box_operations; Type: TABLE; Schema: public; Owner: -
--

