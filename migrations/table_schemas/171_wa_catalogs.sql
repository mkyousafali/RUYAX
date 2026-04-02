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
-- Name: wa_catalogs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wa_catalogs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid NOT NULL,
    meta_catalog_id text,
    name text NOT NULL,
    description text,
    status text DEFAULT 'active'::text,
    product_count integer DEFAULT 0,
    synced_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_catalogs wa_catalogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalogs
    ADD CONSTRAINT wa_catalogs_pkey PRIMARY KEY (id);


--
-- Name: idx_wa_catalogs_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_catalogs_account ON public.wa_catalogs USING btree (wa_account_id);


--
-- Name: wa_catalogs wa_catalogs_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalogs
    ADD CONSTRAINT wa_catalogs_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_catalogs Allow authenticated full access on wa_catalogs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated full access on wa_catalogs" ON public.wa_catalogs TO authenticated USING (true) WITH CHECK (true);


--
-- Name: wa_catalogs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wa_catalogs ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE wa_catalogs; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.wa_catalogs TO anon;
GRANT ALL ON TABLE public.wa_catalogs TO authenticated;
GRANT ALL ON TABLE public.wa_catalogs TO service_role;
GRANT SELECT ON TABLE public.wa_catalogs TO replication_user;


--
-- PostgreSQL database dump complete
--

