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
-- Name: incident_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.incident_types (
    id text NOT NULL,
    incident_type_en text NOT NULL,
    incident_type_ar text NOT NULL,
    description_en text,
    description_ar text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE incident_types; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.incident_types IS 'Stores the types of incidents that can be reported in the system';


--
-- Name: COLUMN incident_types.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_types.id IS 'Unique identifier for incident type (IN1, IN2, etc.)';


--
-- Name: COLUMN incident_types.incident_type_en; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_types.incident_type_en IS 'English name of the incident type';


--
-- Name: COLUMN incident_types.incident_type_ar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_types.incident_type_ar IS 'Arabic name of the incident type';


--
-- Name: incident_types incident_types_incident_type_ar_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_incident_type_ar_key UNIQUE (incident_type_ar);


--
-- Name: incident_types incident_types_incident_type_en_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_incident_type_en_key UNIQUE (incident_type_en);


--
-- Name: incident_types incident_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_pkey PRIMARY KEY (id);


--
-- Name: idx_incident_types_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_incident_types_is_active ON public.incident_types USING btree (is_active) WHERE (is_active = true);


--
-- Name: incident_types Allow all access to incident_types; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to incident_types" ON public.incident_types USING (true) WITH CHECK (true);


--
-- Name: incident_types; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.incident_types ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE incident_types; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.incident_types TO anon;
GRANT ALL ON TABLE public.incident_types TO authenticated;
GRANT ALL ON TABLE public.incident_types TO service_role;
GRANT SELECT ON TABLE public.incident_types TO replication_user;


--
-- PostgreSQL database dump complete
--

