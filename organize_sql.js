#!/usr/bin/env node
/**
 * Reorganize SQL file - CREATE statements first, then UPDATE/INSERT
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const sqlFile = path.join(__dirname, 'migrations', 'ruyax_aqura_tables.sql');
const chunksDir = path.join(__dirname, 'migrations', 'sql_organized');

try {
  // Create chunks directory
  if (!fs.existsSync(chunksDir)) {
    fs.mkdirSync(chunksDir, { recursive: true });
  }

  console.log('📋 Reading and organizing SQL file...');
  let sql = fs.readFileSync(sqlFile, 'utf-8');

  // Split by statements
  const statements = sql
    .split(/;\s*\n/m)
    .map(stmt => stmt.trim() + ';')
    .filter(stmt => stmt.length > 10 && !stmt.match(/^--/));

  console.log(`✓ Found ${statements.length} statements\n`);

  // Categorize statements
  const createStatements = [];
  const alterStatements = [];
  const updateStatements = [];
  const otherStatements = [];

  statements.forEach(stmt => {
    const upper = stmt.toUpperCase();
    
    if (upper.includes('CREATE TABLE') || 
        upper.includes('CREATE SEQUENCE') ||
        upper.includes('CREATE INDEX') ||
        upper.includes('CREATE TYPE')) {
      createStatements.push(stmt);
    } else if (upper.includes('ALTER TABLE') || 
               upper.includes('ALTER SEQUENCE')) {
      alterStatements.push(stmt);
    } else if (upper.includes('UPDATE')) {
      updateStatements.push(stmt);
    } else {
      otherStatements.push(stmt);
    }
  });

  console.log(`📊 Statement breakdown:`);
  console.log(`  CREATE: ${createStatements.length}`);
  console.log(`  ALTER:  ${alterStatements.length}`);
  console.log(`  UPDATE: ${updateStatements.length}`);
  console.log(`  OTHER:  ${otherStatements.length}\n`);

  // Write organized chunks
  const chunks = [
    { name: 'chunk_01_create.sql', statements: createStatements },
    { name: 'chunk_02_alter.sql', statements: alterStatements },
    { name: 'chunk_03_update.sql', statements: updateStatements },
    { name: 'chunk_04_other.sql', statements: otherStatements }
  ];

  chunks.forEach(chunk => {
    if (chunk.statements.length > 0) {
      const content = `-- ${chunk.name}\n\n${chunk.statements.join('\n\n')}`;
      const chunkPath = path.join(chunksDir, chunk.name);
      fs.writeFileSync(chunkPath, content, 'utf-8');
      const size = (content.length / 1024).toFixed(0);
      console.log(`✓ ${chunk.name} (${size}KB, ${chunk.statements.length} statements)`);
    }
  });

  console.log(`\n✅ Organized chunks created!\n`);
  console.log('📋 Import in this order:');
  console.log('   1. chunk_01_create.sql  - Creates all tables');
  console.log('   2. chunk_02_alter.sql   - Adds constraints');
  console.log('   3. chunk_03_update.sql  - Initializes data');
  console.log('   4. chunk_04_other.sql   - Other statements\n');
  console.log('Location: migrations/sql_organized/');

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
