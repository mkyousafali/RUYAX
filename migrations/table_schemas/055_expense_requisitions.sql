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
-- Name: expense_requisitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expense_requisitions (
    id bigint NOT NULL,
    requisition_number text NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    approver_id uuid,
    approver_name text,
    expense_category_id bigint,
    expense_category_name_en text,
    expense_category_name_ar text,
    requester_id text NOT NULL,
    requester_name text NOT NULL,
    requester_contact text NOT NULL,
    vat_applicable boolean DEFAULT false,
    amount numeric(15,2) NOT NULL,
    payment_category text NOT NULL,
    description text,
    status text DEFAULT 'pending'::text,
    image_url text,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    credit_period integer,
    bank_name text,
    iban text,
    used_amount numeric DEFAULT 0,
    remaining_balance numeric DEFAULT 0,
    requester_ref_id uuid,
    is_active boolean DEFAULT true NOT NULL,
    due_date date,
    internal_user_id uuid,
    request_type text DEFAULT 'external'::text,
    vendor_id integer,
    vendor_name text,
    CONSTRAINT expense_requisitions_request_type_check CHECK ((request_type = ANY (ARRAY['external'::text, 'internal'::text, 'vendor'::text])))
);


--
-- Name: TABLE expense_requisitions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.expense_requisitions IS 'Expense requisitions with approval workflow and image storage';


--
-- Name: COLUMN expense_requisitions.requisition_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.requisition_number IS 'Unique requisition number in format REQ-YYYYMMDD-XXXX';


--
-- Name: COLUMN expense_requisitions.expense_category_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.expense_category_id IS 'Expense category - can be null initially and assigned when closing the request';


--
-- Name: COLUMN expense_requisitions.payment_category; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.payment_category IS 'Payment method: advance_cash, advance_bank, advance_cash_credit, advance_bank_credit, cash, bank, cash_credit, bank_credit, stock_purchase_advance_cash, stock_purchase_advance_bank, stock_purchase_cash, stock_purchase_bank';


--
-- Name: COLUMN expense_requisitions.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.status IS 'Requisition status: pending, approved, rejected, completed';


--
-- Name: COLUMN expense_requisitions.credit_period; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.credit_period IS 'Credit period in days (required for credit payment methods: advance_cash_credit, advance_bank_credit, cash_credit, bank_credit)';


--
-- Name: COLUMN expense_requisitions.bank_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.bank_name IS 'Bank name (optional for all bank payment methods)';


--
-- Name: COLUMN expense_requisitions.iban; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.iban IS 'IBAN number (optional for all bank payment methods)';


--
-- Name: COLUMN expense_requisitions.used_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.used_amount IS 'Total amount used from this requisition across all scheduled bills';


--
-- Name: COLUMN expense_requisitions.remaining_balance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.remaining_balance IS 'Remaining balance available for new bills (amount - used_amount)';


--
-- Name: COLUMN expense_requisitions.requester_ref_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.requester_ref_id IS 'Reference to the requesters table for normalized requester data';


--
-- Name: COLUMN expense_requisitions.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.is_active IS 'Indicates if the requisition is active. Deactivated requisitions are excluded from filters and scheduling.';


--
-- Name: COLUMN expense_requisitions.due_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.due_date IS 'Automatically calculated due date based on payment method and credit period';


--
-- Name: COLUMN expense_requisitions.vendor_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.vendor_id IS 'Vendor ERP ID when request type is vendor';


--
-- Name: COLUMN expense_requisitions.vendor_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.vendor_name IS 'Vendor name when request type is vendor';


--
-- Name: expense_requisitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.expense_requisitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expense_requisitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.expense_requisitions_id_seq OWNED BY public.expense_requisitions.id;


--
-- Name: expense_requisitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions ALTER COLUMN id SET DEFAULT nextval('public.expense_requisitions_id_seq'::regclass);


--
-- Name: expense_requisitions expense_requisitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_pkey PRIMARY KEY (id);


--
-- Name: expense_requisitions expense_requisitions_requisition_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_requisition_number_key UNIQUE (requisition_number);


--
-- Name: idx_expense_requisitions_due_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_expense_requisitions_due_date ON public.expense_requisitions USING btree (due_date);


--
-- Name: idx_expense_requisitions_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_expense_requisitions_is_active ON public.expense_requisitions USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_expense_requisitions_remaining_balance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_expense_requisitions_remaining_balance ON public.expense_requisitions USING btree (remaining_balance);


