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
-- Name: customer_access_code_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_access_code_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    old_access_code text,
    new_access_code text NOT NULL,
    generated_by uuid NOT NULL,
    reason text NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT customer_access_code_history_reason_check CHECK ((reason = ANY (ARRAY['initial_generation'::text, 'admin_regeneration'::text, 'security_reset'::text, 'customer_request'::text, 're_registration'::text, 'forgot_code_resend'::text, 'pre_registered_upgrade'::text])))
);


--
-- Name: TABLE customer_access_code_history; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.customer_access_code_history IS 'Audit trail of customer access code changes';


--
-- Name: COLUMN customer_access_code_history.reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customer_access_code_history.reason IS 'Reason for access code change';


--
-- Name: customer_access_code_history customer_access_code_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_access_code_history
    ADD CONSTRAINT customer_access_code_history_pkey PRIMARY KEY (id);


--
-- Name: idx_customer_access_code_history_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_access_code_history_created_at ON public.customer_access_code_history USING btree (created_at);


--
-- Name: idx_customer_access_code_history_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_access_code_history_customer_id ON public.customer_access_code_history USING btree (customer_id);


--
-- Name: idx_customer_access_code_history_generated_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_access_code_history_generated_by ON public.customer_access_code_history USING btree (generated_by);


--
-- Name: customer_access_code_history customer_access_code_history_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_access_code_history
    ADD CONSTRAINT customer_access_code_history_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: customer_access_code_history customer_access_code_history_generated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_access_code_history
    ADD CONSTRAINT customer_access_code_history_generated_by_fkey FOREIGN KEY (generated_by) REFERENCES public.users(id);


--
-- Name: customer_access_code_history Allow anon insert customer_access_code_history; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert customer_access_code_history" ON public.customer_access_code_history FOR INSERT TO anon WITH CHECK (true);


--
-- Name: customer_access_code_history allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.customer_access_code_history USING (true) WITH CHECK (true);


--
-- Name: customer_access_code_history allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.customer_access_code_history FOR DELETE USING (true);


--
-- Name: customer_access_code_history allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.customer_access_code_history FOR INSERT WITH CHECK (true);


--
-- Name: customer_access_code_history allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.customer_access_code_history FOR SELECT USING (true);


--
-- Name: customer_access_code_history allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.customer_access_code_history FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: customer_access_code_history anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.customer_access_code_history USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: customer_access_code_history authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.customer_access_code_history USING ((auth.uid() IS NOT NULL));


--
-- Name: customer_access_code_history; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer_access_code_history ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_access_code_history customer_access_code_history_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY customer_access_code_history_insert_policy ON public.customer_access_code_history FOR INSERT WITH CHECK (true);


--
-- Name: customer_access_code_history customer_access_code_history_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY customer_access_code_history_select_policy ON public.customer_access_code_history FOR SELECT USING (true);


--
-- Name: customer_access_code_history realtime_access_code_history_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY realtime_access_code_history_select ON public.customer_access_code_history FOR SELECT TO authenticated, anon USING (true);


--
-- Name: TABLE customer_access_code_history; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customer_access_code_history TO anon;
GRANT SELECT ON TABLE public.customer_access_code_history TO authenticated;
GRANT ALL ON TABLE public.customer_access_code_history TO service_role;
GRANT SELECT ON TABLE public.customer_access_code_history TO replication_user;


--
-- PostgreSQL database dump complete
--

