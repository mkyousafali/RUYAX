CREATE POLICY box_operations_update ON public.box_operations FOR UPDATE USING (true);


--
-- Name: branch_default_delivery_receivers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.branch_default_delivery_receivers ENABLE ROW LEVEL SECURITY;

--
-- Name: branch_default_positions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.branch_default_positions ENABLE ROW LEVEL SECURITY;

--
-- Name: branch_sync_config; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.branch_sync_config ENABLE ROW LEVEL SECURITY;

--
-- Name: branch_sync_config branch_sync_config_modify; Type: POLICY; Schema: public; Owner: -
--

