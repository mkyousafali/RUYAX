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
-- Name: app_icons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_icons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    icon_key text NOT NULL,
    category text DEFAULT 'general'::text NOT NULL,
    storage_path text NOT NULL,
    mime_type text,
    file_size bigint DEFAULT 0,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: TABLE app_icons; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.app_icons IS 'Stores metadata for all application icons managed dynamically';


--
-- Name: COLUMN app_icons.icon_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_icons.icon_key IS 'Unique key used in code to reference this icon (e.g. logo, saudi-currency)';


--
-- Name: COLUMN app_icons.category; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_icons.category IS 'Category: logo, currency, social, pwa, misc';


--
-- Name: COLUMN app_icons.storage_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_icons.storage_path IS 'Path within the app-icons storage bucket';


--
-- Name: app_icons app_icons_icon_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_icons
    ADD CONSTRAINT app_icons_icon_key_key UNIQUE (icon_key);


--
-- Name: app_icons app_icons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_icons
    ADD CONSTRAINT app_icons_pkey PRIMARY KEY (id);


--
-- Name: idx_app_icons_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_app_icons_category ON public.app_icons USING btree (category);


--
-- Name: idx_app_icons_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_app_icons_key ON public.app_icons USING btree (icon_key);


--
-- Name: app_icons trg_app_icons_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_app_icons_updated_at BEFORE UPDATE ON public.app_icons FOR EACH ROW EXECUTE FUNCTION public.update_app_icons_updated_at();


--
-- Name: app_icons app_icons_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_icons
    ADD CONSTRAINT app_icons_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: app_icons Anyone can view app icons; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anyone can view app icons" ON public.app_icons FOR SELECT USING (true);


--
-- Name: app_icons Authenticated users can delete app icons; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can delete app icons" ON public.app_icons FOR DELETE TO authenticated USING (true);


--
-- Name: app_icons Authenticated users can insert app icons; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can insert app icons" ON public.app_icons FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: app_icons Authenticated users can update app icons; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can update app icons" ON public.app_icons FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: app_icons; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.app_icons ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE app_icons; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT ON TABLE public.app_icons TO anon;
GRANT SELECT ON TABLE public.app_icons TO authenticated;
GRANT ALL ON TABLE public.app_icons TO service_role;
GRANT SELECT ON TABLE public.app_icons TO replication_user;


--
-- PostgreSQL database dump complete
--

