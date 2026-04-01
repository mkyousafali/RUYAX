CREATE TRIGGER purchase_vouchers_updated_at_trigger BEFORE UPDATE ON public.purchase_vouchers FOR EACH ROW EXECUTE FUNCTION public.update_purchase_vouchers_updated_at();


--
-- Name: receiving_user_defaults receiving_user_defaults_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

