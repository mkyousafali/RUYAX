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
-- Name: offer_names; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offer_names (
    id text NOT NULL,
    name_en text NOT NULL,
    name_ar text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: TABLE offer_names; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.offer_names IS 'Predefined offer name templates';


--
-- Name: offer_names offer_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_names
    ADD CONSTRAINT offer_names_pkey PRIMARY KEY (id);


--
-- Name: offer_names Allow all access to offer_names; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to offer_names" ON public.offer_names USING (true) WITH CHECK (true);


--
-- Name: offer_names; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.offer_names ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE offer_names; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.offer_names TO anon;
GRANT ALL ON TABLE public.offer_names TO authenticated;
GRANT ALL ON TABLE public.offer_names TO service_role;
GRANT SELECT ON TABLE public.offer_names TO replication_user;


--
-- PostgreSQL database dump complete
--

