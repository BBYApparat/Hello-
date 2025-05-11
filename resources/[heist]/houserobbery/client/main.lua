ESX = exports["es_extended"]:getSharedObject()

local BlacklistedItemsModels = {}
local robbableHouses = Config.Houses
local robbableItems = Config.RobOffset
local safe = 0
local safepos = {}
local isRobbing = false
local isRaiding = false
local curHouseCoords = {x = 0, y = 0, z = 0}
local lastHouse = nil
local disturbance = 0
local isAgro = false
local myRobbableItems = {}
local robberyped = nil
local pedSpawned = false
local PlayerData = {}
local robbing = {}
local vaultrob = false
local attackDog = nil
local created_targets = {}
local created_targets_for_robbery = {}

PlayerData = ESX.GetPlayerData()

function loadModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(5)
        end
    end
end

local function loadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(5)
        end
    end
end

local function canRaid()
    if PlayerData and PlayerData.job and Config.WhitelistedJobs[PlayerData.job.name] then
        if #robbing > 0 then
            for i = 1, #robbing, 1 do
                local playerCoords = GetEntityCoords(PlayerPedId())
                local hPos = vector3(Config.Houses[robbing[i]].x, Config.Houses[robbing[i]].y, Config.Houses[robbing[i]].z)
                local distance = #(playerCoords - hPos)
                if distance <= 3.0 and not isRaiding then
                    return i
                end
            end
        else
           return false
        end
    else
        return false
    end
end

local function isNight()
    local hours = GetClockHours()
    return (hours >= 20 or hours < 6)
end

local function robberyAlert()
    exports['dispatch']:HouseRobbery()
end

-- local function randomAI(generator)
--     if not isRaiding then
--         local modelhash = GetHashKey("a_m_m_beach_02")
--         loadModel(modelhash)
--         robberyped = CreatePed(GetPedType(modelhash), modelhash, generator.x + 6.86376900, generator.y + 1.20651200, generator.z + 1.36589100, 15.0, 1, 1)
--         SetEntityCoords(robberyped, generator.x + 6.86376900, generator.y + 1.20651200, generator.z + 1.36589100)
--         SetEntityHeading(robberyped, 240.0)
--         SetEntityAsMissionEntity(robberyped, false, true)
--         loadAnimDict("dead")
--         TaskPlayAnim(robberyped, "dead", 'dead_a', 100.0, 1.0, -1, 1, 0, 0, 0, 0)
--         pedSpawned = true
--     end
-- end

local function getRotation(input)
    return 360 / (10 * input)
end

local function closestNPC()
    if DoesEntityExist(robberyped) and not IsEntityDead(robberyped) then
        local playerCoords = GetEntityCoords(PlayerPedId())
        local pedCoords = GetEntityCoords(robberyped)
        return #(playerCoords - pedCoords), 1
    else
        return 0, 0
    end
end

-- local function openGui(disturbance)
--     local msg = "Quiet"
--     if disturbance > 80 then
--         msg = "Danger"
--     elseif disturbance > 60 then
--         msg = "Unsafe"
--     elseif disturbance > 30 then
--         msg = "Safe"
--     end
--     SendNUIMessage({runProgress = true, Length = disturbance, Task = msg})
-- end

-- local function closeGui()
--     SendNUIMessage({closeProgress = true})
-- end

local function CreateSafe(x, y, z)
    safespawned = true
    safepos = {["x"] = x, ["y"] = y, ["z"] = z}
    local model = GetHashKey("prop_ld_int_safe_01")
    loadModel(model)
    safe = CreateObject(model, x, y, z, true, false, false)
    FreezeEntityPosition(safe, true)
end

-- local function agroNPC()
--     CreateThread(function()
--         robberyAlert()
--         ClearPedTasksImmediately(robberyped)
--         SetPedDropsWeaponsWhenDead(robberyped, false)
--         GiveWeaponToPed(robberyped, GetHashKey('WEAPON_BAT'), 150, 0, 1)
--         TaskCombatPed(robberyped, PlayerPedId(), 0, 16)
--         SetPedKeepTask(robberyped, true)
--         while isRobbing do Wait(0) end
--         FreezeEntityPosition(robberyped, true)
--         Wait(3000)
--         if robberyped then
--             if not IsEntityDead(robberyped) then
--                 SetEntityCoords(robberyped, lastHouse)
--                 FreezeEntityPosition(robberyped, false)
--             else
--                 SetEntityAsNoLongerNeeded(robberyped)
--                 DeleteEntity(robberyped)
--             end
--         end
--     end)
-- end

