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
-- Name: flyer_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flyer_offers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_id text DEFAULT (gen_random_uuid())::text NOT NULL,
    template_name text NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    offer_name text,
    offer_name_id text,
    CONSTRAINT flyer_offers_dates_check CHECK ((end_date >= start_date))
);


--
-- Name: TABLE flyer_offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.flyer_offers IS 'Stores flyer offer campaigns and templates';


--
-- Name: COLUMN flyer_offers.template_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offers.template_id IS 'Unique template identifier for the offer';


--
-- Name: COLUMN flyer_offers.template_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offers.template_name IS 'Display name for the offer template';


--
-- Name: COLUMN flyer_offers.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offers.is_active IS 'Whether this offer is currently active';


--
-- Name: COLUMN flyer_offers.offer_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offers.offer_name IS 'Optional custom name for the offer, in addition to the template name';


--
-- Name: COLUMN flyer_offers.offer_name_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offers.offer_name_id IS 'Reference to predefined offer name from offer_names table';


--
-- Name: CONSTRAINT flyer_offers_dates_check ON flyer_offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT flyer_offers_dates_check ON public.flyer_offers IS 'Ensures end date is not before start date';


--
-- Name: flyer_offers flyer_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offers
    ADD CONSTRAINT flyer_offers_pkey PRIMARY KEY (id);


--
-- Name: flyer_offers flyer_offers_template_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offers
    ADD CONSTRAINT flyer_offers_template_id_key UNIQUE (template_id);


--
-- Name: idx_flyer_offers_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_offers_dates ON public.flyer_offers USING btree (start_date, end_date);


--
-- Name: idx_flyer_offers_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_offers_is_active ON public.flyer_offers USING btree (is_active);


--
-- Name: idx_flyer_offers_offer_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_offers_offer_name ON public.flyer_offers USING btree (offer_name);


--
-- Name: idx_flyer_offers_offer_name_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_offers_offer_name_id ON public.flyer_offers USING btree (offer_name_id);


--
-- Name: idx_flyer_offers_template_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_offers_template_id ON public.flyer_offers USING btree (template_id);


--
-- Name: flyer_offers update_flyer_offers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_flyer_offers_updated_at BEFORE UPDATE ON public.flyer_offers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: flyer_offers flyer_offers_offer_name_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offers
    ADD CONSTRAINT flyer_offers_offer_name_id_fkey FOREIGN KEY (offer_name_id) REFERENCES public.offer_names(id) ON DELETE SET NULL;


--
-- Name: flyer_offers Allow anon insert flyer_offers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert flyer_offers" ON public.flyer_offers FOR INSERT TO anon WITH CHECK (true);


--
-- Name: flyer_offers allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.flyer_offers USING (true) WITH CHECK (true);


--
-- Name: flyer_offers allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.flyer_offers FOR DELETE USING (true);


--
-- Name: flyer_offers allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.flyer_offers FOR INSERT WITH CHECK (true);


--
-- Name: flyer_offers allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.flyer_offers FOR SELECT USING (true);


--
-- Name: flyer_offers allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.flyer_offers FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: flyer_offers anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.flyer_offers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: flyer_offers authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.flyer_offers USING ((auth.uid() IS NOT NULL));


--
-- Name: flyer_offers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.flyer_offers ENABLE ROW LEVEL SECURITY;

--
-- Name: flyer_offers flyer_offers_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY flyer_offers_delete_policy ON public.flyer_offers FOR DELETE TO authenticated USING (true);


--
-- Name: flyer_offers flyer_offers_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY flyer_offers_insert_policy ON public.flyer_offers FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: flyer_offers flyer_offers_select_all_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY flyer_offers_select_all_policy ON public.flyer_offers FOR SELECT TO authenticated USING (true);


--
-- Name: POLICY flyer_offers_select_all_policy ON flyer_offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY flyer_offers_select_all_policy ON public.flyer_offers IS 'Allows authenticated users to view all flyer offers including inactive';


--
-- Name: flyer_offers flyer_offers_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY flyer_offers_select_policy ON public.flyer_offers FOR SELECT USING ((is_active = true));


--
-- Name: POLICY flyer_offers_select_policy ON flyer_offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY flyer_offers_select_policy ON public.flyer_offers IS 'Allows public read access to active flyer offers only';


--
-- Name: flyer_offers flyer_offers_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY flyer_offers_update_policy ON public.flyer_offers FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: TABLE flyer_offers; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.flyer_offers TO anon;
GRANT SELECT ON TABLE public.flyer_offers TO authenticated;
GRANT ALL ON TABLE public.flyer_offers TO service_role;
GRANT SELECT ON TABLE public.flyer_offers TO replication_user;


--
-- PostgreSQL database dump complete
--

