CreateThread(function()
    if GetResourceState("ox_inventory") == "started" then
        exports.ox_inventory:displayMetadata(Config.OxMeta)
    end
end)