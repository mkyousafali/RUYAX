CREATE POLICY allow_update ON public.expense_parent_categories FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: expense_requisitions allow_update; Type: POLICY; Schema: public; Owner: -
--

