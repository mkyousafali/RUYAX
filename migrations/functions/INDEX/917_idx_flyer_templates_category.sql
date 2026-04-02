CREATE INDEX idx_flyer_templates_category ON public.flyer_templates USING btree (category) WHERE (deleted_at IS NULL);


--
-- Name: idx_flyer_templates_created_at; Type: INDEX; Schema: public; Owner: -
--

