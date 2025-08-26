ESX = exports["es_extended"]:getSharedObject()

webhookid = GetConvar('advanced_jail:webhookid', '')
Log = {
    ReJail = true, --If it logs when someone gets jailed upon script restart or player load in
    Jail = true, --If it logs when someone gets jailed
    UnJail = true, --If it logs when someone gets unjailed
    AddTime = true, --If it logs when someone gets time added
    RemoveTime = true, --If it logs when someone gets time removed
    LeaveInJail = true, --If it logs when someone logs out while in jail
    SendingSol = true, --IF it logs when someone is sent/taken to solitary
    Breaking = true, --If it logs when someone successfully breaks a part of the wall
    Escape = true, --If it logs when someone escapes
    Craft = true, --If it logs when someone crafts an item
    Bed = true, --If it logs when someone adds/removes something from bed
    Job = true --If it logs everything with the jobs
}
exports('getLog', function()
    return Log
end)

adminRoles = {
    'admin',
    'superadmin'
}
adminAbilities = {
    Jailing = {'admin', 'superadmin'},
    UnJail = {'admin', 'superadmin'},
    AddTime = {'admin', 'superadmin'},
    RemoveTime = {'admin', 'superadmin'},
    Send2Solitary = {'admin', 'superadmin'},
    RemoveFromSolitary = {'admin', 'superadmin'},
    Lockdown = {'admin', 'superadmin'},
    Message = {'admin', 'superadmin'},
}

------------------------------------------------------
inJail = {}
solJail = {}
Items = {}
good = false
infoPedLocie = 1
lockCount = 0
lockDown = false

function getInJail()
    return inJail
end
exports('getInJail', getInJail)

function setInJail(data)
    inJail = data
end
exports('setInJail', setInJail)

Citizen.CreateThread(function()
    if Config.RanMessage then
        while true do
            Citizen.Wait(Config.RanMessageTime * 60000)
            local xPlayers = ESX.GetPlayers()
            if xPlayers[1] ~= nil then
                for i = 1, #xPlayers, 1 do
                    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                    local total = 0
                    local ranMessage = nil
                    for j = 1, #Config.RanMessages, 1 do
                        total = total + 1
                    end
                    ranMessage = math.random(1, total)
                    TriggerClientEvent('advanced_jail:SendNotif2', xPlayer.source, Config.RanMessages[ranMessage])
                end
            end
        end
    end
end)

RegisterServerEvent('advanced_jail:Send2Prisoners')
AddEventHandler('advanced_jail:Send2Prisoners', function(messago)
    local xTarget = ESX.GetPlayerFromId(source)
    if CheckUser(source, 'message') then
        TriggerClientEvent('advanced_jail:SendNotif', -1, Config.Sayings[168]..messago, true)
    end
end)

-- Add this to your server.lua if it's not already there
RegisterServerEvent('advanced_jail:sendToJail')
AddEventHandler('advanced_jail:sendToJail', function(id, time, reason)
    local xPlayer = ESX.GetPlayerFromId(id)
    local ident = xPlayer.identifier
    
    -- Find available cell and place player in jail
    local cellies = {}
    local lowest = {val = 0, amtie = 30}
    
    for i = 1, #inJail, 1 do
        if inJail[i].Players ~= nil then
            local total = 0
            for p = 1, #inJail[i].Players, 1 do
                total = total + 1
            end
            table.insert(cellies, {value = i, amt = total})
        else
            table.insert(cellies, {value = i, amt = 0})
        end
    end
    
    for i = 1, #cellies, 1 do
        if cellies[i].amt < lowest.amtie then
            lowest.val = cellies[i].value
            lowest.amtie = cellies[i].amt
        end
    end
    
    -- Add player to jail records
    table.insert(inJail[lowest.val].Players, {Player = ident, Timie = time, ID = id, Sol = 0, Dead = false, Breako = 0})
    
    -- Update database
    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
        ['@identifier'] = ident
    }, function(result)
        local newData = {}
        if result[1] and result[1].jail_data then
            newData = json.decode(result[1].jail_data)
        else
            newData = {
                cell = lowest.val,
                jailtime = time,
                soli = 0,
                chest = {},
                breaks = 0,
                clothes = {},
                job = 0,
                jobo = xPlayer.job.name, 
                grade = xPlayer.job.grade
            }
        end
        
        newData.cell = lowest.val
        newData.jailtime = time
        
        local data = json.encode(newData)
        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
            ['@identifier'] = ident,
            ['@jail_data'] = data
        })
    end)
    
    -- Save player's job and put them in prison job
    -- xPlayer.setJob('unemployed', 0)
    
    -- Trigger client-side jail events
    TriggerClientEvent('advanced_jail:JailStart', id, time)
end)

RegisterServerEvent('advanced_jail:PoliceNotify')
AddEventHandler('advanced_jail:PoliceNotify', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local fullname = nil
    fullname = xPlayer.get("firstName") .. " " .. xPlayer.get("lastName")
    TriggerClientEvent('advanced_jail:PoliceWarning', -1, fullname)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.InfoPedChangeTime * 60000)
        local total = 0
        for j = 1, #Config.InfoPedLoc, 1 do
            total = total + 1
        end
        infoPedLocie = math.random(1, total)
        TriggerClientEvent('advanced_jail:ChangeLoc', -1, infoPedLocie)
    end
end)

ESX.RegisterServerCallback('advanced_jail:GetChest', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
        }, function(result)
        local newData = nil
        local tablie = {}
        newData = json.decode(result[1].jail_data)
        for i = 1, #newData.chest, 1 do
            for j = 1, #Items, 1 do
                if Items[j].name == newData.chest[i].item then
                    table.insert(tablie, {itemName = Items[j].label, amt = newData.chest[i].amt, ite = newData.chest[i].item})
                end
            end
        end
        cb(tablie)
    end)
end)

ESX.RegisterServerCallback('advanced_jail:GetChest2', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(id)
    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
        }, function(result)
        local newData = nil
        local tablie = {}
        newData = json.decode(result[1].jail_data)
        for i = 1, #newData.chest, 1 do
            for j = 1, #Items, 1 do
                if Items[j].name == newData.chest[i].item then
                    table.insert(tablie, {itemName = Items[j].label, amt = newData.chest[i].amt, ite = newData.chest[i].item})
                end
            end
        end
        cb(tablie)
    end)
end)

ESX.RegisterServerCallback('advanced_jail:GrabInfoLoc', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(infoPedLocie)
end)

ESX.RegisterServerCallback('advanced_jail:CheckID2', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(id)
    local cert = nil
    if xPlayer ~= nil then
        cert = xPlayer.identifier
    end
    local found1 = 0
    local found2 = 0
    if cert ~= nil then
        for i = 1, #inJail, 1 do
            if inJail[i].Players[1] ~= nil then
                for j = 1, #inJail[i].Players, 1 do
                    if inJail[i].Players[j].Player == cert then
                        found1 = i
                        found2 = j
                    end
                end
            end
        end
    end
    if found1 ~= 0 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('advanced_jail:GetInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory
    cb({items = items})
end)

RegisterServerEvent('advanced_jail:RemoveItem')
AddEventHandler('advanced_jail:RemoveItem', function(items, amti, namo, idie)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
        }, function(result)
        local newData = nil
        local removie = {}
        local data = nil
        newData = json.decode(result[1].jail_data)
        for i = 1, #newData.chest, 1 do
            if newData.chest[i].item == items then
                if newData.chest[i].amt > amti then
                    newData.chest[i].amt = amti
                else
                    table.insert(removie, i)
                end
            end
        end
        if Log.Bed then
            local sugg = nil
            for i = 1, #newData.chest, 1 do
                if newData.chest[i].item == items then
                    sugg = newData.chest[i].amt - amti
                end
            end
            local this = {
                {
                    ["name"] = "**Player Name:**",
                    ["value"] = GetPlayerName(idie),
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player ID:**",
                    ["value"] = idie,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player Identifier:**",
                    ["value"] = xPlayer.identifier,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Item Being Removed:**",
                    ["value"] = amti..'x '..namo,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Amount Of That Item Left Under Bed:**",
                    ["value"] = sugg,
                    ["inline"] = true
                },
            }
            sendToDiscord(this, 15597823, "Player Removing Item From Under Bed")
        end
        xPlayer.addInventoryItem(items, amti)
        if removie[1] ~= nil then
            for i = 1, #removie, 1 do
                table.remove(newData.chest, removie[i])
            end
        end
        removie = {}
        data = json.encode(newData)
        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
            ['@jail_data'] = data
        })
    end)
