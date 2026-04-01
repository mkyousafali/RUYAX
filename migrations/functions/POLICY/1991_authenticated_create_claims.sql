CREATE POLICY authenticated_create_claims ON public.coupon_claims FOR INSERT TO authenticated WITH CHECK ((claimed_by_user = auth.uid()));


--
-- Name: approval_permissions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

