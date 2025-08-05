---@module "Framework Utils"

---@class Utilities
---@field framework "qb" | "qbx" | "esx" | "ox"
local Utils = {
      framework = CurrentFramework,
      garages = nil,
      hasExports = hasExports
}

---@param source number | string
---@return table | nil playerObj
function Utils:getPlayerObject(source)
      source = tonumber(source) --[[ @as number ]]
      if self.framework == 'esx' then
            return Framework.GetPlayerFromId(source)
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            return Framework.Functions.GetPlayer(source)
      elseif self.framework == 'ox' then
            return Ox.GetPlayer(source)
      end
end

---@param char_ident string
---@return table | nil playerObj
function Utils:getPlayerObjectFromCharIdentifier(char_ident)
      if self.framework == 'esx' then
            for _, playerObj in pairs(Framework.GetExtendedPlayers()) do
                  if playerObj.getIdentifier() == char_ident then
                        return playerObj
                  end
            end
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            for _, playerObj in pairs(Framework.Functions.GetQBPlayers()) do
                  if playerObj.PlayerData.citizenid == char_ident then
                        return playerObj
                  end
            end
      elseif self.framework == 'ox' then
            for _, playerObj in pairs(Ox.GetPlayers()) do
                  if playerObj.charId == char_ident then
                        return playerObj
                  end
            end
      end
end

---@param cb fun(source:number, playerObj:table)
function Utils:forEachPlayerChar(cb)
      if self.framework == 'esx' then
            for _, playerObj in pairs(Framework.GetExtendedPlayers()) do
                  cb(playerObj.source, playerObj)
            end
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            for _, playerObj in pairs(Framework.Functions.GetQBPlayers()) do
                  cb(playerObj.PlayerData.source, playerObj)
            end
      elseif self.framework == 'ox' then
            for _, playerObj in pairs(Ox.GetPlayers()) do
                  cb(playerObj.source, playerObj)
            end
      end
end

---@param playerObj table
---@return string
function Utils:getCharacterId(playerObj)
      if self.framework == 'esx' then
            return playerObj.getIdentifier()
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            return playerObj.PlayerData.citizenid
      elseif self.framework == 'ox' then
            return playerObj.charId
      end
      return ""
end

---@param playerObj table
---@return number
function Utils:getPlayerSource(playerObj)
      if self.framework == 'esx' then
            return playerObj.source
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            return playerObj.PlayerData.source
      elseif self.framework == 'ox' then
            return playerObj.source
      end
      return 0
end

---@param playerObj table
---@return string
function Utils:getCharacterName(playerObj)
      if self.framework == 'esx' then
            return playerObj.getName()
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            local firstName = playerObj.PlayerData.charinfo.firstname
            local lastName  = playerObj.PlayerData.charinfo.lastname
            return string.format('%s %s', firstName, lastName)
      elseif self.framework == 'ox' then
            local firstName = playerObj.get("firstName")
            local lastName = playerObj.get("lastName")
            return string.format('%s %s', firstName, lastName)
      end
      return ""
end

---@param playerObj table
---@param key string
---@param value any
function Utils:setPlayerMetadata(playerObj, key, value)
      if self.framework == 'esx' then
            playerObj?.setMeta(key, value)
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            playerObj.Functions.SetMetaData(key, value)
      elseif self.framework == 'ox' then
            playerObj.set(key, value, true)
      end
end

---@param playerObj table
---@param key string
---@param value any
function Utils:setPlayerData(playerObj, key, value)
      if self.framework == 'esx' then
            --
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            playerObj.Functions.SetPlayerData(key, value)
      elseif self.framework == 'ox' then
            if not playerObj.charId then return end -- Safeguard
            playerObj.set(key, value, true)
            MySQL.prepare.await(("UPDATE characters SET %s = ? WHERE charId = ?"):format(key),
                  { value, playerObj.charId })
      end
end

