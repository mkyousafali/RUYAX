#!/usr/bin/env node
/**
 * Deep clean Aqura schema for Supabase Cloud
 * Removes ALL role/owner related statements
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, 'migrations', 'aqura_clean_schema.sql');
const outputFile = path.join(__dirname, 'migrations', 'aqura_final_schema.sql');

try {
  console.log('🧹 Deep cleaning schema file...');
  let sql = fs.readFileSync(inputFile, 'utf-8');

  const originalSize = sql.length;

  // Remove problematic lines with more patterns
  const lines = sql.split('\n');
  const filteredLines = lines.filter(line => {
    const trimmed = line.trim();
    
    // Skip any OWNER/owner statements
    if (/OWNER\s*(TO|=)\s*\w+/i.test(trimmed)) {
      return false;
    }
    
    // Skip ALTER OWNER statements
    if (/^ALTER\s+(TABLE|SCHEMA|SEQUENCE|VIEW|FUNCTION|INDEX|PUBLICATION)/i.test(trimmed)) {
      // Check if this line contains OWNER
      if (/OWNER\s*(TO|=)?/i.test(line)) {
        return false;
      }
    }
    
    // Skip any SET statements that are risky
    if (/^SET\s+(ROLE|SESSION|LOCAL)/i.test(trimmed)) {
      return false;
    }
    
    // Skip RESET statements
    if (/^RESET\s+(ROLE|SESSION)/i.test(trimmed)) {
      return false;
    }

    return true;
  });

  const cleanedSQL = filteredLines.join('\n');
  const newSize = cleanedSQL.length;

  fs.writeFileSync(outputFile, cleanedSQL, 'utf-8');

  console.log('✅ Schema deep cleaned!\n');
  console.log(`📊 Removed: ${((originalSize - newSize) / 1024).toFixed(2)}KB`);
  
  // Verify no problematic patterns remain
  const checkLines = cleanedSQL.split('\n');
  let issueCount = 0;
  checkLines.forEach((line, idx) => {
    if (/SET ROLE|OWNER TO|ALTER.*OWNER/i.test(line)) {
      issueCount++;
      console.log(`⚠️  Line ${idx + 1}: ${line.substring(0, 80)}`);
    }
  });

  if (issueCount === 0) {
    console.log('✓ No problematic statements remaining\n');
    console.log('📋 Ready to import:');
    console.log('   File: migrations/aqura_final_schema.sql');
  } else {
    console.log(`\n⚠️  Found ${issueCount} potentially problematic lines`);
  }

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