end)

RegisterServerEvent('advanced_jail:RemoveItem2')
AddEventHandler('advanced_jail:RemoveItem2', function(items, amti, namo, idie)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(idie)
    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xTarget.identifier
        }, function(result)
        local newData = nil
        local removie = {}
        local data = nil
        newData = json.decode(result[1].jail_data)
        for i = 1, #newData.chest, 1 do
            if newData.chest[i].item == items then
                if newData.chest[i].amt > amti then
                    newData.chest[i].amt = amti
                else
                    table.insert(removie, i)
                end
            end
        end
        xPlayer.addInventoryItem(items, amti)
        if removie[1] ~= nil then
            for i = 1, #removie, 1 do
                table.remove(newData.chest, removie[i])
            end
        end
        removie = {}
        data = json.encode(newData)
        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
            ['@identifier'] = xTarget.identifier,
            ['@jail_data'] = data
        })
    end)
end)

RegisterServerEvent('advanced_jail:AddItem')
AddEventHandler('advanced_jail:AddItem', function(items, amti, namo, idie)
    local xPlayer = ESX.GetPlayerFromId(source)
    local found = 0
    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
        }, function(result)
        local newData = nil
        local data = nil
        newData = json.decode(result[1].jail_data)
        for i = 1, #newData.chest, 1 do
            if newData.chest[i].item == items then
                found = i
            end
        end
        if found == 0 then
            table.insert(newData.chest, {item = items, amt = amti})
        else
            newData.chest[found].amt = newData.chest[found].amt + amti
        end
        if Log.Bed then
            local sugg = nil
            for i = 1, #newData.chest, 1 do
                if newData.chest[i].item == items then
                    sugg = newData.chest[i].amt
                end
            end
            local shitie = {
                {
                    ["name"] = "**Player Name:**",
                    ["value"] = GetPlayerName(idie),
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player ID:**",
                    ["value"] = idie,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player Identifier:**",
                    ["value"] = xPlayer.identifier,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Item Being Added:**",
                    ["value"] = amti..'x '..namo,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Amount Of That Item Under Bed:**",
                    ["value"] = sugg,
                    ["inline"] = true
                },
            }
            sendToDiscord(shitie, 16515951, "Player Putting Item Under Bed")
        end
        xPlayer.removeInventoryItem(items, amti)
        data = json.encode(newData)
        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
            ['@jail_data'] = data
        })
    end)
end)

RegisterServerEvent('advanced_jail:ReJail')
AddEventHandler('advanced_jail:ReJail', function(id, values)
    local xPlayer = ESX.GetPlayerFromId(id)
    local ident = xPlayer.identifier
    local theS = {}
    local cellies = {}
    local lowest = {val = 0, amtie = 30}
    theS = values
    local tots = 0
    if theS.cell == 0 then
        theS.cell = 1
    end
    for i = 1, #inJail[theS.cell], 1 do
        tots = tots + 1
    end
    if tots >= Config.MaxPerCell then
        for i = 1, #inJail, 1 do
            if inJail[i].Players ~= nil then
                local total = 0
                for p = 1, #inJail[i].Players, 1 do
                    total = total + 1
                end
                table.insert(cellies, {value = i, amt = total})
            else
                table.insert(cellies, {value = i, amt = 0})
            end
        end
        for i = 1, #cellies, 1 do
            if cellies[i].amt < lowest.amtie then
                lowest.val = cellies[i].value
                lowest.amtie = cellies[i].amt
            end
        end
        table.insert(inJail[lowest.val].Players, {Player = ident, Timie = theS.jailtime, ID = id, Sol = theS.soli, Dead = false, Breako = 0})
        if Log.ReJail then
            if Config.SimpleTime then
                local this = {
                    {
                        ["name"] = "**Player Name:**",
                        ["value"] = GetPlayerName(id),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player ID:**",
                        ["value"] = id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Identifier:**",
                        ["value"] = ident,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Time Remaining:**",
                        ["value"] = theS.jailtime..' (seconds)',
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Solitary Time:**",
                        ["value"] = theS.soli..' (seconds)',
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Cell Number:**",
                        ["value"] = lowest.val,
                        ["inline"] = true
                    },
                }
                sendToDiscord(this, 16562691, "Re-Jailing Player")
            else
                local this = {
                    {
                        ["name"] = "**Player Name:**",
                        ["value"] = GetPlayerName(id),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player ID:**",
                        ["value"] = id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Identifier:**",
                        ["value"] = ident,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Time Remaining:**",
                        ["value"] = GetGoodTime(theS.jailtime),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Solitary Time:**",
                        ["value"] = GetGoodTime(theS.soli),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Cell Number:**",
                        ["value"] = lowest.val,
                        ["inline"] = true
                    },
                }
                sendToDiscord(this, 16562691, "Re-Jailing Player")
            end
        end
        TriggerEvent('advanced_jail:UpdateCell', lowest.val, id)
        if theS.clothes[1] ~= nil then
            TriggerClientEvent('advanced_jail:GoToJail', id, theS.jailtime, theS.job, false)
            Wait(4000)
            TriggerClientEvent('advanced_jail:UpBreaks', id, theS.breaks, false)
        else
            TriggerClientEvent('advanced_jail:GoToJail', id, theS.jailtime, theS.job, true)
            Wait(4000)
            TriggerClientEvent('advanced_jail:UpBreaks', id, theS.breaks, false)
        end
    else
        table.insert(inJail[theS.cell].Players, {Player = ident, Timie = theS.jailtime, ID = id, Sol = theS.soli, Dead = false, Breako = 0})
        if Log.ReJail then
            if not Config.SimpleTime then
                local this = {
                    {
                        ["name"] = "**Player Name:**",
                        ["value"] = GetPlayerName(id),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player ID:**",
                        ["value"] = id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Identifier:**",
                        ["value"] = ident,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Time Remaining:**",
                        ["value"] = GetGoodTime(theS.jailtime),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Solitary Time:**",
                        ["value"] = GetGoodTime(theS.soli),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Cell Number:**",
                        ["value"] = theS.cell,
                        ["inline"] = true
                    },
                }
                sendToDiscord(this, 16562691, "Re-Jailing Player")
            else
                local this = {
                    {
                        ["name"] = "**Player Name:**",
                        ["value"] = GetPlayerName(id),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player ID:**",
                        ["value"] = id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Identifier:**",
                        ["value"] = ident,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Time Remaining:**",
                        ["value"] = theS.jailtime..' (seconds)',
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Solitary Time:**",
                        ["value"] = theS.soli..' (seconds)',
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Cell Number:**",
                        ["value"] = theS.cell,
                        ["inline"] = true
                    },
                }
                sendToDiscord(this, 16562691, "Re-Jailing Player")
            end
        end
        if theS.clothes[1] ~= nil then
            TriggerClientEvent('advanced_jail:GoToJail', id, theS.jailtime, theS.job, false)
            Wait(4000)
            TriggerClientEvent('advanced_jail:UpBreaks', id, theS.breaks, false)
        else
            TriggerClientEvent('advanced_jail:GoToJail', id, theS.jailtime, theS.job, true)
            Wait(4000)
            TriggerClientEvent('advanced_jail:UpBreaks', id, theS.breaks, false)
        end
    end
end)

Citizen.CreateThread(function()
    for i = 1, #Config.Cells, 1 do
        table.insert(inJail, {Value = i, Players = {}})
    end
    for i = 1, #Config.SolCells, 1 do
        table.insert(solJail, {Value = i, Players = {}})
    end
end)

