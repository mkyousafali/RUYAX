CREATE TABLE public.app_icons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    icon_key text NOT NULL,
    category text DEFAULT 'general'::text NOT NULL,
    storage_path text NOT NULL,
    mime_type text,
    file_size bigint DEFAULT 0,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: TABLE app_icons; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.app_icons IS 'Stores metadata for all application icons managed dynamically';


--
-- Name: COLUMN app_icons.icon_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_icons.icon_key IS 'Unique key used in code to reference this icon (e.g. logo, saudi-currency)';


--
-- Name: COLUMN app_icons.category; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_icons.category IS 'Category: logo, currency, social, pwa, misc';


--
-- Name: COLUMN app_icons.storage_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_icons.storage_path IS 'Path within the app-icons storage bucket';


--
-- Name: approval_permissions; Type: TABLE; Schema: public; Owner: -
--

