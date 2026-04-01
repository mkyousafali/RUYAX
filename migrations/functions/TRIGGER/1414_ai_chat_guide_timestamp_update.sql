CREATE TRIGGER ai_chat_guide_timestamp_update BEFORE UPDATE ON public.ai_chat_guide FOR EACH ROW EXECUTE FUNCTION public.update_ai_chat_guide_timestamp();


--
-- Name: approver_visibility_config approver_visibility_config_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

