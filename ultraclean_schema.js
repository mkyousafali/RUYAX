#!/usr/bin/env node
/**
 * Ultra-clean schema - removes ANY line with ROLE, OWNER, or SET keywords before CREATE/ALTER
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, 'migrations', 'aqura_final_schema.sql');
const outputFile = path.join(__dirname, 'migrations', 'aqura_ultraclean_schema.sql');

try {
  console.log('🧼 Ultra-cleaning schema...');
  let sql = fs.readFileSync(inputFile, 'utf-8');

  const lines = sql.split('\n');
  const filtered = [];
  let lastWasComment = false;

  lines.forEach((line, idx) => {
    const trimmed = line.trim();
    
    // Keep comment lines
    if (trimmed.startsWith('--')) {
      lastWasComment = true;
      filtered.push(line);
      return;
    }

    // Remove problematic keywords at start of actual statements
    if (/^(SET|RESET|ALTER).*(ROLE|OWNER|SESSION)/i.test(trimmed)) {
      lastWasComment = false;
      return; // Skip this line entirely
    }

    // Remove lines that are just part of OWNER assignments
    if (/^\s*(OWNER|USER|ROLE)\s*=?\s*/i.test(trimmed) && !trimmed.includes('CREATE')) {
      lastWasComment = false;
      return; // Skip
    }

    // Otherwise keep the line
    filtered.push(line);
    lastWasComment = false;
  });

  // Remove excessive blank lines
  let cleaned = filtered
    .join('\n')
    .replace(/\n\n\n+/g, '\n\n') // Max 2 blank lines
    .split('\n')
    .filter((line, i, arr) => {
      // Keep meaningful content
      if (line.trim()) return true;
      // Keep one blank line between sections
      return i === 0 || arr[i-1].trim() !== '';
    })
    .join('\n');

  fs.writeFileSync(outputFile, cleaned, 'utf-8');

  console.log(`✅ Schema ultra-cleaned!\n`);
  console.log(`📊 Final size: ${(cleaned.length / 1024).toFixed(2)}KB`);
  console.log(`\n📄 Use: migrations/aqura_ultraclean_schema.sql`);

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
