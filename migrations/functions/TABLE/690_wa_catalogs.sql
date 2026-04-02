CREATE TABLE public.wa_catalogs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid NOT NULL,
    meta_catalog_id text,
    name text NOT NULL,
    description text,
    status text DEFAULT 'active'::text,
    product_count integer DEFAULT 0,
    synced_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_contact_group_members; Type: TABLE; Schema: public; Owner: -
--

