$path = "$env:APPDATA\Tally\TrialStatus.txt"
if (Test-Path $path) {
    Get-Content $path
} else {
    Write-Host "ℹ️ Could not determine trial status. Please open Tally manually to verify." -ForegroundColor Yellow
}