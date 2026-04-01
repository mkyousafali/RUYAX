CREATE TABLE public.customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    access_code text,
    whatsapp_number character varying(20),
    registration_status text DEFAULT 'pending'::text NOT NULL,
    registration_notes text,
    approved_by uuid,
    approved_at timestamp with time zone,
    access_code_generated_at timestamp with time zone,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name text,
    location1_name text,
    location1_url text,
    location2_name text,
    location2_url text,
    location3_name text,
    location3_url text,
    location1_lat double precision,
    location1_lng double precision,
    location2_lat double precision,
    location2_lng double precision,
    location3_lat double precision,
    location3_lng double precision,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    whatsapp_available boolean,
    erp_branch_id integer,
    CONSTRAINT customers_location1_name_len CHECK (((location1_name IS NULL) OR (length(location1_name) <= 120))),
    CONSTRAINT customers_location1_url_len CHECK (((location1_url IS NULL) OR (length(location1_url) <= 2048))),
    CONSTRAINT customers_location2_name_len CHECK (((location2_name IS NULL) OR (length(location2_name) <= 120))),
    CONSTRAINT customers_location2_url_len CHECK (((location2_url IS NULL) OR (length(location2_url) <= 2048))),
    CONSTRAINT customers_location3_name_len CHECK (((location3_name IS NULL) OR (length(location3_name) <= 120))),
    CONSTRAINT customers_location3_url_len CHECK (((location3_url IS NULL) OR (length(location3_url) <= 2048))),
    CONSTRAINT customers_registration_status_check CHECK ((registration_status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text, 'suspended'::text, 'pre_registered'::text, 'deleted'::text]))),
    CONSTRAINT customers_whatsapp_format_check CHECK (((whatsapp_number)::text ~ '^\+?[1-9]\d{1,14}$'::text))
);


--
-- Name: TABLE customers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.customers IS 'Customer information and access codes for customer login system';


--
-- Name: COLUMN customers.access_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.access_code IS 'Unique 6-digit access code for customer login';


--
-- Name: COLUMN customers.whatsapp_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.whatsapp_number IS 'Customer WhatsApp number for notifications';


--
-- Name: COLUMN customers.registration_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.registration_status IS 'Customer registration approval status';


--
-- Name: COLUMN customers.is_deleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.is_deleted IS 'Soft delete flag - set to true when customer deletes their account';


--
-- Name: COLUMN customers.deleted_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.deleted_at IS 'Timestamp when customer deleted their account';


--
-- Name: COLUMN customers.erp_branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.erp_branch_id IS 'ERP branch ID for queries';


--
-- Name: day_off; Type: TABLE; Schema: public; Owner: -
--

