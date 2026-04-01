CREATE TYPE public.audit_action_enum AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'LOGIN',
    'LOGOUT',
    'ACCESS',
    'PERMISSION_CHANGE',
    'PASSWORD_CHANGE'
);


--
-- Name: document_category_enum; Type: TYPE; Schema: public; Owner: -
--

