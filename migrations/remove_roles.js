import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const sqlFile = path.join(__dirname, 'ruyax_aqura_tables.sql');
console.log(`📖 Reading: ${path.basename(sqlFile)}\n`);

let content = fs.readFileSync(sqlFile, 'utf8');
let originalSize = content.length;
let removedLines = 0;

// Split into lines and filter
const lines = content.split('\n');
const filtered = lines.filter(line => {
  const trimmed = line.trim();
  
  // Remove GRANT statements
  if (trimmed.startsWith('GRANT ')) {
    removedLines++;
    return false;
  }
  
  // Remove ALTER DEFAULT PRIVILEGES
  if (trimmed.startsWith('ALTER DEFAULT PRIVILEGES')) {
    removedLines++;
    return false;
  }
  
  // Remove CREATE ROLE
  if (trimmed.startsWith('CREATE ROLE ')) {
    removedLines++;
    return false;
  }
  
  // Remove ALTER ROLE
  if (trimmed.startsWith('ALTER ROLE ')) {
    removedLines++;
    return false;
  }
  
  // Remove ALTER ... OWNER TO (if it didn't get caught before)
  if (trimmed.includes(' OWNER TO ')) {
    removedLines++;
    return false;
  }
  
  return true;
});

const cleaned = filtered.join('\n');
const newSize = cleaned.length;
const removed = originalSize - newSize;

fs.writeFileSync(sqlFile, cleaned);

console.log('✅ Cleaned:');
console.log(`   Removed lines: ${removedLines}`);
console.log(`   Removed: ${(removed / 1024).toFixed(1)} KB`);
console.log(`   Original: ${(originalSize / 1024 / 1024).toFixed(2)} MB`);
console.log(`   Now: ${(newSize / 1024 / 1024).toFixed(2)} MB`);
console.log(`\n🚀 Ready to import!`);
