util.require_natives(1651208000)

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

menu.action(menu.my_root(), "Go to Players List", {}, "Shotcut for players list.", function()
    menu.trigger_commands("playerlist")
end)

players.on_join(function(pid)
    menu.divider(menu.player_root(pid), "Object Crash")
    local amount = 200
    local delay = 100
    menu.slider(menu.player_root(pid), "Spawn Amount", {}, "", 0, 2500, amount, 50, function(val)
        amount = val
    end)
    menu.slider(menu.player_root(pid), "Spawn Delay", {}, "", 0, 500, delay, 10, function(val)
        delay = val
    end)
    menu.list_select(menu.player_root(pid), "Object Model", {}, "", object_names, 1, function(val)
        selectedobject = all_objects[val]
    end)
    menu.action(menu.player_root(pid), "Send Objects", {}, "", function()
        
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
end)

players.dispatch_on_join()
util.keep_running()