local function buildBasicHouse(generator)
    SetEntityCoords(PlayerPedId(), 347.04724121094, -1000.2844848633, -99.194671630859)
    FreezeEntityPosition(PlayerPedId(), true)
    Wait(2000)
    local model = GetHashKey("clrp_house_1")
    loadModel(model)
    local building = CreateObject(model, generator.x, generator.y - 0.05, generator.z + 1.26253700 - 89.825, false, false, false)
    FreezeEntityPosition(building, true)
    Wait(500)
    SetEntityCoords(PlayerPedId(), generator.x + 3.6, generator.y - 14.8, generator.z + 1.9)
    SetEntityHeading(PlayerPedId(), 358.106)
    local dt = CreateObject(GetHashKey("V_16_DT"), generator.x - 1.21854400, generator.y - 1.04389600, generator.z + 1.39068600, false, false, false)
    local mpmid01 = CreateObject(GetHashKey("V_16_mpmidapart01"), generator.x + 0.52447510, generator.y - 5.04953700, generator.z + 1.32, false, false, false)
    local mpmid09 = CreateObject(GetHashKey("V_16_mpmidapart09"), generator.x + 0.82202150, generator.y + 2.29612000, generator.z + 1.88, false, false, false)
    local mpmid07 = CreateObject(GetHashKey("V_16_mpmidapart07"), generator.x - 1.91445900, generator.y - 6.61911300, generator.z + 1.45, false, false, false)
    local mpmid03 = CreateObject(GetHashKey("V_16_mpmidapart03"), generator.x - 4.82565300, generator.y - 6.86803900, generator.z + 1.14, false, false, false)
    local midData = CreateObject(GetHashKey("V_16_midapartdeta"), generator.x + 2.28558400, generator.y - 1.94082100, generator.z + 1.32, false, false, false)
    local glow = CreateObject(GetHashKey("V_16_treeglow"), generator.x - 1.37408500, generator.y - 0.95420070, generator.z + 1.135, false, false, false)
    local curtins = CreateObject(GetHashKey("V_16_midapt_curts"), generator.x - 1.96423300, generator.y - 0.95958710, generator.z + 1.280, false, false, false)
    local mpmid13 = CreateObject(GetHashKey("V_16_mpmidapart13"), generator.x - 4.65580700, generator.y - 6.61684000, generator.z + 1.259, false, false, false)
    local mpcab = CreateObject(GetHashKey("V_16_midapt_cabinet"), generator.x - 1.16177400, generator.y - 0.97333810, generator.z + 1.27, false, false, false)
    local mpdecal = CreateObject(GetHashKey("V_16_midapt_deca"), generator.x + 2.311386000, generator.y - 2.05385900, generator.z + 1.297, false, false, false)
    local mpdelta = CreateObject(GetHashKey("V_16_mid_hall_mesh_delta"), generator.x + 3.69693000, generator.y - 5.80020100, generator.z + 1.293, false, false, false)
    local beddelta = CreateObject(GetHashKey("V_16_mid_bed_delta"), generator.x + 7.95187400, generator.y + 1.04246500, generator.z + 1.28402300, false, false, false)
    local bed = CreateObject(GetHashKey("V_16_mid_bed_bed"), generator.x + 6.86376900, generator.y + 1.20651200, generator.z + 1.33589100, false, false, false)
    local beddecal = CreateObject(GetHashKey("V_16_MID_bed_over_decal"), generator.x + 7.82861300, generator.y + 1.04696700, generator.z + 1.34753700, false, false, false)
    local bathDelta = CreateObject(GetHashKey("V_16_mid_bath_mesh_delta"), generator.x + 4.45460500, generator.y + 3.21322800, generator.z + 1.21116100, false, false, false)
    local bathmirror = CreateObject(GetHashKey("V_16_mid_bath_mesh_mirror"), generator.x + 3.57740800, generator.y + 3.25032000, generator.z + 1.48871300, false, false, false)
    --props
    local beerbot = CreateObject(GetHashKey("Prop_CS_Beer_Bot_01"), generator.x + 1.73134600, generator.y - 4.88520200, generator.z + 1.91083000, false, false, false)
    local couch = CreateObject(GetHashKey("v_res_mp_sofa"), generator.x - 1.48765600, generator.y + 1.68100600, generator.z + 1.33640500, false, false, false)
    local chair = CreateObject(GetHashKey("v_res_mp_stripchair"), generator.x - 4.44770800, generator.y - 1.78048800, generator.z + 1.21640500, false, false, false)
    local chair2 = CreateObject(GetHashKey("v_res_tre_chair"), generator.x + 2.91325400, generator.y - 5.27835100, generator.z + 1.22746400, false, false, false)
    local plant = CreateObject(GetHashKey("Prop_Plant_Int_04a"), generator.x + 2.78941300, generator.y - 4.39133900, generator.z + 2.12746400, false, false, false)
    local lamp = CreateObject(GetHashKey("v_res_d_lampa"), generator.x - 3.61473100, generator.y - 6.61465100, generator.z + 2.09373700, false, false, false)
    local fridge = CreateObject(GetHashKey("v_res_fridgemodsml"), generator.x + 1.90339700, generator.y - 3.80026800, generator.z + 1.29917900, false, false, false)
    local micro = CreateObject(GetHashKey("prop_micro_01"), generator.x + 2.03442400, generator.y - 4.64585100, generator.z + 2.28995600, false, false, false)
    local sideBoard = CreateObject(GetHashKey("V_Res_Tre_SideBoard"), generator.x + 2.84053000, generator.y - 4.30947100, generator.z + 1.24577300, false, false, false)
    local bedSide = CreateObject(GetHashKey("V_Res_Tre_BedSideTable"), generator.x - 3.50363200, generator.y - 6.55289400, generator.z + 1.30625800, false, false, false)
    local lamp2 = CreateObject(GetHashKey("v_res_d_lampa"), generator.x + 2.69674700, generator.y - 3.83123500, generator.z + 2.09373700, false, false, false)
    local plant2 = CreateObject(GetHashKey("v_res_tre_tree"), generator.x - 4.96064800, generator.y - 6.09898500, generator.z + 1.31631400, false, false, false)
    local Table = CreateObject(GetHashKey("V_Res_M_DineTble_replace"), generator.x - 3.50712600, generator.y - 4.13621600, generator.z + 1.29625800, false, false, false)
    local tv = CreateObject(GetHashKey("Prop_TV_Flat_01"), generator.x - 5.53120400, generator.y + 0.76299670, generator.z + 2.17236000, false, false, false)
    local plant3 = CreateObject(GetHashKey("v_res_tre_plant"), generator.x - 5.14112800, generator.y - 2.78951000, generator.z + 1.25950800, false, false, false)
    local chair3 = CreateObject(GetHashKey("v_res_m_dinechair"), generator.x - 3.04652400, generator.y - 4.95971200, generator.z + 1.19625800, false, false, false)
    local lampStand = CreateObject(GetHashKey("v_res_m_lampstand"), generator.x + 1.26588400, generator.y + 3.68883900, generator.z + 1.35556700, false, false, false)
    local stool = CreateObject(GetHashKey("V_Res_M_Stool_REPLACED"), generator.x - 3.23216300, generator.y + 2.06159000, generator.z + 1.20556700, false, false, false)
    local chair4 = CreateObject(GetHashKey("v_res_m_dinechair"), generator.x - 2.82237200, generator.y - 3.59831300, generator.z + 1.25950800, false, false, false)
    local chair5 = CreateObject(GetHashKey("v_res_m_dinechair"), generator.x - 4.14955100, generator.y - 4.71316600, generator.z + 1.19625800, false, false, false)
    local chair6 = CreateObject(GetHashKey("v_res_m_dinechair"), generator.x - 3.80622900, generator.y - 3.37648300, generator.z + 1.19625800, false, false, false)
    local plant4 = CreateObject(GetHashKey("v_res_fa_plant01"), generator.x + 2.97859200, generator.y + 2.55307400, generator.z + 1.85796300, false, false, false)
    local storage = CreateObject(GetHashKey("v_res_tre_storageunit"), generator.x + 8.47819500, generator.y - 2.50979300, generator.z + 1.19712300, false, false, false)
    local storage2 = CreateObject(GetHashKey("v_res_tre_storagebox"), generator.x + 9.75982700, generator.y - 1.35874100, generator.z + 1.29625800, false, false, false)
    local basketmess = CreateObject(GetHashKey("v_res_tre_basketmess"), generator.x + 8.70730600, generator.y - 2.55503600, generator.z + 1.94059590, false, false, false)
    local lampStand2 = CreateObject(GetHashKey("v_res_m_lampstand"), generator.x + 9.54306000, generator.y - 2.50427700, generator.z + 1.30556700, false, false, false)
    local plant4 = CreateObject(GetHashKey("Prop_Plant_Int_03a"), generator.x + 9.87521400, generator.y + 3.90917400, generator.z + 1.20829700, false, false, false)
    local basket = CreateObject(GetHashKey("v_res_tre_washbasket"), generator.x + 9.39091500, generator.y + 4.49676300, generator.z + 1.19625800, false, false, false)
    local wardrobe = CreateObject(GetHashKey("V_Res_Tre_Wardrobe"), generator.x + 8.46626300, generator.y + 4.53223600, generator.z + 1.19425800, false, false, false)
    local basket2 = CreateObject(GetHashKey("v_res_tre_flatbasket"), generator.x + 8.51593000, generator.y + 4.55647300, generator.z + 3.46737300, false, false, false)
    local basket3 = CreateObject(GetHashKey("v_res_tre_basketmess"), generator.x + 7.57797200, generator.y + 4.55198800, generator.z + 3.46737300, false, false, false)
    local basket4 = CreateObject(GetHashKey("v_res_tre_flatbasket"), generator.x + 7.12286400, generator.y + 4.54689200, generator.z + 3.46737300, false, false, false)
    local wardrobe2 = CreateObject(GetHashKey("V_Res_Tre_Wardrobe"), generator.x + 7.24382000, generator.y + 4.53423500, generator.z + 1.19625800, false, false, false)
    local basket5 = CreateObject(GetHashKey("v_res_tre_flatbasket"), generator.x + 8.03364600, generator.y + 4.54835500, generator.z + 3.46737300, false, false, false)
    local switch = CreateObject(GetHashKey("v_serv_switch_2"), generator.x + 6.28086900, generator.y - 0.68169880, generator.z + 2.30326000, false, false, false)
    local table2 = CreateObject(GetHashKey("V_Res_Tre_BedSideTable"), generator.x + 5.84416200, generator.y + 2.57377400, generator.z + 1.22089100, false, false, false)
    local lamp3 = CreateObject(GetHashKey("v_res_d_lampa"), generator.x + 5.84912100, generator.y + 2.58001100, generator.z + 1.95311890, false, false, false)
    local ashtray = CreateObject(GetHashKey("Prop_ashtray_01"), generator.x - 1.24716200, generator.y + 1.07820500, generator.z + 1.87089300, false, false, false)
    local candle1 = CreateObject(GetHashKey("v_res_fa_candle03"), generator.x - 2.89289900, generator.y - 4.35329700, generator.z + 2.02881310, false, false, false)
    local candle2 = CreateObject(GetHashKey("v_res_fa_candle02"), generator.x - 3.99865700, generator.y - 4.06048500, generator.z + 2.02530190, false, false, false)
    local candle3 = CreateObject(GetHashKey("v_res_fa_candle01"), generator.x - 3.37733400, generator.y - 3.66639800, generator.z + 2.02526200, false, false, false)
    local woodbowl = CreateObject(GetHashKey("v_res_m_woodbowl"), generator.x - 3.50787400, generator.y - 4.11983000, generator.z + 2.02589900, false, false, false)
    local tablod = CreateObject(GetHashKey("V_Res_TabloidsA"), generator.x - 0.80513000, generator.y + 0.51389600, generator.z + 1.18418800, false, false, false)
    local tapeplayer = CreateObject(GetHashKey("Prop_Tapeplayer_01"), generator.x - 1.26010100, generator.y - 3.62966400, generator.z + 2.37883200, false, false, false)
    local woodbowl2 = CreateObject(GetHashKey("v_res_tre_fruitbowl"), generator.x + 2.77764900, generator.y - 4.138297000, generator.z + 2.10340100, false, false, false)
    local sculpt = CreateObject(GetHashKey("v_res_sculpt_dec"), generator.x + 3.03932200, generator.y + 1.62726400, generator.z + 3.58363900, false, false, false)
    local jewlry = CreateObject(GetHashKey("v_res_jewelbox"), generator.x + 3.04164100, generator.y + 0.31671810, generator.z + 3.58363900, false, false, false)
    local basket6 = CreateObject(GetHashKey("v_res_tre_basketmess"), generator.x - 1.64906300, generator.y + 1.62675900, generator.z + 1.39038500, false, false, false)
    local basket7 = CreateObject(GetHashKey("v_res_tre_flatbasket"), generator.x - 1.63938900, generator.y + 0.91133310, generator.z + 1.39038500, false, false, false)
    local basket8 = CreateObject(GetHashKey("v_res_tre_flatbasket"), generator.x - 1.19923400, generator.y + 1.69598600, generator.z + 1.39038500, false, false, false)
    local basket9 = CreateObject(GetHashKey("v_res_tre_basketmess"), generator.x - 1.18293800, generator.y + 0.91436380, generator.z + 1.39038500, false, false, false)
    local bowl = CreateObject(GetHashKey("v_res_r_sugarbowl"), generator.x - 0.26029210, generator.y - 6.66716800, generator.z + 3.77324900, false, false, false)
    local breadbin = CreateObject(GetHashKey("Prop_Breadbin_01"), generator.x + 2.09788500, generator.y - 6.57634000, generator.z + 2.24041900, false, false, false)
    local knifeblock = CreateObject(GetHashKey("v_res_mknifeblock"), generator.x + 1.82084700, generator.y - 6.58438500, generator.z + 2.27399500, false, false, false)
    local toaster = CreateObject(GetHashKey("prop_toaster_01"), generator.x - 1.05790700, generator.y - 6.59017400, generator.z + 2.26793200, false, false, false)
    local wok = CreateObject(GetHashKey("prop_wok"), generator.x + 2.01728800, generator.y - 5.57091500, generator.z + 2.31793200, false, false, false)
    local plant5 = CreateObject(GetHashKey("Prop_Plant_Int_03a"), generator.x + 2.55015600, generator.y + 4.60183900, generator.z + 1.20829700, false, false, false)
    local tumbler = CreateObject(GetHashKey("p_tumbler_cs2_s"), generator.x - 0.90916440, generator.y - 4.24099100, generator.z + 2.24693200, false, false, false)
    local wisky = CreateObject(GetHashKey("p_whiskey_bottle_s"), generator.x - 0.92809300, generator.y - 3.99099100, generator.z + 2.24693200, false, false, false)
    local tissue = CreateObject(GetHashKey("v_res_tissues"), generator.x + 7.95889300, generator.y - 2.54847100, generator.z + 1.94013400, false, false, false)
    local pants = CreateObject(GetHashKey("V_16_Ap_Mid_Pants4"), generator.x + 7.55366500, generator.y - 0.25457100, generator.z + 1.33009200, false, false, false)
    local pants2 = CreateObject(GetHashKey("V_16_Ap_Mid_Pants5"), generator.x + 7.76753200, generator.y + 3.00476500, generator.z + 1.33052800, false, false, false)
    local hairdryer = CreateObject(GetHashKey("v_club_vuhairdryer"), generator.x + 8.12616000, generator.y - 2.50562000, generator.z + 1.96009390, false, false, false)
    FreezeEntityPosition(hairdryer, true)
    FreezeEntityPosition(pants2, true)
    FreezeEntityPosition(pants, true)
    FreezeEntityPosition(tissue, true)
    FreezeEntityPosition(wisky, true)
    FreezeEntityPosition(tumbler, true)
    FreezeEntityPosition(plant5, true)
    FreezeEntityPosition(wok, true)
    FreezeEntityPosition(toaster, true)
    FreezeEntityPosition(knifeblock, true)
    FreezeEntityPosition(breadbin, true)
    FreezeEntityPosition(bowl, true)
    FreezeEntityPosition(jewlry, true)
    FreezeEntityPosition(sculpt, true)
    FreezeEntityPosition(woodbowl2, true)
    FreezeEntityPosition(tablod, true)
    FreezeEntityPosition(woodbowl, true)
    FreezeEntityPosition(candle2, true)
    FreezeEntityPosition(candle3, true)
    FreezeEntityPosition(candle1, true)
    FreezeEntityPosition(ashtray, true)
    FreezeEntityPosition(switch, true)
    FreezeEntityPosition(basket4, true)
    FreezeEntityPosition(basket3, true)
    FreezeEntityPosition(basket2, true)
    FreezeEntityPosition(lampStand2, true)
    FreezeEntityPosition(basketmess, true)
    FreezeEntityPosition(storage, true)
    FreezeEntityPosition(stool, true)
    FreezeEntityPosition(lamp2, true)
    FreezeEntityPosition(beerbot, true)
    FreezeEntityPosition(dt, true)
    FreezeEntityPosition(bathmirror, true)
    FreezeEntityPosition(bathDelta, true)
    FreezeEntityPosition(mpmid01, true)
    FreezeEntityPosition(mpmid09, true)
    FreezeEntityPosition(mpmid07, true)
    FreezeEntityPosition(mpmid03, true)
    FreezeEntityPosition(midData, true)
    FreezeEntityPosition(glow, true)
    FreezeEntityPosition(curtins, true)
    FreezeEntityPosition(mpmid13, true)
    FreezeEntityPosition(mpcab, true)
    FreezeEntityPosition(mpdecal, true)
    FreezeEntityPosition(mpdelta, true)
    FreezeEntityPosition(couch, true)
    FreezeEntityPosition(chair, true)
    FreezeEntityPosition(chair2, true)
    FreezeEntityPosition(plant, true)
    FreezeEntityPosition(lamp, true)
    FreezeEntityPosition(fridge, true)
    FreezeEntityPosition(micro, true)
    FreezeEntityPosition(sideBoard, true)
    FreezeEntityPosition(bedSide, true)
    FreezeEntityPosition(plant2, true)
    FreezeEntityPosition(Table, true)
    FreezeEntityPosition(tv, true)
    FreezeEntityPosition(plant3, true)
    FreezeEntityPosition(chair3, true)
    FreezeEntityPosition(lampStand, true)
    FreezeEntityPosition(chair4, true)
    FreezeEntityPosition(chair5, true)
    FreezeEntityPosition(chair6, true)
    FreezeEntityPosition(plant4, true)
    FreezeEntityPosition(storage2, true)
    FreezeEntityPosition(basket, true)
    FreezeEntityPosition(wardrobe, true)
    FreezeEntityPosition(wardrobe2, true)
    FreezeEntityPosition(table2, true)
    FreezeEntityPosition(lamp3, true)
    FreezeEntityPosition(beddelta, true)
    FreezeEntityPosition(bed, true)
    FreezeEntityPosition(beddecal, true)
    FreezeEntityPosition(tapeplayer, true)
    FreezeEntityPosition(basket7, true)
    FreezeEntityPosition(basket6, true)
    FreezeEntityPosition(basket8, true)
    FreezeEntityPosition(basket9, true)
    if math.random(1, 10) >= 8 then
        CreateSafe(generator.x + 6.2, generator.y + 4.52972300, generator.z + 1.32609800)
    end
    SetEntityHeading(beerbot, GetEntityHeading(beerbot) + 90)
    SetEntityHeading(couch, GetEntityHeading(couch) - 90)
    SetEntityHeading(chair, GetEntityHeading(chair) + getRotation(0.28045480))
    SetEntityHeading(chair2, GetEntityHeading(chair2) + getRotation(0.3276100))
    SetEntityHeading(fridge, GetEntityHeading(chair2) + 160)
    SetEntityHeading(micro, GetEntityHeading(micro) - 90)
    SetEntityHeading(sideBoard, GetEntityHeading(sideBoard) + 90)
    SetEntityHeading(bedSide, GetEntityHeading(bedSide) + 180)
    SetEntityHeading(tv, GetEntityHeading(tv) + 90)
    SetEntityHeading(plant3, GetEntityHeading(plant3) + 90)
    SetEntityHeading(chair3, GetEntityHeading(chair3) + 200)
    SetEntityHeading(chair4, GetEntityHeading(chair3) + 100)
    SetEntityHeading(chair5, GetEntityHeading(chair5) + 135)
    SetEntityHeading(chair6, GetEntityHeading(chair6) + 10)
    SetEntityHeading(storage, GetEntityHeading(storage) + 180)
    SetEntityHeading(storage2, GetEntityHeading(storage2) - 90)
    SetEntityHeading(table2, GetEntityHeading(table2) + 90)
    SetEntityHeading(tapeplayer, GetEntityHeading(tapeplayer) + 90)
    SetEntityHeading(knifeblock, GetEntityHeading(knifeblock) + 180)
