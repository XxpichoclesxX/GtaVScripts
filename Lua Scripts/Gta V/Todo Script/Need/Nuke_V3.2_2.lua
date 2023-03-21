util.require_natives(1651208000)


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
menu.action(menu.my_root(), "Go to Players List", {}, "Shotcut for players list.", function()
	menu.trigger_commands("playerlist")
end)

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

players.on_join(PlayerOptions)
players.dispatch_on_join()
util.keep_running()