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
-- Name: hr_insurance_companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hr_insurance_companies (
    id character varying(15) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: hr_insurance_companies hr_insurance_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_insurance_companies
    ADD CONSTRAINT hr_insurance_companies_pkey PRIMARY KEY (id);


--
-- Name: idx_hr_insurance_companies_name_ar; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_insurance_companies_name_ar ON public.hr_insurance_companies USING btree (name_ar);


--
-- Name: idx_hr_insurance_companies_name_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_insurance_companies_name_en ON public.hr_insurance_companies USING btree (name_en);


--
-- Name: hr_insurance_companies trg_generate_insurance_company_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_generate_insurance_company_id BEFORE INSERT ON public.hr_insurance_companies FOR EACH ROW EXECUTE FUNCTION public.generate_insurance_company_id();


--
-- Name: hr_insurance_companies Allow all access to hr_insurance_companies; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to hr_insurance_companies" ON public.hr_insurance_companies USING (true) WITH CHECK (true);


--
-- Name: hr_insurance_companies; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_insurance_companies ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE hr_insurance_companies; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.hr_insurance_companies TO anon;
GRANT ALL ON TABLE public.hr_insurance_companies TO authenticated;
GRANT ALL ON TABLE public.hr_insurance_companies TO service_role;
GRANT SELECT ON TABLE public.hr_insurance_companies TO replication_user;


--
-- PostgreSQL database dump complete
--

