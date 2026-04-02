CREATE TRIGGER lease_rent_property_spaces_timestamp_update BEFORE UPDATE ON public.lease_rent_property_spaces FOR EACH ROW EXECUTE FUNCTION public.update_lease_rent_property_spaces_timestamp();


--
-- Name: lease_rent_rent_parties lease_rent_rent_parties_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

