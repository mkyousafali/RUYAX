CREATE TYPE public.warning_status_enum AS ENUM (
    'active',
    'resolved',
    'escalated',
    'dismissed',
    'pending'
);


--
-- Name: accept_order(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

