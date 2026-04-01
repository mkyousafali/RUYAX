CREATE POLICY allow_update ON public.expense_requisitions FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: expense_scheduler allow_update; Type: POLICY; Schema: public; Owner: -
--

