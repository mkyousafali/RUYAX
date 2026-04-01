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
-- Name: quick_task_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quick_task_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    assigned_to_user_id uuid NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying,
    accepted_at timestamp with time zone,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    require_task_finished boolean DEFAULT true,
    require_photo_upload boolean DEFAULT true,
    require_erp_reference boolean DEFAULT false,
    CONSTRAINT chk_require_task_finished_not_null CHECK ((require_task_finished IS NOT NULL))
);


--
-- Name: COLUMN quick_task_assignments.require_task_finished; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_assignments.require_task_finished IS 'Whether task completion checkbox is required';


--
-- Name: COLUMN quick_task_assignments.require_photo_upload; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_assignments.require_photo_upload IS 'Whether photo upload is required for task completion';


--
-- Name: COLUMN quick_task_assignments.require_erp_reference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_assignments.require_erp_reference IS 'Whether ERP reference number is required for task completion';


--
-- Name: quick_task_assignments quick_task_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_pkey PRIMARY KEY (id);


--
-- Name: quick_task_assignments quick_task_assignments_quick_task_id_assigned_to_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_quick_task_id_assigned_to_user_id_key UNIQUE (quick_task_id, assigned_to_user_id);


--
-- Name: idx_quick_task_assignments_assignment_id_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_assignments_assignment_id_status ON public.quick_task_assignments USING btree (quick_task_id, status);


--
-- Name: idx_quick_task_assignments_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_assignments_created_at ON public.quick_task_assignments USING btree (created_at);


--
-- Name: idx_quick_task_assignments_require_erp_reference; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_assignments_require_erp_reference ON public.quick_task_assignments USING btree (require_erp_reference) WHERE (require_erp_reference = true);


--
-- Name: idx_quick_task_assignments_require_photo_upload; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_assignments_require_photo_upload ON public.quick_task_assignments USING btree (require_photo_upload) WHERE (require_photo_upload = true);


--
-- Name: idx_quick_task_assignments_require_task_finished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_assignments_require_task_finished ON public.quick_task_assignments USING btree (require_task_finished);


--
-- Name: idx_quick_task_assignments_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_assignments_status ON public.quick_task_assignments USING btree (status);


--
-- Name: idx_quick_task_assignments_task; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_assignments_task ON public.quick_task_assignments USING btree (quick_task_id);


--
-- Name: idx_quick_task_assignments_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_assignments_user ON public.quick_task_assignments USING btree (assigned_to_user_id);


--
-- Name: quick_task_assignments trigger_copy_completion_requirements; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_copy_completion_requirements AFTER INSERT ON public.quick_task_assignments FOR EACH ROW EXECUTE FUNCTION public.copy_completion_requirements_to_assignment();


--
-- Name: quick_task_assignments trigger_create_quick_task_notification; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_create_quick_task_notification AFTER INSERT ON public.quick_task_assignments FOR EACH ROW EXECUTE FUNCTION public.create_quick_task_notification();


--
-- Name: quick_task_assignments trigger_order_task_completion; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_order_task_completion AFTER UPDATE ON public.quick_task_assignments FOR EACH ROW WHEN ((((old.status)::text IS DISTINCT FROM (new.status)::text) AND ((new.status)::text = 'completed'::text))) EXECUTE FUNCTION public.handle_order_task_completion();


--
-- Name: quick_task_assignments trigger_update_quick_task_status; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_quick_task_status AFTER UPDATE ON public.quick_task_assignments FOR EACH ROW EXECUTE FUNCTION public.update_quick_task_status();


--
-- Name: quick_task_assignments quick_task_assignments_assigned_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_assigned_to_user_id_fkey FOREIGN KEY (assigned_to_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: quick_task_assignments quick_task_assignments_quick_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;


--
-- Name: quick_task_assignments Allow anon insert quick_task_assignments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert quick_task_assignments" ON public.quick_task_assignments FOR INSERT TO anon WITH CHECK (true);


--
-- Name: quick_task_assignments Allow service role full access to quick_task_assignments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow service role full access to quick_task_assignments" ON public.quick_task_assignments TO authenticated USING (true) WITH CHECK (true);


--
-- Name: quick_task_assignments allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.quick_task_assignments USING (true) WITH CHECK (true);


--
-- Name: quick_task_assignments allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.quick_task_assignments FOR DELETE USING (true);


--
-- Name: quick_task_assignments allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.quick_task_assignments FOR INSERT WITH CHECK (true);


--
-- Name: quick_task_assignments allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.quick_task_assignments FOR SELECT USING (true);


--
-- Name: quick_task_assignments allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.quick_task_assignments FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: quick_task_assignments anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.quick_task_assignments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: quick_task_assignments authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.quick_task_assignments USING ((auth.uid() IS NOT NULL));


--
-- Name: quick_task_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.quick_task_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE quick_task_assignments; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_task_assignments TO anon;
GRANT SELECT ON TABLE public.quick_task_assignments TO authenticated;
GRANT ALL ON TABLE public.quick_task_assignments TO service_role;
GRANT SELECT ON TABLE public.quick_task_assignments TO replication_user;


--
-- PostgreSQL database dump complete
--

