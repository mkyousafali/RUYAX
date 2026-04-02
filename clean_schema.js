#!/usr/bin/env node
/**
 * Clean Aqura schema for Supabase Cloud import
 * Removes ALTER OWNER, SET ROLE, and other superuser-only commands
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, 'migrations', 'aqura_fresh_schema.sql');
const outputFile = path.join(__dirname, 'migrations', 'aqura_clean_schema.sql');

try {
  console.log('📖 Reading schema file...');
  let sql = fs.readFileSync(inputFile, 'utf-8');

  const originalSize = sql.length;

  // Remove problematic lines
  const lines = sql.split('\n');
  const filteredLines = lines.filter(line => {
    const trimmed = line.trim();
    
    // Skip ALTER OWNER statements
    if (/^ALTER\s+(TABLE|SCHEMA|SEQUENCE|VIEW|FUNCTION|INDEX).*(OWNER\s+TO|OWNER = )/i.test(trimmed)) {
      return false;
    }
    
    // Skip SET ROLE statements
    if (/^SET\s+ROLE/i.test(trimmed)) {
      return false;
    }
    
    // Skip RESET ROLE
    if (/^RESET\s+ROLE/i.test(trimmed)) {
      return false;
    }

    return true;
  });

  const cleanedSQL = filteredLines.join('\n');
  const newSize = cleanedSQL.length;

  fs.writeFileSync(outputFile, cleanedSQL, 'utf-8');

  console.log('\n✅ Schema cleaned successfully!\n');
  console.log(`📊 Size reduction:`);
  console.log(`   Original:  ${(originalSize / 1024).toFixed(2)}KB`);
  console.log(`   Cleaned:   ${(newSize / 1024).toFixed(2)}KB`);
  console.log(`   Removed:   ${((originalSize - newSize) / 1024).toFixed(2)}KB\n`);
  console.log(`📄 Output: migrations/aqura_clean_schema.sql`);
  console.log('\n📋 Next step:');
  console.log('   1. Go to: https://app.supabase.com/project/tncbykfklynsnnyjajgf/sql/new');
  console.log('   2. Copy & paste from: migrations/aqura_clean_schema.sql');
  console.log('   3. Click "Run"');

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
