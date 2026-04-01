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
-- Name: product_units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_units (
    id character varying(10) NOT NULL,
    name_en character varying(50) NOT NULL,
    name_ar character varying(50) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: product_units product_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_units
    ADD CONSTRAINT product_units_pkey PRIMARY KEY (id);


--
-- Name: idx_product_units_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_units_is_active ON public.product_units USING btree (is_active);


--
-- Name: product_units product_units_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_units
    ADD CONSTRAINT product_units_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: product_units Allow all access to product_units; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to product_units" ON public.product_units USING (true) WITH CHECK (true);


--
-- Name: product_units; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_units ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE product_units; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.product_units TO anon;
GRANT ALL ON TABLE public.product_units TO authenticated;
GRANT ALL ON TABLE public.product_units TO service_role;
GRANT SELECT ON TABLE public.product_units TO replication_user;


--
-- PostgreSQL database dump complete
--

