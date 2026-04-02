#!/usr/bin/env node

/**
 * Migrate Edge Functions from AQURA to RUYAX
 * Copies 13 TypeScript edge function files
 */

const fs = require('fs');
const path = require('path');

// Edge functions to migrate (from AQURA)
const EDGE_FUNCTIONS = [
  '01_analyze-attendance.ts',
  '02_auto-sync-erp.ts',
  '03_get-contact-bills.ts',
  '04_hello.ts',
  '05_main.ts',
  '06_process-fingerprints.ts',
  '07_send-push-notification.ts',
  '08_send-whatsapp.ts',
  '09_whatsapp-manage.ts',
  '10_whatsapp-webhook.ts',
  'analyze-attendance-index.ts',
  'auto-sync-erp-index.ts',
  'get-contact-bills-index.ts'
];

const AQURA_DIR = path.join(__dirname, '../../Aqura/migrations/edge_functions');
const RUYAX_DIR = path.join(__dirname, '../edge_functions');

// Ensure destination directory exists
if (!fs.existsSync(RUYAX_DIR)) {
  fs.mkdirSync(RUYAX_DIR, { recursive: true });
  console.log(`✅ Created directory: ${RUYAX_DIR}`);
}

async function migrateEdgeFunctions() {
  console.log('⚡ Migrating Edge Functions...\n');
  
  let successful = 0;
  let failed = 0;
  let skipped = 0;

  for (const funcName of EDGE_FUNCTIONS) {
    const sourcePath = path.join(AQURA_DIR, funcName);
    const destPath = path.join(RUYAX_DIR, funcName);

    try {
      if (!fs.existsSync(sourcePath)) {
        console.log(`⏭️  ${funcName} - Not found in AQURA`);
        skipped++;
        continue;
      }

      if (fs.existsSync(destPath)) {
        console.log(`⏭️  ${funcName} - Already exists in RUYAX`);
        skipped++;
        continue;
      }

      // Copy file
      fs.copyFileSync(sourcePath, destPath);
      const stats = fs.statSync(destPath);
      
      console.log(`✅ ${funcName} - Copied (${Math.round(stats.size / 1024)} KB)`);
      successful++;

    } catch (err) {
      console.log(`❌ ${funcName} - ${err.message}`);
      failed++;
    }
  }

  console.log('\n📊 Summary:');
  console.log(`   ✅ Copied: ${successful}`);
  console.log(`   ⏭️  Skipped: ${skipped}`);
  console.log(`   ❌ Failed: ${failed}`);
  console.log(`   Total: ${EDGE_FUNCTIONS.length}`);

  if (successful > 0) {
    console.log(`\n📂 Edge functions copied to: ${RUYAX_DIR}`);
    console.log('⚠️  Note: Deploy these to Supabase using: supabase functions deploy');
  }
}

console.log('🚀 Edge Functions Migration\n');
migrateEdgeFunctions().then(() => {
  process.exit(0);
}).catch(err => {
  console.error('❌ Migration failed:', err);
  process.exit(1);
});
