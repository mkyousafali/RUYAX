#!/usr/bin/env node
/**
 * Direct Database-to-Database Schema Migration
 * Migrates schema from Aqura to RUYAX using PostgreSQL connections
 */

import { Client } from 'pg';
import dotenv from 'dotenv';

dotenv.config({ path: './.env' });

// Aqura credentials
const aquraUrl = 'https://supabase.urbanaqura.com';
const aquraAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzY0ODc1NTI3LCJleHAiOjIwODA0NTE1Mjd9.IT_YSPU9oivuGveKfRarwccr59SNMzX_36cw04Lf448';
const aquraServiceKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NjQ4NzU1MjcsImV4cCI6MjA4MDQ1MTUyN30.6mj0wiHW0ljpYNIEeYG-r--577LDNbxCLj7SZOghbv0';

// RUYAX credentials
const ruyaxUrl = process.env.VITE_SUPABASE_URL;
const ruyaxServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!ruyaxUrl || !ruyaxServiceKey) {
  console.error('❌ Missing RUYAX credentials in .env');
  process.exit(1);
}

// Extract DB connection details from Supabase URLs
function getDbConfig(supabaseUrl, serviceKey) {
  // Handle both standard Supabase and custom domain URLs
  let host;
  
  if (supabaseUrl.includes('supabase.co')) {
    // Standard: https://projectid.supabase.co
    const projectId = supabaseUrl.split('.')[0].replace('https://', '');
    host = `db.${projectId}.supabase.co`;
  } else if (supabaseUrl.includes('urbanaqura.com')) {
    // Custom: https://supabase.urbanaqura.com
    host = 'db.urbanaqura.com';
  } else if (supabaseUrl.includes('urbanRuyax.com')) {
    // Custom: https://supabase.urbanRuyax.com
    host = 'db.urbanRuyax.com';
  } else {
    // Generic custom domain
    const domain = supabaseUrl.replace('https://', '').replace('http://', '');
    host = `db.${domain}`;
  }
  
  return {
    host,
    port: 5432,
    database: 'postgres',
    user: 'postgres',
    password: serviceKey,
    ssl: { rejectUnauthorized: false }
  };
}

async function migrateSchema() {
  const aquraConfig = getDbConfig(aquraUrl, aquraServiceKey);
  const ruyaxConfig = getDbConfig(ruyaxUrl, ruyaxServiceKey);

  let aquraConn = null;
  let ruyaxConn = null;

  try {
    console.log('🔗 Connecting to Aqura database...');
    aquraConn = new Client(aquraConfig);
    await aquraConn.connect();
    console.log('✅ Aqura connected');

    console.log('🔗 Connecting to RUYAX database...');
    ruyaxConn = new Client(ruyaxConfig);
    await ruyaxConn.connect();
    console.log('✅ RUYAX connected');

    console.log('\n📊 Getting schema objects from Aqura...');
    
    // Get all schema objects (tables, functions, triggers, etc.)
    const schemaQuery = `
      SELECT
        n.nspname as schema_name,
        c.relname as object_name,
        CASE
          WHEN c.relkind = 'r' THEN 'TABLE'
          WHEN c.relkind = 'i' THEN 'INDEX'
          WHEN c.relkind = 'v' THEN 'VIEW'
          ELSE 'OTHER'
        END as object_type
      FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
      ORDER BY n.nspname, c.relname;
    `;

    const schemaResult = await aquraConn.query(schemaQuery);
    console.log(`📦 Found ${schemaResult.rows.length} schema objects`);

    // Get DDL for all objects
    console.log('\n📝 Extracting DDL from Aqura...');
    const ddlQuery = `
      SELECT
        pg_get_ddl(c.oid) as ddl
      FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
      AND c.relkind IN ('r', 'i', 'v', 'S')
      ORDER BY c.relkind desc, n.nspname, c.relname;
    `;

    const ddlResult = await aquraConn.query(ddlQuery);
    const ddlStatements = ddlResult.rows
      .filter(row => row.ddl)
      .map(row => row.ddl);

    console.log(`✅ Extracted ${ddlStatements.length} DDL statements`);

    // Apply DDL to RUYAX
    console.log('\n⏳ Applying schema to RUYAX...');
    let applied = 0;
    let skipped = 0;

    for (const ddl of ddlStatements) {
      try {
        await ruyaxConn.query(ddl);
        applied++;
        if (applied % 10 === 0) {
          process.stdout.write(`\r  Applied: ${applied}/${ddlStatements.length}`);
        }
      } catch (err) {
        // Skip if object already exists
        if (err.message.includes('already exists')) {
          skipped++;
        } else {
          console.warn(`\n⚠️  Skipped: ${err.message.substring(0, 50)}`);
        }
      }
    }

    console.log(`\n\n✅ Migration Complete!`);
    console.log(`   Applied: ${applied}`);
    console.log(`   Skipped: ${skipped}`);
    console.log(`   Total: ${ddlStatements.length}`);

  } catch (error) {
    console.error('❌ Migration failed:', error.message);
    process.exit(1);
  } finally {
    if (aquraConn) await aquraConn.end();
    if (ruyaxConn) await ruyaxConn.end();
  }
}

migrateSchema();
