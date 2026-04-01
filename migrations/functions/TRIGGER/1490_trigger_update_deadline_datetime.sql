CREATE TRIGGER trigger_update_deadline_datetime BEFORE INSERT OR UPDATE OF deadline_date, deadline_time ON public.task_assignments FOR EACH ROW EXECUTE FUNCTION public.update_deadline_datetime();


--
-- Name: delivery_service_settings trigger_update_delivery_settings_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

