CREATE TRIGGER trigger_update_receiving_task_templates_updated_at BEFORE UPDATE ON public.receiving_task_templates FOR EACH ROW EXECUTE FUNCTION public.update_receiving_task_templates_updated_at();


--
-- Name: receiving_tasks trigger_update_receiving_tasks_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

