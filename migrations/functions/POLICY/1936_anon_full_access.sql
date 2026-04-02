CREATE POLICY anon_full_access ON public.expense_requisitions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: expense_scheduler anon_full_access; Type: POLICY; Schema: public; Owner: -
--

