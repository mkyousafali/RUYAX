CREATE POLICY denomination_records_update ON public.denomination_records FOR UPDATE USING (true);


--
-- Name: denomination_transactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.denomination_transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: denomination_types; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.denomination_types ENABLE ROW LEVEL SECURITY;

--
-- Name: denomination_types denomination_types_delete; Type: POLICY; Schema: public; Owner: -
--

