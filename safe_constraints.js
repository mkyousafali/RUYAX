#!/usr/bin/env node
/**
 * Fix constraints - wrap in DO blocks to ignore if they already exist
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, 'migrations', 'ruyax_fixed_schema.sql');
const outputFile = path.join(__dirname, 'migrations', 'ruyax_safe_schema.sql');

try {
  console.log('🔒 Making constraints safe with error handling...');
  let sql = fs.readFileSync(inputFile, 'utf-8');

  // Wrap ALTER TABLE ADD CONSTRAINT in DO blocks to ignore existing constraints
  sql = sql.replace(
    /^(ALTER TABLE\s+[\w\.]+\s+ADD CONSTRAINT\s+[\w]+\s+(?:PRIMARY KEY|FOREIGN KEY|UNIQUE).*);$/gm,
    (match) => {
      return `DO $$\nBEGIN\n  ${match}\nEXCEPTION WHEN OTHERS THEN\n  NULL; -- Constraint already exists or error\nEND $$;`;
    }
  );

  fs.writeFileSync(outputFile, sql, 'utf-8');

  console.log('✅ Schema made safe!\n');
  console.log('Changes:');
  console.log('  ✓ Wrapped ALTER TABLE ADD CONSTRAINT in DO blocks');
  console.log('  ✓ Duplicate constraints will be silently ignored\n');
  console.log('📄 Ready: migrations/ruyax_safe_schema.sql');

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
