CREATE POLICY anon_full_access ON public.expense_scheduler USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: expense_sub_categories anon_full_access; Type: POLICY; Schema: public; Owner: -
--

