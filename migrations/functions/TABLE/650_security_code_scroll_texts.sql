CREATE TABLE public.security_code_scroll_texts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    text_content text NOT NULL,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: shelf_paper_fonts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

