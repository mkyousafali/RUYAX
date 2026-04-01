CREATE TABLE public.user_theme_assignments (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    theme_id integer NOT NULL,
    assigned_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: user_theme_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

