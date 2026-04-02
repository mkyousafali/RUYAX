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
-- Name: assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assets (
    id integer NOT NULL,
    asset_id character varying(30) NOT NULL,
    sub_category_id integer NOT NULL,
    asset_name_en character varying(255) NOT NULL,
    asset_name_ar character varying(255) NOT NULL,
    purchase_date date,
    purchase_value numeric(12,2) DEFAULT 0,
    branch_id integer,
    invoice_url text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assets_id_seq OWNED BY public.assets.id;


--
-- Name: assets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);


--
-- Name: assets assets_asset_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_asset_id_key UNIQUE (asset_id);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: idx_assets_asset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assets_asset_id ON public.assets USING btree (asset_id);


--
-- Name: idx_assets_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assets_branch_id ON public.assets USING btree (branch_id);


--
-- Name: idx_assets_sub_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assets_sub_category_id ON public.assets USING btree (sub_category_id);


--
-- Name: assets assets_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: assets assets_sub_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_sub_category_id_fkey FOREIGN KEY (sub_category_id) REFERENCES public.asset_sub_categories(id) ON DELETE RESTRICT;


--
-- Name: assets Allow all access to assets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to assets" ON public.assets USING (true) WITH CHECK (true);


--
-- Name: assets; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.assets ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE assets; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.assets TO anon;
GRANT ALL ON TABLE public.assets TO authenticated;
GRANT ALL ON TABLE public.assets TO service_role;
GRANT SELECT ON TABLE public.assets TO replication_user;


--
-- Name: SEQUENCE assets_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.assets_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.assets_id_seq TO anon;
GRANT SELECT,USAGE ON SEQUENCE public.assets_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.assets_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

