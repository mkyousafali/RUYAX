CREATE TABLE public.default_incident_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    incident_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: deleted_bundle_offers; Type: TABLE; Schema: public; Owner: -
--

