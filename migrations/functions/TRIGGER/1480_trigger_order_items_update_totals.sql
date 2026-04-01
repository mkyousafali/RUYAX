CREATE TRIGGER trigger_order_items_update_totals AFTER UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.trigger_update_order_totals();


--
-- Name: orders trigger_order_status_change_audit; Type: TRIGGER; Schema: public; Owner: -
--

