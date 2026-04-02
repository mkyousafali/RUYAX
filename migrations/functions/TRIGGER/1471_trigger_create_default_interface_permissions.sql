CREATE TRIGGER trigger_create_default_interface_permissions AFTER INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.create_default_interface_permissions();


--
-- Name: notifications trigger_create_notification_recipients; Type: TRIGGER; Schema: public; Owner: -
--