---@param playerObj table
---@param phoneNumber string
function Utils:setPhoneNumber(playerObj, phoneNumber)
      if self.framework == 'esx' then
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            playerObj.PlayerData.charinfo.phone = phoneNumber
            self:setPlayerData(playerObj, 'charinfo', playerObj.PlayerData.charinfo)
      elseif self.framework == 'ox' then
            self:setPlayerData(playerObj, "phoneNumber", phoneNumber)
      end
end

---@param item string
---@param cb function
function Utils:registerUsableItem(item, cb)
      if Config.Inventory == "ox" then return end
      if self.framework == 'esx' then
            Framework.RegisterUsableItem(item, cb)
      elseif self.framework == 'qb' then
            Framework.Functions.CreateUseableItem(item, cb)
      elseif self.framework == 'qbx' then
            exports.qbx_core:CreateUseableItem(item, cb)
      end
end

---@param source string | number
---@param itemName string
---@param slot number
---@param metadata table
---@param item table
function Utils:setInventorySlotMetadata(source, itemName, slot, metadata, item)
      if Config.Inventory == 'ox' then
            exports.ox_inventory:SetMetadata(source, slot, metadata)
      elseif Config.Inventory == 'core' then
            local playerObj = self:getPlayerObject(source)
            local charId = playerObj and self:getCharacterId(playerObj)
            if not charId then return end
            local invName = "content-" .. charId:gsub(":", "")
            exports['core_inventory']:updateMetadata(invName, item.id, metadata)
      elseif Config.Inventory == 'qs' then
            exports['qs-inventory']:SetItemMetadata(source, slot, metadata)
      elseif Config.Inventory == 'origen' then
            exports['origen_inventory']:SetItemMetada(source, itemName, slot, metadata)
      elseif Config.Inventory == "ak47" then
            local playerObj = self:getPlayerObject(source)
            local charId = playerObj and self:getCharacterId(playerObj)
            if not charId then return end
            exports['ak47_inventory']:SetItemInfo(charId, slot, metadata)
      elseif Config.Inventory == "tgiann" then
            exports["tgiann-inventory"]:SetItemData(source, itemName, slot, metadata)
      elseif Config.Inventory == 'codem' then
            if not pcall(function()
                      exports['codem-inventory']:SetItemMetadata(source, slot, metadata)
                end) then
                  exports["codem-inventory"]:RemoveItem(source, itemName, 1, slot)
                  exports["codem-inventory"]:AddItem(source, itemName, 1, slot, metadata)
            end
      elseif Config.Inventory == 'qb' then
            local Player = Framework.Functions.GetPlayer(source)

            if not Player then return false end
            if not slot or not Player.PlayerData.items[slot] then return false end
            Player.PlayerData.items[slot].info = metadata
            Player.Functions.SetPlayerData("items", Player.PlayerData.items)
      end
end

---@param item table
---@returns table?
function Utils:getItemMetadata(item)
      if Config.Inventory == 'ox' then
            return item.metadata
      elseif Config.Inventory == 'qs' then
            return item.info or item.metadata
      elseif Config.Inventory == 'core' then
            return item.metadata or item.info
      elseif Config.Inventory == 'tgiann-inventory' then
            return item.metadata
      elseif Config.Inventory == 'qb' then
            return item.info
      else
            return item.info or item.metadata
      end
end

---@param playerObj table
---@return table?
function Utils:getPlayerInventory(playerObj)
      if Config.Inventory == 'core' then
            local charId = self:getCharacterId(playerObj)
            local invName = "content-" .. charId:gsub(":", "")
            return exports['core_inventory']:getInventory(invName)
      end
      if Config.Inventory == 'tgiann' then
            local source = self:getPlayerSource(playerObj)
            return exports['tgiann-inventory']:GetPlayerItems(source)
      end
      if self.framework == 'esx' then
            return playerObj.getInventory()
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            return playerObj.PlayerData.items
      elseif self.framework == 'ox' then
            return exports.ox_inventory:GetInventoryItems(playerObj.source)
      end
end

---@param playerObj table
---@param slot number
function Utils:getItemBySlot(playerObj, slot)
      local items = self:getPlayerInventory(playerObj)
      if not items then return end
      for k, v in pairs(items) do
            if v.slot == slot then
                  return v
            end
      end
