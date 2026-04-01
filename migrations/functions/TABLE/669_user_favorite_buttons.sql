CREATE TABLE public.user_favorite_buttons (
    id text NOT NULL,
    employee_id text,
    user_id uuid NOT NULL,
    favorite_config jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: user_management_view; Type: VIEW; Schema: public; Owner: -
--

