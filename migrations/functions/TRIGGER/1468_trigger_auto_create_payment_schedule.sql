CREATE TRIGGER trigger_auto_create_payment_schedule AFTER INSERT OR UPDATE OF certificate_url ON public.receiving_records FOR EACH ROW EXECUTE FUNCTION public.auto_create_payment_schedule();


--
-- Name: products trigger_calculate_flyer_product_profit; Type: TRIGGER; Schema: public; Owner: -
--

