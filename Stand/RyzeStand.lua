-- This was created by XxpichoclesxX#0427 with some help already mentioned in credits.
-- The original download site should be github.com/xxpichoclesxx, if you got this script from anyone selling it, you got sadly scammed.
-- Also this is only for some new stand people because is a trolling and online feature script, not recovery.
-- So enjoy and pls join my discord, to know when the script is updated or be able to participate in polls.


util.keep_running()
util.require_natives(1663599433)

util.toast("Bienvenide Al Script!!")
util.toast("Cargando, espere... (1-2s)")
local response = false
local localVer = 3.53
async_http.init("raw.githubusercontent.com", "/XxpichoclesxX/GtaVScripts/Ryze-Scripts/Stand/RyzeScriptVersion.lua", function(output)
    currentVer = tonumber(output)
    response = true
    if localVer ~= currentVer then
        util.toast("Hay una actualizacion disponible, reinicia para actualizarlo.")
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

--local required <const> = {
--    "lib/natives-1663599433.lua",
--    "lib/ryzescript/sportmode.lua"
--}
--local scriptdir <const> = filesystem.scripts_dir()
--for _, file in ipairs(required) do
--	assert(filesystem.exists(scriptdir .. file), "archivo requerido no encontrado: " .. file)
--end

--spmode = require "ryzescript.sportmode"

sleep(1200)

local pumps_from_gtaweb_eu = {
    { -190.31, -765.13, 30.45 },
    { -226.738, -904.8115, 31.219986 },
    { -552.5844, -818.5978, 29.199762 },
    { -730.83, -677.30, 30.28 },
    { -1187.7239, -564.0276, 27.595663 },
    { -1341.6681, -405.50613, 36.256187 },
    { -1534.7773, -425.2127, 35.59083 },
    { -1581.8558, -951.5547, 13.017392 },
    { -1977.1042, -533.32056, 11.766664 },
    { -1885.721, -366.0141, 49.08775 },
    { -1289.285, -1115.446 },
    { -1503.121, -936.5198 },
    { -1334.734, -1280.177 },
    { -1184.3699, -1560.265, 4.360539 },
    { -971.0191, -1093.48 },
    { -840.8212, -1207.88 },
    { -296.9001, -1334.173 },
    { -225.556, -1500.448 },
    { -125.133415, -1491.9614, 33.738255 },
    { -197.39958, -1604.4874, 34.38783 },
    { -160.142, -1681.59 },
    { -81.4956, -1642.043 },
    { -20.704, -1856.823 },
    { 25.034052, -1894.8643, 22.592161 },
    { 150.31186, -1867.1355, 24.217976 },
    { 177.9339, -1927.648 },
    { 223.824, -2035.894, 17.98 },
    { 325.4174, -1946.595 },
    { 387.328, -1882.668, 25.62  },
    { 322.5227, -1759.72, 29.34 },
    { 496.8552, -1819.122 },
    { 428.84775, -1724.5013, 29.22905 },
    { 410.2907, -1485.7858, 29.830795 },
    { 378.23923, -2070.1523, 21.337908 },
    { 294.307, -2097.2437, 17.218208 },
    { 1257.2054, -1759.1292, 49.26021 },
    { 1310.985, -1698.068 },
    { 1203.222, -1672.258 },
    { 1297.0492, -1620.1895, 54.225124 },
    { 1232.5145, -1593.675, 53.367897 },
    { 1152.1176, -1530.1102, 35.3683 },
    { 1184.6343, -1461.6602, 34.89396 },
    { 1320.342, -1557.638 },
    { 1435.0863, -1494.6964, 63.22443 },
    { 806.0478, -1073.288 },
    { 847.3984, -1021.431 },
    { 479.53775, -973.7119, 27.98387 },
    { 387.744, -973.043 },
    { 359.4657, -1069.9675, 29.545038 },
    { 263.31732, -1029.6188, 29.211515 },
    { 244.42253, -1071.4537, 29.28771 },
    { 1209.887, -1388.977 },
    { 1142.299, -981.9567 },
    { 73.529, -1026.593 },
    { 63.369442, -966.0302, 29.35756 },
    { -17.319935, -977.0724, 29.363268 },
    { -1207.5237, -1136.5823, 7.708335 },
    { -1125.1512, -1090.9882, 2.1503568 },
    { -1074.3225, -1026.9263, 4.5456057 },
    { -961.535, -940.509 },
    { -1027.394, -921.1421, 5.0412273 },
    { -1146.3093, -990.76086, 2.150192 },
    { -1726.561, -192.421 },
    { -62.999, -1450.793 },
    { -1549.2261, -86.84496, 54.392155 },
    { -1465.655, -31.124 },
    { -1475.253, 63.768 },
    { -1565.532, 40.189 },
    { -1649.6569, 148.86308, 62.162636 },
    { -1539.0607, 128.24585, 56.78024 },
    { -1179.64, 292.144 },
    { -1023.641, 358.387 },
    { -1131.724, 390.5965 },
    { -1214.895, 461.5896 },
    { -1499.9259, 519.5822, 118.27235 },
    { -1290.108, 648.5641 },
    { -1121.946, 572.907, 103.268166 },
    { -1025.834, 505.1749 },
    { -965.19977, 435.01297, 79.97154 },
    { -864.8736, 389.6919 },
    { -821.4586, 267.85245, 86.18485 },
    { -597.9922, 278.1837 },
    { -572.783, 400.7235, 100.6666 },
    { -585.74, 494.794 },
    { -714.54395, 487.50174, 108.633286 },
    { -880.45044, 520.43146, 92.230194 },
    { -937.445, 591.477 },
    { -701.9132, 592.43835, 142.24333 },
    { -888.666, 699.998 },
    { -1017.197, 715.0238, 163.8084 },
    { -1165.568, 732.3715, 155.51604 },
    { -580.1805, 736.33325, 183.75821 },
    { -548.85034, 827.0882, 197.50934 },
    { -491.17026, 738.22864, 162.83086 },
    { -444.48285, 682.3715, 152.95125 },
    { -345.78937, 626.4523, 171.35695 },
    { -247.70671, 619.18585, 187.81017 },
    { -137.8688, 592.7097 },
    { -178.251, 502.183 },
    { -353.838, 467.898 },
    { -369.77725, 346.13782, 109.518524 },
    { -250.332, 397.556 },
    { -85.666, 424.562 },
    { -822.3367, 813.652 },
    { -1313.9503, 454.3366, 99.17906 },
    { -1686.279, -290.491 },
    { 82.5397, -91.9352 },
    { 129.3306, 64.38834, 78.74152 },
    { 14.059147, -5.738815, 70.11617 },
    { -176.8698, 86.8545 },
    { -436.30215, -69.55267, 43.125786 },
    { -375.576, 44.577 },
    { -569.9086, 168.254 },
    { 1771.1506, 3738.6924, 33.995804 },
    { 1913.7814, 3825.0247, 32.439957 },
    { 2009.9589, 3782.3945, 32.18078 },
    { 1923.412, 3916.096 },
    { 1759.466, 3870.604 },
    { 1661.887, 3822.058 },
    { 1419.643, 3668.236 },
    { 440.60117, 3575.3728, 33.23856 },
    { 247.71994, 3161.971, 42.81168 },
    { 199.20934, 3029.2544, 43.584297 },
    { -286.359, 2838.471 },
    { -325.6886, 2817.8408, 59.445034 },
    { -461.6427, 2859.427 },
    { -37.883152, 2868.395, 59.18017 },
    { 469.61234, 2611.1606, 43.26912 },
    { 563.666, 2599.943 },
    { 733.646, 2524.984 },
    { 721.52936, 2335.256, 50.324413 },
    { 790.22644, 2182.987, 52.097557 },
    { 841.57074, 2114.5078, 52.30619 },
    { 1531.942, 1729.31 },
    { 2590.0747, 3168.7322, 50.95394 },
    { 2618.848, 3280.744 },
    { 2984.3713, 3483.7065, 71.43611 },
    { 1356.303, 1147.111 },
    { 1533.893, 2219.883 },
    { -148.0881, 287.3474 },
    { 1992.1509, 3058.1655, 47.05832 },
    { 2166.818, 3381.051 },
    { 2179.4167, 3499.272, 45.461754 },
    { 2420.5247, 4019.958, 36.82945 },
    { 346.24, 441.64 },
    { 325.772, 536.228 },
    { 216.718, 621.505 },
    { 167.685, 487.5329 },
    { 55.64259, 455.10632, 146.66272 },
    { 8.554, 542.77 },
    { -148.985, 996.5 },
    { -2006.675, 445.9337 },
    { -1974.6636, 627.0231, 122.53622 },
    { -1812.335, 342.8018 },
    { -1963.542, 246.943 },
    { -340.031, 6165.106 },
    { -403.0054, 6314.03, 28.949713 },
    { -305.281, 6329.808 },
    { -245.8482, 6410.798, 31.197504 },
    { -113.76428, 6457.688, 31.46844 },
    { -49.958725, 6583.393, 31.183239 },
    { 55.210766, 6642.2563, 31.55679 },
    { -104.82028, 6313.148, 31.490349 },
    { 2232.981, 5611.867 },
    { 1858.875, 3679.3467, 33.70768 },
    { 3312.502, 5176.144 },
    { 1664.0002, 4775.2305, 42.004242 },
    { 1723.4915, 4645.9883, 43.401672 },
    { 1968.356, 4622.632 },
    { 1311.9595, 4362.2754, 40.860874 },
    { 723.8038, 4185.8154, 40.709187 },
    { 92.067, 3743.533 },
    { 33.199, 3668.209 },
    { -267.7338, 2628.924 },
    { -263.6633, 2197.269 },
    { 747.7412, 210.8315, 87.03131 },
    { 135.43411, -567.67084, 43.88963 },
    { -1874.804, 2030.164 },
    { -1112.1802, 2686.0774, 18.615625 },
    { -3184.543, 1293.391 },
    { -3205.871, 1151.494 },
    { -3233.165, 933.7818 },
    { -2997.617, 695.5018 },
    { -3036.497, 491.4613 },
    { -3087.551, 220.9675 },
    { -769.6445, 5514.033 },
    { 1713.0626, 6421.948, 32.78944 },
    { 2452.608, 4964.704 },
    { 2634.9272, 4250.377, 44.639698 },
    { 964.9565, -545.2515 },
    { 959.61523, -595.3386, 59.49267 },
    { 998.7151, -726.6116, 57.555073 },
    { 1204.5651, -621.551, 66.121346 },
    { 1370.6095, -557.4132, 74.33879 },
    { 1325.584, -580.8104, 73.20767 },
    { 1265.7649, -427.8586, 69.38129 },
    { 1011.482, -424.2754 },
    { -2553.464, 1914.783 },
    { 3692.4502, 4564.0312, 25.147186 },
    { -1523.871, 852.2529 }
}

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

local online = menu.list(menu.my_root(), "Online", {}, "Opciones modo online")
local world = menu.list(menu.my_root(), "Mundo", {}, "Opciones al rededor tuyo")
local detections = menu.list(menu.my_root(), "Deteccion De Modders", {}, "Lo dice el nombre ;w;")
local protects = menu.list(menu.my_root(), "Protecciones", {}, "Protejete contra modders")
local vehicles = menu.list(menu.my_root(), "Vehiculos", {}, "Opciones de vehiculos")
local fun = menu.list(menu.my_root(), "Diversion", {}, "Diviertete un rato si estas aburrido :3")
local misc = menu.list(menu.my_root(), "Misc", {}, "Unos atajos utiles y rapidos")

players.on_join(function(player_id)
    menu.divider(menu.player_root(player_id), "RyzeScript")
    local ryzescriptd = menu.list(menu.player_root(player_id), "RyzeScript")
    local malicious = menu.list(ryzescriptd, "Malicioso")
    local trolling = menu.list(ryzescriptd, "Troleador")
    local friendly = menu.list(ryzescriptd, "Amigable")
    local vehicle = menu.list(ryzescriptd, "Vehiculo")




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

    local explode_slider = menu.slider_text(explosions, "Explotar", {"customexplode"}, "", explosion_names, function()
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
            util.yield()
        end
    end)

    menu.toggle_loop(flushes, "Loop Awa", {"waterloop"}, "", function()
        if players.exists(player_id) then
            local player_pos = players.get_position(player_id)
            FIRE.ADD_EXPLOSION(player_pos.x, player_pos.y, player_pos.z - 1, 13, 1, true, false, 1, false)
            util.yield()
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

    local cageveh = menu.list(trolling, "Enjaular Coches", {}, "")

    menu.action(cageveh, "Enjaular Vehiculo", {"cage"}, "", function()
        local container_hash = util.joaat("boxville3")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        request_model(container_hash)
        local container = entities.create_vehicle(container_hash, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 2.0, 0.0), ENTITY.GET_ENTITY_HEADING(ped))
        spawned_objects[#spawned_objects + 1] = container
        ENTITY.SET_ENTITY_VISIBLE(container, false)
        ENTITY.FREEZE_ENTITY_POSITION(container, true)
    end)


    local cage = menu.list(trolling, "Enjaular Jugador", {}, "")
    menu.action(cage, "Jaula Electrica", {"electriccage"}, "", function(cl)
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
    
    menu.action(cage, "Jaula de la reina isabell", {""}, "", function(cl)
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

    menu.action(cage, "Contenedor De Carga", {"cage"}, "", function()
        local container_hash = util.joaat("prop_container_ld_pu")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        request_model(container_hash)
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
        request_model(ladder_hash)
        
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

    local inf_loading = menu.list(trolling, "Pantalla de carga infinita", {}, "")
    menu.action(inf_loading, "Teleport a MC", {}, "", function()
        util.trigger_script_event(1 << player_id, {0xDEE5ED91, player_id, 0, 32, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)

    menu.action(inf_loading, "Metodo Apartamento", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x7EFC3716, player_id, 0, 1, id})
    end)
        
    menu.action_slider(inf_loading, "Telefono corrupto", {}, "Click para seleccionar un estilo", invites, function(index, name)
        pluto_switch name do
            case 1:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x1})
                util.toast("Invitacion a yate")
            break
            case 2:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x2})
                util.toast("Invitacion a oficina")
            break
            case 3:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x3})
                util.toast("Invitacion al club")
            break
            case 4:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x4})
                util.toast("Invitacion al garage de oficina")
            break
            case 5:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x5})
                util.toast("Invitacion a los santos cs")
            break
            case 6:
                util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, 0x6})
                util.toast("Invitacion a apartamento")
            break
        end
    end)


    local freeze = menu.list(malicious, "Metodos Frezeo", {}, "")

    player_toggle_loop(freeze, player_id, "Potente (Ningun menu/exclusivo de Ryze)", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x4868BC31, player_id, 0, 0, 0, 0, 0})
        util.yield(500)
    end)

    player_toggle_loop(freeze, player_id, "Freeze V1 (Blockeado Por Mayoria)", {}, "", function()
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


    local msg = ("Ya lo siguen los mercenarios")

	menu.action(trolling, ("Enviar Mercenarios"), {}, "", function()
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

    menu.action(trolling, "Matar en interior", {}, "No funciona en apartamentos (Love u jinx x2)", function()
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

    glitchiar = menu.list(trolling, "Opciones De Glitch", {}, "")


    player_toggle_loop(glitchiar, player_id, "Movimiento Bug", {}, "", function()
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
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
    glitchVehCmd = menu.toggle(glitchiar, "Glitchear Coche", {"glitchvehicle"}, "", function(toggle) -- jinx <3
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
            util.toast("No se puede controlar el vehiculo. D:")
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





    crashes = menu.list(malicious, "Crasheos", {}, "Crasheos Op", function(); end)

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

    menu.action(crashes, "Modelo V1", {"crashv1"}, "Funcando (Menus populares - Stand)", function()
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

    menu.divider(crashes, "(Ryze Exclusivo)")

    menu.action(crashes, "Inbloqueable", {"crashv2"}, "Funcando (Menus populares - Stand)", function()
        for i = 1, 150 do
            util.trigger_script_event(1 << player_id, {0xA4D43510, player_id, 0xDF607FCD, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
        end
    end)

    menu.action(crashes, "Inbloqueable V2", {"crashv3"}, "Funcando (Menus populares - Stand)", function()
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

    menu.action(crashes, "Inbloqueable V3 '2T1'", {"crashv4"}, "", function()
        BlockSyncs(player_id, function()
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            util.yield(1000)
            entities.delete_by_handle(object)
        end)
    end)

    --menu.action(crashes, "Inbloqueable V4 'Test'", {"crashv4"}, "Deberia estar arreglado por ahora", function()
    --    local mdl = util.joaat("apa_mp_apa_yacht")
    --    local user = players.user_ped()
    --   BlockSyncs(player_id, function()
    --        local old_pos = ENTITY.GET_ENTITY_COORDS(user, false)
    --        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user, 0xFBAB5776, 100, false)
    --        PLAYER.SET_PLAYER_HAS_RESERVE_PARACHUTE(players.user())
    --        PLAYER.SET_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(players.user(), mdl)
    --        util.yield(50)
    --        local pos = players.get_position(player_id)
    --        pos.z += 300
    --        TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
    --        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
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

    menu.divider(crashes, "(Potentes)")

    menu.action(crashes, "Bomba del tsar", {"tsarbomba"}, "Crash demandante de pc, si no tienes buena pc no te recomiendo usarlo (Inbloqueable uwu)", function()
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
        -- Turned off because of a self-crash error
        --util.yield(600)
        --menu.trigger_commands("crashv4"..players.get_name(player_id))
        util.yield(2000)
        menu.trigger_commands("crash"..players.get_name(player_id))
        util.yield(400)
        menu.trigger_commands("ngcrash"..players.get_name(player_id))
        util.yield(400)
        menu.trigger_commands("footlettuce"..players.get_name(player_id))
        util.yield(400)
        menu.trigger_commands("steamroll"..players.get_name(player_id))
        util.yield(1800)
        util.toast("Espera en lo que se limpia todo...")
        --menu.trigger_command(outSync, "off")
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

    local kicks = menu.list(malicious, "Kicks", {}, "")

    menu.action(kicks, "Muerte Modo Libre", {}, "Los manda directo sin escalas al modo historia", function()
        util.trigger_script_event(1 << player_id, {111242367, player_id, memory.script_global(2689235 + 1 + (player_id * 453) + 318 + 7)})
    end)

    menu.action(kicks, "Error De Conexion", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
    end)

    menu.action(kicks, "Coleccionable Invalido", {}, "", function()
        util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
    end)

    if menu.get_edition() >= 2 then 
        menu.action(kicks, "Kickeo Adaptivo", {}, "", function()
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {0x6A16C7F, player_id, memory.script_global(0x2908D3 + 1 + (player_id * 0x1C5) + 0x13E + 0x7)})
            util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
            menu.trigger_commands("breakup" .. players.get_name(player_id))
        end)
    else
        menu.action(kicks, "Kickeo adaptivo V2", {}, "", function()
            util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
            util.trigger_script_event(1 << player_id, {0x6A16C7F, player_id, memory.script_global(0x2908D3 + 1 + (player_id * 0x1C5) + 0x13E + 0x7)})
            util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
        end)
    end

    local antimodder = menu.list(malicious, "Anti-Modder", {}, "")
    local kill_godmode = menu.list(antimodder, "Matar jugador con godmode", {}, "")
    menu.action(kill_godmode, "Stun", {""}, "Funciona en menus que usan a prueba de:", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 99999, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
    end)

    menu.slider_text(kill_godmode, "Aplastamiento", {}, "", {"Khanjali", "APC"}, function(index, veh)
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

    player_toggle_loop(antimodder, player_id, "Remover godmode de carro", {}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) and not PED.IS_PED_DEAD_OR_DYING(ped) then
            local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
            ENTITY.SET_ENTITY_CAN_BE_DAMAGED(veh, true)
            ENTITY.SET_ENTITY_INVINCIBLE(veh, false)
            ENTITY.SET_ENTITY_PROOFS(veh, false, false, false, false, false, 0, 0, false)
        end
    end)

    menu.action(antimodder, "Remover godmode de carro V2", {}, "", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p)
        if PED.IS_PED_IN_ANY_VEHICLE(p) then
            RequestControl(veh)
            ENTITY.SET_ENTITY_INVINCIBLE(veh, false)
        else
            util.toast(players.get_name(player_id).. " No esta en un coche")
        end
    end)

    menu.toggle_loop(antimodder, "Remover godmode de carro V3", {}, "", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p)
        if PED.IS_PED_IN_ANY_VEHICLE(p) then
            RequestControl(veh)
            ENTITY.SET_ENTITY_INVINCIBLE(veh, false)
        else
            util.toast(players.get_name(player_id).. " No esta en un coche")
        end
    end)

    menu.action(trolling, "Enviar Al Bote", {}, "", function()
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
    
    menu.action(trolling, "Clonar", {}, "Clona al jugador en un ped", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local c = ENTITY.GET_ENTITY_COORDS(p)
        local pclone = entities.create_ped(26, ENTITY.GET_ENTITY_MODEL(p), c, 0)
        pclpid [#pclpid + 1] = pclone 
        PED.CLONE_PED_TO_TARGET(p, pclone)
    end)

    menu.action(trolling, "Clonar Con Arma 'Test'", {}, "Clona al jugador en un ped con arma", function()
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

    menu.action(trolling, "Chop 'Test'", {}, "Saca un chop", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local c = ENTITY.GET_ENTITY_COORDS(p)
        STREAMING.REQUEST_MODEL(chop)
        while not STREAMING.HAS_MODEL_LOADED(chop) do
            STREAMING.REQUEST_MODEL(chop)
            util.yield()
        end
        local achop = entities.create_ped(26, chop, c, 0) --spawn chop
        TASK.TASK_COMBAT_PED(achop , p, 0, 16)
        setAttribute(achop)
        if (isImmortal == true) then
            ENTITY.SET_ENTITY_CAN_BE_DAMAGED(achop , false)
        end
        if not STREAMING.HAS_MODEL_LOADED(chop) then
            util.toast("No se puede cargar el modelo")
        end
    end)

    player_toggle_loop(trolling, player_id, "Spam De Sonido", {}, "", function()
        util.trigger_script_event(1 << player_id, {0x4246AA25, player_id, math.random(1, 0x6)})
        util.yield()
    end)

    menu.action(trolling, "Teletransportar a los backrooms 'Test'", {}, "Les teletransporta a los backrooms", function()
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
            util.toast(players.get_name(player_id).. " No esta en un vehiculo")
        end
    end)

    control_veh_cmd = menu.toggle(trolling, "Controlar vehiculo del jugador", {}, "Solo funciona en vehiculos terrestres.", function(toggle)
        control_veh = toggle

        while control_veh do 
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
            local player_veh = PED.GET_VEHICLE_PED_IS_IN(ped)
            local class = VEHICLE.GET_VEHICLE_CLASS(player_veh)
            if not players.exists(player_id) then util.stop_thread() end

            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
                util.toast("Jugador muy lejos.")
                menu.set_value(control_veh_cmd, false)
            return end

            if class == 15 then
                util.toast("El jugador esta en un helicoptero.")
                menu.set_value(control_veh_cmd, false)
            break end
            
            if class == 16 then
                util.toast("El jugador esta en un avion.")
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
                util.toast("El jugador no esta en un vehiculo. :/")
                menu.set_value(control_veh_cmd, false)
            end
            util.yield()
        end
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


    menu.toggle_loop(friendly, "Dar godmode silensioso", {}, "No lo detectaran mod menus gratuitos", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), true, true, true, true, true, false, false, true)
        end, function() 
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), false, false, false, false, false, false, false, false)
    end)

    menu.action(friendly, "Dartles nivel 25", {}, "Les da nivel 25 aprox (Thx jinx <3).", function()
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

    menu.toggle_loop(friendly, "Dar fichas del casino", {"dropchips"}, "Se testeo por 3 semanas y parece seguro, sin embargo puede ser detectado en cualquier momento", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(p)
        STREAMING.REQUEST_MODEL(card)
        while not STREAMING.HAS_MODEL_LOADED(card) do
            STREAMING.REQUEST_MODEL(card)
            util.yield()
        end
        OBJECT.CREATE_AMBIENT_PICKUP(pickup, pos.x, pos.y, pos.z, 0, false, card, true, false) --spawn casino chips
        if not STREAMING.HAS_MODEL_LOADED(card) then
            util.toast("No se pudo cargar el modelo")
        end
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
            util.toast(" No se pudo obtener el control del vehiculo o el jugador no esta en un vehiculo.")
        end
    end)

    menu.toggle_loop(vehicle, "Desabilitar Vehiculo", {}, "Es mejor que el de stand", function(toggle)
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if (PED.IS_PED_IN_ANY_VEHICLE(p)) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
        else
            local veh2 = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(p)
            entities.delete_by_handle(veh2)
        end
    end)

    menu.action(vehicle, "Desabilitar Vehiculo V2", {}, "Inbloqueable por stand '10/02'", function(toggle)
        local player_ped = PLAYER.GET_PLAYER_PED(pid)
        local player_vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, include_last_vehicle_for_player_functions)
        if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_vehicle) then
            VEHICLE.SET_VEHICLE_ENGINE_HEALTH(player_vehicle, -10.0)
            util.toast(players.get_name(player_id) .. " Motor jodido")
        else
            util.toast(" No se pudo obtener el control del vehiculo o el jugador no esta en un vehiculo")
        end
    end)



end)




menu.slider(world, "Transparencia Local", {"transparency"}, "No funciona muy bien ahora, intentare arreglarlo luego", 0, 100, 100, 20, function(value)
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

menu.toggle_loop(world, "Campo De Fuerza", {"sforcefield"}, "", function()
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
            if (players.is_godmode(player_id) or not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(ped)) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior then
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
                if not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(player_veh) and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior then
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
        for i, hash in ipairs(modded_weapons) do
            local weapon_hash = util.joaat(hash)
            if WEAPON.HAS_PED_GOT_WEAPON(ped, weapon_hash, false) and (WEAPON.IS_PED_ARMED(ped, 7) or TASK.GET_IS_TASK_ACTIVE(ped, 8) or TASK.GET_IS_TASK_ACTIVE(ped, 9)) then
                util.toast(players.get_name(player_id) .. " Esta usando arma mod")
                break
            end
        end
    end
end)

menu.toggle_loop(detections, "Coche Modeada", {}, "Saldra si tiene un coche mod", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local modelHash = players.get_vehicle_model(player_id)
        for i, name in ipairs(modded_vehicles) do
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
        if not util.is_session_transition_active() and get_interior_player_is_in(player_id) == 0 and get_transition_state(player_id) ~= 0 and not PED.IS_PED_DEAD_OR_DYING(ped) 
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
        and get_interior_player_is_in(player_id) == 0 and get_transition_state(player_id) ~= 0
        and not PED.IS_PED_IN_ANY_VEHICLE(ped, false) -- too many false positives occured when players where driving. so fuck them. lol.
        and not NETWORK.NETWORK_IS_PLAYER_FADING(player_id) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped)
        and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped) and not PED.IS_PED_USING_SCENARIO(ped)
        and not TASK.GET_IS_TASK_ACTIVE(ped, 160) and not TASK.GET_IS_TASK_ACTIVE(ped, 2)
        and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(player_id)) <= 395.0 -- 400 was causing false positives
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
            if not util.is_session_transition_active() and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior
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
            util.yield(1000)
            local currentpos = players.get_position(player_id)
            for i, interior in ipairs(interior_stuff) do
                if v3.distance(oldpos, currentpos) > 500 and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
                and get_transition_state(player_id) ~= 0 and get_interior_player_is_in(player_id) == interior and PLAYER.IS_PLAYER_PLAYING(player_id) and player.exists(player_id) then
                    util.toast(players.get_name(player_id) .. " Se acaba de teletransportar")
                end
            end
        end
    end
end)

menu.toggle_loop(detections, "Voto De Kickeo 'Test'", {}, "Detecta si votan por expulsar a alguien de la sesion muy rapidamente y avisa.  Mas conocido como 'smart kick' en stand.", function()
    for _, player_id in ipairs(players.list(false, true, true)) do
        local kickowner = NETWORK.NETWORK_SESSION_GET_KICK_VOTE(player_id)
        local kicked = NETWORK.NETWORK_SESSION_KICK_PLAYER(player_id)
        if kicked then
            util.draw_debug_text(players.get_name(player_id) .. " El jugador", kicked, "ha sido kickeado por:", kickowner)
            break
        end
    end
end)
--------------------------------------------------------------------------------------------------------------------------------
--Online

menu.toggle_loop(online, "Adicto SH", {}, "Te buelbez adicto al script houst", function()
    if players.get_script_host() ~= players.user() and get_transition_state(players.user()) ~= 0 then
        menu.trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
    end
end)

menu.toggle(online, "Anti-Chat", {}, "Hace que no salga cuando estas escribiendo el 'icono' encima de ti", function()
	if on then
		menu.trigger_commands("hidetyping on")
	else
		menu.trigger_commands("hidetyping off")
	end
end)

local maxHealth <const> = 328
menu.toggle_loop(online, ("Fuera Del Radar Muerto"), {"undeadotr"}, "", function()
	if ENTITY.GET_ENTITY_MAX_HEALTH(players.user_ped()) ~= 0 then
		ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), 0)
	end
end, function ()
	ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), maxHealth)
end)

