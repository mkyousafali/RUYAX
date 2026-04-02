/**
 * Create storage buckets in RUYAX
 * Based on AQURA storage structure (31 buckets)
 */

const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

// List of storage buckets from AQURA
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
  console.log('🪣 Creating storage buckets in RUYAX...\n');
  
  let successful = 0;
  let failed = 0;
  let existing = 0;

  for (const bucketName of BUCKETS) {
    try {
      const { data, error } = await supabase.storage.createBucket(bucketName, {
        public: false // Make buckets private by default
      });

      if (error) {
        if (error.message.includes('already exists')) {
          console.log(`⏭️  ${bucketName} - Already exists`);
          existing++;
        } else {
          console.log(`❌ ${bucketName} - ${error.message}`);
          failed++;
        }
      } else {
        console.log(`✅ ${bucketName} - Created`);
        successful++;
      }
    } catch (err) {
      console.log(`❌ ${bucketName} - ${err.message}`);
      failed++;
    }
  }

  console.log('\n📊 Summary:');
  console.log(`   ✅ Created: ${successful}`);
  console.log(`   ⏭️  Already existed: ${existing}`);
  console.log(`   ❌ Failed: ${failed}`);
  console.log(`   Total: ${BUCKETS.length}`);
}

console.log('🚀 Storage Bucket Migration\n');
createStorageBuckets().then(() => {
  console.log('\n✨ Storage bucket migration complete!');
  process.exit(0);
}).catch(err => {
  console.error('❌ Migration failed:', err);
  process.exit(1);
});
