if GetResourceState('es_extended') ~= 'started' then return end

local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterUsableItem(Config.Items.note, function(source, item)
    local hasNotepad = hasNotepadItem(source)
    local metadata = item.metadata or {}
    TriggerClientEvent("cw-notes:client:openNote", source, metadata, hasNotepad)
end)

ESX.RegisterUsableItem(Config.Items.notepad, function(source, item)
    TriggerClientEvent("cw-notes:client:openInteraction", source)
end)

function hasNotepadItem(src)
    if Config.Inventory == 'ox' then
        local amount = exports.ox_inventory:GetItemCount(src, Config.Items.notepad)
        if Config.Debug then print('Has notepad: ', amount > 0) end
        return amount > 0
    else
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return false end
    
        local item = xPlayer.getInventoryItem(Config.Items.notepad)
        if item and item.count >= 1 then
            return true
        end
    
        return false
    end
end

function addNote(src, metadata)
    
    if Config.Inventory == 'ox' then
        local pped = GetPlayerPed(src)
        local coords = GetEntityCoords(pped)
    
        if exports.ox_inventory:CanCarryItem(src, Config.Items.note, 1) then
            return exports.ox_inventory:AddItem(src, Config.Items.note, 1, metadata)
        else
            local item = { name = Config.Items.note, amount = 1, metadata = metadata }
            exports.ox_inventory:CustomDrop("cw-craft", { item }, coords)
        end
    else
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addInventoryItem(Config.Items.note, 1, metadata)
        end
    end

end