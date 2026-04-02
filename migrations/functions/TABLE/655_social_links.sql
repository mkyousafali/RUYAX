CREATE TABLE public.social_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id bigint NOT NULL,
    facebook text,
    whatsapp text,
    instagram text,
    tiktok text,
    snapchat text,
    website text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    location_link text,
    facebook_clicks bigint DEFAULT 0,
    whatsapp_clicks bigint DEFAULT 0,
    instagram_clicks bigint DEFAULT 0,
    tiktok_clicks bigint DEFAULT 0,
    snapchat_clicks bigint DEFAULT 0,
    website_clicks bigint DEFAULT 0,
    location_link_clicks bigint DEFAULT 0
);


--
-- Name: special_shift_date_wise; Type: TABLE; Schema: public; Owner: -
--

