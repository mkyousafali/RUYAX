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
-- Name: shelf_paper_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shelf_paper_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    template_image_url text NOT NULL,
    field_configuration jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb
);


--
-- Name: TABLE shelf_paper_templates; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.shelf_paper_templates IS 'Stores shelf paper template designs with field configurations';


--
-- Name: COLUMN shelf_paper_templates.metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shelf_paper_templates.metadata IS 'Stores template metadata like preview dimensions used for field positioning';


--
-- Name: shelf_paper_templates shelf_paper_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shelf_paper_templates
    ADD CONSTRAINT shelf_paper_templates_pkey PRIMARY KEY (id);


--
-- Name: idx_shelf_paper_templates_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shelf_paper_templates_created_at ON public.shelf_paper_templates USING btree (created_at DESC);


--
-- Name: idx_shelf_paper_templates_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shelf_paper_templates_created_by ON public.shelf_paper_templates USING btree (created_by);


--
-- Name: idx_shelf_paper_templates_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shelf_paper_templates_is_active ON public.shelf_paper_templates USING btree (is_active);


--
-- Name: shelf_paper_templates update_shelf_paper_templates_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_shelf_paper_templates_updated_at BEFORE UPDATE ON public.shelf_paper_templates FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: shelf_paper_templates shelf_paper_templates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shelf_paper_templates
    ADD CONSTRAINT shelf_paper_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: shelf_paper_templates Allow anon insert shelf_paper_templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert shelf_paper_templates" ON public.shelf_paper_templates FOR INSERT TO anon WITH CHECK (true);


--
-- Name: shelf_paper_templates Users can create templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create templates" ON public.shelf_paper_templates FOR INSERT WITH CHECK ((auth.uid() IS NOT NULL));


--
-- Name: shelf_paper_templates Users can delete own templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete own templates" ON public.shelf_paper_templates FOR DELETE USING ((created_by = auth.uid()));


--
-- Name: shelf_paper_templates Users can update own templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update own templates" ON public.shelf_paper_templates FOR UPDATE USING ((created_by = auth.uid()));


--
-- Name: shelf_paper_templates Users can view active templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view active templates" ON public.shelf_paper_templates FOR SELECT USING ((is_active = true));


--
-- Name: shelf_paper_templates allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.shelf_paper_templates USING (true) WITH CHECK (true);


--
-- Name: shelf_paper_templates allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.shelf_paper_templates FOR DELETE USING (true);


--
-- Name: shelf_paper_templates allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.shelf_paper_templates FOR INSERT WITH CHECK (true);


--
-- Name: shelf_paper_templates allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.shelf_paper_templates FOR SELECT USING (true);


--
-- Name: shelf_paper_templates allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.shelf_paper_templates FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: shelf_paper_templates anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.shelf_paper_templates USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: shelf_paper_templates authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.shelf_paper_templates USING ((auth.uid() IS NOT NULL));


--
-- Name: shelf_paper_templates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shelf_paper_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE shelf_paper_templates; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.shelf_paper_templates TO anon;
GRANT SELECT ON TABLE public.shelf_paper_templates TO authenticated;
GRANT ALL ON TABLE public.shelf_paper_templates TO service_role;
GRANT SELECT ON TABLE public.shelf_paper_templates TO replication_user;


--
-- PostgreSQL database dump complete
--

