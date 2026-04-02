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
-- Name: security_code_scroll_texts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.security_code_scroll_texts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    text_content text NOT NULL,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: security_code_scroll_texts security_code_scroll_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.security_code_scroll_texts
    ADD CONSTRAINT security_code_scroll_texts_pkey PRIMARY KEY (id);


--
-- Name: security_code_scroll_texts security_code_scroll_texts_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.security_code_scroll_texts
    ADD CONSTRAINT security_code_scroll_texts_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: security_code_scroll_texts Allow anon read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon read" ON public.security_code_scroll_texts FOR SELECT TO anon USING (true);


--
-- Name: security_code_scroll_texts Allow authenticated delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated delete" ON public.security_code_scroll_texts FOR DELETE TO authenticated USING (true);


--
-- Name: security_code_scroll_texts Allow authenticated insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated insert" ON public.security_code_scroll_texts FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: security_code_scroll_texts Allow authenticated read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated read" ON public.security_code_scroll_texts FOR SELECT TO authenticated USING (true);


--
-- Name: security_code_scroll_texts Allow authenticated update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated update" ON public.security_code_scroll_texts FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: security_code_scroll_texts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.security_code_scroll_texts ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE security_code_scroll_texts; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT ON TABLE public.security_code_scroll_texts TO anon;
GRANT ALL ON TABLE public.security_code_scroll_texts TO authenticated;
GRANT ALL ON TABLE public.security_code_scroll_texts TO service_role;
GRANT SELECT ON TABLE public.security_code_scroll_texts TO replication_user;


--
-- PostgreSQL database dump complete
--

