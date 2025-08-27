local CurrentVersion = "1.0.0"
local VersionURL = "https://raw.githubusercontent.com/Jester-Development/Jester-Notify/main/version.lua"

PerformHttpRequest(VersionURL, function(statusCode, response, _)
    if statusCode ~= 200 then
        print("^1[Jester-Notify] Kan versie niet ophalen. Status: " .. statusCode .. "^0")
        return
    end

    local remoteVersion = string.match(response, 'CurrentVersion%s*=%s*"([^"]+)"')

    if not remoteVersion then
        print("^1[Jester-Notify] Kon remote versie niet lezen!^0")
        return
    end

    if remoteVersion ~= CurrentVersion then
        print("^3[Jester-Notify] Update beschikbaar!^0")
        print("🔴 Huidige versie: " .. CurrentVersion)
        print("🟢 Nieuwe versie: " .. remoteVersion)
        print("🔗 https://github.com/Jester-Development/Jester-Notify")
    else
        print("^2[Jester-Notify] Je gebruikt de nieuwste versie (" .. CurrentVersion .. ").^0")
    end
end, "GET")
