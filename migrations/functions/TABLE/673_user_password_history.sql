CREATE TABLE public.user_password_history (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    password_hash character varying(255) NOT NULL,
    salt character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: user_permissions_view; Type: VIEW; Schema: public; Owner: -
--

