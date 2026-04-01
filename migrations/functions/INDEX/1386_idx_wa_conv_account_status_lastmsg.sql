CREATE INDEX idx_wa_conv_account_status_lastmsg ON public.wa_conversations USING btree (wa_account_id, status, last_message_at DESC);


--
-- Name: idx_wa_conversations_account; Type: INDEX; Schema: public; Owner: -
--

