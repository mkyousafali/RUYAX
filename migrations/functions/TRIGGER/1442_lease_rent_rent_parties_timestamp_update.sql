CREATE TRIGGER lease_rent_rent_parties_timestamp_update BEFORE UPDATE ON public.lease_rent_rent_parties FOR EACH ROW EXECUTE FUNCTION public.update_lease_rent_rent_parties_timestamp();


--
-- Name: multi_shift_date_wise multi_shift_date_wise_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

