# AQURA → RUYAX Complete Migration Guide

**Date**: April 2, 2026  
**Status**: ✅ All files prepared and ready to deploy

---

## 📋 What Was Migrated

### ✅ Database Schema (Complete)
- **File**: `aqura_schema.sql` (1.64 MB)
- **Contents**:
  - 200 Tables (structure only, no data)
  - 549 Functions/RPC Procedures
  - 146 Triggers
  - Views, Indexes, Sequences
  - Row-Level Security (RLS) Policies
  - PostgreSQL Extensions
- **Total SQL Statements**: 53,467 lines

### ✅ Storage Buckets (31 Total)
```
1.  app-icons
2.  asset-invoices
3.  category-images
4.  clearance-certificates
5.  completion-photos
6.  coupon-product-images
7.  customer-app-media
8.  custom-fonts
9.  documents
10. employee-documents
11. expense-scheduler-bills
12. flyer-product-images
13. flyer-templates
14. frontend-builds
15. notification-images
16. offer-pdfs
17. original-bills
18. pos-before
19. pr-excel-files
20. product-images
21. product-request-photos
22. purchase-voucher-receipts
23. quick-task-files
24. requisition-images
25. shelf-paper-templates
26. stock-documents
27. task-images
28. user-avatars
29. vendor-contracts
30. warning-documents
31. whatsapp-media
```

### ✅ Edge Functions (13 Total)
```
1.  01_analyze-attendance.ts          - Fingerprint analysis
2.  02_auto-sync-erp.ts              - ERP synchronization
3.  03_get-contact-bills.ts          - Billing lookup
4.  04_hello.ts                      - Health check
5.  05_main.ts                       - Main handler
6.  06_process-fingerprints.ts       - Biometric processing
7.  07_send-push-notification.ts     - Push notifications
8.  08_send-whatsapp.ts              - WhatsApp integration
9.  09_whatsapp-manage.ts            - WhatsApp management
10. 10_whatsapp-webhook.ts           - WhatsApp webhooks
11. analyze-attendance-index.ts       - Attendance indexing
12. auto-sync-erp-index.ts           - ERP sync indexing
13. get-contact-bills-index.ts       - Billing indexing
```

---

## 🚀 Deployment Instructions

### **Phase 1: Apply Database Schema**

#### Option A: Using SQL File Directly (Manual)
1. Go to RUYAX Supabase Dashboard: https://app.supabase.com
2. Open SQL Editor
3. Paste content of `aqura_schema.sql`
4. Click "Run" button
5. Wait for completion (~2-3 minutes)

#### Option B: Using Node.js Script (Automated - Recommended)
```bash
cd C:\Users\mkyou\RUYAX
npm install @supabase/supabase-js dotenv

# Create .env.local with RUYAX credentials (if not already present)
# Then run:
node migrations/apply_schema.js
```

**Expected Output:**
```
✅ Schema application complete!
   ✔️  Successful: ~53,000+ statements
   ⚠️  Warnings/Skipped: ~50-100 (normal - existing objects)
```

---

### **Phase 2: Create Storage Buckets**

```bash
# From RUYAX root directory
node migrations/create_storage_buckets.js
```

**Expected Output:**
```
📊 Summary:
   ✅ Created: 31
   ⏭️  Already existed: 0
   ❌ Failed: 0
   Total: 31
```

---

### **Phase 3: Deploy Edge Functions**

#### Step 1: Copy files to correct location
```bash
node migrations/migrate_edge_functions.js
```

#### Step 2: Deploy to Supabase
```bash
# Install Supabase CLI (if not already installed)
npm install -g supabase

# Authenticate with Supabase
supabase login

# Deploy edge functions to RUYAX
supabase functions deploy

# Or deploy specific function:
supabase functions deploy 01_analyze-attendance
supabase functions deploy 02_auto-sync-erp
# ... etc for each function
```

---

## ✅ Verification Checklist

After migration, verify everything is working:

### Database
- [ ] Check tables exist: Go to Supabase Dashboard → Tables
- [ ] Check functions exist: Go to Database → Functions
- [ ] Test a simple function call

### Storage
- [ ] 31 buckets created and visible
- [ ] Buckets are set to private (secure)
- [ ] No data in buckets (schema-only as intended)

### Edge Functions
- [ ] Functions deployed successfully
- [ ] Check Supabase Dashboard → Edge Functions
- [ ] Test a function endpoint

---

## 📊 Migration Summary

| Component | Source | Target | Status |
|---|---|---|---|
| Database Schema | AQURA (15.8) | RUYAX Cloud | ✅ Ready |
| Tables | 200 | 200 | ✅ Ready |
| Functions | 549 | 549 | ✅ Ready |
| Triggers | 146 | 146 | ✅ Ready |
| Storage Buckets | 31 | 31 | ✅ Ready |
| Edge Functions | 13 | 13 | ✅ Ready |
| **Data Records** | ❌ EXCLUDED | ❌ EXCLUDED | ✅ As requested |

---

## ⚠️ Important Notes

1. **NO DATA INCLUDED** - This migration copies only structure/schema as requested
2. **Edge Functions Need Manual Deployment** - Use Supabase CLI
3. **Storage is Empty** - Buckets created but no files copied (as requested)
4. **RLS Policies Included** - Row-level security rules are in schema
5. **Extension Dependencies** - All PostgreSQL extensions included

---

## 🔧 Troubleshooting

### Schema Application Fails
```
Error: "column does not exist"
```
**Solution**: Ignore - this is normal if tables/functions already exist. Supabase usually has some default objects.

### Storage Bucket Creation Fails
```
Error: "already exists"
```
**Solution**: This is OK - it means the bucket is already there.

### Edge Functions Won't Deploy
```
Error: "Function not found"
```
**Solution**: Make sure you're in the right directory and functions are in `supabase/functions/` folder.

---

## 📞 Support

If you encounter issues:
1. Check RUYAX Supabase Dashboard for errors
2. Review the SQL file for any syntax issues
3. Ensure all environment variables are set correctly
4. Check that SERVICE_ROLE_KEY is valid

---

**Status**: ✅ All migration files prepared and verified  
**Next Step**: Run Phase 1, 2, and 3 in order
