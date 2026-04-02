import fs from 'fs';
import path from 'path';

const inputFile = './ruyax_aqura_tables.sql';
const outputDir = './sql_final_v2';

// Create output directory
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

const content = fs.readFileSync(inputFile, 'utf8');
const statements = content
  .split(';')
  .map(s => s.trim())
  .filter(s => s.length > 0 && !s.startsWith('--'))
  .map(s => s + ';');

console.log(`📊 Total statements: ${statements.length}\n`);

// Categorize statements - look at main SQL keyword
const categories = {
  'sets': [],           // SET ...
  'schemas': [],        // CREATE SCHEMA
  'types': [],          // CREATE TYPE / CREATE ENUM
  'tables': [],         // CREATE TABLE
  'sequences': [],      // CREATE SEQUENCE
  'indexes': [],        // CREATE INDEX
  'foreign_keys': [],   // ALTER TABLE ... ADD CONSTRAINT (FOREIGN KEY)
  'triggers': [],       // CREATE TRIGGER
  'functions': [],      // CREATE FUNCTION / CREATE PROCEDURE
  'comments': [],       // COMMENT ON
  'acl': [],            // GRANT / ALTER ... OWNER
  'updates': [],        // UPDATE
  'other': []           // Everything else
};

statements.forEach(stmt => {
  const upper = stmt.toUpperCase();
  
  // Extract first meaningful SQL keyword
  let matched = false;
  
  if (upper.includes('SET ')) {
    categories.sets.push(stmt);
    matched = true;
  } else if (upper.includes('CREATE SCHEMA')) {
    categories.schemas.push(stmt);
    matched = true;
  } else if (upper.includes('CREATE TYPE') || upper.includes('CREATE ENUM')) {
    categories.types.push(stmt);
    matched = true;
  } else if (upper.includes('CREATE TABLE')) {
    categories.tables.push(stmt);
    matched = true;
  } else if (upper.includes('CREATE SEQUENCE')) {
    categories.sequences.push(stmt);
    matched = true;
  } else if (upper.includes('CREATE INDEX')) {
    categories.indexes.push(stmt);
    matched = true;
  } else if (upper.includes('ADD CONSTRAINT')) {
    categories.foreign_keys.push(stmt);
    matched = true;
  } else if (upper.includes('CREATE TRIGGER')) {
    categories.triggers.push(stmt);
    matched = true;
  } else if (upper.includes('CREATE FUNCTION') || upper.includes('CREATE PROCEDURE')) {
    categories.functions.push(stmt);
    matched = true;
  } else if (upper.includes('COMMENT ON')) {
    categories.comments.push(stmt);
    matched = true;
  } else if (upper.includes('GRANT ') || upper.includes('ALTER') && upper.includes('OWNER')) {
    categories.acl.push(stmt);
    matched = true;
  } else if (upper.startsWith('UPDATE ')) {
    categories.updates.push(stmt);
    matched = true;
  }
  
  if (!matched) {
    categories.other.push(stmt);
  }
});

// Create import order - MOST IMPORTANT: tables must come before constraints/indexes!
const order = ['sets', 'schemas', 'types', 'tables', 'sequences', 'indexes', 'foreign_keys', 'triggers', 'functions', 'comments', 'acl', 'updates', 'other'];

console.log('📝 Statement breakdown:');
let total = 0;
order.forEach(cat => {
  const count = categories[cat].length;
  total += count;
  if (count > 0) {
    console.log(`   ${cat.padEnd(15)} : ${count} statements`);
  }
});
console.log(`   ${'─'.repeat(35)}`);
console.log(`   ${'TOTAL'.padEnd(15)} : ${total} statements\n`);

// Write files in order
let fileOrder = 1;
order.forEach(category => {
  const stmts = categories[category];
  if (stmts.length === 0) return;
  
  const padding = String(fileOrder).padStart(2, '0');
  const filename = `${padding}_${category}.sql`;
  const filepath = path.join(outputDir, filename);
  
  fs.writeFileSync(filepath, stmts.join('\n\n'));
  
  const sizeKB = (fs.statSync(filepath).size / 1024).toFixed(1);
  console.log(`✓ ${filename.padEnd(25)} (${String(stmts.length).padStart(5)} stmts, ${String(sizeKB).padStart(7)}KB)`);
  
  fileOrder++;
});

console.log(`\n📋 Import these files IN ORDER to Supabase SQL Editor:`);
fileOrder = 1;
order.forEach(category => {
  if (categories[category].length === 0) return;
  const padding = String(fileOrder).padStart(2, '0');
  console.log(`   ${fileOrder}. ${padding}_${category}.sql`);
  fileOrder++;
});

console.log(`\n📍 Files created in: ./sql_final_v2/`);
