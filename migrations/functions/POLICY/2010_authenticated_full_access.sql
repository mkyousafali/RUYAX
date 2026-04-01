CREATE POLICY authenticated_full_access ON public.expense_requisitions USING ((auth.uid() IS NOT NULL));


--
-- Name: expense_scheduler authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

