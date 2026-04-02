CREATE TRIGGER special_shift_weekday_timestamp_update BEFORE UPDATE ON public.special_shift_weekday FOR EACH ROW EXECUTE FUNCTION public.update_special_shift_weekday_timestamp();


--
-- Name: expense_scheduler sync_requisition_balance_trigger; Type: TRIGGER; Schema: public; Owner: -
--

