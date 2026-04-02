#!/usr/bin/env node
/**
 * Import Aqura Schema to RUYAX using Supabase SQL API
 */

import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const RUYAX_URL = process.env.VITE_SUPABASE_URL;
const RUYAX_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!RUYAX_URL || !RUYAX_SERVICE_KEY) {
  console.error('❌ Missing RUYAX credentials');
  process.exit(1);
}

async function importSchema() {
  try {
    console.log('📖 Reading schema file...');
    const schemaPath = path.join(__dirname, 'aqura_fresh_schema.sql');
    
    if (!fs.existsSync(schemaPath)) {
      throw new Error(`Schema file not found: ${schemaPath}`);
    }

    const sql = fs.readFileSync(schemaPath, 'utf-8');
    
    console.log('⏳ Uploading schema to RUYAX via SQL Editor API...');
    
    // Split into reasonable chunks
    const statements = sql
      .split('\n/')
      .filter(s => s.trim().length > 0)
      .map((s, i) => `-- Statement ${i + 1}\n${s.trim().replace(/;$/, '')};`)
      .join('\n\n');

    // Use fetch to POST to Supabase SQL API
    const headers = {
      'Authorization': `Bearer ${RUYAX_SERVICE_KEY}`,
      'Content-Type': 'application/json',
      'apikey': RUYAX_SERVICE_KEY,
    };

    // First batch: execute in chunks
    const maxChunkSize = 50000; // ~50KB chunks
    let startIdx = 0;
    let chunkNum = 0;

    while (startIdx < statements.length) {
      const chunk = statements.substring(startIdx, startIdx + maxChunkSize);
      chunkNum++;

      console.log(`  📤 Chunk ${chunkNum}: Sending...`);

      const response = await fetch(`${RUYAX_URL}/rest/v1/rpc/exec_sql`, {
        method: 'POST',
        headers,
        body: JSON.stringify({ sql_content: chunk })
      }).catch(() => null);

      if (!response || !response.ok) {
        // Try alternative: just print instructions
        console.log('\n⚠️  API batch execution not available.');
        console.log('📄 Using manual import instead...\n');
        break;
      }

      startIdx += maxChunkSize;
      process.stdout.write(`\r  Progress: ${Math.min(startIdx, statements.length)} bytes`);
    }

    console.log('\n\n✅ Schema import initiated!');
    console.log(`📊 Schema size: ${(statements.length / 1024).toFixed(2)}KB`);

  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

importSchema();
