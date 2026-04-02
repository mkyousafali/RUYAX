CREATE TRIGGER regular_shift_timestamp_update BEFORE UPDATE ON public.regular_shift FOR EACH ROW EXECUTE FUNCTION public.update_regular_shift_timestamp();


--
-- Name: branch_default_delivery_receivers set_branch_delivery_receivers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

