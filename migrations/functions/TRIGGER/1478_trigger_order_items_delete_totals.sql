CREATE TRIGGER trigger_order_items_delete_totals AFTER DELETE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.trigger_update_order_totals();


--
-- Name: order_items trigger_order_items_insert_totals; Type: TRIGGER; Schema: public; Owner: -
--