end

---@param source number
---@param itemName string
---@param amount? number
---@return boolean
function Utils:hasItem(source, itemName, amount)
      local playerObj = self:getPlayerObject(source)
      if not playerObj then return false end

      amount = amount or 1

      if Config.Inventory == "ox" then
            local count = exports.ox_inventory:GetItem(source, itemName, nil, true)
            return count >= amount
      elseif Config.Inventory == "core" then
            local playerObj = self:getPlayerObject(source)
            local charId = playerObj and self:getCharacterId(playerObj)
            if not charId then return false end
            local invName = "content-" .. charId:gsub(":", "")
            local item = exports['core_inventory']:getItem(invName, itemName)
            local count = item and item.amount or 0

            return count >= amount
      elseif Config.Inventory == "qs" then
            local count = exports['qs-inventory']:GetItemTotalAmount(source, itemName)
            return count >= amount
      elseif Config.Inventory == "ak47" then
            local result = exports['ak47_inventory']:GetItem(source, itemName)
            return result and result.amoun >= amount
      elseif Config.Inventory == "tgiann" then
            return exports["tgiann-inventory"]:HasItem(source, itemName, amount)
      else
            if self.framework == 'qb' then
                  local items = playerObj.PlayerData.items
                  local count = 0
                  for k, v in pairs(items) do
                        if itemName == v.name then
                              count = count + v.amount
                        end
                  end
                  return count >= amount
            elseif self.framework == "qbx" then
                  return exports.qbx_core:CanUseItem(itemName)
            elseif self.framework == 'esx' then
                  return playerObj.getInventoryItem(itemName).count >= amount
            end
      end

      return false
end

--- Check if the player has the phone item
---@param playerObj table
---@param imei? string
---@return boolean
function Utils:hasPhone(playerObj, imei)
      -- If item is not required, return true
      if not Config.Phone.item.enabled then return true end

      local itemName = Config.Phone.item.name
      local items = self:getPlayerInventory(playerObj)
      if not items then return false end

      -- Check if has phone item with specific imei
      if imei and Config.Phone.item.enabled and Config.Phone.item.unique_phones then
            for _, item in pairs(items) do
                  -- Check if imei matches
                  local imeiMatches = item.metadata?.imei == imei or item.info?.imei == imei
                  if item.name == itemName and imeiMatches then return true end
            end
            -- Check if has any phone if item is required
      else
            for _, item in pairs(items) do
                  if item.name == itemName then return true end
            end
      end
      -- No phone item found
      return false
end

---@return table
function Utils:getPlayersList()
      if self.framework == 'esx' then
            if not Framework.GetExtendedPlayers then
                  Ok.print.error("ESX FUNCTION NOT DETECTED")
                  Ok.print.error("GetExtendedPlayers() function was not found")
                  Ok.print.error("This happens when using old ESX versions")
                  Ok.print.error("Please add this function to your framework")
                  return {}
            end
            return Framework.GetExtendedPlayers()
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            return Framework.Functions.GetQBPlayers()
      end
      return {}
end

---@param playerObj table
function Utils:getSourceFromCharacter(playerObj)
      if self.framework == 'esx' then
            return playerObj.source
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            return playerObj.PlayerData.source
      elseif self.framework == 'ox' then
            return playerObj.source
      end
end

---@param playerObj table
---@return string
function Utils:getPlayerJobName(playerObj)
      if self.framework == 'esx' then
            return playerObj?.getJob()?.name
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            return playerObj.PlayerData.job.name
      elseif self.framework == 'ox' then
            return playerObj.get("activeGroup")
      end
      return ""
end

---@param playerObj table
---@return {name:string, label:string, grade:number, grade_label:string, isBoss:boolean}
function Utils:getPlayerJobInfo(playerObj)
      if self.framework == 'esx' then
            local job = playerObj.job
            return {
                  name = job.name,
                  label = job.label,
                  grade = job.grade,
                  grade_label = job.grade_label,
                  isBoss = Ok.table.contains(Config.Work.bossGrades, job.grade_name)
            }
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            local job = playerObj.PlayerData.job
            return {
                  name = job.name,
                  label = job.label,
                  grade = job.grade.level,
                  grade_label = job.grade.name,
                  isBoss = job.isboss
            }
      elseif self.framework == 'ox' then
            local group = playerObj.get("activeGroup")
            return {
                  name = group,
                  label = group,
                  grade = 0,
                  grade_label = "Member",
                  isBoss = false
            }
      end
      return {}
