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
-- Name: warning_main_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.warning_main_category (
    id character varying(10) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: warning_main_category warning_main_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warning_main_category
    ADD CONSTRAINT warning_main_category_pkey PRIMARY KEY (id);


--
-- Name: idx_warning_main_category_name_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_warning_main_category_name_en ON public.warning_main_category USING btree (name_en);


--
-- Name: warning_main_category warning_main_category_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER warning_main_category_timestamp_update BEFORE UPDATE ON public.warning_main_category FOR EACH ROW EXECUTE FUNCTION public.update_warning_main_category_timestamp();


--
-- Name: warning_main_category Allow all access to warning_main_category; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to warning_main_category" ON public.warning_main_category USING (true) WITH CHECK (true);


--
-- Name: warning_main_category; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.warning_main_category ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE warning_main_category; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.warning_main_category TO anon;
GRANT ALL ON TABLE public.warning_main_category TO authenticated;
GRANT ALL ON TABLE public.warning_main_category TO service_role;
GRANT SELECT ON TABLE public.warning_main_category TO replication_user;


--
-- PostgreSQL database dump complete
--

