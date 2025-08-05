---@class Target
local target = {}

---@param models string[]
---@param label string
---@param cb fun(entity: number)
---@param distance number
function target.addModels(models, label, cb, distance)
    if GetResourceState("ox_target") == "started" then
        exports.ox_target:addModel(models, {
            distance = distance,
            label = label,
            onSelect = function(data)
                cb(data.entity)
            end
        })
    elseif GetResourceState("qb-target") == "started" then
        exports["qb-target"]:AddTargetModel(models, {
            options = {
                {
                    label = label,
                    action = function(entity)
                        if type(entity) == "number" and IsAnEntity(entity) then
                            cb(entity)
                        end
                    end
                }
            },
            distance = distance
        })
    end
end

---@param models string[]
function target.cleanupModels(models)
    if GetResourceState("ox_target") == "started" then
        exports.ox_target:removeModel(models)
    elseif GetResourceState("qb-target") == "started" then
        exports["qb-target"]:RemoveTargetModel(models)
    end
end

return target
