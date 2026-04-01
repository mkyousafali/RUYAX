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
-- Name: bank_reconciliations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bank_reconciliations (
    id integer NOT NULL,
    operation_id uuid NOT NULL,
    branch_id integer,
    pos_number integer DEFAULT 1 NOT NULL,
    supervisor_id uuid,
    cashier_id uuid,
    reconciliation_number character varying(100) DEFAULT ''::character varying NOT NULL,
    mada_amount numeric(12,2) DEFAULT 0 NOT NULL,
    visa_amount numeric(12,2) DEFAULT 0 NOT NULL,
    mastercard_amount numeric(12,2) DEFAULT 0 NOT NULL,
    google_pay_amount numeric(12,2) DEFAULT 0 NOT NULL,
    other_amount numeric(12,2) DEFAULT 0 NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: bank_reconciliations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bank_reconciliations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_reconciliations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bank_reconciliations_id_seq OWNED BY public.bank_reconciliations.id;


--
-- Name: bank_reconciliations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations ALTER COLUMN id SET DEFAULT nextval('public.bank_reconciliations_id_seq'::regclass);


--
-- Name: bank_reconciliations bank_reconciliations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_pkey PRIMARY KEY (id);


--
-- Name: idx_bank_reconciliations_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bank_reconciliations_branch_id ON public.bank_reconciliations USING btree (branch_id);


--
-- Name: idx_bank_reconciliations_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bank_reconciliations_created_at ON public.bank_reconciliations USING btree (created_at);


--
-- Name: idx_bank_reconciliations_operation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bank_reconciliations_operation_id ON public.bank_reconciliations USING btree (operation_id);


--
-- Name: bank_reconciliations bank_reconciliations_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER bank_reconciliations_timestamp_update BEFORE UPDATE ON public.bank_reconciliations FOR EACH ROW EXECUTE FUNCTION public.update_bank_reconciliations_timestamp();


--
-- Name: bank_reconciliations bank_reconciliations_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: bank_reconciliations bank_reconciliations_cashier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_cashier_id_fkey FOREIGN KEY (cashier_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: bank_reconciliations bank_reconciliations_operation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_operation_id_fkey FOREIGN KEY (operation_id) REFERENCES public.box_operations(id) ON DELETE CASCADE;


--
-- Name: bank_reconciliations bank_reconciliations_supervisor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_supervisor_id_fkey FOREIGN KEY (supervisor_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: bank_reconciliations Allow all access to bank_reconciliations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to bank_reconciliations" ON public.bank_reconciliations USING (true) WITH CHECK (true);


--
-- Name: bank_reconciliations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.bank_reconciliations ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE bank_reconciliations; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.bank_reconciliations TO anon;
GRANT ALL ON TABLE public.bank_reconciliations TO authenticated;
GRANT ALL ON TABLE public.bank_reconciliations TO service_role;
GRANT SELECT ON TABLE public.bank_reconciliations TO replication_user;


--
-- Name: SEQUENCE bank_reconciliations_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.bank_reconciliations_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.bank_reconciliations_id_seq TO authenticated;
GRANT SELECT,USAGE ON SEQUENCE public.bank_reconciliations_id_seq TO anon;


--
-- PostgreSQL database dump complete
--

