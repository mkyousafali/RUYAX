CREATE TYPE public.notification_type_enum AS ENUM (
    'info',
    'warning',
    'error',
    'success',
    'announcement',
    'task_assigned',
    'task_completed',
    'task_overdue',
    'task_assignment',
    'task_reminder',
    'employee_warning',
    'system_alert',
    'system_maintenance',
    'system_announcement',
    'policy_update',
    'birthday_reminder',
    'leave_approved',
    'leave_rejected',
    'document_uploaded',
    'meeting_scheduled',
    'assignment_updated',
    'deadline_reminder',
    'assignment_rejected',
    'assignment_approved',
    'marketing'
);


--
-- Name: payment_method_type; Type: TYPE; Schema: public; Owner: -
--