end

---@param jobName string
---@return table
function Utils:getPlayersByJob(jobName)
      local players = {}
      if self.framework == "qb" or self.framework == 'qbx' then
            for k, v in pairs(Framework.Functions.GetQBPlayers()) do
                  local job = v.PlayerData.job
                  if job.name == jobName then
                        table.insert(players, v)
                  end
            end
      elseif self.framework == "esx" then
            return Framework.GetExtendedPlayers("job", jobName)
      end
      return players
end

---@param playerObj table
---@return table<string, number> @accounts
function Utils:getPlayerAccounts(playerObj)
      if self.framework == 'qb' or self.framework == "qbx" then
            local accounts = playerObj.PlayerData.money
            return accounts --[[ @as table {[string]:number} ]]
      elseif self.framework == 'esx' then
            local data = playerObj.getAccounts()
            local accounts = {}
            for _, a in ipairs(data) do
                  accounts[a.name] = a.money
            end
            return accounts --[[ @as table {[string]:number} ]]
      elseif self.framework == 'ox' then
            local account = playerObj.getAccount()
            return { bank = account.get("balance") } --[[ @as table {[string]:number} ]]
      end
      return {}
end

---@param playerObj table
---@return number
function Utils:getAccountMoney(account, playerObj)
      if self.framework == 'esx' then
            return playerObj.getAccount(account)?.money
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            return playerObj.PlayerData?.money[account]
      elseif self.framework == "ox" then
            return playerObj.getAccount().get("balance")
      end
      return 0
end

---@param account string
---@param amount number
---@param player table | string | number
function Utils:setAccountMoney(account, amount, player)
      player = type(player) ~= "table" and Utils:getPlayerObject(player) or player
      if not player then return end
      if CurrentFramework == 'qb' or CurrentFramework == 'qbx' then
            player.Functions.SetMoney(account, amount)
      elseif CurrentFramework == 'esx' then
            account = account == 'cash' and 'money' or account -- Esx uses 'money' for cash
            player.setAccountMoney(account, amount)
      elseif self.framework == "ox" then
            local account = player.getAccount()
            local curBalance = account.get("balance")
            account.removeBalance({ amount = curBalance, overdraw = false })
            return account.addBalance({ amount = amount }).success
      end
end

---@param account string
---@param amount number
---@param player table | string | number
function Utils:addAccountMoney(account, amount, player)
      player = type(player) ~= "table" and Utils:getPlayerObject(player) or player
      if not player then return end
      if CurrentFramework == 'qb' or CurrentFramework == 'qbx' then
            player.Functions.AddMoney(account, amount)
      elseif CurrentFramework == 'esx' then
            account = account == 'cash' and 'money' or account -- Esx uses 'money' for cash
            player.addAccountMoney(account, amount)
      elseif self.framework == "ox" then
            return player.getAccount().addBalance({ amount = amount }).success
      end
end

---@param account string
---@param amount number
---@param player table | string | number
function Utils:removeAccountMoney(account, amount, player)
      player = type(player) ~= "table" and Utils:getPlayerObject(player) or player
      if not player then return end
      if CurrentFramework == 'qb' or CurrentFramework == 'qbx' then
            player.Functions.RemoveMoney(account, amount)
      elseif CurrentFramework == 'esx' then
            account = account == 'cash' and 'money' or account -- Esx uses 'money' for cash
            player.removeAccountMoney(account, amount)
      elseif self.framework == "ox" then
            return player.getAccount().removeBalance({ amount = amount, overdraw = false }).success
      end
end

