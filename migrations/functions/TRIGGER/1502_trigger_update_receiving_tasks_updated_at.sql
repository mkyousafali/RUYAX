CREATE TRIGGER trigger_update_receiving_tasks_updated_at BEFORE UPDATE ON public.receiving_tasks FOR EACH ROW EXECUTE FUNCTION public.update_receiving_tasks_updated_at();


--
-- Name: expense_scheduler trigger_update_requisition_balance; Type: TRIGGER; Schema: public; Owner: -
--

