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
-- Name: purchase_voucher_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_voucher_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    purchase_voucher_id character varying NOT NULL,
    serial_number integer NOT NULL,
    value numeric NOT NULL,
    status character varying DEFAULT 'stocked'::character varying,
    issued_date timestamp with time zone,
    closed_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    stock integer DEFAULT 1,
    issue_type character varying DEFAULT 'not issued'::character varying,
    stock_location bigint,
    stock_person uuid,
    issued_to uuid,
    issued_by uuid,
    receipt_url text,
    issue_remarks text,
    close_remarks text,
    close_bill_number character varying,
    approval_status character varying,
    approver_id uuid,
    pending_stock_location bigint,
    pending_stock_person uuid
);


--
-- Name: purchase_voucher_items purchase_voucher_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_voucher_items purchase_voucher_items_purchase_voucher_id_serial_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_purchase_voucher_id_serial_number_key UNIQUE (purchase_voucher_id, serial_number);


--
-- Name: idx_purchase_voucher_items_pv_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_voucher_items_pv_id ON public.purchase_voucher_items USING btree (purchase_voucher_id);


--
-- Name: idx_purchase_voucher_items_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_voucher_items_status ON public.purchase_voucher_items USING btree (status);


--
-- Name: idx_pvi_approver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pvi_approver_id ON public.purchase_voucher_items USING btree (approver_id);


--
-- Name: idx_pvi_close_bill_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pvi_close_bill_number ON public.purchase_voucher_items USING btree (close_bill_number);


--
-- Name: idx_pvi_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pvi_created_at ON public.purchase_voucher_items USING btree (created_at);


--
-- Name: idx_pvi_issued_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pvi_issued_by ON public.purchase_voucher_items USING btree (issued_by);


--
-- Name: idx_pvi_issued_to; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pvi_issued_to ON public.purchase_voucher_items USING btree (issued_to);


--
-- Name: idx_pvi_pending_stock_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pvi_pending_stock_location ON public.purchase_voucher_items USING btree (pending_stock_location);


--
-- Name: idx_pvi_pending_stock_person; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pvi_pending_stock_person ON public.purchase_voucher_items USING btree (pending_stock_person);


--
-- Name: idx_pvi_purchase_voucher_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pvi_purchase_voucher_id ON public.purchase_voucher_items USING btree (purchase_voucher_id);


--
-- Name: idx_pvi_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pvi_status ON public.purchase_voucher_items USING btree (status);


--
-- Name: idx_pvi_stock_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pvi_stock_location ON public.purchase_voucher_items USING btree (stock_location);


--
-- Name: idx_pvi_stock_person; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pvi_stock_person ON public.purchase_voucher_items USING btree (stock_person);


--
-- Name: purchase_voucher_items purchase_voucher_items_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER purchase_voucher_items_updated_at_trigger BEFORE UPDATE ON public.purchase_voucher_items FOR EACH ROW EXECUTE FUNCTION public.update_purchase_voucher_items_updated_at();


--
-- Name: purchase_voucher_items purchase_voucher_items_approver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES public.users(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_issued_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_issued_by_fkey FOREIGN KEY (issued_by) REFERENCES public.users(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_pending_stock_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_pending_stock_location_fkey FOREIGN KEY (pending_stock_location) REFERENCES public.branches(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_pending_stock_person_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_pending_stock_person_fkey FOREIGN KEY (pending_stock_person) REFERENCES public.users(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_purchase_voucher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_purchase_voucher_id_fkey FOREIGN KEY (purchase_voucher_id) REFERENCES public.purchase_vouchers(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_stock_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_stock_location_fkey FOREIGN KEY (stock_location) REFERENCES public.branches(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_stock_person_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_stock_person_fkey FOREIGN KEY (stock_person) REFERENCES public.users(id);


--
-- Name: purchase_voucher_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.purchase_voucher_items ENABLE ROW LEVEL SECURITY;

--
-- Name: purchase_voucher_items pvi_authenticated_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY pvi_authenticated_all ON public.purchase_voucher_items USING (true);


--
-- Name: purchase_voucher_items pvi_service_role_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY pvi_service_role_all ON public.purchase_voucher_items USING (true);


--
-- Name: TABLE purchase_voucher_items; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.purchase_voucher_items TO anon;
GRANT ALL ON TABLE public.purchase_voucher_items TO authenticated;
GRANT ALL ON TABLE public.purchase_voucher_items TO service_role;
GRANT SELECT ON TABLE public.purchase_voucher_items TO replication_user;


--
-- PostgreSQL database dump complete
--

