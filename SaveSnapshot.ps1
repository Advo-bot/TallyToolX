$bk = "$PSScriptRoot\Backup"
New-Item -ItemType Directory -Force -Path $bk | Out-Null
reg export "HKLM\SOFTWARE\Tally" "$bk\Tally.reg" /y
robocopy "C:\Program Files\TallyPrime" "$bk\TallyPrime" /MIR > $null
robocopy "$env:APPDATA\Tally" "$bk\AppDataTally" /MIR > $null
robocopy "C:\ProgramData\Tally" "$bk\ProgramDataTally" /MIR > $null
Write-Host "✅ Snapshot Saved in $bk" -ForegroundColor Green