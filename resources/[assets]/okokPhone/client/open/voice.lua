---@class VoiceHandler
local voiceHandler = {}

local voiceScript = 'pma-voice'

---@param id number channel id
function voiceHandler.setCallChannel(id)
  if voiceScript == 'pma-voice' then
    exports['pma-voice']:setCallChannel(id)
  elseif voiceScript == 'mumble-voip' then
    exports['mumble-voip']:SetCallChannel(id)
  elseif voiceScript == 'saltychat' then
    TriggerServerEvent('okokPhone:Server:SetCallChannel', id)
  end
end

---@param volume number
function voiceHandler.setVolume(volume)
  if voiceScript == 'pma-voice' then
    exports['pma-voice']:setCallVolume(volume)
  elseif voiceScript == 'mumble-voip' then
    exports['mumble-voip']:setCallVolume(volume)
  elseif voiceScript == 'saltychat' then
  end
end

---@param channelId number
function voiceHandler.setRadioChannel(channelId)
  if voiceScript == 'pma-voice' then
    exports['pma-voice']:setRadioChannel(channelId)
  elseif voiceScript == 'mumble-voip' then
    exports['mumble-voip']:setRadioChannel(channelId)
  elseif voiceScript == 'saltychat' then
    exports['saltychat']:SetRadioChannel(tostring(channelId), true)
  end
end

function voiceHandler.removePlayerFromRadio()
  if voiceScript == 'pma-voice' then
    exports['pma-voice']:removePlayerFromRadio()
  elseif voiceScript == 'mumble-voip' then
    exports['mumble-voip']:removePlayerFromRadio()
  elseif voiceScript == 'saltychat' then
    local currentChannel = exports['saltychat']:GetRadioChannel(true)
    TriggerServerEvent(
      'okokPhone:Server:RemovePlayerFromRadio',
      currentChannel
    )
  end
end

function voiceHandler.getRadioChannel()
  if voiceScript == 'pma-voice' then
    return LocalPlayer.state.radioChannel
  elseif voiceScript == 'mumble-voip' then
    return LocalPlayer.state.radioChannel
  elseif voiceScript == 'saltychat' then
    return exports['saltychat']:GetRadioChannel(true)
  end
end

--- Auto Checker

local voiceScripts = {
  'pma-voice',
  'mumble-voip',
  'saltychat',
}

AddEventHandler('onResourceStart', function(r)
  if r ~= GetCurrentResourceName() then return end

  for _, resourceName in pairs(voiceScripts) do
    if GetResourceState(resourceName) == 'started' then
      voiceScript = resourceName
      return
    end
  end

  local autoDetectorEvent

  autoDetectorEvent = AddEventHandler('onResourceStart', function(resource)
    for _, resourceName in pairs(voiceScripts) do
      if resource == resourceName then
        voiceScript = resourceName
        RemoveEventHandler(autoDetectorEvent)
        return
      end
    end
  end)
end)

return voiceHandler
