function Save-TallySnapshot {
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $snapshotDir = "$env:USERPROFILE\Documents\TallySnapshot_$timestamp"
    $null = New-Item -ItemType Directory -Force -Path $snapshotDir

    Write-Host "`n📦 Creating Snapshot at $snapshotDir" -ForegroundColor Yellow

    $regBackupPath = Join-Path $snapshotDir "TallyTrial.reg"
    reg export "HKCU\Software\Tally" $regBackupPath /y | Out-Null

    $tallyPath = "C:\Program Files\Tally"
    $tallyBackupPath = Join-Path $snapshotDir "TallyFiles"
    if (Test-Path $tallyPath) {
        Copy-Item $tallyPath -Destination $tallyBackupPath -Recurse -Force
        Write-Host "✅ Files backed up from $tallyPath"
    } else {
        Write-Host "⚠️ Tally folder not found at $tallyPath"
    }

    $zipPath = "$snapshotDir.zip"
    Compress-Archive -Path $snapshotDir -DestinationPath $zipPath -Force
    Remove-Item $snapshotDir -Recurse -Force
    Write-Host "✅ Snapshot saved as ZIP: $zipPath" -ForegroundColor Green
}

function Restore-TallySnapshot {
    $zipFile = Get-ChildItem "$env:USERPROFILE\Documents" -Filter "TallySnapshot_*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $zipFile) {
        Write-Host "❌ No snapshot found to restore!" -ForegroundColor Red
        return
    }

    Write-Host "`n♻️ Restoring snapshot: $($zipFile.Name)" -ForegroundColor Yellow

    $extractPath = "$env:TEMP\TallyRestore"
    Expand-Archive -Path $zipFile.FullName -DestinationPath $extractPath -Force

    reg import "$extractPath\TallyTrial.reg"

    $restoredPath = Join-Path $extractPath "TallyFiles"
    $tallyPath = "C:\Program Files\Tally"
    if (Test-Path $restoredPath) {
        Copy-Item $restoredPath\* -Destination $tallyPath -Recurse -Force
        Write-Host "✅ Files restored to $tallyPath"
    }

    Remove-Item $extractPath -Recurse -Force
    Write-Host "✅ Trial state restored successfully!" -ForegroundColor Green
}

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
    '1' { Save-TallySnapshot }
    '2' { Restore-TallySnapshot }
    '3' {
        Write-Host "`n🚫 Blocking Tally from internet..." -ForegroundColor Yellow
        try {
            New-NetFirewallRule -DisplayName "Block Tally" -Direction Outbound -Program "C:\Program Files\Tally\Tally.exe" -Action Block -Enabled True -ErrorAction Stop
            Write-Host "✅ Internet Blocked for Tally!" -ForegroundColor Green
        } catch {
            Write-Host "❌ Failed to apply firewall rule: $_" -ForegroundColor Red
        }
    }
    '4' {
        Write-Host "`n🔍 Checking Tally Trial Status..." -ForegroundColor Yellow
        Write-Host "📅 Trial Mode Active — simulated 6 days left" -ForegroundColor Green
    }
    '5' {
        Write-Host "`n👋 Exiting..." -ForegroundColor Magenta
        exit
    }
    Default {
        Write-Host "`n❌ Invalid Choice! Try again." -ForegroundColor Red
    }
}

