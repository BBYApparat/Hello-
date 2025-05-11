CreateThread(function()
    for k, info in pairs(Config.Crafting) do
        local blipData = info.blipData
        local craftLocations = info.locations
        local craftSettings = info.settings
        if craftLocations and blipData and blipData.enabled then
            for i=1,#craftLocations do
                local isAuthorized = true
                if craftSettings.requiredJob then
                    if type(craftSettings.requiredJob) == "string" then
                        if craftSettings.requiredJob ~= PlayerData.job.name then
                            isAuthorized = false
                        end
                    else
                        if not craftSettings.requiredJob[PlayerData.job.name] then
                            isAuthorized = false
                        elseif craftSettings.requiredJob[PlayerData.job.name] and craftSettings.requiredJob[PlayerData.job.name] > PlayerData.job.grade then
                            isAuthorized = false
                        end
                    end
                end
                if isAuthorized then
                    local craft_loc = craftLocations[i]
                    blip = AddBlipForCoord(craft_loc.x, craft_loc.y, craft_loc.z)
                    SetBlipSprite(blip, blipData.sprite)
                    SetBlipColour(blip, blipData.color)
                    SetBlipDisplay(blip, 4)
                    SetBlipScale(blip, blipData.scale)
                    SetBlipAsShortRange(blip, blipData.short)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName(blipData.text)
                    EndTextCommandSetBlipName(blip)
                end
            end
        end
        if craftLocations then
            for i=1,#craftLocations do
                local craft_loc = craftLocations[i]
                local authorizedJobs = {}
                if craftSettings.requiredJob then
                    if type(craftSettings.requiredJob) == "string" then
                        authorizedJobs[craftSettings.requiredJob] = tonumber(0)
                    else
                        for k,v in pairs(craftSettings.requiredJob) do
                            authorizedJobs[k] = tonumber(v)
                        end
                    end
                else
                    authorizedJobs = nil
                end
                exports[Config.TargetResource]:AddBoxZone(k.."_"..i, vector3(craft_loc.x, craft_loc.y, craft_loc.z), 0.75, 0.75, {
                    name = k.."_"..i,
                    heading = craft_loc.h,
                    minZ = craft_loc.z - 1.5,
                    maxZ = craft_loc.z + 1.5,
                },{
                    distance = 2.5,
                    options = {
                        {
                            type = "client",
                            event = "inventory:openGeneralCrafting",
                            icon = "fas fa-screwdriver-wrench",
                            label = "Open Crafting Bench",
                            job = authorizedJobs,                    
                            canInteract = function(entity, distance, data) -- This will check if you can interact with it, this won't show up if it returns false, this is OPTIONAL
                                if authorizedJobs ~= nil and authorizedJobs[PlayerData.job.name] and authorizedJobs[PlayerData.job.name] <= PlayerData.job.grade then
                                    return true
                                elseif authorizedJobs == nil then
                                    return true
                                end
                                return false
                            end,
                        },
                    },
                })
            end 
        end
    end
end)

RegisterNetEvent("inventory:openGeneralCrafting", function()
    OpenCrafting("general_crafting")
end)

RegisterNetEvent('inventory:client:CraftItems', function(itemName, itemCosts, amount, toSlot, label)
    local ped = PlayerPedId()
    SendNUIMessage({action = "close"})
    isCrafting = true
    local timer = math.random(5000, 10000)
    local animations = Config.Animations.crafting
    local dict, anim, flags = animations.general.dict, animations.general.anim, 48
    if string.match(label:lower(), "cook") then
        dict = animations.food.dict
        anim = animations.food.anim
        flags = (48 and dict ~= nil) or 0
        if not dict and animations.food.scenario then
            TaskStartScenarioInPlace(ped, animations.food.scenario, 0, false)
        end
    elseif string.match(label:lower(), "drink") then
        dict = animations.drinks.dict
        anim = animations.drinks.anim
        flags = (48 and dict ~= nil) or 0
        if not dict and animations.drinks.scenario then
            TaskStartScenarioInPlace(ped, animations.drinks.scenario, 0, false)
        end
    else
        if not dict and animations.general.scenario then
            TaskStartScenarioInPlace(ped, animations.general.scenario, 0, false)
        end
    end
    ProgressBar("Crafting...", (timer*amount), {whileDead = false, canCancel = false, movement = true, dict = dict, anim = anim, flags = flags}, function(cancelled)
        if not cancelled then
            isCrafting = false
            TriggerServerEvent("inventory:server:CraftItems", itemName, itemCosts, amount, toSlot)
            ClearPedTasks(PlayerPedId())
        end
    end)
end)

function OpenCrafting(craft_Id)
    local crafting = {}
    local craftingData = Config.Crafting[craft_Id]
    if not craftingData then
        print("Your Crafting table with ID ("..craft_Id..') is not registered into Config.Crafting')
        return
    end
    crafting.label = craftingData.label
    crafting.items = GetCraftingItemInfos(Config.Crafting[craft_Id].items)
    TriggerServerEvent("inventory:server:OpenInventory", "crafting", craft_Id, crafting)
end

exports("OpenCrafting", OpenCrafting)

function GetCraftingItemInfos(data)
    BuildCraftItemInfos(data)
    Wait(200)
    local items = {}
	for k, item in pairs(Config.CraftingItems) do
        items[k] = Config.CraftingItems[k]
	end
	return items
end

function BuildCraftItemInfos(data)
    local itemInfos = {}
    for i=1, #data do
        itemInfos[i] = {}
        local text = " "
        for k,v in pairs(data[i].costs) do
            if v.name:lower() == "money" then
                text = text.. "Cash: $"..v.count..'. '
            else
                text = text.. ESX.Shared.Items[v.name:lower()].label.. ": x"..v.count..". "
            end
        end
        itemInfos[i].costs = text
    end
    local items = {}
    for k, item in ipairs(data) do
        local itemInfo = ESX.Shared.Items[item.name:lower()]
        if itemInfo then
            items[item.slot] = {
                name = itemInfo.name,
                amount = 500,
                info = itemInfos[item.slot],
                label = itemInfo.label,
                weight = itemInfo.weight,
                type = itemInfo.type,
                unique = itemInfo.unique,
                usable = itemInfo.usable,
                image = itemInfo.image,
                slot = item.slot,
                costs = item.costs,
                threshold = item.threshold,
                points = item.points,
            }
        end
    end
    Config.CraftingItems = items
end

-- Combine

RegisterNUICallback("combineItem", function(data)
    Wait(150)
    TriggerServerEvent('inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(ESX.Shared.Items[data.item])
end)

RegisterNUICallback('combineWithAnim', function(data)
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut
    ped = PlayerPedId()
    ProgressBar(animText, animTimeout, {dict = aDict, anim = aLib, flags = 16, whileDead = false, canCancel = false}, function(cancelled)
        if not cancelled then
            StopAnimTask(ped, aDict, aLib, 1.0)
            TriggerServerEvent('inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem)
        else
            StopAnimTask(ped, aDict, aLib, 1.0)
        end
    end)
end)