CREATE SEQUENCE public.expense_sub_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expense_sub_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.expense_sub_categories_id_seq OWNED BY public.expense_sub_categories.id;


--
-- Name: flyer_offer_products; Type: TABLE; Schema: public; Owner: -
--

