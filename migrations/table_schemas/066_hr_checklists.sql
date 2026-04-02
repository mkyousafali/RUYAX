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
-- Name: hr_checklists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hr_checklists (
    id character varying(20) DEFAULT ('CL'::text || nextval('public.hr_checklists_id_seq'::regclass)) NOT NULL,
    checklist_name_en text,
    checklist_name_ar text,
    question_ids jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: hr_checklists hr_checklists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklists
    ADD CONSTRAINT hr_checklists_pkey PRIMARY KEY (id);


--
-- Name: idx_hr_checklists_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_checklists_created ON public.hr_checklists USING btree (created_at DESC);


--
-- Name: hr_checklists hr_checklists_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER hr_checklists_timestamp_update BEFORE UPDATE ON public.hr_checklists FOR EACH ROW EXECUTE FUNCTION public.update_hr_checklists_timestamp();


--
-- Name: hr_checklists Allow all access to hr_checklists; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to hr_checklists" ON public.hr_checklists USING (true) WITH CHECK (true);


--
-- Name: hr_checklists; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_checklists ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE hr_checklists; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.hr_checklists TO anon;
GRANT ALL ON TABLE public.hr_checklists TO authenticated;
GRANT ALL ON TABLE public.hr_checklists TO service_role;
GRANT SELECT ON TABLE public.hr_checklists TO replication_user;


--
-- PostgreSQL database dump complete
--

