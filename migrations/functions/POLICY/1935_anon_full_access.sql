CREATE POLICY anon_full_access ON public.expense_parent_categories USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: expense_requisitions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

