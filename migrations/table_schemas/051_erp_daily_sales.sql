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
-- Name: erp_daily_sales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.erp_daily_sales (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    branch_id bigint NOT NULL,
    sale_date date NOT NULL,
    total_bills integer DEFAULT 0,
    gross_amount numeric(18,2) DEFAULT 0,
    tax_amount numeric(18,2) DEFAULT 0,
    discount_amount numeric(18,2) DEFAULT 0,
    total_returns integer DEFAULT 0,
    return_amount numeric(18,2) DEFAULT 0,
    return_tax numeric(18,2) DEFAULT 0,
    net_bills integer DEFAULT 0,
    net_amount numeric(18,2) DEFAULT 0,
    net_tax numeric(18,2) DEFAULT 0,
    last_sync_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: erp_daily_sales erp_daily_sales_branch_id_sale_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_daily_sales
    ADD CONSTRAINT erp_daily_sales_branch_id_sale_date_key UNIQUE (branch_id, sale_date);


--
-- Name: erp_daily_sales erp_daily_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_daily_sales
    ADD CONSTRAINT erp_daily_sales_pkey PRIMARY KEY (id);


--
-- Name: idx_erp_daily_sales_branch_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_erp_daily_sales_branch_date ON public.erp_daily_sales USING btree (branch_id, sale_date);


--
-- Name: idx_erp_daily_sales_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_erp_daily_sales_branch_id ON public.erp_daily_sales USING btree (branch_id);


--
-- Name: idx_erp_daily_sales_sale_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_erp_daily_sales_sale_date ON public.erp_daily_sales USING btree (sale_date);


--
-- Name: erp_daily_sales erp_daily_sales_notify_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER erp_daily_sales_notify_trigger AFTER INSERT OR DELETE OR UPDATE ON public.erp_daily_sales FOR EACH ROW EXECUTE FUNCTION public.notify_erp_daily_sales_change();


--
-- Name: erp_daily_sales update_erp_daily_sales_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_erp_daily_sales_updated_at BEFORE UPDATE ON public.erp_daily_sales FOR EACH ROW EXECUTE FUNCTION public.update_erp_daily_sales_updated_at();


--
-- Name: erp_daily_sales erp_daily_sales_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_daily_sales
    ADD CONSTRAINT erp_daily_sales_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: erp_daily_sales Allow anon insert erp_daily_sales; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert erp_daily_sales" ON public.erp_daily_sales FOR INSERT TO anon WITH CHECK (true);


--
-- Name: erp_daily_sales Allow authenticated users to read sales data; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to read sales data" ON public.erp_daily_sales FOR SELECT TO authenticated USING (true);


--
-- Name: erp_daily_sales Allow service role to manage sales data; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow service role to manage sales data" ON public.erp_daily_sales TO service_role USING (true);


--
-- Name: erp_daily_sales allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.erp_daily_sales USING (true) WITH CHECK (true);


--
-- Name: erp_daily_sales allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.erp_daily_sales FOR DELETE USING (true);


--
-- Name: erp_daily_sales allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.erp_daily_sales FOR INSERT WITH CHECK (true);


--
-- Name: erp_daily_sales allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.erp_daily_sales FOR SELECT USING (true);


--
-- Name: erp_daily_sales allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.erp_daily_sales FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: erp_daily_sales anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.erp_daily_sales USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: erp_daily_sales authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.erp_daily_sales USING ((auth.uid() IS NOT NULL));


--
-- Name: erp_daily_sales; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.erp_daily_sales ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE erp_daily_sales; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.erp_daily_sales TO anon;
GRANT SELECT ON TABLE public.erp_daily_sales TO authenticated;
GRANT ALL ON TABLE public.erp_daily_sales TO service_role;
GRANT SELECT ON TABLE public.erp_daily_sales TO replication_user;


--
-- PostgreSQL database dump complete
--

