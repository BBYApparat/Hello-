Config = {}

Config.UsingESX = true
Config.UsingQBCore = false

-- You can set this to false to disable this feature.
-- NOTE: The keybind is configurable for every user in the settings menu inside the mdt.
Config.DefaultKeybind = 'Delete' -- Refers the to table toward the bottom of the file

-- You can set this to false to disable this feature.
Config.Command = 'mdt'

-- This determines whether or not to fetch for a users' custom set keybind before they login.
-- This ensures that their set keybind works before logging in to the mdt. Setting this to false will-
-- fetch the keybind upon logging in to the mdt. (This may prevent issues with fetching before identifier has loaded)
Config.KeybindBeforeLogin = true

-- Jobs that have access to the mdt
Config.JobAccess = {
    'police',
    'ambulance',
    'doj'
}

Config.Fines = {
    -- A command that will open a fines menu to pay off fines
    -- You can set this to false to disable this feature.
    Command = 'fines',

    -- Locations that people can go to pay off fines (No blips by default)
    Locations = {
        vector3(195.9, -406.3, 45.2),
    },

    -- If players log in with fines that are unpaid and overdue, they will automatically be paid (despite the amount of money they have)
    AutopayOverdueFines = true,
}

Config.Markers = {
    Type = 23,
    Size = {
        x = 0.6,
        y = 0.6,
        z = 0.6,
    },
    Color = {
        r = 227,
        g = 121,
        b = 38,
    }
}

-- To use this, go to https://imgbb.com/ and create an account. After doing so, click on "About" on the top left.
-- After that, create and copy an API key. You will paste this key below (Make sure to set 'usingImgbb' to true)
Config.ImgAPI = {
    usingImgbb = true,
    APIkey = '7d57f0629f6c60ef6f4a818974c6397c',
}

Config.TakePhoto = function(cb)
    if Config.ImgAPI and Config.ImgAPI.APIkey then
        exports['screenshot-basic']:requestScreenshotUpload('https://api.imgbb.com/1/upload?key=' .. Config.ImgAPI.APIkey, 'image', function(data)
            local resp = json.decode(data)

            if resp then
                cb(resp.data.url)
            else
                cb(false)
            end
        end)
    else
        -- Change this to what works for you if you decide not to use the imgbb API
        exports['screenshot-basic']:requestScreenshotUpload('http://127.0.0.1/upload.php', 'files', function(data)
            local resp = json.decode(data)

            if resp then
                cb(resp.files[1].url)
            else
                cb(false)
            end
        end)
    end
end

-- Keybinds people have to choose from
Config.Keybinds = {
    ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F9"] = 56, ["F10"] = 57,
    ["Backquote"] = 243, ["Digit1"] = 157, ["Digit2"] = 158, ["Digit3"] = 160, ["Digit4"] = 164, ["Digit5"] = 165, ["Digit6"] = 159, ["Digit7"] = 161, ["Digit8"] = 162, ["Digit9"] = 163, ["Minus"] = 84, ["Equal"] = 83,
    ["Tab"] = 37, ["KeyQ"] = 44, ["KeyE"] = 38, ["KeyR"] = 45, ["KeyY"] = 246, ["KeyU"] = 303, ["KeyP"] = 199, ["BracketLeft"] = 39, ["BracketRight"] = 40,
    ["KeyG"] = 47, ["KeyH"] = 74, ["KeyK"] = 311, ["KeyL"] = 182,
    ["KeyZ"] = 20, ["KeyX"] = 73, ["KeyC"] = 26, ["KeyB"] = 29, ["KeyN"] = 249, ["KeyM"] = 244, ["Comma"] = 82, ["Period"] = 81,
    ["ControlLeft"] = 36, ["AltLeft"] = 19, ["ControlRight"] = 70,
    ["Home"] = 212, ["PageUp"] = 10, ["PageDown"] = 11, ["Delete"] = 178,
    ["ArrowLeft"] = 174, ["ArrowRight"] = 175, ["ArrowUp"] = 27, ["ArrowDown"] = 173,
    ["Numpad4"] = 108, ["Numpad5"] = 60, ["Numpad6"] = 107, ["NumpadAdd"] = 96, ["NumpadSubtract"] = 97, ["Numpad7"] = 117, ["Numpad8"] = 61, ["Numpad9"] = 118
}