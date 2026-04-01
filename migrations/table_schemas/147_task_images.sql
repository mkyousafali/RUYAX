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
-- Name: task_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_images (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    file_name text NOT NULL,
    file_size bigint NOT NULL,
    file_type text NOT NULL,
    file_url text NOT NULL,
    image_type text NOT NULL,
    uploaded_by text NOT NULL,
    uploaded_by_name text,
    created_at timestamp with time zone DEFAULT now(),
    image_width integer,
    image_height integer,
    file_path text,
    attachment_type text DEFAULT 'task_creation'::text,
    CONSTRAINT task_images_attachment_type_check CHECK ((attachment_type = ANY (ARRAY['task_creation'::text, 'task_completion'::text])))
);


--
-- Name: TABLE task_images; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.task_images IS 'Task creation images and completion photos';


--
-- Name: task_images task_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_images
    ADD CONSTRAINT task_images_pkey PRIMARY KEY (id);


--
-- Name: idx_task_images_attachment_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_images_attachment_type ON public.task_images USING btree (attachment_type);


--
-- Name: idx_task_images_image_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_images_image_type ON public.task_images USING btree (image_type);


--
-- Name: idx_task_images_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_images_task_id ON public.task_images USING btree (task_id);


--
-- Name: idx_task_images_uploaded_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_images_uploaded_by ON public.task_images USING btree (uploaded_by);


--
-- Name: task_images task_images_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_images
    ADD CONSTRAINT task_images_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: task_images Allow anon insert task_images; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert task_images" ON public.task_images FOR INSERT TO anon WITH CHECK (true);


--
-- Name: task_images Simple create task images policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Simple create task images policy" ON public.task_images FOR INSERT WITH CHECK (true);


--
-- Name: POLICY "Simple create task images policy" ON task_images; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple create task images policy" ON public.task_images IS 'Allow all users to create task images';


--
-- Name: task_images Simple delete task images policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Simple delete task images policy" ON public.task_images FOR DELETE USING (true);


--
-- Name: POLICY "Simple delete task images policy" ON task_images; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple delete task images policy" ON public.task_images IS 'Allow all users to delete task images';


--
-- Name: task_images Simple update task images policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Simple update task images policy" ON public.task_images FOR UPDATE USING (true);


--
-- Name: POLICY "Simple update task images policy" ON task_images; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple update task images policy" ON public.task_images IS 'Allow all users to update task images';


--
-- Name: task_images Simple view task images policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Simple view task images policy" ON public.task_images FOR SELECT USING (true);


--
-- Name: POLICY "Simple view task images policy" ON task_images; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple view task images policy" ON public.task_images IS 'Allow viewing all task images';


--
-- Name: task_images allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.task_images USING (true) WITH CHECK (true);


--
-- Name: task_images allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.task_images FOR DELETE USING (true);


--
-- Name: task_images allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.task_images FOR INSERT WITH CHECK (true);


--
-- Name: task_images allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.task_images FOR SELECT USING (true);


--
-- Name: task_images allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.task_images FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: task_images anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.task_images USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: task_images authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.task_images USING ((auth.uid() IS NOT NULL));


--
-- Name: task_images; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.task_images ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE task_images; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.task_images TO anon;
GRANT SELECT ON TABLE public.task_images TO authenticated;
GRANT ALL ON TABLE public.task_images TO service_role;
GRANT SELECT ON TABLE public.task_images TO replication_user;


--
-- PostgreSQL database dump complete
--

