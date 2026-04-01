CREATE TRIGGER trigger_order_task_completion AFTER UPDATE ON public.quick_task_assignments FOR EACH ROW WHEN ((((old.status)::text IS DISTINCT FROM (new.status)::text) AND ((new.status)::text = 'completed'::text))) EXECUTE FUNCTION public.handle_order_task_completion();


--
-- Name: task_completions trigger_sync_erp_on_completion; Type: TRIGGER; Schema: public; Owner: -
--

