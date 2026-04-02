import { Client } from 'pg';

const connectionString = 'postgresql://postgres:Alzaidy%23123@db.tncbykfklynsnnyjajgf.supabase.co:5432/postgres';

async function testConnection() {
  const client = new Client({
    connectionString: connectionString,
    ssl: { rejectUnauthorized: false }
  });

  try {
    console.log('🔗 Testing connection to RUYAX...');
    console.log(`   Host: db.tncbykfklynsnnyjajgf.supabase.co`);
    console.log(`   Port: 5432`);
    console.log(`   Database: postgres\n`);
    
    await client.connect();
    console.log('✅ Connection SUCCESSFUL!\n');

    // Test with a simple query
    const result = await client.query('SELECT version();');
    console.log('📊 Server info:');
    console.log(`   ${result.rows[0].version}\n`);

    await client.end();
    console.log('🔌 Disconnected');

  } catch (error) {
    console.error('❌ Connection FAILED');
    console.error(`   Error: ${error.message}\n`);
    process.exit(1);
  }
}

testConnection();
