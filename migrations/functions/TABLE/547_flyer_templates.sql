CREATE TABLE public.flyer_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    first_page_image_url text NOT NULL,
    sub_page_image_urls text[] DEFAULT '{}'::text[] NOT NULL,
    first_page_configuration jsonb DEFAULT '[]'::jsonb NOT NULL,
    sub_page_configurations jsonb DEFAULT '[]'::jsonb NOT NULL,
    metadata jsonb DEFAULT '{"sub_page_width": 794, "sub_page_height": 1123, "first_page_width": 794, "first_page_height": 1123}'::jsonb,
    is_active boolean DEFAULT true,
    is_default boolean DEFAULT false,
    category character varying(100),
    tags text[] DEFAULT '{}'::text[],
    usage_count integer DEFAULT 0,
    last_used_at timestamp with time zone,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    CONSTRAINT flyer_templates_sub_page_images_match_configs CHECK (((array_length(sub_page_image_urls, 1) = jsonb_array_length(sub_page_configurations)) OR ((sub_page_image_urls = '{}'::text[]) AND (sub_page_configurations = '[]'::jsonb))))
);


--
-- Name: TABLE flyer_templates; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.flyer_templates IS 'Stores flyer template designs with product field configurations';


--
-- Name: COLUMN flyer_templates.first_page_image_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_templates.first_page_image_url IS 'Storage URL for the first page template image';


--
-- Name: COLUMN flyer_templates.sub_page_image_urls; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_templates.sub_page_image_urls IS 'Array of storage URLs for unlimited sub-page template images';


--
-- Name: COLUMN flyer_templates.first_page_configuration; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_templates.first_page_configuration IS 'JSONB array of product field configurations for first page';


--
-- Name: COLUMN flyer_templates.sub_page_configurations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_templates.sub_page_configurations IS 'JSONB 2D array - each element contains field configurations for a sub-page';


--
-- Name: COLUMN flyer_templates.metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_templates.metadata IS 'Template dimensions and additional metadata';


--
-- Name: frontend_builds; Type: TABLE; Schema: public; Owner: -
--

