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
-- Name: hr_employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hr_employees (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    employee_id character varying(20) NOT NULL,
    branch_id bigint NOT NULL,
    hire_date date,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    name character varying(200) NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE hr_employees; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_employees IS 'HR Employees - Upload function with Employee ID and Name only. Branch assigned from UI, Hire Date updated later.';


--
-- Name: hr_employees hr_employees_employee_id_branch_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employees
    ADD CONSTRAINT hr_employees_employee_id_branch_id_unique UNIQUE (employee_id, branch_id);


--
-- Name: hr_employees hr_employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employees
    ADD CONSTRAINT hr_employees_pkey PRIMARY KEY (id);


--
-- Name: idx_hr_employees_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employees_branch_id ON public.hr_employees USING btree (branch_id);


--
-- Name: idx_hr_employees_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employees_employee_id ON public.hr_employees USING btree (employee_id);


--
-- Name: idx_hr_employees_employee_id_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employees_employee_id_branch_id ON public.hr_employees USING btree (employee_id, branch_id);


--
-- Name: idx_hr_employees_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employees_updated_at ON public.hr_employees USING btree (updated_at);


--
-- Name: hr_employees hr_employees_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employees
    ADD CONSTRAINT hr_employees_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: hr_employees Allow anon insert hr_employees; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert hr_employees" ON public.hr_employees FOR INSERT TO anon WITH CHECK (true);


--
-- Name: hr_employees allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.hr_employees USING (true) WITH CHECK (true);


--
-- Name: hr_employees allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.hr_employees FOR DELETE USING (true);


--
-- Name: hr_employees allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.hr_employees FOR INSERT WITH CHECK (true);


--
-- Name: hr_employees allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.hr_employees FOR SELECT USING (true);


--
-- Name: hr_employees allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.hr_employees FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: hr_employees anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.hr_employees USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_employees authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.hr_employees USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_employees; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_employees ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE hr_employees; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.hr_employees TO anon;
GRANT SELECT ON TABLE public.hr_employees TO authenticated;
GRANT ALL ON TABLE public.hr_employees TO service_role;
GRANT SELECT ON TABLE public.hr_employees TO replication_user;


--
-- PostgreSQL database dump complete
--

