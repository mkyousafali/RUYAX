CREATE TRIGGER sync_requisition_balance_trigger AFTER INSERT OR UPDATE ON public.expense_scheduler FOR EACH ROW EXECUTE FUNCTION public.sync_requisition_balance();


--
-- Name: hr_positions sync_roles_on_position_changes; Type: TRIGGER; Schema: public; Owner: -
--

