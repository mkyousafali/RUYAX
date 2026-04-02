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
-- Name: receiving_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receiving_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    branch_id integer NOT NULL,
    vendor_id integer NOT NULL,
    bill_date date NOT NULL,
    bill_amount numeric(15,2) NOT NULL,
    bill_number character varying(100),
    payment_method character varying(100),
    credit_period integer,
    due_date date,
    bank_name character varying(200),
    iban character varying(50),
    vendor_vat_number character varying(50),
    bill_vat_number character varying(50),
    vat_numbers_match boolean,
    vat_mismatch_reason text,
    branch_manager_user_id uuid,
    shelf_stocker_user_ids uuid[] DEFAULT '{}'::uuid[],
    accountant_user_id uuid,
    purchasing_manager_user_id uuid,
    expired_return_amount numeric(12,2) DEFAULT 0,
    near_expiry_return_amount numeric(12,2) DEFAULT 0,
    over_stock_return_amount numeric(12,2) DEFAULT 0,
    damage_return_amount numeric(12,2) DEFAULT 0,
    total_return_amount numeric(12,2) DEFAULT 0,
    final_bill_amount numeric(12,2) DEFAULT 0,
    expired_erp_document_type character varying(10),
    expired_erp_document_number character varying(100),
    expired_vendor_document_number character varying(100),
    near_expiry_erp_document_type character varying(10),
    near_expiry_erp_document_number character varying(100),
    near_expiry_vendor_document_number character varying(100),
    over_stock_erp_document_type character varying(10),
    over_stock_erp_document_number character varying(100),
    over_stock_vendor_document_number character varying(100),
    damage_erp_document_type character varying(10),
    damage_erp_document_number character varying(100),
    damage_vendor_document_number character varying(100),
    has_expired_returns boolean DEFAULT false,
    has_near_expiry_returns boolean DEFAULT false,
    has_over_stock_returns boolean DEFAULT false,
    has_damage_returns boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    inventory_manager_user_id uuid,
    night_supervisor_user_ids uuid[] DEFAULT '{}'::uuid[],
    warehouse_handler_user_ids uuid[] DEFAULT '{}'::uuid[],
    certificate_url text,
    certificate_generated_at timestamp with time zone,
    certificate_file_name text,
    original_bill_url text,
    erp_purchase_invoice_reference character varying(255),
    updated_at timestamp with time zone DEFAULT now(),
    pr_excel_file_url text,
    erp_purchase_invoice_uploaded boolean DEFAULT false,
    pr_excel_file_uploaded boolean DEFAULT false,
    original_bill_uploaded boolean DEFAULT false,
    CONSTRAINT check_credit_period_positive CHECK (((credit_period IS NULL) OR (credit_period >= 0))),
    CONSTRAINT check_damage_return_amount CHECK ((damage_return_amount >= (0)::numeric)),
    CONSTRAINT check_due_date_after_bill_date CHECK (((due_date IS NULL) OR (bill_date IS NULL) OR (due_date >= bill_date))),
    CONSTRAINT check_expired_return_amount CHECK ((expired_return_amount >= (0)::numeric)),
    CONSTRAINT check_final_bill_amount CHECK ((final_bill_amount >= (0)::numeric)),
    CONSTRAINT check_near_expiry_return_amount CHECK ((near_expiry_return_amount >= (0)::numeric)),
    CONSTRAINT check_over_stock_return_amount CHECK ((over_stock_return_amount >= (0)::numeric)),
    CONSTRAINT check_return_not_exceed_bill CHECK ((total_return_amount <= bill_amount)),
    CONSTRAINT check_total_return_amount CHECK ((total_return_amount >= (0)::numeric)),
    CONSTRAINT check_vat_mismatch_reason CHECK (((vat_numbers_match IS NULL) OR (vat_numbers_match = true) OR ((vat_numbers_match = false) AND (vat_mismatch_reason IS NOT NULL) AND (length(TRIM(BOTH FROM vat_mismatch_reason)) > 0))))
);


--
-- Name: TABLE receiving_records; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.receiving_records IS 'Receiving records with bill information and return processing';


