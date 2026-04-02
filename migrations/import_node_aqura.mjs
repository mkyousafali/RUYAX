import { Client } from 'pg';
import fs from 'fs';

async function importToRuyax() {
  const client = new Client({
    host: 'db.tncbykfklynsnnyjajgf.supabase.co',
    port: 5432,
    database: 'postgres',
    user: 'postgres',
    password: 'Alzaidy#123',
    ssl: { rejectUnauthorized: false },
    connectionTimeoutMillis: 30000
  });

  try {
    console.log('🔗 Connecting to RUYAX from Aqura server...\n');
    await client.connect();
    console.log('✅ Connected!\n');

    // Read SQL file content
    const sqlContent = fs.readFileSync('/tmp/ruyax_aqura_tables.sql', 'utf8');
    const stmts = sqlContent.split(';').map(s => s.trim()).filter(s => s.length > 0);
    
    console.log(`📊 Executing ${stmts.length} statements...\n`);
    
    let success = 0, failed = 0;
    const errors = [];

    for (let i = 0; i < stmts.length; i++) {
      if ((i + 1) % 100 === 0) {
        console.log(`Progress: ${i + 1}/${stmts.length}`);
      }
      
      try {
        await client.query(stmts[i]);
        success++;
      } catch (e) {
        failed++;
        if (failed <= 5) errors.push({ num: i + 1, msg: e.message });
      }
    }

    console.log(`\n✅ Complete: ${success} passed, ${failed} failed`);
    if (errors.length > 0) {
      console.log('\n❌ First errors:');
      errors.forEach(e => console.log(`   [${e.num}] ${e.msg}`));
    }

    await client.end();
  } catch (error) {
    console.error('❌ Fatal:', error.message);
    process.exit(1);
  }
}

importToRuyax();
