CREATE TRIGGER trigger_ensure_single_default_flyer_template BEFORE INSERT OR UPDATE OF is_default ON public.flyer_templates FOR EACH ROW WHEN ((new.is_default = true)) EXECUTE FUNCTION public.ensure_single_default_flyer_template();


--
-- Name: order_items trigger_link_offer_usage_to_order; Type: TRIGGER; Schema: public; Owner: -
--

