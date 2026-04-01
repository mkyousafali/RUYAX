CREATE TRIGGER sync_roles_on_position_changes AFTER INSERT OR DELETE OR UPDATE ON public.hr_positions FOR EACH ROW EXECUTE FUNCTION public.sync_user_roles_from_positions();


--
-- Name: system_api_keys system_api_keys_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

