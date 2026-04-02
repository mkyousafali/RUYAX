#!/usr/bin/env node
/**
 * Import Aqura Schema to RUYAX Database
 * Direct database-to-database migration
 */

import fs from 'fs';
import path from 'path';
import { createClient } from '@supabase/supabase-js';
import pg from 'pg';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// RUYAX Cloud credentials
const RUYAX_URL = process.env.VITE_SUPABASE_URL;
const RUYAX_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!RUYAX_URL || !RUYAX_SERVICE_KEY) {
  console.error('❌ Missing RUYAX credentials in .env');
  process.exit(1);
}

// Extract host from RUYAX URL
const ruyaxHost = new URL(RUYAX_URL).hostname.replace('.supabase.co', '');

async function importSchema() {
  const client = new pg.Client({
    host: `db.${ruyaxHost}.supabase.co`,
    database: 'postgres',
    user: 'postgres',
    password: RUYAX_SERVICE_KEY,
    port: 5432,
    ssl: { rejectUnauthorized: false },
  });

  try {
    console.log('🔄 Connecting to RUYAX database...');
    await client.connect();
    console.log('✓ Connected');

    console.log('📖 Reading schema file...');
    const schemaPath = path.join(__dirname, 'aqura_fresh_schema.sql');
    
    if (!fs.existsSync(schemaPath)) {
      throw new Error(`Schema file not found: ${schemaPath}`);
    }

    const sql = fs.readFileSync(schemaPath, 'utf-8');
    
    // Split into statements (handle both ; and \n/ separators)
    const statements = sql
      .split('\n/')
      .filter(s => s.trim().length > 0)
      .map(s => s.trim());

    console.log(`⏳ Executing ${statements.length} statements...`);
    
    let successCount = 0;
    let errorCount = 0;
    let skipCount = 0;

    for (let i = 0; i < statements.length; i++) {
      try {
        const stmt = statements[i];
        if (!stmt) continue;

        // Add semicolon if missing
        const fullStmt = stmt.endsWith(';') ? stmt : stmt + ';';
        
        await client.query(fullStmt);
        successCount++;

        if ((i + 1) % 50 === 0) {
          process.stdout.write(`\r  Progress: ${i + 1}/${statements.length}`);
        }
      } catch (error) {
        // Skip errors for objects that already exist
        if (error.message.includes('already exists') || 
            error.message.includes('duplicate') ||
            error.message.includes('NOTICE')) {
          skipCount++;
        } else {
          console.error(`\n  ⚠️  Statement ${i}: ${error.message}`);
          errorCount++;
        }
      }
    }

    console.log(`\n\n📊 Migration Summary:`);
    console.log(`  ✅ Successful: ${successCount}`);
    console.log(`  ⏭️  Skipped (already exist): ${skipCount}`);
    console.log(`  ❌ Errors: ${errorCount}`);

    console.log('\n✅ Schema import complete!');

  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  } finally {
    await client.end();
  }
}

importSchema();
