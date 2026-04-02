CREATE TYPE public.notification_target_type_enum AS ENUM (
    'all_users',
    'specific_users',
    'specific_roles',
    'specific_branches',
    'specific_departments',
    'specific_positions'
);


--
-- Name: notification_type_enum; Type: TYPE; Schema: public; Owner: -
--

