import fs from 'fs';
import path from 'path';

const inputFile = './ruyax_aqura_tables.sql';
const outputDir = './sql_final';

// Create output directory
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

const content = fs.readFileSync(inputFile, 'utf8');
const statements = content
  .split(';')
  .map(s => s.trim())
  .filter(s => s.length > 0)
  .map(s => s + ';');

console.log(`📊 Total statements: ${statements.length}\n`);

// Categorize statements
const categories = {
  settings: [],      // SET ...
  types: [],         // CREATE TYPE
  domains: [],       // CREATE DOMAIN
  tables: [],        // CREATE TABLE
  indexes: [],       // CREATE INDEX
  constraints: [],   // ALTER TABLE ... ADD CONSTRAINT
  updates: [],       // UPDATE
  other: []
};

statements.forEach(stmt => {
  const trimmed = stmt.trim().toUpperCase();
  
  if (trimmed.startsWith('SET ')) {
    categories.settings.push(stmt);
  } else if (trimmed.includes('CREATE TYPE') || trimmed.includes('CREATE DOMAIN')) {
    categories.types.push(stmt);
  } else if (trimmed.startsWith('CREATE TABLE')) {
    categories.tables.push(stmt);
  } else if (trimmed.startsWith('CREATE INDEX')) {
    categories.indexes.push(stmt);
  } else if (trimmed.includes('ALTER TABLE') && trimmed.includes('ADD CONSTRAINT')) {
    categories.constraints.push(stmt);
  } else if (trimmed.startsWith('UPDATE ')) {
    categories.updates.push(stmt);
  } else {
    categories.other.push(stmt);
  }
});

// Create import order
const order = ['settings', 'types', 'tables', 'constraints', 'indexes', 'updates', 'other'];
let fileOrder = 1;

console.log('📝 Statement breakdown:');
order.forEach(cat => {
  console.log(`   ${cat.padEnd(12)} : ${categories[cat].length} statements`);
});
console.log('');

// Write files in order
order.forEach(category => {
  const stmts = categories[category];
  if (stmts.length === 0) return;
  
  const padding = String(fileOrder).padStart(2, '0');
  const filename = `${padding}_${category}.sql`;
  const filepath = path.join(outputDir, filename);
  
  fs.writeFileSync(filepath, stmts.join('\n\n'));
  
  const sizeKB = (fs.statSync(filepath).size / 1024).toFixed(1);
  console.log(`✓ ${filename.padEnd(25)} (${stmts.length} stmts, ${sizeKB}KB)`);
  
  fileOrder++;
});

console.log(`\n✅ Import in order:`);
order.forEach((cat, i) => {
  const padding = String(i + 1).padStart(2, '0');
  console.log(`   ${i + 1}. ${padding}_${cat}.sql`);
});

console.log(`\n📍 Files created in: ${outputDir}/`);
