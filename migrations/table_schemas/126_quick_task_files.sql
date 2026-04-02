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
-- Name: quick_task_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quick_task_files (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_type character varying(100),
    file_size integer,
    mime_type character varying(100),
    storage_path text NOT NULL,
    storage_bucket character varying(100) DEFAULT 'quick-task-files'::character varying,
    uploaded_by uuid,
    uploaded_at timestamp with time zone DEFAULT now()
);


--
-- Name: quick_task_files quick_task_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_files
    ADD CONSTRAINT quick_task_files_pkey PRIMARY KEY (id);


--
-- Name: idx_quick_task_files_task; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_files_task ON public.quick_task_files USING btree (quick_task_id);


--
-- Name: idx_quick_task_files_uploaded_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_files_uploaded_by ON public.quick_task_files USING btree (uploaded_by);


--
-- Name: quick_task_files quick_task_files_quick_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_files
    ADD CONSTRAINT quick_task_files_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;


--
-- Name: quick_task_files quick_task_files_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_files
    ADD CONSTRAINT quick_task_files_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: quick_task_files Allow anon insert quick_task_files; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert quick_task_files" ON public.quick_task_files FOR INSERT TO anon WITH CHECK (true);


--
-- Name: quick_task_files allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.quick_task_files USING (true) WITH CHECK (true);


--
-- Name: quick_task_files allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.quick_task_files FOR DELETE USING (true);


--
-- Name: quick_task_files allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.quick_task_files FOR INSERT WITH CHECK (true);


--
-- Name: quick_task_files allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.quick_task_files FOR SELECT USING (true);


--
-- Name: quick_task_files allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.quick_task_files FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: quick_task_files anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.quick_task_files USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: quick_task_files authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.quick_task_files USING ((auth.uid() IS NOT NULL));


--
-- Name: quick_task_files; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.quick_task_files ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE quick_task_files; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_task_files TO anon;
GRANT SELECT ON TABLE public.quick_task_files TO authenticated;
GRANT ALL ON TABLE public.quick_task_files TO service_role;
GRANT SELECT ON TABLE public.quick_task_files TO replication_user;


--
-- PostgreSQL database dump complete
--