ESX.RegisterServerCallback('advanced_jail:getjailtime', function(source, cb)
    for i = 1, #inJail, 1 do
        for k = 1, #inJail[i].Players, 1 do
            if inJail[i].Players[k] and inJail[i].Players[k].ID == source then
                cb(inJail[i].Players[k].Timie)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for i = 1, #inJail, 1 do
            for k = 1, #inJail[i].Players, 1 do
                if inJail[i].Players[k] then
                    if not inJail[i].Players[k].Dead then
                        if inJail[i].Players[k].Breako > 0 then
                            inJail[i].Players[k].Breako = inJail[i].Players[k].Breako - 1
                            if inJail[i].Players[k].Breako <= 0 then
                                TriggerEvent('advanced_jail:UnBreak', inJail[i].Players[k].ID)
                            end
                        else
                            if inJail[i].Players[k].Sol > 0 then
                                inJail[i].Players[k].Sol = inJail[i].Players[k].Sol - 1
                                if inJail[i].Players[k].Sol <= 0 then
                                    TriggerEvent('advanced_jail:UnSol', inJail[i].Players[k].ID)
                                end
                            else
                                inJail[i].Players[k].Timie = inJail[i].Players[k].Timie - 1
                                if inJail[i].Players[k].Timie <= 0 then
                                    TriggerEvent('advanced_jail:UnJailPlayer', inJail[i].Players[k].ID, true)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        local cert = nil
        cert = xPlayer.identifier
        local found1 = 0
        local found2 = 0
        for i = 1, #inJail, 1 do
            if inJail[i].Players[1] ~= nil then
                for j = 1, #inJail[i].Players, 1 do
                    if inJail[i].Players[j].Player == cert then
                        found1 = i
                        found2 = j
                    end
                end
            end
        end
        if found1 ~= 0 then
            if Log.LeaveInJail then
                if Config.SimpleTime then
                    local this = {
                        {
                            ["name"] = "**Player Name:**",
                            ["value"] = GetPlayerName(inJail[found1].Players[found2].ID),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player ID:**",
                            ["value"] = inJail[found1].Players[found2].ID,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player Identifier:**",
                            ["value"] = cert,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Time Remaining:**",
                            ["value"] = inJail[found1].Players[found2].Timie..' (seconds)',
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Solitary Time Remaining:**",
                            ["value"] = inJail[found1].Players[found2].Sol..' (seconds)',
                            ["inline"] = true
                        },
                    }
                    sendToDiscord(this, 13172480, "Player Leaving In Jail")
                else
                    local this = {
                        {
                            ["name"] = "**Player Name:**",
                            ["value"] = GetPlayerName(inJail[found1].Players[found2].ID),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player ID:**",
                            ["value"] = inJail[found1].Players[found2].ID,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player Identifier:**",
                            ["value"] = cert,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Time Remaining:**",
                            ["value"] = GetGoodTime(inJail[found1].Players[found2].Timie),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Solitary Time Remaining:**",
                            ["value"] = GetGoodTime(inJail[found1].Players[found2].Sol),
                            ["inline"] = true
                        },
                    }
                    sendToDiscord(this, 13172480, "Player Leaving In Jail")
                end
            end
            MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                ['@identifier'] = cert
                }, function(result)
                local newData = nil
                local data = nil
                newData = json.decode(result[1].jail_data)
                newData.jailtime = inJail[found1].Players[found2].Timie
                newData.soli = inJail[found1].Players[found2].Sol
                data = json.encode(newData)
                table.remove(inJail[found1].Players, found2)
                MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                    ['@identifier'] = cert,
                    ['@jail_data'] = data
                })
            end)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.SyncInterval * 60000)
        for i = 1, #inJail, 1 do
            for k = 1, #inJail[i].Players, 1 do
                if inJail[i].Players[k].Player ~= nil then
                    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = inJail[i].Players[k].Player
                        }, function(result)
                        local newData = nil
                        local data = nil
                        newData = json.decode(result[1].jail_data)
                        newData.jailtime = inJail[i].Players[k].Timie
                        newData.soli = inJail[i].Players[k].Sol
                        data = json.encode(newData)
                        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                            ['@identifier'] = inJail[i].Players[k].Player,
                            ['@jail_data'] = data
                        })
                    end)
                end
            end
        end
    end
end)

ESX.RegisterCommand('jailmenu', {'admin', 'superadmin'}, function(xPlayer, args, showError)
    TriggerClientEvent('advanced_jail:JailMenu', xPlayer.source)
end, true, {help = 'Jail Menu For Admins & Police', validate = true, arguments = {}})

ESX.RegisterServerCallback('advanced_jail:GetCell', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ident = xPlayer.identifier
    local found = 0
    for i = 1, #inJail, 1 do
        if inJail[i].Players[1] ~= nil then
            for j = 1, #inJail[i].Players, 1 do
                if inJail[i].Players[j].Player == ident then
                    found = i
                end
            end
        end
    end

    cb(found)
end)

ESX.RegisterServerCallback('advanced_jail:CheckID', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('advanced_jail:GetPlayerInCell', function(source, cb, cell)
    local goodShit = {}
    for j = 1, #inJail[cell].Players, 1 do
        local xPlayer = ESX.GetPlayerFromId(inJail[cell].Players[j].ID)
        if xPlayer then
            local fullname = nil
            fullname = xPlayer.get("firstName") .. " " .. xPlayer.get("lastName")
            table.insert(goodShit, {name = fullname, id = inJail[cell].Players[j].ID})
        end
    end
    cb(goodShit)
end)

RegisterServerEvent('advanced_jail:UnJailPlayer')
AddEventHandler('advanced_jail:UnJailPlayer', function(id, flip)
    local id = id
    local xTarget = ESX.GetPlayerFromId(source)
    if xTarget == nil then
        local xPlayer = ESX.GetPlayerFromId(id)
        local ident = xPlayer.identifier
        local found = 0
        local found2 = 0
        for i = 1, #inJail, 1 do
            if inJail[i].Players[1] ~= nil then
                for j = 1, #inJail[i].Players, 1 do
                    if inJail[i].Players[j].Player == ident then
                        found = i
                        found2 = j
                    end
                end
            end
        end
        if found ~= 0 then
            table.remove(inJail[found].Players, found2)
            if flip then
                MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier
                    }, function(result)
                    local newData = nil
                    local clothie = nil
                    local data = nil
                    newData = json.decode(result[1].jail_data)
                    newData.cell = 0
                    newData.chest = {}
                    newData.job = 0
                    xPlayer.setJob(newData.jobo, newData.grade)
                    newData.jobo = 'nil'
                    newData.grade = 0
                    newData.job = 0
                    newData.jailtime = 0
                    newData.soli = 0
                    newData.breaks = 0
                    clothie = newData.clothes
                    newData.clothes = {}
                    data = json.encode(newData)
                    TriggerClientEvent('advanced_jail:UnnJail', id, clothie)
                    if Log.UnJail then
                        local this = {
                            {
                                ["name"] = "**Player Name:**",
                                ["value"] = GetPlayerName(id),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player ID:**",
                                ["value"] = id,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player Identifier:**",
                                ["value"] = ident,
                                ["inline"] = true
                            },
                        }
                        sendToDiscord(this, 16515843, "Un-Jailing Player")
                    end
                    MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier,
                        ['@jail_data'] = data
                    })
                end)
            else
                MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier
                    }, function(result)
                    local newData = nil
                    local data = nil
                    newData = json.decode(result[1].jail_data)
                    newData.cell = 0
                    newData.chest = {}
                    newData.job = 0
                    xPlayer.setJob(newData.jobo, newData.grade)
                    newData.jobo = 'nil'
                    newData.grade = 0
                    newData.soli = 0
                    newData.jailtime = 0
                    newData.breaks = 0
                    newData.clothes = {}
                    newData.items = {}
                    data = json.encode(newData)
                    MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier,
                        ['@jail_data'] = data
                    })
                end)
            end
        end
    else
        if CheckUser(source, 'unjail') then
            local xPlayer = ESX.GetPlayerFromId(id)
            local ident = xPlayer.identifier
            local found = 0
            local found2 = 0
            for i = 1, #inJail, 1 do
                if inJail[i].Players[1] ~= nil then
                    for j = 1, #inJail[i].Players, 1 do
                        if inJail[i].Players[j].Player == ident then
                            found = i
                            found2 = j
                        end
                    end
                end
            end
            if found ~= 0 then
                table.remove(inJail[found].Players, found2)
                if flip then
                    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier
                        }, function(result)
                        local newData = nil
                        local itemzz = nil
                        local clothie = nil
                        local data = nil
                        newData = json.decode(result[1].jail_data)
                        newData.cell = 0
                        newData.chest = {}
                        newData.job = 0
                        xPlayer.setJob(newData.jobo, newData.grade)
                        newData.jobo = 'nil'
                        newData.grade = 0
                        newData.job = 0
                        newData.jailtime = 0
                        newData.soli = 0
                        newData.breaks = 0
                        clothie = newData.clothes
                        newData.clothes = {}
                        itemzz = newData.items
                        newData.items = {}
                        data = json.encode(newData)
                        TriggerClientEvent('advanced_jail:UnnJail', id, itemzz, clothie)
                        if Log.UnJail then
                            local this = {
                                {
                                    ["name"] = "**Player Name:**",
                                    ["value"] = GetPlayerName(id),
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Player ID:**",
                                    ["value"] = id,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Player Identifier:**",
                                    ["value"] = ident,
                                    ["inline"] = true
                                },
                            }
                            sendToDiscord(this, 16515843, "Un-Jailing Player")
                        end
                        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                            ['@identifier'] = xPlayer.identifier,
                            ['@jail_data'] = data
                        })
                    end)
                else
                    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier
                        }, function(result)
                        local newData = nil
                        local data = nil
                        newData = json.decode(result[1].jail_data)
                        newData.cell = 0
                        newData.chest = {}
                        newData.job = 0
                        xPlayer.setJob(newData.jobo, newData.grade)
                        newData.jobo = 'nil'
                        newData.grade = 0
                        newData.soli = 0
                        newData.jailtime = 0
                        newData.breaks = 0
                        newData.clothes = {}
                        newData.items = {}
                        data = json.encode(newData)
                        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                            ['@identifier'] = xPlayer.identifier,
                            ['@jail_data'] = data
                        })
                    end)
                end
            end
        else
            TriggerClientEvent('advanced_jail:SendNotif', xTarget.source, Config.Sayings[159])
        end
    end