menu.toggle_loop(online, "Aceptar La Union", {}, "Aceptara automaticamente pantallas de unirse", function() -- credits to jinx for letting me steal this
    local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
    if message_hash == 15890625 or message_hash == -398982408 or message_hash == -587688989 then
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
        util.yield(200)
    end
end)

menu.toggle(online, "Armas Termicas 'Test'", {}, "Hace todas tus armas con mira termica con la tecla. E", function()
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

menu.toggle(online, "Sangre Fria 'Test'", {}, "Remueve tu señal termica.\nAlgunos jugadores pueden seguir viendote.", function(toggle)
    local player = PLAYER.PLAYER_PED_ID()
    if toggle then
        PED.SET_PED_HEATSCALE_OVERRIDE(player, 0)
    else
        PED.SET_PED_HEATSCALE_OVERRIDE(player, 1)
    end
end)

joining = false
menu.toggle(online, "Notificacion De Jugador", {}, "Avisa cuando un jugador entra a la sesion", function(on_toggle)
	if on_toggle then
		joining = true
	else
		joining = false
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
        memory.write_int(memory.script_global(2815059 + 876), 1)
        memory.write_int(memory.script_global(2815059 + 883), 1)
	end
end)

menu.action(servicios, "Quitar Recompenza", {}, "", function()
    if memory.read_int(memory.script_global(1835502 + 4 + 1 + (players.user() * 3))) == 1 then 
        memory.write_int(memory.script_global(2815059 + 1856 + 17), -1)
        memory.write_int(memory.script_global(2359296 + 1 + 5149 + 13), 2880000)
    else
        util.toast("No tienes recompenza :/")
    end
end)

recovery = menu.list(online, "Recovery", {}, "")


menu.action(recovery, "Dar M16", {""}, "", function()
    memory.write_int(memory.script_global(262145 + 32775), 1)
end)

local coleccionables = menu.list(recovery, "Coleccionables", {}, "")

menu.click_slider(coleccionables, "Cintas", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x0, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Hidden Caches", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x1, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Cofres/Tesoro", {""}, "", 0, 1, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x2, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Antenas Radio", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x3, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "USBs", {""}, "", 0, 19, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x4, i, 1, 1, 1})
end)

menu.action(coleccionables, "Naufragios", {""}, "", function()
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x5, 0, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Enterrados", {""}, "", 0, 1, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x6, i, 1, 1, 1})
end)

menu.action(coleccionables, "Camisetas Halloween", {""}, "", function()
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x7, 1, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Linternas", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x8, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Productos organicos lamar", {""}, "", 0, 99, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x9, i, 1, 1, 1})
end)

