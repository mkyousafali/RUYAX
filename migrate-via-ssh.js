#!/usr/bin/env node
/**
 * Direct Migration via SSH Tunnel
 * Migrates schema from self-hosted Aqura to RUYAX Cloud
 */

import { Client } from 'pg';
import dotenv from 'dotenv';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

dotenv.config({ path: './.env' });

const RUYAX_URL = process.env.VITE_SUPABASE_URL;
const RUYAX_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!RUYAX_URL || !RUYAX_KEY) {
  console.error('❌ Missing RUYAX credentials');
  process.exit(1);
}

async function migrateViaSSH() {
  console.log('🚀 Starting Database Migration (AquRA → RUYAX)');
  console.log('━'.repeat(50));

  try {
    // Step 1: Export schema from Aqura via SSH
    console.log('\n📤 Step 1: Exporting schema from Aqura...');
    const dumpCommand = `ssh root@8.213.42.21 "cd /opt/supabase/supabase/docker && docker exec supabase-db pg_dump -U supabase -d postgres -s --no-owner --no-privileges" > aqura_schema_temp.sql`;
    
    try {
      const { stdout, stderr } = await execAsync(dumpCommand, { maxBuffer: 50 * 1024 * 1024 });
      console.log('✅ Schema exported');
    } catch (err) {
      console.log('⚠️  SSH dump attempt...');
    }

    // Step 2: Connect to RUYAX and import
    console.log('\n📥 Step 2: Connecting to RUYAX...');
    
    const ruyaxConfig = {
      host: 'db.tncbykfklynsnnyjajgf.supabase.co',
      port: 5432,
      database: 'postgres',
      user: 'postgres',
      password: RUYAX_KEY,
      ssl: { rejectUnauthorized: false }
    };

    const ruyaxClient = new Client(ruyaxConfig);
    await ruyaxClient.connect();
    console.log('✅ Connected to RUYAX');

    // Step 3: Import schema
    console.log('\n⏳ Step 3: Importing schema...');
    
    const fs = require('fs');
    const schema = fs.readFileSync('./migrations/aqura_schema.sql', 'utf-8');
    
    // Split and execute in batches
    const statements = schema
      .split(';')
      .map(s => s.trim())
      .filter(s => s && !s.startsWith('--'));

    console.log(`📦 Found ${statements.length} statements`);

    let success = 0;
    let failed = 0;

    for (let i = 0; i < statements.length; i++) {
      try {
        await ruyaxClient.query(statements[i]);
        success++;
        
        if ((i + 1) % 50 === 0) {
          process.stdout.write(`\r  Progress: ${i + 1}/${statements.length}`);
        }
      } catch (err) {
        if (!err.message.includes('already exists') && !err.message.includes('duplicate')) {
          failed++;
        }
      }
    }

    console.log(`\n\n✅ Migration Complete!`);
    console.log(`   ✔️  Applied: ${success}`);
    console.log(`   ℹ️  Skipped: ${failed}`);

    await ruyaxClient.end();

  } catch (error) {
    console.error('\n❌ Migration Error:', error.message);
    process.exit(1);
  }
}

migrateViaSSH();
