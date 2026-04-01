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
-- Name: variation_audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.variation_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    action_type text NOT NULL,
    variation_group_id uuid,
    affected_barcodes text[],
    parent_barcode text,
    group_name_en text,
    group_name_ar text,
    user_id uuid,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    details jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT variation_audit_log_action_type_check CHECK ((action_type = ANY (ARRAY['create_group'::text, 'edit_group'::text, 'delete_group'::text, 'add_variation'::text, 'remove_variation'::text, 'reorder_variations'::text, 'change_parent'::text, 'update_image_override'::text])))
);


--
-- Name: TABLE variation_audit_log; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.variation_audit_log IS 'Audit trail for all variation group operations';


--
-- Name: COLUMN variation_audit_log.action_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.action_type IS 'Type of action performed on variation group';


--
-- Name: COLUMN variation_audit_log.variation_group_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.variation_group_id IS 'UUID of the variation group affected';


--
-- Name: COLUMN variation_audit_log.affected_barcodes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.affected_barcodes IS 'Array of product barcodes affected by this action';


--
-- Name: COLUMN variation_audit_log.parent_barcode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.parent_barcode IS 'Parent product barcode for reference';


--
-- Name: COLUMN variation_audit_log.group_name_en; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.group_name_en IS 'English name of the group at time of action';


--
-- Name: COLUMN variation_audit_log.group_name_ar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.group_name_ar IS 'Arabic name of the group at time of action';


--
-- Name: COLUMN variation_audit_log.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.user_id IS 'User who performed the action';


--
-- Name: COLUMN variation_audit_log.details; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.details IS 'Additional details stored as JSON (before/after state, etc.)';


--
-- Name: variation_audit_log variation_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variation_audit_log
    ADD CONSTRAINT variation_audit_log_pkey PRIMARY KEY (id);


--
-- Name: idx_variation_audit_log_action_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_variation_audit_log_action_type ON public.variation_audit_log USING btree (action_type);


--
-- Name: idx_variation_audit_log_parent_barcode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_variation_audit_log_parent_barcode ON public.variation_audit_log USING btree (parent_barcode) WHERE (parent_barcode IS NOT NULL);


--
-- Name: idx_variation_audit_log_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_variation_audit_log_timestamp ON public.variation_audit_log USING btree ("timestamp" DESC);


--
-- Name: idx_variation_audit_log_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_variation_audit_log_user_id ON public.variation_audit_log USING btree (user_id);


--
-- Name: idx_variation_audit_log_variation_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_variation_audit_log_variation_group_id ON public.variation_audit_log USING btree (variation_group_id) WHERE (variation_group_id IS NOT NULL);


--
-- Name: variation_audit_log variation_audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variation_audit_log
    ADD CONSTRAINT variation_audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: variation_audit_log Allow anon insert variation_audit_log; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert variation_audit_log" ON public.variation_audit_log FOR INSERT TO anon WITH CHECK (true);


--
-- Name: variation_audit_log System can insert variation audit logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "System can insert variation audit logs" ON public.variation_audit_log FOR INSERT WITH CHECK (true);


--
-- Name: variation_audit_log Users can view variation audit logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view variation audit logs" ON public.variation_audit_log FOR SELECT USING (true);


--
-- Name: variation_audit_log allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.variation_audit_log USING (true) WITH CHECK (true);


--
-- Name: variation_audit_log allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.variation_audit_log FOR DELETE USING (true);


--
-- Name: variation_audit_log allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.variation_audit_log FOR INSERT WITH CHECK (true);


--
-- Name: variation_audit_log allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.variation_audit_log FOR SELECT USING (true);


--
-- Name: variation_audit_log allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.variation_audit_log FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: variation_audit_log anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.variation_audit_log USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: variation_audit_log authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.variation_audit_log USING ((auth.uid() IS NOT NULL));


--
-- Name: variation_audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.variation_audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE variation_audit_log; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.variation_audit_log TO anon;
GRANT SELECT ON TABLE public.variation_audit_log TO authenticated;
GRANT ALL ON TABLE public.variation_audit_log TO service_role;
GRANT SELECT ON TABLE public.variation_audit_log TO replication_user;


--
-- PostgreSQL database dump complete
--

