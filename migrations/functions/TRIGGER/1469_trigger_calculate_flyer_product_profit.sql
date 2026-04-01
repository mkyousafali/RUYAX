CREATE TRIGGER trigger_calculate_flyer_product_profit BEFORE INSERT OR UPDATE OF sale_price, cost ON public.products FOR EACH ROW EXECUTE FUNCTION public.calculate_flyer_product_profit();


--
-- Name: quick_task_assignments trigger_copy_completion_requirements; Type: TRIGGER; Schema: public; Owner: -
--

