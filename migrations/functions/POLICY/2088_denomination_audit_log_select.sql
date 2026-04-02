CREATE POLICY denomination_audit_log_select ON public.denomination_audit_log FOR SELECT USING (true);


--
-- Name: denomination_records; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.denomination_records ENABLE ROW LEVEL SECURITY;

--
-- Name: denomination_records denomination_records_delete; Type: POLICY; Schema: public; Owner: -
--

