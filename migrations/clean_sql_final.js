import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const sqlDir = path.join(__dirname, 'sql_final_v2');

// Get all SQL files
const files = fs.readdirSync(sqlDir).filter(f => f.endsWith('.sql'));

console.log(`Cleaning ${files.length} SQL files...\n`);

files.forEach(file => {
  const filePath = path.join(sqlDir, file);
  let content = fs.readFileSync(filePath, 'utf8');
  
  // Remove lines that are not SQL
  const lines = content.split('\n');
  const cleanedLines = lines.filter(line => {
    const trimmed = line.trim();
    
    // Skip empty lines
    if (!trimmed) return true;
    
    // Skip valid comment lines (starting with --)
    if (trimmed.startsWith('--')) return true;
    
    // Skip invalid "Owner: ..." lines
    if (trimmed.startsWith('Owner:')) return false;
    
    // Keep everything else
    return true;
  });
  
  const cleaned = cleanedLines.join('\n');
  fs.writeFileSync(filePath, cleaned);
  
  const originalSize = content.length;
  const newSize = cleaned.length;
  const reduced = originalSize - newSize;
  
  console.log(`✓ ${file.padEnd(25)} (removed ${reduced} bytes)`);
});

console.log('\n✅ All files cleaned!');
