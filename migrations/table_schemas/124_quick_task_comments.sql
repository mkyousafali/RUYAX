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
-- Name: quick_task_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quick_task_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    comment text NOT NULL,
    comment_type character varying(50) DEFAULT 'comment'::character varying,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: quick_task_comments quick_task_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_comments
    ADD CONSTRAINT quick_task_comments_pkey PRIMARY KEY (id);


--
-- Name: idx_quick_task_comments_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_comments_created_by ON public.quick_task_comments USING btree (created_by);


--
-- Name: idx_quick_task_comments_task; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_task_comments_task ON public.quick_task_comments USING btree (quick_task_id);


--
-- Name: quick_task_comments quick_task_comments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_comments
    ADD CONSTRAINT quick_task_comments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: quick_task_comments quick_task_comments_quick_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_comments
    ADD CONSTRAINT quick_task_comments_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;


--
-- Name: quick_task_comments Allow anon insert quick_task_comments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert quick_task_comments" ON public.quick_task_comments FOR INSERT TO anon WITH CHECK (true);


--
-- Name: quick_task_comments allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.quick_task_comments USING (true) WITH CHECK (true);


--
-- Name: quick_task_comments allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.quick_task_comments FOR DELETE USING (true);


--
-- Name: quick_task_comments allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.quick_task_comments FOR INSERT WITH CHECK (true);


--
-- Name: quick_task_comments allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.quick_task_comments FOR SELECT USING (true);


--
-- Name: quick_task_comments allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.quick_task_comments FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: quick_task_comments anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.quick_task_comments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: quick_task_comments authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.quick_task_comments USING ((auth.uid() IS NOT NULL));


--
-- Name: quick_task_comments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.quick_task_comments ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE quick_task_comments; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_task_comments TO anon;
GRANT SELECT ON TABLE public.quick_task_comments TO authenticated;
GRANT ALL ON TABLE public.quick_task_comments TO service_role;
GRANT SELECT ON TABLE public.quick_task_comments TO replication_user;


--
-- PostgreSQL database dump complete
--

