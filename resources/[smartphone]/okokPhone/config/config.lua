return {
      welcome_title = 'Phone',
      locale = 'en', -- Language file - locales/ folder

      --- UI Formating (time, currency, etc...)
      --- Find locales: https://gist.github.com/luxu-gg/b70f01850942dfe91369a21262f5a89f
      formatting = {
            locale = 'en-US',
            currency = 'USD',
            currencySymbol = '$', -- Used for some places that don't allow proper formatting
      },

      PhoneNumber = {
            prefix = '91', -- Prefix for the phone number
            length = 9,    -- Total Length of the phone number
            -- WARNING ⚠️ If you change this:
            -- you may need to change the phone_number column length in the database tables: okokphone_phones and okokphone_backups
      },
      PlayerCoordsCacheDelay = 10000,    -- 10 seconds
      -- Delay between the execution of one giant query with all the new messages since the last delay
      SaveChatMessagesDelay = 60 * 1000, -- 60 seconds

      --[[ Media Uploads ]]

      UploadMethod = 'fivemanage',              -- Options: fivemanage | fivemerr
      PrioritisePresignedUrlIfAvailable = true, -- If enabled (Fivemange only at this moment), will generate presigned url (if available from the api provider) for uploads so the server doesn't need to handle the upload
      ServerSideUploads = true,                 -- If enabled, media uploads will be handled by the server and api.json keys will not be exposed to the client
      -- Disable this if you are chinese, Only works for fivemanage
      -- Disable this if you are experiencing problems with the media uploads

      --[[ Inventory ]]
      --[[ Auto will attempt to detect the inventory system automatically ]]
      --[[ Note: If you have ps-inventory or lj-inventory, change it to "qb" ]]
      Inventory = 'ox', -- Options: auto, qb, ox, qs, codem, origen, ak47, tgiann
      ----[[ 💀 Death Screen 💀 ]]
      -- Triggered after the player dies
      DeathScreen = {
            enabled = false,
            sound = true,                                      -- Enable sound
            jobs_notified = { "ambulance", --[[ "police" ]] }, -- Jobs that will receive a notification when a player dies
      },

      --[[ 📞 Calls ]]
      -- Uses GTA V's Zones to determine signal strength
      -- Dead zones can't make calls
      CellPhoneDynamicSignal = false, -- Disable to use a static signal strength

      --[[ 📱 Phone  ]]
      Phone = {
            item = {
                  enabled = false,       -- If disabled, it wont check if player has a phone item
                  name = 'phone', -- Item name, used to check if player has a phone
                  unique_phones = true, -- If enabled, each phone will be unique
            },
            command = {
                  -- Command will only be registered if item.enabled is disabled
                  name = 'phone',
                  description = 'Open Phone',
                  keybinding = {
                        name = 'phone', -- This is just for the keybinding, it doesn't affect the command
                        enabled = true,
                        key = 'F1',
                        -- 👆 After first use, you need to change it in the pause menu Settings -> FiveM -> keybinds
                  },
            },
      },
      --[[ Requires a supported inventory for metadata ]]
      SimCards = {
            enabled = true,
            item_name = 'simcard',
      },


      --- Command name: okokphone_installdb
      --- Running this command will install the database and stop the resource.
      InstallDB_Command = true,

      --[[ ⌨️ Chat Commands ]]
      Commands = {
            {
                  name = 'resetpin',
                  enabled = true,
                  id = 'resetpin',
                  props = {
                        help = 'Reset your phone pin',
                        params = { {
                              name = 'pincode',
                              help = 'New pin code',
                              type = 'number',
                              optional = false,
                        } },
                  },
            },
            {
                  name = 'phonefix',
                  enabled = true,
                  id = 'phonefix',
                  props = {
                        help = 'Fix phone/camera bugs',
                  },
            },
            {
                  name = 'verifyvaccount', -- ✅ You can change this
                  enabled = true,
                  id = 'verifyvaccount',   -- ❌ Do not change this
                  props = {
                        help = 'Toggle verification of a V account',
                        params = { {
                              name = 'username',
                              help = 'Account username',
                              type = 'string',
                              optional = false,
                        }, {
                              name = 'state',
                              help = 'true/false - toggle verification',
                              type = 'string',
                              optional = false,
                        } },
                        restricted = true,
                  },
            }, {
            name = 'verifyvmod', -- ✅ You can change this
            enabled = true,
            id = 'verifyvmod',   -- ❌ Do not change this
            props = {
                  help = 'Toggle verification of a V moderator',
                  params = { {
                        name = 'username',
                        help = 'Account username',
                        type = 'string',
                        optional = false,
                  }, {
                        name = 'state',
                        help = 'true/false - toggle verification',
                        type = 'string',
                        optional = false,
                  } },
                  restricted = true,
            },
      }, {
            name = 'phonenumber', -- ✅ You can change this
            enabled = true,
            id = 'phonenumber',   -- ❌ Do not change this
            props = { help = 'Print and Copy Your Phone Number' },
      }, {
            name = 'createemail', -- ✅ You can change this
            enabled = true,
            id = 'createemail',   -- ❌ Do not change this
            props = {
                  help = 'Create a new email account',
                  params = { {
                        name = 'alias',
                        help = 'e.g. john | john@domain.com',
                        type = 'string',
                        optional = false,
                  }, {
                        name = 'password',
                        help = 'Account password',
                        type = 'string',
                        optional = false,
                  } },
                  restricted = true,
            },
      },
            {
                  name = 'resetemailpassword', -- ✅ You can change this
                  enabled = true,
                  id = 'resetemailpassword',   -- ❌ Do not change this
                  props = {
                        help = 'Reset your email account password',
                        params = { {
                              name = 'address',
                              help = 'Email address',
                              type = 'string',
                              optional = false,
                        }, {
                              name = 'password',
                              help = 'New password',
                              type = 'string',
                              optional = false,
                        } },
                        restricted = true,
                  },
            },
            {
                  name = '911', -- ✅ You can change this
                  enabled = true,
                  id = '911',   -- ❌ Do not change this
                  props = {
                        help = 'Notify emergency services',
                        params = { {
                              name = 'reason',
                              help = 'Reason for the call',
                              type = 'string',
                              optional = false,
                        } },
                  },
                  jobs_notified = { "ambulance" },
                  notify_cooldown = 60 * 1000, -- 60 seconds
            },
            {
                  name = '311', -- ✅ You can change this
                  enabled = true,
                  id = '311',   -- ❌ Do not change this
                  props = {
                        help = 'Notify police department',
                        params = { {
                              name = 'reason',
                              help = 'Reason for the call',
                              type = 'string',
                              optional = false,
                        } },
                        restricted = true,
                  },
                  jobs_notified = { "police" },
                  notify_cooldown = 60 * 1000, -- 60 seconds
            },
      },
      Camera = {
            max_quality = 1080, -- Maximum height (quality): 2160 | 1440 | 1080 | 720 | 480
            controls = {
                  -- https://docs.fivem.net/docs/game-references/controls/
                  Toggle_Mouse = {
                        index = 44,
                        label = 'INPUT_COVER',
                  },
                  Toggle_Front_Camera = {
                        index = 38,
                        label = 'INPUT_PICKUP',
                  },
                  Record = {
                        index = 24,
                        label = 'INPUT_ATTACK',
                  },
            },
      },

      Payphone = {
            enabled = true,
            label = "Payphone ($5/min)",
            cost_per_minute = 5,
            money_account = "cash",
            models = {
                  -- I can only garantee animations for these 2 models
                  `p_phonebox_01b_s`,
                  `sf_prop_sf_phonebox_01b_s`,
                  -- No animations for these models
                  `p_phonebox_02_s`,
                  `prop_phonebox_01a`,
                  `prop_phonebox_01b`,
                  `prop_phonebox_01c`,
                  `prop_phonebox_02`,
                  `prop_phonebox_03`,
                  `prop_phonebox_04`,
            },
            spawn_locations = {
                  -- Optional spawn locations
                  { coords = vector4(46.11, -675.5, 43.22, 70.00),  model = `p_phonebox_01b_s` },
                  { coords = vector4(47.16, -672.41, 43.22, 70.00), model = `sf_prop_sf_phonebox_01b_s` },
            },
            textUi = {
                  enabled = true,
                  keybind = "E"
            },
            useTarget = true
      },

      -- Optional Keybindings
      Keybindings = {
            answer = {
                  key = 'PageUp',
                  description = 'Answer incoming calls',
                  enabled = false,
            },
            hangup = {
                  key = 'PageDown',
                  description = 'Reject incoming calls',
                  enabled = false,
            },
      },

      --[[ Used for Video Calls and Live Streaming ]]
      webRTC = {
            enabled = true,
            turnServer = {
                  enabled = true, -- Use okokPhone's built in turn server
                  settings = {
                        --- Open this port on your vps firewall or router if localhosting
                        port = 3478,
                        debug = "OFF", -- "OFF" | "FATAL" | "ERROR" | "WARN" | "INFO" | "DEBUG" | "TRACE" | "ALL"
                        overrideOptions = {
                              enabled = false,
                              listeningIps = { '0.0.0.0' },
                              relayIps = {},
                              externalIps = {},
                        }
                  },
                  external = {
                        enabled = false, -- Enable this if you want to use an external turn server
                        servers = {
                              {
                                    urls = "stun:stun.relay.metered.ca:80",
                              },
                              {
                                    urls = "turn:global.relay.metered.ca:80",
                                    username = "b76f15ce83932262267c076f",
                                    credential = "47G8gr06DKuwdgbN",
                              },
                              {
                                    urls = "turn:global.relay.metered.ca:80?transport=tcp",
                                    username = "b76f15ce83932262267c076f",
                                    credential = "47G8gr06DKuwdgbN",
                              },
                              {
                                    urls = "turn:global.relay.metered.ca:443",
                                    username = "b76f15ce83932262267c076f",
                                    credential = "47G8gr06DKuwdgbN",
                              },
                              {
                                    urls = "turns:global.relay.metered.ca:443?transport=tcp",
                                    username = "b76f15ce83932262267c076f",
                                    credential = "47G8gr06DKuwdgbN",
                              },
                        }
                  },
            },
      },
      settings = {
            wallpapers = {
                  './images/wallpapers/1.jpg',
                  './images/wallpapers/2.jpg',
                  './images/wallpapers/3.jpg',
                  './images/wallpapers/4.jpg',
                  './images/wallpapers/5.jpg',
                  './images/wallpapers/6.jpg',
            },
            lockscreens = {
                  './images/lockscreen/1.png',
                  './images/lockscreen/2.png',
                  './images/lockscreen/3.png',
                  './images/lockscreen/4.png',
                  './images/lockscreen/5.png',
                  './images/lockscreen/6.png',
            },
            notifications = { {
                  label = 'Notification 1',
                  url = './audio/notifications/1.mp3',
            }, {
                  label = 'Notification 2',
                  url = './audio/notifications/2.mp3',
            }, {
                  label = 'Notification 3',
                  url = './audio/notifications/3.mp3',
            }, {
                  label = 'Notification 4',
                  url = './audio/notifications/4.mp3',
            } },
            ringtones = { {
                  label = 'Ringtone 1',
                  url = './audio/ringtones/1.mp3',
            }, {
                  label = 'Ringtone 2',
                  url = './audio/ringtones/2.mp3',
            }, {
                  label = 'Ringtone 3',
                  url = './audio/ringtones/3.mp3',
            }, {
                  label = 'Ringtone 4',
                  url = './audio/ringtones/4.mp3',
            }, {
                  label = "Franklin's Ringtone",
                  url = './audio/ringtones/5.mp3',
            } },
      },
      alarms = { {
            label = 'Notification 1',
            url = './audio/alarms/1.wav',
      } },
      DEBUG = true, -- true, false
}
