CREATE TRIGGER lease_rent_lease_parties_timestamp_update BEFORE UPDATE ON public.lease_rent_lease_parties FOR EACH ROW EXECUTE FUNCTION public.update_lease_rent_lease_parties_timestamp();


--
-- Name: lease_rent_properties lease_rent_properties_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

