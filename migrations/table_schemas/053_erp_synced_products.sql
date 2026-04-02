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
-- Name: erp_synced_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.erp_synced_products (
    id integer NOT NULL,
    barcode character varying(50) NOT NULL,
    auto_barcode character varying(50),
    parent_barcode character varying(50),
    product_name_en character varying(500),
    product_name_ar character varying(500),
    unit_name character varying(100),
    unit_qty numeric(18,6) DEFAULT 1,
    is_base_unit boolean DEFAULT false,
    synced_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    expiry_dates jsonb DEFAULT '[]'::jsonb,
    managed_by jsonb DEFAULT '[]'::jsonb,
    in_process jsonb DEFAULT '[]'::jsonb,
    expiry_hidden boolean DEFAULT false
);


--
-- Name: erp_synced_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.erp_synced_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: erp_synced_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.erp_synced_products_id_seq OWNED BY public.erp_synced_products.id;


--
-- Name: erp_synced_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_synced_products ALTER COLUMN id SET DEFAULT nextval('public.erp_synced_products_id_seq'::regclass);


--
-- Name: erp_synced_products erp_synced_products_barcode_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_synced_products
    ADD CONSTRAINT erp_synced_products_barcode_key UNIQUE (barcode);


--
-- Name: erp_synced_products erp_synced_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_synced_products
    ADD CONSTRAINT erp_synced_products_pkey PRIMARY KEY (id);


--
-- Name: idx_erp_synced_products_barcode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_erp_synced_products_barcode ON public.erp_synced_products USING btree (barcode);


--
-- Name: idx_erp_synced_products_expiry_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_erp_synced_products_expiry_dates ON public.erp_synced_products USING gin (expiry_dates);


--
-- Name: idx_erp_synced_products_expiry_hidden; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_erp_synced_products_expiry_hidden ON public.erp_synced_products USING btree (expiry_hidden) WHERE (expiry_hidden = true);


--
-- Name: idx_erp_synced_products_in_process; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_erp_synced_products_in_process ON public.erp_synced_products USING gin (in_process);


--
-- Name: idx_erp_synced_products_managed_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_erp_synced_products_managed_by ON public.erp_synced_products USING gin (managed_by);


--
-- Name: idx_erp_synced_products_parent_barcode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_erp_synced_products_parent_barcode ON public.erp_synced_products USING btree (parent_barcode);


--
-- Name: idx_erp_synced_products_product_name_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_erp_synced_products_product_name_en ON public.erp_synced_products USING btree (product_name_en);


--
-- Name: erp_synced_products Allow all access to erp_synced_products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to erp_synced_products" ON public.erp_synced_products USING (true) WITH CHECK (true);


--
-- Name: erp_synced_products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.erp_synced_products ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE erp_synced_products; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.erp_synced_products TO anon;
GRANT ALL ON TABLE public.erp_synced_products TO authenticated;
GRANT ALL ON TABLE public.erp_synced_products TO service_role;
GRANT SELECT ON TABLE public.erp_synced_products TO replication_user;


--
-- Name: SEQUENCE erp_synced_products_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.erp_synced_products_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.erp_synced_products_id_seq TO authenticated;
GRANT SELECT,USAGE ON SEQUENCE public.erp_synced_products_id_seq TO anon;
GRANT SELECT ON SEQUENCE public.erp_synced_products_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

