#!/usr/bin/env node
/**
 * Fix schema file - use IF NOT EXISTS for schemas and tables
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, 'migrations', 'ruyax_proper_schema.sql');
const outputFile = path.join(__dirname, 'migrations', 'ruyax_fixed_schema.sql');

try {
  console.log('🔧 Adding IF NOT EXISTS to schema...');
  let sql = fs.readFileSync(inputFile, 'utf-8');

  // Replace CREATE SCHEMA with CREATE SCHEMA IF NOT EXISTS
  sql = sql.replace(/^CREATE SCHEMA\s+(\w+);/gm, 'CREATE SCHEMA IF NOT EXISTS $1;');

  // Replace CREATE TABLE with CREATE TABLE IF NOT EXISTS
  sql = sql.replace(/^CREATE TABLE\s+/gm, 'CREATE TABLE IF NOT EXISTS ');

  // Replace CREATE SEQUENCE with CREATE SEQUENCE IF NOT EXISTS
  sql = sql.replace(/^CREATE SEQUENCE\s+/gm, 'CREATE SEQUENCE IF NOT EXISTS ');

  // Replace CREATE VIEW with CREATE VIEW IF NOT EXISTS
  sql = sql.replace(/^CREATE VIEW\s+/gm, 'CREATE VIEW IF NOT EXISTS ');

  // Replace CREATE MATERIALIZED VIEW with CREATE MATERIALIZED VIEW IF NOT EXISTS
  sql = sql.replace(/^CREATE MATERIALIZED VIEW\s+/gm, 'CREATE MATERIALIZED VIEW IF NOT EXISTS ');

  fs.writeFileSync(outputFile, sql, 'utf-8');

  console.log('✅ Schema file fixed!\n');
  console.log('Changes made:');
  console.log('  ✓ CREATE SCHEMA → CREATE SCHEMA IF NOT EXISTS');
  console.log('  ✓ CREATE TABLE → CREATE TABLE IF NOT EXISTS');
  console.log('  ✓ CREATE SEQUENCE → CREATE SEQUENCE IF NOT EXISTS');
  console.log('  ✓ CREATE VIEW → CREATE VIEW IF NOT EXISTS\n');
  
  console.log('📄 Ready: migrations/ruyax_fixed_schema.sql');
  console.log('\n✅ Now you can safely re-run without conflicts!');

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
