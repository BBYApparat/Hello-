#!/usr/bin/env python3

import re
import os

def extract_and_format_emotes():
    # Paths
    rp_file = r"C:\Users\alexi\GitHub\Hello-\resources\[plugins]\cylex_animmenu\rpemotes-reborn-master\client\AnimationList.lua"
    missing_file = r"C:\Users\alexi\GitHub\Hello-\resources\[plugins]\cylex_animmenu\missing_emotes_list.txt"
    output_dir = r"C:\Users\alexi\GitHub\Hello-\resources\[plugins]\cylex_animmenu"
    
    # Read missing emotes list
    with open(missing_file, 'r') as f:
        missing_emotes = [line.strip() for line in f if line.strip()]
    
    print(f"Processing {len(missing_emotes)} missing emotes...")
    
    # Read RP file
    with open(rp_file, 'r', encoding='utf-8') as f:
        rp_content = f.read()
    
    # Extract emote definitions
    emote_definitions = {}
    
    # Pattern to match emote definitions
    pattern = r'(\["([^"]+)"\]\s*=\s*{[^}]*(?:{[^}]*}[^}]*)*})'
    
    # Find all emote definitions in the RP.Emotes section
    lines = rp_content.split('\n')
    in_rp_emotes = False
    
    for i, line in enumerate(lines):
        # Check if we're in the RP.Emotes section
        if 'RP.Emotes = {' in line:
            in_rp_emotes = True
            continue
        elif in_rp_emotes and line.strip() == '}':
            break
        
        if in_rp_emotes:
            # Look for emote definitions
            match = re.match(r'\s*\["([^"]+)"\]\s*=\s*{', line)
            if match:
                emote_name = match.group(1)
                
                # Extract the complete emote definition
                definition_lines = [line]
                brace_count = 1
                j = i + 1
                
                while j < len(lines) and brace_count > 0:
                    current_line = lines[j]
                    definition_lines.append(current_line)
                    
                    # Count braces
                    brace_count += current_line.count('{') - current_line.count('}')
                    
                    if brace_count <= 0:
                        break
                    j += 1
                
                emote_definitions[emote_name] = definition_lines
    
    print(f"Found definitions for {len(emote_definitions)} emotes")
    
    # Format and output missing emotes
    processed_emotes = []
    
    for emote_name in missing_emotes:
        if emote_name in emote_definitions:
            # Convert RP format to DP format
            definition = emote_definitions[emote_name]
            formatted_definition = []
            
            for line in definition:
                # Convert RP-specific syntax to DP format
                line = re.sub(r'onFootFlag\s*=\s*AnimFlag\.LOOP', 'EmoteLoop = true', line)
                line = re.sub(r'onFootFlag\s*=\s*AnimFlag\.MOVING', 'EmoteMoving = true', line)
                
                formatted_definition.append(line)
            
            processed_emotes.append('\n'.join(formatted_definition))
    
    # Split into chunks of 100 emotes each
    chunk_size = 100
    total_chunks = (len(processed_emotes) + chunk_size - 1) // chunk_size
    
    for chunk_num in range(total_chunks):
        start_idx = chunk_num * chunk_size
        end_idx = min(start_idx + chunk_size, len(processed_emotes))
        chunk_emotes = processed_emotes[start_idx:end_idx]
        
        # Create chunk file
        chunk_file = os.path.join(output_dir, f"missing_emotes_chunk_{chunk_num + 1}.lua")
        
        with open(chunk_file, 'w', encoding='utf-8') as f:
            f.write(f"""-- Missing Emotes from RPEmotes-Reborn for Cylex AnimMenu
-- Chunk {chunk_num + 1} of {total_chunks} - Emotes {start_idx + 1}-{end_idx}
-- Add these to your DP.Emotes section in animations/merge/AnimationList.lua
--
-- Instructions:
-- 1. Copy the emote definitions below
-- 2. Paste them into your DP.Emotes = {{ }} section
-- 3. Make sure to add commas between emotes as needed
-- 4. Ensure proper formatting and syntax

""")
            
            for i, emote_def in enumerate(chunk_emotes):
                f.write(emote_def)
                if i < len(chunk_emotes) - 1:
                    f.write(',\n\n')
                else:
                    f.write('\n\n')
        
        print(f"Created chunk {chunk_num + 1}: {len(chunk_emotes)} emotes")
    
    print(f"Successfully processed {len(processed_emotes)} emotes into {total_chunks} chunks")

if __name__ == "__main__":
    extract_and_format_emotes()