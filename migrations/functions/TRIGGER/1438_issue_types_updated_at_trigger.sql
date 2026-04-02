CREATE TRIGGER issue_types_updated_at_trigger BEFORE UPDATE ON public.purchase_voucher_issue_types FOR EACH ROW EXECUTE FUNCTION public.update_issue_types_updated_at();


--
-- Name: lease_rent_lease_parties lease_rent_lease_parties_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

