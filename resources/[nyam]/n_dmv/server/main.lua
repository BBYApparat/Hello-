local ESX = exports.es_extended:getSharedObject()
local licenses = {}

MySQL.ready(function()
	local p = promise.new()
	MySQL.query('SELECT type, label, category FROM licenses', function(result)
		licenses = result
		p:resolve(true)
	end)

	for k,v in pairs(Config.License) do
		local result = MySQL.query.await('SELECT * FROM `licenses` WHERE `type` = ?', {
			v.id
		})
		
		if result == nil or result[1] == nil then
			MySQL.insert.await('INSERT INTO `licenses` (type, label, category) VALUES (?, ?, ?)', {
				v.id, v.label, v.category
			})
		end
	end

	for k,v in pairs(Config.License) do
		local result = MySQL.query.await('SELECT * FROM `licenses` WHERE `type` = ?', {
			v.id
		})		
		if result == nil or result[1] == nil then
			MySQL.insert.await('INSERT INTO `licenses` (type, label, category) VALUES (?, ?, ?)', {
				v.id.."dmv", v.label.." DMV", v.category
			})
		end
	end
	
	Citizen.Await(p)
	ESX.Trace('[esx_license] : ' .. #licenses .. ' Loaded.')
end)

---@param identifier target identifier
---@param licenseType license type
---@param cb callback function
local function AddLicense(identifier, licenseType, cb)
	MySQL.insert('INSERT INTO user_licenses (type, owner) VALUES (?, ?)', {licenseType, identifier}, function(rowsChanged)
		if cb then
			cb(rowsChanged)
		end
	end)
end

---@param identifier target identifier
---@param licenseType license type
---@param cb callback function
local function RemoveLicense(identifier, licenseType, cb)
	MySQL.update('DELETE FROM user_licenses WHERE type = ? AND owner = ?', {licenseType, identifier}, function(rowsChanged)
		if cb then
			cb(rowsChanged)
		end
	end)
end

---@param licenseType license type
---@param cb callback function
local function GetLicense(licenseType, cb)
	MySQL.scalar('SELECT label, category FROM licenses WHERE type = ?', {licenseType}, function(result)
		if cb then
			cb({type = licenseType, label = result.label, category = result.category})
		end
	end)
end

---@param identifier target identifier
---@param cb callback function
local function GetLicenses(identifier, cb)
	MySQL.query('SELECT user_licenses.type, licenses.label, licenses.category FROM user_licenses LEFT JOIN licenses ON user_licenses.type = licenses.type WHERE owner = ?', {identifier},
	function(result)
		if cb then
			cb(result)
		end
	end)
end

---@param identifier target identifier
---@param licenseType license type
---@param cb callback function
local function CheckLicense(identifier, licenseType, cb)
	MySQL.scalar('SELECT type FROM user_licenses WHERE type = ? AND owner = ?', {licenseType, identifier}, function(result)
		if cb then
			if result then
				cb(true)
			else
				cb(false)
			end
		end
	end)
end

local function GetLicensesList(cb)
	cb(licenses)
end

local function isValidLicense(licenseType)
	local flag = false
	for i=1,#licenses do
		if licenses[i].type == licenseType then
			flag = true
			break
		end
	end
	return flag
end

RegisterNetEvent('esx_license:addLicense', function(target, licenseType, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		if isValidLicense(licenseType) then
			AddLicense(xPlayer.getIdentifier(), licenseType, cb)
		else
		end
	end
end)

RegisterNetEvent('esx_license:removeLicense', function(target, licenseType, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then 
		if Config.allowedJobs[xPlayer.getJob().name] then
			local xTarget = ESX.GetPlayerFromId(target)
			if xTarget then
				RemoveLicense(xTarget.getIdentifier(), licenseType, cb)
			end
		else
			xPlayer.showNotification('Your job is not allowed to remove the license', 'error', 3000)
		end
	end
end)

AddEventHandler('esx_license:getLicense', function(licenseType, cb)
	GetLicense(licenseType, cb)
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		GetLicenses(xPlayer.getIdentifier(), cb)
	end
end)

AddEventHandler('esx_license:checkLicense', function(target, licenseType, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		CheckLicense(xPlayer.getIdentifier(), licenseType, cb)
	end
end)

AddEventHandler('esx_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, licenseType)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		GetLicense(licenseType, cb)
	end
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		GetLicenses(xPlayer.getIdentifier(), cb)
	end
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, licenseType)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		CheckLicense(xPlayer.getIdentifier(), licenseType, cb)
	end
end)

ESX.RegisterServerCallback('esx_license:getLicensesList', function(source, cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('n_dmv:getData', function(source, cb)
    local licenses = Config.License
    local xPlayer = ESX.GetPlayerFromId(source)
    local result =  MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE owner = @identifier", {
        ['@identifier'] = xPlayer.identifier,
    })
    for k,v in pairs(licenses) do 
        v.theory = false
        v.practice = false
        for i=1, #result, 1 do
            local coso = result[i]

            if coso.type == v.id then
                v.theory = true
                v.practice = true
            elseif coso.type == v.id.."dmv" then
                v.theory = true
                v.practice = false
            end
        end
    end
    cb(licenses, xPlayer.getAccount('money').money, xPlayer.getAccount('bank').money)
end)


-- AddEventHandler('onResourceStart', function(resource)
--     if resource == GetCurrentResourceName() then
--         for k,v in pairs(Config.License) do
--             local result =  MySQL.Sync.fetchAll("SELECT * FROM licenses WHERE type = @type", {
--                   ['@type'] = v.id,
--             })

--             if result == nil or result[1] == nil then
--                 MySQL.Async.execute("INSERT INTO licenses (type, label, category) VALUES (@type, @label, @category)", {
--                     ['@type'] = v.id,
--                     ['@label'] = v.label,
-- 					['@category'] = v.category
--                 }) 
--             end
--         end

--         for k,v in pairs(Config.License) do
--             local result =  MySQL.Sync.fetchAll("SELECT * FROM licenses WHERE type = @type", {
--                   ['@type'] = v.id.."dmv",
--             }) 
--             if result == nil or result[1] == nil then
--                 MySQL.Async.execute("INSERT INTO licenses (type, label, category) VALUES (@type, @label, @category)", {
--                     ['@type'] = v.id.."dmv",
--                     ['@label'] = v.label.." DMV",
-- 					['@category'] = v.category
--                 }) 
--             end
--         end
--     end
-- end)

RegisterServerEvent('n_dmv:givelicense', function(license)
	local _source = source
    TriggerEvent('esx_license:addLicense', _source, license)
    local licenses = Config.License
	local xPlayer = ESX.GetPlayerFromId(_source)
    local result =  MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE owner = @identifier", {
        ['@identifier'] = xPlayer.identifier,
    })
	if not license:find("dmv") then
		exports["um-idcard"]:CreateMetaLicense(_source, nil, "driver_license")
	end
    for k,v in pairs(licenses) do 
        v.theory = false
        v.practice = false
        for i=1, #result, 1 do
            local coso = result[i]

            if coso.type == v.id then
                v.theory = true
                v.practice = true
            elseif coso.type == v.id.."dmv" then
                v.theory = true
                v.practice = false
            end
        end
    end

    TriggerClientEvent('n_dmv:updateLicense', _source, licenses)
end)

RegisterServerEvent('n_dmv:removeMoney', function(account, money)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.removeAccountMoney(account, money, "Driving School")
	if account == "bank" then
		TriggerEvent("banking:AddTransaction", src, money, "Driving School")
	end
end)