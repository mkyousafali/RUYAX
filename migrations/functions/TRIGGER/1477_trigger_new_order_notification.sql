CREATE TRIGGER trigger_new_order_notification AFTER INSERT ON public.orders FOR EACH ROW EXECUTE FUNCTION public.trigger_notify_new_order();


--
-- Name: order_items trigger_order_items_delete_totals; Type: TRIGGER; Schema: public; Owner: -
--

