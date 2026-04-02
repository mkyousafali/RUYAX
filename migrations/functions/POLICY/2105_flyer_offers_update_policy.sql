CREATE POLICY flyer_offers_update_policy ON public.flyer_offers FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: flyer_templates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.flyer_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: frontend_builds; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.frontend_builds ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_analysed_attendance_data; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_analysed_attendance_data ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_basic_salary; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_basic_salary ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_checklist_operations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_checklist_operations ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_checklist_questions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_checklist_questions ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_checklists; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_checklists ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_departments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_departments ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_employee_master; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_employee_master ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_employees; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_employees ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_fingerprint_transactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_fingerprint_transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_insurance_companies; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_insurance_companies ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_levels; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_levels ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_position_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_position_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_position_reporting_template; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_position_reporting_template ENABLE ROW LEVEL SECURITY;

--
-- Name: hr_positions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_positions ENABLE ROW LEVEL SECURITY;

--
-- Name: incident_actions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.incident_actions ENABLE ROW LEVEL SECURITY;

--
-- Name: incident_types; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.incident_types ENABLE ROW LEVEL SECURITY;

--
-- Name: incidents; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.incidents ENABLE ROW LEVEL SECURITY;

--
-- Name: interface_permissions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.interface_permissions ENABLE ROW LEVEL SECURITY;

--
-- Name: interface_permissions interface_permissions_delete_policy; Type: POLICY; Schema: public; Owner: -
--