end)

RegisterServerEvent('advanced_jail:UpdateCell')
AddEventHandler('advanced_jail:UpdateCell', function(cnum, player)
    local xPlayer = nil
    if ESX.GetPlayerFromId(source) == nil then
        xPlayer = ESX.GetPlayerFromId(player)
    else
        xPlayer = ESX.GetPlayerFromId(source)
    end
    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
        }, function(result)
        local newData = nil
        local data = nil
        newData = json.decode(result[1].jail_data)
        newData.cell = cnum
        data = json.encode(newData)
        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
            ['@jail_data'] = data
        })
    end)
end)

RegisterServerEvent('advanced_jail:AddSomeTime')
AddEventHandler('advanced_jail:AddSomeTime', function(id, timzu, reason)
    if CheckUser(source, 'add') then
        local xPlayer = ESX.GetPlayerFromId(id)
        local ident = xPlayer.identifier
        local found = 0
        local found2 = 0
        for i = 1, #inJail, 1 do
            if inJail[i].Players[1] ~= nil then
                for j = 1, #inJail[i].Players, 1 do
                    if inJail[i].Players[j].Player == ident then
                        found = i
                        found2 = j
                    end
                end
            end
        end
        if found ~= 0 then

            if Log.AddTime then
                if Config.SimpleTime then
                    local this = {
                        {
                            ["name"] = "**Player Name:**",
                            ["value"] = GetPlayerName(id),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player ID:**",
                            ["value"] = id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player Identifier:**",
                            ["value"] = ident,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Current Time:**",
                            ["value"] = inJail[found].Players[found2].Timie..' (seconds)',
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Amount Being Added:**",
                            ["value"] = timzu..' (seconds)',
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Total New Time:**",
                            ["value"] = inJail[found].Players[found2].Timie + timzu,
                            ["inline"] = true
                        },
                    }
                    sendToDiscord(this, 65301, "Adding Time To Player")
                else
                    local this = {
                        {
                            ["name"] = "**Player Name:**",
                            ["value"] = GetPlayerName(id),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player ID:**",
                            ["value"] = id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player Identifier:**",
                            ["value"] = ident,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Current Time:**",
                            ["value"] = GetGoodTime(inJail[found].Players[found2].Timie),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Amount Being Added:**",
                            ["value"] = GetGoodTime(timzu),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Total New Time:**",
                            ["value"] = GetGoodTime(inJail[found].Players[found2].Timie + timzu),
                            ["inline"] = true
                        },
                    }
                    sendToDiscord(this, 65301, "Adding Time To Player")
                end
            end
            MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
                }, function(result)
                local newData = nil
                local data = nil
                newData = json.decode(result[1].jail_data)
                inJail[found].Players[found2].Timie = inJail[found].Players[found2].Timie + timzu
                newData.jailtime = inJail[found].Players[found2].Timie
                TriggerClientEvent('advanced_jail:AddItUp', id, timzu)
                data = json.encode(newData)
                MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier,
                    ['@jail_data'] = data
                })
            end)
        end
    else
        local _source = source
        TriggerClientEvent('advanced_jail:SendNotif', _source, Config.Sayings[159])
    end
end)

RegisterServerEvent('advanced_jail:RemoveSomeTime')
AddEventHandler('advanced_jail:RemoveSomeTime', function(id, timzu, reason)
    if CheckUser(source, 'remove') then
        local xPlayer = ESX.GetPlayerFromId(id)
        local ident = xPlayer.identifier
        local _source = source
        local found = 0
        local found2 = 0
        for i = 1, #inJail, 1 do
            if inJail[i].Players[1] ~= nil then
                for j = 1, #inJail[i].Players, 1 do
                    if inJail[i].Players[j].Player == ident then
                        found = i
                        found2 = j
                    end
                end
            end
        end
        if found ~= 0 then
            if inJail[found].Players[found2].Timie > timzu then
                if Log.RemoveTime then
                    if Config.SimpleTime then
                        local this = {
                            {
                                ["name"] = "**Player Name:**",
                                ["value"] = GetPlayerName(id),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player ID:**",
                                ["value"] = id,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player Identifier:**",
                                ["value"] = ident,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Current Time:**",
                                ["value"] = inJail[found].Players[found2].Timie..' (seconds)',
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Amount Being Removed:**",
                                ["value"] = timzu..' (seconds)',
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Total New Time:**",
                                ["value"] = inJail[found].Players[found2].Timie - timzu,
                                ["inline"] = true
                            },
                        }
                        sendToDiscord(this, 65301, "Removing Time From Player")
                    else
                        local this = {
                            {
                                ["name"] = "**Player Name:**",
                                ["value"] = GetPlayerName(id),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player ID:**",
                                ["value"] = id,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player Identifier:**",
                                ["value"] = ident,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Current Time:**",
                                ["value"] = GetGoodTime(inJail[found].Players[found2].Timie),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Amount Being Removed:**",
                                ["value"] = GetGoodTime(timzu),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Total New Time:**",
                                ["value"] = GetGoodTime(inJail[found].Players[found2].Timie - timzu),
                                ["inline"] = true
                            },
                        }
                        sendToDiscord(this, 65301, "Removing Time From Player")
                    end
                end
                MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier
                    }, function(result)
                    local newData = nil
                    local data = nil
                    newData = json.decode(result[1].jail_data)
                    inJail[found].Players[found2].Timie = inJail[found].Players[found2].Timie - timzu
                    newData.jailtime = inJail[found].Players[found2].Timie
                    TriggerClientEvent('advanced_jail:Removeit', id, timzu)
                    data = json.encode(newData)
                    MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier,
                        ['@jail_data'] = data
                    })
                end)
            else
                TriggerClientEvent('advanced_jail:SendNotif', _source, Config.Sayings[141])
            end
        end
    else
        local _source = source
        TriggerClientEvent('advanced_jail:SendNotif', _source, Config.Sayings[159])
    end
end)

RegisterServerEvent('advanced_jail:UpdateClothes')
AddEventHandler('advanced_jail:UpdateClothes', function(numie)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
        }, function(result)
        local newData = nil
        local data = nil
        newData = json.decode(result[1].jail_data)
        newData.clothes = numie
        data = json.encode(newData)
        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
            ['@jail_data'] = data
        })
    end)
end)

RegisterServerEvent('advanced_jail:Ate')
AddEventHandler('advanced_jail:Ate', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx_status:add', source, 'hunger', Config.FoodAmt)
    TriggerClientEvent('esx_status:add', source, 'thirst', Config.DrinkAmt)
end)

