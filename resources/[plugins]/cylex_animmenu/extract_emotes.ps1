$workDir = 'C:\Users\alexi\GitHub\Hello-\resources\[plugins]\cylex_animmenu'
$rpFile = Join-Path $workDir 'rpemotes-reborn-master\client\AnimationList.lua'
$dpFile = Join-Path $workDir 'animations\merge\AnimationList.lua'

# Extract RP emotes
$rpLines = Get-Content $rpFile
$rpEmotes = @()
for ($i = 5053; $i -lt 10523 -and $i -lt $rpLines.Count; $i++) {
    if ($rpLines[$i] -match '^\s*\["([^"]+)"\]\s*=') {
        $rpEmotes += $matches[1]
    }
}

# Extract DP emotes  
$dpLines = Get-Content $dpFile
$dpEmotes = @()
for ($i = 6595; $i -lt 10070 -and $i -lt $dpLines.Count; $i++) {
    if ($dpLines[$i] -match '^\s*\["([^"]+)"\]\s*=') {
        $dpEmotes += $matches[1]
    }
}

# Find missing emotes
$missing = $rpEmotes | Where-Object { $_ -notin $dpEmotes }
Write-Host "Total RP emotes: $($rpEmotes.Count)"
Write-Host "Total DP emotes: $($dpEmotes.Count)"
Write-Host "Missing emotes: $($missing.Count)"

# Output files
$missing | Out-File -FilePath (Join-Path $workDir 'missing_emotes.txt') -Force
$rpEmotes | Out-File -FilePath (Join-Path $workDir 'rp_emotes.txt') -Force  
$dpEmotes | Out-File -FilePath (Join-Path $workDir 'dp_emotes.txt') -Force

Write-Host "Files created: missing_emotes.txt, rp_emotes.txt, dp_emotes.txt"