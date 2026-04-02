Write-Host "Deploying Edge Functions to RUYAX..." -ForegroundColor Cyan
Write-Host "Project: tncbykfklynsnnyjajgf`n" -ForegroundColor Gray

# List of edge functions to deploy
$functions = @(
  "analyze-attendance",
  "auto-sync-erp",
  "get-contact-bills",
  "process-fingerprints",
  "send-push-notification",
  "send-whatsapp",
  "whatsapp-manage",
  "whatsapp-webhook"
)

$deployed = 0
$failed = 0

# Deploy each function
foreach ($func in $functions) {
  Write-Host "[ $($functions.IndexOf($func) + 1)/$($functions.Count) ] $func..."  -ForegroundColor Cyan
  
  try {
    # Deploy using Supabase CLI (no --linked flag, uses default linked project)
    $output = & npx supabase functions deploy $func 2>&1
    
    if ($LASTEXITCODE -eq 0) {
      Write-Host "         SUCCESS" -ForegroundColor Green
      $deployed++
    } else {
      Write-Host "         FAILED" -ForegroundColor Red
      if ($output) {
        Write-Host "         Error: $($output | Select-Object -First 1)" -ForegroundColor Red
      }
      $failed++
    }
  } catch {
    Write-Host "         ERROR: $_" -ForegroundColor Red
    $failed++
  }
}

Write-Host "`nDeployment Summary:" -ForegroundColor Cyan
Write-Host "   Deployed: $deployed/$($functions.Count)"
Write-Host "   Failed: $failed"

if ($failed -eq 0) {
  Write-Host "`nAll edge functions deployed successfully!" -ForegroundColor Green
} else {
  Write-Host "`nSome functions failed to deploy." -ForegroundColor Yellow
}
