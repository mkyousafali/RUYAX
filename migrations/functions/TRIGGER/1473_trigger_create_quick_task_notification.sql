CREATE TRIGGER trigger_create_quick_task_notification AFTER INSERT ON public.quick_task_assignments FOR EACH ROW EXECUTE FUNCTION public.create_quick_task_notification();


--
-- Name: order_audit_logs trigger_customer_push_on_status_change; Type: TRIGGER; Schema: public; Owner: -
--

