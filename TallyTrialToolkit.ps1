Clear-Host

function Show-Menu {
    Write-Host "`n🔷 Tally ToolX — Ultra-Fast Trial Toolkit"
    Write-Host "-------------------------------------------"
    Write-Host "1️⃣  Save Trial Snapshot"
    Write-Host "2️⃣  Restore Trial Snapshot"
    Write-Host "3️⃣  Block Internet Access"
    Write-Host "4️⃣  Exit"
}

function Save-Snapshot {
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $snapshotDir = "$env:USERPROFILE\Documents\TallySnapshot_$timestamp"
    $tallyPath = "C:\Program Files\TallyPrime"

    if (!(Test-Path $tallyPath)) {
        Write-Host "❌ TallyPrime folder not found at $tallyPath"
        return
    }

    New-Item -ItemType Directory -Force -Path $snapshotDir | Out-Null
    $backupPath = Join-Path $snapshotDir "TallyFiles"
    Copy-Item $tallyPath -Destination $backupPath -Recurse -Force
    $zipFile = "$snapshotDir.zip"
    Compress-Archive -Path $snapshotDir -DestinationPath $zipFile -Force
    Write-Host "`n✅ Snapshot saved: $zipFile"
}

function Restore-Snapshot {
    $zip = Get-ChildItem "$env:USERPROFILE\Documents" -Filter "TallySnapshot_*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($null -eq $zip) {
        Write-Host "❌ No snapshot found to restore."
        return
    }

    $tempPath = "$env:TEMP\TallyToolXRestore"
    if (Test-Path $tempPath) { Remove-Item $tempPath -Recurse -Force }
    Expand-Archive -Path $zip.FullName -DestinationPath $tempPath -Force

    $source = Join-Path $tempPath "TallyFiles"
    $target = "C:\Program Files\TallyPrime"
    if (!(Test-Path $source)) {
        Write-Host "❌ No Tally files found in snapshot."
        return
    }

    Copy-Item $source\* -Destination $target -Recurse -Force
    Write-Host "`n✅ TallyPrime restored from snapshot."
}

function Block-Internet {
    $exe = "C:\Program Files\TallyPrime\Tally.exe"
    $rule = "TallyBlock"
    if (Get-NetFirewallRule -DisplayName $rule -ErrorAction SilentlyContinue) {
        Write-Host "ℹ️ Firewall rule already exists."
    } else {
        New-NetFirewallRule -DisplayName $rule -Direction Outbound -Program $exe -Action Block
        Write-Host "✅ Internet blocked for Tally.exe"
    }
}

# Main Menu Loop
do {
    Show-Menu
    $choice = Read-Host "`nEnter your choice [1-4]"
    switch ($choice) {
        '1' { Save-Snapshot }
        '2' { Restore-Snapshot }
        '3' { Block-Internet }
        '4' { Write-Host "`n👋 Exiting..."; break }
        default { Write-Host "❌ Invalid choice. Try again." }
    }
} while ($true)
