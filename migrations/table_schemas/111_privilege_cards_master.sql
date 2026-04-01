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
-- Name: privilege_cards_master; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.privilege_cards_master (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    card_number character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: privilege_cards_master privilege_cards_master_card_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.privilege_cards_master
    ADD CONSTRAINT privilege_cards_master_card_number_key UNIQUE (card_number);


--
-- Name: privilege_cards_master privilege_cards_master_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.privilege_cards_master
    ADD CONSTRAINT privilege_cards_master_pkey PRIMARY KEY (id);


--
-- Name: idx_privilege_cards_master_card_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_privilege_cards_master_card_number ON public.privilege_cards_master USING btree (card_number);


--
-- Name: privilege_cards_master Allow anon insert privilege_cards_master; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert privilege_cards_master" ON public.privilege_cards_master FOR INSERT TO anon WITH CHECK (true);


--
-- Name: privilege_cards_master Allow authenticated users to create privilege_cards_master; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to create privilege_cards_master" ON public.privilege_cards_master FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: privilege_cards_master Allow authenticated users to read privilege_cards_master; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to read privilege_cards_master" ON public.privilege_cards_master FOR SELECT TO authenticated USING (true);


--
-- Name: privilege_cards_master Allow authenticated users to update privilege_cards_master; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to update privilege_cards_master" ON public.privilege_cards_master FOR UPDATE TO authenticated USING (true);


--
-- Name: privilege_cards_master Service role has full access to privilege_cards_master; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role has full access to privilege_cards_master" ON public.privilege_cards_master TO service_role USING (true);


--
-- Name: privilege_cards_master allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.privilege_cards_master USING (true);


--
-- Name: privilege_cards_master allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.privilege_cards_master FOR DELETE USING (true);


--
-- Name: privilege_cards_master allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.privilege_cards_master FOR INSERT WITH CHECK (true);


--
-- Name: privilege_cards_master allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.privilege_cards_master FOR SELECT USING (true);


--
-- Name: privilege_cards_master allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.privilege_cards_master FOR UPDATE USING (true);


--
-- Name: privilege_cards_master anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.privilege_cards_master USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: privilege_cards_master authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.privilege_cards_master USING ((auth.uid() IS NOT NULL));


--
-- Name: privilege_cards_master; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.privilege_cards_master ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE privilege_cards_master; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT ON TABLE public.privilege_cards_master TO anon;
GRANT SELECT ON TABLE public.privilege_cards_master TO authenticated;
GRANT ALL ON TABLE public.privilege_cards_master TO service_role;
GRANT SELECT ON TABLE public.privilege_cards_master TO replication_user;


--
-- PostgreSQL database dump complete
--

