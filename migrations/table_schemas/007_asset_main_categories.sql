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
-- Name: asset_main_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.asset_main_categories (
    id integer NOT NULL,
    group_code character varying(20) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: asset_main_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.asset_main_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: asset_main_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.asset_main_categories_id_seq OWNED BY public.asset_main_categories.id;


--
-- Name: asset_main_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_main_categories ALTER COLUMN id SET DEFAULT nextval('public.asset_main_categories_id_seq'::regclass);


--
-- Name: asset_main_categories asset_main_categories_group_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_main_categories
    ADD CONSTRAINT asset_main_categories_group_code_key UNIQUE (group_code);


--
-- Name: asset_main_categories asset_main_categories_name_en_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_main_categories
    ADD CONSTRAINT asset_main_categories_name_en_key UNIQUE (name_en);


--
-- Name: asset_main_categories asset_main_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_main_categories
    ADD CONSTRAINT asset_main_categories_pkey PRIMARY KEY (id);


--
-- Name: idx_asset_main_categories_group_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_asset_main_categories_group_code ON public.asset_main_categories USING btree (group_code);


--
-- Name: idx_asset_main_categories_name_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_asset_main_categories_name_en ON public.asset_main_categories USING btree (name_en);


--
-- Name: asset_main_categories Allow all access to asset_main_categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to asset_main_categories" ON public.asset_main_categories USING (true) WITH CHECK (true);


--
-- Name: asset_main_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.asset_main_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE asset_main_categories; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.asset_main_categories TO anon;
GRANT ALL ON TABLE public.asset_main_categories TO authenticated;
GRANT ALL ON TABLE public.asset_main_categories TO service_role;
GRANT SELECT ON TABLE public.asset_main_categories TO replication_user;


--
-- Name: SEQUENCE asset_main_categories_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.asset_main_categories_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.asset_main_categories_id_seq TO anon;
GRANT SELECT,USAGE ON SEQUENCE public.asset_main_categories_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.asset_main_categories_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

