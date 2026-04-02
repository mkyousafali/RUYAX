CREATE TRIGGER trigger_update_pos_deduction_transfers_updated_at BEFORE UPDATE ON public.pos_deduction_transfers FOR EACH ROW EXECUTE FUNCTION public.update_pos_deduction_transfers_updated_at();


--
-- Name: quick_task_completions trigger_update_quick_task_completions_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

