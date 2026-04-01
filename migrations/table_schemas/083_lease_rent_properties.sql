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
-- Name: lease_rent_properties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lease_rent_properties (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    location_en character varying(500),
    location_ar character varying(500),
    is_leased boolean DEFAULT false,
    is_rented boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: lease_rent_properties lease_rent_property_spaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_properties
    ADD CONSTRAINT lease_rent_property_spaces_pkey PRIMARY KEY (id);


--
-- Name: idx_lease_rent_properties_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lease_rent_properties_created_by ON public.lease_rent_properties USING btree (created_by);


--
-- Name: idx_lease_rent_properties_is_leased; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lease_rent_properties_is_leased ON public.lease_rent_properties USING btree (is_leased);


--
-- Name: idx_lease_rent_properties_is_rented; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lease_rent_properties_is_rented ON public.lease_rent_properties USING btree (is_rented);


--
-- Name: lease_rent_properties lease_rent_properties_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER lease_rent_properties_timestamp_update BEFORE UPDATE ON public.lease_rent_properties FOR EACH ROW EXECUTE FUNCTION public.update_lease_rent_property_spaces_timestamp();


--
-- Name: lease_rent_properties lease_rent_property_spaces_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_properties
    ADD CONSTRAINT lease_rent_property_spaces_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: lease_rent_properties Allow all access to lease_rent_properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to lease_rent_properties" ON public.lease_rent_properties USING (true) WITH CHECK (true);


--
-- Name: lease_rent_properties; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lease_rent_properties ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE lease_rent_properties; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.lease_rent_properties TO anon;
GRANT ALL ON TABLE public.lease_rent_properties TO authenticated;
GRANT ALL ON TABLE public.lease_rent_properties TO service_role;
GRANT SELECT ON TABLE public.lease_rent_properties TO replication_user;


--
-- PostgreSQL database dump complete
--

