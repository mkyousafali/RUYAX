CREATE TRIGGER trg_generate_insurance_company_id BEFORE INSERT ON public.hr_insurance_companies FOR EACH ROW EXECUTE FUNCTION public.generate_insurance_company_id();


--
-- Name: vendor_payment_schedule trg_update_final_bill_amount; Type: TRIGGER; Schema: public; Owner: -
--

