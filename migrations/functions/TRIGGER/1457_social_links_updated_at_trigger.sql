CREATE TRIGGER social_links_updated_at_trigger BEFORE UPDATE ON public.social_links FOR EACH ROW EXECUTE FUNCTION public.update_social_links_updated_at();


--
-- Name: special_shift_date_wise special_shift_date_wise_timestamp_trigger; Type: TRIGGER; Schema: public; Owner: -
--

