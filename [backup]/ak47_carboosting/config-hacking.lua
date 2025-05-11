Config.UseCarlockScript = false
--[[
    if this option is enabled and if you are not using VehicleHack for any class in Config.HackingByClass, vehicle will be unlocked by default.
    if you are using any vehicle key script then player have to lockpick the vehicle as usual
    if enabled then you will get a lockpick minigame. On success, givekey function will trigger.
]]
Config.LockpickItem = 'lockpick'
Config.LockpickRemoveChance = {
    onSuccess = 10,
    onFail = 70,
}
Config.LockpickMinigame = function()
    local promise = promise.new()
    exports['ps-ui']:Circle(function(success)
        promise:resolve(success)
    end, 3, 20) -- NumberOfCircles, MS
    return Citizen.Await(promise)
end

Config.NumberOfGpsHackByClass = { --how many hack player need to complete to disable the GPS
    ['D'] = 0,
    ['C'] = 3,
    ['B'] = 4,
    ['A'] = 5,
    ['S'] = 6,
}

Config.GpsHackIntervalByClass = { --how long player need to wait for next GPS hack
    ['D'] = 30, --seconds
    ['C'] = 30, --seconds
    ['B'] = 30, --seconds
    ['A'] = 30, --seconds
    ['S'] = 30, --seconds
}

--Don't touch if you are not a Dev
Config.HackingByClass = { --hacking minigame
    ['D'] = {
      --[[ Don't keep the function open if it's empty
        GarageHack = function()
            
        end,
        VehicleHack = function()
            
        end,
        GpsHack = function()
            
        end
      ]]
    },
    ['C'] = {
      --[[
        GarageHack = function()
            
        end,
        VehicleHack = function()
            
        end,
      ]]
        GpsHack = function()
            local promise = promise.new()
            exports['ps-ui']:Scrambler(function(success)
                promise:resolve(success)
            end, "alphabet", 30, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
            return Citizen.Await(promise)
        end
    },
    ['B'] = {
      --[[
        GarageHack = function()
            
        end,
      ]]
        VehicleHack = function()
            local promise = promise.new()
            exports['ps-ui']:Circle(function(success)
                promise:resolve(success)
            end, 2, 20) -- NumberOfCircles, MS
            return Citizen.Await(promise)
        end,
        GpsHack = function()
            local promise = promise.new()
            exports['ps-ui']:Circle(function(success)
                promise:resolve(success)
            end, 2, 20) -- NumberOfCircles, MS
            return Citizen.Await(promise)
        end
        
    },
    ['A'] = {
        GarageHack = function()
            local promise = promise.new()
            exports['ps-ui']:Scrambler(function(success)
                promise:resolve(success)
            end, "numeric", 30, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
            return Citizen.Await(promise)
        end,
        VehicleHack = function()
            local promise = promise.new()
            exports['ps-ui']:Scrambler(function(success)
                promise:resolve(success)
            end, "numeric", 30, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
            return Citizen.Await(promise)
        end,
        GpsHack = function()
            local promise = promise.new()
            exports['ps-ui']:Scrambler(function(success)
                promise:resolve(success)
            end, "numeric", 30, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
            return Citizen.Await(promise)
        end
    },
    ['S'] = {
        GarageHack = function()
            local promise = promise.new()
            exports['ps-ui']:Scrambler(function(success)
                promise:resolve(success)
            end, "greek", 120, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
            return Citizen.Await(promise)
        end,
        VehicleHack = function()
            local promise = promise.new()
            exports['ps-ui']:Scrambler(function(success)
                promise:resolve(success)
            end, "braille", 120, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
            return Citizen.Await(promise)
        end,
        GpsHack = function()
            local promise = promise.new()
            exports['ps-ui']:Scrambler(function(success)
                promise:resolve(success)
            end, "runes", 120, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
            return Citizen.Await(promise)
        end
    },
}