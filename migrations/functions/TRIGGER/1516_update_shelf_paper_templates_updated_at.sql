CREATE TRIGGER update_shelf_paper_templates_updated_at BEFORE UPDATE ON public.shelf_paper_templates FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

