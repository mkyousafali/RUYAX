CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: user_theme_assignments user_theme_assignments_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

