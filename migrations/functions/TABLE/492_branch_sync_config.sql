CREATE TABLE public.branch_sync_config (
    id bigint NOT NULL,
    branch_id bigint NOT NULL,
    local_supabase_url text NOT NULL,
    local_supabase_key text NOT NULL,
    is_active boolean DEFAULT true,
    last_sync_at timestamp with time zone,
    last_sync_status text,
    last_sync_details jsonb DEFAULT '{}'::jsonb,
    sync_tables text[] DEFAULT ARRAY['branches'::text, 'users'::text, 'user_sessions'::text, 'user_device_sessions'::text, 'button_permissions'::text, 'sidebar_buttons'::text, 'button_main_sections'::text, 'button_sub_sections'::text, 'interface_permissions'::text, 'user_favorite_buttons'::text, 'erp_synced_products'::text, 'product_categories'::text, 'products'::text, 'product_units'::text, 'offers'::text, 'offer_products'::text, 'offer_names'::text, 'offer_bundles'::text, 'offer_cart_tiers'::text, 'bogo_offer_rules'::text, 'flyer_offers'::text, 'flyer_offer_products'::text, 'customers'::text, 'privilege_cards_master'::text, 'privilege_cards_branch'::text, 'desktop_themes'::text, 'user_theme_assignments'::text, 'erp_connections'::text, 'erp_sync_logs'::text],
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    tunnel_url text,
    ssh_user text DEFAULT 'u'::text,
    CONSTRAINT branch_sync_config_last_sync_status_check CHECK ((last_sync_status = ANY (ARRAY['success'::text, 'failed'::text, 'in_progress'::text])))
);


--
-- Name: COLUMN branch_sync_config.tunnel_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branch_sync_config.tunnel_url IS 'Cloudflare Tunnel URL for the branch Supabase (used when local URL is unreachable)';


--
-- Name: branch_sync_config_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.branch_sync_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.branch_sync_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: branches; Type: TABLE; Schema: public; Owner: -
--