end

local function DeleteSpawnedHouse(id)
    local housePosition = robbableHouses[id]
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(vector3(housePosition["x"], housePosition["y"], (housePosition["z"] - 24.0)) - vector3(pos.x, pos.y, pos.z))
        if distance < 35.0 and ObjectFound ~= PlayerPedId() and not BlacklistedItemsModels[GetEntityModel(ObjectFound)] then
            if IsEntityAPed(ObjectFound) then
                if not IsPedAPlayer(ObjectFound) then
                    DeleteObject(ObjectFound)
                end
            else
                DeleteObject(ObjectFound)
            end
        end
        success, ObjectFound = FindNextObject(handle)
    until not success
    EndFindObject(handle)
end

local function showMessage(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentScaleform(msg)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

local function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

CreateThread(function()
    TriggerEvent("n_snippets:getModelsItemsOnBack", function(models) BlacklistedItemsModels = models end)

    for i, v in pairs(robbableHouses) do
        table.insert(created_targets, "houserobbery_"..i)
        
        robbableHouses[i].id = i
        robbableHouses[i].coords = vector3(v.x, v.y, v.z)

        exports['qb-target']:AddBoxZone("houserobbery_"..i, vector3(v.x, v.y, v.z-1), 2.5, 2.55, {
            name = "houserobbery_"..i,
            debugPoly = false,
            minZ = v.z-1,
            maxZ = v.z+1
        }, {
            distance = 2.0,
            options = {
                {
                    type = "client",
                    event = "houserobbery:canRaidHouse",
                    icon = 'fa-solid fa-key',
                    label = 'Lockpick',
                    args = robbableHouses[i],
                    canInteract = function(entity)
                        if not Config.WhitelistedJobs[PlayerData.job.name] then
                            return true
                        end
                        return false
                    end,
                },
                {
                    type = "client",
                    event = "houserobbery:raid",
                    icon = 'fa-solid fa-hand-fist',
                    label = 'Raid',
                    job = 'police',
                    args = {robbableHouses[i]},
                    canInteract = function(entity)
                        return canRaid()
                    end,
                },
            }
        })
        -- SetEntityCoords(cache.ped, vector3(v.x, v.y, v.z-1))
        -- Wait(3000)
    end
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob", function(job)
    PlayerData.job = job
end)

local TargetHouse = nil

RegisterNetEvent("houserobbery:canRaidHouse", function(houseData)
    TargetHouse = nil
    TargetHouse = houseData.args
    local lockpickCount = exports.ox_inventory:GetItemCount("lockpick")
    
    if isNight() then
        if lockpickCount and lockpickCount > 0 then
            TriggerServerEvent("houserobbery:lockpick")
        else
            local items = {
                { name = "lockpick", amount = 1}
            }
            exports.inventory:requiredItems(items, 5000)
        end
    else
        ESX.ShowNotification("You can only rob at night time.")
    end
end)

RegisterNetEvent('houserobbery:attempt', function(lockpicks, cops)
    local playerCoords = GetEntityCoords(PlayerPedId(), true)
    -- if isRobbing and not isAgro and DoesEntityExist(safe) then
    if isRobbing and DoesEntityExist(safe) then
        if not vaultrob and #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - vector3(safepos.x, safepos.y, safepos.z)) <= 3.0 then
            vaultrob = true
            TriggerEvent("safecracking:loop", 3, GetCurrentResourceName())
        end
    end
    
    if cops >= Config.CopRequired then
        if lockpicks > 0 and not isRobbing then
            if #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - TargetHouse.coords) <= 2.5 then
                if isNight() then
                    ESX.TriggerServerCallback('houserobbery:alreadyrobbed', function(alreadyRobbed)
                        if alreadyRobbed then
                            ESX.ShowNotification('~y~This place is already robbed!')
                        else
                            FreezeEntityPosition(PlayerPedId(), true)
                            TriggerEvent('lockpickAnimation')
                            exports['ps-ui']:Circle(function(success)
                                FreezeEntityPosition(PlayerPedId(), false)
                                if success then
                                    pedSpawned = false
                                    TriggerEvent('houserobbery:createHouse', TargetHouse.id)
                                else
                                    ClearPedTasks(PlayerPedId())
                                    robberyAlert()
                                    TriggerServerEvent('houserobbery:setRobbed', TargetHouse.id)
                                    TriggerServerEvent('houserobbery:removeLockpick')
                                end
                            end, 3, 10)
                        end
                    end, TargetHouse.id)
                else
                    ESX.ShowNotification('~y~It\'s too bright outside')
                end
            end
        elseif lockpicks == 0 and not isRobbing then
            ESX.ShowNotification('~r~No lockpick')
        end
    else
        ESX.ShowNotification('~r~Not enough cops in the city')
    end
end)

RegisterNetEvent('houserobbery:updatehouse', function(data)
    robbing = data
end)

RegisterNetEvent('houserobbery:createHouse', function(id)
    LocalPlayer.state:set('teleport', true, true)
    TriggerEvent('Allhousing:Enter')
    if not Config.WhitelistedJobs[PlayerData.job.name] then
        TriggerServerEvent('houserobbery:registerhouse', id)
    end
    local house = robbableHouses[id]
    myRobbableItems = robbableItems
    for i = 1, #myRobbableItems do
        myRobbableItems[i].isSearched = false
    end
    DoScreenFadeOut(100)
    Wait(100)
    buildBasicHouse({x = house.x, y = house.y, z = house.z - 50})
    Wait(3000)
    -- randomAI({x = house.x, y = house.y, z = house.z - 50})
    curHouseCoords = {x = house.x, y = house.y, z = house.z - 50}
    lastHouse = vector3(house.x, house.y, house.z)
    -- disturbance = 0
    -- isAgro = false
    -- if math.random(1, 10) < 2 then
    --     TriggerEvent('houserobbery:createDog')
    -- end
    FreezeEntityPosition(PlayerPedId(), false)
    Wait(500)
    DoScreenFadeIn(500)
    if not Config.WhitelistedJobs[PlayerData.job.name] then
        isRobbing = true
        TriggerEvent('houserobbery:startRob')
    else
        isRaiding = true
    end
    table.insert(created_targets_for_robbery, "robbery_house_exit_"..id)
    
    exports['qb-target']:AddBoxZone("robbery_house_exit_"..id, vector3(house.x + 3.6, house.y - 15, house.z - 48.5), 2.5, 2.5, {
        name = "robbery_house_exit_"..id,
        minZ = house.z - 47.5,
        maxZ = house.z - 49.5
    }, {
        distance = 2.0,
        options = {
            {
                type = "client",
                event = "houserobbery:deleteHouse",
                icon = "fas fa-house-circle-xmark",
                label = "Exit House",
                args = {id},
                canInteract = function(entity)
                    if isRobbing or isRaiding then
                        return true
                    end
                    return false
                end
            }
        }
    })
    CreateThread(function()
        while isRobbing or isRaiding do
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId(), true)
            if #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - vector3(house.x + 3.6, house.y - 15, house.z - 50)) > 25.0 then
                TriggerEvent('houserobbery:deleteHouse', id)
                break
            end
        end
    end)
end)

