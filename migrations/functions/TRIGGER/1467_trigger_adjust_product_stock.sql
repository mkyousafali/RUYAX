CREATE TRIGGER trigger_adjust_product_stock BEFORE INSERT ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.adjust_product_stock_on_order_insert();


--
-- Name: receiving_records trigger_auto_create_payment_schedule; Type: TRIGGER; Schema: public; Owner: -
--