RegisterServerEvent('advanced_jail:UnBreak')
AddEventHandler('advanced_jail:UnBreak', function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    local ident = xPlayer.identifier
    local found1 = 0
    local found2 = 0
    for i = 1, #inJail, 1 do
        if inJail[i].Players[1] ~= nil then
            for j = 1, #inJail[i].Players, 1 do
                if inJail[i].Players[j].Player == ident then
                    found1 = i
                    found2 = j
                end
            end
        end
    end
    if found1 ~= 0 then
        inJail[found1].Players[found2].Breako = 0
        TriggerClientEvent('advanced_jail:UnBreak2', id)
    end
end)

RegisterServerEvent('advanced_jail:RetrieveItems')
AddEventHandler('advanced_jail:RetrieveItems', function(itoms)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itee = nil
    itee = itoms
    for j = 1, #itee, 1 do
        xPlayer.addInventoryItem(itee[j].item, itee[j].Amt)
    end
end)

RegisterServerEvent('advanced_jail:SetJob')
AddEventHandler('advanced_jail:SetJob', function(jobii, flip)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ident = xPlayer.identifier
    local found1 = 0
    local found2 = 0
    local id = nil
    for i = 1, #inJail, 1 do
        if inJail[i].Players[1] ~= nil then
            for j = 1, #inJail[i].Players, 1 do
                if inJail[i].Players[j].Player == ident then
                    id = inJail[i].Players[j].ID
                end
            end
        end
    end
    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
        }, function(result)
        local newData = nil
        local data = nil
        newData = json.decode(result[1].jail_data)
        if Log.Job and flip then
            local jobzo = nil
            local jobbo = nil
            if newData.job ~= 0 then
                jobzo = Config.JobOptions[newData.job].Name
            else
                jobzo = Config.Sayings[16]
            end
            if jobii ~= 0 then
                jobbo = Config.JobOptions[jobii].Name
            else
                jobbo = Config.Sayings[16]
            end
            local this = {
                {
                    ["name"] = "**Player Name:**",
                    ["value"] = GetPlayerName(id),
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player ID:**",
                    ["value"] = id,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player Identifier:**",
                    ["value"] = ident,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Old Job:**",
                    ["value"] = jobzo,
                    ["inline"] = true
                },
                {
                    ["name"] = "**New Job:**",
                    ["value"] = jobbo,
                    ["inline"] = true
                },
            }
            sendToDiscord(this, 65412, "Player Job Change")
        end
        newData.job = jobii
        data = json.encode(newData)
        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
            ['@jail_data'] = data
        })
    end)
end)

RegisterServerEvent('advanced_jail:TaskComplete')
AddEventHandler('advanced_jail:TaskComplete', function(taskJob)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ident = xPlayer.identifier
    local found1 = 0
    local found2 = 0
    for i = 1, #inJail, 1 do
        if inJail[i].Players[1] ~= nil then
            for j = 1, #inJail[i].Players, 1 do
                if inJail[i].Players[j].Player == ident then
                    found1 = i
                    found2 = j
                end
            end
        end
    end
    if found1 ~= 0 then
        if Log.Job then
            local yur = inJail[found1].Players[found2].Timie - Config.JobOptions[taskJob].TimeRemove
            if Config.SimpleTime then
                local this = {
                    {
                        ["name"] = "**Player Name:**",
                        ["value"] = GetPlayerName(xPlayer.source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player ID:**",
                        ["value"] = xPlayer.source,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Identifier:**",
                        ["value"] = ident,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Job:**",
                        ["value"] = Config.JobOptions[taskJob].Name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Current Time:**",
                        ["value"] = inJail[found1].Players[found2].Timie..' (seconds)',
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Time Being Removed:**",
                        ["value"] = Config.JobOptions[taskJob].TimeRemove..' (seconds)',
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**New Time:**",
                        ["value"] = yur..' (seconds)',
                        ["inline"] = true
                    },
                }
                sendToDiscord(this, 65480, "Job Task Complete")
            else
                local this = {
                    {
                        ["name"] = "**Player Name:**",
                        ["value"] = GetPlayerName(xPlayer.source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player ID:**",
                        ["value"] = xPlayer.source,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Identifier:**",
                        ["value"] = ident,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Job:**",
                        ["value"] = Config.JobOptions[taskJob].Name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Current Time:**",
                        ["value"] = GetGoodTime(inJail[found1].Players[found2].Timie),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Time Being Removed:**",
                        ["value"] = GetGoodTime(Config.JobOptions[taskJob].TimeRemove),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**New Time:**",
                        ["value"] = GetGoodTime(yur),
                        ["inline"] = true
                    },
                }
                sendToDiscord(this, 65480, "Job Task Complete")
            end
        end
        inJail[found1].Players[found2].Timie = inJail[found1].Players[found2].Timie - Config.JobOptions[taskJob].TimeRemove
    end
end)

RegisterServerEvent('advanced_jail:PlayerDie')
AddEventHandler('advanced_jail:PlayerDie', function(trip)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ident = xPlayer.identifier
    local found1 = 0
    local found2 = 0
    for i = 1, #inJail, 1 do
        if inJail[i].Players[1] ~= nil then
            for j = 1, #inJail[i].Players, 1 do
                if inJail[i].Players[j].Player == ident then
                    found1 = i
                    found2 = j
                end
            end
        end
    end
    if found1 ~= 0 then
        inJail[found1].Players[found2].Dead = trip
        if inJail[found1].Players[found2].Breako > 0 then
            TriggerEvent('advanced_jail:UnBreak', inJail[found1].Players[found2].ID)
        end
    end
end)

RegisterServerEvent('advanced_jail:KilledBy')
AddEventHandler('advanced_jail:KilledBy', function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer then
        local ident = xPlayer.identifier
        local found1 = 0
        local found2 = 0
        for i = 1, #inJail, 1 do
            if inJail[i].Players[1] ~= nil then
                for j = 1, #inJail[i].Players, 1 do
                    if inJail[i].Players[j].Player == ident then
                        found1 = i
                        found2 = j
                    end
                end
            end
        end
        if found1 ~= 0 and Config.Sol4Kill then
            TriggerEvent('advanced_jail:SendToSol', id, Config.SolKillTime, Config.Sayings[110])
        end
    end
end)

RegisterServerEvent('advanced_jail:UpdateBreak')
AddEventHandler('advanced_jail:UpdateBreak', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local ident = xPlayer.identifier
    local found1 = 0
    local found2 = 0
    for i = 1, #inJail, 1 do
        if inJail[i].Players[1] ~= nil then
            for j = 1, #inJail[i].Players, 1 do
                if inJail[i].Players[j].Player == ident then
                    found1 = i
                    found2 = j
                end
            end
        end
    end
    if found1 ~= 0 then
        inJail[found1].Players[found2].Breako = Config.BreakoutTime
        MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
            }, function(result)
            local newData = nil
            local data = nil
            newData = json.decode(result[1].jail_data)
            newData.breaks = 0
            data = json.encode(newData)
            MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier,
                ['@jail_data'] = data
            })
        end)
    end
end)

RegisterServerEvent('advanced_jail:UpdateBreaking')
AddEventHandler('advanced_jail:UpdateBreaking', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local ident = xPlayer.identifier
    local found1 = 0
    local found2 = 0
    for i = 1, #inJail, 1 do
        if inJail[i].Players[1] ~= nil then
            for j = 1, #inJail[i].Players, 1 do
                if inJail[i].Players[j].Player == ident then
                    found1 = i
                    found2 = j
                end
            end
        end
    end
    if found1 ~= 0 then
        inJail[found1].Players[found2].Breako = 0
    end
end)

RegisterServerEvent('advanced_jail:TaskComplete1')
AddEventHandler('advanced_jail:TaskComplete1', function(taskJob)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ident = xPlayer.identifier
    local ran = math.random(1, 10)
    local ranq = 0
    ranq = ran
    if ranq <= Config.JobOptions[taskJob].StealChance then
        local totNims = {}
        local totnums = 0
        for i = 1, #Config.JobOptions[taskJob].StealItems, 1 do
            for x = 1, Config.JobOptions[taskJob].StealItems[i].Chance, 1 do
                table.insert(totNims, {value = i})
            end
        end
        for i = 1, #totNims, 1 do
            totnums = totnums + 1
        end
        local rannym = math.random(1, totnums)
        local finish = 0
        finish = rannym
        xPlayer.addInventoryItem(Config.JobOptions[taskJob].StealItems[totNims[finish].value].Item, 1)
        TriggerClientEvent('esx:showNotification', source, Config.Sayings[86]..Config.JobOptions[taskJob].StealItems[totNims[finish].value].Name)
    end
end)

