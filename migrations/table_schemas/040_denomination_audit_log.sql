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
-- Name: denomination_audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.denomination_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    record_id uuid NOT NULL,
    branch_id integer NOT NULL,
    user_id uuid NOT NULL,
    action character varying(10) NOT NULL,
    record_type character varying(30) NOT NULL,
    box_number smallint,
    old_counts jsonb,
    new_counts jsonb,
    old_erp_balance numeric(15,2),
    new_erp_balance numeric(15,2),
    old_grand_total numeric(15,2),
    new_grand_total numeric(15,2),
    old_difference numeric(15,2),
    new_difference numeric(15,2),
    change_reason text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT denomination_audit_log_action_check CHECK (((action)::text = ANY ((ARRAY['INSERT'::character varying, 'UPDATE'::character varying, 'DELETE'::character varying])::text[])))
);


--
-- Name: TABLE denomination_audit_log; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.denomination_audit_log IS 'Automatic audit log for all denomination record changes (INSERT, UPDATE, DELETE)';


--
-- Name: denomination_audit_log denomination_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_audit_log
    ADD CONSTRAINT denomination_audit_log_pkey PRIMARY KEY (id);


--
-- Name: idx_denomination_audit_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_audit_action ON public.denomination_audit_log USING btree (action);


--
-- Name: idx_denomination_audit_branch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_audit_branch ON public.denomination_audit_log USING btree (branch_id);


--
-- Name: idx_denomination_audit_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_audit_created ON public.denomination_audit_log USING btree (created_at DESC);


--
-- Name: idx_denomination_audit_record; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_audit_record ON public.denomination_audit_log USING btree (record_id);


--
-- Name: idx_denomination_audit_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_audit_user ON public.denomination_audit_log USING btree (user_id);


--
-- Name: denomination_audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.denomination_audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: denomination_audit_log denomination_audit_log_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY denomination_audit_log_insert ON public.denomination_audit_log FOR INSERT WITH CHECK (true);


--
-- Name: denomination_audit_log denomination_audit_log_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY denomination_audit_log_select ON public.denomination_audit_log FOR SELECT USING (true);


--
-- Name: TABLE denomination_audit_log; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.denomination_audit_log TO anon;
GRANT ALL ON TABLE public.denomination_audit_log TO authenticated;
GRANT ALL ON TABLE public.denomination_audit_log TO service_role;
GRANT SELECT ON TABLE public.denomination_audit_log TO replication_user;


--
-- PostgreSQL database dump complete
--

