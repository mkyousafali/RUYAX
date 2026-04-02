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
-- Name: mobile_themes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mobile_themes (
    id bigint NOT NULL,
    name text NOT NULL,
    description text,
    is_default boolean DEFAULT false,
    colors jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid
);


--
-- Name: mobile_themes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mobile_themes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mobile_themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mobile_themes_id_seq OWNED BY public.mobile_themes.id;


--
-- Name: mobile_themes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mobile_themes ALTER COLUMN id SET DEFAULT nextval('public.mobile_themes_id_seq'::regclass);


--
-- Name: mobile_themes mobile_themes_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mobile_themes
    ADD CONSTRAINT mobile_themes_name_key UNIQUE (name);


--
-- Name: mobile_themes mobile_themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mobile_themes
    ADD CONSTRAINT mobile_themes_pkey PRIMARY KEY (id);


--
-- Name: idx_mobile_themes_is_default; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mobile_themes_is_default ON public.mobile_themes USING btree (is_default);


--
-- Name: mobile_themes mobile_themes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mobile_themes
    ADD CONSTRAINT mobile_themes_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: mobile_themes Allow all access to mobile_themes; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to mobile_themes" ON public.mobile_themes USING (true) WITH CHECK (true);


--
-- Name: mobile_themes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.mobile_themes ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE mobile_themes; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.mobile_themes TO anon;
GRANT ALL ON TABLE public.mobile_themes TO authenticated;
GRANT ALL ON TABLE public.mobile_themes TO service_role;
GRANT SELECT ON TABLE public.mobile_themes TO replication_user;


--
-- Name: SEQUENCE mobile_themes_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.mobile_themes_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.mobile_themes_id_seq TO authenticated;
GRANT SELECT,USAGE ON SEQUENCE public.mobile_themes_id_seq TO anon;


--
-- PostgreSQL database dump complete
--

