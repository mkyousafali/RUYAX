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
-- Name: approval_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approval_permissions (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    can_approve_requisitions boolean DEFAULT false NOT NULL,
    requisition_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_single_bill boolean DEFAULT false NOT NULL,
    single_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_multiple_bill boolean DEFAULT false NOT NULL,
    multiple_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_recurring_bill boolean DEFAULT false NOT NULL,
    recurring_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_vendor_payments boolean DEFAULT false NOT NULL,
    vendor_payment_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_leave_requests boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    can_approve_purchase_vouchers boolean DEFAULT false NOT NULL,
    can_add_missing_punches boolean DEFAULT false NOT NULL,
    can_receive_customer_incidents boolean DEFAULT false NOT NULL,
    can_receive_employee_incidents boolean DEFAULT false NOT NULL,
    can_receive_maintenance_incidents boolean DEFAULT false NOT NULL,
    can_receive_vendor_incidents boolean DEFAULT false NOT NULL,
    can_receive_vehicle_incidents boolean DEFAULT false NOT NULL,
    can_receive_government_incidents boolean DEFAULT false NOT NULL,
    can_receive_other_incidents boolean DEFAULT false NOT NULL,
    can_receive_finance_incidents boolean DEFAULT false NOT NULL,
    can_receive_pos_incidents boolean DEFAULT false NOT NULL,
    CONSTRAINT approval_permissions_multiple_bill_limit_check CHECK ((multiple_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_recurring_bill_limit_check CHECK ((recurring_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_requisition_limit_check CHECK ((requisition_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_single_bill_limit_check CHECK ((single_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_vendor_payment_limit_check CHECK ((vendor_payment_amount_limit >= (0)::numeric))
);


--
-- Name: TABLE approval_permissions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.approval_permissions IS 'Stores granular approval permissions for different types of requests (requisitions, schedules, vendor payments, etc.)';


--
-- Name: COLUMN approval_permissions.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.user_id IS 'Reference to the user who has these approval permissions';


--
-- Name: COLUMN approval_permissions.can_approve_requisitions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_approve_requisitions IS 'Whether user can approve expense requisitions';


--
-- Name: COLUMN approval_permissions.requisition_amount_limit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.requisition_amount_limit IS 'Maximum amount user can approve for requisitions (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_single_bill; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_approve_single_bill IS 'Whether user can approve single bill payment schedules';


--
-- Name: COLUMN approval_permissions.single_bill_amount_limit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.single_bill_amount_limit IS 'Maximum amount user can approve for single bills (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_multiple_bill; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_approve_multiple_bill IS 'Whether user can approve multiple bill payment schedules';


--
-- Name: COLUMN approval_permissions.multiple_bill_amount_limit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.multiple_bill_amount_limit IS 'Maximum amount user can approve for multiple bills (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_recurring_bill; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_approve_recurring_bill IS 'Whether user can approve recurring bill payment schedules';


--
-- Name: COLUMN approval_permissions.recurring_bill_amount_limit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.recurring_bill_amount_limit IS 'Maximum amount user can approve for recurring bills (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_vendor_payments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_approve_vendor_payments IS 'Whether user can approve vendor payments';


--
-- Name: COLUMN approval_permissions.vendor_payment_amount_limit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.vendor_payment_amount_limit IS 'Maximum amount user can approve for vendor payments (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.is_active IS 'Whether these permissions are currently active';


--
-- Name: COLUMN approval_permissions.can_receive_customer_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_customer_incidents IS 'Permission to receive and review customer-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_employee_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_employee_incidents IS 'Permission to receive and review employee-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_maintenance_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_maintenance_incidents IS 'Permission to receive and review maintenance-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_vendor_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_vendor_incidents IS 'Permission to receive and review vendor-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_vehicle_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_vehicle_incidents IS 'Permission to receive and review vehicle-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_government_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_government_incidents IS 'Permission to receive and review government-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_other_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_other_incidents IS 'Permission to receive and review other types of incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_finance_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_finance_incidents IS 'Permission to receive and review finance department incident reports (IN8)';


--
-- Name: COLUMN approval_permissions.can_receive_pos_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_pos_incidents IS 'Permission to receive and review customer/POS incident reports (IN9)';


--
-- Name: approval_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_permissions_id_seq OWNED BY public.approval_permissions.id;


--
-- Name: approval_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions ALTER COLUMN id SET DEFAULT nextval('public.approval_permissions_id_seq'::regclass);


--
-- Name: approval_permissions approval_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_pkey PRIMARY KEY (id);


--
-- Name: approval_permissions approval_permissions_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_user_id_key UNIQUE (user_id);


--
-- Name: idx_approval_permissions_add_missing_punches; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_add_missing_punches ON public.approval_permissions USING btree (can_add_missing_punches) WHERE ((can_add_missing_punches = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_customer_incidents; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_customer_incidents ON public.approval_permissions USING btree (can_receive_customer_incidents) WHERE ((can_receive_customer_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_employee_incidents; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_employee_incidents ON public.approval_permissions USING btree (can_receive_employee_incidents) WHERE ((can_receive_employee_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_finance_incidents; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_finance_incidents ON public.approval_permissions USING btree (can_receive_finance_incidents) WHERE ((can_receive_finance_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_government_incidents; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_government_incidents ON public.approval_permissions USING btree (can_receive_government_incidents) WHERE ((can_receive_government_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_is_active ON public.approval_permissions USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_approval_permissions_leave_requests; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_leave_requests ON public.approval_permissions USING btree (can_approve_leave_requests) WHERE ((can_approve_leave_requests = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_maintenance_incidents; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_maintenance_incidents ON public.approval_permissions USING btree (can_receive_maintenance_incidents) WHERE ((can_receive_maintenance_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_multiple_bill; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_multiple_bill ON public.approval_permissions USING btree (can_approve_multiple_bill) WHERE ((can_approve_multiple_bill = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_other_incidents; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_other_incidents ON public.approval_permissions USING btree (can_receive_other_incidents) WHERE ((can_receive_other_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_pos_incidents; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_pos_incidents ON public.approval_permissions USING btree (can_receive_pos_incidents) WHERE ((can_receive_pos_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_purchase_vouchers; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_purchase_vouchers ON public.approval_permissions USING btree (can_approve_purchase_vouchers) WHERE ((can_approve_purchase_vouchers = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_recurring_bill; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_recurring_bill ON public.approval_permissions USING btree (can_approve_recurring_bill) WHERE ((can_approve_recurring_bill = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_requisitions; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_requisitions ON public.approval_permissions USING btree (can_approve_requisitions) WHERE ((can_approve_requisitions = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_single_bill; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_single_bill ON public.approval_permissions USING btree (can_approve_single_bill) WHERE ((can_approve_single_bill = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_user_id ON public.approval_permissions USING btree (user_id);


--
-- Name: idx_approval_permissions_vehicle_incidents; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_vehicle_incidents ON public.approval_permissions USING btree (can_receive_vehicle_incidents) WHERE ((can_receive_vehicle_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_vendor_incidents; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_vendor_incidents ON public.approval_permissions USING btree (can_receive_vendor_incidents) WHERE ((can_receive_vendor_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_vendor_payments; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approval_permissions_vendor_payments ON public.approval_permissions USING btree (can_approve_vendor_payments) WHERE ((can_approve_vendor_payments = true) AND (is_active = true));


--
-- Name: approval_permissions update_approval_permissions_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_approval_permissions_timestamp BEFORE UPDATE ON public.approval_permissions FOR EACH ROW EXECUTE FUNCTION public.update_approval_permissions_updated_at();


--
-- Name: approval_permissions approval_permissions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: approval_permissions approval_permissions_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: approval_permissions approval_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: approval_permissions Allow all access to approval_permissions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to approval_permissions" ON public.approval_permissions USING (true) WITH CHECK (true);


--
-- Name: approval_permissions Allow all to view approval permissions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all to view approval permissions" ON public.approval_permissions FOR SELECT USING (true);


--
-- Name: approval_permissions Allow anon insert approval_permissions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert approval_permissions" ON public.approval_permissions FOR INSERT TO anon WITH CHECK (true);


--
-- Name: approval_permissions allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.approval_permissions USING (true) WITH CHECK (true);


--
-- Name: approval_permissions allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.approval_permissions FOR DELETE USING (true);


--
-- Name: approval_permissions allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.approval_permissions FOR INSERT WITH CHECK (true);


--
-- Name: approval_permissions allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.approval_permissions FOR SELECT USING (true);


--
-- Name: approval_permissions allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.approval_permissions FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: approval_permissions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.approval_permissions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: approval_permissions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.approval_permissions ENABLE ROW LEVEL SECURITY;

--
-- Name: approval_permissions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.approval_permissions USING ((auth.uid() IS NOT NULL));


--
-- Name: TABLE approval_permissions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.approval_permissions TO anon;
GRANT ALL ON TABLE public.approval_permissions TO authenticated;
GRANT ALL ON TABLE public.approval_permissions TO service_role;
GRANT SELECT ON TABLE public.approval_permissions TO replication_user;


--
-- Name: SEQUENCE approval_permissions_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.approval_permissions_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.approval_permissions_id_seq TO anon;
GRANT ALL ON SEQUENCE public.approval_permissions_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.approval_permissions_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

