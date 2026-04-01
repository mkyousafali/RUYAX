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
-- Name: deleted_bundle_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deleted_bundle_offers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    original_offer_id integer NOT NULL,
    offer_data jsonb NOT NULL,
    bundles_data jsonb NOT NULL,
    deleted_at timestamp with time zone DEFAULT now(),
    deleted_by uuid,
    deletion_reason text
);


--
-- Name: TABLE deleted_bundle_offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.deleted_bundle_offers IS 'Archive table for deleted bundle offers - allows recovery and audit trail';


--
-- Name: COLUMN deleted_bundle_offers.original_offer_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.deleted_bundle_offers.original_offer_id IS 'The original offer ID from offers table (INTEGER)';


--
-- Name: COLUMN deleted_bundle_offers.offer_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.deleted_bundle_offers.offer_data IS 'Complete offer data as JSON';


--
-- Name: COLUMN deleted_bundle_offers.bundles_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.deleted_bundle_offers.bundles_data IS 'Array of bundle data as JSON';


--
-- Name: COLUMN deleted_bundle_offers.deleted_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.deleted_bundle_offers.deleted_by IS 'User who deleted the offer';


--
-- Name: COLUMN deleted_bundle_offers.deletion_reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.deleted_bundle_offers.deletion_reason IS 'Optional reason for deletion';


--
-- Name: deleted_bundle_offers deleted_bundle_offers_original_offer_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deleted_bundle_offers
    ADD CONSTRAINT deleted_bundle_offers_original_offer_id_key UNIQUE (original_offer_id);


--
-- Name: deleted_bundle_offers deleted_bundle_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deleted_bundle_offers
    ADD CONSTRAINT deleted_bundle_offers_pkey PRIMARY KEY (id);


--
-- Name: idx_deleted_bundle_offers_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_deleted_bundle_offers_deleted_at ON public.deleted_bundle_offers USING btree (deleted_at DESC);


--
-- Name: idx_deleted_bundle_offers_deleted_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_deleted_bundle_offers_deleted_by ON public.deleted_bundle_offers USING btree (deleted_by);


--
-- Name: idx_deleted_bundle_offers_original_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_deleted_bundle_offers_original_id ON public.deleted_bundle_offers USING btree (original_offer_id);


--
-- Name: deleted_bundle_offers deleted_bundle_offers_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deleted_bundle_offers
    ADD CONSTRAINT deleted_bundle_offers_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES public.users(id);


--
-- Name: deleted_bundle_offers Allow anon insert deleted_bundle_offers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert deleted_bundle_offers" ON public.deleted_bundle_offers FOR INSERT TO anon WITH CHECK (true);


--
-- Name: deleted_bundle_offers Allow authenticated users to archive offers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to archive offers" ON public.deleted_bundle_offers FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: deleted_bundle_offers Allow authenticated users to view deleted offers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to view deleted offers" ON public.deleted_bundle_offers FOR SELECT TO authenticated USING (true);


--
-- Name: deleted_bundle_offers allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.deleted_bundle_offers USING (true) WITH CHECK (true);


--
-- Name: deleted_bundle_offers allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.deleted_bundle_offers FOR DELETE USING (true);


--
-- Name: deleted_bundle_offers allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.deleted_bundle_offers FOR INSERT WITH CHECK (true);


--
-- Name: deleted_bundle_offers allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.deleted_bundle_offers FOR SELECT USING (true);


--
-- Name: deleted_bundle_offers allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.deleted_bundle_offers FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: deleted_bundle_offers anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.deleted_bundle_offers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: deleted_bundle_offers authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.deleted_bundle_offers USING ((auth.uid() IS NOT NULL));


--
-- Name: deleted_bundle_offers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.deleted_bundle_offers ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE deleted_bundle_offers; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.deleted_bundle_offers TO anon;
GRANT SELECT ON TABLE public.deleted_bundle_offers TO authenticated;
GRANT ALL ON TABLE public.deleted_bundle_offers TO service_role;
GRANT SELECT ON TABLE public.deleted_bundle_offers TO replication_user;


--
-- PostgreSQL database dump complete
--

