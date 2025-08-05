-- Initialize ESX using modern exports method
local ESX = exports['es_extended']:getSharedObject()

-- Get player info for the Info app
ESX.RegisterServerCallback('okok_infoapp:getPlayerInfo', function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        cb({success = false, message = "Player not found"})
        return
    end
    
    -- Wrap in pcall for error handling
    local success, result = pcall(function()
    
    -- Get state_id using proper ESX method
    local stateId = xPlayer.getStateId()
    
    local playerInfo = {
        success = true,
        data = {
            state_id = stateId or "N/A",
            bank_balance = xPlayer.getAccount('bank').money or 0,
            cash_balance = xPlayer.getMoney() or 0,
            job = {
                name = xPlayer.job.name,
                label = xPlayer.job.label,
                grade = xPlayer.job.grade,
                grade_label = xPlayer.job.grade_label
            },
            gang = {
                name = "none",
                label = "No Gang",
                grade = 0,
                grade_label = "Member"
            }
        }
    }
    
    -- Check if player has gang data via database query (as gang data is stored separately)
    local result = MySQL.query.await('SELECT gang, gang_grade FROM users WHERE identifier = ?', {
        xPlayer.identifier
    })
    
    if result and result[1] and result[1].gang and result[1].gang ~= 'unemployed' then
        -- Get gang information from gang tables
        local gangResult = MySQL.query.await('SELECT gangs.label as gang_label, gang_grades.label as grade_label FROM gangs LEFT JOIN gang_grades ON gangs.name = gang_grades.gang_name WHERE gangs.name = ? AND gang_grades.grade = ?', {
            result[1].gang,
            result[1].gang_grade
        })
        
        if gangResult and gangResult[1] then
            playerInfo.data.gang = {
                name = result[1].gang,
                label = gangResult[1].gang_label,
                grade = result[1].gang_grade,
                grade_label = gangResult[1].grade_label
            }
        end
    end
    
        return playerInfo
    end)
    
    if success then
        cb(result)
    else
        print("Error in getPlayerInfo:", result)
        cb({success = false, message = "Internal server error"})
    end
end)