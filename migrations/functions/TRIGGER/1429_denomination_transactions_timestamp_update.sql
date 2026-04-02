CREATE TRIGGER denomination_transactions_timestamp_update BEFORE UPDATE ON public.denomination_transactions FOR EACH ROW EXECUTE FUNCTION public.update_denomination_transactions_timestamp();


--
-- Name: denomination_types denomination_types_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

