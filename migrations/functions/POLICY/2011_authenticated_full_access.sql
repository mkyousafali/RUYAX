CREATE POLICY authenticated_full_access ON public.expense_scheduler USING ((auth.uid() IS NOT NULL));


--
-- Name: expense_sub_categories authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

