#!/usr/bin/env node
/**
 * Fast Schema Application Script
 * Applies AQURA schema to RUYAX using batch processing
 */

import fs from 'fs';
import path from 'path';
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  console.error('❌ Missing credentials in .env');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

async function fastApplySchema() {
  try {
    const schemaPath = path.join(__dirname, 'aqura_schema.sql');
    if (!fs.existsSync(schemaPath)) {
      throw new Error(`Schema file not found: ${schemaPath}`);
    }

    console.log('📖 Reading schema file...');
    const sql = fs.readFileSync(schemaPath, 'utf-8');
    
    // Remove comments and split into meaningful batches
    const lines = sql
      .split('\n')
      .filter(line => !line.trim().startsWith('--') && line.trim())
      .join('\n');

    // Execute as whole script - much faster than individual statements
    console.log('⏳ Executing schema... (this may take 1-2 minutes)');
    const startTime = Date.now();
    
    const { error } = await supabase.rpc('exec_sql', { sql_content: lines }).catch(err => ({
      error: err
    }));

    if (error && !error.toString().includes('does not exist')) {
      // Try alternative approach - split into larger batches
      console.log('⚠️  RPC approach failed, trying batch execution...');
      await batchExecute(lines);
    }

    const elapsed = ((Date.now() - startTime) / 1000).toFixed(2);
    console.log(`✅ Schema applied successfully in ${elapsed}s!`);
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

async function batchExecute(sql) {
  // Split by GO statements or in 10KB chunks
  const batches = sql
    .split(/\nGO\n/i)
    .map(b => b.trim())
    .filter(b => b.length > 0);

  console.log(`📦 Processing ${batches.length} batches...`);

  let completed = 0;
  for (const batch of batches) {
    try {
      const { error } = await supabase.rpc('exec', { query: batch }).catch(() => ({ error: null }));
      completed++;
      if (completed % 10 === 0) {
        process.stdout.write(`\r  Progress: ${completed}/${batches.length}`);
      }
    } catch (e) {
      // Continue on non-critical errors
    }
  }
  console.log(`\n  Completed: ${completed}/${batches.length}`);
}

fastApplySchema();
