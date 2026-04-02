#!/usr/bin/env node
/**
 * Clean Aqura public schema for RUYAX import
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, 'migrations', 'aqura_public_complete.sql');
const outputFile = path.join(__dirname, 'migrations', 'ruyax_aqura_tables.sql');

try {
  console.log('🧹 Cleaning Aqura public schema...');
  let sql = fs.readFileSync(inputFile, 'utf-8');

  const originalSize = sql.length;

  // Remove problematic statements
  const lines = sql.split('\n');
  const filtered = lines.filter(line => {
    const trimmed = line.trim();
    
    // Skip ALTER TABLE ... OWNER statements
    if (/^ALTER\s+(TABLE|SCHEMA|SEQUENCE|VIEW|FUNCTION).*OWNER\s*(TO|=)/i.test(trimmed)) {
      return false;
    }
    
    // Skip SET ROLE/RESET ROLE
    if (/^(SET|RESET)\s+ROLE/i.test(trimmed)) {
      return false;
    }

    return true;
  });

  let cleaned = filtered.join('\n');

  // Add IF NOT EXISTS to CREATE statements
  cleaned = cleaned.replace(/^CREATE TABLE\s+/gm, 'CREATE TABLE IF NOT EXISTS ');
  cleaned = cleaned.replace(/^CREATE SEQUENCE\s+/gm, 'CREATE SEQUENCE IF NOT EXISTS ');
  cleaned = cleaned.replace(/^CREATE VIEW\s+/gm, 'CREATE VIEW IF NOT EXISTS ');
  cleaned = cleaned.replace(/^CREATE SCHEMA\s+/gm, 'CREATE SCHEMA IF NOT EXISTS ');
  cleaned = cleaned.replace(/^CREATE INDEX\s+/gm, 'CREATE INDEX IF NOT EXISTS ');

  fs.writeFileSync(outputFile, cleaned, 'utf-8');

  console.log('✅ Public schema cleaned!\n');
  console.log(`📊 Size: ${(cleaned.length / 1024).toFixed(2)}KB\n`);
  console.log('Changes made:');
  console.log('  ✓ Removed OWNER statements');
  console.log('  ✓ Removed SET ROLE statements');
  console.log('  ✓ Added IF NOT EXISTS to CREATE statements\n');
  
  console.log('📄 Ready: migrations/ruyax_aqura_tables.sql');
  console.log('\n✅ This file contains all Aqura application tables!');

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
