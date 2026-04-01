CREATE TRIGGER branch_default_positions_timestamp_update BEFORE UPDATE ON public.branch_default_positions FOR EACH ROW EXECUTE FUNCTION public.update_branch_default_positions_timestamp();


--
-- Name: branches branches_notify_trigger; Type: TRIGGER; Schema: public; Owner: -
--

