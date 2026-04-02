#!/usr/bin/env node
/**
 * Verify RUYAX schema was imported successfully
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
    console.log('🔍 Checking RUYAX database schema...\n');

    // Query information_schema for all tables
    const { data, error } = await supabase
      .from('information_schema.tables')
      .select('table_schema, table_name')
      .neq('table_schema', 'pg_catalog')
      .neq('table_schema', 'information_schema')
      .neq('table_schema', '_analytics')
      .neq('table_schema', '_supavisor')
      .order('table_schema')
      .order('table_name');

    if (error) {
      console.error('❌ Query error:', error.message);
      return;
    }

    if (!data || data.length === 0) {
      console.log('⚠️  No custom tables found');
      return;
    }

    // Group by schema
    const bySchema = {};
    data.forEach(row => {
      if (!bySchema[row.table_schema]) {
        bySchema[row.table_schema] = [];
      }
      bySchema[row.table_schema].push(row.table_name);
    });

    console.log('📊 Tables by Schema:\n');
    
    let totalTables = 0;
    Object.entries(bySchema).forEach(([schema, tables]) => {
      console.log(`📁 ${schema} (${tables.length} tables)`);
      tables.slice(0, 5).forEach(table => {
        console.log(`   ✓ ${table}`);
      });
      if (tables.length > 5) {
        console.log(`   ... and ${tables.length - 5} more`);
      }
      totalTables += tables.length;
    });

    console.log(`\n✅ Total tables: ${totalTables}`);
    console.log('\n🎉 Schema import successful!');

  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

verifySchema();
