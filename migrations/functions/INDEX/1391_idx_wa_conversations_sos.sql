CREATE INDEX idx_wa_conversations_sos ON public.wa_conversations USING btree (is_sos) WHERE (is_sos = true);


--
-- Name: idx_wa_group_members_customer; Type: INDEX; Schema: public; Owner: -
--

