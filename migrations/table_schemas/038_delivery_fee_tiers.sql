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
-- Name: delivery_fee_tiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_fee_tiers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    min_order_amount numeric(10,2) NOT NULL,
    max_order_amount numeric(10,2),
    delivery_fee numeric(10,2) NOT NULL,
    tier_order integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    description_en text,
    description_ar text,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    branch_id bigint,
    CONSTRAINT check_delivery_fee_positive CHECK ((delivery_fee >= (0)::numeric)),
    CONSTRAINT check_min_amount_positive CHECK ((min_order_amount >= (0)::numeric)),
    CONSTRAINT check_min_max_order CHECK (((max_order_amount IS NULL) OR (max_order_amount > min_order_amount)))
);


--
-- Name: TABLE delivery_fee_tiers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.delivery_fee_tiers IS 'Multi-tier delivery fee system - Migration 20251107000000';


--
-- Name: COLUMN delivery_fee_tiers.min_order_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.delivery_fee_tiers.min_order_amount IS 'Minimum order amount for this tier (SAR)';


--
-- Name: COLUMN delivery_fee_tiers.max_order_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.delivery_fee_tiers.max_order_amount IS 'Maximum order amount for this tier, NULL for unlimited';


--
-- Name: COLUMN delivery_fee_tiers.delivery_fee; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.delivery_fee_tiers.delivery_fee IS 'Delivery fee charged for orders in this tier (SAR)';


--
-- Name: COLUMN delivery_fee_tiers.tier_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.delivery_fee_tiers.tier_order IS 'Display order for admin interface';


--
-- Name: COLUMN delivery_fee_tiers.branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.delivery_fee_tiers.branch_id IS 'When NULL, tier is global. When set, tier applies only to this branch.';


--
-- Name: delivery_fee_tiers delivery_fee_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_pkey PRIMARY KEY (id);


--
-- Name: idx_delivery_tiers_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_delivery_tiers_active ON public.delivery_fee_tiers USING btree (is_active);


--
-- Name: idx_delivery_tiers_branch_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_delivery_tiers_branch_order ON public.delivery_fee_tiers USING btree (branch_id, tier_order);


--
-- Name: idx_delivery_tiers_branch_order_amount; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_delivery_tiers_branch_order_amount ON public.delivery_fee_tiers USING btree (branch_id, min_order_amount, max_order_amount) WHERE (is_active = true);


--
-- Name: idx_delivery_tiers_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_delivery_tiers_order ON public.delivery_fee_tiers USING btree (tier_order);


--
-- Name: idx_delivery_tiers_order_amount; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_delivery_tiers_order_amount ON public.delivery_fee_tiers USING btree (min_order_amount, max_order_amount);


--
-- Name: ux_delivery_tiers_scope_order; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_delivery_tiers_scope_order ON public.delivery_fee_tiers USING btree (COALESCE(branch_id, ('-1'::integer)::bigint), tier_order);


--
-- Name: delivery_fee_tiers trigger_update_delivery_tiers_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_delivery_tiers_timestamp BEFORE UPDATE ON public.delivery_fee_tiers FOR EACH ROW EXECUTE FUNCTION public.update_delivery_tiers_timestamp();


--
-- Name: delivery_fee_tiers delivery_fee_tiers_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: delivery_fee_tiers delivery_fee_tiers_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: delivery_fee_tiers delivery_fee_tiers_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: delivery_fee_tiers Allow anon insert delivery_fee_tiers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert delivery_fee_tiers" ON public.delivery_fee_tiers FOR INSERT TO anon WITH CHECK (true);


--
-- Name: delivery_fee_tiers allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.delivery_fee_tiers USING (true) WITH CHECK (true);


--
-- Name: delivery_fee_tiers allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.delivery_fee_tiers FOR DELETE USING (true);


--
-- Name: delivery_fee_tiers allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.delivery_fee_tiers FOR INSERT WITH CHECK (true);


--
-- Name: delivery_fee_tiers allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.delivery_fee_tiers FOR SELECT USING (true);


--
-- Name: delivery_fee_tiers allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.delivery_fee_tiers FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: delivery_fee_tiers anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.delivery_fee_tiers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: delivery_fee_tiers authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.delivery_fee_tiers USING ((auth.uid() IS NOT NULL));


--
-- Name: delivery_fee_tiers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.delivery_fee_tiers ENABLE ROW LEVEL SECURITY;

--
-- Name: delivery_fee_tiers delivery_tiers_select_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY delivery_tiers_select_all ON public.delivery_fee_tiers FOR SELECT USING (true);


--
-- Name: TABLE delivery_fee_tiers; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.delivery_fee_tiers TO anon;
GRANT SELECT ON TABLE public.delivery_fee_tiers TO authenticated;
GRANT ALL ON TABLE public.delivery_fee_tiers TO service_role;
GRANT SELECT ON TABLE public.delivery_fee_tiers TO replication_user;


--
-- PostgreSQL database dump complete
--