RegisterServerEvent('advanced_jail:LoadedIn')
AddEventHandler('advanced_jail:LoadedIn', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
        }, function(result)
        if result and result[1] and result[1].jail_data then
            local newData = json.decode(result[1].jail_data)
            if newData and newData.jailtime and newData.jailtime > 0 then
                TriggerEvent('advanced_jail:ReJail', _source, newData)
            end
        end
    end)
end)

RegisterServerEvent('advanced_jail:CheckSol')
AddEventHandler('advanced_jail:CheckSol', function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    local ident = xPlayer.identifier
    local cellies = {}
    local lowest = {val = 0, amtie = 30}
    local found1 = 0
    local found2 = 0
    for i = 1, #inJail, 1 do
        if inJail[i].Players[1] ~= nil then
            for j = 1, #inJail[i].Players, 1 do
                if inJail[i].Players[j].Player == ident then
                    found1 = i
                    found2 = j
                end
            end
        end
    end
    if found1 ~= 0 then
        if inJail[found1].Players[found2].Sol > 0 then
            for i = 1, #solJail, 1 do
                if solJail[i].Players ~= nil then
                    local total = 0
                    for p = 1, #solJail[i].Players, 1 do
                        total = total + 1
                    end
                    table.insert(cellies, {value = i, amt = total})
                else
                    table.insert(cellies, {value = i, amt = 0})
                end
            end
            for i = 1, #cellies, 1 do
                if cellies[i].amt < lowest.amtie then
                    lowest.val = cellies[i].value
                    lowest.amtie = cellies[i].amt
                end
            end
            table.insert(solJail[lowest.val].Players, {Player = ident})
            TriggerClientEvent('advanced_jail:SendSol', id, inJail[found1].Players[found2].Sol, lowest.val)
        else
            TriggerClientEvent('advanced_jail:NotSol', id)
        end
    end
end)

RegisterServerEvent('advanced_jail:SendToSol')
AddEventHandler('advanced_jail:SendToSol', function(id, tima, reasons)
    local xTarget = ESX.GetPlayerFromId(source)
    if xTarget == nil then
        local xPlayer = ESX.GetPlayerFromId(id)
        local ident = xPlayer.identifier
        local timaz = tima * 60
        local found = 0
        local found2 = 0
        for i = 1, #inJail, 1 do
            if inJail[i].Players[1] ~= nil then
                for j = 1, #inJail[i].Players, 1 do
                    if inJail[i].Players[j].Player == ident then
                        found = i
                        found2 = j
                    end
                end
            end
        end
        if found ~= 0 then
            MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
                }, function(result)
                local newData = nil
                local data = nil
                newData = json.decode(result[1].jail_data)
                newData.soli = timaz
                local cellies = {}
                local lowest = {val = 0, amtie = 30}
                for i = 1, #solJail, 1 do
                    if solJail[i].Players ~= nil then
                        local total = 0
                        for p = 1, #solJail[i].Players, 1 do
                            total = total + 1
                        end
                        table.insert(cellies, {value = i, amt = total})
                    else
                        table.insert(cellies, {value = i, amt = 0})
                    end
                end
                for i = 1, #cellies, 1 do
                    if cellies[i].amt < lowest.amtie then
                        lowest.val = cellies[i].value
                        lowest.amtie = cellies[i].amt
                    end
                end
                table.insert(solJail[lowest.val].Players, {Player = ident})
                inJail[found].Players[found2].Sol = timaz
                if Log.SendingSol then
                    if Config.SimpleTime then
                        local this = {
                            {
                                ["name"] = "**Player Name:**",
                                ["value"] = GetPlayerName(id),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player ID:**",
                                ["value"] = id,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player Identifier:**",
                                ["value"] = ident,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Solitary Time:**",
                                ["value"] = timaz..' (seconds)',
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Reason For Solitary:**",
                                ["value"] = reasons,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Solitary Cell:**",
                                ["value"] = lowest.val,
                                ["inline"] = true
                            },
                        }
                        sendToDiscord(this, 54783, "Player Going To Solitary")
                    else
                        local this = {
                            {
                                ["name"] = "**Player Name:**",
                                ["value"] = GetPlayerName(id),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player ID:**",
                                ["value"] = id,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player Identifier:**",
                                ["value"] = ident,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Solitary Time:**",
                                ["value"] = GetGoodTime(timaz),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Reason For Solitary:**",
                                ["value"] = reasons,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Solitary Cell:**",
                                ["value"] = lowest.val,
                                ["inline"] = true
                            },
                        }
                        sendToDiscord(this, 54783, "Player Going To Solitary")
                    end
                end
                data = json.encode(newData)
                TriggerClientEvent('advanced_jail:SendSol', id, timaz, lowest.val)
                MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier,
                    ['@jail_data'] = data
                })
            end)
        end
    else
        if CheckUser(source, 'solitary') then
            local xPlayer = ESX.GetPlayerFromId(id)
            local ident = xPlayer.identifier
            local timaz = tima * 60
            local found = 0
            local found2 = 0
            for i = 1, #inJail, 1 do
                if inJail[i].Players[1] ~= nil then
                    for j = 1, #inJail[i].Players, 1 do
                        if inJail[i].Players[j].Player == ident then
                            found = i
                            found2 = j
                        end
                    end
                end
            end
            if found ~= 0 then
                MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier
                    }, function(result)
                    local newData = nil
                    local data = nil
                    newData = json.decode(result[1].jail_data)
                    newData.soli = timaz
                    local cellies = {}
                    local lowest = {val = 0, amtie = 30}
                    for i = 1, #solJail, 1 do
                        if solJail[i].Players ~= nil then
                            local total = 0
                            for p = 1, #solJail[i].Players, 1 do
                                total = total + 1
                            end
                            table.insert(cellies, {value = i, amt = total})
                        else
                            table.insert(cellies, {value = i, amt = 0})
                        end
                    end
                    for i = 1, #cellies, 1 do
                        if cellies[i].amt < lowest.amtie then
                            lowest.val = cellies[i].value
                            lowest.amtie = cellies[i].amt
                        end
                    end
                    table.insert(solJail[lowest.val].Players, {Player = ident})
                    inJail[found].Players[found2].Sol = timaz
                    if Log.SendingSol then
                        if Config.SimpleTime then
                            local this = {
                                {
                                    ["name"] = "**Player Name:**",
                                    ["value"] = GetPlayerName(id),
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Player ID:**",
                                    ["value"] = id,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Player Identifier:**",
                                    ["value"] = ident,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Solitary Time:**",
                                    ["value"] = timaz..' (seconds)',
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Reason For Solitary:**",
                                    ["value"] = reasons,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Solitary Cell:**",
                                    ["value"] = lowest.val,
                                    ["inline"] = true
                                },
                            }
                            sendToDiscord(this, 54783, "Player Going To Solitary")
                        else
                            local this = {
                                {
                                    ["name"] = "**Player Name:**",
                                    ["value"] = GetPlayerName(id),
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Player ID:**",
                                    ["value"] = id,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Player Identifier:**",
                                    ["value"] = ident,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Solitary Time:**",
                                    ["value"] = GetGoodTime(timaz),
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Reason For Solitary:**",
                                    ["value"] = reasons,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Solitary Cell:**",
                                    ["value"] = lowest.val,
                                    ["inline"] = true
                                },
                            }
                            sendToDiscord(this, 54783, "Player Going To Solitary")
                        end
                    end
                    data = json.encode(newData)
                    TriggerClientEvent('advanced_jail:SendSol', id, timaz, lowest.val)
                    MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier,
                        ['@jail_data'] = data
                    })
                end)
            end
        else
            local _source = source
            TriggerClientEvent('advanced_jail:SendNotif', _source, Config.Sayings[159])
        end
    end
end)

