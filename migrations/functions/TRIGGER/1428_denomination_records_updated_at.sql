CREATE TRIGGER denomination_records_updated_at BEFORE UPDATE ON public.denomination_records FOR EACH ROW EXECUTE FUNCTION public.update_denomination_updated_at();


--
-- Name: denomination_transactions denomination_transactions_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

