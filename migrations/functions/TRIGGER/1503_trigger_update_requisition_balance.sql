CREATE TRIGGER trigger_update_requisition_balance AFTER INSERT OR DELETE OR UPDATE ON public.expense_scheduler FOR EACH ROW EXECUTE FUNCTION public.update_requisition_balance();


--
-- Name: expense_scheduler trigger_update_requisition_balance_old; Type: TRIGGER; Schema: public; Owner: -
--

