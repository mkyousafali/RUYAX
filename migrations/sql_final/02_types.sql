Owner: supabase_admin
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

Owner: supabase_admin
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

Owner: supabase_admin
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

Owner: supabase_admin
--

CREATE TYPE public.employee_status_enum AS ENUM (
    'active',
    'inactive',
    'terminated',
    'on_leave',
    'suspended'
);

Owner: supabase_admin
--

CREATE TYPE public.fine_payment_status_enum AS ENUM (
    'pending',
    'paid',
    'overdue',
    'cancelled',
    'waived'
);

Owner: supabase_admin
--

CREATE TYPE public.notification_priority_enum AS ENUM (
    'low',
    'medium',
    'high',
    'urgent',
    'critical'
);

Owner: supabase_admin
--

CREATE TYPE public.notification_queue_status_enum AS ENUM (
    'pending',
    'processing',
    'sent',
    'failed',
    'retrying',
    'cancelled'
);

Owner: supabase_admin
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

Owner: supabase_admin
--

CREATE TYPE public.notification_target_type_enum AS ENUM (
    'all_users',
    'specific_users',
    'specific_roles',
    'specific_branches',
    'specific_departments',
    'specific_positions'
);

Owner: supabase_admin
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

Owner: supabase_admin
--

CREATE TYPE public.payment_method_type AS ENUM (
    'cash',
    'credit',
    'cpod',
    'bpod'
);

Owner: supabase_admin
--

CREATE TYPE public.pos_deduction_status AS ENUM (
    'Proposed',
    'Deducted',
    'Forgiven',
    'Cancelled'
);

Owner: supabase_admin
--

CREATE TYPE public.push_subscription_status_enum AS ENUM (
    'active',
    'inactive',
    'expired',
    'revoked'
);

Owner: supabase_admin
--

CREATE TYPE public.resolution_status AS ENUM (
    'reported',
    'claimed',
    'resolved'
);

Owner: supabase_admin
--

CREATE TYPE public.role_type_enum AS ENUM (
    'Master Admin',
    'Admin',
    'Position-based'
);

Owner: supabase_admin
--

CREATE TYPE public.session_status_enum AS ENUM (
    'active',
    'expired',
    'revoked',
    'inactive'
);

Owner: supabase_admin
--

CREATE TYPE public.task_priority_enum AS ENUM (
    'low',
    'medium',
    'high',
    'urgent',
    'critical'
);

Owner: supabase_admin
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

Owner: supabase_admin
--

CREATE TYPE public.user_role AS ENUM (
    'master_admin',
    'admin',
    'user'
);

Owner: supabase_admin
--

CREATE TYPE public.user_status_enum AS ENUM (
    'active',
    'inactive',
    'pending',
    'suspended',
    'locked'
);

Owner: supabase_admin
--

CREATE TYPE public.user_type_enum AS ENUM (
    'global',
    'branch_specific'
);

Owner: supabase_admin
--

CREATE TYPE public.vendor_status_enum AS ENUM (
    'active',
    'inactive',
    'suspended',
    'blacklisted'
);

Owner: supabase_admin
--

CREATE TYPE public.warning_status_enum AS ENUM (
    'active',
    'resolved',
    'escalated',
    'dismissed',
    'pending'
);

-- ═══ CUSTOM TYPES (enums and composites) ═══
    FOR r IN
        SELECT t.typname,
               CASE t.typtype
                   WHEN 'e' THEN
                       'CREATE TYPE IF NOT EXISTS public.' || quote_ident(t.typname) || ' AS ENUM (' ||
                       string_agg(quote_literal(e.enumlabel), ', ' ORDER BY e.enumsortorder) || ')'
                   WHEN 'c' THEN
                       'DO $typchk$ BEGIN CREATE TYPE public.' || quote_ident(t.typname) || ' AS (' ||
                       string_agg(quote_ident(a.attname) || ' ' || pg_catalog.format_type(a.atttypid, a.atttypmod), ', ' ORDER BY a.attnum) ||
                       ');