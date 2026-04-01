CREATE TRIGGER trigger_sync_erp_on_completion AFTER INSERT OR UPDATE ON public.task_completions FOR EACH ROW EXECUTE FUNCTION public.trigger_sync_erp_reference_on_task_completion();


--
-- Name: bogo_offer_rules trigger_update_bogo_offer_rules_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