menu.click_slider(coleccionables, "Junk Energy Vuelo Libre", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0xA, i, 1, 1, 1})
end)

local pump_list = menu.list(coleccionables, "Pumkpins", {}, "Funciona")
for idx, coords in pumps_from_gtaweb_eu do
    pump_list:action("Pumpkin " .. idx, {}, "Teletransportate a las calabazas", function()
        util.teleport_2d(coords[1], coords[2])
    end)
end

local bypasskick = menu.list(online, "Bypass Kick", {}, "Opciones que te permiten usar metodos para \n entrar a la sesion si te estan bloqueando.")

menu.divider(bypasskick, "Metodos Normales")

menu.toggle(bypasskick, "Metodo V1", {}, "Te da un tiempo limitado para que expulses al que te bloquea", function(on_toggle)
    local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
    local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
    if on_toggle then
        menu.trigger_commands("nobgscript on")
        menu.trigger_command(BlockIncSyncs)
        menu.trigger_command(BlockNetEvents)
        util.toast("Activado, ahora entra a su sesion y prepara el kick")
    else
        menu.trigger_commands("nobgscript off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        util.toast("Listo, todo desactivado")
    end
end)

menu.toggle(bypasskick, "Metodo V2", {}, "Un poco mas funcional pero tambien con mas errores de red", function(on_toggle)
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
        util.toast("Activado, ahora entra a su sesion y prepara el kick")
    else
        menu.trigger_commands("nobgscript off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        menu.trigger_command(BlockBailing3, "off")
        util.toast("Listo, todo desactivado")
    end
end)

menu.toggle(bypasskick, "Metodo V3", {}, "Metodo mas funcional, pero para desarrolladores, recibiras notificacion de todo evento de red", function(on_toggle)
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
    util.toast("Activado, ahora entra a su sesion y prepara el kick")
else
    menu.trigger_commands("nobgscript off")
    menu.trigger_command(UnblockIncSyncs)
    menu.trigger_command(UnblockNetEvents)
    menu.trigger_command(BlockBailing3, "off")
    menu.trigger_command(UnShowNotis)
    menu.trigger_command(UnBlockRaw)
    util.toast("Listo, todo desactivado")
end
end)

menu.toggle(bypasskick, "Metodo V4", {}, "Probablemente rompa el juego, usa en tu propio riesgo", function(on_toggle)
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
        util.toast("Activado, ahora entra a su sesion y prepara el kick")
    else
        menu.trigger_commands("nobgscript off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        menu.trigger_command(BlockBailing3, "off")
        menu.trigger_command(UnShowNotis)
        menu.trigger_command(UnBlockRaw)
        menu.trigger_commands("skipbroadcast off")
        menu.trigger_command(DontAsk, "off")
        menu.trigger_commands("skipswoopdown off")
        util.toast("Listo, todo desactivado")
    end
    end)

--------------------------------------------------------------------------------------------------------------------------------
--Protecciones

menu.action(protects, "Parar Todos Los Sonidos", {"stopsounds"}, "", function()
    for i=-1,100 do
        AUDIO.STOP_SOUND(i)
        AUDIO.RELEASE_SOUND_ID(i)
    end
end)

menu.action(protects, "Quitar ring", {}, "Quita el ringtone del celular parando que deje de sonar.", function()
    if AUDIO.IS_PED_RINGTONE_PLAYING then
        for i=-1, 50 do
            AUDIO.STOP_PED_RINGTONE(i)
        end
    end
end)

local quitarf = menu.list(protects, "Metodos De Anti Freeze")

menu.action(quitarf, "Quitar Freeze V1", {}, "Intenta reiniciar algunos nativos para quitarte el estado de freeze.", function()
    --local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    MISC.OVERRIDE_FREEZE_FLAGS()
    menu.trigger_commands("rcleararea")
end)

menu.action(quitarf, "Quitar Freeze V2 'Test'", {}, "Intenta reiniciar algunos nativos para quitarte el estado de freeze \nCon este metodo moriras.", function()
    --local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    ENTITY.SET_ENTITY_COORDS(player, 1, 0, 0, 1, false)
    MISC.OVERRIDE_FREEZE_FLAGS()
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
    local TransactionError = menu.ref_by_path("Online>Protections>Events>Transaction Error Event>Block")
    local TransactionErrorV = menu.ref_by_path("Online>Protections>Events>Transaction Error Event>Notification")
    local ScriptEvent = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Script Event>Block")
    local ScriptEventV = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Script Event>Notification")
    if on_toggle then
        menu.trigger_command(TransactionError, "on")
        --if STATS.SET_SAVE_MIGRATION_TRANSACTION_ID_WARNING, NETSHOPPING.NET_GAMESERVER_IS_SESSION_REFRESH_PENDING then
        --    SCRIPT.TERMINATE_THIS_THREAD
        --end
        menu.trigger_command(TransactionErrorV, "on")
        menu.trigger_commands("removeloader")
        --menu.trigger_command(ScriptEvent, "on")
        --menu.trigger_command(ScriptEvent1, "on")
        util.toast("No es mi culpa el error del log, esperen a que Stand lo arregle")
    else
        --menu.trigger_command(ScriptEvent, "off")
        --menu.trigger_command(ScriptEventV, "off")
    end
end)

menu.toggle_loop(protects, "Bloquear Fuego/Lag", {}, "", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
end)

menu.toggle_loop(protects, "Bloquear PTFX", {}, "", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
end)

menu.toggle_loop(protects, "Anti Bestia", {}, "Previene que te vuelvan la bestia con stand etc.", function()
    if util.spoof_script("am_hunt_the_beast", SCRIPT.TERMINATE_THIS_THREAD) then
        util.toast("Detectado script de bestia, parando script...")
    end
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

menu.click_slider_float(modificaciones, "Multiplicador De Curva", {"curve"}, "", 0, 500, 100, 10, function(value)
    value/=100
    local VehicleHandle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
    if VehicleHandle == 0 then return end
    local CAutomobile = entities.handle_to_pointer(VehicleHandle)
    local CHandlingData = memory.read_long(CAutomobile + 0x0938)
    memory.write_float(CHandlingData + 0x0094, value)
end)

menu.toggle_loop(modificaciones, "Mejoras Random", {}, "Only works on vehicles you spawned in for some reason", function()
    local mod_types = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, 14, 15, 16, 23, 24, 25, 27, 28, 30, 33, 35, 38, 48}
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
        for i, upgrades in ipairs(mod_types) do
            VEHICLE.SET_VEHICLE_MOD(entities.get_user_vehicle_as_handle(), upgrades, math.random(0, 20), false)
        end
    end
    util.yield(100)
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

local bullet_proof
bullet_proof = menu.toggle_loop(modificaciones, "A prueba de balas", {}, "", function()
    local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
    if ENTITY.GET_ENTITY_MODEL(player_veh) == true then
        ENTITY.SET_ENTITY_PROOFS(player_cur_car, true, true, true, true, true, true, true, true)
    else
        util.toast("No estas en un vehiculo.")
        menu.trigger_command(bullet_proof, "off")
    end
end)


infcms = false
menu.toggle(modificaciones, "Contramedidas Infinitas", {"infinitecms"}, "Dara contramedidas infinitas.", function(on)
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
-- Diversion

menu.toggle(fun, "Piloto Tesla", {}, "", function(toggled)
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

menu.action(fun, "Jalar el gatillo", {}, "Juega la ruleta rusa con tu juego", function()
    if randomizer(array) == "1" then
        util.toast("Sobreviviste :D")
    else
        util.log("Tu juego murio D:")
        ENTITY.APPLY_FORCE_TO_ENTITY(0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, false, false, false)
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

menu.toggle_loop(fun, "Gato Mascota", {}, "", function()
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
local army = menu.list(fun, "Ataque Gatuno", {}, "Saca gatos... MUCHOS GATOS!!")
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

menu.action(army, "Limpiar G", {}, "", function()
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

menu.hyperlink(menu.my_root(), "Entra al discord!", "https://discord.gg/BNbSHhunPv")
local credits = menu.list(misc, "Creditos", {}, "")
menu.action(credits, "Emir, Joju, Pepe, Ady, Vicente, Sammy", {}, "This will never be posible without them <3", function()
end)
menu.action(credits, "JinxScript", {}, "Thx for many of the player detection :3.", function()
end)
menu.action(credits, "gLance", {}, "He gave me a lot of help with Gta V natives.", function()
end)
menu.action(credits, "LanceScriptTEOF", {}, "He helped me learn and understand Gta V natives", function()
end)
menu.action(credits, "Aaron", {}, "Thanks for helping me with my first steps in the stand lua api", function()
end)
menu.action(credits, "Cxbr", {}, "Thx for friendly features <3", function()
end)
menu.action(credits, "Sapphire", {}, "Who helped me with almost every single feature and being patient because of my dumb brain <3", function()
end)
menu.action(credits, "You <3", {}, "Who download the script and give ideas for improvement <3", function()
end)

util.on_stop(function ()
    VEHICLE.SET_VEHICLE_GRAVITY(veh, true)
    ENTITY.SET_ENTITY_COLLISION(veh, true, true);
    sleep(100)
    util.toast("Adious\nEspero te haya gustado :3")
    util.toast("Limpiando...")
end)

players.dispatch_on_join()
