CREATE TABLE public.ai_chat_guide (
    id integer NOT NULL,
    guide_text text DEFAULT ''::text NOT NULL,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: ai_chat_guide_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

