#!/bin/bash

# Script to create properly formatted emote chunks
INPUT_FILE="C:/Users/alexi/GitHub/Hello-/resources/[plugins]/cylex_animmenu/missing_emotes_definitions.lua"
OUTPUT_DIR="C:/Users/alexi/GitHub/Hello-/resources/[plugins]/cylex_animmenu"

echo "Creating formatted emote chunks..."

# First, let's create a clean version by processing the input file properly
TEMP_FILE="$OUTPUT_DIR/emotes_clean.lua"

# Extract just the emote definitions and clean them up
awk '
BEGIN { 
    in_emote = 0
    brace_count = 0
}
/^\s*\[".*"\]\s*=\s*\{/ {
    in_emote = 1
    brace_count = 1
    # Clean up the line
    line = $0
    gsub(/AnimationOptions\s*=\s*$/, "AnimationOptions = {", line)
    print line
    next
}
in_emote {
    line = $0
    # Count braces
    open_braces = gsub(/\{/, "&", line)
    close_braces = gsub(/\}/, "&", line)
    brace_count += open_braces - close_braces
    
    # Fix common formatting issues
    gsub(/^\s*EmoteLoop = true\s*$/, "            EmoteLoop = true", line)
    gsub(/^\s*EmoteMoving = true,?\s*$/, "            EmoteMoving = true,", line)
    gsub(/^\s*EmoteDuration = ([0-9]+),?\s*$/, "            EmoteDuration = \\1,", line)
    gsub(/^\s*,\s*$/, "        }", line)
    
    print line
    
    if (brace_count <= 0) {
        in_emote = 0
        print ""
    }
}
' "$INPUT_FILE" > "$TEMP_FILE"

# Now split into chunks of 100 emotes each
CHUNK_SIZE=100
emote_count=0
chunk_num=1
current_chunk="$OUTPUT_DIR/missing_emotes_chunk_${chunk_num}.lua"

# Create first chunk header
start_num=1
end_num=$CHUNK_SIZE
cat > "$current_chunk" << EOF
-- Missing Emotes from RPEmotes-Reborn for Cylex AnimMenu
-- Chunk $chunk_num - Emotes $start_num-$end_num
-- Add these to your DP.Emotes section in animations/merge/AnimationList.lua
-- 
-- Instructions:
-- 1. Copy the emote definitions below
-- 2. Paste them into your DP.Emotes = { } section
-- 3. Make sure to add commas between emotes as needed

EOF

# Process the clean file
while IFS= read -r line; do
    # Check if this is a new emote definition
    if [[ "$line" =~ ^\s*\[\".*\"\]\s*=\s*\{ ]]; then
        # Check if we need to start a new chunk
        if [ $emote_count -ge $CHUNK_SIZE ]; then
            chunk_num=$((chunk_num + 1))
            emote_count=0
            current_chunk="$OUTPUT_DIR/missing_emotes_chunk_${chunk_num}.lua"
            
            # Create header for new chunk
            start_num=$(((chunk_num - 1) * CHUNK_SIZE + 1))
            end_num=$((chunk_num * CHUNK_SIZE))
            
            cat > "$current_chunk" << EOF
-- Missing Emotes from RPEmotes-Reborn for Cylex AnimMenu  
-- Chunk $chunk_num - Emotes $start_num-$end_num
-- Add these to your DP.Emotes section in animations/merge/AnimationList.lua
--
-- Instructions:
-- 1. Copy the emote definitions below
-- 2. Paste them into your DP.Emotes = { } section  
-- 3. Make sure to add commas between emotes as needed

EOF
        fi
        emote_count=$((emote_count + 1))
    fi
    
    echo "$line" >> "$current_chunk"
    
done < "$TEMP_FILE"

# Clean up temp file
rm "$TEMP_FILE"

echo "Created $chunk_num chunks with properly formatted emotes"
echo ""
echo "Summary:"
total_emotes=0
for i in $(seq 1 $chunk_num); do
    chunk_file="$OUTPUT_DIR/missing_emotes_chunk_${i}.lua"
    emote_count=$(grep -c '^\s*\[".*"\]\s*=' "$chunk_file" || echo 0)
    echo "  - missing_emotes_chunk_${i}.lua: $emote_count emotes"
    total_emotes=$((total_emotes + emote_count))
done
echo ""
echo "Total emotes processed: $total_emotes"