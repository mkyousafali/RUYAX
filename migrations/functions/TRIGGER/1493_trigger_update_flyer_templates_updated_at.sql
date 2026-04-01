CREATE TRIGGER trigger_update_flyer_templates_updated_at BEFORE UPDATE ON public.flyer_templates FOR EACH ROW EXECUTE FUNCTION public.update_flyer_templates_updated_at();


--
-- Name: interface_permissions trigger_update_interface_permissions_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

