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
-- Name: day_off_reasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.day_off_reasons (
    id character varying(50) NOT NULL,
    reason_en character varying(255) NOT NULL,
    reason_ar character varying(255) NOT NULL,
    is_deductible boolean DEFAULT false,
    is_document_mandatory boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: day_off_reasons day_off_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off_reasons
    ADD CONSTRAINT day_off_reasons_pkey PRIMARY KEY (id);


--
-- Name: day_off_reasons day_off_reasons_reason_en_reason_ar_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off_reasons
    ADD CONSTRAINT day_off_reasons_reason_en_reason_ar_key UNIQUE (reason_en, reason_ar);


--
-- Name: idx_day_off_reasons_deductible; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_day_off_reasons_deductible ON public.day_off_reasons USING btree (is_deductible);


--
-- Name: idx_day_off_reasons_document_mandatory; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_day_off_reasons_document_mandatory ON public.day_off_reasons USING btree (is_document_mandatory);


--
-- Name: day_off_reasons day_off_reasons_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER day_off_reasons_timestamp_update BEFORE UPDATE ON public.day_off_reasons FOR EACH ROW EXECUTE FUNCTION public.update_day_off_reasons_timestamp();


--
-- Name: day_off_reasons Allow all access to day_off_reasons; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to day_off_reasons" ON public.day_off_reasons USING (true) WITH CHECK (true);


--
-- Name: day_off_reasons; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.day_off_reasons ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE day_off_reasons; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.day_off_reasons TO anon;
GRANT ALL ON TABLE public.day_off_reasons TO authenticated;
GRANT ALL ON TABLE public.day_off_reasons TO service_role;
GRANT SELECT ON TABLE public.day_off_reasons TO replication_user;


--
-- PostgreSQL database dump complete
--