--
-- Name: COLUMN receiving_records.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.user_id IS 'User who performed the receiving';


--
-- Name: COLUMN receiving_records.branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.branch_id IS 'Branch where receiving was performed';


--
-- Name: COLUMN receiving_records.vendor_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.vendor_id IS 'Vendor from whom goods were received';


--
-- Name: COLUMN receiving_records.bill_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.bill_date IS 'Date entered from the physical bill';


--
-- Name: COLUMN receiving_records.bill_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.bill_amount IS 'Total amount from the bill';


--
-- Name: COLUMN receiving_records.bill_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.bill_number IS 'Bill number from the physical bill';


--
-- Name: COLUMN receiving_records.payment_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.payment_method IS 'Payment method for this receiving (can differ from vendor default)';


--
-- Name: COLUMN receiving_records.credit_period; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.credit_period IS 'Credit period in days for this receiving (can differ from vendor default)';


--
-- Name: COLUMN receiving_records.due_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.due_date IS 'Calculated due date (bill date + credit period) for credit payment methods';


--
-- Name: COLUMN receiving_records.bank_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.bank_name IS 'Bank name for this receiving (can differ from vendor default)';


--
-- Name: COLUMN receiving_records.iban; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.iban IS 'IBAN for this receiving (can differ from vendor default)';


--
-- Name: COLUMN receiving_records.vendor_vat_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.vendor_vat_number IS 'VAT number from vendor record at time of receiving';


--
-- Name: COLUMN receiving_records.bill_vat_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.bill_vat_number IS 'VAT number entered from the physical bill';


--
-- Name: COLUMN receiving_records.vat_numbers_match; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.vat_numbers_match IS 'Whether vendor and bill VAT numbers match';


--
-- Name: COLUMN receiving_records.vat_mismatch_reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.vat_mismatch_reason IS 'Reason provided when VAT numbers do not match';


--
-- Name: COLUMN receiving_records.branch_manager_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.branch_manager_user_id IS 'Selected branch manager or responsible user for this receiving';


--
-- Name: COLUMN receiving_records.shelf_stocker_user_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.shelf_stocker_user_ids IS 'Array of user IDs selected as shelf stockers for this receiving';


--
-- Name: COLUMN receiving_records.accountant_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.accountant_user_id IS 'Selected accountant or responsible user for accounting tasks';


--
-- Name: COLUMN receiving_records.purchasing_manager_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.purchasing_manager_user_id IS 'Selected purchasing manager or responsible user for purchasing oversight';


--
-- Name: COLUMN receiving_records.expired_return_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.expired_return_amount IS 'Amount returned for expired items';


--
-- Name: COLUMN receiving_records.near_expiry_return_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.near_expiry_return_amount IS 'Amount returned for near expiry items';


--
-- Name: COLUMN receiving_records.over_stock_return_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.over_stock_return_amount IS 'Amount returned for over stock items';


--
-- Name: COLUMN receiving_records.damage_return_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.damage_return_amount IS 'Amount returned for damaged items';


--
-- Name: COLUMN receiving_records.total_return_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.total_return_amount IS 'Total amount of all returns (auto-calculated)';


--
-- Name: COLUMN receiving_records.final_bill_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.final_bill_amount IS 'Final bill amount after deducting returns (auto-calculated)';


--
-- Name: COLUMN receiving_records.expired_erp_document_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.expired_erp_document_type IS 'ERP document type for expired returns (GRN, PR)';


--
-- Name: COLUMN receiving_records.expired_erp_document_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.expired_erp_document_number IS 'ERP document number for expired returns';


--
-- Name: COLUMN receiving_records.expired_vendor_document_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.expired_vendor_document_number IS 'Vendor document number for expired returns';


--
-- Name: COLUMN receiving_records.near_expiry_erp_document_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.near_expiry_erp_document_type IS 'ERP document type for near expiry returns (GRN, PR)';


--
-- Name: COLUMN receiving_records.near_expiry_erp_document_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.near_expiry_erp_document_number IS 'ERP document number for near expiry returns';


