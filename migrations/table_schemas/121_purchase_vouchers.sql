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
-- Name: purchase_vouchers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_vouchers (
    id character varying NOT NULL,
    book_number character varying NOT NULL,
    serial_start integer NOT NULL,
    serial_end integer NOT NULL,
    voucher_count integer NOT NULL,
    per_voucher_value numeric NOT NULL,
    total_value numeric NOT NULL,
    status character varying DEFAULT 'active'::character varying,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: purchase_vouchers purchase_vouchers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_vouchers
    ADD CONSTRAINT purchase_vouchers_pkey PRIMARY KEY (id);


--
-- Name: idx_purchase_vouchers_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_vouchers_created_at ON public.purchase_vouchers USING btree (created_at);


--
-- Name: idx_purchase_vouchers_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_vouchers_status ON public.purchase_vouchers USING btree (status);


--
-- Name: purchase_vouchers purchase_vouchers_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER purchase_vouchers_updated_at_trigger BEFORE UPDATE ON public.purchase_vouchers FOR EACH ROW EXECUTE FUNCTION public.update_purchase_vouchers_updated_at();


--
-- Name: purchase_vouchers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.purchase_vouchers ENABLE ROW LEVEL SECURITY;

--
-- Name: purchase_vouchers pv_authenticated_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY pv_authenticated_all ON public.purchase_vouchers USING (true);


--
-- Name: purchase_vouchers pv_service_role_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY pv_service_role_all ON public.purchase_vouchers USING (true);


--
-- Name: TABLE purchase_vouchers; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.purchase_vouchers TO anon;
GRANT ALL ON TABLE public.purchase_vouchers TO authenticated;
GRANT ALL ON TABLE public.purchase_vouchers TO service_role;
GRANT SELECT ON TABLE public.purchase_vouchers TO replication_user;


--
-- PostgreSQL database dump complete
--

