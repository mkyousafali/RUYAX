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
-- Name: hr_employee_master; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hr_employee_master (
    id text NOT NULL,
    user_id uuid NOT NULL,
    current_branch_id integer NOT NULL,
    current_position_id uuid,
    name_en character varying(255),
    name_ar character varying(255),
    employee_id_mapping jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    nationality_id character varying(10),
    id_expiry_date date,
    id_document_url character varying(500),
    health_card_expiry_date date,
    health_card_document_url character varying(500),
    driving_licence_expiry_date date,
    driving_licence_document_url character varying(500),
    id_number character varying(50),
    health_card_number character varying(50),
    driving_licence_number character varying(50),
    bank_name character varying(255),
    iban character varying(34),
    contract_expiry_date date,
    contract_document_url text,
    sponsorship_status boolean DEFAULT false,
    insurance_expiry_date date,
    insurance_company_id character varying(15),
    health_educational_renewal_date date,
    date_of_birth date,
    join_date date,
    work_permit_expiry_date date,
    probation_period_expiry_date date,
    employment_status text DEFAULT 'Resigned'::text,
    permitted_early_leave_hours numeric DEFAULT 0,
    employment_status_effective_date date,
    employment_status_reason text,
    whatsapp_number text,
    email text,
    privacy_policy_accepted boolean DEFAULT false NOT NULL,
    CONSTRAINT employment_status_values CHECK ((employment_status = ANY (ARRAY['Resigned'::text, 'Job (With Finger)'::text, 'Vacation'::text, 'Terminated'::text, 'Run Away'::text, 'Remote Job'::text, 'Job (No Finger)'::text])))
);


--
-- Name: COLUMN hr_employee_master.bank_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.bank_name IS 'Name of the bank where employee has account';


--
-- Name: COLUMN hr_employee_master.iban; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.iban IS 'International Bank Account Number';


--
-- Name: COLUMN hr_employee_master.contract_expiry_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.contract_expiry_date IS 'Employment contract expiry date';


--
-- Name: COLUMN hr_employee_master.contract_document_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.contract_document_url IS 'URL to the uploaded contract document';


--
-- Name: COLUMN hr_employee_master.sponsorship_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.sponsorship_status IS 'Employee sponsorship status - true if active, false if inactive';


--
-- Name: COLUMN hr_employee_master.employment_status_effective_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.employment_status_effective_date IS 'Effective date for employment status changes (Resigned, Terminated, Run Away)';


--
-- Name: COLUMN hr_employee_master.employment_status_reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.employment_status_reason IS 'Reason for employment status change';


--
-- Name: hr_employee_master hr_employee_master_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_pkey PRIMARY KEY (id);


--
-- Name: hr_employee_master hr_employee_master_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_user_id_key UNIQUE (user_id);


--
-- Name: idx_employment_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employment_status ON public.hr_employee_master USING btree (employment_status);


--
-- Name: idx_employment_status_effective_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employment_status_effective_date ON public.hr_employee_master USING btree (employment_status_effective_date);


--
-- Name: idx_hr_employee_driving_licence_expiry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_driving_licence_expiry ON public.hr_employee_master USING btree (driving_licence_expiry_date);


--
-- Name: idx_hr_employee_health_card_expiry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_health_card_expiry ON public.hr_employee_master USING btree (health_card_expiry_date);


--
-- Name: idx_hr_employee_id_expiry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_id_expiry ON public.hr_employee_master USING btree (id_expiry_date);


--
-- Name: idx_hr_employee_master_bank_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_bank_name ON public.hr_employee_master USING btree (bank_name);


--
-- Name: idx_hr_employee_master_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_branch_id ON public.hr_employee_master USING btree (current_branch_id);


--
-- Name: idx_hr_employee_master_date_of_birth; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_date_of_birth ON public.hr_employee_master USING btree (date_of_birth);


--
-- Name: idx_hr_employee_master_driving_licence_expiry_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_driving_licence_expiry_date ON public.hr_employee_master USING btree (driving_licence_expiry_date);


