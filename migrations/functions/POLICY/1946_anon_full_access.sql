CREATE POLICY anon_full_access ON public.hr_levels USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_position_assignments anon_full_access; Type: POLICY; Schema: public; Owner: -
--

