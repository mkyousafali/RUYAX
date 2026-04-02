#!/usr/bin/env node
/**
 * Remove duplicate constraints from schema
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, 'migrations', 'ruyax_fixed_schema.sql');
const outputFile = path.join(__dirname, 'migrations', 'ruyax_deduped_schema.sql');

try {
  console.log('🔧 Removing duplicate constraints...');
  let sql = fs.readFileSync(inputFile, 'utf-8');

  // Track added constraints to avoid duplicates
  const seenConstraints = new Set();
  const lines = sql.split('\n');
  const filtered = [];

  lines.forEach((line, idx) => {
    const trimmed = line.trim();
    
    // Check if this is a constraint addition line
    if (/ADD CONSTRAINT\s+(\w+)\s+(PRIMARY KEY|UNIQUE|FOREIGN KEY)/i.test(trimmed)) {
      // Extract constraint name
      const match = trimmed.match(/ADD CONSTRAINT\s+(\w+)/i);
      if (match) {
        const constraintName = match[1];
        
        if (seenConstraints.has(constraintName)) {
          // Skip duplicate
          console.log(`  ⏭️  Skipped duplicate: ${constraintName}`);
          return;
        }
        
        seenConstraints.add(constraintName);
      }
    }
    
    filtered.push(line);
  });

  const cleaned = filtered.join('\n');
  fs.writeFileSync(outputFile, cleaned, 'utf-8');

  console.log(`\n✅ Duplicates removed!\n`);
  console.log(`📄 Ready: migrations/ruyax_deduped_schema.sql`);

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
