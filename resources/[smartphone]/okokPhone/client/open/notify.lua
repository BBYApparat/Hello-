---@class DynamicIslandNotification
---@field title string
---@field text string
---@field app? string
---@field icon? string
---@field duration number

--- Notify using dynamic island, this is mostly meant for non important notifications like feedback.
---@param data DynamicIslandNotification
function notifyDI(data)
      data.duration = data.duration or 5000
      fetchNUI('notifyDI', data)
end

exports("notifyDI", notifyDI)

RegisterNetEvent('okokPhone:Client:NotifyDI', notifyDI)


--- This 👇 client side event can be triggered by the server
--- TriggerClientEvent("okokPhone:Client:NotifyDynamicIsland", source, data)
