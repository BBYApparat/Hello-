ESX.RegisterServerCallback('shops:server:getLicenseStatus', function(source, cb) -- TOFIX
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local licenseTable = GetUserLicenses(xPlayer.source)
    local licenseItem = xPlayer.GetItemByName("weaponlicense")
    cb(licenseTable.weapon, licenseItem)
end)