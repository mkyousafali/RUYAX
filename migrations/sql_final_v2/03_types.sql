--

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

CREATE TYPE public.document_category_enum AS ENUM (
    'warnings',
    'sick_leave',
    'special_leave',
    'resignation',
    'contract_objection',
    'annual_leave',
    'other'
);

--

CREATE TYPE public.document_type_enum AS ENUM (
    'contract',
    'id_copy',
    'resume',
    'certificate',
    'medical_report',
    'performance_review',
    'disciplinary_action',
    'other'
);

--

CREATE TYPE public.employee_status_enum AS ENUM (
    'active',
    'inactive',
    'terminated',
    'on_leave',
    'suspended'
);

--

CREATE TYPE public.fine_payment_status_enum AS ENUM (
    'pending',
    'paid',
    'overdue',
    'cancelled',
    'waived'
);

--

CREATE TYPE public.notification_priority_enum AS ENUM (
    'low',
    'medium',
    'high',
    'urgent',
    'critical'
);

--

CREATE TYPE public.notification_queue_status_enum AS ENUM (
    'pending',
    'processing',
    'sent',
    'failed',
    'retrying',
    'cancelled'
);

--

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

CREATE TYPE public.notification_target_type_enum AS ENUM (
    'all_users',
    'specific_users',
    'specific_roles',
    'specific_branches',
    'specific_departments',
    'specific_positions'
);

--

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

CREATE TYPE public.payment_method_type AS ENUM (
    'cash',
    'credit',
    'cpod',
    'bpod'
);

--

CREATE TYPE public.pos_deduction_status AS ENUM (
    'Proposed',
    'Deducted',
    'Forgiven',
    'Cancelled'
);

--

CREATE TYPE public.push_subscription_status_enum AS ENUM (
    'active',
    'inactive',
    'expired',
    'revoked'
);

--

CREATE TYPE public.resolution_status AS ENUM (
    'reported',
    'claimed',
    'resolved'
);

--

CREATE TYPE public.role_type_enum AS ENUM (
    'Master Admin',
    'Admin',
    'Position-based'
);

--

CREATE TYPE public.session_status_enum AS ENUM (
    'active',
    'expired',
    'revoked',
    'inactive'
);

--

CREATE TYPE public.task_priority_enum AS ENUM (
    'low',
    'medium',
    'high',
    'urgent',
    'critical'
);

--

CREATE TYPE public.task_status_enum AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'overdue',
    'cancelled',
    'rejected',
    'approved'
);

--

CREATE TYPE public.user_role AS ENUM (
    'master_admin',
    'admin',
    'user'
);

--

CREATE TYPE public.user_status_enum AS ENUM (
    'active',
    'inactive',
    'pending',
    'suspended',
    'locked'
);

--

CREATE TYPE public.user_type_enum AS ENUM (
    'global',
    'branch_specific'
);

--

CREATE TYPE public.vendor_status_enum AS ENUM (
    'active',
    'inactive',
    'suspended',
    'blacklisted'
);

--

CREATE TYPE public.warning_status_enum AS ENUM (
    'active',
    'resolved',
    'escalated',
    'dismissed',
    'pending'
);