CREATE TABLE public.nationalities (
    id character varying(10) NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ar character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: near_expiry_reports; Type: TABLE; Schema: public; Owner: -
--

