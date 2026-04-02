-- Disable foreign key constraints temporarily
ALTER TABLE public.users DISABLE TRIGGER ALL;

-- Insert users
INSERT INTO public.users VALUES ('68670b6c-246d-4455-9ad0-feb224c43e1c', 'Sarfas', '$2a$08$L9z6STkXnvAbqVOiQxM1beYz544ys9t0GwY3cVcP9IMi09gPHZ4pC', '$2a$08$L9z6STkXnvAbqVOiQxM1be', '$2a$08$FZ52h8sEtbrzq535yaIuhOp1JnUkPHnjjjcETBCyNU4KKsbOgQw0W', '$2a$08$FZ52h8sEtbrzq535yaIuhOp1JnUkPHnjjjcETBCyNU4KKsbOgQw0W', 'branch_specific', '2503bb0f-0fe5-436d-a19b-8abe4becd55b', 3, '172d87af-6224-455b-9c7c-741761ec4ac3', NULL, NULL, NULL, NULL, true, 0, NULL, NULL, '2026-03-31 18:11:57.578+00', '2026-01-05 07:59:30.845109+00', '2025-10-07 07:59:30.845109+00', NULL, NULL, '2025-10-07 07:59:30.845109+00', '2026-03-31 18:11:57.885292+00', 'active', false, false, false) ON CONFLICT (id) DO NOTHING;

-- Re-enable constraints 
ALTER TABLE public.users ENABLE TRIGGER ALL;
