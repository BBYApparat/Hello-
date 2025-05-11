
CodeStudio.ServerType = 'ESX'  ---Your Server Type QB/ESX/false

CodeStudio.OpenUI = {
    useCommand = true,
    Command_Name = 'ftest',

    useItem = true, 
    Item_Name = 'finger_scanner'
}


---EDIT THIS AS PER YOUR SERVER NEEDS---

if CodeStudio.ServerType == "QB" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif CodeStudio.ServerType == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
end

if CodeStudio.OpenUI.useItem then 
    if CodeStudio.ServerType == 'QB' then
        QBCore.Functions.CreateUseableItem(CodeStudio.OpenUI.Item_Name, function(source)
            TriggerClientEvent('cs:fscanner:openUI', source)
        end)
    elseif CodeStudio.ServerType == 'ESX' then
        ESX.RegisterUsableItem(CodeStudio.OpenUI.Item_Name, function(source)
            TriggerClientEvent('cs:fscanner:openUI', source)
        end)
    else
        --YOU CAN ADD YOUR CUSTOM EVENTS HERE
    end
end

if CodeStudio.OpenUI.useCommand then
    lib.addCommand(CodeStudio.OpenUI.Command_Name, {
        help = "Open Alcohol Tester",
        restricted = false
    }, function(source, args)
        TriggerClientEvent('cs:fscanner:openUI', source)
    end)
end

-----Info Fetch-----

function GetPlayerDetail(pID)
    local pData = {}

    if CodeStudio.ServerType == "ESX" then 
        local Player = ESX.GetPlayerFromId(pID)
        pData = {
            name = Player.get('firstName')..' '..Player.get('lastName'),
            dob = Player.get('dateofbirth'),
            finger = GetFingerID(Player.identifier),
            gender = Player.get('sex')
        }
        if pData.gender == 'm' then 
            pData.gender = CodeStudio.Language.male_txt 
        else
            pData.gender = CodeStudio.Language.female_txt 
        end

    elseif CodeStudio.ServerType == "QB" then
        local Player = QBCore.Functions.GetPlayer(pID)
        pData = {
            name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname,
            dob = Player.PlayerData.charinfo.birthdate,
            finger = Player.PlayerData.metadata["fingerprint"],
            gender = Player.PlayerData.charinfo.gender
        }
        if pData.gender == 0 then 
            pData.gender = CodeStudio.Language.male_txt 
        else
            pData.gender = CodeStudio.Language.female_txt 
        end

    else
        -- Standalone Mode - Generate Random Values or you can edit this 
        local playerName = GetPlayerName(pID) or "Unknown"
        pData = {
            name = playerName,
            dob = tostring(RandomInt(2) .. "/" .. RandomInt(2) .. "/19" .. RandomInt(2)),
            finger = CreateRandomFingerId(),
            gender = CodeStudio.Language.male_txt
        }
    end

    return pData
end

-- Fingerprint Fetching and Creating for ESX Server -- 

function GetFingerID(identifier)
    if not CodeStudio.Enable_Fingerprint_ID then return false end
    local result = MySQL.scalar.await('SELECT fingerprint FROM users WHERE identifier = ?', { identifier })
    if not result or result == '0' or result == '' then
        local NewFinger = CreateFingerId()
        MySQL.update.await('UPDATE users SET fingerprint = ? WHERE identifier = ?', { NewFinger, identifier })
        return NewFinger
    end
    return result
end

function CreateRandomFingerId()
    return string.format("%s-%s-%s-%s", RandomStr(2), RandomInt(3), RandomStr(3), RandomInt(2))
end

function CreateFingerId()
    local FingerId
    while true do 
        FingerId = tostring(RandomStr(2) .. RandomInt(3) .. RandomStr(1) .. RandomInt(2) .. RandomStr(3)) 
        local result = MySQL.scalar.await('SELECT COUNT(*) FROM users WHERE fingerprint = ?', { FingerId })
        if result == 0 then break end
    end
    return FingerId
end

--- Discord Logs ---

function SendDiscordLog(self, target)
    local webHook = 'PUT_WEBHOOK_HERE'
    local embedData = {
        {
            ['title'] = "Test Performed",
            ['color'] = 65280,
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
            ['description'] = '**Tested By: **' ..self.name.."\n\n**Target Player: **"..target.name
            .."\n**Date of Birth: **"..target.dob.."\n**Gender: **"..target.gender..'\n**Finger Print: **'..target.finger
        }
    }
    PerformHttpRequest(webHook, function() end, 'POST', json.encode({ username = 'Figer Print Department', embeds = embedData}), { ['Content-Type'] = 'application/json' })
end
