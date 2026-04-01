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
-- Name: denomination_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.denomination_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    user_id uuid NOT NULL,
    record_type character varying(30) NOT NULL,
    box_number smallint,
    counts jsonb DEFAULT '{}'::jsonb NOT NULL,
    erp_balance numeric(15,2),
    grand_total numeric(15,2) DEFAULT 0 NOT NULL,
    difference numeric(15,2),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    petty_cash_operation jsonb,
    CONSTRAINT denomination_records_box_number_check CHECK (((box_number IS NULL) OR ((box_number >= 1) AND (box_number <= 12)))),
    CONSTRAINT denomination_records_record_type_check CHECK (((record_type)::text = ANY (ARRAY['main'::text, 'advance_box'::text, 'collection_box'::text, 'paid'::text, 'received'::text, 'petty_cash_box'::text])))
);


--
-- Name: TABLE denomination_records; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.denomination_records IS 'Stores denomination count records for main, boxes, and other sections';


--
-- Name: COLUMN denomination_records.record_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_records.record_type IS 'Type of record: main, advance_box, collection_box, paid, received';


--
-- Name: COLUMN denomination_records.box_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_records.box_number IS 'Box or card number (1-12 for advance boxes, 1-6 for collection boxes, 1-6 for paid/received, null for main)';


--
-- Name: COLUMN denomination_records.counts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_records.counts IS 'JSONB storing denomination counts: {"d500": 10, "d200": 5, ...}';


--
-- Name: COLUMN denomination_records.petty_cash_operation; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_records.petty_cash_operation IS 'JSONB column storing petty cash operation details: {transferred_from_box_number, transferred_from_user_id, closing_details}';


--
-- Name: CONSTRAINT denomination_records_record_type_check ON denomination_records; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT denomination_records_record_type_check ON public.denomination_records IS 'Allowed record types: main (main denomination), advance_box (advance manager boxes), collection_box (collection boxes), paid (paid records), received (received records), petty_cash_box (petty cash transfers)';


--
-- Name: denomination_records denomination_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_records
    ADD CONSTRAINT denomination_records_pkey PRIMARY KEY (id);


--
-- Name: idx_denomination_records_branch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_records_branch ON public.denomination_records USING btree (branch_id);


--
-- Name: idx_denomination_records_branch_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_records_branch_created ON public.denomination_records USING btree (branch_id, created_at DESC);


--
-- Name: idx_denomination_records_branch_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_records_branch_type ON public.denomination_records USING btree (branch_id, record_type);


--
-- Name: idx_denomination_records_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_records_created_at ON public.denomination_records USING btree (created_at);


--
-- Name: idx_denomination_records_history; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_records_history ON public.denomination_records USING btree (branch_id, record_type, created_at DESC);


--
-- Name: idx_denomination_records_petty_cash_operation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_records_petty_cash_operation ON public.denomination_records USING gin (petty_cash_operation);


--
-- Name: idx_denomination_records_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_records_type ON public.denomination_records USING btree (record_type);


--
-- Name: idx_denomination_records_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_records_user ON public.denomination_records USING btree (user_id);


--
-- Name: denomination_records denomination_records_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER denomination_records_audit AFTER INSERT OR DELETE OR UPDATE ON public.denomination_records FOR EACH ROW EXECUTE FUNCTION public.denomination_audit_trigger();


--
-- Name: denomination_records denomination_records_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER denomination_records_updated_at BEFORE UPDATE ON public.denomination_records FOR EACH ROW EXECUTE FUNCTION public.update_denomination_updated_at();


--
-- Name: denomination_records denomination_records_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_records
    ADD CONSTRAINT denomination_records_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: denomination_records denomination_records_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_records
    ADD CONSTRAINT denomination_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: denomination_records; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.denomination_records ENABLE ROW LEVEL SECURITY;

--
-- Name: denomination_records denomination_records_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY denomination_records_delete ON public.denomination_records FOR DELETE USING (true);


--
-- Name: denomination_records denomination_records_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY denomination_records_insert ON public.denomination_records FOR INSERT WITH CHECK (true);


--
-- Name: denomination_records denomination_records_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY denomination_records_select ON public.denomination_records FOR SELECT USING (true);


--
-- Name: denomination_records denomination_records_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY denomination_records_update ON public.denomination_records FOR UPDATE USING (true);


--
-- Name: TABLE denomination_records; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.denomination_records TO anon;
GRANT ALL ON TABLE public.denomination_records TO authenticated;
GRANT ALL ON TABLE public.denomination_records TO service_role;
GRANT SELECT ON TABLE public.denomination_records TO replication_user;


--
-- PostgreSQL database dump complete
--