---@param jobName string
---@param cb fun(source:number, playerObj:table)
---@param verify? fun(source:number, playerObj:table):boolean
function Utils:jobSpecificCallback(jobName, cb, verify)
      if self.framework == "qb" then
            for source, playerObj in pairs(Framework.Functions.GetQBPlayers()) do
                  if (verify == nil or verify(source, playerObj)) and playerObj.PlayerData?.job?.name == jobName and playerObj.PlayerData?.job?.onduty then
                        cb(source, playerObj)
                  end
            end
      elseif self.framework == "esx" then
            for _, playerObj in pairs(Framework.GetExtendedPlayers("job", jobName)) do
                  if (verify == nil or verify(playerObj.source, playerObj)) then
                        cb(playerObj.source, playerObj)
                  end
            end
      elseif self.framework == 'ox' then
            for _, playerObj in pairs(Ox.GetPlayers()) do
                  local group = playerObj.get("activeGroup")
                  if (verify == nil or verify(playerObj.source, playerObj)) and group == jobName then
                        cb(playerObj.source, playerObj)
                  end
            end
      end
end

---@param jobNames table<string, any>
---@param cb fun(source:number, playerObj:table)
---@param verify? fun(source:number, playerObj:table):boolean
function Utils:multiJobSpecificCallback(jobNames, cb, verify)
      if self.framework == "qb" then
            for source, playerObj in pairs(Framework.Functions.GetQBPlayers()) do
                  if (verify == nil or verify(source, playerObj)) and jobNames[playerObj.PlayerData?.job?.name] and playerObj.PlayerData?.job?.onduty then
                        cb(source, playerObj)
                  end
            end
      elseif self.framework == "esx" then
            for _, playerObj in pairs(Framework.GetExtendedPlayers()) do
                  local job = playerObj.getJob().name
                  if (verify == nil or verify(playerObj.source, playerObj)) and jobNames[job] then
                        cb(playerObj.source, playerObj)
                  end
            end
      elseif self.framework == 'ox' then
            for _, playerObj in pairs(Ox.GetPlayers()) do
                  local group = playerObj.get("activeGroup")
                  if (verify == nil or verify(playerObj.source, playerObj)) and jobNames[group] then
                        cb(playerObj.source, playerObj)
                  end
            end
      end
end

---@return boolean
function Utils:getDuty(playerObj)
      if self.framework == "qb" or self.framework == 'qbx' then
            return playerObj.PlayerData?.job?.onduty
      elseif self.framework == "esx" then
            if isResourceRunning("okokBossMenu") then
                  local identifier = playerObj.getIdentifier()
                  return MySQL.prepare.await("SELECT 1 FROM users WHERE identifier = ? AND isOnDuty = 1 LIMIT 1",
                        { identifier }) ~= nil
            end

            local job = playerObj.getJob()
            if not job then return false end

            --- Using the off_ prefix
            if string.find(job.name, Config.Work.OffDutyJobPrefix) then
                  return false
            end

            -- New Method
            if type(job.onDuty) == "boolean" then
                  return playerObj.job.onDuty
            end

            return false
      elseif self.framework == "ox" then
            return playerObj.get("activeGroup")
      end
end

---@param playerObj table
---@param mode boolean
function Utils:setDuty(playerObj, mode)
      if self.framework == "qb" or self.framework == 'qbx' then
            playerObj.Functions.SetJobDuty(mode)
      elseif self.framework == "esx" then
            if isResourceRunning("okokBossMenu") then
                  local src = self:getSourceFromCharacter(playerObj)
                  return exports["okokBossMenu"]:toggleJobDuty(src, mode)
            end

            local job = playerObj.getJob()
            job.name = mode and job.name:gsub(Config.Work.OffDutyJobPrefix, '') or
                Config.Work.OffDutyJobPrefix .. job.name
            playerObj.setJob(job.name, job.grade)
      elseif self.framework == "ox" then
            local group = mode and playerObj.get('group') or nil
            playerObj.setActiveGroup(group)
      end
end

function Utils:setJob(playerObj, jobName, grade)
      if self.framework == "qb" or self.framework == 'qbx' then
            playerObj.Functions.SetJob(jobName, grade)
      elseif self.framework == "esx" then
            playerObj.setJob(jobName, grade)
      end
