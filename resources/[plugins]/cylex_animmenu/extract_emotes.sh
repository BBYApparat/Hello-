#!/bin/bash

# Script to extract missing emote definitions
WORK_DIR="/c/Users/alexi/GitHub/Hello-/resources/[plugins]/cylex_animmenu"
RP_FILE="$WORK_DIR/rpemotes-reborn-master/client/AnimationList.lua"
DP_FILE="$WORK_DIR/animations/merge/AnimationList.lua"
MISSING_FILE="$WORK_DIR/missing_emotes_list.txt"
OUTPUT_FILE="$WORK_DIR/missing_emotes_definitions.lua"

echo "Starting emote extraction process..."

# Create output file header
cat > "$OUTPUT_FILE" << 'EOF'
-- Missing emotes from RP.Emotes formatted for DP.Emotes
-- These are the emotes that exist in rpemotes-reborn but not in cylex_animmenu
-- Copy these definitions into your DP.Emotes section

EOF

# Counter for processed emotes
processed=0
total_missing=$(wc -l < "$MISSING_FILE")

echo "Processing $total_missing missing emotes..."

# Process each missing emote
while IFS= read -r emote_name; do
    # Find the emote definition in the RP file
    start_line=$(grep -n "^\s*\[\"$emote_name\"\]\s*=" "$RP_FILE" | cut -d: -f1)
    
    if [ -n "$start_line" ]; then
        # Extract the complete emote definition
        # Start from the emote line and read until we find the closing brace
        awk -v start="$start_line" '
        NR >= start {
            if (NR == start) {
                brace_count = 1
                print $0
            } else {
                # Count opening and closing braces
                open_braces = gsub(/\{/, "")
                close_braces = gsub(/\}/, "")
                brace_count += open_braces - close_braces
                print $0
                
                if (brace_count <= 0) {
                    exit
                }
            }
        }' "$RP_FILE" | sed 's/onFootFlag = AnimFlag\.LOOP/EmoteLoop = true/g' | sed 's/onFootFlag = AnimFlag\.MOVING/EmoteMoving = true/g' >> "$OUTPUT_FILE"
        
        echo "" >> "$OUTPUT_FILE"
        processed=$((processed + 1))
        
        if [ $((processed % 50)) -eq 0 ]; then
            echo "Processed $processed/$total_missing emotes..."
        fi
    else
        echo "Warning: Could not find definition for emote: $emote_name"
    fi
done < "$MISSING_FILE"

echo "Completed! Processed $processed missing emotes"
echo "Output written to: $OUTPUT_FILE"