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
-- Name: user_password_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_password_history (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    password_hash character varying(255) NOT NULL,
    salt character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: user_password_history user_password_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_password_history
    ADD CONSTRAINT user_password_history_pkey PRIMARY KEY (id);


--
-- Name: idx_password_history_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_password_history_user_created ON public.user_password_history USING btree (user_id, created_at DESC);


--
-- Name: user_password_history user_password_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_password_history
    ADD CONSTRAINT user_password_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_password_history Allow anon insert user_password_history; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert user_password_history" ON public.user_password_history FOR INSERT TO anon WITH CHECK (true);


--
-- Name: user_password_history allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.user_password_history USING (true) WITH CHECK (true);


--
-- Name: user_password_history allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.user_password_history FOR DELETE USING (true);


--
-- Name: user_password_history allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.user_password_history FOR INSERT WITH CHECK (true);


--
-- Name: user_password_history allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.user_password_history FOR SELECT USING (true);


--
-- Name: user_password_history allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.user_password_history FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: user_password_history anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.user_password_history USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: user_password_history authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.user_password_history USING ((auth.uid() IS NOT NULL));


--
-- Name: user_password_history; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_password_history ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE user_password_history; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.user_password_history TO anon;
GRANT SELECT ON TABLE public.user_password_history TO authenticated;
GRANT ALL ON TABLE public.user_password_history TO service_role;
GRANT SELECT ON TABLE public.user_password_history TO replication_user;


--
-- PostgreSQL database dump complete
--

