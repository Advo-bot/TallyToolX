$exe = "C:\Program Files\TallyPrime\tally.exe"
New-NetFirewallRule -DisplayName "Block Tally Internet" -Direction Outbound -Program $exe -Action Block -Profile Any
Write-Host "🚫 Tally Internet Access Blocked!" -ForegroundColor Red