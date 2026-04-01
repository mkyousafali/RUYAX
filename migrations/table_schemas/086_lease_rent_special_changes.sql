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
-- Name: lease_rent_special_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lease_rent_special_changes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    party_type character varying(10) NOT NULL,
    party_id uuid NOT NULL,
    field_name character varying(50) NOT NULL,
    old_value numeric(12,2) DEFAULT 0,
    new_value numeric(12,2) NOT NULL,
    effective_from date NOT NULL,
    effective_until date,
    till_end_of_contract boolean DEFAULT false,
    payment_period character varying(20) DEFAULT 'monthly'::character varying,
    reason text,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    CONSTRAINT lease_rent_special_changes_party_type_check CHECK (((party_type)::text = ANY ((ARRAY['rent'::character varying, 'lease'::character varying])::text[])))
);


--
-- Name: lease_rent_special_changes lease_rent_special_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_special_changes
    ADD CONSTRAINT lease_rent_special_changes_pkey PRIMARY KEY (id);


--
-- Name: idx_special_changes_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_special_changes_dates ON public.lease_rent_special_changes USING btree (effective_from, effective_until);


--
-- Name: idx_special_changes_party; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_special_changes_party ON public.lease_rent_special_changes USING btree (party_type, party_id);


--
-- Name: lease_rent_special_changes lease_rent_special_changes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_special_changes
    ADD CONSTRAINT lease_rent_special_changes_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: lease_rent_special_changes allow_all_lease_rent_special_changes; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_lease_rent_special_changes ON public.lease_rent_special_changes USING (true) WITH CHECK (true);


--
-- Name: lease_rent_special_changes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lease_rent_special_changes ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE lease_rent_special_changes; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.lease_rent_special_changes TO anon;
GRANT ALL ON TABLE public.lease_rent_special_changes TO authenticated;
GRANT ALL ON TABLE public.lease_rent_special_changes TO service_role;
GRANT SELECT ON TABLE public.lease_rent_special_changes TO replication_user;


--
-- PostgreSQL database dump complete
--

