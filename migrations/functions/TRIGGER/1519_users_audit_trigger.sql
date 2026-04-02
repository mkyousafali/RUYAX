CREATE TRIGGER users_audit_trigger AFTER INSERT OR DELETE OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.log_user_action();


--
-- Name: warning_main_category warning_main_category_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

