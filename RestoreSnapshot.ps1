$bk = "$PSScriptRoot\Backup"
reg import "$bk\Tally.reg"
robocopy "$bk\TallyPrime" "C:\Program Files\TallyPrime" /MIR > $null
robocopy "$bk\AppDataTally" "$env:APPDATA\Tally" /MIR > $null
robocopy "$bk\ProgramDataTally" "C:\ProgramData\Tally" /MIR > $null
Write-Host "✅ Snapshot Restored. Restart System before using Tally." -ForegroundColor Yellow