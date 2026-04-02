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
-- Name: hr_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hr_levels (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    level_name_en character varying(100) NOT NULL,
    level_name_ar character varying(100) NOT NULL,
    level_order integer NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE hr_levels; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_levels IS 'HR Levels - minimal schema for Create Level function';


--
-- Name: hr_levels hr_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_levels
    ADD CONSTRAINT hr_levels_pkey PRIMARY KEY (id);


--
-- Name: hr_levels Allow anon insert hr_levels; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert hr_levels" ON public.hr_levels FOR INSERT TO anon WITH CHECK (true);


--
-- Name: hr_levels allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.hr_levels USING (true) WITH CHECK (true);


--
-- Name: hr_levels allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.hr_levels FOR DELETE USING (true);


--
-- Name: hr_levels allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.hr_levels FOR INSERT WITH CHECK (true);


--
-- Name: hr_levels allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.hr_levels FOR SELECT USING (true);


--
-- Name: hr_levels allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.hr_levels FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: hr_levels anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.hr_levels USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_levels authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.hr_levels USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_levels; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_levels ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE hr_levels; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.hr_levels TO anon;
GRANT SELECT ON TABLE public.hr_levels TO authenticated;
GRANT ALL ON TABLE public.hr_levels TO service_role;
GRANT SELECT ON TABLE public.hr_levels TO replication_user;


--
-- PostgreSQL database dump complete
--