RegisterServerEvent('advanced_jail:UnSol')
AddEventHandler('advanced_jail:UnSol', function(id)
    local xTarget = ESX.GetPlayerFromId(source)
    if xTarget == nil then
        local xPlayer = ESX.GetPlayerFromId(id)
        local ident = xPlayer.identifier
        local found = 0
        local found2 = 0
        local found3 = 0
        local found4 = 0
        for i = 1, #inJail, 1 do
            if inJail[i].Players[1] ~= nil then
                for j = 1, #inJail[i].Players, 1 do
                    if inJail[i].Players[j].Player == ident then
                        found = i
                        found2 = j
                    end
                end
            end
        end
        for i = 1, #solJail, 1 do
            if solJail[i].Players[1] ~= nil then
                for j = 1, #solJail[i].Players, 1 do
                    if solJail[i].Players[j].Player == ident then
                        found3 = i
                        found4 = j
                    end
                end
            end
        end
        if found3 ~= 0 then
            table.remove(solJail[found3].Players, found4)
        end
        if found ~= 0 then
            if Log.SendingSol then
                local this = {
                    {
                        ["name"] = "**Player Name:**",
                        ["value"] = GetPlayerName(id),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player ID:**",
                        ["value"] = id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Identifier:**",
                        ["value"] = ident,
                        ["inline"] = true
                    },
                }
                sendToDiscord(this, 2303, "Player Being Removed From Solitary")
            end
            MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
                }, function(result)
                local newData = nil
                local data = nil
                newData = json.decode(result[1].jail_data)
                newData.soli = 0
                data = json.encode(newData)
                TriggerClientEvent('advanced_jail:UnnSol', id)
                MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier,
                    ['@jail_data'] = data
                })
            end)
        end
    else
        if CheckUser(source, 'unsolitary') then
            local xPlayer = ESX.GetPlayerFromId(source)
            local ident = xPlayer.identifier
            local found = 0
            local found2 = 0
            local found3 = 0
            local found4 = 0
            for i = 1, #inJail, 1 do
                if inJail[i].Players[1] ~= nil then
                    for j = 1, #inJail[i].Players, 1 do
                        if inJail[i].Players[j].Player == ident then
                            found = i
                            found2 = j
                        end
                    end
                end
            end
            for i = 1, #solJail, 1 do
                if solJail[i].Players[1] ~= nil then
                    for j = 1, #solJail[i].Players, 1 do
                        if solJail[i].Players[j].Player == ident then
                            found3 = i
                            found4 = j
                        end
                    end
                end
            end
            if found3 ~= 0 then
                table.remove(solJail[found3].Players, found4)
            end
            if found ~= 0 then
                if Log.SendingSol then
                    local this = {
                        {
                            ["name"] = "**Player Name:**",
                            ["value"] = GetPlayerName(id),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player ID:**",
                            ["value"] = id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player Identifier:**",
                            ["value"] = ident,
                            ["inline"] = true
                        },
                    }
                    sendToDiscord(this, 2303, "Player Being Removed From Solitary")
                end
                MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier
                    }, function(result)
                    local newData = nil
                    local data = nil
                    newData = json.decode(result[1].jail_data)
                    newData.soli = 0
                    data = json.encode(newData)
                    TriggerClientEvent('advanced_jail:UnnSol', id)
                    MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier,
                        ['@jail_data'] = data
                    })
                end)
            end
        else
            local _source = source
            TriggerClientEvent('advanced_jail:SendNotif', _source, Config.Sayings[159])
        end
    end
end)

ESX.RegisterServerCallback('advanced_jail:CheckItemMake', function(source, cb, num)
    local xPlayer = ESX.GetPlayerFromId(source)
    local totnum = 0
    for i = 1, #Config.Crafts[num].Needed, 1 do
        totnum = totnum + 1
        if xPlayer.getInventoryItem(Config.Crafts[num].Needed[i].Item).count >= Config.Crafts[num].Needed[i].Amount then
            totnum = totnum - 1
        end
    end
    if totnum <= 0 then
        if xPlayer.canCarryItem(Config.Crafts[num].MakeItem, 1) then
            cb(3)
        else
            cb(2)
        end
    else
        cb(1)
    end
end)

ESX.RegisterServerCallback('advanced_jail:CheckItemB', function(source, cb, num)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem(Config.RoomTools[num].Item).count >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('advanced_jail:CheckLockdown', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local elo = {}
    if CheckUser(xPlayer.source, 'jail') then
        table.insert(elo, {label = Config.Sayings[128], value = 'jailplayer'})
    end
    if CheckUser(xPlayer.source, 'unjail') then
        table.insert(elo, {label = Config.Sayings[129], value = 'unjail'})
    end
    if CheckUser(xPlayer.source, 'add') then
        table.insert(elo, {label = Config.Sayings[130], value = 'add'})
    end
    if CheckUser(xPlayer.source, 'remove') then
        table.insert(elo, {label = Config.Sayings[131], value = 'remove'})
    end
    if CheckUser(xPlayer.source, 'solitary') then
        table.insert(elo, {label = Config.Sayings[132], value = 'solitary'})
    end
    if CheckUser(xPlayer.source, 'unsolitary') then
        table.insert(elo, {label = Config.Sayings[144], value = 'unsolitary'})
    end
    if CheckUser(xPlayer.source, 'lockdown') then
        if lockdown then
            table.insert(elo, {label = Config.Sayings[145] .. ' <span style="color:green;">'..Config.Sayings[146], value = 'lockdown'})
        else
            table.insert(elo, {label = Config.Sayings[145] .. ' <span style="color:red;">'..Config.Sayings[147], value = 'lockdown'})
        end
    end
    if CheckUser(xPlayer.source, 'message') then
        table.insert(elo, {label = Config.Sayings[165], value = 'mssg'})
    end
    cb(elo)
end)

RegisterServerEvent('advanced_jail:SwitchLock')
AddEventHandler('advanced_jail:SwitchLock', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    if CheckUser(_source, 'lockdown') then
        if lockCount > 0 then
            TriggerClientEvent('advanced_jail:SendNotif', _source, Config.Sayings[148])
        else
            if lockDown then
                TriggerClientEvent('advanced_jail:SendNotif', _source, Config.Sayings[151])
                lockDown = false
                TriggerClientEvent('advanced_jail:TurnOffLock', -1)
            else
                TriggerClientEvent('advanced_jail:SendNotif', _source, Config.Sayings[153]..Config.StartLockCount..Config.Sayings[154])
                StartLockDown()
            end
        end
    else
        TriggerClientEvent('advanced_jail:SendNotif', _source, Config.Sayings[159])
    end
end)

function StartLockDown()
    lockCount = Config.StartLockCount
    TriggerClientEvent('advanced_jail:CountWarn', -1, Config.StartLockCount)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            if lockCount > 0 then
                lockCount = lockCount - 1
                for i = 1, #Config.WarnLockNums, 1 do
                    if lockCount == Config.WarnLockNums[i] then
                        for j = 1, #inJail, 1 do
                            for k = 1, #inJail[j].Players, 1 do
                                if inJail[j].Players[k] then
                                    TriggerClientEvent('advanced_jail:CountWarn', inJail[j].Players[k].ID, Config.WarnLockNums[i])
                                end
                            end
                        end
                    end
                end
            else
                lockDown = true
                TriggerClientEvent('advanced_jail:CountFinish', -1)
                break
            end
        end
    end)
end

ESX.RegisterServerCallback('advanced_jail:CheckItemB2', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem(item).count >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('advanced_jail:TakeItems4')
AddEventHandler('advanced_jail:TakeItems4', function(itnuma)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(Config.RoomTools[itnuma].Item, 1)
end)

RegisterServerEvent('advanced_jail:TakeItems2')
AddEventHandler('advanced_jail:TakeItems2', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, 1)
end)

