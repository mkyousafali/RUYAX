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
-- Name: social_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.social_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id bigint NOT NULL,
    facebook text,
    whatsapp text,
    instagram text,
    tiktok text,
    snapchat text,
    website text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    location_link text,
    facebook_clicks bigint DEFAULT 0,
    whatsapp_clicks bigint DEFAULT 0,
    instagram_clicks bigint DEFAULT 0,
    tiktok_clicks bigint DEFAULT 0,
    snapchat_clicks bigint DEFAULT 0,
    website_clicks bigint DEFAULT 0,
    location_link_clicks bigint DEFAULT 0
);


--
-- Name: social_links social_links_branch_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_links
    ADD CONSTRAINT social_links_branch_id_key UNIQUE (branch_id);


--
-- Name: social_links social_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_links
    ADD CONSTRAINT social_links_pkey PRIMARY KEY (id);


--
-- Name: idx_social_links_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_social_links_branch_id ON public.social_links USING btree (branch_id);


--
-- Name: social_links social_links_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER social_links_updated_at_trigger BEFORE UPDATE ON public.social_links FOR EACH ROW EXECUTE FUNCTION public.update_social_links_updated_at();


--
-- Name: social_links fk_social_links_branch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_links
    ADD CONSTRAINT fk_social_links_branch FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: social_links Enable all access for social_links; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable all access for social_links" ON public.social_links USING (true) WITH CHECK (true);


--
-- Name: social_links; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.social_links ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE social_links; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.social_links TO anon;
GRANT ALL ON TABLE public.social_links TO authenticated;
GRANT ALL ON TABLE public.social_links TO service_role;
GRANT SELECT ON TABLE public.social_links TO replication_user;


--
-- PostgreSQL database dump complete
--

