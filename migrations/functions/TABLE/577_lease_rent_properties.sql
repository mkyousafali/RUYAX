CREATE TABLE public.lease_rent_properties (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    location_en character varying(500),
    location_ar character varying(500),
    is_leased boolean DEFAULT false,
    is_rented boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: lease_rent_property_spaces; Type: TABLE; Schema: public; Owner: -
--

