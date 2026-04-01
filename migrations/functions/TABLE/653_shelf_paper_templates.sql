CREATE TABLE public.shelf_paper_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    template_image_url text NOT NULL,
    field_configuration jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb
);


--
-- Name: TABLE shelf_paper_templates; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.shelf_paper_templates IS 'Stores shelf paper template designs with field configurations';


--
-- Name: COLUMN shelf_paper_templates.metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shelf_paper_templates.metadata IS 'Stores template metadata like preview dimensions used for field positioning';


--
-- Name: sidebar_buttons; Type: TABLE; Schema: public; Owner: -
--

