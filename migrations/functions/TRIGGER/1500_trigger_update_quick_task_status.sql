CREATE TRIGGER trigger_update_quick_task_status AFTER UPDATE ON public.quick_task_assignments FOR EACH ROW EXECUTE FUNCTION public.update_quick_task_status();


--
-- Name: receiving_task_templates trigger_update_receiving_task_templates_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

