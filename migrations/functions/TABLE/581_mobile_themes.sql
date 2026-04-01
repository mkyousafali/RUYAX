CREATE TABLE public.mobile_themes (
    id bigint NOT NULL,
    name text NOT NULL,
    description text,
    is_default boolean DEFAULT false,
    colors jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid
);


--
-- Name: mobile_themes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

