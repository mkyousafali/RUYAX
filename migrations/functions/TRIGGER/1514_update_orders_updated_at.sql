CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: requesters update_requesters_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

