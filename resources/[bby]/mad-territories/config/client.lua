return {

    -- blip colors for each gang (must match core) you can add more 

    gangColors = {
        ["ballas"] = 7,
        ["vagos"] = 46,
        ["lostmc"] = 40,
    },

    useDrugSellingSystem = true, -- if you want to use or not the drug selling system

    useRobNpcSystem = true, -- if you want to use or not the rob npc system

    robAnimationTime = 5, --how much time you take to rob in seconds

    timeBetweenDrugBuyers = 10, --time in seconds between each ped that buy you stuff

    negotiateTimer = 10, --how much time you will have to negociate in seconds

    graffitiRadius = 100.0,   --radius for each graffiti (need to be float)

    graffitiProgressbarTimer = 20000, --time for progressbar in ms

    CleanGraffitiProgressbarTimer = 20000,

    everyoneCanSeeGangBlips = true, --if everyone can blips or just the gangs

    madrazoCoords = vec4(244.41, 372.94, 105.74, 162.97), --coords for madrazo

    BlacklistedZones = {
        {coords = vector3(455.81, -997.04, 43.69), radius = 200.0}, -- Police
        {coords = vector3(324.76, -585.72, 59.15), radius = 300.0}, -- Hospital

    },

    chanceToCallCopsDrugSell = 20, --20% of calling cops on drug selling

    chanceToCallCopsRobNpc = 20, --20% of calling cops on rob npc~


    --------------------- car heist stuff -----------------------

    carSpawnLocs = {
        vec4(-1317.81, -1255.3, 4.59, 283.31),
        vec4(-1545.94, -398.74, 41.99, 227.56),
        vec4(-580.51, 314.75, 84.78, 356.64),
    },

    deliverLocs = {
        vec3(-1669.68, -543.32, 35.02),
        vec3(1117.74, -984.33, 46.29),
        vec3(703.19, -1110.22, 22.48),
    },
}