CREATE TRIGGER trigger_update_branches_updated_at BEFORE UPDATE ON public.branches FOR EACH ROW EXECUTE FUNCTION public.update_branches_updated_at();


--
-- Name: coupon_campaigns trigger_update_coupon_campaigns_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

