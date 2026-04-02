CREATE TRIGGER update_offer_products_updated_at BEFORE UPDATE ON public.offer_products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: orders update_orders_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

