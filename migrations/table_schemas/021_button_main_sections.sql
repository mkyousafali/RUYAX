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
-- Name: button_main_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.button_main_sections (
    id bigint NOT NULL,
    section_name_en character varying(255) NOT NULL,
    section_name_ar character varying(255) NOT NULL,
    section_code character varying(50) NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: button_main_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.button_main_sections ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.button_main_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: button_main_sections button_main_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_main_sections
    ADD CONSTRAINT button_main_sections_pkey PRIMARY KEY (id);


--
-- Name: button_main_sections button_main_sections_section_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_main_sections
    ADD CONSTRAINT button_main_sections_section_code_key UNIQUE (section_code);


--
-- Name: idx_button_main_sections_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_button_main_sections_active ON public.button_main_sections USING btree (is_active);


--
-- Name: button_main_sections allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.button_main_sections FOR DELETE USING (true);


--
-- Name: button_main_sections allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.button_main_sections FOR INSERT WITH CHECK (true);


--
-- Name: button_main_sections allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.button_main_sections FOR SELECT USING (true);


--
-- Name: button_main_sections allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.button_main_sections FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: button_main_sections; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.button_main_sections ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE button_main_sections; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.button_main_sections TO anon;
GRANT SELECT ON TABLE public.button_main_sections TO authenticated;
GRANT ALL ON TABLE public.button_main_sections TO service_role;
GRANT SELECT ON TABLE public.button_main_sections TO replication_user;


--
-- Name: SEQUENCE button_main_sections_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.button_main_sections_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.button_main_sections_id_seq TO anon;
GRANT SELECT,USAGE ON SEQUENCE public.button_main_sections_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.button_main_sections_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

