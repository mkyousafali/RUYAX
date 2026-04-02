CREATE TRIGGER set_branch_delivery_receivers_updated_at BEFORE UPDATE ON public.branch_default_delivery_receivers FOR EACH ROW EXECUTE FUNCTION public.update_branch_delivery_receivers_updated_at();


--
-- Name: push_subscriptions set_push_subscriptions_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

