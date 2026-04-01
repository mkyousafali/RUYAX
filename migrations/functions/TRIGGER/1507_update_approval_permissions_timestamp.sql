CREATE TRIGGER update_approval_permissions_timestamp BEFORE UPDATE ON public.approval_permissions FOR EACH ROW EXECUTE FUNCTION public.update_approval_permissions_updated_at();


--
-- Name: customer_app_media update_customer_app_media_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

