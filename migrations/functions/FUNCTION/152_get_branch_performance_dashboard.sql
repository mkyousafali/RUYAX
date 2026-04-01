CREATE FUNCTION public.get_branch_performance_dashboard(p_days_back integer DEFAULT 30, p_specific_date date DEFAULT NULL::date) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_from timestamp;
  v_to timestamp;
  v_branch_stats json;
  v_task_type_stats json;
  v_daily_stats json;
  v_top_employees json;
  v_assigned_by_stats json;
  v_checklist_stats json;
  v_totals json;
BEGIN
  IF p_specific_date IS NOT NULL THEN
    v_from := p_specific_date::timestamp;
    v_to := (p_specific_date + 1)::timestamp;
  ELSE
    v_from := NOW() - (p_days_back || ' days')::interval;
    v_to := NOW();
  END IF;

  -- 1. Overall totals
  SELECT json_build_object(
    'total_tasks', COALESCE(SUM(total), 0),
    'completed_tasks', COALESCE(SUM(completed), 0),
    'pending_tasks', COALESCE(SUM(pending), 0),
    'overdue_tasks', COALESCE(SUM(overdue), 0),
    'avg_completion_hours', ROUND(COALESCE(AVG(NULLIF(avg_hrs, 0)), 0)::numeric, 1),
    'total_checklists', COALESCE((SELECT COUNT(*) FROM hr_checklist_operations WHERE created_at >= v_from AND created_at < v_to), 0),
    'avg_checklist_score', COALESCE((SELECT ROUND(AVG(total_points::numeric / NULLIF(max_points, 0) * 100), 1) FROM hr_checklist_operations WHERE created_at >= v_from AND created_at < v_to), 0)
  ) INTO v_totals
  FROM (
    SELECT
      COUNT(*) as total,
      COUNT(*) FILTER (WHERE ta.status = 'completed') as completed,
      COUNT(*) FILTER (WHERE ta.status NOT IN ('completed','cancelled')) as pending,
      COUNT(*) FILTER (WHERE ta.status NOT IN ('completed','cancelled') AND ta.deadline_date < CURRENT_DATE) as overdue,
      EXTRACT(EPOCH FROM AVG(ta.completed_at - ta.assigned_at) FILTER (WHERE ta.status = 'completed')) / 3600 as avg_hrs
    FROM task_assignments ta
    WHERE ta.assigned_at >= v_from AND ta.assigned_at < v_to

    UNION ALL

    SELECT
      COUNT(*) as total,
      COUNT(*) FILTER (WHERE qta.status = 'completed') as completed,
      COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled')) as pending,
      COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled') AND qt.deadline_datetime < NOW()) as overdue,
      EXTRACT(EPOCH FROM AVG(qta.completed_at - qta.created_at) FILTER (WHERE qta.status = 'completed')) / 3600 as avg_hrs
    FROM quick_task_assignments qta
    JOIN quick_tasks qt ON qt.id = qta.quick_task_id
    WHERE qta.created_at >= v_from AND qta.created_at < v_to

    UNION ALL

    SELECT
      COUNT(*) as total,
      COUNT(*) FILTER (WHERE rt.task_status = 'completed') as completed,
      COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled')) as pending,
      COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled') AND rt.due_date < NOW()) as overdue,
      EXTRACT(EPOCH FROM AVG(rt.completed_at - rt.created_at) FILTER (WHERE rt.task_status = 'completed')) / 3600 as avg_hrs
    FROM receiving_tasks rt
    WHERE rt.created_at >= v_from AND rt.created_at < v_to
  ) sub;

  -- 2. Per-branch stats (tasks + checklists)
  SELECT COALESCE(json_agg(row_to_json(bs) ORDER BY bs.total_tasks DESC), '[]'::json)
  INTO v_branch_stats
  FROM (
    SELECT
      b.id as branch_id,
      b.name_en as branch_name_en,
      b.name_ar as branch_name_ar,
      b.location_en as branch_location_en,
      b.location_ar as branch_location_ar,
      COALESCE(r.total, 0) + COALESCE(q.total, 0) + COALESCE(rv.total, 0) as total_tasks,
      COALESCE(r.completed, 0) + COALESCE(q.completed, 0) + COALESCE(rv.completed, 0) as completed,
      COALESCE(r.pending, 0) + COALESCE(q.pending, 0) + COALESCE(rv.pending, 0) as pending,
      COALESCE(r.overdue, 0) + COALESCE(q.overdue, 0) + COALESCE(rv.overdue, 0) as overdue,
      COALESCE(r.regular_count, 0) as regular_count,
      COALESCE(q.quick_count, 0) as quick_count,
      COALESCE(rv.receiving_count, 0) as receiving_count,
      COALESCE(cl.checklist_count, 0) as checklist_count,
      COALESCE(cl.avg_checklist_score, 0) as avg_checklist_score,
      CASE WHEN (COALESCE(r.total, 0) + COALESCE(q.total, 0) + COALESCE(rv.total, 0)) > 0
        THEN ROUND(((COALESCE(r.completed, 0) + COALESCE(q.completed, 0) + COALESCE(rv.completed, 0))::numeric /
              (COALESCE(r.total, 0) + COALESCE(q.total, 0) + COALESCE(rv.total, 0))::numeric) * 100, 1)
        ELSE 0
      END as completion_rate
    FROM branches b
    LEFT JOIN (
      SELECT e.current_branch_id as branch_id, COUNT(*) as total, COUNT(*) as regular_count,
             COUNT(*) FILTER (WHERE ta.status = 'completed') as completed,
             COUNT(*) FILTER (WHERE ta.status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE ta.status NOT IN ('completed','cancelled') AND ta.deadline_date < CURRENT_DATE) as overdue
      FROM task_assignments ta JOIN hr_employee_master e ON e.user_id = ta.assigned_to_user_id
      WHERE ta.assigned_at >= v_from AND ta.assigned_at < v_to GROUP BY e.current_branch_id
    ) r ON r.branch_id = b.id
    LEFT JOIN (
      SELECT e.current_branch_id as branch_id, COUNT(*) as total, COUNT(*) as quick_count,
             COUNT(*) FILTER (WHERE qta.status = 'completed') as completed,
             COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled') AND qt.deadline_datetime < NOW()) as overdue
      FROM quick_task_assignments qta JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      JOIN hr_employee_master e ON e.user_id = qta.assigned_to_user_id
      WHERE qta.created_at >= v_from AND qta.created_at < v_to GROUP BY e.current_branch_id
    ) q ON q.branch_id = b.id
    LEFT JOIN (
      SELECT e.current_branch_id as branch_id, COUNT(*) as total, COUNT(*) as receiving_count,
             COUNT(*) FILTER (WHERE rt.task_status = 'completed') as completed,
             COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled') AND rt.due_date < NOW()) as overdue
      FROM receiving_tasks rt JOIN hr_employee_master e ON e.user_id = rt.assigned_user_id
      WHERE rt.created_at >= v_from AND rt.created_at < v_to GROUP BY e.current_branch_id
    ) rv ON rv.branch_id = b.id
    LEFT JOIN (
      SELECT co.branch_id, COUNT(*) as checklist_count,
             ROUND(AVG(co.total_points::numeric / NULLIF(co.max_points, 0) * 100), 1) as avg_checklist_score
      FROM hr_checklist_operations co
      WHERE co.created_at >= v_from AND co.created_at < v_to GROUP BY co.branch_id
    ) cl ON cl.branch_id = b.id
    WHERE COALESCE(r.total, 0) + COALESCE(q.total, 0) + COALESCE(rv.total, 0) + COALESCE(cl.checklist_count, 0) > 0
  ) bs;

  -- 3. Task type distribution
  SELECT json_build_object(
    'regular', COALESCE((SELECT COUNT(*) FROM task_assignments WHERE assigned_at >= v_from AND assigned_at < v_to), 0),
    'quick', COALESCE((SELECT COUNT(*) FROM quick_task_assignments WHERE created_at >= v_from AND created_at < v_to), 0),
    'receiving', COALESCE((SELECT COUNT(*) FROM receiving_tasks WHERE created_at >= v_from AND created_at < v_to), 0),
    'checklist', COALESCE((SELECT COUNT(*) FROM hr_checklist_operations WHERE created_at >= v_from AND created_at < v_to), 0)
  ) INTO v_task_type_stats;

  -- 4. Daily completion trend
  SELECT COALESCE(json_agg(row_to_json(ds) ORDER BY ds.day), '[]'::json)
  INTO v_daily_stats
  FROM (
    SELECT
      d.day::date as day,
      COALESCE(r.cnt, 0) + COALESCE(q.cnt, 0) + COALESCE(rv.cnt, 0) as completed,
      COALESCE(rc.cnt, 0) + COALESCE(qc.cnt, 0) + COALESCE(rvc.cnt, 0) as created
    FROM generate_series(v_from::date, LEAST(v_to::date, CURRENT_DATE), '1 day') d(day)
    LEFT JOIN (
      SELECT completed_at::date as day, COUNT(*) as cnt
      FROM task_assignments WHERE status = 'completed' AND completed_at >= v_from AND completed_at < v_to
      GROUP BY completed_at::date
    ) r ON r.day = d.day
    LEFT JOIN (
      SELECT completed_at::date as day, COUNT(*) as cnt
      FROM quick_task_assignments WHERE status = 'completed' AND completed_at >= v_from AND completed_at < v_to
      GROUP BY completed_at::date
    ) q ON q.day = d.day
    LEFT JOIN (
      SELECT completed_at::date as day, COUNT(*) as cnt
      FROM receiving_tasks WHERE task_status = 'completed' AND completed_at >= v_from AND completed_at < v_to
      GROUP BY completed_at::date
    ) rv ON rv.day = d.day
    LEFT JOIN (
      SELECT assigned_at::date as day, COUNT(*) as cnt
      FROM task_assignments WHERE assigned_at >= v_from AND assigned_at < v_to
      GROUP BY assigned_at::date
    ) rc ON rc.day = d.day
    LEFT JOIN (
      SELECT created_at::date as day, COUNT(*) as cnt
      FROM quick_task_assignments WHERE created_at >= v_from AND created_at < v_to
      GROUP BY created_at::date
    ) qc ON qc.day = d.day
    LEFT JOIN (
      SELECT created_at::date as day, COUNT(*) as cnt
      FROM receiving_tasks WHERE created_at >= v_from AND created_at < v_to
      GROUP BY created_at::date
    ) rvc ON rvc.day = d.day
  ) ds;

  -- 5. Top performing employees (by completion count, with checklist data)
  SELECT COALESCE(json_agg(row_to_json(te) ORDER BY te.completed DESC), '[]'::json)
  INTO v_top_employees
  FROM (
    SELECT
      emp.user_id,
      emp.name_en,
      emp.name_ar,
      emp.branch_name_en,
      emp.branch_name_ar,
      emp.completed,
      emp.total,
      emp.rate,
      COALESCE(cl.checklist_count, 0) as checklist_count,
      COALESCE(cl.avg_score, 0) as avg_checklist_score
    FROM (
      SELECT
        e.user_id,
        e.name_en,
        e.name_ar,
        b.name_en as branch_name_en,
        b.name_ar as branch_name_ar,
        SUM(sub.completed) as completed,
        SUM(sub.total) as total,
        CASE WHEN SUM(sub.total) > 0
          THEN ROUND((SUM(sub.completed)::numeric / SUM(sub.total)::numeric) * 100, 1)
          ELSE 0
        END as rate
      FROM (
        SELECT assigned_to_user_id as user_id, COUNT(*) as total,
               COUNT(*) FILTER (WHERE status = 'completed') as completed
        FROM task_assignments WHERE assigned_at >= v_from AND assigned_at < v_to GROUP BY assigned_to_user_id
        UNION ALL
        SELECT assigned_to_user_id as user_id, COUNT(*) as total,
               COUNT(*) FILTER (WHERE status = 'completed') as completed
        FROM quick_task_assignments WHERE created_at >= v_from AND created_at < v_to GROUP BY assigned_to_user_id
        UNION ALL
        SELECT assigned_user_id as user_id, COUNT(*) as total,
               COUNT(*) FILTER (WHERE task_status = 'completed') as completed
        FROM receiving_tasks WHERE created_at >= v_from AND created_at < v_to GROUP BY assigned_user_id
      ) sub
      JOIN hr_employee_master e ON e.user_id = sub.user_id
      JOIN branches b ON b.id = e.current_branch_id
      GROUP BY e.user_id, e.name_en, e.name_ar, b.name_en, b.name_ar
      HAVING SUM(sub.total) > 0
    ) emp
    LEFT JOIN (
      SELECT co.user_id, COUNT(*) as checklist_count,
             ROUND(AVG(co.total_points::numeric / NULLIF(co.max_points, 0) * 100), 1) as avg_score
      FROM hr_checklist_operations co
      WHERE co.created_at >= v_from AND co.created_at < v_to
      GROUP BY co.user_id
    ) cl ON cl.user_id = emp.user_id
    ORDER BY emp.completed DESC
  ) te;

  -- 5b. Checklist stats per employee (separate - has score, not status)
  SELECT COALESCE(json_agg(row_to_json(cs) ORDER BY cs.checklist_count DESC), '[]'::json)
  INTO v_checklist_stats
  FROM (
    SELECT
      e.user_id,
      e.name_en,
      e.name_ar,
      b.name_en as branch_name_en,
      b.name_ar as branch_name_ar,
      COUNT(*) as checklist_count,
      ROUND(AVG(co.total_points::numeric / NULLIF(co.max_points, 0) * 100), 1) as avg_score,
      SUM(co.total_points) as total_points,
      SUM(co.max_points) as max_points
    FROM hr_checklist_operations co
    JOIN hr_employee_master e ON e.user_id = co.user_id
    JOIN branches b ON b.id = e.current_branch_id
    WHERE co.created_at >= v_from AND co.created_at < v_to
    GROUP BY e.user_id, e.name_en, e.name_ar, b.name_en, b.name_ar
    ORDER BY COUNT(*) DESC
  ) cs;

  -- 6. Assigned-by stats (who assigned tasks and their outcome)
  SELECT COALESCE(json_agg(row_to_json(ab) ORDER BY ab.total_assigned DESC), '[]'::json)
  INTO v_assigned_by_stats
  FROM (
    SELECT
      e.user_id,
      e.name_en,
      e.name_ar,
      b.name_en as branch_name_en,
      b.name_ar as branch_name_ar,
      SUM(sub.total_assigned) as total_assigned,
      SUM(sub.completed) as completed,
      SUM(sub.pending) as pending,
      SUM(sub.overdue) as overdue,
      CASE WHEN SUM(sub.total_assigned) > 0
        THEN ROUND((SUM(sub.completed)::numeric / SUM(sub.total_assigned)::numeric) * 100, 1)
        ELSE 0
      END as completion_rate
    FROM (
      -- Regular task assignments: assigned_by
      SELECT assigned_by as user_id,
             COUNT(*) as total_assigned,
             COUNT(*) FILTER (WHERE status = 'completed') as completed,
             COUNT(*) FILTER (WHERE status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE status NOT IN ('completed','cancelled') AND deadline_date < CURRENT_DATE) as overdue
      FROM task_assignments
      WHERE assigned_at >= v_from AND assigned_at < v_to AND assigned_by IS NOT NULL
      GROUP BY assigned_by

      UNION ALL

      -- Quick tasks: assigned_by is on the parent quick_tasks table
      SELECT qt.assigned_by as user_id,
             COUNT(*) as total_assigned,
             COUNT(*) FILTER (WHERE qta.status = 'completed') as completed,
             COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled') AND qt.deadline_datetime < NOW()) as overdue
      FROM quick_task_assignments qta
      JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      WHERE qta.created_at >= v_from AND qta.created_at < v_to AND qt.assigned_by IS NOT NULL
      GROUP BY qt.assigned_by

      UNION ALL

      -- Receiving tasks: created by the user who submitted the receiving record
      SELECT rr.user_id as user_id,
             COUNT(*) as total_assigned,
             COUNT(*) FILTER (WHERE rt.task_status = 'completed') as completed,
             COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled') AND rt.due_date < NOW()) as overdue
      FROM receiving_tasks rt
      JOIN receiving_records rr ON rr.id = rt.receiving_record_id
      WHERE rt.created_at >= v_from AND rt.created_at < v_to AND rr.user_id IS NOT NULL
      GROUP BY rr.user_id
    ) sub
    JOIN hr_employee_master e ON e.user_id = sub.user_id
    JOIN branches b ON b.id = e.current_branch_id
    GROUP BY e.user_id, e.name_en, e.name_ar, b.name_en, b.name_ar
    HAVING SUM(sub.total_assigned) > 0
    ORDER BY SUM(sub.total_assigned) DESC
  ) ab;

  RETURN json_build_object(
    'totals', v_totals,
    'branch_stats', v_branch_stats,
    'task_type_stats', v_task_type_stats,
    'daily_stats', v_daily_stats,
    'top_employees', v_top_employees,
    'assigned_by_stats', v_assigned_by_stats,
    'checklist_stats', v_checklist_stats
  );
END;
$$;


--
-- Name: get_branch_promissory_notes_summary(uuid); Type: FUNCTION; Schema: public; Owner: -
--

