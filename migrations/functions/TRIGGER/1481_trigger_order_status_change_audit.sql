CREATE TRIGGER trigger_order_status_change_audit AFTER UPDATE ON public.orders FOR EACH ROW WHEN (((old.order_status)::text IS DISTINCT FROM (new.order_status)::text)) EXECUTE FUNCTION public.trigger_order_status_audit();


--
-- Name: quick_task_assignments trigger_order_task_completion; Type: TRIGGER; Schema: public; Owner: -
--

