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
-- Name: vendors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendors (
    erp_vendor_id integer NOT NULL,
    vendor_name text NOT NULL,
    salesman_name text,
    salesman_contact text,
    supervisor_name text,
    supervisor_contact text,
    vendor_contact_number text,
    payment_method text,
    credit_period integer,
    bank_name text,
    iban text,
    status text DEFAULT 'Active'::text,
    last_visit timestamp without time zone,
    categories text[],
    delivery_modes text[],
    place text,
    location_link text,
    return_expired_products text,
    return_expired_products_note text,
    return_near_expiry_products text,
    return_near_expiry_products_note text,
    return_over_stock text,
    return_over_stock_note text,
    return_damage_products text,
    return_damage_products_note text,
    no_return boolean DEFAULT false,
    no_return_note text,
    vat_applicable text DEFAULT 'VAT Applicable'::text,
    vat_number text,
    no_vat_note text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    branch_id bigint NOT NULL,
    payment_priority text DEFAULT 'Normal'::text,
    CONSTRAINT vendors_payment_priority_check CHECK ((payment_priority = ANY (ARRAY['Most'::text, 'Medium'::text, 'Normal'::text, 'Low'::text])))
);


--
-- Name: TABLE vendors; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.vendors IS 'Vendor management table with support for multiple payment methods, return policies, and VAT information';


--
-- Name: COLUMN vendors.payment_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.payment_method IS 'Comma-separated list of payment methods: Cash on Delivery, Bank on Delivery, Cash Credit, Bank Credit';


--
-- Name: COLUMN vendors.credit_period; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.credit_period IS 'Credit period in days for credit-based payment methods';


--
-- Name: COLUMN vendors.bank_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.bank_name IS 'Bank name for bank-related payment methods';


--
-- Name: COLUMN vendors.iban; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.iban IS 'International Bank Account Number for bank transfers';


--
-- Name: COLUMN vendors.no_return; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.no_return IS 'When TRUE, vendor does not accept any returns regardless of other return policy settings';


--
-- Name: COLUMN vendors.vat_applicable; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.vat_applicable IS 'VAT applicability status for the vendor';


--
-- Name: COLUMN vendors.vat_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.vat_number IS 'VAT registration number when VAT is applicable';


--
-- Name: COLUMN vendors.branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.branch_id IS 'Branch ID that this vendor belongs to - makes vendor management branch-wise';


--
-- Name: COLUMN vendors.payment_priority; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.payment_priority IS 'Payment priority level: Most, Medium, Normal (default), Low';


--
-- Name: vendors vendors_erp_vendor_branch_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_erp_vendor_branch_unique UNIQUE (erp_vendor_id, branch_id);


--
-- Name: CONSTRAINT vendors_erp_vendor_branch_unique ON vendors; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT vendors_erp_vendor_branch_unique ON public.vendors IS 'Ensures ERP vendor ID is unique within each branch, allowing same vendor ID across different branches';


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (erp_vendor_id, branch_id);


--
-- Name: idx_vendors_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vendors_branch_id ON public.vendors USING btree (branch_id) WHERE (branch_id IS NOT NULL);


--
-- Name: idx_vendors_branch_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vendors_branch_status ON public.vendors USING btree (branch_id, status) WHERE (branch_id IS NOT NULL);


--
-- Name: idx_vendors_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vendors_created_at ON public.vendors USING btree (created_at);


--
-- Name: idx_vendors_erp_vendor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vendors_erp_vendor_id ON public.vendors USING btree (erp_vendor_id);


--
-- Name: idx_vendors_payment_method; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vendors_payment_method ON public.vendors USING gin (to_tsvector('english'::regconfig, payment_method));


--
-- Name: idx_vendors_payment_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vendors_payment_priority ON public.vendors USING btree (payment_priority);


--
-- Name: idx_vendors_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vendors_status ON public.vendors USING btree (status);


--
-- Name: idx_vendors_vat_applicable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vendors_vat_applicable ON public.vendors USING btree (vat_applicable);


--
-- Name: idx_vendors_vendor_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vendors_vendor_name ON public.vendors USING btree (vendor_name);


--
-- Name: vendors vendors_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: vendors allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.vendors FOR DELETE USING (true);


--
-- Name: vendors allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.vendors FOR INSERT WITH CHECK (true);


--
-- Name: vendors allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.vendors FOR SELECT USING (true);


--
-- Name: vendors allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.vendors FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: vendors rls_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_delete ON public.vendors FOR DELETE USING (true);


--
-- Name: vendors rls_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_insert ON public.vendors FOR INSERT WITH CHECK (true);


--
-- Name: vendors rls_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_select ON public.vendors FOR SELECT USING (true);


--
-- Name: vendors rls_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_update ON public.vendors FOR UPDATE WITH CHECK (true);


--
-- Name: vendors; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.vendors ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE vendors; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.vendors TO anon;
GRANT SELECT ON TABLE public.vendors TO authenticated;
GRANT ALL ON TABLE public.vendors TO service_role;
GRANT SELECT ON TABLE public.vendors TO replication_user;


--
-- PostgreSQL database dump complete
--