--
-- Name: idx_expense_requisitions_requester_ref; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_expense_requisitions_requester_ref ON public.expense_requisitions USING btree (requester_ref_id);


--
-- Name: idx_expense_requisitions_status_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_expense_requisitions_status_active ON public.expense_requisitions USING btree (status, is_active);


--
-- Name: idx_requisitions_branch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_requisitions_branch ON public.expense_requisitions USING btree (branch_id);


--
-- Name: idx_requisitions_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_requisitions_created_at ON public.expense_requisitions USING btree (created_at DESC);


--
-- Name: idx_requisitions_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_requisitions_number ON public.expense_requisitions USING btree (requisition_number);


--
-- Name: idx_requisitions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_requisitions_status ON public.expense_requisitions USING btree (status);


--
-- Name: expense_requisitions expense_requisitions_expense_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_expense_category_id_fkey FOREIGN KEY (expense_category_id) REFERENCES public.expense_sub_categories(id);


--
-- Name: expense_requisitions expense_requisitions_internal_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_internal_user_id_fkey FOREIGN KEY (internal_user_id) REFERENCES public.users(id);


--
-- Name: expense_requisitions expense_requisitions_requester_ref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_requester_ref_id_fkey FOREIGN KEY (requester_ref_id) REFERENCES public.requesters(id);


--
-- Name: expense_requisitions fk_expense_requisitions_branch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT fk_expense_requisitions_branch FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: CONSTRAINT fk_expense_requisitions_branch ON expense_requisitions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT fk_expense_requisitions_branch ON public.expense_requisitions IS 'Links expense requisitions to their branch. ON DELETE RESTRICT prevents deletion of branches with existing requisitions.';


--
-- Name: expense_requisitions Allow anon insert expense_requisitions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert expense_requisitions" ON public.expense_requisitions FOR INSERT TO anon WITH CHECK (true);


--
-- Name: expense_requisitions Allow authenticated users to create expense requisitions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to create expense requisitions" ON public.expense_requisitions FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: expense_requisitions Allow authenticated users to delete requisitions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to delete requisitions" ON public.expense_requisitions FOR DELETE TO authenticated USING (true);


--
-- Name: expense_requisitions Allow authenticated users to insert requisitions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to insert requisitions" ON public.expense_requisitions FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: expense_requisitions Allow authenticated users to read expense requisitions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to read expense requisitions" ON public.expense_requisitions FOR SELECT TO authenticated USING (true);


--
-- Name: expense_requisitions Allow authenticated users to read requisitions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to read requisitions" ON public.expense_requisitions FOR SELECT TO authenticated USING (true);


--
-- Name: expense_requisitions Allow authenticated users to update expense requisitions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to update expense requisitions" ON public.expense_requisitions FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: expense_requisitions Allow authenticated users to update requisitions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to update requisitions" ON public.expense_requisitions FOR UPDATE TO authenticated USING (true);


--
-- Name: expense_requisitions Service role has full access to expense requisitions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role has full access to expense requisitions" ON public.expense_requisitions TO service_role USING (true) WITH CHECK (true);


--
-- Name: expense_requisitions allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.expense_requisitions USING (true) WITH CHECK (true);


--
-- Name: expense_requisitions allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.expense_requisitions FOR DELETE USING (true);


--
-- Name: expense_requisitions allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.expense_requisitions FOR INSERT WITH CHECK (true);


--
-- Name: expense_requisitions allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.expense_requisitions FOR SELECT USING (true);


--
-- Name: expense_requisitions allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.expense_requisitions FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: expense_requisitions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.expense_requisitions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: expense_requisitions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.expense_requisitions USING ((auth.uid() IS NOT NULL));


--
-- Name: expense_requisitions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.expense_requisitions ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE expense_requisitions; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.expense_requisitions TO anon;
GRANT SELECT ON TABLE public.expense_requisitions TO authenticated;
GRANT ALL ON TABLE public.expense_requisitions TO service_role;
GRANT SELECT ON TABLE public.expense_requisitions TO replication_user;


--
-- Name: SEQUENCE expense_requisitions_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.expense_requisitions_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.expense_requisitions_id_seq TO anon;
GRANT ALL ON SEQUENCE public.expense_requisitions_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.expense_requisitions_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