--
-- Name: COLUMN receiving_records.near_expiry_vendor_document_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.near_expiry_vendor_document_number IS 'Vendor document number for near expiry returns';


--
-- Name: COLUMN receiving_records.over_stock_erp_document_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.over_stock_erp_document_type IS 'ERP document type for over stock returns (GRN, PR)';


--
-- Name: COLUMN receiving_records.over_stock_erp_document_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.over_stock_erp_document_number IS 'ERP document number for over stock returns';


--
-- Name: COLUMN receiving_records.over_stock_vendor_document_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.over_stock_vendor_document_number IS 'Vendor document number for over stock returns';


--
-- Name: COLUMN receiving_records.damage_erp_document_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.damage_erp_document_type IS 'ERP document type for damage returns (GRN, PR)';


--
-- Name: COLUMN receiving_records.damage_erp_document_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.damage_erp_document_number IS 'ERP document number for damage returns';


--
-- Name: COLUMN receiving_records.damage_vendor_document_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.damage_vendor_document_number IS 'Vendor document number for damage returns';


--
-- Name: COLUMN receiving_records.has_expired_returns; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.has_expired_returns IS 'Whether expired returns were processed';


--
-- Name: COLUMN receiving_records.has_near_expiry_returns; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.has_near_expiry_returns IS 'Whether near expiry returns were processed';


--
-- Name: COLUMN receiving_records.has_over_stock_returns; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.has_over_stock_returns IS 'Whether over stock returns were processed';


--
-- Name: COLUMN receiving_records.has_damage_returns; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.has_damage_returns IS 'Whether damage returns were processed';


--
-- Name: COLUMN receiving_records.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.created_at IS 'When this receiving record was created in system';


--
-- Name: COLUMN receiving_records.inventory_manager_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.inventory_manager_user_id IS 'Single user responsible for inventory management for this receiving';


--
-- Name: COLUMN receiving_records.night_supervisor_user_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.night_supervisor_user_ids IS 'Array of user IDs for night supervisors assigned to this receiving';


--
-- Name: COLUMN receiving_records.warehouse_handler_user_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.warehouse_handler_user_ids IS 'Array of user IDs for warehouse and stock handlers assigned to this receiving';


--
-- Name: COLUMN receiving_records.certificate_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.certificate_url IS 'Public URL to the generated clearance certificate image';


--
-- Name: COLUMN receiving_records.certificate_generated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.certificate_generated_at IS 'Timestamp when certificate was generated and saved';


--
-- Name: COLUMN receiving_records.certificate_file_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.certificate_file_name IS 'Original filename of the certificate in storage';


--
-- Name: COLUMN receiving_records.original_bill_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.original_bill_url IS 'URL to uploaded original bill document (PDF, image, etc.)';


--
-- Name: COLUMN receiving_records.erp_purchase_invoice_reference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.erp_purchase_invoice_reference IS 'ERP purchase invoice reference number entered by inventory manager when completing receiving task';


--
-- Name: COLUMN receiving_records.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.updated_at IS 'Timestamp when the record was last updated';


--
-- Name: COLUMN receiving_records.pr_excel_file_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.pr_excel_file_url IS 'URL link to uploaded PR Excel file stored in Supabase Storage';


--
-- Name: COLUMN receiving_records.erp_purchase_invoice_uploaded; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.erp_purchase_invoice_uploaded IS 'Boolean flag indicating if ERP purchase invoice reference has been entered by Inventory Manager';


--
-- Name: COLUMN receiving_records.pr_excel_file_uploaded; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.pr_excel_file_uploaded IS 'Boolean flag indicating if PR Excel file has been uploaded by Inventory Manager';


--
-- Name: COLUMN receiving_records.original_bill_uploaded; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_records.original_bill_uploaded IS 'Boolean flag indicating if original bill has been uploaded by Inventory Manager';


--
-- Name: receiving_records receiving_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_pkey PRIMARY KEY (id);


--
-- Name: idx_receiving_records_accountant_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_accountant_user_id ON public.receiving_records USING btree (accountant_user_id);


--
-- Name: idx_receiving_records_bank_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_bank_name ON public.receiving_records USING btree (bank_name);


