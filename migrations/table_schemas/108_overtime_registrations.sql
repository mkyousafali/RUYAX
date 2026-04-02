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
-- Name: overtime_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.overtime_registrations (
    id text NOT NULL,
    employee_id text NOT NULL,
    overtime_date date NOT NULL,
    overtime_minutes integer DEFAULT 0 NOT NULL,
    worked_minutes integer DEFAULT 0,
    notes text,
    created_by text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE overtime_registrations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.overtime_registrations IS 'Stores overtime registrations for employees who worked on holidays/day offs or worked beyond expected hours';


--
-- Name: overtime_registrations overtime_registrations_employee_id_overtime_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.overtime_registrations
    ADD CONSTRAINT overtime_registrations_employee_id_overtime_date_key UNIQUE (employee_id, overtime_date);


--
-- Name: overtime_registrations overtime_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.overtime_registrations
    ADD CONSTRAINT overtime_registrations_pkey PRIMARY KEY (id);


--
-- Name: overtime_registrations overtime_registrations_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.overtime_registrations
    ADD CONSTRAINT overtime_registrations_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: overtime_registrations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.overtime_registrations ENABLE ROW LEVEL SECURITY;

--
-- Name: overtime_registrations overtime_registrations_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY overtime_registrations_all ON public.overtime_registrations USING (true) WITH CHECK (true);


--
-- Name: TABLE overtime_registrations; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT ON TABLE public.overtime_registrations TO anon;
GRANT SELECT ON TABLE public.overtime_registrations TO authenticated;
GRANT ALL ON TABLE public.overtime_registrations TO service_role;
GRANT SELECT ON TABLE public.overtime_registrations TO replication_user;


--
-- PostgreSQL database dump complete
--

