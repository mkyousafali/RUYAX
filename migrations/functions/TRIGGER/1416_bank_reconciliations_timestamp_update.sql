CREATE TRIGGER bank_reconciliations_timestamp_update BEFORE UPDATE ON public.bank_reconciliations FOR EACH ROW EXECUTE FUNCTION public.update_bank_reconciliations_timestamp();


--
-- Name: box_operations box_operations_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

