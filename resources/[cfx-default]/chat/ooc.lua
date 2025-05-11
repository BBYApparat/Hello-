RegisterNetEvent('chat:ooc')
AddEventHandler('chat:ooc', function(id, name, head, message, time)
    local id1 = PlayerId()
    local id2 = GetPlayerFromServerId(id) 
    if id2 == id1 then
        TriggerEvent('chat:addMessage', {
			template = '<div class="chat-message ooc"><i class="fas fa-door-open"></i> <span style="color: #7d7d7d">[OOC] {0} <span style="margin-top: 5px; font-weight: 300;">{1}</span></div>',
			args = { head, message, time }
		})
    elseif id2 > 0 and #(GetEntityCoords(GetPlayerPed(id1)) - GetEntityCoords(GetPlayerPed(id2))) < Config.OOCDistance then
        TriggerEvent('chat:addMessage', {
			template = '<div class="chat-message ooc"><i class="fas fa-door-open"></i> <span style="color: #7d7d7d">[OOC] {0} <span style="margin-top: 5px; font-weight: 300;">{1}</span></div>',
			args = { head, message, time }
		})
    end
end)