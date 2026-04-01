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
-- Name: quick_task_completions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quick_task_completions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    completed_by_user_id uuid NOT NULL,
    completion_notes text,
    photo_path text,
    erp_reference character varying(255),
    completion_status character varying(50) DEFAULT 'submitted'::character varying NOT NULL,
    verified_by_user_id uuid,
    verified_at timestamp with time zone,
    verification_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_completion_status_valid CHECK (((completion_status)::text = ANY (ARRAY[('submitted'::character varying)::text, ('verified'::character varying)::text, ('rejected'::character varying)::text, ('pending_review'::character varying)::text]))),
    CONSTRAINT chk_verified_at_when_verified CHECK (((((completion_status)::text <> 'verified'::text) AND (verified_at IS NULL)) OR (((completion_status)::text = 'verified'::text) AND (verified_at IS NOT NULL))))
);


--
-- Name: TABLE quick_task_completions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.quick_task_completions IS 'Completion records for quick tasks with photos and verification';


--
-- Name: COLUMN quick_task_completions.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.id IS 'Unique identifier for the completion record';


--
-- Name: COLUMN quick_task_completions.quick_task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.quick_task_id IS 'Reference to the quick task that was completed';


--
-- Name: COLUMN quick_task_completions.assignment_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.assignment_id IS 'Reference to the specific assignment that was completed';


--
-- Name: COLUMN quick_task_completions.completed_by_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.completed_by_user_id IS 'User who completed the task';


--
-- Name: COLUMN quick_task_completions.completion_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.completion_notes IS 'Notes provided by the user upon completion';


--
-- Name: COLUMN quick_task_completions.photo_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.photo_path IS 'Path to the completion photo in storage';


--
-- Name: COLUMN quick_task_completions.erp_reference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.erp_reference IS 'ERP system reference number if required';


--
-- Name: COLUMN quick_task_completions.completion_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.completion_status IS 'Status of the completion record';


--
-- Name: COLUMN quick_task_completions.verified_by_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.verified_by_user_id IS 'User who verified the completion';


--
-- Name: COLUMN quick_task_completions.verified_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.verified_at IS 'When the completion was verified';


--
-- Name: COLUMN quick_task_completions.verification_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.verification_notes IS 'Notes from the verifier';


--
-- Name: quick_task_completions quick_task_completions_assignment_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_assignment_unique UNIQUE (assignment_id);


--
-- Name: quick_task_completions quick_task_completions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_pkey PRIMARY KEY (id);


--
-- Name: idx_quick_task_completions_assignment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_completions_assignment ON public.quick_task_completions USING btree (assignment_id);


--
-- Name: idx_quick_task_completions_completed_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_completions_completed_by ON public.quick_task_completions USING btree (completed_by_user_id);


--
-- Name: idx_quick_task_completions_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_completions_created_at ON public.quick_task_completions USING btree (created_at DESC);


--
-- Name: idx_quick_task_completions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_completions_status ON public.quick_task_completions USING btree (completion_status);


--
-- Name: idx_quick_task_completions_task; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_completions_task ON public.quick_task_completions USING btree (quick_task_id);


--
-- Name: idx_quick_task_completions_verified_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_completions_verified_by ON public.quick_task_completions USING btree (verified_by_user_id) WHERE (verified_by_user_id IS NOT NULL);


--
-- Name: quick_task_completions trigger_update_quick_task_completions_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_quick_task_completions_updated_at BEFORE UPDATE ON public.quick_task_completions FOR EACH ROW EXECUTE FUNCTION public.update_quick_task_completions_updated_at();


--
-- Name: quick_task_completions quick_task_completions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.quick_task_assignments(id) ON DELETE CASCADE;


--
-- Name: quick_task_completions quick_task_completions_completed_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_completed_by_user_id_fkey FOREIGN KEY (completed_by_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: quick_task_completions quick_task_completions_quick_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;


--
-- Name: quick_task_completions quick_task_completions_verified_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_verified_by_user_id_fkey FOREIGN KEY (verified_by_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: quick_task_completions Allow anon insert quick_task_completions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert quick_task_completions" ON public.quick_task_completions FOR INSERT TO anon WITH CHECK (true);


--
-- Name: quick_task_completions Allow service role full access to quick_task_completions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow service role full access to quick_task_completions" ON public.quick_task_completions TO authenticated USING (true) WITH CHECK (true);


--
-- Name: quick_task_completions Managers can verify completions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Managers can verify completions" ON public.quick_task_completions FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.user_type = 'global'::public.user_type_enum)))));


--
-- Name: quick_task_completions Managers can view all completions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Managers can view all completions" ON public.quick_task_completions FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.user_type = 'global'::public.user_type_enum)))));


--
-- Name: quick_task_completions Users can insert their own completions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert their own completions" ON public.quick_task_completions FOR INSERT WITH CHECK ((completed_by_user_id = auth.uid()));


--
-- Name: quick_task_completions Users can update their own completions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update their own completions" ON public.quick_task_completions FOR UPDATE USING ((completed_by_user_id = auth.uid()));


--
-- Name: quick_task_completions Users can view their own completions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view their own completions" ON public.quick_task_completions FOR SELECT USING ((completed_by_user_id = auth.uid()));


--
-- Name: quick_task_completions allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.quick_task_completions USING (true) WITH CHECK (true);


--
-- Name: quick_task_completions allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.quick_task_completions FOR DELETE USING (true);


--
-- Name: quick_task_completions allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.quick_task_completions FOR INSERT WITH CHECK (true);


--
-- Name: quick_task_completions allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.quick_task_completions FOR SELECT USING (true);


--
-- Name: quick_task_completions allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.quick_task_completions FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: quick_task_completions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.quick_task_completions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: quick_task_completions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.quick_task_completions USING ((auth.uid() IS NOT NULL));


--
-- Name: quick_task_completions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.quick_task_completions ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE quick_task_completions; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_task_completions TO anon;
GRANT SELECT ON TABLE public.quick_task_completions TO authenticated;
GRANT ALL ON TABLE public.quick_task_completions TO service_role;
GRANT SELECT ON TABLE public.quick_task_completions TO replication_user;


--
-- PostgreSQL database dump complete
--