RegisterNetEvent('houserobbery:success', function(success)
    if success then
        DeleteEntity(safe)
        DeleteObject(safe)
        SetEntityAsNoLongerNeeded(safe)
        safepos = {["x"] = 0, ["y"] = 0, ["z"] = 0}
        TriggerServerEvent('houserobbery:giveMoney', Config)
    end
    vaultrob = false
end)

RegisterNetEvent('houserobbery:deleteHouse', function(data)
    local id = nil
    if type(data) == "number" then id = data else id = data.args[1] end
    
    for i=1,#created_targets_for_robbery do
        exports["qb-target"]:RemoveZone(created_targets_for_robbery[i])
    end
    if not Config.WhitelistedJobs[PlayerData.job.name] then
        TriggerServerEvent('houserobbery:deregisterhouse', id)
    else
        isRaiding = false
    end
    local house = robbableHouses[id]
    myRobbableItems = robbableItems
    DoScreenFadeOut(100)
    Wait(100)
    FreezeEntityPosition(PlayerPedId(), true)
    DeleteSpawnedHouse(id)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), house.x, house.y, house.z)
    FreezeEntityPosition(PlayerPedId(), false)
    Wait(500)
    TriggerEvent("n_snipppets:recheckItems")
    DoScreenFadeIn(100)
    Wait(100)
    -- closeGui()
    -- disturbance = 0
    isRobbing = false
    -- if not isAgro and DoesEntityExist(robberyped) then
    --     SetEntityAsNoLongerNeeded(robberyped)
    --     DeleteEntity(robberyped)
    -- end
    LocalPlayer.state:set('teleport', false, true)
    TriggerEvent('Allhousing:Leave')
