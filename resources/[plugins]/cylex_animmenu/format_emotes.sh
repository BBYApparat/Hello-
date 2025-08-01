#!/bin/bash

# Script to clean up and format the extracted emotes
INPUT_FILE="C:/Users/alexi/GitHub/Hello-/resources/[plugins]/cylex_animmenu/missing_emotes_definitions.lua"
OUTPUT_DIR="C:/Users/alexi/GitHub/Hello-/resources/[plugins]/cylex_animmenu"

echo "Cleaning up emote formatting..."

# Create a temporary clean file
TEMP_FILE="$OUTPUT_DIR/emotes_temp.lua"

# Clean up the formatting issues
sed 's/AnimationOptions = /AnimationOptions = {/g' "$INPUT_FILE" |
sed 's/EmoteLoop = true}/EmoteLoop = true/g' |
sed 's/EmoteMoving = true}/EmoteMoving = true/g' |
sed 's/        }/        }/g' |
sed 's/    ,/    },/g' > "$TEMP_FILE"

# Now let's create properly formatted chunks
CHUNK_SIZE=100
CHUNK_NUM=1
EMOTE_COUNT=0
CURRENT_CHUNK="$OUTPUT_DIR/missing_emotes_chunk_${CHUNK_NUM}.lua"

# Create header for first chunk
cat > "$CURRENT_CHUNK" << 'EOF'
-- Missing Emotes from RPEmotes-Reborn for Cylex AnimMenu
-- Chunk 1 - Emotes 1-100
-- Add these to your DP.Emotes section in animations/merge/AnimationList.lua

EOF

# Process the cleaned file
while IFS= read -r line; do
    # Skip the header lines
    if [[ "$line" =~ ^-- ]]; then
        continue
    fi
    
    # If we find an emote definition start
    if [[ "$line" =~ ^\s*\[\".*\"\]\s*=\s*\{ ]]; then
        # Check if we need to start a new chunk
        if [ $EMOTE_COUNT -ge $CHUNK_SIZE ]; then
            CHUNK_NUM=$((CHUNK_NUM + 1))
            EMOTE_COUNT=0
            CURRENT_CHUNK="$OUTPUT_DIR/missing_emotes_chunk_${CHUNK_NUM}.lua"
            
            # Create header for new chunk
            START_NUM=$(((CHUNK_NUM - 1) * CHUNK_SIZE + 1))
            END_NUM=$((CHUNK_NUM * CHUNK_SIZE))
            
            cat > "$CURRENT_CHUNK" << EOF
-- Missing Emotes from RPEmotes-Reborn for Cylex AnimMenu
-- Chunk $CHUNK_NUM - Emotes $START_NUM-$END_NUM
-- Add these to your DP.Emotes section in animations/merge/AnimationList.lua

EOF
        fi
        EMOTE_COUNT=$((EMOTE_COUNT + 1))
    fi
    
    echo "$line" >> "$CURRENT_CHUNK"
    
done < "$TEMP_FILE"

# Clean up temp file
rm "$TEMP_FILE"

echo "Created $CHUNK_NUM chunks with properly formatted emotes"
echo "Files created:"
for i in $(seq 1 $CHUNK_NUM); do
    chunk_file="$OUTPUT_DIR/missing_emotes_chunk_${i}.lua"
    emote_count=$(grep -c '^\s*\[".*"\]\s*=' "$chunk_file")
    echo "  - missing_emotes_chunk_${i}.lua ($emote_count emotes)"
done