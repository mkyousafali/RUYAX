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
-- Name: hr_departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hr_departments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    department_name_en character varying(100) NOT NULL,
    department_name_ar character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE hr_departments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_departments IS 'HR Departments - minimal schema for Create Department function';


--
-- Name: hr_departments hr_departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_departments
    ADD CONSTRAINT hr_departments_pkey PRIMARY KEY (id);


--
-- Name: hr_departments Allow anon insert hr_departments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert hr_departments" ON public.hr_departments FOR INSERT TO anon WITH CHECK (true);


--
-- Name: hr_departments allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.hr_departments USING (true) WITH CHECK (true);


--
-- Name: hr_departments allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.hr_departments FOR DELETE USING (true);


--
-- Name: hr_departments allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.hr_departments FOR INSERT WITH CHECK (true);


--
-- Name: hr_departments allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.hr_departments FOR SELECT USING (true);


--
-- Name: hr_departments allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.hr_departments FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: hr_departments anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.hr_departments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_departments authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.hr_departments USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_departments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_departments ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE hr_departments; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.hr_departments TO anon;
GRANT SELECT ON TABLE public.hr_departments TO authenticated;
GRANT ALL ON TABLE public.hr_departments TO service_role;
GRANT SELECT ON TABLE public.hr_departments TO replication_user;


--
-- PostgreSQL database dump complete
--

