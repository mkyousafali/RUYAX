CREATE TABLE public.expense_parent_categories (
    id bigint NOT NULL,
    name_en text NOT NULL,
    name_ar text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true
);


--
-- Name: TABLE expense_parent_categories; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.expense_parent_categories IS 'Parent expense categories with bilingual support (English and Arabic)';


--
-- Name: expense_parent_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

