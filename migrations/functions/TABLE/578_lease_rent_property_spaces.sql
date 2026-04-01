CREATE TABLE public.lease_rent_property_spaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    space_number character varying(100) NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: lease_rent_rent_parties; Type: TABLE; Schema: public; Owner: -
--

