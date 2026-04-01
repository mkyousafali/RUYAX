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
-- Name: flyer_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flyer_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    first_page_image_url text NOT NULL,
    sub_page_image_urls text[] DEFAULT '{}'::text[] NOT NULL,
    first_page_configuration jsonb DEFAULT '[]'::jsonb NOT NULL,
    sub_page_configurations jsonb DEFAULT '[]'::jsonb NOT NULL,
    metadata jsonb DEFAULT '{"sub_page_width": 794, "sub_page_height": 1123, "first_page_width": 794, "first_page_height": 1123}'::jsonb,
    is_active boolean DEFAULT true,
    is_default boolean DEFAULT false,
    category character varying(100),
    tags text[] DEFAULT '{}'::text[],
    usage_count integer DEFAULT 0,
    last_used_at timestamp with time zone,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    CONSTRAINT flyer_templates_sub_page_images_match_configs CHECK (((array_length(sub_page_image_urls, 1) = jsonb_array_length(sub_page_configurations)) OR ((sub_page_image_urls = '{}'::text[]) AND (sub_page_configurations = '[]'::jsonb))))
);


--
-- Name: TABLE flyer_templates; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.flyer_templates IS 'Stores flyer template designs with product field configurations';


--
-- Name: COLUMN flyer_templates.first_page_image_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_templates.first_page_image_url IS 'Storage URL for the first page template image';


--
-- Name: COLUMN flyer_templates.sub_page_image_urls; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_templates.sub_page_image_urls IS 'Array of storage URLs for unlimited sub-page template images';


--
-- Name: COLUMN flyer_templates.first_page_configuration; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_templates.first_page_configuration IS 'JSONB array of product field configurations for first page';


--
-- Name: COLUMN flyer_templates.sub_page_configurations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_templates.sub_page_configurations IS 'JSONB 2D array - each element contains field configurations for a sub-page';


--
-- Name: COLUMN flyer_templates.metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_templates.metadata IS 'Template dimensions and additional metadata';


--
-- Name: flyer_templates flyer_templates_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_name_unique UNIQUE (name);


--
-- Name: flyer_templates flyer_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_pkey PRIMARY KEY (id);


--
-- Name: idx_flyer_templates_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_templates_category ON public.flyer_templates USING btree (category) WHERE (deleted_at IS NULL);


--
-- Name: idx_flyer_templates_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_templates_created_at ON public.flyer_templates USING btree (created_at DESC);


--
-- Name: idx_flyer_templates_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_templates_created_by ON public.flyer_templates USING btree (created_by);


--
-- Name: idx_flyer_templates_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_templates_is_active ON public.flyer_templates USING btree (is_active) WHERE (deleted_at IS NULL);


--
-- Name: idx_flyer_templates_is_default; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_templates_is_default ON public.flyer_templates USING btree (is_default) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: idx_flyer_templates_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_templates_tags ON public.flyer_templates USING gin (tags);


--
-- Name: flyer_templates trigger_ensure_single_default_flyer_template; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_ensure_single_default_flyer_template BEFORE INSERT OR UPDATE OF is_default ON public.flyer_templates FOR EACH ROW WHEN ((new.is_default = true)) EXECUTE FUNCTION public.ensure_single_default_flyer_template();


--
-- Name: flyer_templates trigger_update_flyer_templates_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_flyer_templates_updated_at BEFORE UPDATE ON public.flyer_templates FOR EACH ROW EXECUTE FUNCTION public.update_flyer_templates_updated_at();


--
-- Name: flyer_templates flyer_templates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: flyer_templates flyer_templates_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: flyer_templates Allow anon insert flyer_templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert flyer_templates" ON public.flyer_templates FOR INSERT TO anon WITH CHECK (true);


--
-- Name: flyer_templates Users can view active flyer templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view active flyer templates" ON public.flyer_templates FOR SELECT TO authenticated USING (((is_active = true) AND (deleted_at IS NULL)));


--
-- Name: flyer_templates allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.flyer_templates USING (true) WITH CHECK (true);


--
-- Name: flyer_templates allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.flyer_templates FOR DELETE USING (true);


--
-- Name: flyer_templates allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.flyer_templates FOR INSERT WITH CHECK (true);


--
-- Name: flyer_templates allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.flyer_templates FOR SELECT USING (true);


--
-- Name: flyer_templates allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.flyer_templates FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: flyer_templates anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.flyer_templates USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: flyer_templates authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.flyer_templates USING ((auth.uid() IS NOT NULL));


--
-- Name: flyer_templates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.flyer_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE flyer_templates; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.flyer_templates TO anon;
GRANT SELECT ON TABLE public.flyer_templates TO authenticated;
GRANT ALL ON TABLE public.flyer_templates TO service_role;
GRANT SELECT ON TABLE public.flyer_templates TO replication_user;


--
-- PostgreSQL database dump complete
--

