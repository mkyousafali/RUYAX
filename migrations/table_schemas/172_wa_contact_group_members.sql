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
-- Name: wa_contact_group_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wa_contact_group_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    group_id uuid,
    customer_id uuid,
    added_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_contact_group_members wa_contact_group_members_group_id_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_group_id_customer_id_key UNIQUE (group_id, customer_id);


--
-- Name: wa_contact_group_members wa_contact_group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_pkey PRIMARY KEY (id);


--
-- Name: idx_wa_group_members_customer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_group_members_customer ON public.wa_contact_group_members USING btree (customer_id);


--
-- Name: idx_wa_group_members_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_group_members_group ON public.wa_contact_group_members USING btree (group_id);


--
-- Name: wa_contact_group_members wa_contact_group_members_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: wa_contact_group_members wa_contact_group_members_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.wa_contact_groups(id) ON DELETE CASCADE;


--
-- Name: wa_contact_group_members Service role full access on wa_contact_group_members; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on wa_contact_group_members" ON public.wa_contact_group_members USING (true) WITH CHECK (true);


--
-- Name: wa_contact_group_members; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wa_contact_group_members ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE wa_contact_group_members; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.wa_contact_group_members TO anon;
GRANT ALL ON TABLE public.wa_contact_group_members TO authenticated;
GRANT ALL ON TABLE public.wa_contact_group_members TO service_role;
GRANT SELECT ON TABLE public.wa_contact_group_members TO replication_user;


--
-- PostgreSQL database dump complete
--

