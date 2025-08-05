return {
  refresh_delay = 10,  --- seconds before the online businesses are refreshed
  cooldown_delay = 60, --- seconds before a player can reopen a chat for the same job
  jobs = {
    {
      id = "police",                                 -- Must be unique, doesn't matter what it is
      jobs = { 'police', 'special_forces' }, -- DONT MIX JOBS IN DIFFERENT SERVICES, THEY CAN ONLY BE IN ONE SERVICE
      label = 'Police',
      logo = "./services/police.png"
    },
    {
      id = "ambulance",
      jobs = { 'ambulance' },
      label = 'Ambulance',
      logo = "./services/ambulance.png"
    },
    {
      id = "mechanic",
      jobs = { 'mechanic' },
      label = 'Mechanic',
      logo = "./services/mechanic.png"
    },
    {
      id = "taxi",
      jobs = { 'taxi' },
      label = 'Taxi',
      logo = "./services/taxi.png"
    }
  },
}


--[[ Notes ]]
--[[

Your own job will not be shown in the services app.
Example:
If your character is in the police job, you will not see it in the services app.

]]
