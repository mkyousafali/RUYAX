CREATE TRIGGER desktop_themes_timestamp_update BEFORE UPDATE ON public.desktop_themes FOR EACH ROW EXECUTE FUNCTION public.update_desktop_themes_timestamp();


--
-- Name: erp_daily_sales erp_daily_sales_notify_trigger; Type: TRIGGER; Schema: public; Owner: -
--

