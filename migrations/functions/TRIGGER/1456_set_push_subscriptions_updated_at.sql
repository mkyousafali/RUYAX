CREATE TRIGGER set_push_subscriptions_updated_at BEFORE UPDATE ON public.push_subscriptions FOR EACH ROW EXECUTE FUNCTION public.update_push_subscriptions_updated_at();


--
-- Name: social_links social_links_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

