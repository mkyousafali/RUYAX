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
-- Name: official_holidays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.official_holidays (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    holiday_date date NOT NULL,
    name_en text DEFAULT ''::text NOT NULL,
    name_ar text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: official_holidays official_holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.official_holidays
    ADD CONSTRAINT official_holidays_pkey PRIMARY KEY (id);


--
-- Name: official_holidays unique_official_holiday_date; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.official_holidays
    ADD CONSTRAINT unique_official_holiday_date UNIQUE (holiday_date);


--
-- Name: idx_official_holidays_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_official_holidays_date ON public.official_holidays USING btree (holiday_date);


--
-- Name: official_holidays official_holidays_timestamp_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER official_holidays_timestamp_trigger BEFORE UPDATE ON public.official_holidays FOR EACH ROW EXECUTE FUNCTION public.update_official_holidays_timestamp();


--
-- Name: official_holidays Allow all operations on official_holidays; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all operations on official_holidays" ON public.official_holidays USING (true) WITH CHECK (true);


--
-- Name: official_holidays; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.official_holidays ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE official_holidays; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.official_holidays TO anon;
GRANT ALL ON TABLE public.official_holidays TO authenticated;
GRANT ALL ON TABLE public.official_holidays TO service_role;
GRANT SELECT ON TABLE public.official_holidays TO replication_user;


--
-- PostgreSQL database dump complete
--

