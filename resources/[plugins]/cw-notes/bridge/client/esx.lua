if GetResourceState('es_extended') ~= 'started' then return end
if Config.Debug then print('Using ESX bridge') end

local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent("esx:playerLoaded", function()
    if Config.Inventory == 'ox' then
        exports.ox_inventory:displayMetadata('title', 'Title')
    end
end)

function notify(text, type)
    if Config.OxLibNotify then
        lib.notify({
            title = text,
            type = type,
        })
    else
        ESX.ShowNotification(text, type)
    end
end