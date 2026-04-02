#!/usr/bin/env node
/**
 * Split schema into smaller chunks for safer import
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, 'migrations', 'aqura_final_schema.sql');
const outputDir = path.join(__dirname, 'migrations', 'schema_chunks');

try {
  // Create output directory
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  console.log('📋 Reading schema file...');
  let sql = fs.readFileSync(inputFile, 'utf-8');

  // Split into logical chunks:
  // 1. Settings and extensions
  // 2. Schema/type definitions  
  // 3. Tables
  // 4. Sequences
  // 5. Functions
  // 6. Views
  // 7. Triggers/Rules
  // 8. Indexes
  // 9. Constraints

  const statements = sql.split(/\n\/\s*$/m).filter(s => s.trim());

  let settingsChunk = '';
  let schemaChunk = '';
  let tableChunk = '';
  let functionChunk = '';
  let viewChunk = '';
  let triggerChunk = '';
  let indexChunk = '';
  let constraintChunk = '';

  statements.forEach(stmt => {
    const normalized = stmt.trim().toUpperCase();
    
    if (normalized.includes('SET ') && !normalized.includes('CREATE')) {
      settingsChunk += stmt + '\n/\n';
    } else if (normalized.includes('CREATE SCHEMA') || normalized.includes('CREATE TYPE')) {
      schemaChunk += stmt + '\n/\n';
    } else if (normalized.includes('CREATE TABLE')) {
      tableChunk += stmt + '\n/\n';
    } else if (normalized.includes('CREATE SEQUENCE')) {
      tableChunk += stmt + '\n/\n'; // Sequences with tables
    } else if (normalized.includes('CREATE FUNCTION') || normalized.includes('CREATE OR REPLACE FUNCTION')) {
      functionChunk += stmt + '\n/\n';
    } else if (normalized.includes('CREATE VIEW') || normalized.includes('CREATE MATERIALIZED VIEW')) {
      viewChunk += stmt + '\n/\n';
    } else if (normalized.includes('CREATE TRIGGER') || normalized.includes('CREATE RULE')) {
      triggerChunk += stmt + '\n/\n';
    } else if (normalized.includes('CREATE INDEX')) {
      indexChunk += stmt + '\n/\n';
    } else if (normalized.includes('ALTER TABLE') || normalized.includes('ADD CONSTRAINT')) {
      constraintChunk += stmt + '\n/\n';
    } else {
      if (stmt.trim()) {
        schemaChunk += stmt + '\n/\n'; // Default to schema
      }
    }
  });

  // Write chunks
  const chunks = [
    { name: '01_settings.sql', content: settingsChunk },
    { name: '02_schema_types.sql', content: schemaChunk },
    { name: '03_tables_sequences.sql', content: tableChunk },
    { name: '04_functions.sql', content: functionChunk },
    { name: '05_views.sql', content: viewChunk },
    { name: '06_triggers.sql', content: triggerChunk },
    { name: '07_indexes.sql', content: indexChunk },
    { name: '08_constraints.sql', content: constraintChunk },
  ];

  chunks.forEach(chunk => {
    if (chunk.content.trim()) {
      const chunkPath = path.join(outputDir, chunk.name);
      fs.writeFileSync(chunkPath, chunk.content, 'utf-8');
      const size = (chunk.content.length / 1024).toFixed(2);
      console.log(`✓ ${chunk.name} (${size}KB)`);
    }
  });

  console.log('\n✅ Schema split into chunks!\n');
  console.log('📋 Import order:');
  console.log('   1) 01_settings.sql');
  console.log('   2) 02_schema_types.sql');
  console.log('   3) 03_tables_sequences.sql');
  console.log('   4) 04_functions.sql');
  console.log('   5) 05_views.sql');
  console.log('   6) 06_triggers.sql');
  console.log('   7) 07_indexes.sql');
  console.log('   8) 08_constraints.sql');
  console.log('\nLocation: migrations/schema_chunks/');

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
