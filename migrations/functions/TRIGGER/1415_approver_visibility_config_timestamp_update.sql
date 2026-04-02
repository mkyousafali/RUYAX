CREATE TRIGGER approver_visibility_config_timestamp_update BEFORE UPDATE ON public.approver_visibility_config FOR EACH ROW EXECUTE FUNCTION public.update_approver_visibility_config_timestamp();


--
-- Name: bank_reconciliations bank_reconciliations_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

