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
-- Name: shelf_paper_fonts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shelf_paper_fonts (
    name character varying(255) NOT NULL,
    font_url text NOT NULL,
    file_name character varying(255),
    file_size integer,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    id character varying(20) DEFAULT ('F'::text || (nextval('public.shelf_paper_fonts_id_seq'::regclass))::text) NOT NULL,
    original_file_name character varying(500)
);


--
-- Name: shelf_paper_fonts shelf_paper_fonts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shelf_paper_fonts
    ADD CONSTRAINT shelf_paper_fonts_pkey PRIMARY KEY (id);


--
-- Name: idx_shelf_paper_fonts_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shelf_paper_fonts_created_by ON public.shelf_paper_fonts USING btree (created_by);


--
-- Name: idx_shelf_paper_fonts_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shelf_paper_fonts_name ON public.shelf_paper_fonts USING btree (name);


--
-- Name: shelf_paper_fonts Allow all access to shelf_paper_fonts; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to shelf_paper_fonts" ON public.shelf_paper_fonts USING (true) WITH CHECK (true);


--
-- Name: shelf_paper_fonts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shelf_paper_fonts ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE shelf_paper_fonts; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.shelf_paper_fonts TO anon;
GRANT ALL ON TABLE public.shelf_paper_fonts TO authenticated;
GRANT ALL ON TABLE public.shelf_paper_fonts TO service_role;
GRANT SELECT ON TABLE public.shelf_paper_fonts TO replication_user;


--
-- PostgreSQL database dump complete
--

