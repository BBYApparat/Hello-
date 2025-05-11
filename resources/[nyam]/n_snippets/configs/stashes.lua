Config.Stashes = {
    restricted = {
        {
            id = "myUniquE_Id-GGaa3355", -- Must be unique!
            label = "Police - Ambulance",
            type = "stash", -- "stash = Stash, personal = Personal"
            jobs = {"police", "ambulance"},
            jobGrades = {1, 5, 11}, -- You can use "all" or table of grade levels example: {1, 5, 11}
            inventory = {slots = 25, weight = 50},
            coords = vec4(-512.67, 277.03, 83.25, 134.91)
        },
    },
    personal = {
        {
            id = "myUniquePersonalStash_iD-11e", -- Must be unique!
            label = "Personal Police - Ambulance",
            type = "personal", -- "stash = Stash, personal = Personal"
            jobs = {"police", "ambulance"},
            jobGrades = {1, 5, 11}, -- You can use "all" or table of grade levels example: {1, 5, 11}
            inventory = {slots = 25, weight = 50},
            coords = vec4(-513.69, 278.61, 83.27, 123.28)
        },
    },
    public = {

    }
}