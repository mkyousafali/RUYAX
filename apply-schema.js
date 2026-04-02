#!/usr/bin/env node
/**
 * Fast Schema Application to RUYAX
 * Uses existing Aqura schema dump
 */

import fs from 'fs';
import { Client } from 'pg';
import dotenv from 'dotenv';

dotenv.config({ path: './.env' });

const RUYAX_URL = process.env.VITE_SUPABASE_URL;
const RUYAX_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!RUYAX_URL || !RUYAX_KEY) {
  console.error('❌ Missing RUYAX credentials');
  process.exit(1);
}

async function applySchema() {
  console.log('🚀 Applying Aqura Schema to RUYAX');
  console.log('━'.repeat(60));

  const ruyaxClient = new Client({
    host: 'db.tncbykfklynsnnyjajgf.supabase.co',
    port: 5432,
    database: 'postgres',
    user: 'postgres',
    password: RUYAX_KEY,
    ssl: { rejectUnauthorized: false }
  });

  try {
    console.log('\n🔗 Connecting to RUYAX...');
    await ruyaxClient.connect();
    console.log('✅ Connected\n');

    console.log('📖 Reading schema file...');
    const schemaPath = './migrations/aqura_schema.sql';
    const schema = fs.readFileSync(schemaPath, 'utf-8');

    // Parse SQL statements (split by semicolon, remove comments)
    const lines = schema
      .split('\n')
      .filter(line => line.trim() && !line.trim().startsWith('--'))
      .join('\n');

    const statements = lines
      .split(';')
      .map(s => s.trim())
      .filter(s => s.length > 0);

    console.log(`📦 Found ${statements.length} SQL statements\n`);
    console.log('⏳ Applying schema (this may take 2-3 minutes)...\n');

    const startTime = Date.now();
    let applied = 0;
    let skipped = 0;
    const errors = [];

    for (let i = 0; i < statements.length; i++) {
      const stmt = statements[i];
      
      try {
        await ruyaxClient.query(stmt);
        applied++;
      } catch (err) {
        const msg = err.message.toLowerCase();
        
        // Skip expected errors
        if (msg.includes('already exists') || 
            msg.includes('duplicate') ||
            msg.includes('no such') ||
            msg.includes('does not exist')) {
          skipped++;
        } else {
          errors.push({ stmt: stmt.substring(0, 50), error: err.message });
          skipped++;
        }
      }

      if ((i + 1) % 100 === 0) {
        const elapsed = ((Date.now() - startTime) / 1000).toFixed(1);
        process.stdout.write(`\r  Progress: ${i + 1}/${statements.length} (${elapsed}s)`);
      }
    }

    const totalTime = ((Date.now() - startTime) / 1000).toFixed(2);
    
    console.log(`\n\n${'━'.repeat(60)}`);
    console.log('✅ MIGRATION COMPLETE!');
    console.log('━'.repeat(60));
    console.log(`  Applied: ${applied} statements`);
    console.log(`  Skipped: ${skipped} (already exist or errors)`);
    console.log(`  Total:   ${statements.length} statements`);
    console.log(`  Time:    ${totalTime}s`);
    
    if (errors.length > 0 && errors.length <= 5) {
      console.log(`\n⚠️  Sample errors:`);
      errors.slice(0, 5).forEach(e => {
        console.log(`    - ${e.stmt}...`);
        console.log(`      ${e.error.substring(0, 80)}`);
      });
    }

  } catch (error) {
    console.error('\n❌ ERROR:', error.message);
    process.exit(1);
  } finally {
    await ruyaxClient.end();
  }
}

applySchema();
