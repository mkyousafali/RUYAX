CREATE TRIGGER trigger_update_quick_task_completions_updated_at BEFORE UPDATE ON public.quick_task_completions FOR EACH ROW EXECUTE FUNCTION public.update_quick_task_completions_updated_at();


--
-- Name: quick_task_assignments trigger_update_quick_task_status; Type: TRIGGER; Schema: public; Owner: -
--

