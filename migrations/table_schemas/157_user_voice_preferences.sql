--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: user_voice_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_voice_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    locale text NOT NULL,
    voice_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_voice_preferences_locale_check CHECK ((locale = ANY (ARRAY['en'::text, 'ar'::text])))
);


--
-- Name: user_voice_preferences user_voice_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_voice_preferences
    ADD CONSTRAINT user_voice_preferences_pkey PRIMARY KEY (id);


--
-- Name: user_voice_preferences user_voice_preferences_user_id_locale_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_voice_preferences
    ADD CONSTRAINT user_voice_preferences_user_id_locale_key UNIQUE (user_id, locale);


--
-- Name: idx_user_voice_preferences_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_voice_preferences_user_id ON public.user_voice_preferences USING btree (user_id);


--
-- Name: user_voice_preferences Allow all access to user_voice_preferences; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to user_voice_preferences" ON public.user_voice_preferences USING (true) WITH CHECK (true);


--
-- Name: user_voice_preferences Allow all operations for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all operations for authenticated users" ON public.user_voice_preferences TO authenticated USING (true) WITH CHECK (true);


--
-- Name: user_voice_preferences; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_voice_preferences ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE user_voice_preferences; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.user_voice_preferences TO anon;
GRANT ALL ON TABLE public.user_voice_preferences TO authenticated;
GRANT ALL ON TABLE public.user_voice_preferences TO service_role;
GRANT SELECT ON TABLE public.user_voice_preferences TO replication_user;


--
-- PostgreSQL database dump complete
--

