Write-Host "📤 Copying SQL file to Aqura server..." -ForegroundColor Cyan

$sqlFile = "c:\Users\mkyou\RUYAX\migrations\ruyax_aqura_tables.sql"
$remoteFile = "/tmp/ruyax_aqura_tables.sql"

# Copy file to Aqura
scp -r $sqlFile "root@8.213.42.21:$remoteFile"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to copy file to Aqura" -ForegroundColor Red
    exit 1
}

Write-Host "✅ File copied to Aqura server" -ForegroundColor Green
Write-Host "`n🔗 Testing connection from Aqura to RUYAX..." -ForegroundColor Cyan

# Test connection from Aqura server
ssh root@8.213.42.21 "export PGPASSWORD='Alzaidy#123' && psql -h db.tncbykfklynsnnyjajgf.supabase.co -p 5432 -d postgres -U postgres -c 'SELECT version();'"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Cannot connect from Aqura to RUYAX" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Connection from Aqura to RUYAX works!" -ForegroundColor Green
Write-Host "`n🚀 Starting import (this may take a few minutes)..." -ForegroundColor Cyan
Write-Host "   Importing 1.8MB SQL file with 7800+ statements`n" -ForegroundColor Gray

# Import the SQL file from Aqura server to RUYAX
ssh root@8.213.42.21 "export PGPASSWORD='Alzaidy#123' && psql -h db.tncbykfklynsnnyjajgf.supabase.co -p 5432 -d postgres -U postgres -f $remoteFile"

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n❌ Import failed" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ IMPORT SUCCESSFUL!" -ForegroundColor Green
Write-Host "`nCleaning up temporary files..." -ForegroundColor Cyan
ssh root@8.213.42.21 "rm -f $remoteFile"
Write-Host "✅ Done!" -ForegroundColor Green
