if Config.Enable.StatusSystem then

    local OriginalStatus, Status, isPaused = {}, {}, false

    function GetStatusData(minimal)
        local status = {}
        for i=1, #Status, 1 do
            if minimal then
                table.insert(status, {
                    name    = Status[i].name,
                    val     = Status[i].val,
                    percent = (Status[i].val / Config.StatusMax) * 100
                })
            else
                table.insert(status, {
                    name    = Status[i].name,
                    val     = Status[i].val,
                    color   = Status[i].color,
                    visible = Status[i].visible(Status[i]),
                    percent = (Status[i].val / Config.StatusMax) * 100
                })
            end
        end
        return status
    end

    AddEventHandler('esx_status:registerStatus', function(name, default, color, visible, tickCallback)
        local status = CreateStatus(name, default, color, visible, tickCallback)
        for i=1, #OriginalStatus, 1 do
            if status.name == OriginalStatus[i].name then
                status.set(OriginalStatus[i].val)
            end
        end
        table.insert(Status, status)
    end)

    AddEventHandler('esx_status:unregisterStatus', function(name)
        for k,v in ipairs(Status) do
            if v.name == name then
                table.remove(Status, k)
                break
            end
        end
    end)

    RegisterNetEvent('esx:onPlayerLogout', function()
        ESX.PlayerLoaded = false
        Status = {}
    end)

    RegisterNetEvent('esx_status:load', function(status)
        OriginalStatus = status
        ESX.PlayerLoaded = true
        TriggerEvent('esx_status:loaded')
        CreateThread(function()
            local data = {}
            while ESX.PlayerLoaded do
                for i=1, #Status do
                    Status[i].onTick()
                    table.insert(data, {
                        name = Status[i].name,
                        val = Status[i].val,
                        percent = (Status[i].val / Config.StatusMax) * 100
                    })
                end
                TriggerEvent('esx_status:onTick', data)
                table.wipe(data)
                Wait(Config.TickTime)
            end
        end)
    end)

    RegisterNetEvent('esx_status:set', function(name, val)
        for i=1, #Status, 1 do
            if Status[i].name == name then
                Status[i].set(val)
                break
            end
        end
    end)

    RegisterNetEvent('esx_status:add', function(name, val)
        for i=1, #Status, 1 do
            if Status[i].name == name then
                Status[i].add(val)
                break
            end
        end
    end)

    RegisterNetEvent('esx_status:remove', function(name, val)
        for i=1, #Status, 1 do
            if Status[i].name == name then
                Status[i].remove(val)
                break
            end
        end
    end)

    AddEventHandler('esx_status:getStatus', function(name, cb)
        for i=1, #Status, 1 do
            if Status[i].name == name then
                cb(Status[i])
                return
            end
        end
    end)

    AddEventHandler('esx_status:getAllStatus', function(cb)
        cb(Status)
    end)

    CreateThread(function()
        while true do
            Wait(Config.UpdateInterval)
            if ESX.PlayerLoaded then 
                TriggerServerEvent('esx_status:update', GetStatusData(true))
            end
        end
    end)

end