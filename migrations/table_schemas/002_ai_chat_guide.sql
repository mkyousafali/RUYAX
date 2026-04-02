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
-- Name: ai_chat_guide; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_chat_guide (
    id integer NOT NULL,
    guide_text text DEFAULT ''::text NOT NULL,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: ai_chat_guide_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ai_chat_guide_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ai_chat_guide_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ai_chat_guide_id_seq OWNED BY public.ai_chat_guide.id;


--
-- Name: ai_chat_guide id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_chat_guide ALTER COLUMN id SET DEFAULT nextval('public.ai_chat_guide_id_seq'::regclass);


--
-- Name: ai_chat_guide ai_chat_guide_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_chat_guide
    ADD CONSTRAINT ai_chat_guide_pkey PRIMARY KEY (id);


--
-- Name: ai_chat_guide ai_chat_guide_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ai_chat_guide_timestamp_update BEFORE UPDATE ON public.ai_chat_guide FOR EACH ROW EXECUTE FUNCTION public.update_ai_chat_guide_timestamp();


--
-- Name: ai_chat_guide ai_chat_guide_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_chat_guide
    ADD CONSTRAINT ai_chat_guide_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: ai_chat_guide Allow all access to ai_chat_guide; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to ai_chat_guide" ON public.ai_chat_guide USING (true) WITH CHECK (true);


--
-- Name: ai_chat_guide; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_chat_guide ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE ai_chat_guide; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.ai_chat_guide TO anon;
GRANT ALL ON TABLE public.ai_chat_guide TO authenticated;
GRANT ALL ON TABLE public.ai_chat_guide TO service_role;
GRANT SELECT ON TABLE public.ai_chat_guide TO replication_user;


--
-- Name: SEQUENCE ai_chat_guide_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.ai_chat_guide_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.ai_chat_guide_id_seq TO anon;
GRANT SELECT,USAGE ON SEQUENCE public.ai_chat_guide_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.ai_chat_guide_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

