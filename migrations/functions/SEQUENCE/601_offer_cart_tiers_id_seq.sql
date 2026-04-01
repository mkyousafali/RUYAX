CREATE SEQUENCE public.offer_cart_tiers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offer_cart_tiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offer_cart_tiers_id_seq OWNED BY public.offer_cart_tiers.id;


--
-- Name: offer_names; Type: TABLE; Schema: public; Owner: -
--

