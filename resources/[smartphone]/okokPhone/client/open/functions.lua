---@class ClientUtils
local cUtils = {
      framework = CurrentFramework
}

---@return table | nil playerObj
function cUtils:GetPlayerData()
      if self.framework == 'esx' then
            return Framework.GetPlayerData();
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            return Framework.Functions.GetPlayerData()
      end
end

---@return string
function cUtils:getCharId()
      if self.framework == 'esx' then
            return Framework.GetPlayerData().identifier;
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            return Framework.Functions.GetPlayerData().citizenid
      end
      return ""
end

---@param vehicle number
---@param plate string
---@param model string
function cUtils:GiveVehicleKeys(vehicle, plate, model)
      local resources = {
            { name = "okokGarage",      event = "okokGarage:GiveKeys",                      args = { plate },        type = "server" },
            { name = "qbx_vehiclekeys", event = 'qb-vehiclekeys:server:AcquireVehicleKeys', args = { plate },        type = "server" },
            { name = "qb-vehiclekeys",  event = 'qb-vehiclekeys:server:AcquireVehicleKeys', args = { plate },        type = "server" },
            { name = "qs-vehiclekeys",  event = 'GetKey',                                   args = { plate },        type = "export" },
            { name = "cd_garage",       event = 'cd_garage:AddKeys',                        args = { plate },        type = "client" },
            { name = "gflp10-carkeys",  event = 'LuxuModules:Server:GiveKeyItem',           args = { model, plate }, type = "server" },
            { name = "wasabi_carlock",  event = 'GiveKey',                                  args = { plate, false }, type = "export" }
      }

      for _, resource in ipairs(resources) do
            if isResourceRunning(resource.name) then
                  if resource.type == "server" then
                        TriggerServerEvent(resource.event, table.unpack(resource.args))
                  elseif resource.type == "client" then
                        TriggerEvent(resource.event, table.unpack(resource.args))
                  elseif resource.type == "export" then
                        exports[resource.name][resource.event](table.unpack(resource.args))
                  end
            end
      end

      TriggerEvent("vehiclekeys:client:SetOwner", plate)
end

---@return boolean
function cUtils:isDead()
      if GetResourceState("visn_are") == "started" then
            return exports['visn_are']:GetHealthBuffer().unconscious
      end

      local playerData = cUtils:GetPlayerData()
      if self.framework == 'qb' or self.framework == 'qbx' then
            if not playerData then return false end
            return playerData?.metadata?["isdead"] == true or playerData?.metadata?["inlaststand"] == true
      elseif self.framework == 'esx' then
            if not playerData then return false end
            return playerData.dead == true
      elseif self.framework == 'ox' then
            return LocalPlayer.state.isDead
      else
            return IsEntityDead(PlayerPedId())
      end
end

---@param vehicle number
---@param mods table
function cUtils:setVehicleProperties(vehicle, mods)
      if self.framework == "qb" or self.framework == "qbx" then
            Framework.Functions.SetVehicleProperties(vehicle, mods)
      elseif self.framework == "esx" then
            Framework.Game.SetVehicleProperties(vehicle, mods)
      end
end

function cUtils:getItems()
      if self.framework == 'esx' then
            return Framework.GetPlayerData().inventory
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            return Framework.Functions.GetPlayerData().items
      elseif self.framework == 'ox' then
            return exports.ox_inventory:GetPlayerItems()
      end
end

---@return {label:string, grade:string, name:string, gradeName:string, onDuty:boolean, isBoss:boolean} jobInfo
function cUtils:getJob()
      if self.framework == 'esx' then
            local job = Framework.GetPlayerData().job

            local onDuty
            if GetResourceState("okokBossMenu") == "started" then
                  onDuty = exports['okokBossMenu']:isJobOnDuty()
            else
                  onDuty = string.find(job.name, "off") == nil
            end

            return {
                  label = job.label,
                  grade = job.grade,
                  gradeName = job.grade_name,
                  name = job.name,
                  onDuty = onDuty,
                  isBoss = Ok.table.contains(Config.Work.bossGrades, job.grade_name)
            }
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            local job = Framework.Functions.GetPlayerData().job
            return {
                  label = job.label,
                  grade = job.grade.level,
                  gradeName = job.grade.name,
                  name = job.name,
                  onDuty = job.onduty,
                  isBoss = job.isboss
            }
      end
      return {}
end

---@return {label:string, grade:number}[]
function cUtils:getJobGrades()
      local grades = {}
      if self.framework == 'esx' then
            local job = Framework.GetPlayerData().job
            local jobInfo = triggerServerCallback("esx:getJobInfo", job.name)
            if not jobInfo then return {} end
            for _, v in pairs(jobInfo.grades) do
                  grades[#grades + 1] = {
                        label = v.label,
                        grade = v.grade,
                  }
            end
      elseif self.framework == 'qb' or self.framework == 'qbx' then
            local job = Framework.Functions.GetPlayerData().job
            local jobInfo = Framework.Shared.Jobs[job.name]
            for k, v in pairs(jobInfo.grades) do
                  grades[#grades + 1] = {
                        label = v.name,
                        grade = tonumber(k)
                  }
            end
      end
      return grades
end

---@param ped number
function cUtils:disarm(ped)
      local _, currentWeapon = GetCurrentPedWeapon(ped, true)

      if currentWeapon ~= `WEAPON_UNARMED` then
            if isResourceRunning('ox_inventory') then
                  TriggerEvent("ox_inventory:disarm")
            else
                  ---TODO: Investigate other inventories for potential disarm functions
                  SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                  Wait(2000)
            end
      end
end

function cUtils:vehicleSpawned(vehicle, plate)
      if GetResourceState("jg-advancedgarages") == "started" then
            TriggerServerEvent("jg-advancedgarages:server:register-vehicle-outside", plate, VehToNet(vehicle))
      end
end

return cUtils
