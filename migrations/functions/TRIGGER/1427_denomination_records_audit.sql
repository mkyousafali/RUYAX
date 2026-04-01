CREATE TRIGGER denomination_records_audit AFTER INSERT OR DELETE OR UPDATE ON public.denomination_records FOR EACH ROW EXECUTE FUNCTION public.denomination_audit_trigger();


--
-- Name: denomination_records denomination_records_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

