CREATE TRIGGER erp_daily_sales_notify_trigger AFTER INSERT OR DELETE OR UPDATE ON public.erp_daily_sales FOR EACH ROW EXECUTE FUNCTION public.notify_erp_daily_sales_change();


--
-- Name: expense_scheduler expense_scheduler_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

