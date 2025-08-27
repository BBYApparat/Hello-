-- NUI focus uit bij start
Citizen.CreateThread(function()
    SetNuiFocus(false, false)
end)

-- Exporteer de Alert functie zoals jij wil gebruiken
exports('Alert', function(title, message, time, type)
    local color = 'blue'

    if type == 'error' then
        color = 'red'
    elseif type == 'inform' then
        color = 'blue'
    elseif type == 'success' then
        color = 'green'
    elseif type == 'warning' then
        color = 'yellow'
    elseif type == 'orange' then
        color = 'orange'
    elseif type == 'purple' then
        color = 'purple'
    elseif type == 'teal' then
        color = 'teal'
    elseif type == 'pink' then
        color = 'pink'
    end

    SendNUIMessage({
        action = 'notify',
        text = message or 'Geen bericht meegegeven',
        color = color
    })
end)
