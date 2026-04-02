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
-- Name: employee_checklist_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_checklist_assignments (
    id bigint NOT NULL,
    employee_id text NOT NULL,
    assigned_to_user_id text,
    branch_id bigint,
    checklist_id text NOT NULL,
    frequency_type text NOT NULL,
    day_of_week text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    assigned_by text,
    updated_by text,
    CONSTRAINT employee_checklist_assignments_frequency_type_check CHECK ((frequency_type = ANY (ARRAY['daily'::text, 'weekly'::text])))
);


--
-- Name: employee_checklist_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employee_checklist_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_checklist_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employee_checklist_assignments_id_seq OWNED BY public.employee_checklist_assignments.id;


--
-- Name: employee_checklist_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_checklist_assignments ALTER COLUMN id SET DEFAULT nextval('public.employee_checklist_assignments_id_seq'::regclass);


--
-- Name: employee_checklist_assignments employee_checklist_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_pkey PRIMARY KEY (id);


--
-- Name: idx_employee_checklist_assignments_assigned_to_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_checklist_assignments_assigned_to_user_id ON public.employee_checklist_assignments USING btree (assigned_to_user_id);


--
-- Name: idx_employee_checklist_assignments_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_checklist_assignments_branch_id ON public.employee_checklist_assignments USING btree (branch_id);


--
-- Name: idx_employee_checklist_assignments_checklist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_checklist_assignments_checklist_id ON public.employee_checklist_assignments USING btree (checklist_id);


--
-- Name: idx_employee_checklist_assignments_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_checklist_assignments_deleted_at ON public.employee_checklist_assignments USING btree (deleted_at);


--
-- Name: idx_employee_checklist_assignments_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_checklist_assignments_employee_id ON public.employee_checklist_assignments USING btree (employee_id);


--
-- Name: employee_checklist_assignments employee_checklist_assignments_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: employee_checklist_assignments employee_checklist_assignments_checklist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_checklist_id_fkey FOREIGN KEY (checklist_id) REFERENCES public.hr_checklists(id) ON DELETE CASCADE;


--
-- Name: employee_checklist_assignments employee_checklist_assignments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: employee_checklist_assignments Allow all access to employee_checklist_assignments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to employee_checklist_assignments" ON public.employee_checklist_assignments USING (true) WITH CHECK (true);


--
-- Name: employee_checklist_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.employee_checklist_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE employee_checklist_assignments; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.employee_checklist_assignments TO anon;
GRANT ALL ON TABLE public.employee_checklist_assignments TO authenticated;
GRANT ALL ON TABLE public.employee_checklist_assignments TO service_role;
GRANT SELECT ON TABLE public.employee_checklist_assignments TO replication_user;


--
-- Name: SEQUENCE employee_checklist_assignments_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.employee_checklist_assignments_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.employee_checklist_assignments_id_seq TO anon;
GRANT SELECT ON SEQUENCE public.employee_checklist_assignments_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

