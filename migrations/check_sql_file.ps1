Write-Host "Testing if we can dump from Aqura and pipe to RUYAX via local file..." -ForegroundColor Cyan

# Since we already have ruyax_aqura_tables.sql locally, let's verify it's properly cleaned
$sqlFile = "c:\Users\mkyou\RUYAX\migrations\ruyax_aqura_tables.sql"

if (Test-Path $sqlFile) {
    $fileSize = (Get-Item $sqlFile).Length / 1MB
    Write-Host "✅ SQL file exists: $fileSize MB" -ForegroundColor Green
    Write-Host "`n📋 File contents sample (first 50 lines):" -ForegroundColor Cyan
    Get-Content $sqlFile -Head 50 | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "❌ SQL file not found!" -ForegroundColor Red
}
