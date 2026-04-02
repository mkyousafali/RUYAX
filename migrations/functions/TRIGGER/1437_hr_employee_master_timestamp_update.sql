CREATE TRIGGER hr_employee_master_timestamp_update BEFORE UPDATE ON public.hr_employee_master FOR EACH ROW EXECUTE FUNCTION public.update_hr_employee_master_timestamp();


--
-- Name: purchase_voucher_issue_types issue_types_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