--
-- Name: idx_receiving_records_bill_amount; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_bill_amount ON public.receiving_records USING btree (bill_amount);


--
-- Name: idx_receiving_records_bill_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_bill_date ON public.receiving_records USING btree (bill_date);


--
-- Name: idx_receiving_records_bill_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_bill_number ON public.receiving_records USING btree (bill_number);


--
-- Name: idx_receiving_records_bill_vat_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_bill_vat_number ON public.receiving_records USING btree (bill_vat_number);


--
-- Name: idx_receiving_records_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_branch_id ON public.receiving_records USING btree (branch_id);


--
-- Name: idx_receiving_records_branch_manager_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_branch_manager_user_id ON public.receiving_records USING btree (branch_manager_user_id);


--
-- Name: idx_receiving_records_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_created_at ON public.receiving_records USING btree (created_at);


--
-- Name: idx_receiving_records_credit_period; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_credit_period ON public.receiving_records USING btree (credit_period);


--
-- Name: idx_receiving_records_damage_erp_document_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_damage_erp_document_number ON public.receiving_records USING btree (damage_erp_document_number);


--
-- Name: idx_receiving_records_damage_vendor_document_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_damage_vendor_document_number ON public.receiving_records USING btree (damage_vendor_document_number);


--
-- Name: idx_receiving_records_due_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_due_date ON public.receiving_records USING btree (due_date);


--
-- Name: idx_receiving_records_erp_purchase_invoice_reference; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_erp_purchase_invoice_reference ON public.receiving_records USING btree (erp_purchase_invoice_reference);


--
-- Name: idx_receiving_records_erp_purchase_invoice_uploaded; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_erp_purchase_invoice_uploaded ON public.receiving_records USING btree (erp_purchase_invoice_uploaded);


--
-- Name: idx_receiving_records_expired_erp_document_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_expired_erp_document_number ON public.receiving_records USING btree (expired_erp_document_number);


--
-- Name: idx_receiving_records_expired_vendor_document_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_expired_vendor_document_number ON public.receiving_records USING btree (expired_vendor_document_number);


--
-- Name: idx_receiving_records_final_bill_amount; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_final_bill_amount ON public.receiving_records USING btree (final_bill_amount);


--
-- Name: idx_receiving_records_iban; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_iban ON public.receiving_records USING btree (iban);


--
-- Name: idx_receiving_records_inventory_manager_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_inventory_manager_user_id ON public.receiving_records USING btree (inventory_manager_user_id);


--
-- Name: idx_receiving_records_near_expiry_erp_document_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_near_expiry_erp_document_number ON public.receiving_records USING btree (near_expiry_erp_document_number);


--
-- Name: idx_receiving_records_near_expiry_vendor_document_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_near_expiry_vendor_document_number ON public.receiving_records USING btree (near_expiry_vendor_document_number);


--
-- Name: idx_receiving_records_night_supervisor_user_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_night_supervisor_user_ids ON public.receiving_records USING gin (night_supervisor_user_ids);


--
-- Name: idx_receiving_records_original_bill_uploaded; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_original_bill_uploaded ON public.receiving_records USING btree (original_bill_uploaded);


--
-- Name: idx_receiving_records_original_bill_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_original_bill_url ON public.receiving_records USING btree (original_bill_url);


--
-- Name: idx_receiving_records_over_stock_erp_document_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_over_stock_erp_document_number ON public.receiving_records USING btree (over_stock_erp_document_number);


--
-- Name: idx_receiving_records_over_stock_vendor_document_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_over_stock_vendor_document_number ON public.receiving_records USING btree (over_stock_vendor_document_number);


--
-- Name: idx_receiving_records_payment_method; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_payment_method ON public.receiving_records USING btree (payment_method);


--
-- Name: idx_receiving_records_pr_excel_file_uploaded; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_pr_excel_file_uploaded ON public.receiving_records USING btree (pr_excel_file_uploaded);


--
-- Name: idx_receiving_records_pr_excel_file_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_pr_excel_file_url ON public.receiving_records USING btree (pr_excel_file_url) WHERE (pr_excel_file_url IS NOT NULL);


