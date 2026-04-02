#!/usr/bin/env node
/**
 * Import Aqura Schema to RUYAX Database
 * Uses direct HTTP API calls to Supabase
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const RUYAX_URL = 'https://tncbykfklynsnnyjajgf.supabase.co';
const RUYAX_SERVICE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRuY2J5a2ZrbHluc25ueWphamdmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NTA1NzQzMywiZXhwIjoyMDkwNjMzNDMzfQ.FOAecqEiib0kI-6LyzhvqJYi4Yyju0CsI1gqUHRZsXw';

async function importSQL(sqlContent) {
  console.log('⏳ Sending SQL to RUYAX database...');
  
  try {
    const response = await fetch(`${RUYAX_URL}/rest/v1/rpc/exec_sql`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${RUYAX_SERVICE_KEY}`,
        'apikey': RUYAX_SERVICE_KEY,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ sql_content: sqlContent })
    });

    if (response.ok) {
      console.log('✅ API submission successful');
      return true;
    } else {
      console.log('⚠️  API not available, using alternative method...');
      return false;
    }
  } catch (error) {
    console.log('⚠️  Alternative execution needed');
    return false;
  }
}

async function main() {
  try {
    const schemaPath = path.join(__dirname, 'migrations', 'aqura_fresh_schema.sql');
    
    if (!fs.existsSync(schemaPath)) {
      throw new Error(`Schema file not found: ${schemaPath}`);
    }

    let sql = fs.readFileSync(schemaPath, 'utf-8');
    
    // Clean up SQL
    sql = sql
      .split('\n')
      .filter(line => !line.trim().startsWith('--') && line.trim())
      .join('\n');

    console.log(`📊 Schema size: ${(sql.length / 1024).toFixed(2)}KB`);
    console.log(`📝 Statements: ${sql.split('\n/').length}\n`);

    // Try API method first
    const apiSuccess = await importSQL(sql);

    if (!apiSuccess) {
      console.log('\n📋 MANUAL IMPORT INSTRUCTIONS:');
      console.log('================================\n');
      console.log('1. Go to: https://app.supabase.com/project/tncbykfklynsnnyjajgf/sql/new');
      console.log('2. Go to: https://app.supabase.com/project/tncbykfklynsnnyjajgf/sql/templates');
      console.log('3. Click "New query"');
      console.log('4. Copy & paste the SQL from: migrations/aqura_fresh_schema.sql');
      console.log('5. Click "Run" button');
      console.log('6. Wait for completion (2-3 minutes)\n');
      console.log('File location: c:\\Users\\mkyou\\RUYAX\\migrations\\aqura_fresh_schema.sql');
    }

  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

main();
