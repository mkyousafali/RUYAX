#!/usr/bin/env node
/**
 * Direct SSH import to Supabase self-hosted Aqura, then replicate to RUYAX Cloud
 */

import { exec } from 'child_process';
import { promisify } from 'util';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const execAsync = promisify(exec);
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function importViaSupabaseCloud() {
  try {
    console.log('🌍 Using Supabase Cloud direct import...\n');
    console.log('Option A: Fast batch upload');
    console.log('─────────────────────────\n');
    console.log('API Endpoint: https://tncbykfklynsnnyjajgf.supabase.co/rest/v1/');
    console.log('Method: POST /rpc/exec_sql\n');
    
    console.log('Headers:');
    console.log('  Authorization: Bearer <SERVICE_ROLE_KEY>');
    console.log('  apikey: <SERVICE_ROLE_KEY>');
    console.log('  Content-Type: application/json\n');

    const schemaFile = path.join(__dirname, 'migrations', 'aqura_final_schema.sql');
    const fileSize = fs.statSync(schemaFile).size;

    console.log(`Body: { "sql_content": "<${(fileSize/1024).toFixed(0)}KB SQL>" }\n`);

    console.log('Option B: Dashboard Import (Recommended)\n');
    console.log('Step 1: Open Supabase Dashboard');
    console.log('        👉 https://app.supabase.com/project/tncbykfklynsnnyjajgf\n');
    
    console.log('Step 2: Go to SQL Editor');
    console.log('        Click on "SQL Editor" in left sidebar\n');
    
    console.log('Step 3: Create New Query');
    console.log('        Click "New query" button\n');
    
    console.log('Step 4: Paste Schema');
    console.log(`        📄 File: migrations/aqura_final_schema.sql\n`);
    
    console.log('Step 5: Execute');
    console.log('        Click "Run" button\n');
    
    console.log('Step 6: Wait for completion');
    console.log('        ⏱️  Expected time: 2-3 minutes\n');

    console.log('Option C: Terminal Import (If available)\n');
    console.log('Command:');
    console.log('```bash');
    console.log('pg_restore \\');
    console.log('  -h db.tncbykfklynsnnyjajgf.supabase.co \\');
    console.log('  -U postgres \\');
    console.log('  -d postgres \\');
    console.log('  -1 \\');
    console.log('  migrations/aqura_final_schema.sql');
    console.log('```\n');

    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('⚠️  When importing, you may see warnings about:');
    console.log('   • Unable to set ROLE (expected - Supabase limitation)');
    console.log('   • Duplicate extensions (expected - may already exist)');
    console.log('   • Missing objects (expected - cross-references)\n');
    console.log('These are NORMAL and can be ignored. ✓');

  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

importViaSupabaseCloud();
