#!/usr/bin/env node
/**
 * Advanced chunk cleaning - fix VIEW syntax
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const chunksDir = path.join(__dirname, 'migrations', 'sql_chunks');

try {
  console.log('🧹 Advanced cleaning of chunks...\n');

  const files = fs.readdirSync(chunksDir).filter(f => f.endsWith('.sql')).sort();

  files.forEach(file => {
    const filePath = path.join(chunksDir, file);
    let sql = fs.readFileSync(filePath, 'utf-8');

    const originalSize = sql.length;

    // Split into lines for processing
    let lines = sql.split('\n');
    const filtered = [];
    
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const trimmed = line.trim();

      // Skip SET ROLE statements
      if (/^SET\s+ROLE/i.test(trimmed)) {
        continue;
      }
      
      // Skip RESET ROLE
      if (/^RESET\s+ROLE/i.test(trimmed)) {
        continue;
      }

      // Skip ANY ALTER ... OWNER statements
      if (/^ALTER\s+.*(OWNER\s*(TO|=)|OWNER\s+TO)/i.test(trimmed)) {
        continue;
      }

      // Fix CREATE VIEW IF NOT EXISTS - change to DROP + CREATE
      if (/^CREATE\s+VIEW\s+IF\s+NOT\s+EXISTS/i.test(trimmed)) {
        // Extract schema and view name
        const match = trimmed.match(/CREATE\s+VIEW\s+IF\s+NOT\s+EXISTS\s+([\w.]+)\s+AS/i);
        if (match) {
          const viewName = match[1];
          filtered.push(`DROP VIEW IF EXISTS ${viewName} CASCADE;`);
          filtered.push(line.replace(/IF\s+NOT\s+EXISTS\s+/i, '')); // Remove IF NOT EXISTS
        } else {
          filtered.push(line);
        }
        continue;
      }

      filtered.push(line);
    }

    const cleaned = filtered.join('\n');
    fs.writeFileSync(filePath, cleaned, 'utf-8');

    const removed = originalSize - cleaned.length;
    console.log(`✓ ${file} (removed ${(removed / 1024).toFixed(0)}KB)`);
  });

  console.log(`\n✅ All ${files.length} chunks advanced-cleaned!\n`);
  console.log('Fixed:');
  console.log('  ✓ Removed SET ROLE / RESET ROLE');
  console.log('  ✓ Removed ALTER ... OWNER');
  console.log('  ✓ Fixed CREATE VIEW syntax');

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
