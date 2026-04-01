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
-- Name: lease_rent_lease_parties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lease_rent_lease_parties (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    property_space_id uuid,
    party_name_en character varying(255) NOT NULL,
    party_name_ar character varying(255) NOT NULL,
    shop_name character varying(255),
    contract_start_date date,
    contract_end_date date,
    lease_amount_contract numeric(12,2) DEFAULT 0,
    lease_amount_outside_contract numeric(12,2) DEFAULT 0,
    utility_charges numeric(12,2) DEFAULT 0,
    security_charges numeric(12,2) DEFAULT 0,
    other_charges jsonb DEFAULT '[]'::jsonb,
    payment_mode character varying(20) DEFAULT 'cash'::character varying,
    collection_incharge_id text,
    payment_period character varying(30) DEFAULT 'monthly'::character varying,
    payment_specific_date integer,
    payment_end_of_month boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_open_contract boolean DEFAULT false,
    contact_number character varying(50),
    email character varying(255)
);


--
-- Name: lease_rent_lease_parties lease_rent_lease_parties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_pkey PRIMARY KEY (id);


--
-- Name: idx_lrlp_collection_incharge; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lrlp_collection_incharge ON public.lease_rent_lease_parties USING btree (collection_incharge_id);


--
-- Name: idx_lrlp_contract_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lrlp_contract_dates ON public.lease_rent_lease_parties USING btree (contract_start_date, contract_end_date);


--
-- Name: idx_lrlp_payment_mode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lrlp_payment_mode ON public.lease_rent_lease_parties USING btree (payment_mode);


--
-- Name: idx_lrlp_property_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lrlp_property_id ON public.lease_rent_lease_parties USING btree (property_id);


--
-- Name: idx_lrlp_property_space_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lrlp_property_space_id ON public.lease_rent_lease_parties USING btree (property_space_id);


--
-- Name: lease_rent_lease_parties lease_rent_lease_parties_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER lease_rent_lease_parties_timestamp_update BEFORE UPDATE ON public.lease_rent_lease_parties FOR EACH ROW EXECUTE FUNCTION public.update_lease_rent_lease_parties_timestamp();


--
-- Name: lease_rent_lease_parties lease_rent_lease_parties_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: lease_rent_lease_parties lease_rent_lease_parties_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.lease_rent_properties(id) ON DELETE CASCADE;


--
-- Name: lease_rent_lease_parties lease_rent_lease_parties_property_space_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_property_space_id_fkey FOREIGN KEY (property_space_id) REFERENCES public.lease_rent_property_spaces(id) ON DELETE SET NULL;


--
-- Name: lease_rent_lease_parties Allow all access to lease_rent_lease_parties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to lease_rent_lease_parties" ON public.lease_rent_lease_parties USING (true) WITH CHECK (true);


--
-- Name: lease_rent_lease_parties; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lease_rent_lease_parties ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE lease_rent_lease_parties; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.lease_rent_lease_parties TO anon;
GRANT ALL ON TABLE public.lease_rent_lease_parties TO authenticated;
GRANT ALL ON TABLE public.lease_rent_lease_parties TO service_role;
GRANT SELECT ON TABLE public.lease_rent_lease_parties TO replication_user;


--
-- PostgreSQL database dump complete
--

