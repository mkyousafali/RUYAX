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
-- Name: privilege_cards_branch; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.privilege_cards_branch (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    privilege_card_id integer NOT NULL,
    card_number character varying(50) NOT NULL,
    branch_id integer NOT NULL,
    card_balance numeric(10,4) DEFAULT 0,
    card_holder_name character varying(255),
    total_redemptions numeric(10,4) DEFAULT 0,
    redemption_count integer DEFAULT 0,
    expiry_date date,
    mobile character varying(20),
    last_sync_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: privilege_cards_branch privilege_cards_branch_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.privilege_cards_branch
    ADD CONSTRAINT privilege_cards_branch_pkey PRIMARY KEY (id);


--
-- Name: privilege_cards_branch privilege_cards_branch_privilege_card_id_branch_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.privilege_cards_branch
    ADD CONSTRAINT privilege_cards_branch_privilege_card_id_branch_id_key UNIQUE (privilege_card_id, branch_id);


--
-- Name: idx_privilege_cards_branch_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_privilege_cards_branch_branch_id ON public.privilege_cards_branch USING btree (branch_id);


--
-- Name: idx_privilege_cards_branch_card_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_privilege_cards_branch_card_number ON public.privilege_cards_branch USING btree (card_number);


--
-- Name: idx_privilege_cards_branch_composite; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_privilege_cards_branch_composite ON public.privilege_cards_branch USING btree (branch_id, card_number);


--
-- Name: privilege_cards_branch Allow anon insert privilege_cards_branch; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert privilege_cards_branch" ON public.privilege_cards_branch FOR INSERT TO anon WITH CHECK (true);


--
-- Name: privilege_cards_branch Allow authenticated users to create privilege_cards_branch; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to create privilege_cards_branch" ON public.privilege_cards_branch FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: privilege_cards_branch Allow authenticated users to read privilege_cards_branch; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to read privilege_cards_branch" ON public.privilege_cards_branch FOR SELECT TO authenticated USING (true);


--
-- Name: privilege_cards_branch Allow authenticated users to update privilege_cards_branch; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to update privilege_cards_branch" ON public.privilege_cards_branch FOR UPDATE TO authenticated USING (true);


--
-- Name: privilege_cards_branch Service role has full access to privilege_cards_branch; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role has full access to privilege_cards_branch" ON public.privilege_cards_branch TO service_role USING (true);


--
-- Name: privilege_cards_branch allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.privilege_cards_branch USING (true);


--
-- Name: privilege_cards_branch allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.privilege_cards_branch FOR DELETE USING (true);


--
-- Name: privilege_cards_branch allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.privilege_cards_branch FOR INSERT WITH CHECK (true);


--
-- Name: privilege_cards_branch allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.privilege_cards_branch FOR SELECT USING (true);


--
-- Name: privilege_cards_branch allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.privilege_cards_branch FOR UPDATE USING (true);


--
-- Name: privilege_cards_branch anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.privilege_cards_branch USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: privilege_cards_branch authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.privilege_cards_branch USING ((auth.uid() IS NOT NULL));


--
-- Name: privilege_cards_branch; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.privilege_cards_branch ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE privilege_cards_branch; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT ON TABLE public.privilege_cards_branch TO anon;
GRANT SELECT ON TABLE public.privilege_cards_branch TO authenticated;
GRANT ALL ON TABLE public.privilege_cards_branch TO service_role;
GRANT SELECT ON TABLE public.privilege_cards_branch TO replication_user;


--
-- PostgreSQL database dump complete
--

