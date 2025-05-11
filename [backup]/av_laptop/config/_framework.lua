Config = Config or {}
Config.Framework = nil -- Don't edit this

CreateThread(function()
    if GetResourceState("qb-core") ~= "missing" then
        Config.Framework = "qb"
        Core = exports['qb-core']:GetCoreObject()
        return
    end
    if GetResourceState("es_extended") ~= "missing" then
        Config.Framework = "esx"
        Core = exports['es_extended']:getSharedObject()
        return
    end
    print("^3[ERROR]^7 No Framework loaded...please verify config/_framework.lua")
    print("^3[ERROR]^7 No Framework loaded...please verify config/_framework.lua")
    print("^3[ERROR]^7 No Framework loaded...please verify config/_framework.lua")
end)