require("natives-1663599433")
ptoggle1 = {}
for a=0, 31 do 
	ptoggle1[a] = false
end

GenerateFeatures = function(pid)

function delet_entity(entity)
        entitypointer = memory.alloc(24)
        memory.write_int(entitypointer, entity)
        bool = ENTITY.DELETE_ENTITY(entitypointer)
        memory.free(entitypointer)
        return bool
    end
	-- body
function crash_attach_object(model_name,pid)

	 vzRot = 0
       
      local hash = util.joaat(model_name)
     while not STREAMING.HAS_MODEL_LOADED(hash) do
     	STREAMING.REQUEST_MODEL(hash)
     	util.yield()
     end
        

     	attach = OBJECT.CREATE_OBJECT(hash, 0, 0 , 0, true, true)
		attach2 = OBJECT.CREATE_OBJECT(hash, 0, 0 , 0, true, true)
        
     
         ENTITY.ATTACH_ENTITY_TO_ENTITY(attach, ped_to_attach, 0, 0, 0, 0, 0, 0, vzRot, false, true, true, false, 0, false)
		 ENTITY.ATTACH_ENTITY_TO_ENTITY(attach2, ped_to_attach2, 0, 0, 0, 0, 0, 0, vzRot, false, true, true, false, 0, false)
         ENTITY.SET_ENTITY_VISIBLE(attach, true)
		 ENTITY.SET_ENTITY_VISIBLE(attach2, true)
         STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
                  util.yield()

   
	end
 

function crash_attach_ped(model_name,pid)

	 vzRot = 0
       local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
      local hash = util.joaat(model_name)
     while not STREAMING.HAS_MODEL_LOADED(hash) do
     	STREAMING.REQUEST_MODEL(hash)
     	util.yield()
     end
        

     
         attach = entities.create_ped(28 ,hash, ENTITY.GET_ENTITY_COORDS(V3, true), CAM.GET_FINAL_RENDERED_CAM_ROT(64).z)
		 attach2 = entities.create_ped(29 ,hash, ENTITY.GET_ENTITY_COORDS(V3, true), CAM.GET_FINAL_RENDERED_CAM_ROT(64).z)
         
		 
		 
		 
		 
         ENTITY.ATTACH_ENTITY_TO_ENTITY(attach, ped_to_attach, 0, 0, 0, 0, 0, 0, vzRot, false, true, true, false, 0, false)
		 ENTITY.ATTACH_ENTITY_TO_ENTITY(attach, ped_to_attach2, 0, 0, 0, 0, 0, 0, vzRot, false, true, true, false, 0, false)
         ENTITY.SET_ENTITY_VISIBLE(attach, true)
         STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
                  util.yield()

   
	end
 

 function crash_attach_veh(model_name,pid)

	 vzRot = 0
       local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
      local hash = util.joaat(model_name)
     if STREAMING.IS_MODEL_A_VEHICLE(hash) then
        STREAMING.REQUEST_MODEL(hash)
		while not STREAMING.HAS_MODEL_LOADED(hash) do
			util.yield()
		end

         
         attach = entities.create_vehicle(hash, ENTITY.GET_ENTITY_COORDS(V3, true), CAM.GET_FINAL_RENDERED_CAM_ROT(64).z)
			
         ENTITY.ATTACH_ENTITY_TO_ENTITY(attach, ped_to_attach, 0, 0, 0, 0, 0, 0, vzRot, false, true, true, false, 0, false)
		 ENTITY.ATTACH_ENTITY_TO_ENTITY(attach, ped_to_attach2, 0, 0, 0, 0, 0, 0, vzRot, false, true, true, false, 0, false)
         ENTITY.SET_ENTITY_VISIBLE(attach, true)
         STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
         util.log(attach)



      
         util.yield()

      
	end
end

          menu.divider(menu.player_root(pid),"The Tasar Bomba")
parent  = menu.list(menu.player_root(pid), "Tsar Bomba" ,{}, "WARNING : Keep distance from targeted player, otherwise it WILL affect you", function();end)

function spectate(pid)
    local name = PLAYER.GET_PLAYER_NAME(pid)
    menu.trigger_commands("spectate" .. name)
	end



	

