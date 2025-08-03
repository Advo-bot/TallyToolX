Clear-Host
Write-Host "🔷 Tally Trial Toolkit 🔷" -ForegroundColor Cyan
Write-Host "-----------------------------------"
Write-Host "1️⃣  Save Current Trial Snapshot"
Write-Host "2️⃣  Restore Trial Snapshot"
Write-Host "3️⃣  Block Tally Internet Access"
Write-Host "4️⃣  Check Trial Status"
Write-Host "5️⃣  Exit"
$choice = Read-Host "`nEnter Your Choice [1-5]"

$base = "https://raw.githubusercontent.com/<your-github-username>/TallyTrialToolkit/main"

switch ($choice) {
    "1" { iex (irm "$base/SaveSnapshot.ps1") }
    "2" { iex (irm "$base/RestoreSnapshot.ps1") }
    "3" { iex (irm "$base/BlockTallyFirewall.ps1") }
    "4" { iex (irm "$base/TrialStatusCheck.ps1") }
    default { Write-Host "`n❌ Invalid choice or Exit" -ForegroundColor Red }
}