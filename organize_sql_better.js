#!/usr/bin/env node
/**
 * Better SQL organization - categorize more accurately
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
    .map(stmt => stmt.trim())
    .filter(stmt => stmt.length > 10);

  console.log(`✓ Found ${statements.length} statements\n`);

  // Better categorization
  const createTableStatements = [];
  const createTypeStatements = [];
  const createIndexStatements = [];
  const alterOwnerStatements = [];
  const constraintStatements = [];
  const updateStatements = [];
  const settingsStatements = [];
  const otherStatements = [];

  statements.forEach(stmt => {
    const upper = stmt.toUpperCase();
    const firstLine = stmt.split('\n')[0].toUpperCase();
    
    if (firstLine.includes('CREATE TABLE')) {
      createTableStatements.push(stmt);
    } else if (firstLine.includes('CREATE TYPE') || firstLine.includes('CREATE DOMAIN')) {
      createTypeStatements.push(stmt);
    } else if (firstLine.includes('CREATE INDEX')) {
      createIndexStatements.push(stmt);
    } else if (upper.includes('OWNER TO') || upper.includes('OWNER =')) {
      // Skip OWNER statements
      return;
    } else if (firstLine.includes('ADD CONSTRAINT') || firstLine.includes('ADD PRIMARY KEY')) {
      constraintStatements.push(stmt);
    } else if (firstLine.includes('UPDATE')) {
      updateStatements.push(stmt);
    } else if (firstLine.includes('SET ') || firstLine.includes('SELECT pg_catalog')) {
      settingsStatements.push(stmt);
    } else {
      otherStatements.push(stmt);
    }
  });

  console.log(`📊 Statement breakdown:`);
  console.log(`  CREATE TABLE:    ${createTableStatements.length}`);
  console.log(`  CREATE TYPE:     ${createTypeStatements.length}`);
  console.log(`  CREATE INDEX:    ${createIndexStatements.length}`);
  console.log(`  CONSTRAINTS:     ${constraintStatements.length}`);
  console.log(`  UPDATE:          ${updateStatements.length}`);
  console.log(`  SETTINGS:        ${settingsStatements.length}`);
  console.log(`  OTHER:           ${otherStatements.length}\n`);

  // Write organized chunks
  const chunks = [
    { name: '01_types.sql', statements: createTypeStatements },
    { name: '02_tables.sql', statements: createTableStatements },
    { name: '03_constraints.sql', statements: constraintStatements },
    { name: '04_indexes.sql', statements: createIndexStatements },
    { name: '05_other.sql', statements: [...otherStatements, ...updateStatements] }
  ];

  chunks.forEach(chunk => {
    if (chunk.statements.length > 0) {
      const content = chunk.statements.join(';\n\n') + ';';
      const chunkPath = path.join(chunksDir, chunk.name);
      fs.writeFileSync(chunkPath, content, 'utf-8');
      const size = (content.length / 1024).toFixed(0);
      console.log(`✓ ${chunk.name} (${size}KB, ${chunk.statements.length} statements)`);
    }
  });

  console.log(`\n✅ Organized chunks created!\n`);
  console.log('📋 Import in this order:');
  console.log('   1. 01_types.sql');
  console.log('   2. 02_tables.sql');
  console.log('   3. 03_constraints.sql');
  console.log('   4. 04_indexes.sql');
  console.log('   5. 05_other.sql\n');
  console.log('Location: migrations/sql_organized/');

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
