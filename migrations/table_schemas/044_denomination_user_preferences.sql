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
-- Name: denomination_user_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.denomination_user_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    default_branch_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE denomination_user_preferences; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.denomination_user_preferences IS 'Stores user preferences for the Denomination feature';


--
-- Name: COLUMN denomination_user_preferences.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_user_preferences.user_id IS 'Reference to the user';


--
-- Name: COLUMN denomination_user_preferences.default_branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_user_preferences.default_branch_id IS 'Default branch selected by the user for denomination';


--
-- Name: denomination_user_preferences denomination_user_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_pkey PRIMARY KEY (id);


--
-- Name: denomination_user_preferences denomination_user_preferences_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_user_id_key UNIQUE (user_id);


--
-- Name: idx_denomination_user_preferences_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_user_preferences_user_id ON public.denomination_user_preferences USING btree (user_id);


--
-- Name: denomination_user_preferences denomination_user_preferences_default_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_default_branch_id_fkey FOREIGN KEY (default_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: denomination_user_preferences denomination_user_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: TABLE denomination_user_preferences; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.denomination_user_preferences TO anon;
GRANT ALL ON TABLE public.denomination_user_preferences TO authenticated;
GRANT ALL ON TABLE public.denomination_user_preferences TO service_role;
GRANT SELECT ON TABLE public.denomination_user_preferences TO replication_user;


--
-- PostgreSQL database dump complete
--

