CREATE POLICY system_insert_order_items ON public.order_items FOR INSERT WITH CHECK ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.customer_id = auth.uid()) OR public.has_order_management_access(auth.uid())))));


--
-- Name: task_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.task_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: task_completions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.task_completions ENABLE ROW LEVEL SECURITY;

--
-- Name: task_images; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.task_images ENABLE ROW LEVEL SECURITY;

--
-- Name: task_reminder_logs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.task_reminder_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: tasks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

--
-- Name: user_audit_logs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_audit_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: user_device_sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_device_sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: user_favorite_buttons; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_favorite_buttons ENABLE ROW LEVEL SECURITY;

--
-- Name: user_mobile_theme_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_mobile_theme_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: user_password_history; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_password_history ENABLE ROW LEVEL SECURITY;

--
-- Name: user_sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: user_theme_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_theme_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: user_voice_preferences; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_voice_preferences ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: order_audit_logs users_view_order_audit_logs; Type: POLICY; Schema: public; Owner: -
--

