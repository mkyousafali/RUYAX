CREATE POLICY pvi_service_role_all ON public.purchase_voucher_items USING (true);


--
-- Name: quick_task_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.quick_task_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: quick_task_comments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.quick_task_comments ENABLE ROW LEVEL SECURITY;

--
-- Name: quick_task_completions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.quick_task_completions ENABLE ROW LEVEL SECURITY;

--
-- Name: quick_task_files; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.quick_task_files ENABLE ROW LEVEL SECURITY;

--
-- Name: quick_task_user_preferences; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.quick_task_user_preferences ENABLE ROW LEVEL SECURITY;

--
-- Name: quick_tasks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.quick_tasks ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_access_code_history realtime_access_code_history_select; Type: POLICY; Schema: public; Owner: -
--

