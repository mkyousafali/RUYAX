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
-- Name: wa_contact_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wa_contact_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    customer_count integer DEFAULT 0,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_contact_groups wa_contact_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_contact_groups
    ADD CONSTRAINT wa_contact_groups_pkey PRIMARY KEY (id);


--
-- Name: wa_contact_groups Service role full access on wa_contact_groups; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on wa_contact_groups" ON public.wa_contact_groups USING (true) WITH CHECK (true);


--
-- Name: wa_contact_groups; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wa_contact_groups ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE wa_contact_groups; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.wa_contact_groups TO anon;
GRANT ALL ON TABLE public.wa_contact_groups TO authenticated;
GRANT ALL ON TABLE public.wa_contact_groups TO service_role;
GRANT SELECT ON TABLE public.wa_contact_groups TO replication_user;


--
-- PostgreSQL database dump complete
--

