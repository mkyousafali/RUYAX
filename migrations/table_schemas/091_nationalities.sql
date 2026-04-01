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
-- Name: nationalities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nationalities (
    id character varying(10) NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ar character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: nationalities nationalities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nationalities
    ADD CONSTRAINT nationalities_pkey PRIMARY KEY (id);


--
-- Name: nationalities Allow all access to nationalities; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to nationalities" ON public.nationalities USING (true) WITH CHECK (true);


--
-- Name: nationalities; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nationalities ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE nationalities; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.nationalities TO anon;
GRANT ALL ON TABLE public.nationalities TO authenticated;
GRANT ALL ON TABLE public.nationalities TO service_role;
GRANT SELECT ON TABLE public.nationalities TO replication_user;


--
-- PostgreSQL database dump complete
--

