CREATE TRIGGER trigger_update_requisition_balance_old BEFORE DELETE OR UPDATE ON public.expense_scheduler FOR EACH ROW EXECUTE FUNCTION public.update_requisition_balance_old();


--
-- Name: user_device_sessions trigger_user_device_sessions_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

