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
-- Name: task_completions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_completions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    completed_by text NOT NULL,
    completed_by_name text,
    completed_by_branch_id uuid,
    task_finished_completed boolean DEFAULT false,
    photo_uploaded_completed boolean DEFAULT false,
    erp_reference_completed boolean DEFAULT false,
    erp_reference_number text,
    completion_notes text,
    verified_by text,
    verified_at timestamp with time zone,
    verification_notes text,
    completed_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    completion_photo_url text,
    CONSTRAINT chk_photo_url_consistency CHECK (((photo_uploaded_completed = false) OR (completion_photo_url IS NOT NULL)))
);


--
-- Name: TABLE task_completions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.task_completions IS 'Individual user task completion records';


--
-- Name: COLUMN task_completions.completion_photo_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_completions.completion_photo_url IS 'URL of the uploaded completion photo stored in completion-photos bucket';


--
-- Name: task_completions task_completions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_pkey PRIMARY KEY (id);


--
-- Name: idx_task_completions_assignment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_completions_assignment_id ON public.task_completions USING btree (assignment_id);


--
-- Name: idx_task_completions_completed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_completions_completed_at ON public.task_completions USING btree (completed_at DESC);


--
-- Name: idx_task_completions_completed_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_completions_completed_by ON public.task_completions USING btree (completed_by);


--
-- Name: idx_task_completions_completed_by_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_completions_completed_by_branch_id ON public.task_completions USING btree (completed_by_branch_id);


--
-- Name: idx_task_completions_erp_reference; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_completions_erp_reference ON public.task_completions USING btree (erp_reference_completed);


--
-- Name: idx_task_completions_photo_uploaded; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_completions_photo_uploaded ON public.task_completions USING btree (photo_uploaded_completed);


--
-- Name: idx_task_completions_photo_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_completions_photo_url ON public.task_completions USING btree (completion_photo_url) WHERE (completion_photo_url IS NOT NULL);


--
-- Name: idx_task_completions_task_finished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_completions_task_finished ON public.task_completions USING btree (task_finished_completed);


--
-- Name: idx_task_completions_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_completions_task_id ON public.task_completions USING btree (task_id);


--
-- Name: task_completions trigger_sync_erp_on_completion; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_sync_erp_on_completion AFTER INSERT OR UPDATE ON public.task_completions FOR EACH ROW EXECUTE FUNCTION public.trigger_sync_erp_reference_on_task_completion();


--
-- Name: task_completions task_completions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.task_assignments(id) ON DELETE CASCADE;


--
-- Name: task_completions task_completions_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: task_completions Allow anon insert task_completions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert task_completions" ON public.task_completions FOR INSERT TO anon WITH CHECK (true);


--
-- Name: task_completions Allow service role full access to task_completions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow service role full access to task_completions" ON public.task_completions TO authenticated USING (true) WITH CHECK (true);


--
-- Name: task_completions Simple create task completions policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Simple create task completions policy" ON public.task_completions FOR INSERT WITH CHECK (true);


--
-- Name: POLICY "Simple create task completions policy" ON task_completions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple create task completions policy" ON public.task_completions IS 'Allow all users to create task completions';


--
-- Name: task_completions Simple update task completions policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Simple update task completions policy" ON public.task_completions FOR UPDATE USING (true);


--
-- Name: POLICY "Simple update task completions policy" ON task_completions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple update task completions policy" ON public.task_completions IS 'Allow all users to update task completions';


--
-- Name: task_completions Simple view task completions policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Simple view task completions policy" ON public.task_completions FOR SELECT USING (true);


--
-- Name: POLICY "Simple view task completions policy" ON task_completions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple view task completions policy" ON public.task_completions IS 'Allow viewing all task completions';


--
-- Name: task_completions allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.task_completions USING (true) WITH CHECK (true);


--
-- Name: task_completions allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.task_completions FOR DELETE USING (true);


--
-- Name: task_completions allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.task_completions FOR INSERT WITH CHECK (true);


--
-- Name: task_completions allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.task_completions FOR SELECT USING (true);


--
-- Name: task_completions allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.task_completions FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: task_completions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.task_completions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: task_completions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.task_completions USING ((auth.uid() IS NOT NULL));


--
-- Name: task_completions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.task_completions ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE task_completions; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.task_completions TO anon;
GRANT SELECT ON TABLE public.task_completions TO authenticated;
GRANT ALL ON TABLE public.task_completions TO service_role;
GRANT SELECT ON TABLE public.task_completions TO replication_user;


--
-- PostgreSQL database dump complete
--

