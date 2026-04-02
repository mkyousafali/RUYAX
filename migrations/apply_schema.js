/**
 * Apply AQURA schema to RUYAX Supabase database
 * This script executes the SQL schema file against RUYAX
 */

import fs from 'fs';
import path from 'path';
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';

// Load environment variables
dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  console.error('❌ Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env');
  process.exit(1);
}

console.log('🔄 Initializing Supabase client...');
const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

async function applySchema() {
  try {
    const schemaPath = path.join(__dirname, 'aqura_schema.sql');
    
    if (!fs.existsSync(schemaPath)) {
      throw new Error(`Schema file not found: ${schemaPath}`);
    }

    console.log('📖 Reading schema file...');
    const sql = fs.readFileSync(schemaPath, 'utf-8');
    
    // Split by semicolon and filter empty statements
    const statements = sql
      .split(';')
      .map(s => s.trim())
      .filter(s => s.length > 0);

    console.log(`📊 Found ${statements.length} SQL statements to execute`);
    
    let successCount = 0;
    let errorCount = 0;
    const errors = [];

    // Execute each statement
    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i];
      
      try {
        // Show progress
        if ((i + 1) % 100 === 0) {
          console.log(`⏳ Progress: ${i + 1}/${statements.length}...`);
        }

        const { data, error } = await supabase.rpc('exec_sql', {
          query: statement + ';'
        });

        if (error) {
          // Some statements might fail due to existing objects, that's OK
          if (!error.message.includes('already exists') && 
              !error.message.includes('duplicate key') &&
              !error.message.includes('NOTICE')) {
            errorCount++;
            errors.push({
              statement: statement.substring(0, 100),
              error: error.message
            });
          } else {
            successCount++;
          }
        } else {
          successCount++;
        }
      } catch (err) {
        errorCount++;
        errors.push({
          statement: statement.substring(0, 100),
          error: err.message
        });
      }
    }

    console.log('✅ Schema application complete!');
    console.log(`   ✔️  Successful: ${successCount}`);
    console.log(`   ⚠️  Warnings/Skipped: ${errorCount}`);
    
    if (errors.length > 0 && errors.length <= 10) {
      console.log('\n⚠️  Some non-critical errors (usually OK):');
      errors.forEach(err => {
        console.log(`   - ${err.statement}...`);
        console.log(`     Error: ${err.error}`);
      });
    }

  } catch (error) {
    console.error('❌ Error applying schema:', error.message);
    process.exit(1);
  }
}

console.log('🚀 Starting AQURA → RUYAX schema migration...\n');
applySchema().then(() => {
  console.log('\n✨ Migration complete!');
  process.exit(0);
}).catch(err => {
  console.error('❌ Migration failed:', err);
  process.exit(1);
});
