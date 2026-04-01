CREATE TRIGGER branches_notify_trigger AFTER INSERT OR DELETE OR UPDATE ON public.branches FOR EACH ROW EXECUTE FUNCTION public.notify_branches_change();


--
-- Name: receiving_records calculate_receiving_amounts_trigger; Type: TRIGGER; Schema: public; Owner: -
--

