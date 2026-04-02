CREATE TRIGGER user_theme_assignments_timestamp_update BEFORE UPDATE ON public.user_theme_assignments FOR EACH ROW EXECUTE FUNCTION public.update_user_theme_assignments_timestamp();


--
-- Name: users users_audit_trigger; Type: TRIGGER; Schema: public; Owner: -
--

