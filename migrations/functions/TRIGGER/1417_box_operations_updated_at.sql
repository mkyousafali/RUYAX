CREATE TRIGGER box_operations_updated_at BEFORE UPDATE ON public.box_operations FOR EACH ROW EXECUTE FUNCTION public.update_box_operations_updated_at();


--
-- Name: branch_default_positions branch_default_positions_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

