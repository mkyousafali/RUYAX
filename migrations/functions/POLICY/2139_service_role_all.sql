CREATE POLICY service_role_all ON public.access_code_otp TO service_role USING (true) WITH CHECK (true);


--
-- Name: shelf_paper_fonts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shelf_paper_fonts ENABLE ROW LEVEL SECURITY;

--
-- Name: shelf_paper_templates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shelf_paper_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: sidebar_buttons; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.sidebar_buttons ENABLE ROW LEVEL SECURITY;

--
-- Name: social_links; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.social_links ENABLE ROW LEVEL SECURITY;

--
-- Name: special_shift_date_wise; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.special_shift_date_wise ENABLE ROW LEVEL SECURITY;

--
-- Name: special_shift_weekday; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.special_shift_weekday ENABLE ROW LEVEL SECURITY;

--
-- Name: special_shift_weekday special_shift_weekday_policy; Type: POLICY; Schema: public; Owner: -
--

