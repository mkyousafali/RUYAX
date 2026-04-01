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
-- Name: denomination_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.denomination_transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    section character varying(20) NOT NULL,
    transaction_type character varying(50) NOT NULL,
    amount numeric(15,2) NOT NULL,
    remarks text,
    apply_denomination boolean DEFAULT false,
    denomination_details jsonb DEFAULT '{}'::jsonb,
    entity_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid NOT NULL,
    CONSTRAINT denomination_transactions_section_check CHECK (((section)::text = ANY ((ARRAY['paid'::character varying, 'received'::character varying])::text[]))),
    CONSTRAINT denomination_transactions_transaction_type_check CHECK (((transaction_type)::text = ANY ((ARRAY['vendor'::character varying, 'expenses'::character varying, 'user'::character varying, 'other'::character varying])::text[])))
);


--
-- Name: denomination_transactions denomination_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_transactions
    ADD CONSTRAINT denomination_transactions_pkey PRIMARY KEY (id);


--
-- Name: idx_denomination_transactions_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_transactions_branch_id ON public.denomination_transactions USING btree (branch_id);


--
-- Name: idx_denomination_transactions_branch_section; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_transactions_branch_section ON public.denomination_transactions USING btree (branch_id, section);


--
-- Name: idx_denomination_transactions_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_transactions_created_at ON public.denomination_transactions USING btree (created_at DESC);


--
-- Name: idx_denomination_transactions_section; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_transactions_section ON public.denomination_transactions USING btree (section);


--
-- Name: idx_denomination_transactions_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_transactions_type ON public.denomination_transactions USING btree (transaction_type);


--
-- Name: denomination_transactions denomination_transactions_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER denomination_transactions_timestamp_update BEFORE UPDATE ON public.denomination_transactions FOR EACH ROW EXECUTE FUNCTION public.update_denomination_transactions_timestamp();


--
-- Name: denomination_transactions denomination_transactions_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_transactions
    ADD CONSTRAINT denomination_transactions_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: denomination_transactions denomination_transactions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_transactions
    ADD CONSTRAINT denomination_transactions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: denomination_transactions Allow all access to denomination_transactions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to denomination_transactions" ON public.denomination_transactions USING (true) WITH CHECK (true);


--
-- Name: denomination_transactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.denomination_transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE denomination_transactions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.denomination_transactions TO anon;
GRANT ALL ON TABLE public.denomination_transactions TO authenticated;
GRANT ALL ON TABLE public.denomination_transactions TO service_role;
GRANT SELECT ON TABLE public.denomination_transactions TO replication_user;


--
-- PostgreSQL database dump complete
--

