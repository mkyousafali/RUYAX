CREATE TABLE public.wa_catalog_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid NOT NULL,
    catalog_id uuid,
    customer_phone text NOT NULL,
    customer_name text,
    order_status text DEFAULT 'pending'::text,
    items jsonb DEFAULT '[]'::jsonb,
    subtotal numeric(12,2) DEFAULT 0,
    tax numeric(12,2) DEFAULT 0,
    shipping numeric(12,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0,
    currency text DEFAULT 'SAR'::text,
    notes text,
    meta_order_id text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_catalog_products; Type: TABLE; Schema: public; Owner: -
--

