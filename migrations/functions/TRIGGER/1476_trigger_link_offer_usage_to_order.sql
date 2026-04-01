CREATE TRIGGER trigger_link_offer_usage_to_order AFTER INSERT ON public.order_items FOR EACH ROW WHEN (((new.has_offer = true) AND (new.offer_id IS NOT NULL))) EXECUTE FUNCTION public.trigger_log_order_offer_usage();


--
-- Name: orders trigger_new_order_notification; Type: TRIGGER; Schema: public; Owner: -
--

