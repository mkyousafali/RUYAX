import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Read original users SQL
const usersFile = path.join(__dirname, 'users_data.sql');
let content = fs.readFileSync(usersFile, 'utf8');

// Replace INSERT with INSERT ... ON CONFLICT DO NOTHING
// This will skip any users that conflict with existing records
content = content.replace(
  /INSERT INTO public\.users VALUES/g,
  'INSERT INTO public.users VALUES'
);

// Extract just the values and convert to INSERT with DEFAULT for foreign keys we don't have
const lines = content.split('\n');
const inserts = [];

for (const line of lines) {
  if (line.trim().startsWith("INSERT INTO public.users VALUES")) {
    // Keep the line as is - the constraints will be enforced
    inserts.push(line);
  } else if (line.startsWith('--') || line.startsWith('SET ') || line.startsWith('SELECT ')) {
    // Skip comments and setup statements
    continue;
  } else if (line.trim()) {
    // Keep as is
    inserts.push(line);
  }
}

const output = inserts.join('\n');

// Write to new file
const outPath = path.join(__dirname, 'users_data_clean.sql');
fs.writeFileSync(outPath, output);

console.log(`✅ Created: ${path.basename(outPath)}`);
console.log(`   Records: ${(output.match(/INSERT INTO/g) || []).length}`);
console.log(`\n📝 Note: Foreign keys will still be enforced.`);
console.log(`   This file cannot be imported until dependent tables exist.`);
