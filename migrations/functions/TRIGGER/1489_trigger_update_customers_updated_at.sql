CREATE TRIGGER trigger_update_customers_updated_at BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION public.update_customers_updated_at();


--
-- Name: task_assignments trigger_update_deadline_datetime; Type: TRIGGER; Schema: public; Owner: -
--

