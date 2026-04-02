CREATE INDEX idx_flyer_templates_is_active ON public.flyer_templates USING btree (is_active) WHERE (deleted_at IS NULL);


--
-- Name: idx_flyer_templates_is_default; Type: INDEX; Schema: public; Owner: -
--

