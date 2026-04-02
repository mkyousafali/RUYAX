import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';

const files = [
  '01_sets.sql',
  '02_schemas.sql',
  '03_types.sql',
  '04_tables.sql',
  '05_sequences.sql',
  '06_indexes.sql',
  '07_foreign_keys.sql',
  '08_triggers.sql',
  '09_functions.sql',
  '10_comments.sql',
  '11_acl.sql',
  '12_other.sql'
];

const sqlDir = './sql_final_v2';

console.log('🚀 Starting sequential SQL import via Supabase CLI\n');

let successCount = 0;
let failCount = 0;

files.forEach((file, index) => {
  const num = index + 1;
  const filePath = path.join(sqlDir, file);
  
  if (!fs.existsSync(filePath)) {
    console.log(`⏭️  [${num}/12] ${file} - FILE NOT FOUND, skipping`);
    return;
  }

  const fileSize = (fs.statSync(filePath).size / 1024).toFixed(1);
  console.log(`📝 [${num}/12] ${file} (${fileSize}KB)`);

  try {
    const result = execSync(`npx supabase db push --file-path "${filePath}"`, {
      cwd: process.cwd(),
      encoding: 'utf8',
      stdio: 'pipe'
    });
    
    console.log(`    ✅ Success\n`);
    successCount++;
  } catch (error) {
    console.log(`    ❌ Error: ${error.message.split('\n')[0]}\n`);
    failCount++;
  }
});

console.log('\n📊 Summary:');
console.log(`   ✅ Successful: ${successCount}/${files.length}`);
console.log(`   ❌ Failed: ${failCount}/${files.length}`);

if (successCount === files.length) {
  console.log('\n🎉 ALL FILES IMPORTED SUCCESSFULLY!');
} else {
  console.log('\n⚠️  Some files failed - check errors above');
}
