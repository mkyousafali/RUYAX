Write-Host "Starting sequential SQL import via Supabase CLI" -ForegroundColor Cyan
Write-Host "Each file will be imported to the linked RUYAX project`n" -ForegroundColor Gray

$files = @(
  "01_sets.sql",
  "02_schemas.sql",
  "03_types.sql",
  "04_tables.sql",
  "05_sequences.sql",
  "06_indexes.sql",
  "07_foreign_keys.sql",
  "08_triggers.sql",
  "09_functions.sql",
  "10_comments.sql",
  "11_acl.sql",
  "12_other.sql"
)

$sqlDir = "$PSScriptRoot\sql_final_v2"
$success = 0
$failed = 0

for ($i = 0; $i -lt $files.Count; $i++) {
  $file = $files[$i]
  $num = $i + 1
  $total = $files.Count
  
  $filePath = Join-Path $sqlDir $file
  $filePath = (Resolve-Path $filePath).Path
  
  if (-not (Test-Path $filePath)) {
    Write-Host "[ $num/$total ] $file - NOT FOUND" -ForegroundColor Yellow
    continue
  }
  
  $fileSize = [math]::Round((Get-Item $filePath).Length / 1KB, 1)
  Write-Host "[ $num/$total ] $file ($fileSize KB)" -ForegroundColor Cyan
  
  try {
    & npx supabase db query -f "$filePath" --linked -o json 2> $null | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
      Write-Host "         SUCCESS`n" -ForegroundColor Green
      $success++
    } else {
      Write-Host "         FAILED`n" -ForegroundColor Red
      $failed++
    }
  } catch {
    Write-Host "         ERROR: $_`n" -ForegroundColor Red
    $failed++
  }
}

Write-Host "`nSummary:" -ForegroundColor Cyan
Write-Host "   Successful: $success/$($files.Count)"
Write-Host "   Failed: $failed/$($files.Count)"

if ($failed -eq 0) {
  Write-Host "`nALL FILES IMPORTED SUCCESSFULLY!" -ForegroundColor Green
  exit 0
} else {
  Write-Host "`nSome files failed - check errors above" -ForegroundColor Yellow
  exit 1
}
