local duration = 5000

---@param data {title:string, message:string, type: "info" | "error" | "warning"}
function Notify(data)
      -- Check which func ref is calling this function
      if GetResourceState("okokNotify") == "started" then
            exports['okokNotify']:Alert(data.title, data.message, duration, data.type, true)
      else
            exports.ox_lib:notify({
                  type        = data.type,
                  title       = data.title,
                  description = data.message
            })
      end
end
