CREATE TRIGGER trigger_update_interface_permissions_updated_at BEFORE UPDATE ON public.interface_permissions FOR EACH ROW EXECUTE FUNCTION public.update_interface_permissions_updated_at();


--
-- Name: near_expiry_reports trigger_update_near_expiry_reports_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

