ESX = exports['es_extended']:getSharedObject()

local metadata = {}
local function GetBadge(src, itemName)
    if not Config.Licenses[itemName].badge then return nil end
    local xPlayer = ESX.GetPlayerFromId(src)
    local badgeTable = {
        img = Config.Licenses[itemName].badge,
        grade = xPlayer.getJob().grade_label
    }
    return badgeTable
end

local function CreateMetaLicense(src, itemTable, itemName)
    local xPlayer = ESX.GetPlayerFromId(src)

    if type(itemTable) == 'string' then
        itemTable = { itemTable }
    end

    if type(itemTable) == 'table' then
        for _, itemName in pairs(itemTable) do
            metadata = {
                cardtype = itemName,
                identifier = xPlayer.getIdentifier(),
                citizenId = xPlayer.citizenid or xPlayer.metadata.citizenId,
                firstname = xPlayer.variables.firstName,
                lastname = xPlayer.variables.lastName,
                birthdate = xPlayer.variables.dateofbirth,
                sex = xPlayer.variables.sex,
                nationality = 'Los Santos',
                mugShot = lib.callback.await('um-idcard:client:callBack:getMugShot', src),
                badge = GetBadge(src, itemName)
            }
            exports.ox_inventory:AddItem(src, itemName, 1, metadata)
        end
    elseif itemName then
        metadata = {
            cardtype = itemName,
            identifier = xPlayer.getIdentifier(),
            citizenId = xPlayer.citizenid or xPlayer.metadata.citizenId,
            firstname = xPlayer.variables.firstName,
            lastname = xPlayer.variables.lastName,
            birthdate = xPlayer.variables.dateofbirth,
            sex = xPlayer.variables.sex,
            nationality = 'Los Santos',
            mugShot = lib.callback.await('um-idcard:client:callBack:getMugShot', src),
            badge = GetBadge(src, itemName)
        }
        exports.ox_inventory:AddItem(src, itemName, 1, metadata)
    else
        print("Invalid data given for CreateMetaLicense", json.encode(itemTable), itemName)
    end
end

exports('CreateMetaLicense', CreateMetaLicense)

local ox_inventory = exports.ox_inventory
local ESX = exports.es_extended:getSharedObject()

function NewMetaDataLicense(source, itemName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local newMetaDataItem = ox_inventory:Search(src, 1, itemName, { mugShot = "none" })
    local shouldwait = false

    for _, v in pairs(newMetaDataItem) do
        newMetaDataItem = v
        break
    end
    
    if itemName == "driver_license" then
        shouldwait = true
        TriggerEvent("esx_license:getLicenses", src, function(cb)
            local licenses = ""
            local prevCat = ""
            for k , license in pairs(cb) do
                if prevCat ~= license.category then
                    prevCat = license.category
                    licenses = licenses .. "\n" .. prevCat .." | "
                end
            end
            newMetaDataItem.metadata.licenses = licenses
            shouldwait = false
        end)
    end 

    while shouldwait do Wait(0) end

    newMetaDataItem.metadata.cardtype = itemName
    newMetaDataItem.metadata.identifier = xPlayer.getIdentifier()
    newMetaDataItem.metadata.citizenid = xPlayer.citizenid or xPlayer.metadata.citizenId
    newMetaDataItem.metadata.firstname = xPlayer.get('firstName')
    newMetaDataItem.metadata.lastname = xPlayer.get('lastName')
    newMetaDataItem.metadata.birthdate = xPlayer.get('dateofbirth')
    newMetaDataItem.metadata.sex = xPlayer.get('sex')
    newMetaDataItem.metadata.nationality = "Los Santos"
    newMetaDataItem.metadata.mugShot = lib.callback.await('um-idcard:client:callBack:getMugShot', src)
    newMetaDataItem.metadata.badge = GetBadge(src, itemName)

    ox_inventory:SetMetadata(src, newMetaDataItem.slot, newMetaDataItem.metadata)
    TriggerEvent("um-idcard:server:sendData", src, newMetaDataItem, newMetaDataItem.metadata)
end

RegisterNetEvent('um-idcard:server:sendData', function(src, item, metadata)
    if metadata.mugShot and metadata.mugShot ~= 'none' then
        lib.callback('um-idcard:client:callBack:getClosestPlayer', src, function(player)
            if player ~= 0 then
                TriggerClientEvent('um-idcard:client:notifyOx', src, {
                    title = 'You showed your idcard', 
                    desc = 'You are showing your ID Card to the closest player',
                    icon = 'id-card',
                    iconColor = 'green'
                })
                src = player
            end
            TriggerClientEvent('um-idcard:client:sendData', src, metadata)
        end)
        TriggerClientEvent('um-idcard:client:startAnim', src, metadata.cardtype)
    else
        NewMetaDataLicense(src, item)
    end
end)

local filterItems = {}

for licenseType, _ in pairs(Config.Licenses) do
    print(licenseType)
    ESX.RegisterUsableItem(licenseType, function(source, itemName, item)
        TriggerEvent('um-idcard:server:sendData', source, item.name, item.metadata)
    end)
    filterItems[licenseType] = true
end

-- print(exports.n_snippets:DumpTable(filterItems))

local hookId = exports.ox_inventory:registerHook('createItem', function(payload)
    local metadata = payload.metadata
    metadata.cardtype = payload.item.name
    metadata.mugShot = "none"
    return metadata
end, {
    itemFilter = filterItems
})