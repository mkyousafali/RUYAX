CREATE TABLE public.user_mobile_theme_assignments (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    theme_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    color_overrides jsonb
);


--
-- Name: COLUMN user_mobile_theme_assignments.color_overrides; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_mobile_theme_assignments.color_overrides IS 'User-specific color overrides. Merge with theme colors at runtime. Stores only properties that differ from base theme.';


--
-- Name: user_mobile_theme_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