--
-- Name: idx_hr_employee_master_employee_mapping; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_employee_mapping ON public.hr_employee_master USING gin (employee_id_mapping);


--
-- Name: idx_hr_employee_master_health_card_expiry_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_health_card_expiry_date ON public.hr_employee_master USING btree (health_card_expiry_date);


--
-- Name: idx_hr_employee_master_health_educational_renewal_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_health_educational_renewal_date ON public.hr_employee_master USING btree (health_educational_renewal_date);


--
-- Name: idx_hr_employee_master_id_expiry_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_id_expiry_date ON public.hr_employee_master USING btree (id_expiry_date);


--
-- Name: idx_hr_employee_master_insurance_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_insurance_company_id ON public.hr_employee_master USING btree (insurance_company_id);


--
-- Name: idx_hr_employee_master_insurance_expiry_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_insurance_expiry_date ON public.hr_employee_master USING btree (insurance_expiry_date);


--
-- Name: idx_hr_employee_master_join_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_join_date ON public.hr_employee_master USING btree (join_date);


--
-- Name: idx_hr_employee_master_nationality_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_nationality_id ON public.hr_employee_master USING btree (nationality_id);


--
-- Name: idx_hr_employee_master_permitted_early_leave_hours; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_permitted_early_leave_hours ON public.hr_employee_master USING btree (permitted_early_leave_hours);


--
-- Name: idx_hr_employee_master_position_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_position_id ON public.hr_employee_master USING btree (current_position_id);


--
-- Name: idx_hr_employee_master_probation_period_expiry_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_probation_period_expiry_date ON public.hr_employee_master USING btree (probation_period_expiry_date);


--
-- Name: idx_hr_employee_master_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_user_id ON public.hr_employee_master USING btree (user_id);


--
-- Name: idx_hr_employee_master_work_permit_expiry_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_employee_master_work_permit_expiry_date ON public.hr_employee_master USING btree (work_permit_expiry_date);


--
-- Name: hr_employee_master hr_employee_master_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER hr_employee_master_timestamp_update BEFORE UPDATE ON public.hr_employee_master FOR EACH ROW EXECUTE FUNCTION public.update_hr_employee_master_timestamp();


--
-- Name: hr_employee_master hr_employee_master_current_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_current_branch_id_fkey FOREIGN KEY (current_branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: hr_employee_master hr_employee_master_current_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_current_position_id_fkey FOREIGN KEY (current_position_id) REFERENCES public.hr_positions(id) ON DELETE SET NULL;


--
-- Name: hr_employee_master hr_employee_master_nationality_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_nationality_id_fkey FOREIGN KEY (nationality_id) REFERENCES public.nationalities(id);


--
-- Name: hr_employee_master hr_employee_master_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: hr_employee_master Allow all access to hr_employee_master; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to hr_employee_master" ON public.hr_employee_master USING (true) WITH CHECK (true);


--
-- Name: hr_employee_master Allow all users to view hr_employee_master table; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all users to view hr_employee_master table" ON public.hr_employee_master FOR SELECT USING (true);


--
-- Name: hr_employee_master Allow anon insert hr_employee_master; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert hr_employee_master" ON public.hr_employee_master FOR INSERT TO anon WITH CHECK (true);


--
-- Name: hr_employee_master Allow service role full access to hr_employee_master; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow service role full access to hr_employee_master" ON public.hr_employee_master TO authenticated USING (true) WITH CHECK (true);


--
-- Name: hr_employee_master anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.hr_employee_master FOR SELECT USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_employee_master authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.hr_employee_master FOR SELECT USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_employee_master; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_employee_master ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE hr_employee_master; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.hr_employee_master TO anon;
GRANT ALL ON TABLE public.hr_employee_master TO authenticated;
GRANT ALL ON TABLE public.hr_employee_master TO service_role;
GRANT SELECT ON TABLE public.hr_employee_master TO replication_user;


--
-- PostgreSQL database dump complete
--

