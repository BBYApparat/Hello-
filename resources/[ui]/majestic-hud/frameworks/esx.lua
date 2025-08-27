local ESX = exports['es_extended']:getSharedObject()

local Framework = {}
Framework.__index = Framework

function Framework.new()
    local self = setmetatable({}, Framework)
    self.playerData = {}
    self.stats = {
        hunger = 0,
        thirst = 0,
        stress = 0
    }
    
    -- Listen for ESX status updates
    AddEventHandler("esx_status:onTick", function(data)
        for i = 1, #data do
            if data[i].name == "hunger" then
                self.stats.hunger = math.floor(data[i].percent)
            elseif data[i].name == "thirst" then
                self.stats.thirst = math.floor(data[i].percent)
            elseif data[i].name == "stress" then
                self.stats.stress = math.floor(data[i].percent)
            end
        end
    end)
    
    -- ESX Player Loading
    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        self.playerData = xPlayer
    end)
    
    RegisterNetEvent('esx:onPlayerLogout', function()
        self.playerData = {}
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
    return ESX.IsPlayerLoaded()
end

function Framework:triggerStressGain(amount)
    -- ESX stress system integration - add stress instead of remove
    TriggerServerEvent('esx_status:add', 'stress', amount)
end

return Framework