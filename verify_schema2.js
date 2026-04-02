#!/usr/bin/env node
/**
 * Verify schema using PostgreSQL system functions
 */

import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function verifySchema() {
  try {
    console.log('🔍 Verifying RUYAX schema...\n');

    // Use SQL query via RPC or direct execution
    const { data, error } = await supabase.rpc('exec', {
      query: `SELECT COUNT(*) as table_count FROM information_schema.tables 
              WHERE table_schema = 'public' AND table_type = 'BASE TABLE';`
    }).catch(() => ({ data: null, error: 'RPC not available' }));

    if (data) {
      console.log(`✅ Tables found: ${data[0]?.table_count || 0}`);
    } else {
      // Try alternative: check if specific known table exists
      console.log('Checking if schema tables exist...\n');
      
      // Try to select from a table that should exist if schema was imported
      const { data: testData, error: testError } = await supabase
        .from('public.users')
        .select('count', { count: 'exact', head: true })
        .catch(() => ({ data: null, error: 'Table not found' }));

      if (testError && testError.message?.includes('not found')) {
        console.log('⚠️  Tables not yet created or query method incompatible\n');
        console.log('Please check Supabase Dashboard:');
        console.log('👉 https://app.supabase.com/project/tncbykfklynsnnyjajgf/editor\n');
      } else if (testData !== null) {
        console.log('✅ Schema appears to be imported successfully!');
      }
    }

  } catch (error) {
    console.log('⚠️  Cannot verify with REST API, check dashboard instead');
    console.log('URL: https://app.supabase.com/project/tncbykfklynsnnyjajgf/editor');
  }
}

verifySchema();
