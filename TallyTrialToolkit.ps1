Clear-Host

function Show-Menu {
    Write-Host "`n🔷 Tally ToolX — Ultra-Fast Trial Toolkit" -ForegroundColor Cyan
    Write-Host "-------------------------------------------"
    Write-Host "1️⃣  Save Trial Snapshot"
    Write-Host "2️⃣  Restore Trial Snapshot"
    Write-Host "3️⃣  Block Internet Access"
    Write-Host "4️⃣  Unblock Internet Access"
    Write-Host "5️⃣  Exit`n"
}

function Save-Snapshot {
    $tallyPath = "C:\Program Files\TallyPrime"
    if (-Not (Test-Path $tallyPath)) {
        Write-Host "❌ Tally folder not found at $tallyPath" -ForegroundColor Red
        return
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $snapshotName = "TallySnapshot_$timestamp"
    $zipPath = "$env:USERPROFILE\Documents\$snapshotName.zip"

    $tempDir = "$env:TEMP\$snapshotName"
    Copy-Item $tallyPath -Destination "$tempDir\TallyFiles" -Recurse -Force

    Compress-Archive -Path "$tempDir\TallyFiles" -DestinationPath $zipPath -Force
    Remove-Item $tempDir -Recurse -Force

    Write-Host "`n✅ Snapshot saved: $zipPath" -ForegroundColor Green
}

function Restore-Snapshot {
    $snapshots = Get-ChildItem "$env:USERPROFILE\Documents" -Filter "TallySnapshot_*.zip" | Sort-Object LastWriteTime -Descending
    if (-Not $snapshots) {
        Write-Host "❌ No snapshot found in Documents." -ForegroundColor Red
        return
    }

    $latestZip = $snapshots[0].FullName
    $extractPath = "$env:TEMP\TallyRestore"
    if (Test-Path $extractPath) { Remove-Item $extractPath -Recurse -Force }

    Expand-Archive -Path $latestZip -DestinationPath $extractPath -Force
    Copy-Item "$extractPath\TallyFiles\*" "C:\Program Files\TallyPrime" -Recurse -Force

    Write-Host "`n♻️ Snapshot restored from: $latestZip" -ForegroundColor Yellow
}

function Block-TallyInternet {
    $exePath = "C:\Program Files\TallyPrime\tally.exe"
    if (Test-Path $exePath) {
        New-NetFirewallRule -DisplayName "Block-TallyInternet" -Direction Outbound -Program $exePath -Action Block -ErrorAction SilentlyContinue
        Write-Host "🔒 Internet Access Blocked for Tally." -ForegroundColor Red
    } else {
        Write-Host "❌ tally.exe not found at $exePath" -ForegroundColor Red
    }
}

function Unblock-TallyInternet {
    Remove-NetFirewallRule -DisplayName "Block-TallyInternet" -ErrorAction SilentlyContinue
    Write-Host "🔓 Internet Access Unblocked for Tally." -ForegroundColor Green
}

do {
    Show-Menu
    $choice = Read-Host "Enter your choice [1-5]"

    switch ($choice) {
        '1' { Save-Snapshot }
        '2' { Restore-Snapshot }
        '3' { Block-TallyInternet }
        '4' { Unblock-TallyInternet }
        '5' { Write-Host "`n👋 Exiting..."; break }
        default { Write-Host "❌ Invalid choice. Please select 1-5." -ForegroundColor Red }
    }
} while ($true)
