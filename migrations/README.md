# Database Migrations & Backups

Generated: 2026-04-02
Self-Hosted Supabase Server: 8.213.42.21

## 📁 Migration Folder Structure

```
migrations/
├── table_schemas/           # 181 individual table schemas (CREATE TABLE, indexes, RLS, triggers)
│   ├── 001_access_code_otp.sql
│   ├── 002_ai_chat_guide.sql
│   ├── 003_app_icons.sql
│   └── ... (up to 181 tables)
│
├── functions/               # All database functions, stored procedures, and RPC
│   └── 01_all_functions.sql
│
├── edge_functions/          # Deno Edge Functions
│   ├── analyze-attendance/
│   ├── auto-sync-erp/
│   ├── get-contact-bills/
│   ├── hello/
│   ├── main/
│   ├── process-fingerprints/
│   ├── send-push-notification/
│   ├── send-whatsapp/
│   ├── whatsapp-manage/
│   ├── whatsapp-webhook/
│   └── ... (and more)
│
├── storage/                 # Storage bucket configurations
│   └── buckets-info.sql
│
└── README.md               # This file

```

## 📊 Database Statistics

- **Total Tables**: 181
- **Total Functions/Procedures**: See functions/ folder
- **Edge Functions**: 11 deployed
- **Database Version**: PostgreSQL 15.8
- **Database Status**: ✅ Healthy (running 13 days)

## 🗂️ Table Schemas

All 181 tables have been exported to individual SQL files in `table_schemas/` folder:

Each file contains:
- ✅ CREATE TABLE statement
- ✅ Column definitions with types
- ✅ Indexes (UNIQUE, PRIMARY KEY, composite)
- ✅ Constraints (FOREIGN KEY, CHECK, etc.)
- ✅ RLS (Row Level Security) policies
- ✅ Triggers (if any)

**Format**: `NNN_table_name.sql` (sequential numbering)

Examples:
- `001_access_code_otp.sql`
- `002_ai_chat_guide.sql`
- `003_app_icons.sql`
- `181_whatsapp_message_log.sql`

To restore a table:
```bash
psql -U supabase_admin -d postgres -f migrations/table_schemas/NNN_table_name.sql
```

## 🔧 Database Functions

**Location**: `functions/01_all_functions.sql`

Contains all:
- Stored Procedures
- User-Defined Functions (UDFs)
- RPC (Remote Procedure Call) functions
- Aggregate functions
- Trigger functions

Entries include Supabase-generated functions like:
- `get_system_expiry_dates()` - System expiry date management
- `get_analytics_log_tables()` - Analytics logging
- `get_lease_rent_properties_with_spaces()` - Property management
- `broadcast_stats()` - Broadcast statistics
- And 100+ more...

## 🌐 Edge Functions (Deno)

**Location**: `edge_functions/` folder

### Deployed Edge Functions (11 total)

| # | Function | Purpose | URLs |
|---|----------|---------|------|
| 1 | `analyze-attendance` | Attendance analysis & reporting | `/functions/v1/analyze-attendance` |
| 2 | `auto-sync-erp` | ERP synchronization | `/functions/v1/auto-sync-erp` |
| 3 | `get-contact-bills` | Retrieve contact bill information | `/functions/v1/get-contact-bills` |
| 4 | `hello` | Hello world example function | `/functions/v1/hello` |
| 5 | `main` | Main/primary edge function | `/functions/v1/main` |
| 6 | `process-fingerprints` | Fingerprint biometric processing | `/functions/v1/process-fingerprints` |
| 7 | `send-push-notification` | Push notification delivery | `/functions/v1/send-push-notification` |
| 8 | `send-whatsapp` | WhatsApp message sending | `/functions/v1/send-whatsapp` |
| 9 | `whatsapp-manage` | WhatsApp management operations | `/functions/v1/whatsapp-manage` |
| 10 |`whatsapp-webhook` | WhatsApp webhook receiver | `/functions/v1/whatsapp-webhook` |
| 11 | `get-billing-data` | Billing data retrieval | `/functions/v1/get-billing-data` |

### Edge Function Access

**Internal (Server)**: `http://supabase-kong:8000/functions/v1/<function-name>`
**External**: `https://supabase.urbanaqura.com/functions/v1/<function-name>`

### pg_cron Scheduled Executions

| Job ID | Function | Schedule (UTC) | Saudi Time | Frequency |
|--------|----------|---|---|---|
| 5-10 | analyze-attendance | Various | 6 AM - 12:30 AM | 6x daily |
| 11 | process-fingerprints | `0 * * * *` | Every hour | Hourly |

## 💾 Storage Buckets

**Location**: `storage/buckets-info.sql`

Contains information about:
- Bucket configurations
- Access policies
- CORS settings
- File storage settings

## 🔐 Security Notes

### SSH Access
- **Server**: 8.213.42.21
- **User**: root
- **Auth**: ED25519 SSH Key
- **Key Location**: `~/.ssh/id_ed25519`

### Database Access
- **Container**: supabase-db
- **User**: supabase_admin
- **Command**: `docker exec supabase-db psql -U supabase_admin -d postgres`

### Service Role Key
⚠️ **NEVER** commit to git!
```bash
# Get service role key (run on server):
grep SERVICE_ROLE_KEY /opt/supabase/supabase/docker/.env | cut -d '=' -f2
```

## 📋 How to Use These Exports

### 1. Restore a Specific Table

```bash
ssh root@8.213.42.21
docker exec supabase-db psql -U supabase_admin -d postgres -f /path/to/00X_table_name.sql
```

### 2. Restore All Tables

```bash
for file in migrations/table_schemas/*.sql; do
  ssh root@8.213.42.21 "docker exec supabase-db psql -U supabase_admin -d postgres -f $file"
done
```

### 3. Export Specific Function

Extract from `functions/01_all_functions.sql` and run:
```bash
docker exec supabase-db psql -U supabase_admin -d postgres -c "CREATE OR REPLACE FUNCTION ..."
```

### 4. Deploy Edge Function

See [EDGE_FUNCTION_DEPLOYMENT_GUIDE.md](../Do%20not%20delete/EDGE_FUNCTION_DEPLOYMENT_GUIDE.md)

## 🔍 For Future Reference

This backup includes:
✅ Complete database schema (all 181 tables)
✅ All functions and RPC procedures
✅ Edge function references (11 functions listed)
✅ Storage configuration
✅ RLS policies and triggers for each table
✅ Indexes and constraints

**Generated**: 2026-04-02 03:15 UTC (6:15 AM Saudi)
**Server Status**: Healthy ✅
**Backup Completeness**: 100%

---

**Next Steps**:
1. Version control these migrations in git
2. Use in CI/CD pipelines for database reproduction
3. Reference for schema documentation
4. Disaster recovery procedures
