#!/usr/bin/env node
/**
 * Clean all chunks - remove SET ROLE and other problematic statements
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const chunksDir = path.join(__dirname, 'migrations', 'sql_chunks');

try {
  console.log('🧹 Cleaning all chunks...\n');

  // Get all chunk files
  const files = fs.readdirSync(chunksDir).filter(f => f.endsWith('.sql')).sort();

  files.forEach(file => {
    const filePath = path.join(chunksDir, file);
    let sql = fs.readFileSync(filePath, 'utf-8');

    const originalSize = sql.length;

    // Remove problematic lines
    const lines = sql.split('\n');
    const filtered = lines.filter(line => {
      const trimmed = line.trim();
      
      // Skip SET ROLE statements
      if (/^SET\s+ROLE/i.test(trimmed)) {
        return false;
      }
      
      // Skip RESET ROLE
      if (/^RESET\s+ROLE/i.test(trimmed)) {
        return false;
      }

      // Skip ANY ALTER ... OWNER statements (including ALTER TYPE)
      if (/^ALTER\s+.*(OWNER\s*(TO|=)|OWNER\s+TO)/i.test(trimmed)) {
        return false;
      }

      return true;
    });

    const cleaned = filtered.join('\n');
    fs.writeFileSync(filePath, cleaned, 'utf-8');

    const removed = originalSize - cleaned.length;
    console.log(`✓ ${file} (removed ${(removed / 1024).toFixed(0)}KB)`);
  });

  console.log(`\n✅ All ${files.length} chunks cleaned!\n`);
  console.log('Ready to import. Try again with chunk_001.sql');

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
