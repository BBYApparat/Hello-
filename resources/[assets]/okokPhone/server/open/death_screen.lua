local dispatchJobs = Config.DeathScreen.jobs_notified


local function isDispatchJob(jobName)
  for _, _jobName in ipairs(dispatchJobs) do
    if _jobName == jobName then
      return true
    end
  end
  return false
end

---@param src number
---@param coords {x: number, y: number} | vector(2) | vector(3) | vector(4)
local function notify(src, coords)
  local imei = Phones:getEquippedImei(src)
  if not imei then return end
  Phones:pushNotifyViaImei(imei, {
    app = 'emergencies',
    title = Locales.emergency,
    message = Locales.citizen_injured,
    coords = {
      x = coords.x,
      y = coords.y,
    },
    type = 'emergency',
  })
end

exports("emergencyNotify", notify)

RegisterNetEventOK('notifyEmergencyServices', function()
  local source = tonumber(source) --[[ @as number ]]
  local coords = GetEntityCoords(GetPlayerPed(source))
  if type(dispatchJobs) == 'table' then
    for _, playerObj in pairs(Utils:getPlayersList()) do
      local targetSource = Utils:getPlayerSource(playerObj)
      local job = Utils:getPlayerJobInfo(playerObj)

      if targetSource ~= source and Utils:getDuty(playerObj) and isDispatchJob(job.name) then
        notify(targetSource, coords)
      end
      --
    end
  end
end)
