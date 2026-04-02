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
-- Name: wa_bot_flows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wa_bot_flows (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    name text NOT NULL,
    trigger_words_en text[] DEFAULT ARRAY[]::text[],
    trigger_words_ar text[] DEFAULT ARRAY[]::text[],
    match_type character varying(20) DEFAULT 'contains'::character varying,
    nodes jsonb DEFAULT '[]'::jsonb,
    edges jsonb DEFAULT '[]'::jsonb,
    is_active boolean DEFAULT true,
    priority integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_bot_flows wa_bot_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_bot_flows
    ADD CONSTRAINT wa_bot_flows_pkey PRIMARY KEY (id);


--
-- Name: idx_wa_bot_flows_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_bot_flows_account ON public.wa_bot_flows USING btree (wa_account_id);


--
-- Name: idx_wa_bot_flows_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_bot_flows_active ON public.wa_bot_flows USING btree (is_active);


--
-- Name: wa_bot_flows wa_bot_flows_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_bot_flows
    ADD CONSTRAINT wa_bot_flows_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_bot_flows allow_all_wa_bot_flows; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_wa_bot_flows ON public.wa_bot_flows USING (true) WITH CHECK (true);


--
-- Name: wa_bot_flows; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wa_bot_flows ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE wa_bot_flows; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.wa_bot_flows TO anon;
GRANT ALL ON TABLE public.wa_bot_flows TO authenticated;
GRANT ALL ON TABLE public.wa_bot_flows TO service_role;
GRANT SELECT ON TABLE public.wa_bot_flows TO replication_user;


--
-- PostgreSQL database dump complete
--