RegisterServerEvent('advanced_jail:SuccessFul')
AddEventHandler('advanced_jail:SuccessFul', function(id, time)
    local xPlayer = ESX.GetPlayerFromId(id)
    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
        }, function(result)
        local newData = nil
        local data = nil
        newData = json.decode(result[1].jail_data)
        if Log.Breaking then
            local this = {
                {
                    ["name"] = "**Player Name:**",
                    ["value"] = GetPlayerName(id),
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player ID:**",
                    ["value"] = id,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player Identifier:**",
                    ["value"] = ident,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Current Amount Of Breaks:**",
                    ["value"] = newData.breaks,
                    ["inline"] = true
                },
                {
                    ["name"] = "**New Amount Of Breaks:**",
                    ["value"] = newData.breaks + 1,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Needed Breaks To Breakout:**",
                    ["value"] = Config.BreakHole,
                    ["inline"] = true
                },
            }
            sendToDiscord(this, 30719, "Player Successfully Digging In Wall")
        end

        newData.breaks = newData.breaks + 1
        data = json.encode(newData)
        TriggerClientEvent('advanced_jail:UpBreaks', id, newData.breaks, true, time)
        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
            ['@jail_data'] = data
        })
    end)
end)

RegisterServerEvent('advanced_jail:TakeItems')
AddEventHandler('advanced_jail:TakeItems', function(itnuma)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ident = xPlayer.identifier
    local id = xPlayer.source
    if Log.Craft then
        local this = {
            {
                ["name"] = "**Player Name:**",
                ["value"] = GetPlayerName(id),
                ["inline"] = true
            },
            {
                ["name"] = "**Player ID:**",
                ["value"] = id,
                ["inline"] = true
            },
            {
                ["name"] = "**Player Identifier:**",
                ["value"] = ident,
                ["inline"] = true
            },
            {
                ["name"] = "**Item Being Crafted:**",
                ["value"] = Config.Crafts[itnuma].Name,
                ["inline"] = true
            },
        }
        sendToDiscord(this, 7799039, "Player Crafting Item")
    end

    for i = 1, #Config.Crafts[itnuma].Needed, 1 do
        xPlayer.removeInventoryItem(Config.Crafts[itnuma].Needed[i].Item, Config.Crafts[itnuma].Needed[i].Amount)
    end
    xPlayer.addInventoryItem(Config.Crafts[itnuma].MakeItem, 1)
end)

--Discord
function sendToDiscord(field, colour, titles, ur)
    local urls = nil
    if ur ~= nil then
        urls = ur
    else
        urls = "https://imgur.com/WFyOaoY.png"
    end
    local embed = {
        {
            ["fields"] = field,
            ["color"] = colour,
            ["title"] = titles,
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Timestamp: "..os.date("%x %X %p"),
            },
            ["thumbnail"] = {
                ["url"] = urls,
            },
        },
    }
    PerformHttpRequest(webhookid, function(err, text, headers) end, 'POST', json.encode({username = "Bolingbroke Penitentiary", embeds = embed, avatar_url = "https://imgur.com/WFyOaoY.png"}), {['Content-Type'] = 'application/json'})
end
exports('sendToDiscord', sendToDiscord)

function GetGoodTime(timo)
    local dope = {Hours = 0, Mins = 0, Seconds = 0}
    local msg = nil
    local duration = timo
    local extraSeconds = duration % 60
    local minutes = (duration - extraSeconds) / 60
    if duration >= 60 then
        if minutes >= 60 then
            local extraMinutes = minutes % 60
            local hours = (minutes - extraMinutes) / 60
            dope.Hours = math.floor(hours)
            dope.Mins = math.ceil(extraMinutes)
            dope.Seconds = extraSeconds
        else
            dope.Hours = 0
            dope.Mins = math.floor(minutes)
            dope.Seconds = extraSeconds
        end
    else
        dope.Hours = 0
        dope.Mins = 0
        dope.Seconds = timo
    end
    msg = dope.Hours..'H '..dope.Mins..'M '..dope.Seconds..'S '
    return msg
end
exports('GetGoodTime', GetGoodTime)

function CheckUser(yupiue, checkfor)
    local xPlayer = ESX.GetPlayerFromId(yupiue)
    local wegood = false

    if Config.PoliceRoles[xPlayer.job.name] then
        if checkfor == 'jail' then
            for j = 1, #Config.PoliceRanks.Jailing, 1 do
                if xPlayer.job.name == Config.PoliceRanks.Jailing[j].Job and xPlayer.job.grade >= Config.PoliceRanks.Jailing[j].Grade then
                    wegood = true
                end
            end
        elseif checkfor == 'unjail' then
            for j = 1, #Config.PoliceRanks.UnJail, 1 do
                if xPlayer.job.name == Config.PoliceRanks.UnJail[j].Job and xPlayer.job.grade >= Config.PoliceRanks.UnJail[j].Grade then
                    wegood = true
                end
            end
        elseif checkfor == 'add' then
            for j = 1, #Config.PoliceRanks.AddTime, 1 do
                if xPlayer.job.name == Config.PoliceRanks.AddTime[j].Job and xPlayer.job.grade >= Config.PoliceRanks.AddTime[j].Grade then
                    wegood = true
                end
            end
        elseif checkfor == 'remove' then
            for j = 1, #Config.PoliceRanks.RemoveTime, 1 do
                if xPlayer.job.name == Config.PoliceRanks.RemoveTime[j].Job and xPlayer.job.grade >= Config.PoliceRanks.RemoveTime[j].Grade then
                    wegood = true
                end
            end
        elseif checkfor == 'solitary' then
            for j = 1, #Config.PoliceRanks.Send2Solitary, 1 do
                if xPlayer.job.name == Config.PoliceRanks.Send2Solitary[j].Job and xPlayer.job.grade >= Config.PoliceRanks.Send2Solitary[j].Grade then
                    wegood = true
                end
            end
        elseif checkfor == 'unsolitary' then
            for j = 1, #Config.PoliceRanks.RemoveFromSolitary, 1 do
                if xPlayer.job.name == Config.PoliceRanks.RemoveFromSolitary[j].Job and xPlayer.job.grade >= Config.PoliceRanks.RemoveFromSolitary[j].Grade then
                    wegood = true
                end
            end
        elseif checkfor == 'lockdown' then
            for j = 1, #Config.PoliceRanks.Lockdown, 1 do
                if xPlayer.job.name == Config.PoliceRanks.Lockdown[j].Job and xPlayer.job.grade >= Config.PoliceRanks.Lockdown[j].Grade then
                    wegood = true
                end
            end
        elseif checkfor == 'message' then
            for j = 1, #Config.PoliceRanks.Message, 1 do
                if xPlayer.job.name == Config.PoliceRanks.Message[j].Job and xPlayer.job.grade >= Config.PoliceRanks.Message[j].Grade then
                    wegood = true
                end
            end
        end
    end

    for i = 1, #adminRoles, 1 do
        if xPlayer.getGroup() == adminRoles[i] then
            if checkfor == 'jail' then
                for j = 1, #adminAbilities.Jailing, 1 do
                    if xPlayer.getGroup() == adminAbilities.Jailing[j] then
                        wegood = true
                    end
                end
            elseif checkfor == 'unjail' then
                for j = 1, #adminAbilities.UnJail, 1 do
                    if xPlayer.getGroup() == adminAbilities.UnJail[j] then
                        wegood = true
                    end
                end
            elseif checkfor == 'add' then
                for j = 1, #adminAbilities.AddTime, 1 do
                    if xPlayer.getGroup() == adminAbilities.AddTime[j] then
                        wegood = true
                    end
                end
            elseif checkfor == 'remove' then
                for j = 1, #adminAbilities.RemoveTime, 1 do
                    if xPlayer.getGroup() == adminAbilities.RemoveTime[j] then
                        wegood = true
                    end
                end
            elseif checkfor == 'solitary' then
                for j = 1, #adminAbilities.Send2Solitary, 1 do
                    if xPlayer.getGroup() == adminAbilities.Send2Solitary[j] then
                        wegood = true
                    end
                end
            elseif checkfor == 'unsolitary' then
                for j = 1, #adminAbilities.RemoveFromSolitary, 1 do
                    if xPlayer.getGroup() == adminAbilities.RemoveFromSolitary[j] then
                        wegood = true
                    end
                end
            elseif checkfor == 'lockdown' then
                for j = 1, #adminAbilities.Lockdown, 1 do
                    if xPlayer.getGroup() == adminAbilities.Lockdown[j] then
                        wegood = true
                    end
                end
            elseif checkfor == 'message' then
                for j = 1, #adminAbilities.Message, 1 do
                    if xPlayer.getGroup() == adminAbilities.Message[j] then
                        wegood = true
                    end
                end
            end
        end
    end
    if wegood then
        return true
    else
        return false
    end
end
exports('CheckUser',CheckUser)
