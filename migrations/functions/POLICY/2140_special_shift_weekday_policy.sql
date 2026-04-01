CREATE POLICY special_shift_weekday_policy ON public.special_shift_weekday USING (true) WITH CHECK (true);


--
-- Name: system_api_keys; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.system_api_keys ENABLE ROW LEVEL SECURITY;

--
-- Name: order_audit_logs system_insert_audit_logs; Type: POLICY; Schema: public; Owner: -
--

