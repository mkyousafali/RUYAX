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
-- Name: incidents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.incidents (
    id text NOT NULL,
    incident_type_id text NOT NULL,
    employee_id text,
    branch_id bigint NOT NULL,
    violation_id text,
    what_happened jsonb NOT NULL,
    witness_details jsonb,
    report_type text DEFAULT 'employee_related'::text NOT NULL,
    reports_to_user_ids uuid[] DEFAULT ARRAY[]::uuid[] NOT NULL,
    claims_status text,
    claimed_user_id uuid,
    resolution_status public.resolution_status DEFAULT 'reported'::public.resolution_status NOT NULL,
    user_statuses jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    attachments jsonb DEFAULT '[]'::jsonb,
    investigation_report jsonb,
    related_party jsonb,
    resolution_report jsonb
);


--
-- Name: TABLE incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.incidents IS 'Stores incident reports submitted by employees and other incident types';


--
-- Name: COLUMN incidents.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.id IS 'Unique identifier for incident (INS1, INS2, etc.)';


--
-- Name: COLUMN incidents.incident_type_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.incident_type_id IS 'Type of incident (references incident_types table)';


--
-- Name: COLUMN incidents.employee_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.employee_id IS 'Employee ID - NULL for non-employee incidents (Customer, Maintenance, Vendor, Vehicle, Government, Other)';


--
-- Name: COLUMN incidents.branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.branch_id IS 'Branch where incident occurred';


--
-- Name: COLUMN incidents.violation_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.violation_id IS 'Violation ID - NULL for non-employee incidents';


--
-- Name: COLUMN incidents.what_happened; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.what_happened IS 'JSONB: Detailed description of what happened';


--
-- Name: COLUMN incidents.witness_details; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.witness_details IS 'JSONB: Information about witnesses';


--
-- Name: COLUMN incidents.report_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.report_type IS 'Type of report (e.g., employee_related)';


--
-- Name: COLUMN incidents.reports_to_user_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.reports_to_user_ids IS 'Array of user IDs who should receive this incident report';


--
-- Name: COLUMN incidents.claims_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.claims_status IS 'Status of claims related to the incident';


--
-- Name: COLUMN incidents.claimed_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.claimed_user_id IS 'User ID of person who claimed the incident';


--
-- Name: COLUMN incidents.resolution_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.resolution_status IS 'Status: reported, claimed, or resolved';


--
-- Name: COLUMN incidents.user_statuses; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.user_statuses IS 'JSONB: Individual status for each user in reports_to_user_ids';


--
-- Name: COLUMN incidents.attachments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.attachments IS 'JSONB array of attachments: [{url, name, type, size, uploaded_at}, ...]';


--
-- Name: COLUMN incidents.investigation_report; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.investigation_report IS 'Stores investigation report details as JSON';


--
-- Name: COLUMN incidents.related_party; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.related_party IS 'Stores related party details as JSONB. For customer incidents: {name, contact_number}. For other incidents: {details}';


--
-- Name: COLUMN incidents.resolution_report; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.resolution_report IS 'Stores resolution report as JSONB with content, resolved_by, resolved_by_name, and resolved_at';


--
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);


--
-- Name: idx_incidents_attachments; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_incidents_attachments ON public.incidents USING gin (attachments);


--
-- Name: idx_incidents_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_incidents_branch_id ON public.incidents USING btree (branch_id);


--
-- Name: idx_incidents_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_incidents_created_at ON public.incidents USING btree (created_at DESC);


--
-- Name: idx_incidents_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_incidents_employee_id ON public.incidents USING btree (employee_id);


--
-- Name: idx_incidents_incident_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_incidents_incident_type_id ON public.incidents USING btree (incident_type_id);


--
-- Name: idx_incidents_related_party; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_incidents_related_party ON public.incidents USING gin (related_party) WHERE (related_party IS NOT NULL);


--
-- Name: idx_incidents_reports_to_user_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_incidents_reports_to_user_ids ON public.incidents USING gin (reports_to_user_ids);


--
-- Name: idx_incidents_resolution_report; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_incidents_resolution_report ON public.incidents USING gin (resolution_report) WHERE (resolution_report IS NOT NULL);


--
-- Name: idx_incidents_resolution_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_incidents_resolution_status ON public.incidents USING btree (resolution_status);


--
-- Name: idx_incidents_violation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_incidents_violation_id ON public.incidents USING btree (violation_id);


--
-- Name: incidents incidents_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: incidents incidents_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id);


--
-- Name: incidents incidents_incident_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_incident_type_id_fkey FOREIGN KEY (incident_type_id) REFERENCES public.incident_types(id);


--
-- Name: incidents incidents_violation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_violation_id_fkey FOREIGN KEY (violation_id) REFERENCES public.warning_violation(id);


--
-- Name: incidents Allow all access to incidents; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to incidents" ON public.incidents USING (true) WITH CHECK (true);


--
-- Name: incidents; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.incidents ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE incidents; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.incidents TO anon;
GRANT ALL ON TABLE public.incidents TO authenticated;
GRANT ALL ON TABLE public.incidents TO service_role;
GRANT SELECT ON TABLE public.incidents TO replication_user;


--
-- PostgreSQL database dump complete
--

