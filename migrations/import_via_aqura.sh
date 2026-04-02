#!/bin/bash

# Copy SQL file to Aqura server
echo "📤 Copying SQL to Aqura server..."
scp /c/Users/mkyou/RUYAX/migrations/ruyax_aqura_tables.sql root@8.213.42.21:/tmp/

echo "📋 File copied. Now running psql from Aqura server..."

# SSH into Aqura and run psql to import to Ruyax
ssh root@8.213.42.21 << 'EOF'
echo "🔗 Testing connection from Aqura to RUYAX..."
psql -h db.tncbykfklynsnnyjajgf.supabase.co -p 5432 -d postgres -U postgres -c "SELECT version();" << PASS
Alzaidy#123
PASS

if [ $? -eq 0 ]; then
  echo "✅ Connection successful! Starting import..."
  psql -h db.tncbykfklynsnnyjajgf.supabase.co -p 5432 -d postgres -U postgres -f /tmp/ruyax_aqura_tables.sql << PASS
Alzaidy#123
PASS
  
  echo "✅ Import complete!"
else
  echo "❌ Connection failed from Aqura server"
fi
EOF
