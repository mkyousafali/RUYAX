CREATE TRIGGER hr_checklist_questions_timestamp_update BEFORE UPDATE ON public.hr_checklist_questions FOR EACH ROW EXECUTE FUNCTION public.update_hr_checklist_questions_timestamp();


--
-- Name: hr_checklists hr_checklists_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

