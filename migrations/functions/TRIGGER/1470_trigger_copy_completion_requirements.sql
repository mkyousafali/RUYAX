CREATE TRIGGER trigger_copy_completion_requirements AFTER INSERT ON public.quick_task_assignments FOR EACH ROW EXECUTE FUNCTION public.copy_completion_requirements_to_assignment();


--
-- Name: users trigger_create_default_interface_permissions; Type: TRIGGER; Schema: public; Owner: -
--

