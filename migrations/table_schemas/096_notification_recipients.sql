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
-- Name: notification_recipients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_recipients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id uuid NOT NULL,
    role character varying(100),
    branch_id character varying(255),
    is_read boolean DEFAULT false NOT NULL,
    read_at timestamp with time zone,
    is_dismissed boolean DEFAULT false NOT NULL,
    dismissed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    delivery_status character varying(20) DEFAULT 'pending'::character varying,
    delivery_attempted_at timestamp with time zone,
    error_message text,
    user_id uuid
);


--
-- Name: notification_recipients notification_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT notification_recipients_pkey PRIMARY KEY (id);


--
-- Name: notification_recipients unique_notification_recipient; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT unique_notification_recipient UNIQUE (notification_id, user_id);


--
-- Name: idx_notification_recipients_delivery_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notification_recipients_delivery_status ON public.notification_recipients USING btree (delivery_status) WHERE ((delivery_status)::text = ANY (ARRAY[('pending'::character varying)::text, ('failed'::character varying)::text]));


--
-- Name: notification_recipients fk_notification_recipients_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT fk_notification_recipients_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: notification_recipients notification_recipients_notification_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT notification_recipients_notification_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;


--
-- Name: notification_recipients Allow anon insert notification_recipients; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert notification_recipients" ON public.notification_recipients FOR INSERT TO anon WITH CHECK (true);


--
-- Name: notification_recipients allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.notification_recipients USING (true) WITH CHECK (true);


--
-- Name: notification_recipients allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.notification_recipients FOR DELETE USING (true);


--
-- Name: notification_recipients allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.notification_recipients FOR INSERT WITH CHECK (true);


--
-- Name: notification_recipients allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.notification_recipients FOR SELECT USING (true);


--
-- Name: notification_recipients allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.notification_recipients FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: notification_recipients anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.notification_recipients USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: notification_recipients authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.notification_recipients USING ((auth.uid() IS NOT NULL));


--
-- Name: notification_recipients; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notification_recipients ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE notification_recipients; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.notification_recipients TO anon;
GRANT SELECT ON TABLE public.notification_recipients TO authenticated;
GRANT ALL ON TABLE public.notification_recipients TO service_role;
GRANT SELECT ON TABLE public.notification_recipients TO replication_user;


--
-- PostgreSQL database dump complete
--

