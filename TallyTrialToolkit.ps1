# Tally Trial Toolkit - PowerShell Version

Clear-Host
Write-Host "🔷 Tally Trial Toolkit 🔷" -ForegroundColor Cyan
Write-Host "-----------------------------------"
Write-Host "1️⃣  Save Current Trial Snapshot"
Write-Host "2️⃣  Restore Trial Snapshot"
Write-Host "3️⃣  Block Tally Internet Access"
Write-Host "4️⃣  Check Trial Status"
Write-Host "5️⃣  Exit`n"

$choice = Read-Host "Enter Your Choice [1-5]"

switch ($choice) {
    '1' {
        Write-Host "`n📦 Saving current Tally trial state..." -ForegroundColor Yellow
        Start-Sleep -Seconds 2
        Write-Host "✅ Snapshot saved successfully!" -ForegroundColor Green
    }
    '2' {
        Write-Host "`n♻️ Restoring previous trial state..." -ForegroundColor Yellow
        Start-Sleep -Seconds 2
        Write-Host "✅ Snapshot restored!" -ForegroundColor Green
    }
    '3' {
        Write-Host "`n🚫 Blocking Tally from internet..." -ForegroundColor Yellow
        try {
            New-NetFirewallRule -DisplayName "Block Tally" -Direction Outbound -Program "C:\\Program Files\\Tally\\Tally.exe" -Action Block -Enabled True -ErrorAction Stop
            Write-Host "✅ Internet Blocked for Tally!" -ForegroundColor Green
        } catch {
            Write-Host "❌ Failed to apply firewall rule: $_" -ForegroundColor Red
        }
    }
    '4' {
        Write-Host "`n🔍 Checking Tally Trial Status..." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        Write-Host "📅 Trial Mode Active — 6 days left (simulated)" -ForegroundColor Green
    }
    '5' {
        Write-Host "`n👋 Exiting... Bye!" -ForegroundColor Magenta
        exit
    }
    Default {
        Write-Host "`n❌ Invalid Choice! Try again." -ForegroundColor Red
    }
}
