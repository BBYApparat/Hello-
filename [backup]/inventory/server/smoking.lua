local AntiAbusers = {}

local Smokers = {
    {Item = "cubancigar",        Prop = 'prop_cigar_01',          Size = 20, Type = 'cigar',     Time = 120000 },
    {Item = "slimcigarette",     Prop = 'ng_proc_cigarette01a',   Size = 20, Type = 'cigarette', Time = 120000 },
    {Item = "cigarette",         Prop = 'ng_proc_cigarette01a',   Size = 20, Type = 'cigarette', Time = 120000 },
    {Item = "joint",             Prop = 'prop_sh_joint_01',       Size = 20, Type = 'joint',     Time = 120000 },
    {Item = "vape",              Prop = 'ba_prop_battle_vape_01', Size = 0,  Type = 'vape',      Time = 0 },
    {Item = "bong",              Prop = 'prop_bong_01',           Size = 0,  Type = 'bong',      Time = 0 },
}

local Lighters = {
    'lighter',
    'zippo'
}

local cigarettePackages = {
    { name = "slimcigarettepack",  toGive = "slimcigarette" },
    { name = "cigarettepack",      toGive = "cigarette"     },
    { name = "cubancigarettepack", toGive = "cubancigar"    },
}

for i=1, #Smokers, 1 do
    ESX.RegisterUsableItem(Smokers[i].Item, function(source, srcitem)
        src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local item = Smokers[i].Item
        local prop = Smokers[i].Prop
        local size = Smokers[i].Size
        local type = Smokers[i].Type
        local time = Smokers[i].Time
        if type == 'vape' or type == 'bong' then
            xPlayer.triggerEvent('smoking_sys:client:Smoke', item, size, prop, type, time)
        elseif type == 'cigar' or type == 'cigarette' or type == 'joint' then
            for i=1,#Lighters do
                local reqitem = xPlayer.GetItemByName(Lighters[i])
                if reqitem and reqitem.amount and reqitem.amount > 0 and reqitem.info and reqitem.info.uses and reqitem.info.uses > 0 then
                    xPlayer.triggerEvent('smoking_sys:client:Smoke', item, size, prop, type, time)
                    local info = reqitem.info
                    info.uses = info.uses - 1
                    xPlayer.updateItemData(reqitem.slot, info)
                    xPlayer.removeInventoryItem(Smokers[i].Item, 1, srcitem.slot)
                    return
                end
            end
            xPlayer.showNotification('You need a lighter to light up the cigarette', 'error')
        end
    end)
end

for k,v in pairs(cigarettePackages) do
    ESX.RegisterUsableItem(v.name, function(source, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = xPlayer.GetItemBySlot(item.slot)
        if item.name == v.name then
            local info = item.info
            if info.cigarettes and info.cigarettes > 0 then
                if xPlayer.canCarryItem(v.toGive, 1) then
                    xPlayer.addInventoryItem(v.toGive, 1)
                    xPlayer.ItemBox(v.toGive, "add", 1)
                    info.cigarettes = info.cigarettes - 1
                    if info.cigarettes == 0 then
                        xPlayer.removeInventoryItem(v.name, 1, item.slot)
                    else
                        xPlayer.updateItemData(item.slot, info)
                    end
                    xPlayer.triggerEvent('smoking_sys:client:CigarettesUnPack')
                else
                    xPlayer.showNotification('You have not enough space', 'error')
                end
            end
        end
    end)
end

RegisterServerEvent("smoking_sys:server:RemoveItem", function(item, size, prop, type, time)
    src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.hasInventoryItem(item, 1) then
        xPlayer.removeInventoryItem(item, 1)
    end
end)

RegisterServerEvent("smoking_sys:server:CheckItem", function(type, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local foundLiq = false
    for i=1,#Config.Smoking.Liquids do
        if Config.Smoking.Liquids[i] == item then
            foundLiq = true
            break
        end
    end
	local liquid = xPlayer.GetItemByName(item)
    if liquid and liquid.amount > 0 then
        local info = liquid.info
        local shouldRemove = false
        if info and info.shots and info.shots > 0 then
            info.shots = info.shots - 5
        else
            xPlayer.showNotification('This bottle is empty', 'error')
            return
        end
        if info.shots == 0 then
            shouldRemove = true
        end
        if not shouldRemove then
            xPlayer.updateItemData(liquid.slot, info)
        else
            xPlayer.removeInventoryItem(item, 1, liquid.slot)
            xPlayer.ItemBox(item, "remove", 1)
        end
        xPlayer.triggerEvent('smoking_sys:client:AddLiquid')
    else
        xPlayer.showNotification('You need liquid', 'error')
    end
end)

RegisterServerEvent("smoking_sys:server:checkbong", function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.GetItemByName(itemName)
	if xItem and xItem.amount > 0 then
        xPlayer.removeInventoryItem(xItem.name, 1)
        xPlayer.triggerEvent('smoking_sys:client:AddBong')
    else
        xPlayer.showNotification('You do not have this item', 'error')
		return
	end
end)

RegisterServerEvent('smoking_sys:server:Receiver', function(target, item, size, prop, type, time)
    local xPlayer = ESX.GetPlayerFromId(source)
    if target == -1 then
        xPlayer.ban('smoking_sys:server:Receiver')
        return
    end
    local coords1 = GetEntityCoords(GetPlayerPed(source))
    local coords2 = GetEntityCoords(GetPlayerPed(target))
    if #(vector2(coords1.x, coords1.y) - vector2(coords2.x, coords2.y)) < 10.0 then
        local xTarget = ESX.GetPlayerFromId(target)
        AntiAbusers[xTarget.identifier] = {item = item, size = size, prop = prop, type = type, time = time}
        if xTarget then
            xTarget.triggerEvent("smoking_sys:client:Receiver", item, size, prop, type, time)
        end
    end
end)

RegisterServerEvent("smoking_sys:server:AddItem", function(item, size, prop, type, time)
    src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local isLegit = AntiAbusers[xPlayer.identifier]
    if not isLegit then
        xPlayer.ban("smoking_sys:server:AddItem")
        return
    end
    if isLegit.item == item and isLegit.size == size and isLegit.prop == prop and isLegit.type == type and isLegit.time == time then
        xPlayer.addInventoryItem(item, 1)
    else
        xPlayer.ban("smoking_sys:server:AddItem2")
    end
end)

RegisterServerEvent("smoking_sys:server:StartPropSmoke", function(propsmoke, type)
    TriggerClientEvent("smoking_sys:client:StartPropSmoke", -1, propsmoke, type)
end)

RegisterServerEvent("smoking_sys:server:StopPropSmoke", function(propsmoke)
    TriggerClientEvent("smoking_sys:client:StopPropSmoke", -1, propsmoke)
end)

RegisterServerEvent("smoking_sys:server:StartMouthSmoke", function(mouthsmoke, type)
    TriggerClientEvent("smoking_sys:client:StartMouthSmoke", -1, mouthsmoke, type)
end)

RegisterServerEvent("smoking_sys:server:StopMouthSmoke", function(mouthsmoke)
    TriggerClientEvent("smoking_sys:client:StopMouthSmoke", -1, mouthsmoke)
end)