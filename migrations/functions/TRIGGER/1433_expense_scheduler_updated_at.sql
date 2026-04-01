CREATE TRIGGER expense_scheduler_updated_at BEFORE UPDATE ON public.expense_scheduler FOR EACH ROW EXECUTE FUNCTION public.update_expense_scheduler_updated_at();


--
-- Name: hr_checklist_operations hr_checklist_operations_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

