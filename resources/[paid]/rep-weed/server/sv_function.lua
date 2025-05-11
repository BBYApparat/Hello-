Plants = {}
MyStrains = {}

function createLog(src, reason)
    if Config.Logger.oxlog then
        lib.logger(src, 'Weed', reason)
    else
        local embedData = {
            {
                ['title'] = "REP WEED",
                ['color'] = Config.Logger.discord.color,
                ['footer'] = {
                    ['text'] = os.date("Day: %d, Month: %m, %H hours - %M min"),
                },
                ['description'] = reason,
                ['author'] = {
                    ['name'] = "REP WEED",
                    ['icon_url'] = Config.Logger.discord.img,
                },
            }
        }
        PerformHttpRequest(Config.Logger.discord.link, function() end, 'POST',
            json.encode({ username = "REP WEED", embeds = embedData }), { ['Content-Type'] = 'application/json' })
        Citizen.Wait(100)
        if Config.Logger.discord.tag then
            PerformHttpRequest(Config.Logger.discord.link, function() end, 'POST',
                json.encode({ username = "REP WEED", content = '@everyone' }), { ['Content-Type'] = 'application/json' })
        end
    end
end

function extractAfterMarker(str1)
    -- Kiểm tra xem str2 có tồn tại trong str1 không
    for _index, _value in pairs(Config.Plant.canDry) do
        if _value then
            local pos = string.find(str1, _index)
            if pos then
                -- Lấy phần còn lại sau str2 trong str1
                local remaining = string.sub(str1, pos + #_index)
                -- Kiểm tra xem phần còn lại có chứa '-' hoặc '_' không
                local splitPos = string.find(remaining, "[-_]")
                if splitPos then
                    -- Nếu có, trả về phần sau dấu đầu tiên
                    return _index, string.sub(remaining, splitPos + 1)
                else
                    -- Nếu không có, trả về toàn bộ phần còn lại
                    return _index, remaining
                end
            end
        end
    end
    return false
end

lib.callback.register('rep-weed:callback:spawnTacoNPC', function(source, _model, _index)
    local _pPos = Config.TacoShop.points[_index].pos
    _model = type(_model) == 'string' and joaat(_model) or _model
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local _ped = CreatePed(0, _model, coords.x, coords.y, coords.z - 3.0, _pPos.w, true, true)
    while not DoesEntityExist(_ped) do Wait(0) end
    while NetworkGetEntityOwner(_ped) ~= source do Wait(0) end
    SetEntityDistanceCullingRadius(_ped, 30000.0) -- So this entity will be visible by all clients at any distance
    SetEntityCoords(_ped, _pPos.x, _pPos.y, _pPos.z)
    SetEntityHeading(_ped, _pPos.w)
    TacoShop[source].ped = _ped
    Wait(1000)
    return NetworkGetNetworkIdFromEntity(TacoShop[source].ped), _pPos
end)

lib.callback.register('rep-weed:callback:spawnObj', function(source, _model)
    local ped = GetPlayerPed(source)
    local coord = GetEntityCoords(ped)
    local obj = CreateObject(joaat(_model), coord.x, coord.y, coord.z, true, true, false)
    while not DoesEntityExist(obj) do Wait(0) end
    while NetworkGetEntityOwner(obj) ~= source do Wait(0) end
    return NetworkGetNetworkIdFromEntity(obj)
end)

if Config.Inventory == 'qs' then
    lib.callback.register('rep-weed:callback:GetItems', function(source)
        return exports['qs-inventory']:GetInventory(source)
    end)
end

RegisterNetEvent('rep-weed:server:delEntity', function(entityId)
    local _entity = NetworkGetEntityFromNetworkId(entityId)
    if DoesEntityExist(_entity) then
        DeleteEntity(_entity)
    end
end)

local function addExpStrain(n, p, pk, amount)
    for k, v in pairs(MyStrains) do
        if tonumber(n) == v.n and tonumber(p) == v.p and tonumber(pk) == v.k then
            MyStrains[k].rep = MyStrains[k].rep + amount
            MySQL.update('UPDATE strain SET rep = ? WHERE id = ?', { MyStrains[k].rep, v.id })
        end
    end
end

exports('addExpStrain', addExpStrain)

local function getExpStrain(n, p, pk)
    for k, v in pairs(MyStrains) do
        if tonumber(n) == v.n and tonumber(p) == v.p and tonumber(pk) == v.k then
            return MyStrains[k].rep
        end
    end
end

exports('getExpStrain', getExpStrain)


CreateThread(function()
    TriggerEvent('rep-weed:config', Config.HyperData)
end)
