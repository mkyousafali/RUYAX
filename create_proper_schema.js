#!/usr/bin/env node
/**
 * Create proper schema file - remove ONLY problematic lines, keep all CREATE statements
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, 'migrations', 'aqura_fresh_schema.sql');
const outputFile = path.join(__dirname, 'migrations', 'ruyax_proper_schema.sql');

try {
  console.log('🔨 Creating proper schema file...');
  let sql = fs.readFileSync(inputFile, 'utf-8');

  const originalLines = sql.split('\n').length;

  // Filter OUT only problematic lines
  const lines = sql.split('\n');
  const filtered = lines.filter(line => {
    const trimmed = line.trim();
    
    // REMOVE: ALTER TABLE/SCHEMA/SEQUENCE ... OWNER TO
    if (/^ALTER\s+(TABLE|SCHEMA|SEQUENCE|VIEW|FUNCTION|INDEX|PUBLICATION|TYPE|DOMAIN)/i.test(trimmed)) {
      if (/OWNER\s*(TO|=)/i.test(trimmed)) {
        return false; // Skip this line
      }
    }
    
    // REMOVE: ALTER TABLE/SCHEMA ... OWNER = 
    if (/OWNER\s*=\s*\w+/i.test(trimmed) && /^ALTER/i.test(trimmed)) {
      return false; // Skip
    }

    // REMOVE: SET ROLE statements
    if (/^SET\s+ROLE/i.test(trimmed)) {
      return false; // Skip
    }

    // REMOVE: RESET ROLE
    if (/^RESET\s+ROLE/i.test(trimmed)) {
      return false; // Skip
    }

    // KEEP EVERYTHING ELSE: CREATE TABLE, CREATE SCHEMA, CREATE SEQUENCE, etc.
    return true;
  });

  const cleaned = filtered.join('\n');
  fs.writeFileSync(outputFile, cleaned, 'utf-8');

  console.log(`✅ Schema file created!\n`);
  console.log(`📊 Lines:`);
  console.log(`   Original: ${originalLines}`);
  console.log(`   Filtered: ${filtered.length}`);
  console.log(`   Removed:  ${originalLines - filtered.length}\n`);
  
  // Count CREATE statements
  const createCount = cleaned.match(/^CREATE\s+/gim)?.length || 0;
  const alterCount = cleaned.match(/^ALTER\s+/gim)?.length || 0;
  
  console.log(`📋 Statement counts:`);
  console.log(`   CREATE: ${createCount}`);
  console.log(`   ALTER:  ${alterCount}\n`);
  
  console.log(`📄 Ready: migrations/ruyax_proper_schema.sql`);
  console.log(`\n✅ This file should create all tables, schemas, and sequences!`);

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
