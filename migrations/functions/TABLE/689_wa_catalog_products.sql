CREATE TABLE public.wa_catalog_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    catalog_id uuid NOT NULL,
    wa_account_id uuid NOT NULL,
    meta_product_id text,
    retailer_id text,
    name text NOT NULL,
    description text,
    price numeric(12,2) DEFAULT 0,
    currency text DEFAULT 'SAR'::text,
    sale_price numeric(12,2),
    image_url text,
    additional_images text[] DEFAULT '{}'::text[],
    url text,
    category text,
    availability text DEFAULT 'in stock'::text,
    condition text DEFAULT 'new'::text,
    brand text,
    sku text,
    quantity integer DEFAULT 0,
    is_hidden boolean DEFAULT false,
    status text DEFAULT 'active'::text,
    synced_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_catalogs; Type: TABLE; Schema: public; Owner: -
--

