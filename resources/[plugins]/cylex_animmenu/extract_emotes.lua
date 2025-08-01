-- Script to extract all emote names from both files
local rp_emotes = {}
local dp_emotes = {}

-- Function to extract emote names from a line
function extract_emote_name(line)
    local name = line:match('%[%"(.-)%"%]')
    return name
end

-- Read RP.Emotes file
print("Extracting RP.Emotes...")
local rp_file = io.open("C:\\Users\\alexi\\GitHub\\Hello-\\resources\\[plugins]\\cylex_animmenu\\rpemotes-reborn-master\\client\\AnimationList.lua", "r")
if rp_file then
    local line_number = 0
    local in_rp_emotes = false
    for line in rp_file:lines() do
        line_number = line_number + 1
        if line_number >= 5054 and line_number <= 10523 then
            if line:match('%[%".-"%]') then
                local emote_name = extract_emote_name(line)
                if emote_name then
                    rp_emotes[emote_name] = true
                    print("RP: " .. emote_name)
                end
            end
        end
    end
    rp_file:close()
end

-- Read DP.Emotes file
print("\nExtracting DP.Emotes...")
local dp_file = io.open("C:\\Users\\alexi\\GitHub\\Hello-\\resources\\[plugins]\\cylex_animmenu\\animations\\merge\\AnimationList.lua", "r")
if dp_file then
    local line_number = 0
    for line in dp_file:lines() do
        line_number = line_number + 1
        if line_number >= 6596 and line_number <= 10070 then
            if line:match('%[%".-"%]') then
                local emote_name = extract_emote_name(line)
                if emote_name then
                    dp_emotes[emote_name] = true
                    print("DP: " .. emote_name)
                end
            end
        end
    end
    dp_file:close()
end

-- Find missing emotes
print("\nMissing emotes from DP:")
local missing_count = 0
for emote_name, _ in pairs(rp_emotes) do
    if not dp_emotes[emote_name] then
        print(emote_name)
        missing_count = missing_count + 1
    end
end

print("\nTotal missing emotes: " .. missing_count)