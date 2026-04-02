CREATE POLICY interface_permissions_update_policy ON public.interface_permissions FOR UPDATE USING (true);


--
-- Name: lease_rent_lease_parties; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lease_rent_lease_parties ENABLE ROW LEVEL SECURITY;

--
-- Name: lease_rent_payment_entries; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lease_rent_payment_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: lease_rent_payments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lease_rent_payments ENABLE ROW LEVEL SECURITY;

--
-- Name: lease_rent_properties; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lease_rent_properties ENABLE ROW LEVEL SECURITY;

--
-- Name: lease_rent_property_spaces; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lease_rent_property_spaces ENABLE ROW LEVEL SECURITY;

--
-- Name: lease_rent_rent_parties; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lease_rent_rent_parties ENABLE ROW LEVEL SECURITY;

--
-- Name: lease_rent_special_changes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lease_rent_special_changes ENABLE ROW LEVEL SECURITY;

--
-- Name: order_items management_delete_order_items; Type: POLICY; Schema: public; Owner: -
--