end

---@param playerObj table
function Utils:fireEmployee(playerObj)
      local charId = self:getCharacterId(playerObj)
      local currentJob = self:getPlayerJobInfo(playerObj)
      if isResourceRunning('ps-multijob') then
            exports["ps-multijob"]:RemoveJob(charId, currentJob.name)
      end
      Utils:setJob(playerObj, Config.Work.UnemployedJobName, 0)
end

---@param charId string
---@param jobName string
---@param grade number
function Utils:setJobViaSQL(charId, jobName, grade)
      if self.framework == 'qb' or self.framework == 'qbx' then
            local jobInfo = Framework.Shared.Jobs[jobName]
            if not jobInfo then return end
            local gradeInfo = jobInfo.grades[tostring(grade)] --- if this fails its over

            -- Mental Gymnastics 💀
            local job = {
                  name = jobName,
                  label = jobInfo.label,
                  onduty = false,
                  type = jobInfo.type,
                  grade = { name = gradeInfo.name, level = grade },
                  payment =
                      gradeInfo.payment,
                  isboss = gradeInfo.isboss
            }

            MySQL.prepare.await("UPDATE players set job = ? WHERE citizenid = ?", {
                  json.encode(job),
                  charId
            })


            --[[ {"name":"ambulance","label":"EMS","onduty":true,"type":"ems","grade":{"name":"Recruit","level":0},"payment":50,"isboss":false} ]]
      elseif self.framework == 'esx' then
            MySQL.prepare.await("UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?", {
                  jobName,
                  grade,
                  charId
            })
      end
end

