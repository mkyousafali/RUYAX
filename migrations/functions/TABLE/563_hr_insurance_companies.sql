CREATE TABLE public.hr_insurance_companies (
    id character varying(15) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: hr_insurance_company_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

