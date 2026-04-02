CREATE POLICY authenticated_full_access ON public.expense_parent_categories USING ((auth.uid() IS NOT NULL));


--
-- Name: expense_requisitions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

