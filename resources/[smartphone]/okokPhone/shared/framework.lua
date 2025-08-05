---@module 'framework_object_getter'

local qbCoreResourceName = 'qb-core'
local esxResourceName = 'es_extended'
local esxEvent = 'esx:getSharedObject'

local prom = promise.new()

if GetResourceState('qbx_core') == 'started' then -- QBOX
      local obj = exports[qbCoreResourceName]:GetCoreObject()
      prom:resolve({
            name = 'qbx',
            funcs = obj,
      })
elseif GetResourceState(qbCoreResourceName) == 'started' then -- QBCore
      local obj = exports[qbCoreResourceName]:GetCoreObject()
      prom:resolve({
            name = 'qb',
            funcs = obj,
      })
elseif GetResourceState(esxResourceName) == 'started' then -- ESX
      if hasExports(esxResourceName, 'getSharedObject') then
            prom:resolve({
                  name = 'esx',
                  funcs = exports[esxResourceName]:getSharedObject(),
            })
      else
            TriggerEvent(esxEvent, function(obj)
                  prom:resolve({
                        name = 'esx',
                        funcs = obj,
                  })
            end)
      end
elseif GetResourceState('ox_core') == 'started' then -- OX
      Ok.require('@ox_core.lib.init')
      prom:resolve({
            name = 'ox',
            funcs = Ox,
      })
else
      Ok.print.error("Framework not detected")
      Ok.print.warning("Make sure okokPhone is the last resource to load")
      Ok.print.error("If your framework is custom, please edit shared/framework.lua")
      prom:reject()
end

return Citizen.Await(prom) --[[ @as {name: "qb" | "qbx" | "esx" | "ox", funcs: table<string, function>} ]]
