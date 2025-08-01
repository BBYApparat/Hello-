# Script to extract full emote definitions for missing emotes
$workDir = 'C:\Users\alexi\GitHub\Hello-\resources\[plugins]\cylex_animmenu'
$rpFile = Join-Path $workDir 'rpemotes-reborn-master\client\AnimationList.lua'
$missingEmotesFile = Join-Path $workDir 'missing_emotes_list.txt'
$outputFile = Join-Path $workDir 'missing_emotes_formatted.lua'

# Read the missing emotes list
$missingEmotes = Get-Content $missingEmotesFile

# Read all lines from RP file
$rpLines = Get-Content $rpFile

Write-Host "Processing $($missingEmotes.Count) missing emotes..."

# Create output file
$output = @()
$output += "-- Missing emotes from RP.Emotes to add to DP.Emotes"
$output += "-- Total missing emotes: $($missingEmotes.Count)"
$output += ""

$processedCount = 0
$emoteDefinitions = @{}

# First pass: collect all emote definitions
$i = 0
while ($i -lt $rpLines.Count) {
    $line = $rpLines[$i]
    
    # Check if this is an emote definition line
    if ($line -match '^\s*\["([^"]+)"\]\s*=\s*\{') {
        $emoteName = $matches[1]
        $emoteLines = @()
        $emoteLines += $line
        
        # Read until we find the closing brace
        $braceCount = 1
        $i++
        
        while ($i -lt $rpLines.Count -and $braceCount -gt 0) {
            $currentLine = $rpLines[$i]
            $emoteLines += $currentLine
            
            # Count braces to find the end of this emote definition
            $openBraces = ($currentLine -split '\{').Count - 1
            $closeBraces = ($currentLine -split '\}').Count - 1
            $braceCount += $openBraces - $closeBraces
            
            if ($braceCount -eq 0) {
                break
            }
            $i++
        }
        
        $emoteDefinitions[$emoteName] = $emoteLines
    }
    $i++
}

Write-Host "Collected $($emoteDefinitions.Count) emote definitions"

# Second pass: extract missing emotes and convert to DP format
foreach ($emoteName in $missingEmotes) {
    if ($emoteDefinitions.ContainsKey($emoteName)) {
        $rpDefinition = $emoteDefinitions[$emoteName]
        
        # Convert RP format to DP format
        $dpDefinition = @()
        
        foreach ($line in $rpDefinition) {
            $dpLine = $line
            
            # Convert AnimationOptions format
            $dpLine = $dpLine -replace 'AnimationOptions\s*=', 'AnimationOptions ='
            
            # Convert onFootFlag to standard format  
            $dpLine = $dpLine -replace 'onFootFlag\s*=\s*AnimFlag\.LOOP', 'EmoteLoop = true'
            $dpLine = $dpLine -replace 'onFootFlag\s*=\s*AnimFlag\.MOVING', 'EmoteMoving = true'
            
            # Convert other RP-specific syntax to DP format
            $dpLine = $dpLine -replace 'EmoteDuration\s*=', 'EmoteDuration ='
            $dpLine = $dpLine -replace 'StartDelay\s*=', 'StartDelay ='
            $dpLine = $dpLine -replace 'ExitEmote\s*=', 'ExitEmote ='
            
            $dpDefinition += $dpLine
        }
        
        $output += $dpDefinition
        $output += ""
        $processedCount++
        
        if ($processedCount % 50 -eq 0) {
            Write-Host "Processed $processedCount emotes..."
        }
    } else {
        Write-Host "Warning: Could not find definition for emote: $emoteName"
    }
}

# Write output file
$output | Out-File -FilePath $outputFile -Encoding UTF8 -Force

Write-Host "Completed! Processed $processedCount missing emotes"
Write-Host "Output written to: $outputFile"