--
-- Name: idx_receiving_records_purchasing_manager_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_purchasing_manager_user_id ON public.receiving_records USING btree (purchasing_manager_user_id);


--
-- Name: idx_receiving_records_shelf_stocker_user_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_shelf_stocker_user_ids ON public.receiving_records USING gin (shelf_stocker_user_ids);


--
-- Name: idx_receiving_records_total_return_amount; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_total_return_amount ON public.receiving_records USING btree (total_return_amount);


--
-- Name: idx_receiving_records_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_updated_at ON public.receiving_records USING btree (updated_at DESC);


--
-- Name: idx_receiving_records_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_user_id ON public.receiving_records USING btree (user_id);


--
-- Name: idx_receiving_records_vat_numbers_match; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_vat_numbers_match ON public.receiving_records USING btree (vat_numbers_match);


--
-- Name: idx_receiving_records_vendor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_vendor_id ON public.receiving_records USING btree (vendor_id);


--
-- Name: idx_receiving_records_vendor_vat_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_vendor_vat_number ON public.receiving_records USING btree (vendor_vat_number);


--
-- Name: idx_receiving_records_warehouse_handler_user_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_records_warehouse_handler_user_ids ON public.receiving_records USING gin (warehouse_handler_user_ids);


--
-- Name: receiving_records calculate_receiving_amounts_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER calculate_receiving_amounts_trigger BEFORE INSERT OR UPDATE ON public.receiving_records FOR EACH ROW EXECUTE FUNCTION public.calculate_receiving_amounts();


--
-- Name: receiving_records trigger_auto_create_payment_schedule; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_auto_create_payment_schedule AFTER INSERT OR UPDATE OF certificate_url ON public.receiving_records FOR EACH ROW EXECUTE FUNCTION public.auto_create_payment_schedule();


--
-- Name: receiving_records receiving_records_accountant_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_accountant_user_id_fkey FOREIGN KEY (accountant_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: receiving_records receiving_records_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: receiving_records receiving_records_branch_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_branch_manager_user_id_fkey FOREIGN KEY (branch_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: receiving_records receiving_records_inventory_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_inventory_manager_user_id_fkey FOREIGN KEY (inventory_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: receiving_records receiving_records_purchasing_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_purchasing_manager_user_id_fkey FOREIGN KEY (purchasing_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: receiving_records receiving_records_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: receiving_records receiving_records_vendor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_vendor_fkey FOREIGN KEY (vendor_id, branch_id) REFERENCES public.vendors(erp_vendor_id, branch_id) ON DELETE RESTRICT;


--
-- Name: CONSTRAINT receiving_records_vendor_fkey ON receiving_records; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT receiving_records_vendor_fkey ON public.receiving_records IS 'Foreign key constraint linking receiving_records to vendors using composite key (vendor_id -> erp_vendor_id, branch_id -> branch_id)';


--
-- Name: receiving_records allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.receiving_records FOR DELETE USING (true);


--
-- Name: receiving_records allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.receiving_records FOR INSERT WITH CHECK (true);


--
-- Name: receiving_records allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.receiving_records FOR SELECT USING (true);


--
-- Name: receiving_records allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.receiving_records FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: receiving_records; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.receiving_records ENABLE ROW LEVEL SECURITY;

--
-- Name: receiving_records rls_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_delete ON public.receiving_records FOR DELETE USING (true);


--
-- Name: receiving_records rls_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_insert ON public.receiving_records FOR INSERT WITH CHECK (true);


--
-- Name: receiving_records rls_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_select ON public.receiving_records FOR SELECT USING (true);


--
-- Name: receiving_records rls_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_update ON public.receiving_records FOR UPDATE WITH CHECK (true);


--
-- Name: TABLE receiving_records; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.receiving_records TO anon;
GRANT SELECT ON TABLE public.receiving_records TO authenticated;
GRANT ALL ON TABLE public.receiving_records TO service_role;
GRANT SELECT ON TABLE public.receiving_records TO replication_user;


--
-- PostgreSQL database dump complete
--