end)

AddEventHandler('houserobbery:raid', function()
    if PlayerData and PlayerData.job and Config.WhitelistedJobs[PlayerData.job.name] then
        if #robbing > 0 then
            for i = 1, #robbing, 1 do
                local playerCoords = GetEntityCoords(PlayerPedId())
                local hPos = vector3(Config.Houses[robbing[i]].x, Config.Houses[robbing[i]].y, Config.Houses[robbing[i]].z)
                local distance = #(playerCoords - hPos)
                if distance <= 3.0 and not isRaiding then
                    isRaiding = true
                    TriggerEvent('houserobbery:createHouse', robbing[i])
                end
            end
        else
           return false
        end
    else
        return false
    end
end)

RegisterNetEvent("houserobbery:tryRobItem", function(locData)
    local args = locData.args
    local rob_item_id = args[1]
    local rob_item_data = args[2]
    myRobbableItems[rob_item_id].isSearched = true
    local ped = PlayerPedId()
    local gen = { x = curHouseCoords.x, y = curHouseCoords.y, z = curHouseCoords.z }
    local distance, pedcount = closestNPC()
    -- local distadd = 0.1
    -- if pedcount > 0 then
    --     distadd = distadd + (pedcount / 100)
    --     local distancealter = (8.0 - distance) / 100
    --     distadd = distadd + distancealter
    -- end
    -- distadd = distadd * 100
    -- disturbance = disturbance + distadd
    -- if math.random(100) > 95 then
    --     disturbance = disturbance + 10
    -- end
    TaskTurnPedToFaceCoord(ped, gen.x + rob_item_data.x, gen.y + rob_item_data.y, gen.z + rob_item_data.z, 1500)
    loadAnimDict("oddjobs@shop_robbery@rob_till")
    Wait(1500)
    if lib.progressBar({
        duration = 5000, -- duration in milliseconds
        label = 'Searching '..rob_item_data.name, -- label to display
        useWhileDead = false, -- whether the progress bar can be used when the player is dead
        canCancel = true, -- whether the player can cancel the progress bar
        disable = {
            car = true,
            move = true,
        },
        anim = {
            dict = 'missexile3',
            clip = 'ex03_dingy_search_case_base_michael'
        }
    }) then
        TaskPlayAnim(ped, "oddjobs@shop_robbery@rob_till", "loop", 6.0, -6.0, -1, 1, 1, false, false, false)
        TriggerServerEvent('houserobbery:searchItem', myRobbableItems[rob_item_id].name)
        Wait(1500)
        ClearPedTasks(ped)
    else
        ClearPedTasks(ped)
    end
end)

