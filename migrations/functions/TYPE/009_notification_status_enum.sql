CREATE TYPE public.notification_status_enum AS ENUM (
    'draft',
    'scheduled',
    'published',
    'sent',
    'failed',
    'cancelled',
    'expired'
);


--
-- Name: notification_target_type_enum; Type: TYPE; Schema: public; Owner: -
--

