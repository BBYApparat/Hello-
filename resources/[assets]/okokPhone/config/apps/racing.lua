--[[ Racing App ]]
return {

  -- Player account used for add and removing money from
  account_name                  = "bank",
  finish_timeout                = 30,   -- seconds, time left to complete the race after the first player crosses the finish line
  end_timeout                   = 3600, -- Seconds, maximum time for race to end after it started, if no one finishes it ends automatically
  minimum_distance_to_join_race = 70,   -- Minimum distance to join the race (Player - 1st Checkpoint)
  disable_collision             = true, -- Disable collision between players and vehicle when racing
  leaderboard_limit             = 50,   -- Maximum number of players to show in the leaderboard
  -- UI when racing_
  ui                            = {
    ending_timer = {
      enabled = true,
      position = { x = 0.015, y = 0.15 },
      scale = 1.0,
    },
    position = {
      enabled = true,
      position = { x = 0.015, y = 0.20 },
      scale = 1.0,
    },
    checkpoints = {
      enabled = true,
      position = { x = 0.015, y = 0.25 },
      scale = 1.0,
    }
  },
  route_creator                 = {
    controls = {
      ADD_CHECKPOINT = 69,    -- LEFT MOUSE BUTTON
      REMOVE_CHECKPOINT = 68, -- RIGHT MOUSE BUTTON
      FINISH = 191,           -- ENTER
      CANCEL = 194,           -- BACKSPACE
    }
  },

  public_races                  = {
    enabled = true,
    routes = { 5 }, -- Create Routes, then add their database id here (check the "routes" menu inside the app, for the id)
    minimum_players = 2,
    maximum_players = 20,
    automatic_start_delay = 20, -- seconds | Triggered when minimum players are reached
    prize = {                   -- Randomly selected between these values
      minimum = 2000,
      maximum = 10000,
    },
    loser_prize = {       -- Prizes for players who didn't win the race
      finished = 500,     -- Completed the race on time
      didnt_finish = 250, -- Didn't finish
    },
    laps = {
      minimum = 1,
      maximum = 1,
    },                         -- Randomly selected between these values
    cooldown = 60 * 60 * 1000, -- 1 hour between new races (seconds)
    elo = {
      startingElo = 1500,
      kFactor = 32,
      abandonPenalty = 100, --- Elo penalty for abandoning
    }
  },

  private_races                 = {
    enabled = true,
  },

  --- This route is used when there are no routes found in the database
  --- Please create routes instead of using this, and add the ids to public_races.routes
  fallbackPublicRoute           = {
    title = "Test Route",
    zone_name = "TERMINA",
    checkpoints =
    '[{"x":902.8487548828125,"y":-3227.42529296875,"z":5.48296737670898},{"x":966.0536499023438,"y":-3228.037353515625,"z":5.45306777954101},{"x":1064.186279296875,"y":-3228.225341796875,"z":5.4698781967163},{"x":1079.5660400390626,"y":-3184.25537109375,"z":5.45731401443481},{"x":1080.8372802734376,"y":-3002.92333984375,"z":5.48825168609619},{"x":985.7046508789063,"y":-3004.125,"z":5.47932863235473},{"x":881.343017578125,"y":-3002.0517578125,"z":5.47763156890869},{"x":882.0929565429688,"y":-3218.0810546875,"z":5.48672676086425}]'
  }
}