AddEventHandler('houserobbery:startRob', function()
    local gen = { x = curHouseCoords.x, y = curHouseCoords.y, z = curHouseCoords.z }
    for i=1,#myRobbableItems do
        local curr_rob_item = myRobbableItems[i]
        local curr_loc = { x = gen.x + curr_rob_item.x, y = gen.y + curr_rob_item.y, z = gen.z + curr_rob_item.z }
        exports["qb-target"]:AddBoxZone(curr_rob_item.name.."_"..i, vector3(curr_loc.x, curr_loc.y, curr_loc.z - 1.0), 0.5, 0.5, {
            name = curr_rob_item.name.."_"..i,
            debugPoly = false,
            minZ = curr_loc.z - 1.0,
            maxZ = curr_loc.z + 2.0
        }, {
            distance = 2.0,
            options = {
                {
                    type = "client",
                    event = "houserobbery:tryRobItem",
                    icon = 'fas fa-magnifying-glass',
                    label = 'Search '..curr_rob_item.name,
                    args = {i, curr_rob_item},
                    canInteract = function(entity)
                        if not myRobbableItems[i].isSearched then
                            if not Config.WhitelistedJobs[PlayerData.job.name] then
                                return true
                            end
                        end
                        return false
                    end,
                },
            }
        })
    end
    while isRobbing do
        Wait(0)
        for i=1,#myRobbableItems do
            if myRobbableItems[i].isSearched then
                exports["qb-target"]:RemoveZone(myRobbableItems[i].name.."_"..i)
            end
        end
        local generator = {x = curHouseCoords["x"], y = curHouseCoords["y"], z = curHouseCoords["z"]}
    --     if isRobbing and not isAgro then
    --         local ped = PlayerPedId()
    --         local pedCo = GetEntityCoords(ped)
    --         local speed = GetEntitySpeed(ped)
    --         if IsPedShooting(ped) then
    --             disturbance = 100
    --             if not isAgro then
    --                 isAgro = true
    --                 agroNPC()
    --             end
    --         end
    --         if disturbance > 85 then
    --             if not calledin then
    --                 local num = 150 - disturbance
    --                 num = math.random(math.ceil(num))
    --                 local fuckup = math.ceil(num)
    --                 if fuckup == 2 and speed > 0.8 then
    --                     calledin = true
    --                     disturbance = 100
    --                     if not isAgro then
    --                         isAgro = true
    --                         agroNPC()
    --                     end
    --                 end
    --             end
    --         end
    --         if speed > 1.4 then
    --             local distance, pedcount = closestNPC()
    --             local alteredsound = 0.1
    --             if pedcount > 0 then
    --                 alteredsound = alteredsound + (pedcount / 100)
    --                 local distancealter = (8.0 - distance) / 100
    --                 alteredsound = alteredsound + distancealter
    --             end
    --             disturbance = disturbance + alteredsound
    --             if speed > 2.0 then
    --                 disturbance = disturbance + alteredsound
    --             end
    --             if speed > 3.0 then
    --                 disturbance = disturbance + alteredsound
    --             end
    --         else
    --             disturbance = disturbance - 0.01
    --             if disturbance < 0 then
    --                 disturbance = 0
    --             end
    --         end
    --         openGui(math.ceil(disturbance))
    --     end
    end
end)

AddEventHandler('lockpickAnimation', function()
    isLockpicking = true
    local dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@'
    loadAnimDict(dict)
    TaskPlayAnim(PlayerPedId(), dict, "machinic_loop_mechandplayer", 1.0, -1.0, -1, 49, 1, false, false, false)
end)

-- AddEventHandler('houserobbery:createDog', function()
--     if not DoesEntityExist(attackDog) then
--         local model = GetHashKey("a_c_rottweiler")
--         RequestModel(model)
--         while not HasModelLoaded(model) do
--             RequestModel(model)
--             Wait(100)
--         end
--         attackDog = CreatePed(GetPedType(model), model, curHouseCoords.x + 3.70339700, curHouseCoords.y +- 3.80026800, curHouseCoords.z + 2.29917900, 90, 1, 0)
--         Wait(1500)
--         TaskCombatPed(attackDog, PlayerPedId(), 0, 16)
--         SetPedKeepTask(attackDog, true)
--         Wait(45000)
--         SetEntityAsNoLongerNeeded(attackDog)
--         attackDog = 0
--     end
-- end)