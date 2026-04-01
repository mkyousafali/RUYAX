CREATE VIEW public.user_management_view AS
 SELECT u.id,
    u.username,
    u.status,
    u.is_master_admin,
    u.is_admin,
    u.branch_id,
    u.employee_id,
    u.position_id,
    u.created_at,
    u.updated_at,
    u.failed_login_attempts,
    u.is_first_login,
    u.last_login_at,
    e.name AS employee_name,
    b.name_en AS branch_name,
    p.position_title_en,
    p.position_title_ar
   FROM (((public.users u
     LEFT JOIN public.hr_employees e ON ((u.employee_id = e.id)))
     LEFT JOIN public.branches b ON ((u.branch_id = b.id)))
     LEFT JOIN public.hr_positions p ON ((u.position_id = p.id)));


--
-- Name: user_mobile_theme_assignments; Type: TABLE; Schema: public; Owner: -
--

