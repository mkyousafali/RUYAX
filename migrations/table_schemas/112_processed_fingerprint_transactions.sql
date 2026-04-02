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
-- Name: processed_fingerprint_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.processed_fingerprint_transactions (
    id text NOT NULL,
    center_id text NOT NULL,
    employee_id text NOT NULL,
    branch_id text NOT NULL,
    punch_date date NOT NULL,
    punch_time time without time zone NOT NULL,
    status text,
    processed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: processed_fingerprint_transactions processed_fingerprint_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.processed_fingerprint_transactions
    ADD CONSTRAINT processed_fingerprint_transactions_pkey PRIMARY KEY (id);


--
-- Name: idx_processed_fingerprint_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_processed_fingerprint_branch_id ON public.processed_fingerprint_transactions USING btree (branch_id);


--
-- Name: idx_processed_fingerprint_center_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_processed_fingerprint_center_id ON public.processed_fingerprint_transactions USING btree (center_id);


--
-- Name: idx_processed_fingerprint_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_processed_fingerprint_employee_id ON public.processed_fingerprint_transactions USING btree (employee_id);


--
-- Name: idx_processed_fingerprint_punch_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_processed_fingerprint_punch_date ON public.processed_fingerprint_transactions USING btree (punch_date);


--
-- Name: processed_fingerprint_transactions processed_fingerprint_transactions_center_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.processed_fingerprint_transactions
    ADD CONSTRAINT processed_fingerprint_transactions_center_id_fkey FOREIGN KEY (center_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: processed_fingerprint_transactions Allow all access to processed_fingerprint_transactions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to processed_fingerprint_transactions" ON public.processed_fingerprint_transactions USING (true) WITH CHECK (true);


--
-- Name: processed_fingerprint_transactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.processed_fingerprint_transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE processed_fingerprint_transactions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.processed_fingerprint_transactions TO anon;
GRANT ALL ON TABLE public.processed_fingerprint_transactions TO authenticated;
GRANT ALL ON TABLE public.processed_fingerprint_transactions TO service_role;
GRANT SELECT ON TABLE public.processed_fingerprint_transactions TO replication_user;


--
-- PostgreSQL database dump complete
--

