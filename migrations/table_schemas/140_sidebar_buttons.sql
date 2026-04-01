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
-- Name: sidebar_buttons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sidebar_buttons (
    id bigint NOT NULL,
    main_section_id bigint NOT NULL,
    subsection_id bigint NOT NULL,
    button_name_en character varying(255) NOT NULL,
    button_name_ar character varying(255) NOT NULL,
    button_code character varying(100) NOT NULL,
    icon character varying(50),
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: sidebar_buttons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.sidebar_buttons ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sidebar_buttons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sidebar_buttons sidebar_buttons_main_section_id_subsection_id_button_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT sidebar_buttons_main_section_id_subsection_id_button_code_key UNIQUE (main_section_id, subsection_id, button_code);


--
-- Name: sidebar_buttons sidebar_buttons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT sidebar_buttons_pkey PRIMARY KEY (id);


--
-- Name: idx_sidebar_buttons_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sidebar_buttons_active ON public.sidebar_buttons USING btree (is_active);


--
-- Name: idx_sidebar_buttons_main; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sidebar_buttons_main ON public.sidebar_buttons USING btree (main_section_id);


--
-- Name: idx_sidebar_buttons_sub; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sidebar_buttons_sub ON public.sidebar_buttons USING btree (subsection_id);


--
-- Name: sidebar_buttons fk_main_section; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT fk_main_section FOREIGN KEY (main_section_id) REFERENCES public.button_main_sections(id) ON DELETE CASCADE;


--
-- Name: sidebar_buttons fk_sub_section; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT fk_sub_section FOREIGN KEY (subsection_id) REFERENCES public.button_sub_sections(id) ON DELETE CASCADE;


--
-- Name: sidebar_buttons allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.sidebar_buttons FOR DELETE USING (true);


--
-- Name: sidebar_buttons allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.sidebar_buttons FOR INSERT WITH CHECK (true);


--
-- Name: sidebar_buttons allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.sidebar_buttons FOR SELECT USING (true);


--
-- Name: sidebar_buttons allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.sidebar_buttons FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: sidebar_buttons; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.sidebar_buttons ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE sidebar_buttons; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.sidebar_buttons TO anon;
GRANT SELECT ON TABLE public.sidebar_buttons TO authenticated;
GRANT ALL ON TABLE public.sidebar_buttons TO service_role;
GRANT SELECT ON TABLE public.sidebar_buttons TO replication_user;


--
-- Name: SEQUENCE sidebar_buttons_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.sidebar_buttons_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.sidebar_buttons_id_seq TO anon;
GRANT SELECT,USAGE ON SEQUENCE public.sidebar_buttons_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.sidebar_buttons_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

