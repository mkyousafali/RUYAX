--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: wa_ai_bot_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wa_ai_bot_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    is_enabled boolean DEFAULT false,
    tone character varying(20) DEFAULT 'friendly'::character varying,
    default_language character varying(10) DEFAULT 'auto'::character varying,
    max_replies_per_conversation integer DEFAULT 10,
    handoff_keywords text[] DEFAULT '{}'::text[],
    training_data jsonb DEFAULT '[]'::jsonb,
    custom_instructions text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    token_limit integer DEFAULT 500000,
    tokens_used integer DEFAULT 0,
    prompt_tokens_used integer DEFAULT 0,
    completion_tokens_used integer DEFAULT 0,
    total_requests integer DEFAULT 0,
    training_qa jsonb DEFAULT '[]'::jsonb,
    bot_rules text DEFAULT ''::text,
    human_support_enabled boolean DEFAULT false,
    human_support_start_time time without time zone DEFAULT '12:00:00'::time without time zone,
    human_support_end_time time without time zone DEFAULT '20:00:00'::time without time zone
);


--
-- Name: wa_ai_bot_config wa_ai_bot_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_ai_bot_config
    ADD CONSTRAINT wa_ai_bot_config_pkey PRIMARY KEY (id);


--
-- Name: wa_ai_bot_config Service role full access on wa_ai_bot_config; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on wa_ai_bot_config" ON public.wa_ai_bot_config USING (true) WITH CHECK (true);


--
-- Name: wa_ai_bot_config; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wa_ai_bot_config ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE wa_ai_bot_config; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.wa_ai_bot_config TO anon;
GRANT ALL ON TABLE public.wa_ai_bot_config TO authenticated;
GRANT ALL ON TABLE public.wa_ai_bot_config TO service_role;
GRANT SELECT ON TABLE public.wa_ai_bot_config TO replication_user;


--
-- PostgreSQL database dump complete
--