---@return {name:string, label:string}[]
function Utils:getJobList()
      local list = {}
      if self.framework == "qb" or self.framework == 'qbx' then
            -- Fetch Job list
            local jobs = Framework.Shared.Jobs

            -- Build Job List
            for k, v in pairs(jobs) do
                  list[#list + 1] = { name = k, label = v.label }
            end
            --[[
                  Qb Schema
            = {
	['unemployed'] = {
		label = 'Civilian',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Freelancer',
                payment = 10
            },
        },
	}, ]]
      elseif self.framework == "esx" then
            local jobs = Framework.GetJobs()
            for k, v in pairs(jobs) do
                  if not k:find(Config.Work.OffDutyJobPrefix) then
                        list[#list + 1] = { name = k, label = v.label }
                  end
            end
            ---
            --[[
                  ESX Schema
            Jobs['unemployed'] = { label = 'Unemployed', grades = { ['0'] = { grade = 0, label = 'Unemployed', salary = 200, skin_male = {}, skin_female = {} } } }
             ]]
      end
      return list
end

---@return table<string, table<string, {name:string, salaray:number }>>
function Utils:getJobsGrades()
      if self.framework == 'esx' then
            local result = MySQL.query.await("SELECT * FROM job_grades")
            local grades = {}
            for _, grade in ipairs(result) do
                  grades[grade.job_name] = grades[grade.job_name] or {}
            end
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            local grades = {}
            for _, job in pairs(Framework.Shared.Jobs) do
                  grades[job.name] = job.grades
            end
            return grades
      end
      return {}
end

---@param jobName string
function Utils:getSocietyName(jobName)
      if self.framework == 'esx' then
            return Config.Work.EsxSocietyPrefix .. jobName
      else
            return jobName
      end
end

---@param jobName string
---@return number
function Utils:getSocietyBalance(jobName)
      if self.framework == 'esx' then
            local name = Config.Work.EsxSocietyPrefix .. jobName
            local society = exports.esx_addonaccount:GetSharedAccount(name)
            return society.money
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            if Config.Work.useOkokBanking and GetResourceState('okokBanking') == 'started' then
                  return exports['okokBanking']:GetAccount(jobName)
            end
            if self.hasExports('qb-management', 'GetAccount') then
                  return exports['qb-management']:GetAccount(jobName)
            else
                  return exports['qb-banking']:GetAccountBalance(jobName)
            end
      end
      return 0
end

---@param source number
---@param jobName string
---@param amount number
function Utils:depositSocietyMoney(source, jobName, amount)
      if self.framework == 'esx' then
            local name = Config.Work.EsxSocietyPrefix .. jobName
            -- TriggerClientEvent('okokPhone:Client:DepositMoneyOnESXSociety', source, name, amount)
            local society = exports.esx_addonaccount:GetSharedAccount(name)
            society.addMoney(amount)
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            if Config.Work.useOkokBanking and GetResourceState('okokBanking') == 'started' then
                  return exports['okokBanking']:AddMoney(jobName, amount)
            end
            if self.hasExports('qb-management', 'AddMoney') then
                  exports['qb-management']:AddMoney(jobName, amount)
            else
                  exports['qb-banking']:AddMoney(jobName, amount)
            end
      end
end

---@param source number
---@param jobName string
---@param amount number
function Utils:withdrawSocietyMoney(source, jobName, amount)
      if self.framework == 'esx' then
            function self:withdrawSocietyMoney(source, jobName, amount)
                  local name = Config.Work.EsxSocietyPrefix .. jobName
                  -- TriggerClientEvent("okokPhone:Client:WithdrawMoneyOnESXSociety", source, name, amount)
                  local society = exports.esx_addonaccount:GetSharedAccount(name)
                  society.removeMoney(amount)
            end
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            if Config.Work.useOkokBanking and GetResourceState('okokBanking') == 'started' then
                  return exports['okokBanking']:RemoveMoney(jobName, amount)
            end
            if self.hasExports('qb-management', 'RemoveMoney') then
                  function self:withdrawSocietyMoney(source, jobName, amount)
                        exports['qb-management']:RemoveMoney(jobName, amount)
                  end
            else
                  function self:withdrawSocietyMoney(source, jobName, amount)
                        exports['qb-banking']:RemoveMoney(jobName, amount)
                  end
            end
      end
      self:withdrawSocietyMoney(source, jobName, amount)
end

---@alias VehicleList table<string, {name:string, model:string}>

---@return VehicleList
function Utils:getVehicleLabels()
      if self.framework == 'esx' then
            local result = MySQL.prepare.await("SELECT name, model FROM vehicles")
            local vehicles = {} --[[ @as VehicleList ]]
            if not result then return vehicles end
            for _, v in ipairs(result) do
                  vehicles[v.model] = { name = v.name, model = v.model }
            end
            return vehicles
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            local list = Framework.Shared.vehicles
            local vehicles = {} --[[ @as VehicleList ]]
            for _, v in ipairs(list) do
                  vehicles[v.model] = { name = v.name, model = v.model }
            end
            return vehicles
      end
      return {}
end

---@return {name:string, charId: string} | false
function Utils:getVehicleOwnerInfo(plate)
      if CurrentFramework == "qb" or CurrentFramework == "qbx" then
            local result = MySQL.prepare.await([[
                        SELECT p.charinfo, p.citizenid
                        FROM player_vehicles v
                        JOIN players p ON v.citizenid = p.citizenid
                        WHERE v.plate = ?
                    ]], { plate })
            if not result then return false end
            local charInfo = json.decode(result.charinfo)
            return { name = charInfo.firstname .. " " .. charInfo.lastname, charId = result.citizenid }
      elseif CurrentFramework == "esx" then
            local result = MySQL.prepare.await([[
                        SELECT p.firstname, p.lastname, p.identifier
                        FROM owned_vehicles v
                        JOIN users p ON v.owner = p.identifier
                        WHERE v.plate = ?
                    ]], { plate })
            if not result then return false end
            return { name = result.firstname .. " " .. result.lastname, charId = result.identifier }
      elseif CurrentFramework == "ox" then
            local result = MySQL.prepare.await([[
                        SELECT p.firstName, p.lastName, p.charId
                        FROM vehicles v
                        JOIN characters p ON v.owner = p.charId
                        WHERE v.plate = ?
                    ]], { plate })
            if not result then return false end
            return { name = result.firstName .. " " .. result.lastName, charId = result.charId }
      else
            return false
      end
end

return Utils
