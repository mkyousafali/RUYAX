CREATE TABLE public.requesters (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_id character varying(50) NOT NULL,
    requester_name character varying(255) NOT NULL,
    contact_number character varying(20),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    created_by uuid,
    updated_by uuid
);


--
-- Name: TABLE requesters; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.requesters IS 'Table to store requester information for expense requisitions';


--
-- Name: COLUMN requesters.requester_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.requesters.requester_id IS 'Unique identifier for the requester (employee ID or custom ID)';


--
-- Name: COLUMN requesters.requester_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.requesters.requester_name IS 'Full name of the requester';


--
-- Name: COLUMN requesters.contact_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.requesters.contact_number IS 'Contact number of the requester';


--
-- Name: security_code_scroll_texts; Type: TABLE; Schema: public; Owner: -
--

