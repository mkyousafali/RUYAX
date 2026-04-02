CREATE TABLE public.break_security_seed (
    id integer DEFAULT 1 NOT NULL,
    seed text DEFAULT encode(extensions.gen_random_bytes(32), 'hex'::text) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT break_security_seed_id_check CHECK ((id = 1))
);


--
-- Name: button_main_sections; Type: TABLE; Schema: public; Owner: -
--

