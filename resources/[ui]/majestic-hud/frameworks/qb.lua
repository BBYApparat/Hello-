local QBCore = exports['qb-core']:GetCoreObject()

local Framework = {}
Framework.__index = Framework

function Framework.new()
    local self = setmetatable({}, Framework)
    self.playerData = QBCore.Functions.GetPlayerData()
    self.stats = {
        hunger = self.playerData.metadata.hunger or 0,
        thirst = self.playerData.metadata.thirst or 0,
        stress = self.playerData.metadata.stress or 0
    }
    
    -- QBCore Player Loading
    RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
        Wait(2000)
        self.playerData = QBCore.Functions.GetPlayerData()
        self.stats.hunger = self.playerData.metadata.hunger
        self.stats.thirst = self.playerData.metadata.thirst
        self.stats.stress = self.playerData.metadata.stress
    end)
    
    RegisterNetEvent("QBCore:Client:OnPlayerUnload", function()
        self.playerData = {}
    end)
    
    RegisterNetEvent("QBCore:Player:SetPlayerData", function(val)
        self.playerData = val
        self.stats.hunger = self.playerData.metadata.hunger
        self.stats.thirst = self.playerData.metadata.thirst
        self.stats.stress = self.playerData.metadata.stress
    end)
    
    -- Update needs event
    RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
        self.stats.hunger = newHunger
        self.stats.thirst = newThirst
    end)
    
    -- Update stress event
    RegisterNetEvent('hud:client:UpdateStress', function(newStress)
        self.stats.stress = newStress
    end)
    
    return self
end

function Framework:getPlayerData()
    return self.playerData
end

function Framework:getStats()
    return self.stats
end

function Framework:isPlayerLoaded()
    return self.playerData and next(self.playerData) ~= nil
end

function Framework:triggerStressGain(amount)
    TriggerServerEvent('hud:server:GainStress', amount)
end

return Framework