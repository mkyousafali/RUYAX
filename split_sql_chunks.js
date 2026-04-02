#!/usr/bin/env node
/**
 * Split large SQL file into chunks
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const sqlFile = path.join(__dirname, 'migrations', 'ruyax_aqura_tables.sql');
const chunksDir = path.join(__dirname, 'migrations', 'sql_chunks');

try {
  // Create chunks directory
  if (!fs.existsSync(chunksDir)) {
    fs.mkdirSync(chunksDir, { recursive: true });
  }

  console.log('📂 Reading SQL file...');
  let sql = fs.readFileSync(sqlFile, 'utf-8');

  // Split by major statement types for logical grouping
  const lines = sql.split('\n');
  
  let currentChunk = '';
  let chunkNum = 0;
  let chunkSize = 0;
  const maxChunkSize = 500000; // 500KB per chunk

  const writeChunk = (content) => {
    if (content.trim()) {
      chunkNum++;
      const chunkFile = path.join(chunksDir, `chunk_${String(chunkNum).padStart(3, '0')}.sql`);
      fs.writeFileSync(chunkFile, content, 'utf-8');
      console.log(`  ✓ Chunk ${chunkNum}: ${(content.length / 1024).toFixed(0)}KB`);
    }
  };

  lines.forEach((line) => {
    currentChunk += line + '\n';
    chunkSize += line.length;

    if (chunkSize >= maxChunkSize) {
      writeChunk(currentChunk);
      currentChunk = '';
      chunkSize = 0;
    }
  });

  // Write remaining
  writeChunk(currentChunk);

  console.log(`\n✅ Split into ${chunkNum} chunks\n`);
  console.log('📋 Import order:');
  for (let i = 1; i <= chunkNum; i++) {
    console.log(`   chunk_${String(i).padStart(3, '0')}.sql`);
  }
  console.log(`\nLocation: migrations/sql_chunks/`);

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
