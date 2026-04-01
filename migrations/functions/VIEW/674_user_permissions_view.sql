CREATE VIEW public.user_permissions_view AS
 SELECT bp.user_id,
    u.username,
    sb.button_code AS function_code,
    sb.button_name_en AS function_name,
    bp.is_enabled AS can_view,
    bp.is_enabled AS can_add,
    bp.is_enabled AS can_edit,
    bp.is_enabled AS can_delete,
    bp.is_enabled AS can_export
   FROM ((public.button_permissions bp
     JOIN public.users u ON ((bp.user_id = u.id)))
     JOIN public.sidebar_buttons sb ON ((bp.button_id = sb.id)))
  WHERE (bp.is_enabled = true);


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: -
--

