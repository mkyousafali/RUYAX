#!/usr/bin/env node
/**
 * Clean schema - drop all tables first, then recreate
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, 'migrations', 'ruyax_fixed_schema.sql');
const outputFile = path.join(__dirname, 'migrations', 'ruyax_clean_fresh_schema.sql');

try {
  console.log('🧹 Creating fresh schema with DROP and CREATE...');
  let sql = fs.readFileSync(inputFile, 'utf-8');

  // Add DROP statements at the beginning
  const dropStatements = `
-- Drop all tables and schemas if they exist (in reverse order of dependencies)
DROP SCHEMA IF EXISTS _analytics CASCADE;
DROP SCHEMA IF EXISTS _supavisor CASCADE;

`;

  // Combine drop + schema
  sql = dropStatements + sql;

  fs.writeFileSync(outputFile, sql, 'utf-8');

  console.log('✅ Fresh schema created!\n');
  console.log('Changes:');
  console.log('  ✓ Added DROP SCHEMA IF EXISTS _analytics CASCADE');
  console.log('  ✓ Added DROP SCHEMA IF EXISTS _supavisor CASCADE');
  console.log('  ✓ All tables will be created fresh\n');
  console.log('📄 Ready: migrations/ruyax_clean_fresh_schema.sql');
  console.log('\n⚠️  WARNING: This will DELETE everything in _analytics schema');
  console.log('   Make sure you want to start fresh!');

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
