CREATE SEQUENCE public.non_approved_payment_scheduler_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: non_approved_payment_scheduler_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.non_approved_payment_scheduler_id_seq OWNED BY public.non_approved_payment_scheduler.id;


--
-- Name: notification_attachments; Type: TABLE; Schema: public; Owner: -
--

