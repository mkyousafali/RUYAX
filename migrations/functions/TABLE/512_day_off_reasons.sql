CREATE TABLE public.day_off_reasons (
    id character varying(50) NOT NULL,
    reason_en character varying(255) NOT NULL,
    reason_ar character varying(255) NOT NULL,
    is_deductible boolean DEFAULT false,
    is_document_mandatory boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: day_off_weekday; Type: TABLE; Schema: public; Owner: -
--

