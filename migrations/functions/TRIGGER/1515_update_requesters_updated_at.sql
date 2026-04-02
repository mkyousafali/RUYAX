CREATE TRIGGER update_requesters_updated_at BEFORE UPDATE ON public.requesters FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: shelf_paper_templates update_shelf_paper_templates_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

