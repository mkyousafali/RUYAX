CREATE TRIGGER hr_checklist_operations_timestamp_update BEFORE UPDATE ON public.hr_checklist_operations FOR EACH ROW EXECUTE FUNCTION public.update_hr_checklist_operations_timestamp();


--
-- Name: hr_checklist_questions hr_checklist_questions_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