menu.toggle(parent,"The Tsar Bomba", {}, "Falling-edge toggle for entity spamming the targeted player, from testing it will spawn 1 NPC on the rising-edge, and spam on the falling-edge.", function(on) -- This function creates the button inside Stand
			
			if on then 
				ptoggle1[pid] = true
		local ped_name1 = "a_m_y_acult_01"
		ped_hash = util.joaat(ped_name1)
       	local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)

       	while not STREAMING.HAS_MODEL_LOADED(ped_hash)do
       		STREAMING.REQUEST_MODEL(ped_hash)
       		util.yield()
       	end
		   ped_to_attach = entities.create_ped(28, ped_hash, ENTITY.GET_ENTITY_COORDS(V3, true), CAM.GET_FINAL_RENDERED_CAM_ROT(64).z)
		   STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		   util.yield(1000)
		   --ped_to_attach2 = util.create_ped(29, ped_hash, ENTITY.GET_ENTITY_COORDS(V3, true), CAM.GET_FINAL_RENDERED_CAM_ROT(0).z)
		   --STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		   --util.yield(1000)



				
			else 
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				util.yield(38)



				--util.yield(380)




				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				util.yield(38)
				crash_attach_object("prop_gas_pump_1a", pid)
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				util.yield(38)
				util.yield(0)
				crash_attach_object("stt_prop_stunt_tube_cross", pid)
				util.yield(17)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(33)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				util.yield(38)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(80)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(28)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(30)
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				util.yield(38)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(80)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(34)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )

				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(33)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(80)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(42)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				util.yield(38)
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(33)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(80)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(28)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				util.yield(38)
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(33)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				util.yield(80)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(28)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(33)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(80)
				crash_attach_object("prop_gas_pump_1d", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1d", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1d", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1d", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1d", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1d", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1d", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1d", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1d", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1d", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_gas_pump_1a", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("prop_storagetank_02b", pid)
				crash_attach_object("stt_prop_stunt_tube_cross", pid)
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(28)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(33)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(80)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(28)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(33)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(80)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(28)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(33)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(80)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(28)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(33)
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				util.yield(38)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(80)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(28)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(33)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(80)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(28)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv3, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)
				util.yield(38)
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(33)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(70)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(10)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(80)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(28)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				FIRE.ADD_OWNED_EXPLOSION(player_pedv2, coords.x, coords.y, coords.z + 1, 33, 1, true, false, 1 ,true )
				util.yield(13)
				ptoggle1[pid] = false -- If the toggle is not on, change the toggle variable to false

				local V3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local coords = ENTITY.GET_ENTITY_COORDS(V3, true) 

				local player_pedv3 = PLAYER.PLAYER_PED_ID(28)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach, coords.x, coords.y, coords.z , false, false, false, false )


				local coords1 = ENTITY.GET_ENTITY_COORDS(ped_to_attach, true) 
				
				local player_pedv2 = PLAYER.PLAYER_PED_ID(29)
								ENTITY.SET_ENTITY_COORDS(ped_to_attach2, coords.x, coords.y, coords.z , false, false, false, false )


				local coords2 = ENTITY.GET_ENTITY_COORDS(ped_to_attach2, true)


				util.yield(380)
				util.toast(os.date("%H:%M:%S").." Ending entity spam on Player ID : "..pid..". Please note that the spammed objects will still be there as this lua does not clean up after itself.", TOAST_ABOVE_MAP)
			    --entity_ptr = memory.alloc(attach)
				--read = memory.read_int(entity_ptr)
         		--VEHICLE.DELETE_VEHICLE(read)
			end
			
		end)
		end
			
			

			for pid = 0,31 do 
		if players.exists(pid) then 
			GenerateFeatures(pid)
		util.yield()
		end
	end
    players.on_join(GenerateFeatures)
	
		while true do 
		
		
		for pid=0,31 do 
		
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("kosatka", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("kosatka", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("kosatka", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("monster", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			   crash_attach_veh("cargobob", pid)
			   util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
            end
			if ptoggle1[pid] and players.exists(pid) then
                
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("cargobob", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
                crash_attach_veh("openwheel2", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
			    crash_attach_veh("cargobob", pid)
			    util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("monster", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
			
				crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("alkonost", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then

                crash_attach_veh("patrolboat", pid)
				util.yield(0)
			end
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)
			if ptoggle1[pid] and players.exists(pid) then
            
				crash_attach_veh("alkonost", pid)
				util.yield(0)




				
				util.toast(os.date("%H:%M:%S").."Now is the time to unseak on the player: "..pid.." Crash in progress...", TOAST_ABOVE_MAP)		
				util.yield(3000)
			end 			
		end

		util.yield()
	end

end