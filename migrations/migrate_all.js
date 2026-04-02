import { createClient } from '@supabase/supabase-js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load .env file
const envPath = path.join(__dirname, '..', '.env');
const envContent = fs.readFileSync(envPath, 'utf8');
const envVars = {};
envContent.split('\n').forEach(line => {
  if (line && !line.startsWith('#')) {
    const [key, value] = line.split('=');
    if (key && value) {
      envVars[key.trim()] = value.trim();
    }
  }
});

// Get values from env file or environment
const SUPABASE_URL = envVars.VITE_SUPABASE_URL || process.env.VITE_SUPABASE_URL || 'https://tncbykfklynsnnyjajgf.supabase.co';
const SERVICE_ROLE_KEY = envVars.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SERVICE_ROLE_KEY) {
  console.error('❌ SUPABASE_SERVICE_ROLE_KEY not found in environment');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

// Storage buckets from AQURA
const BUCKETS = [
  'app-icons',
  'asset-invoices',
  'category-images',
  'clearance-certificates',
  'completion-photos',
  'coupon-product-images',
  'customer-app-media',
  'custom-fonts',
  'documents',
  'employee-documents',
  'expense-scheduler-bills',
  'flyer-product-images',
  'flyer-templates',
  'frontend-builds',
  'notification-images',
  'offer-pdfs',
  'original-bills',
  'pos-before',
  'pr-excel-files',
  'product-images',
  'product-request-photos',
  'purchase-voucher-receipts',
  'quick-task-files',
  'requisition-images',
  'shelf-paper-templates',
  'stock-documents',
  'task-images',
  'user-avatars',
  'vendor-contracts',
  'warning-documents',
  'whatsapp-media'
];

async function createStorageBuckets() {
  console.log('🔄 Creating storage buckets in RUYAX...\n');
  
  let created = 0;
  let skipped = 0;
  let failed = 0;
  
  for (const bucketName of BUCKETS) {
    try {
      // Check if bucket exists
      const { data: existingBuckets } = await supabase.storage.listBuckets();
      const exists = existingBuckets.some(b => b.name === bucketName);
      
      if (exists) {
        console.log(`  ⏭️  ${bucketName} - Already exists`);
        skipped++;
        continue;
      }
      
      // Create bucket
      const { data, error } = await supabase.storage.createBucket(bucketName, {
        public: true
      });
      
      if (error) {
        console.log(`  ❌ ${bucketName} - Error: ${error.message}`);
        failed++;
      } else {
        console.log(`  ✅ ${bucketName} - Created`);
        created++;
      }
    } catch (error) {
      console.log(`  ❌ ${bucketName} - Exception: ${error.message}`);
      failed++;
    }
  }
  
  console.log(`\n📊 Storage Summary:`);
  console.log(`   Created: ${created}`);
  console.log(`   Skipped: ${skipped}`);
  console.log(`   Failed: ${failed}`);
  
  return { created, skipped, failed };
}

async function main() {
  console.log('🚀 RUYAX Migration: Storage & Edge Functions\n');
  console.log(`📍 Supabase Project: ${SUPABASE_URL}\n`);
  
  const storageResult = await createStorageBuckets();
  
  console.log('\n✅ Storage buckets migration complete!');
  console.log('\n📝 Next steps:');
  console.log('   1. Edge functions deployment via Supabase CLI');
  console.log('   2. Run: supabase functions deploy');
}

main().catch(error => {
  console.error('Fatal error:', error.message);
  process.exit(1);
});
