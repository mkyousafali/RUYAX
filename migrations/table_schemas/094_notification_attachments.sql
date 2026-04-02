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
-- Name: notification_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_attachments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_path text NOT NULL,
    file_size bigint NOT NULL,
    file_type character varying(100) NOT NULL,
    uploaded_by character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: notification_attachments notification_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_attachments
    ADD CONSTRAINT notification_attachments_pkey PRIMARY KEY (id);


--
-- Name: idx_notification_attachments_notification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notification_attachments_notification_id ON public.notification_attachments USING btree (notification_id);


--
-- Name: idx_notification_attachments_uploaded_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notification_attachments_uploaded_by ON public.notification_attachments USING btree (uploaded_by);


--
-- Name: notification_attachments notification_attachments_notification_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_attachments
    ADD CONSTRAINT notification_attachments_notification_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;


--
-- Name: notification_attachments Allow anon insert notification_attachments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert notification_attachments" ON public.notification_attachments FOR INSERT TO anon WITH CHECK (true);


--
-- Name: notification_attachments allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.notification_attachments USING (true) WITH CHECK (true);


--
-- Name: notification_attachments allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.notification_attachments FOR DELETE USING (true);


--
-- Name: notification_attachments allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.notification_attachments FOR INSERT WITH CHECK (true);


--
-- Name: notification_attachments allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.notification_attachments FOR SELECT USING (true);


--
-- Name: notification_attachments allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.notification_attachments FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: notification_attachments anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.notification_attachments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: notification_attachments authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.notification_attachments USING ((auth.uid() IS NOT NULL));


--
-- Name: notification_attachments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notification_attachments ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE notification_attachments; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.notification_attachments TO anon;
GRANT SELECT ON TABLE public.notification_attachments TO authenticated;
GRANT ALL ON TABLE public.notification_attachments TO service_role;
GRANT SELECT ON TABLE public.notification_attachments TO replication_user;


--
-- PostgreSQL database dump complete
--

