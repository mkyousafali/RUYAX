CREATE TABLE public.expense_sub_categories (
    id bigint NOT NULL,
    parent_category_id bigint NOT NULL,
    name_en text NOT NULL,
    name_ar text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true
);


--
-- Name: TABLE expense_sub_categories; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.expense_sub_categories IS 'Sub expense categories linked to parent categories with bilingual support';


--
-- Name: expense_sub_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

