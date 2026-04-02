#!/usr/bin/env node
/**
 * Fix SQL syntax - remove PostgreSQL pg_dump "/" delimiter
 * and ensure proper semicolons
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, 'migrations', 'schema_chunks', '02_schema_types.sql');
const outputFile = path.join(__dirname, 'migrations', 'ruyax_schema_clean.sql');

try {
  console.log('🔧 Fixing SQL syntax...');
  let sql = fs.readFileSync(inputFile, 'utf-8');

  const originalSize = sql.length;

  // Remove the "/" delimiter (pg_dump artifact)
  sql = sql.replace(/^\s*\/\s*$/gm, '');

  // Clean up multiple blank lines
  sql = sql.replace(/\n\n\n+/g, '\n\n');

  // Ensure statements end with semicolon (if they don't have one)
  const lines = sql.split('\n');
  const fixedLines = [];
  
  for (let i = 0; i < lines.length; i++) {
    let line = lines[i];
    const trimmed = line.trim();

    // Skip empty and comment lines
    if (!trimmed || trimmed.startsWith('--')) {
      fixedLines.push(line);
      continue;
    }

    // Check if this line ends a statement
    const isStatementEnd = trimmed.endsWith(';');
    const isCreateOrAlter = /^(CREATE|ALTER|DROP|INSERT|UPDATE|DELETE|SELECT|WITH)/i.test(trimmed);
    
    // Add semicolon if statement doesn't have one
    if (isCreateOrAlter && !isStatementEnd && trimmed.length > 0) {
      // Check if next line starts a comment or new statement
      const nextLine = i + 1 < lines.length ? lines[i + 1].trim() : '';
      if (!nextLine || nextLine.startsWith('--') || /^(CREATE|ALTER|DROP|--)/i.test(nextLine)) {
        if (!trimmed.endsWith(',') && !trimmed.endsWith('(')) {
          line += ';';
        }
      }
    }

    fixedLines.push(line);
  }

  sql = fixedLines.join('\n');
  const newSize = sql.length;

  fs.writeFileSync(outputFile, sql, 'utf-8');

  console.log('✅ SQL syntax fixed!\n');
  console.log(`📊 Size: ${(newSize / 1024).toFixed(2)}KB`);
  console.log(`\n✓ Removed "/" delimiters`);
  console.log(`✓ Fixed semicolons\n`);
  console.log(`📄 Ready: migrations/ruyax_schema_clean.sql`);

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
