import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const sqlFile = path.join(__dirname, 'ruyax_aqura_tables.sql');
console.log(`📖 Reading: ${path.basename(sqlFile)}\n`);

let content = fs.readFileSync(sqlFile, 'utf8');
let originalSize = content.length;

// Fix CREATE VIEW IF NOT EXISTS -> DROP VIEW IF EXISTS; CREATE VIEW
content = content.replace(
  /CREATE VIEW IF NOT EXISTS (.+?) AS\n/g,
  'DROP VIEW IF EXISTS $1 CASCADE;\nCREATE VIEW $1 AS\n'
);

// Remove all "Owner: ..." comments
content = content.split('\n').filter(line => !line.trim().startsWith('Owner:')).join('\n');

// Remove all "ALTER ... OWNER" statements
content = content.replace(/ALTER\s+\w+\s+.+?\s+OWNER\s+TO\s+.+?;/g, '');

// Remove all SET ROLE statements
content = content.replace(/SET ROLE\s+.+?;/g, '');
content = content.replace(/RESET ROLE;/g, '');

// Remove all "-- Owner: " lines
content = content.split('\n').filter(line => !line.trim().startsWith('-- Owner:')).join('\n');

const newSize = content.length;
const removed = originalSize - newSize;

fs.writeFileSync(sqlFile, content);

console.log('✅ Cleaning Complete:');
console.log(`   Removed: ${(removed / 1024).toFixed(1)} KB`);
console.log(`   Original: ${(originalSize / 1024 / 1024).toFixed(2)} MB`);
console.log(`   Now: ${(newSize / 1024 / 1024).toFixed(2)} MB`);
console.log(`\n🚀 Ready to import!`);
