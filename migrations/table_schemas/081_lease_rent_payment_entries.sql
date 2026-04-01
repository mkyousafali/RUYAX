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
-- Name: lease_rent_payment_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lease_rent_payment_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    party_type character varying(10) NOT NULL,
    party_id uuid NOT NULL,
    period_num integer NOT NULL,
    column_name character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    paid_date date DEFAULT CURRENT_DATE NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: lease_rent_payment_entries lease_rent_payment_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_payment_entries
    ADD CONSTRAINT lease_rent_payment_entries_pkey PRIMARY KEY (id);


--
-- Name: idx_payment_entries_party; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payment_entries_party ON public.lease_rent_payment_entries USING btree (party_type, party_id, period_num, column_name);


--
-- Name: lease_rent_payment_entries allow_all_payment_entries; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_payment_entries ON public.lease_rent_payment_entries USING (true) WITH CHECK (true);


--
-- Name: lease_rent_payment_entries; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lease_rent_payment_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE lease_rent_payment_entries; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.lease_rent_payment_entries TO anon;
GRANT ALL ON TABLE public.lease_rent_payment_entries TO authenticated;
GRANT ALL ON TABLE public.lease_rent_payment_entries TO service_role;
GRANT SELECT ON TABLE public.lease_rent_payment_entries TO replication_user;


--
-- PostgreSQL database dump complete
--

