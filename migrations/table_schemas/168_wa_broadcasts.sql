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
-- Name: wa_broadcasts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wa_broadcasts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    name text,
    template_id uuid,
    recipient_filter character varying(20) DEFAULT 'all'::character varying,
    recipient_group_id uuid,
    total_recipients integer DEFAULT 0,
    sent_count integer DEFAULT 0,
    delivered_count integer DEFAULT 0,
    read_count integer DEFAULT 0,
    failed_count integer DEFAULT 0,
    status character varying(20) DEFAULT 'draft'::character varying,
    scheduled_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY public.wa_broadcasts REPLICA IDENTITY FULL;


--
-- Name: wa_broadcasts wa_broadcasts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_pkey PRIMARY KEY (id);


--
-- Name: idx_wa_broadcasts_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_broadcasts_account ON public.wa_broadcasts USING btree (wa_account_id);


--
-- Name: idx_wa_broadcasts_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_broadcasts_created ON public.wa_broadcasts USING btree (created_at DESC);


--
-- Name: idx_wa_broadcasts_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_broadcasts_status ON public.wa_broadcasts USING btree (status);


--
-- Name: wa_broadcasts wa_broadcasts_recipient_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_recipient_group_id_fkey FOREIGN KEY (recipient_group_id) REFERENCES public.wa_contact_groups(id) ON DELETE SET NULL;


--
-- Name: wa_broadcasts wa_broadcasts_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.wa_templates(id) ON DELETE SET NULL;


--
-- Name: wa_broadcasts wa_broadcasts_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_broadcasts Allow all access to wa_broadcasts; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to wa_broadcasts" ON public.wa_broadcasts USING (true) WITH CHECK (true);


--
-- Name: wa_broadcasts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wa_broadcasts ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE wa_broadcasts; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.wa_broadcasts TO anon;
GRANT ALL ON TABLE public.wa_broadcasts TO authenticated;
GRANT ALL ON TABLE public.wa_broadcasts TO service_role;
GRANT SELECT ON TABLE public.wa_broadcasts TO replication_user;


--
-- PostgreSQL database dump complete
--

