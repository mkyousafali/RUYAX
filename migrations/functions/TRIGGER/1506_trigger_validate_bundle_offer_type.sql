CREATE TRIGGER trigger_validate_bundle_offer_type BEFORE INSERT OR UPDATE ON public.offer_bundles FOR EACH ROW EXECUTE FUNCTION public.validate_bundle_offer_type();


--
-- Name: approval_permissions update_approval_permissions_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

