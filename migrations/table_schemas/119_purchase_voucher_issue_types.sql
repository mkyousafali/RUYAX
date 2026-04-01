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
-- Name: purchase_voucher_issue_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_voucher_issue_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type_name character varying NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: purchase_voucher_issue_types purchase_voucher_issue_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_issue_types
    ADD CONSTRAINT purchase_voucher_issue_types_pkey PRIMARY KEY (id);


--
-- Name: purchase_voucher_issue_types purchase_voucher_issue_types_type_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_issue_types
    ADD CONSTRAINT purchase_voucher_issue_types_type_name_key UNIQUE (type_name);


--
-- Name: idx_issue_types_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_issue_types_name ON public.purchase_voucher_issue_types USING btree (type_name);


--
-- Name: purchase_voucher_issue_types issue_types_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER issue_types_updated_at_trigger BEFORE UPDATE ON public.purchase_voucher_issue_types FOR EACH ROW EXECUTE FUNCTION public.update_issue_types_updated_at();


--
-- Name: purchase_voucher_issue_types; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.purchase_voucher_issue_types ENABLE ROW LEVEL SECURITY;

--
-- Name: purchase_voucher_issue_types pv_issue_types_authenticated_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY pv_issue_types_authenticated_all ON public.purchase_voucher_issue_types USING (true);


--
-- Name: purchase_voucher_issue_types pv_issue_types_service_role_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY pv_issue_types_service_role_all ON public.purchase_voucher_issue_types USING (true);


--
-- Name: TABLE purchase_voucher_issue_types; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.purchase_voucher_issue_types TO anon;
GRANT ALL ON TABLE public.purchase_voucher_issue_types TO authenticated;
GRANT ALL ON TABLE public.purchase_voucher_issue_types TO service_role;
GRANT SELECT ON TABLE public.purchase_voucher_issue_types TO replication_user;


--
-- PostgreSQL database dump complete
--

