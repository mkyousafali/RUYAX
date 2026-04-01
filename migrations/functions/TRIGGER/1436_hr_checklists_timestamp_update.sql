CREATE TRIGGER hr_checklists_timestamp_update BEFORE UPDATE ON public.hr_checklists FOR EACH ROW EXECUTE FUNCTION public.update_hr_checklists_timestamp();


--
-- Name: hr_employee_master hr_employee_master_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

