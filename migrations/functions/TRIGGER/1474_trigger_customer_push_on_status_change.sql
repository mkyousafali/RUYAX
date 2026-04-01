CREATE TRIGGER trigger_customer_push_on_status_change AFTER INSERT ON public.order_audit_logs FOR EACH ROW WHEN (((new.action_type)::text = 'status_change'::text)) EXECUTE FUNCTION public.notify_customer_order_status_change();


--
-- Name: flyer_templates trigger_ensure_single_default_flyer_template; Type: TRIGGER; Schema: public; Owner: -
--

