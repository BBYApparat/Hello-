Config = {
    -- Notify = function(message)
    --     print(message)
    -- end,
    voiceScript = "pma-voice",
    defaultVolume = 50,
    prop = {
        model = "prop_cs_hand_radio",
        screen_texture = "script_rt",
        animDict = "cellphone@",
        animName = "cellphone_text_read_base",
        boneIndex = 57005,
        offsetX = 0.14,
        offsetY = 0.005,
        offsetZ = -0.02,
        rotX = 110.0,
        rotY = 105.0,
        rotZ = -15.0,
        buttons = {
            toggle = {
                offset = vector3(0.005, 0.005, 0.055),
                text = "Toggle Radio",
            },
            volumeUp = {
                offset = vector3(0.04, 0.005, 0.00),
                text = "Volume Up",
            },
            volumeDown = {
                offset = vector3(0.04, 0.005, -0.02),
                text = "Volume Down",
            },
            connect = {
                offset = vector3(0.015, -0.0125, -0.05),
                text = "Connect",
            },
            disconnect = {
                offset = vector3(-0.015, -0.0125, -0.05),
                text = "Disconnect",
            },
        }
    },
    debugButtons = false, -- Set to true to add markers to the button positions
    functions = { -- Functions to call when a button is pressed
        toggle = function()
            RADIO_ENABLED = not RADIO_ENABLED
            exports["pma-voice"]:setVoiceProperty("radioEnabled", RADIO_ENABLED)
            Notify("Radio " .. (RADIO_ENABLED and "enabled" or "disabled"))
        end,
        volumeUp = function()
            if RADIO_VOLUME <= 95 then
                RADIO_VOLUME = RADIO_VOLUME + 5
            end
            Notify("Radio volume: " .. RADIO_VOLUME)

            if Config.voiceScript == "pma-voice" then
                exports["pma-voice"]:setRadioVolume(RADIO_VOLUME)
            end
        end,
        volumeDown = function()
            if RADIO_VOLUME >= 10 then
                RADIO_VOLUME = RADIO_VOLUME - 5
            end
            Notify("Radio volume: " .. RADIO_VOLUME)

            if Config.voiceScript == "pma-voice" then
                exports["pma-voice"]:setRadioVolume(RADIO_VOLUME)
            end
        end,
        connect = function(channel)
            if Config.voiceScript == "pma-voice" then
                exports["pma-voice"]:setRadioChannel(channel)
            end
        end,
        disconnect = function()
            if Config.voiceScript == "pma-voice" then
                exports["pma-voice"]:setRadioChannel(0)
            end
        end,
    },
    cam = {
        fov = 45.0,
        offset = vector3(0.1, 0.25, 0.75),
        rotation = vector3(-75.0, 10.0, -10.0)
    },
}