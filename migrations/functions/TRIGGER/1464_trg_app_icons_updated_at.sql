CREATE TRIGGER trg_app_icons_updated_at BEFORE UPDATE ON public.app_icons FOR EACH ROW EXECUTE FUNCTION public.update_app_icons_updated_at();


--
-- Name: hr_insurance_companies trg_generate_insurance_company_id; Type: TRIGGER; Schema: public; Owner: -
--

