-- This was coded and rebuild by XxpichoclesxX#0427
-- Love ya this is a rebuild of past codes and some improovements that some friends helped me with
-- Enjoy this and if you find any bug just write me on discord (XxpichoclesxX#0427)
-- With love Picho <3

require_game_build(2699) -- v1.61


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local GTr = 2671447+59
local GHs = 2671447+46
local delay = 0.1
local LpC = 0
local function set_model_hash(h)
	globals.set_int(GTr, 1)
	while (globals.get_int(GTr) ~= 0) do
		if localplayer:get_model_hash() == h then return end
		if LpC == 10 then return end
		globals.set_int(GTr, 1)
		globals.set_int(GHs, h)
		sleep(delay)
		globals.set_int(GTr, 0)
		globals.set_int(GHs, 0)
		if localplayer:get_model_hash() ~= h then
			delay = delay+0.05
			LpC = LpC + 1
		end
	end
	if  LpC == 10 then
		delay = 0.1
	end
	LpC = 0
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local function Text(text) menu.add_action(text, function() end) end local fmC2020 = script("fm_pichocles_script_2022") local fmC = script("fm_pichocles_script") local PlayerIndex = stats.get_int("MPPLY_LAST_MP_CHAR") local mpx = PlayerIndex if PlayerIndex == 0 then mpx = "MP0_" else mpx = "MP1_" end local xox_00 = 1 local xox_01 = 1 local xox_0 = 1 local xox_1 = 1 local xox_2 = 1 local xox_3 = 1 local xox_4 = 1 local xox_5 = 1 local xox_6 = 1 local xox_7 = 1 local xox_8 = 1 local xox_9 = 1 local xox_10 = 1 local xox_11 = 1 local xox_12 = 1 local xox_13 = 1 local xox_14 = 1 local xox_15 = 1 local xox_16 = 1 local xox_17 = 1 local xox_18 = 1 local xox_19 = 1 local xox_20 = 1 local xox_21 = 1 local xox_22 = 1 local xox_23 = 1 local xox_24 = 1 local xox_25 = 1 local xox_26 = 1 local xox_27 = 1 local xox_28 = 1 local xox_29 = 1 local xox_30 = 1 local xox_31 = 1 local xox_32 = 1 local xox_33 = 1 local xox_34 = 1 local xox_35 = 1 local e0 = false local e1 = false local e2 = false local e3 = false local e4 = false local e5 = false local e6 = false local e7 = false local e8 = false local e9 = false local e10 = false local e11 = false local e12 = false local e13 = false local e14 = false local e15 = false local e16 = false local e17 = false local e18 = false local e19 = false local e20 = false local e21 = false local e22 = false local e23 = false local e24 = false local e25 = false local e26 = false local e27 = false local e28 = false local e29 = false local e30 = false local e31 = false local e32 = false local e33 = false local e34 = false local e35 = false local e36 = false local e37 = false local e38 = false local e39 = false local e40 = false local function TP(x, y, z, yaw, roll, pitch) if localplayer:is_in_vehicle() then localplayer:get_current_vehicle():set_position(x, y, z) localplayer:get_current_vehicle():set_rotation(yaw, roll, pitch) else localplayer:set_position(x, y, z) localplayer:set_rotation(yaw, roll, pitch) end end local mainMenu = menu.add_submenu(" Pichocles UwU ")

local modelMenu = mainMenu:add_submenu("Self")

modelMenu:add_action("Añadir malos jugadores", function() stats.set_int("MPPLY_BADSPORT_MESSAGE", -1) stats.set_int("MPPLY_BECAME_BADSPORT_NUM", -1) stats.set_float("MPPLY_OVERALL_BADSPORT", 60000) stats.set_bool("MPPLY_CHAR_IS_BADSPORT", true) globals.set_int(1575015, 0) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)
modelMenu:add_action("Quitar malos jugadores", function() stats.set_int("MPPLY_BADSPORT_MESSAGE", 0) stats.set_int("MPPLY_BECAME_BADSPORT_NUM", 0) stats.set_float("MPPLY_OVERALL_BADSPORT", 0) stats.set_bool("MPPLY_CHAR_IS_BADSPORT", false) globals.set_int(1575015, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)
modelMenu:add_action("Reienar Inv y Armadula", function()	stats.set_int(mpx .. "NO_BOUGHT_YUM_SNACKS", 30) stats.set_int(mpx .. "NO_BOUGHT_HEALTH_SNACKS", 15) stats.set_int(mpx .. "NO_BOUGHT_EPIC_SNACKS", 5) stats.set_int(mpx .. "NUMBER_OF_CHAMP_BOUGHT", 5) stats.set_int(mpx .. "NUMBER_OF_ORANGE_BOUGHT", 11) stats.set_int(mpx .. "NUMBER_OF_BOURGE_BOUGHT", 10) stats.set_int(mpx .. "CIGARETTES_BOUGHT", 20) stats.set_int(mpx .. "MP_CHAR_ARMOUR_1_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_2_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_3_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_4_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_5_COUNT", 10) stats.set_int(mpx .. "BREATHING_APPAR_BOUGHT", 20) end) modelMenu:add_action("Reienar Inv x1000", function() stats.set_int(mpx .. "NO_BOUGHT_YUM_SNACKS", 1000) stats.set_int(mpx .. "NO_BOUGHT_HEALTH_SNACKS", 1000) stats.set_int(mpx .. "NO_BOUGHT_EPIC_SNACKS", 1000) stats.set_int(mpx .. "NUMBER_OF_CHAMP_BOUGHT", 1000) stats.set_int(mpx .. "NUMBER_OF_ORANGE_BOUGHT", 1000) stats.set_int(mpx .. "NUMBER_OF_BOURGE_BOUGHT", 1000) stats.set_int(mpx .. "CIGARETTES_BOUGHT", 1000) stats.set_int(mpx .. "MP_CHAR_ARMOUR_1_COUNT", 1000) stats.set_int(mpx .. "MP_CHAR_ARMOUR_2_COUNT", 1000) stats.set_int(mpx .. "MP_CHAR_ARMOUR_3_COUNT", 1000) stats.set_int(mpx .. "MP_CHAR_ARMOUR_4_COUNT", 1000) stats.set_int(mpx .. "MP_CHAR_ARMOUR_5_COUNT", 1000) stats.set_int(mpx .. "BREATHING_APPAR_BOUGHT", 1000) end) modelMenu:add_action("Cambiar Genero", function() stats.set_int(mpx.."ALLOW_GENDER_CHANGE", 52) globals.set_int(281050, 0) end) local enable = false local speed = 2 local function up() if not enable then return end local newpos = localplayer:get_position() + vector3(0,0,speed) if not localplayer:is_in_vehicle() then localplayer:set_position(newpos) else vehicle=localplayer:get_current_vehicle() vehicle:set_position(newpos) end end local function down() if not enable then return end local newpos = localplayer:get_position() + vector3(0,0,speed * -1) if not localplayer:is_in_vehicle() then localplayer:set_position(newpos) else vehicle=localplayer:get_current_vehicle() vehicle:set_position(newpos) end end local function forward() if not enable then return end local dir = localplayer:get_heading() local newpos = localplayer:get_position() + (dir * speed) if not localplayer:is_in_vehicle() then localplayer:set_position(newpos) else vehicle=localplayer:get_current_vehicle() vehicle:set_position(newpos) end end local function backward() if not enable then return end local dir = localplayer:get_heading() local newpos = localplayer:get_position() + (dir * speed * -1) if not localplayer:is_in_vehicle() then localplayer:set_position(newpos) else vehicle=localplayer:get_current_vehicle() vehicle:set_position(newpos) end end local function turnleft() if not enable then return end local dir = localplayer:get_rotation() if not localplayer:is_in_vehicle() then localplayer:set_rotation(dir + vector3(0.25,0,0)) else vehicle=localplayer:get_current_vehicle() vehicle:set_rotation(dir + vector3(0.25,0,0)) end end local function turnright() if not enable then return end local dir = localplayer:get_rotation() if not localplayer:is_in_vehicle() then localplayer:set_rotation(dir + vector3(0.25 * -1,0,0)) else vehicle=localplayer:get_current_vehicle() vehicle:set_rotation(dir + vector3(0.25 * -1,0,0)) end end local function increasespeed() speed = speed + 1 end local function decreasespeed() speed = speed - 1 end local up_hotkey local down_hotkey local forward_hotkey local backward_hotkey local turnleft_hotkey local turnright_hotkey local increasespeed_hotkey local decreasespeed_hotkey local function NoClip(e) if not localplayer then return end if e then localplayer:set_freeze_momentum(true) localplayer:set_no_ragdoll(true) localplayer:set_config_flag(292,true) up_hotkey = menu.register_hotkey(go_up, up) down_hotkey = menu.register_hotkey(go_down, down) forward_hotkey = menu.register_hotkey(go_forward, forward) backward_hotkey = menu.register_hotkey(go_back, backward) turnleft_hotkey = menu.register_hotkey(turn_left, turnleft) turnright_hotkey = menu.register_hotkey(turn_right, turnright) increasespeed_hotkey = menu.register_hotkey(inc_speed, increasespeed) decreasespeed_hotkey = menu.register_hotkey(dec_speed, decreasespeed) else localplayer:set_freeze_momentum(false) localplayer:set_no_ragdoll(false) localplayer:set_config_flag(292,false) menu.remove_hotkey(up_hotkey) menu.remove_hotkey(down_hotkey) menu.remove_hotkey(forward_hotkey) menu.remove_hotkey(backward_hotkey) menu.remove_hotkey(turnleft_hotkey) menu.remove_hotkey(turnright_hotkey) menu.remove_hotkey(increasespeed_hotkey) menu.remove_hotkey(decreasespeed_hotkey) end end
local appMenu = modelMenu:add_submenu("Aparienzia")

local PedSelf = {}
PedSelf[joaat("mp_m_freemode_01")] = "Honvre"
PedSelf[joaat("mp_f_freemode_01")] = "Mujer"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local PedModelAnimal = {}
PedModelAnimal[joaat("a_c_cat_01")] = "Cat" 
PedModelAnimal[joaat("a_c_chimp")] = "Chimp Black"
PedModelAnimal[joaat("a_c_chop")] = "Chop"
PedModelAnimal[joaat("a_c_cow")] = "Cow"
PedModelAnimal[joaat("a_c_coyote")] = "Coyote"
PedModelAnimal[joaat("a_c_deer")] = "Deer"
PedModelAnimal[joaat("a_c_husky")] = "Husky"
PedModelAnimal[joaat("a_c_mtlion")] = "Mountian Lion"
PedModelAnimal[joaat("a_c_panther")] = "Panther"
PedModelAnimal[joaat("a_c_pig")] = "Pig"
PedModelAnimal[joaat("a_c_poodle")] = "Poodle"
PedModelAnimal[joaat("a_c_pug")] = "Pug"
PedModelAnimal[joaat("a_c_rabbit_01")] = "Rabbit"
PedModelAnimal[joaat("a_c_rat")] = "Rat"
PedModelAnimal[joaat("a_c_retriever")] = "Retriever"
PedModelAnimal[joaat("a_c_rhesus")] = "Rhesus Monkey"
PedModelAnimal[joaat("a_c_rottweiler")] = "Rottweiler"
PedModelAnimal[joaat("a_c_shepherd")] = "Shepherd"
PedModelAnimal[joaat("a_c_westy")] = "Westy"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local PedModelBird = {}
PedModelBird[joaat("a_c_seagull")] = "Seagull"
PedModelBird[joaat("a_c_pigeon")] = "Pigeon"
PedModelBird[joaat("a_c_crow")] = "Crow"
PedModelBird[joaat("a_c_hen")] = "Hen"
PedModelBird[joaat("a_c_cormorant")] = "Cormorant"
PedModelBird[joaat("a_c_chickenhawk")] = "Hawk Eagle"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local PedModelSeaAnimal = {}
PedModelSeaAnimal[joaat("a_c_dolphin")] = "Dolphin"
PedModelSeaAnimal[joaat("a_c_fish")] = "Fish"
PedModelSeaAnimal[joaat("a_c_stingray")] = "Sting Ray"
PedModelSeaAnimal[joaat("a_c_sharktiger")] = "Tiger Shark"
PedModelSeaAnimal[joaat("a_c_humpback")] = "Humpback"
PedModelSeaAnimal[joaat("a_c_sharkhammer")] = "Hammer Shark"
PedModelSeaAnimal[joaat("a_c_killerwhale")] = "Killer Whale"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local PedModel1 = {}
PedModel1[joaat("player_one")] = "Franklin"
PedModel1[joaat("player_two")] = "Trevor"
PedModel1[joaat("player_zero")] = "Michael"
PedModel1[joaat("a_f_m_beach_01")] = "a_f_m_beach_01"
PedModel1[joaat("a_f_m_bevhill")] = "a_f_m_bevhill"
PedModel1[joaat("a_f_m_bevhills_02")] = "Ponsonbys Cashier"
PedModel1[joaat("a_f_m_bodybuild_01")] =  "a_f_m_bodybuild_01"
PedModel1[joaat("a_f_m_business_02")] = "a_f_m_business_02"
PedModel1[joaat("a_f_m_downtown_01")] = "a_f_m_downtown_01"
PedModel1[joaat("a_f_m_eastsa_01")] = "a_f_m_eastsa_01"
PedModel1[joaat("a_f_m_eastsa_02")] = "a_f_m_eastsa_02"
PedModel1[joaat("a_f_m_fatbla_01")] = "a_f_m_fatbla_01"
PedModel1[joaat("a_f_m_fatcult_01")] = "a_f_m_fatcult_01"
PedModel1[joaat("a_f_m_fatwhite_01")] = "a_f_m_fatwhite_01"
PedModel1[joaat("a_f_m_ktown_01")] = "a_f_m_ktown_01"
PedModel1[joaat("a_f_m_ktown_02")] = "a_f_m_ktown_02"
PedModel1[joaat("a_f_m_prolhost_01")] = "a_f_m_prolhost_01"
PedModel1[joaat("a_f_m_salton_01")] = "a_f_m_salton_01"
PedModel1[joaat("a_f_m_skidrow_01")] = "a_f_m_skidrow_01"
PedModel1[joaat("a_f_m_soucent_01")] = "a_f_m_soucent_01"
PedModel1[joaat("a_f_m_soucent_02")] = "a_f_m_soucent_02"
PedModel1[joaat("a_f_m_soucentmc_01")] = "a_f_m_soucentmc_01"
PedModel1[joaat("a_f_m_tourist_01")] = "a_f_m_tourist_01"
PedModel1[joaat("a_f_m_tramp_01")] = "a_f_m_tramp_01"
PedModel1[joaat("a_f_m_trampbeac_01")] = "a_f_m_trampbeac_01"
PedModel1[joaat("a_f_o_genstreet_01")] = "a_f_o_genstreet_01"
PedModel1[joaat("a_f_o_indian_01")] = "a_f_o_indian_01"
PedModel1[joaat("a_f_o_ktown_01")] = "a_f_o_ktown_01"
PedModel1[joaat("a_f_o_salton_01")] = "a_f_o_salton_01"
PedModel1[joaat("a_f_o_soucent_01")] = "a_f_o_soucent_01"
PedModel1[joaat("a_f_o_soucent_02")] = "a_f_o_soucent_02"
PedModel1[joaat("a_f_y_beach_01")] = "a_f_y_beach_01"
PedModel1[joaat("a_f_y_beach_02")] = "a_f_y_beach_02"
PedModel1[joaat("a_f_y_bevhills_01")] = "a_f_y_bevhills_01"
PedModel1[joaat("a_f_y_bevhills_02")] = "a_f_y_bevhills_02"
PedModel1[joaat("a_f_y_bevhills_03")] = "a_f_y_bevhills_03"
PedModel1[joaat("a_f_y_bevhills_04")] = "a_f_y_bevhills_04"
PedModel1[joaat("a_f_y_bevhills_05")] = "a_f_y_bevhills_05"
PedModel1[joaat("a_f_y_business_01")] = "a_f_y_business_01"
PedModel1[joaat("a_f_y_business_02")] = "a_f_y_business_02"
PedModel1[joaat("a_f_y_business_03")] = "a_f_y_business_03"
PedModel1[joaat("a_f_y_business_04")] = "a_f_y_business_04"
PedModel1[joaat("a_f_y_clubcust_01")] = "a_f_y_clubcust_01"
PedModel1[joaat("a_f_y_clubcust_02")] = "a_f_y_clubcust_02"
PedModel1[joaat("a_f_y_clubcust_03")] = "a_f_y_clubcust_03"
PedModel1[joaat("a_f_y_clubcust_04")] = "a_f_y_clubcust_04"
PedModel1[joaat("a_f_y_eastsa_01")] = "a_f_y_eastsa_01"
PedModel1[joaat("a_f_y_eastsa_02")] = "a_f_y_eastsa_02"
PedModel1[joaat("a_f_y_eastsa_03")] = "a_f_y_eastsa_03"
PedModel1[joaat("a_f_y_epsilon_01")] = "a_f_y_epsilon_01"
PedModel1[joaat("a_f_y_femaleagent")] = "a_f_y_femaleagent"
PedModel1[joaat("a_f_y_fitness_01")] = "a_f_y_fitness_01"
PedModel1[joaat("a_f_y_fitness_02")] = "a_f_y_fitness_02"
PedModel1[joaat("a_f_y_gencaspat_01")] = "a_f_y_gencaspat_01"
PedModel1[joaat("a_f_y_genhot_01")] = "a_f_y_genhot_01"
PedModel1[joaat("a_f_y_golfer_01")] = "a_f_y_golfer_01"
PedModel1[joaat("a_f_y_hiker_01")] = "a_f_y_hiker_01"
PedModel1[joaat("a_f_y_hippie_01")] = "a_f_y_hippie_01"
PedModel1[joaat("a_f_y_hipster_01")] = "a_f_y_hipster_01"
PedModel1[joaat("a_f_y_hipster_02")] = "Binco Cashier"
PedModel1[joaat("a_f_y_hipster_03")] = "a_f_y_hipster_03"
PedModel1[joaat("a_f_y_hipster_04")] = "a_f_y_hipster_04"
PedModel1[joaat("a_f_y_indian_01")] = "a_f_y_indian_01"
PedModel1[joaat("a_f_y_juggalo_01")] = "a_f_y_juggalo_01"
PedModel1[joaat("a_f_y_runner_01")] = "a_f_y_runner_01"
PedModel1[joaat("a_f_y_rurmeth_01")] = "a_f_y_rurmeth_01"
PedModel1[joaat("a_f_y_scdressy_01")] = "a_f_y_scdressy_01"
PedModel1[joaat("a_f_y_skater_01")] = "a_f_y_skater_01"
PedModel1[joaat("a_f_y_smartcaspat_01")] = "a_f_y_smartcaspat_01"
PedModel1[joaat("a_f_y_soucent_01")] = "a_f_y_soucent_01"
PedModel1[joaat("a_f_y_soucent_02")] = "a_f_y_soucent_02"
PedModel1[joaat("a_f_y_soucent_03")] = "a_f_y_soucent_03"
PedModel1[joaat("a_f_y_tennis_01")] = "a_f_y_tennis_01"
PedModel1[joaat("a_f_y_topless_01")] = "a_f_y_topless_01"
PedModel1[joaat("a_f_y_tourist_01")] = "a_f_y_tourist_01"
PedModel1[joaat("a_f_y_tourist_02")] = "a_f_y_tourist_02"
PedModel1[joaat("a_f_y_vinewood_01")] = "a_f_y_vinewood_01"
PedModel1[joaat("a_f_y_vinewood_02")] = "a_f_y_vinewood_02"
PedModel1[joaat("a_f_y_vinewood_03")] = "a_f_y_vinewood_03"
PedModel1[joaat("a_f_y_vinewood_04")] = "a_f_y_vinewood_04"
PedModel1[joaat("a_f_y_yoga_01")] = "a_f_y_yoga_01"
PedModel1[joaat("a_m_m_acult_01")] = "a_m_m_acult_01"
PedModel1[joaat("a_m_m_afriamer_01")] = "a_m_m_afriamer_01"
PedModel1[joaat("a_m_m_beach_01")] = "a_m_m_beach_01"
PedModel1[joaat("a_m_m_beach_02")] = "a_m_m_beach_02"
PedModel1[joaat("a_m_m_bevhills_01")] = "a_m_m_bevhills_01"
PedModel1[joaat("a_m_m_bevhills_02")] = "a_m_m_bevhills_02"
PedModel1[joaat("a_m_m_business_01")] = "a_m_m_business_01"
PedModel1[joaat("a_m_m_eastsa_01")] = "a_m_m_eastsa_01"
PedModel1[joaat("a_m_m_eastsa_02")] = "a_m_m_eastsa_02"
PedModel1[joaat("a_m_m_farmer_01")] = "a_m_m_farmer_01"
PedModel1[joaat("a_m_m_fatlatin_01")] = "a_m_m_fatlatin_01"
PedModel1[joaat("a_m_m_genfat_01")] = "a_m_m_genfat_01"
PedModel1[joaat("a_m_m_genfat_02")] = "a_m_m_genfat_02"
PedModel1[joaat("a_m_m_golfer_01")] = "a_m_m_golfer_01"
PedModel1[joaat("a_m_m_hasjew_01")] = "a_m_m_hasjew_01"
PedModel1[joaat("a_m_m_hillbilly_01")] = "a_m_m_hillbilly_01"
PedModel1[joaat("a_m_m_hillbilly_02")] = "a_m_m_hillbilly_02"
PedModel1[joaat("a_m_m_indian_01")] = "a_m_m_indian_01"
PedModel1[joaat("a_m_m_ktown_01")] = "a_m_m_ktown_01"
PedModel1[joaat("a_m_m_malibu_01")] = "a_m_m_malibu_01"
PedModel1[joaat("a_m_m_mexcntry_01")] = "a_m_m_mexcntry_01"
PedModel1[joaat("a_m_m_mexlabor_01")] = "a_m_m_mexlabor_01"
PedModel1[joaat("a_m_m_mlcrisis_01")] = "a_m_m_mlcrisis_01"
PedModel1[joaat("a_m_m_og_boss_01")] = "a_m_m_og_boss_01"
PedModel1[joaat("a_m_m_paparazzi_01")] = "a_m_m_paparazzi_01"
PedModel1[joaat("a_m_m_polynesian_01")] = "a_m_m_polynesian_01"
PedModel1[joaat("a_m_m_prolhost_01")] = "a_m_m_prolhost_01"
PedModel1[joaat("a_m_m_rurmeth_01")] = "a_m_m_rurmeth_01"
PedModel1[joaat("a_m_m_salton_01")] = "a_m_m_salton_01"
PedModel1[joaat("a_m_m_salton_02")] = "a_m_m_salton_02"
PedModel1[joaat("a_m_m_salton_03")] = "a_m_m_salton_03"
PedModel1[joaat("a_m_m_salton_04")] = "a_m_m_salton_04"
PedModel1[joaat("a_m_m_skater_01")] = "a_m_m_skater_01"
PedModel1[joaat("a_m_m_skidrow_01")] = "a_m_m_skidrow_01"
PedModel1[joaat("a_m_m_socenlat_01")] = "a_m_m_socenlat_01"
PedModel1[joaat("a_m_m_soucent_01")] = "a_m_m_soucent_01"
PedModel1[joaat("a_m_m_soucent_02")] = "a_m_m_soucent_02"
PedModel1[joaat("a_m_m_soucent_03")] = "a_m_m_soucent_03"
PedModel1[joaat("a_m_m_soucent_04")] = "a_m_m_soucent_04"
PedModel1[joaat("a_m_m_stlat_02")] = "a_m_m_stlat_02"
PedModel1[joaat("a_m_m_tennis_01")] = "a_m_m_tennis_01"
PedModel1[joaat("a_m_m_tourist_01")] = "a_m_m_tourist_01"
PedModel1[joaat("a_m_m_tramp_01")] = "a_m_m_tramp_01"
PedModel1[joaat("a_m_m_trampbeac_01")] = "a_m_m_trampbeac_01"
PedModel1[joaat("a_m_m_tranvest_01")] = "a_m_m_tranvest_01"
PedModel1[joaat("a_m_m_tranvest_02")] = "a_m_m_tranvest_02"
PedModel1[joaat("a_m_o_acult_01")] = "a_m_o_acult_01"
PedModel1[joaat("a_m_o_acult_02")] = "a_m_o_acult_02"
PedModel1[joaat("a_m_o_beach_01")] = "a_m_o_beach_01"
PedModel1[joaat("a_m_o_beach_02")] = "a_m_o_beach_02"
PedModel1[joaat("a_m_o_genstreet_01")] = "a_m_o_genstreet_01"
PedModel1[joaat("a_m_o_ktown_01")] = "a_m_o_ktown_01"
PedModel1[joaat("a_m_o_salton_01")] = "a_m_o_salton_01"
PedModel1[joaat("a_m_o_soucent_01")] = "a_m_o_soucent_01"
PedModel1[joaat("a_m_o_soucent_02")] = "a_m_o_soucent_02"
PedModel1[joaat("a_m_o_soucent_03")] = "a_m_o_soucent_03"
PedModel1[joaat("a_m_o_tramp_01")] = "a_m_o_tramp_01"
PedModel1[joaat("a_m_y_acult_01")] = "a_m_y_acult_01"
PedModel1[joaat("a_m_y_acult_02")] = "a_m_y_acult_02"
PedModel1[joaat("a_m_y_beach_01")] = "a_m_y_beach_01"
PedModel1[joaat("a_m_y_beach_02")] = "a_m_y_beach_02"
PedModel1[joaat("a_m_y_beach_03")] = "a_m_y_beach_03"
PedModel1[joaat("a_m_y_beach_04")] = "a_m_y_beach_04"
PedModel1[joaat("a_m_y_beachvesp_01")] = "a_m_y_beachvesp_01"
PedModel1[joaat("a_m_y_beachvesp_02")] = "a_m_y_beachvesp_02"
PedModel1[joaat("a_m_y_bevhills_01")] = "a_m_y_bevhills_01"
PedModel1[joaat("a_m_y_bevhills_02")] = "a_m_y_bevhills_02"
PedModel1[joaat("a_m_y_breakdance_01")] = "a_m_y_breakdance_01"
PedModel1[joaat("a_m_y_busicas_01")] = "a_m_y_busicas_01"
PedModel1[joaat("a_m_y_business_01")] = "a_m_y_business_01"
PedModel1[joaat("a_m_y_business_02")] = "a_m_y_business_02"
PedModel1[joaat("a_m_y_business_03")] = "a_m_y_business_03"
PedModel1[joaat("a_m_y_clubcust_01")] = "a_m_y_clubcust_01"
PedModel1[joaat("a_m_y_clubcust_02")] = "a_m_y_clubcust_02"
PedModel1[joaat("a_m_y_clubcust_03")] = "a_m_y_clubcust_03"
PedModel1[joaat("a_m_y_clubcust_04")] = "a_m_y_clubcust_04"
PedModel1[joaat("a_m_y_cyclist_01")] = "a_m_y_cyclist_01"
PedModel1[joaat("a_m_y_dhill_01")] = "a_m_y_dhill_01"
PedModel1[joaat("a_m_y_downtown_01")] = "a_m_y_downtown_01"
PedModel1[joaat("a_m_y_eastsa_01")] = "a_m_y_eastsa_01"
PedModel1[joaat("a_m_y_eastsa_02")] = "a_m_y_eastsa_02"
PedModel1[joaat("a_m_y_epsilon_01")] = "a_m_y_epsilon_01"
PedModel1[joaat("a_m_y_epsilon_02")] = "a_m_y_epsilon_02"
PedModel1[joaat("a_m_y_gay_01")] = "a_m_y_gay_01"
PedModel1[joaat("a_m_y_gay_02")] = "a_m_y_gay_02"
PedModel1[joaat("a_m_y_gencaspat_01")] = "a_m_y_gencaspat_01"
PedModel1[joaat("a_m_y_genstreet_01")] = "a_m_y_genstreet_01"
PedModel1[joaat("a_m_y_genstreet_02")] = "a_m_y_genstreet_02"
PedModel1[joaat("a_m_y_golfer_01")] = "a_m_y_golfer_01"
PedModel1[joaat("a_m_y_hasjew_01")] = "a_m_y_hasjew_01"
PedModel1[joaat("a_m_y_hiker_01")] = "a_m_y_hiker_01"
PedModel1[joaat("a_m_y_hippy_01")] = "a_m_y_hippy_01"
PedModel1[joaat("a_m_y_hipster_01")] = "a_m_y_hipster_01"
PedModel1[joaat("a_m_y_hipster_02")] = "a_m_y_hipster_02"
PedModel1[joaat("a_m_y_hipster_03")] = "a_m_y_hipster_03"
PedModel1[joaat("a_m_y_indian_01")] = "a_m_y_indian_01"
PedModel1[joaat("a_m_y_jetski_01")] = "a_m_y_jetski_01"
PedModel1[joaat("a_m_y_juggalo_01")] = "a_m_y_juggalo_01"
PedModel1[joaat("a_m_y_ktown_01")] = "a_m_y_ktown_01"
PedModel1[joaat("a_m_y_ktown_02")] = "a_m_y_ktown_02"
PedModel1[joaat("a_m_y_latino_01")] = "a_m_y_latino_01"
PedModel1[joaat("a_m_y_methhead_01")] = "a_m_y_methhead_01"
PedModel1[joaat("a_m_y_mexthug_01")] = "a_m_y_mexthug_01"
PedModel1[joaat("a_m_y_motox_01")] = "a_m_y_motox_01"
PedModel1[joaat("a_m_y_motox_02")] = "a_m_y_motox_02"
PedModel1[joaat("a_m_y_musclbeac_01")] = "a_m_y_musclbeac_01"
PedModel1[joaat("a_m_y_musclbeac_02")] = "a_m_y_musclbeac_02"
PedModel1[joaat("a_m_y_polynesian_01")] = "a_m_y_polynesian_01"
PedModel1[joaat("a_m_y_roadcyc_01")] = "a_m_y_roadcyc_01"
PedModel1[joaat("a_m_y_runner_01")] = "a_m_y_runner_01"
PedModel1[joaat("a_m_y_runner_02")] = "a_m_y_runner_02"
PedModel1[joaat("a_m_y_salton_01")] = "a_m_y_salton_01"
PedModel1[joaat("a_m_y_skater_01")] = "a_m_y_skater_01"
PedModel1[joaat("a_m_y_skater_02")] = "a_m_y_skater_02"
PedModel1[joaat("a_m_y_smartcaspat_01")] = "a_m_y_smartcaspat_01"
PedModel1[joaat("a_m_y_soucent_01")] = "a_m_y_soucent_01"
PedModel1[joaat("a_m_y_soucent_02")] = "a_m_y_soucent_02"
PedModel1[joaat("a_m_y_soucent_03")] = "a_m_y_soucent_03"
PedModel1[joaat("a_m_y_soucent_04")] = "a_m_y_soucent_04"
PedModel1[joaat("a_m_y_stbla_01")] = "a_m_y_stbla_01"
PedModel1[joaat("a_m_y_stbla_02")] = "a_m_y_stbla_02"
PedModel1[joaat("a_m_y_stlat_01")] = "a_m_y_stlat_01"
PedModel1[joaat("a_m_y_stwhi_01")] = "a_m_y_stwhi_01"
PedModel1[joaat("a_m_y_stwhi_02")] = "a_m_y_stwhi_02"
PedModel1[joaat("a_m_y_sunbathe_01")] = "a_m_y_sunbathe_01"
PedModel1[joaat("a_m_y_surfer_01")] = "a_m_y_surfer_01"
PedModel1[joaat("a_m_y_vindouche_01")] = "a_m_y_vindouche_01"
PedModel1[joaat("a_m_y_vinewood_01")] = "a_m_y_vinewood_01"
PedModel1[joaat("a_m_y_vinewood_02")] = "a_m_y_vinewood_02"
PedModel1[joaat("a_m_y_vinewood_03")] = "a_m_y_vinewood_03"
PedModel1[joaat("a_m_y_vinewood_04")] = "a_m_y_vinewood_04"
PedModel1[joaat("a_m_y_yoga_01")] = "a_m_y_yoga_01"
PedModel1[joaat("cs_amandatownley")] = "Amanda"
PedModel1[joaat("cs_andreas")] = "cs_andreas"
PedModel1[joaat("cs_ashley")] = "cs_ashley"
PedModel1[joaat("cs_bankman")] = "cs_bankman"
PedModel1[joaat("cs_barry")] = "cs_barry"
PedModel1[joaat("cs_beverly")] = "cs_beverly"
PedModel1[joaat("cs_brad")] = "cs_brad"
PedModel1[joaat("cs_bradcadaver")] = "cs_bradcadaver"
PedModel1[joaat("cs_carbuyer")] = "cs_carbuyer"
PedModel1[joaat("cs_casey")] = "cs_casey"
PedModel1[joaat("cs_chengsr")] = "cs_chengsr"
PedModel1[joaat("cs_chrisformage")] = "cs_chrisformage"
PedModel1[joaat("cs_clay")] = "cs_clay"
PedModel1[joaat("cs_dale")] = "cs_dale"
PedModel1[joaat("Dave Norton")] = "cs_davenorton"
PedModel1[joaat("cs_debra")] = "cs_debra"
PedModel1[joaat("cs_denise")] = "cs_denise"
PedModel1[joaat("cs_devin")] = "cs_devin"
PedModel1[joaat("cs_dom")] = "cs_dom"
PedModel1[joaat("cs_dreyfuss")] = "cs_dreyfuss"
PedModel1[joaat("cs_drfriedlander")] = "Isiah Friedlander"
PedModel1[joaat("cs_fabien")] = "cs_fabien"
PedModel1[joaat("cs_fbisuit_01")] = "cs_fbisuit_01"
PedModel1[joaat("cs_floyd")] = "cs_floyd"
PedModel1[joaat("cs_guadalope")] = "cs_guadalope"
PedModel1[joaat("cs_gurk")] = "cs_gurk"
PedModel1[joaat("cs_hunter")] = "cs_hunter"
PedModel1[joaat("cs_janet")] = "cs_janet"
PedModel1[joaat("cs_jewelass")] = "cs_jewelass"
PedModel1[joaat("cs_jimmyboston")] = "cs_jimmyboston"
PedModel1[joaat("cs_jimmydisanto")] = "cs_jimmydisanto"
PedModel1[joaat("cs_jimmydisanto2")] = "cs_jimmydisanto2"
PedModel1[joaat("cs_joeminuteman")] = "cs_joeminuteman"
PedModel1[joaat("cs_johnnyklebitz")] = "cs_johnnyklebitz"
PedModel1[joaat("cs_josef")] = "cs_josef"
PedModel1[joaat("cs_josh")] = "cs_josh"
PedModel1[joaat("cs_karen_daniels")] = "cs_karen_daniels"
PedModel1[joaat("cs_lamardavis")] = "cs_lamardavis"
PedModel1[joaat("cs_lazlow")] = "Lazlow 1"
PedModel1[joaat("cs_lazlow_2")] = "cs_lazlow_2"
PedModel1[joaat("cs_lestercrest")] = "cs_lestercrest"
PedModel1[joaat("cs_lestercrest_2")] = "cs_lestercrest_2"
PedModel1[joaat("cs_lestercrest_3")] = "cs_lestercrest_3"
PedModel1[joaat("cs_lifeinvad_01")] = "cs_lifeinvad_01"
PedModel1[joaat("cs_magenta")] = "cs_magenta"
PedModel1[joaat("cs_manuel")] = "cs_manuel"
PedModel1[joaat("cs_marnie")] = "cs_marnie"
PedModel1[joaat("cs_martinmadrazo")] = "cs_martinmadrazo"
PedModel1[joaat("cs_maryann")] = "cs_maryann"
PedModel1[joaat("cs_michelle")] = "cs_michelle"
PedModel1[joaat("cs_milton")] = "cs_milton"
PedModel1[joaat("cs_molly")] = "cs_molly"
PedModel1[joaat("cs_movpremf_01")] = "cs_movpremf_01"
PedModel1[joaat("cs_movpremmale")] = "cs_movpremmale"
PedModel1[joaat("cs_mrk")] = "cs_mrk"
PedModel1[joaat("cs_mrs_thornhill")] = "cs_mrs_thornhill"
PedModel1[joaat("cs_mrsphillips")] = "cs_mrsphillips"
PedModel1[joaat("cs_natalia")] = "cs_natalia"
PedModel1[joaat("cs_nervousron")] = "cs_nervousron"
PedModel1[joaat("cs_nigel")] = "cs_nigel"
PedModel1[joaat("cs_old_man1a")] = "cs_old_man1a"
PedModel1[joaat("cs_old_man2")] = "cs_old_man2"
PedModel1[joaat("cs_omega")] = "cs_omega"
PedModel1[joaat("cs_orleans")] = "cs_orleans"
PedModel1[joaat("cs_paper")] = "cs_paper"
PedModel1[joaat("cs_patricia")] = "cs_patricia"
PedModel1[joaat("cs_patricia_02")] = "cs_patricia_02"
PedModel1[joaat("cs_priest")] = "cs_priest"
PedModel1[joaat("cs_prolsec_02")] = "cs_prolsec_02"
PedModel1[joaat("cs_russiandrunk")] = "cs_russiandrunk"
PedModel1[joaat("cs_siemonyetarian")] = "cs_siemonyetarian"
PedModel1[joaat("cs_solomon")] = "cs_solomon"
PedModel1[joaat("cs_stevehains")] = "Steven Haines"
PedModel1[joaat("cs_stretch")] = "Stretch"
PedModel1[joaat("cs_tanisha")] = "cs_tanisha"
PedModel1[joaat("cs_taocheng")] = "Tao Cheng"
PedModel1[joaat("cs_taocheng2")] = "cs_taocheng2"
PedModel1[joaat("cs_taostranslator")] = "cs_taostranslator"
PedModel1[joaat("cs_taostranslator2")] = "cs_taostranslator2"
PedModel1[joaat("cs_tenniscoach")] = "cs_tenniscoach"
PedModel1[joaat("cs_terry")] = "cs_terry"
PedModel1[joaat("cs_tom")] = "cs_tom"
PedModel1[joaat("cs_tomepsilon")] = "cs_tomepsilon"
PedModel1[joaat("cs_tracydisanto")] = "cs_tracydisanto"
PedModel1[joaat("cs_wade")] = "cs_wade"
PedModel1[joaat("cs_zimbor")] = "cs_zimbor"
PedModel1[joaat("csb_abigail")] = "Abigail"
PedModel1[joaat("csb_agatha")] = "csb_agatha"
PedModel1[joaat("csb_agent")] = "csb_agent"
PedModel1[joaat("csb_alan")] = "csb_alan"
PedModel1[joaat("csb_anita")] = "csb_anita"
PedModel1[joaat("csb_anton")] = "csb_anton"
PedModel1[joaat("csb_ary")] = "csb_ary"
PedModel1[joaat("csb_avery")] = "csb_avery"
PedModel1[joaat("csb_avon")] = "csb_avon"
PedModel1[joaat("csb_ballasog")] = "csb_ballasog"
PedModel1[joaat("csb_bogdan")] = "csb_bogdan"
PedModel1[joaat("csb_bride")] = "csb_bride"
PedModel1[joaat("csb_brucie2")] = "csb_brucie2"
PedModel1[joaat("csb_bryony")] = "csb_bryony"
PedModel1[joaat("csb_burgerdrug")] = "csb_burgerdrug"
PedModel1[joaat("csb_car3guy1")] = "csb_car3guy1"
PedModel1[joaat("csb_car3guy2")] = "csb_car3guy2"
PedModel1[joaat("csb_celeb_01")] = "csb_celeb_01"
PedModel1[joaat("csb_chef")] = "csb_chef"
PedModel1[joaat("csb_chef2")] = "csb_chef2"
PedModel1[joaat("csb_chin_goon")] = "csb_chin_goon"
PedModel1[joaat("csb_cletus")] = "csb_cletus"
PedModel1[joaat("csb_cop")] = "csb_cop"
PedModel1[joaat("csb_customer")] = "csb_customer"
PedModel1[joaat("csb_denise_friend")] = "csb_denise_friend"
PedModel1[joaat("csb_dix")] = "csb_dix"
PedModel1[joaat("csb_djblamadon")] = "csb_djblamadon"
PedModel1[joaat("csb_englishdave")] = "English Dave"
PedModel1[joaat("csb_englishdave_02")] = "csb_englishdave_02"
PedModel1[joaat("csb_fos_rep")] = "csb_fos_rep"
PedModel1[joaat("csb_g")] = "Gerald 2"
PedModel1[joaat("csb_georginacheng")] = "csb_georginacheng"
PedModel1[joaat("csb_groom")] = "csb_groom"
PedModel1[joaat("csb_grove_str_dlr")] = "csb_grove_str_dlr"
PedModel1[joaat("csb_gustavo")] = "Gustavo"
PedModel1[joaat("csb_hao")] = "Hao"
PedModel1[joaat("csb_helmsmanpavel")] = "Pavel"
PedModel1[joaat("csb_huang")] = "csb_huang"
PedModel1[joaat("csb_hugh")] = "csb_hugh"
PedModel1[joaat("csb_imran")] = "csb_imran"
PedModel1[joaat("csb_isldj_00")] = "csb_isldj_00"
PedModel1[joaat("csb_isldj_01")] = "csb_isldj_01"
PedModel1[joaat("csb_isldj_02")] = "csb_isldj_02"
PedModel1[joaat("csb_isldj_03")] = "csb_isldj_03"
PedModel1[joaat("csb_isldj_04")] = "csb_isldj_04"
PedModel1[joaat("csb_jackhowitzer")] = "csb_jackhowitzer"
PedModel1[joaat("csb_janitor")] = "csb_janitor"
PedModel1[joaat("csb_jio")] = "Jimmy Iovine"
PedModel1[joaat("csb_juanstrickler")] = "csb_juanstrickler"
PedModel1[joaat("csb_maude")] = "csb_maude"
PedModel1[joaat("csb_miguelmadrazo")] = "csb_miguelmadrazo"
PedModel1[joaat("csb_mjo")] = "DJ Pooh"
PedModel1[joaat("csb_money")] = "Avi Schwartzman"
PedModel1[joaat("csb_mp_agent14")] = "csb_mp_agent14"
PedModel1[joaat("csb_mrs_r")] = "Mrs Rackman"
PedModel1[joaat("csb_mweather")] = "csb_mweather"
PedModel1[joaat("csb_ortega")] = "csb_ortega"
PedModel1[joaat("csb_oscar")] = "csb_oscar"
PedModel1[joaat("csb_paige")] = "csb_paige"
PedModel1[joaat("csb_popov")] = "csb_popov"
PedModel1[joaat("csb_porndudes")] = "csb_porndudes"
PedModel1[joaat("csb_prologuedriver")] = "csb_prologuedriver"
PedModel1[joaat("csb_prolsec")] = "csb_prolsec"
PedModel1[joaat("csb_ramp_gang")] = "csb_ramp_gang"
PedModel1[joaat("csb_ramp_hic")] = "csb_ramp_hic"
PedModel1[joaat("csb_ramp_hipster")] = "csb_ramp_hipster"
PedModel1[joaat("csb_ramp_marine")] = "csb_ramp_marine"
PedModel1[joaat("csb_ramp_mex")] = "csb_ramp_mex"
PedModel1[joaat("csb_rashcosvki")] = "csb_rashcosvki"
PedModel1[joaat("csb_reporter")] = "csb_reporter"
PedModel1[joaat("csb_roccopelosi")] = "csb_roccopelosi"
PedModel1[joaat("csb_screen_writer")] = "csb_screen_writer"
PedModel1[joaat("csb_sol")] = "csb_sol"
PedModel1[joaat("csb_sss")] = "csb_sss"
PedModel1[joaat("csb_stripper_01")] = "csb_stripper_01"
PedModel1[joaat("csb_stripper_02")] = "csb_stripper_02"
PedModel1[joaat("csb_talcc")] = "csb_talcc"
PedModel1[joaat("csb_talmm")] = "csb_talmm"
PedModel1[joaat("csb_thornton")] = "csb_thornton"
PedModel1[joaat("csb_tomcasino")] = "csb_tomcasino"
PedModel1[joaat("csb_tonya")] = "csb_tonya"
PedModel1[joaat("csb_tonyprince")] = "csb_tonyprince"
PedModel1[joaat("csb_trafficwarden")] = "csb_trafficwarden"
PedModel1[joaat("csb_undercover")] = "csb_undercover"
PedModel1[joaat("csb_vagspeak")] = "csb_vagspeak"
PedModel1[joaat("csb_vincent")] = "csb_vincent"
PedModel1[joaat("csb_vincent_2")] = "Vincent 2"
PedModel1[joaat("csb_wendy")] = "csb_wendy"
PedModel1[joaat("g_f_importexport_01")] = "g_f_importexport_01"
PedModel1[joaat("g_f_y_ballas_01")] = "g_f_y_ballas_01"
PedModel1[joaat("g_f_y_families_01")] = "g_f_y_families_01"
PedModel1[joaat("g_f_y_lost_01")] = "g_f_y_lost_01"
PedModel1[joaat("g_f_y_vagos_01")] = "g_f_y_vagos_01"
PedModel1[joaat("g_m_importexport_01")] = "g_m_importexport_01"
PedModel1[joaat("g_m_m_armboss_01")] = "g_m_m_armboss_01"
PedModel1[joaat("g_m_m_armgoon_01")] = "g_m_m_armgoon_01"
PedModel1[joaat("g_m_m_armlieut_01")] = "g_m_m_armlieut_01"
PedModel1[joaat("g_m_m_cartelguards_01")] = "g_m_m_cartelguards_01"
PedModel1[joaat("g_m_m_cartelguards_02")] = "g_m_m_cartelguards_02"
PedModel1[joaat("g_m_m_casrn_01")] = "g_m_m_casrn_01"
PedModel1[joaat("g_m_m_chemwork_01")] = "g_m_m_chemwork_01"
PedModel1[joaat("g_m_m_chiboss_01")] = "g_m_m_chiboss_01"
PedModel1[joaat("g_m_m_chicold_01")] = "g_m_m_chicold_01"
PedModel1[joaat("g_m_m_chigoon_01")] = "g_m_m_chigoon_01"
PedModel1[joaat("g_m_m_chigoon_02")] = "g_m_m_chigoon_02"
PedModel1[joaat("g_m_m_korboss_01")] = "g_m_m_korboss_01"
PedModel1[joaat("g_m_m_mexboss_01")] = "g_m_m_mexboss_01"
PedModel1[joaat("g_m_m_mexboss_02")] = "g_m_m_mexboss_02"
PedModel1[joaat("g_m_y_armgoon_02")] = "g_m_y_armgoon_02"
PedModel1[joaat("g_m_y_azteca_01")] = "g_m_y_azteca_01"
PedModel1[joaat("g_m_y_ballaeast_01")] = "g_m_y_ballaeast_01"
PedModel1[joaat("g_m_y_ballaorig_01")] = "g_m_y_ballaorig_01"
PedModel1[joaat("g_m_y_ballasout_01")] = "g_m_y_ballasout_01"
PedModel1[joaat("g_m_y_famca_01")] = "g_m_y_famca_01"
PedModel1[joaat("g_m_y_famdnf_01")] = "g_m_y_famdnf_01"
PedModel1[joaat("g_m_y_famfor_01")] = "g_m_y_famfor_01"
PedModel1[joaat("g_m_y_korean_01")] = "g_m_y_korean_01"
PedModel1[joaat("g_m_y_korean_02")] = "g_m_y_korean_02"
PedModel1[joaat("g_m_y_korlieut_01")] = "g_m_y_korlieut_01"
PedModel1[joaat("g_m_y_lost_01")] = "g_m_y_lost_01"
PedModel1[joaat("g_m_y_lost_02")] = "g_m_y_lost_02"
PedModel1[joaat("g_m_y_lost_03")] = "g_m_y_lost_03"
PedModel1[joaat("g_m_y_mexgang_01")] = "g_m_y_mexgang_01"
PedModel1[joaat("g_m_y_mexgoon_01")] = "g_m_y_mexgoon_01"
PedModel1[joaat("g_m_y_mexgoon_02")] = "g_m_y_mexgoon_02"
PedModel1[joaat("g_m_y_mexgoon_03")] = "g_m_y_mexgoon_03"
PedModel1[joaat("g_m_y_pologoon_01")] = "g_m_y_pologoon_01"
PedModel1[joaat("g_m_y_pologoon_02")] = "g_m_y_pologoon_02"
PedModel1[joaat("g_m_y_salvaboss_01")] = "g_m_y_salvaboss_01"
PedModel1[joaat("g_m_y_salvagoon_01")] = "g_m_y_salvagoon_01"
PedModel1[joaat("g_m_y_salvagoon_02")] = "g_m_y_salvagoon_02"
PedModel1[joaat("g_m_y_salvagoon_03")] = "g_m_y_salvagoon_03"
PedModel1[joaat("g_m_y_strpunk_01")] = "g_m_y_strpunk_01"
PedModel1[joaat("g_m_y_strpunk_02")] = "g_m_y_strpunk_02"
PedModel1[joaat("hc_driver")] = "hc_driver"
PedModel1[joaat("hc_gunman")] = "hc_gunman"
PedModel1[joaat("hc_hacker")] = "hc_hacker"
PedModel1[joaat("ig_abigail")] = "Abigail"
PedModel1[joaat("ig_agatha")] = "Agatha"
PedModel1[joaat("ig_agent")] = "Agent"
PedModel1[joaat("ig_amandatownley")] = "Amanda 1"
PedModel1[joaat("ig_andreas")] = "Andreas"
PedModel1[joaat("ig_ary")] = "Ary"
PedModel1[joaat("ig_ashley")] = "Ashley"
PedModel1[joaat("ig_avery")] = "Avery"
PedModel1[joaat("ig_avon")] = "Avon Hertz"
PedModel1[joaat("ig_ballasog")] = "Ballas Chilli D"
PedModel1[joaat("ig_bankman")] = "Bankman"
PedModel1[joaat("ig_barry")] = "Barry"
PedModel1[joaat("ig_benny")] = "Benny"
PedModel1[joaat("ig_bestmen")] = "Bestmen"
PedModel1[joaat("ig_beverly")] = "Beverly"
PedModel1[joaat("ig_brad")] = "Brad"
PedModel1[joaat("ig_bride")] = "ig_bride"
PedModel1[joaat("ig_brucie2")] = "Brucie 2"
PedModel1[joaat("ig_car3guy1")] = "ig_car3guy1"
PedModel1[joaat("ig_car3guy2")] = "ig_car3guy2"
PedModel1[joaat("ig_casey")] = "Casey"
PedModel1[joaat("ig_celeb_01")] = "ig_celeb_01"
PedModel1[joaat("ig_chef")] = "ig_chef"
PedModel1[joaat("ig_chef2")] = "ig_chef2"
PedModel1[joaat("ig_chengsr")] = "Cheng Sr"
PedModel1[joaat("ig_chrisformage")] = "Cris Formage"
PedModel1[joaat("ig_clay")] = "Clay Simons"
PedModel1[joaat("ig_claypain")] = "Claypain"
PedModel1[joaat("ig_cletus")] = "Cletus"
PedModel1[joaat("ig_dale")] = "Dale"
PedModel1[joaat("ig_davenorton")] = "Dave Norton"
PedModel1[joaat("ig_denise")] = "Denise"
PedModel1[joaat("ig_devin")] = "Devin"
PedModel1[joaat("ig_dix")] = "dix"
PedModel1[joaat("ig_djblamadon")] = "djblamadon"
PedModel1[joaat("ig_djblamrupert")] = "Rupert Murray"
PedModel1[joaat("ig_djblamryanh")] = "djblamryanh"
PedModel1[joaat("ig_djblamryans")] = "djblamryans"
PedModel1[joaat("ig_djdixmanager")] = "djdixmanager"
PedModel1[joaat("ig_djgeneric_01")] = "djgeneric_01"
PedModel1[joaat("ig_djsolfotios")] = "djsolfotios"
PedModel1[joaat("ig_djsoljakob")] = "Jakob Grunert"
PedModel1[joaat("ig_djsolmanager")] = "djsolmanager"
PedModel1[joaat("ig_djsolmike")] = "djsolmike"
PedModel1[joaat("ig_djsolrobt")] = "djsolrobt"
PedModel1[joaat("ig_djtalaurelia")] = "djtalaurelia"
PedModel1[joaat("ig_djtalignazio")] = "djtalignazio"
PedModel1[joaat("ig_dom")] = "Dom"
PedModel1[joaat("ig_dreyfuss")] = "dreyfuss"
PedModel1[joaat("ig_drfriedlander")] = "drfriedlander"
PedModel1[joaat("ig_englishdave")] = "englishdave"
PedModel1[joaat("ig_englishdave_02")] = "englishdave_02"
PedModel1[joaat("ig_fabien")] = "fabien"
PedModel1[joaat("ig_fbisuit_01")] = "fbisuit_01"
PedModel1[joaat("ig_floyd")] = "floyd"
PedModel1[joaat("ig_g")] = "Gerald"
PedModel1[joaat("ig_georginacheng")] = "georginacheng"
PedModel1[joaat("ig_groom")] = "groom"
PedModel1[joaat("ig_gustavo")] = "gustavo"
PedModel1[joaat("ig_hao")] = "hao"
PedModel1[joaat("ig_helmsmanpavel")] = "helmsmanpavel"
PedModel1[joaat("ig_huang")] = "huang"
PedModel1[joaat("ig_hunter")] = "hunter"
PedModel1[joaat("ig_isldj_00")] = "isldj_00"
PedModel1[joaat("ig_isldj_01")] = "isldj_01"
PedModel1[joaat("ig_isldj_02")] = "isldj_02"
PedModel1[joaat("ig_isldj_03")] = "isldj_03"
PedModel1[joaat("ig_isldj_04")] = "Moodyman"
PedModel1[joaat("ig_isldj_04_d_01")] = "isldj_04_d_01"
PedModel1[joaat("ig_isldj_04_d_02")] = "isldj_04_d_02"
PedModel1[joaat("ig_isldj_04_e_01")] = "isldj_04_e_01"
PedModel1[joaat("ig_jackie")] = "jackie"
PedModel1[joaat("ig_janet")] = "janet"
PedModel1[joaat("ig_jay_norris")] = "jay_norris"
PedModel1[joaat("ig_jewelass")] = "jewelass"
PedModel1[joaat("ig_jimmyboston")] = "jimmyboston"
PedModel1[joaat("ig_jimmyboston_02")] = "jimmyboston_02"
PedModel1[joaat("ig_jimmydisanto")] = "jimmydisanto"
PedModel1[joaat("ig_jimmydisanto2")] = "Jimmy 2"
PedModel1[joaat("ig_jio")] = "jio"
PedModel1[joaat("ig_joeminuteman")] = "joeminuteman"
PedModel1[joaat("ig_johnnyklebitz")] = "johnnyklebitz"
PedModel1[joaat("ig_josef")] = "josef"
PedModel1[joaat("ig_josh")] = "josh"
PedModel1[joaat("ig_juanstrickler")] = "juanstrickler"
PedModel1[joaat("ig_karen_daniels")] = "karen_daniels"
PedModel1[joaat("ig_kaylee")] = "kaylee"
PedModel1[joaat("ig_kerrymcintosh")] = "kerrymcintosh"
PedModel1[joaat("ig_kerrymcintosh_02")] = "kerrymcintosh_02"
PedModel1[joaat("ig_lacey_jones_02")] = "lacey_jones_02"
PedModel1[joaat("ig_lamardavis")] = "lamardavis"
PedModel1[joaat("ig_lazlow")] = "lazlow"
PedModel1[joaat("ig_lazlow_2")] = "Lazlow 2"
PedModel1[joaat("ig_lestercrest")] = "lestercrest"
PedModel1[joaat("ig_lestercrest_2")] = "lestercrest_2"
PedModel1[joaat("ig_lestercrest_3")] = "lestercrest_3"
PedModel1[joaat("ig_lifeinvad_01")] = "lifeinvad_01"
PedModel1[joaat("ig_lifeinvad_02")] = "lifeinvad_02"
PedModel1[joaat("ig_magenta")] = "magenta"
PedModel1[joaat("ig_malc")] = "malc"
PedModel1[joaat("ig_manuel")] = "manuel"
PedModel1[joaat("ig_marnie")] = "marnie"
PedModel1[joaat("ig_maryann")] = "Mary Ann"
PedModel1[joaat("ig_maude")] = "Maude"
PedModel1[joaat("ig_michelle")] = "Michelle"
PedModel1[joaat("ig_miguelmadrazo")] = "Miguel Madrazo"
PedModel1[joaat("ig_milton")] = "Milton"
PedModel1[joaat("ig_mjo")] = "DJ Pooh"
PedModel1[joaat("ig_molly")] = "molly"
PedModel1[joaat("ig_money")] = "Avi Schwartzman 1"
PedModel1[joaat("ig_mp_agent14")] = "mp_agent14"
PedModel1[joaat("ig_mrk")] = "mrk"
PedModel1[joaat("ig_mrs_thornhill")] = "mrs_thornhill"
PedModel1[joaat("ig_mrsphillips")] = "Mrs Phillips"
PedModel1[joaat("ig_natalia")] = "natalia"
PedModel1[joaat("ig_nervousron")] = "nervousron"
PedModel1[joaat("ig_nigel")] = "nigel"
PedModel1[joaat("ig_old_man1a")] = "old_man1a"
PedModel1[joaat("ig_old_man2")] = "old_man2"
PedModel1[joaat("ig_oldrichguy")] = "oldrichguy"
PedModel1[joaat("ig_omega")] = "omega"
PedModel1[joaat("ig_oneil")] = "oneil"
PedModel1[joaat("ig_orleans")] = "orleans"
PedModel1[joaat("ig_ortega")] = "ortega"
PedModel1[joaat("ig_paige")] = "paige"
PedModel1[joaat("ig_paper")] = "paper"
PedModel1[joaat("ig_patricia")] = "patricia"
PedModel1[joaat("ig_patricia_02")] = "patricia_02"
PedModel1[joaat("ig_pilot")] = "pilot"
PedModel1[joaat("ig_popov")] = "popov"
PedModel1[joaat("ig_priest")] = "priest"
PedModel1[joaat("ig_prolsec_02")] = "prolsec_02"
PedModel1[joaat("ig_ramp_gang")] = "ramp_gang"
PedModel1[joaat("ig_ramp_hic")] = "ramp_hic"
PedModel1[joaat("ig_ramp_hipster")] = "ramp_hipster"
PedModel1[joaat("ig_ramp_mex")] = "ramp_mex"
PedModel1[joaat("ig_rashcosvki")] = "Rashcosvki"
PedModel1[joaat("ig_roccopelosi")] = "roccopelosi"
PedModel1[joaat("ig_russiandrunk")] = "russiandrunk"
PedModel1[joaat("ig_sacha")] = "sacha"
PedModel1[joaat("ig_screen_writer")] = "screen_writer"
PedModel1[joaat("ig_siemonyetarian")] = "siemonyetarian"
PedModel1[joaat("ig_sol")] =	 "sol"
PedModel1[joaat("ig_solomon")] = "Solomon"
PedModel1[joaat("ig_sss")] =	 "Scott Storch"
PedModel1[joaat("ig_stevehains")] = "Steven Haines"
PedModel1[joaat("ig_stretch")] = "Harold 'Stretch' Joseph"
PedModel1[joaat("ig_talcc")] = "talcc"
PedModel1[joaat("ig_talina")] = "talina"
PedModel1[joaat("ig_talmm")] = "talmm"
PedModel1[joaat("ig_tanisha")] = "tanisha"
PedModel1[joaat("ig_taocheng")] = "taocheng"
PedModel1[joaat("ig_taocheng2")] = "taocheng2"
PedModel1[joaat("ig_taostranslator")] = "taostranslator"
PedModel1[joaat("ig_taostranslator2")] = "taostranslator2"
PedModel1[joaat("ig_tenniscoach")] = "tenniscoach"
PedModel1[joaat("ig_terry")] = "Terry Thorpe"
PedModel1[joaat("ig_thornton")] = "Thornton Duggan"
PedModel1[joaat("ig_tomcasino")] = "tomcasino"
PedModel1[joaat("ig_tomepsilon")] = "tomepsilon"
PedModel1[joaat("ig_tonya")] = "tonya"
PedModel1[joaat("ig_tonyprince")] = "tonyprince"
PedModel1[joaat("ig_tracydisanto")] = "tracydisanto"
PedModel1[joaat("ig_trafficwarden")] = "trafficwarden"
PedModel1[joaat("ig_tylerdix")] = "tylerdix"
PedModel1[joaat("ig_tylerdix_02")] = "tylerdix_02"
PedModel1[joaat("ig_vagspeak")] = "Vagspeak"
PedModel1[joaat("ig_vincent")] = "Vincent"
PedModel1[joaat("ig_vincent_2")] = "Vincent 2"
PedModel1[joaat("ig_wade")] = "Wade"
PedModel1[joaat("ig_wendy")] = "Wendy"
PedModel1[joaat("ig_zimbor")] = "Zimbor"
PedModel1[joaat("mp_f_bennymech_01")] = "mp_f_bennymech_01"
PedModel1[joaat("mp_f_boatstaff_01")] = "mp_f_boatstaff_01"
PedModel1[joaat("mp_f_cardesign_01")] = "mp_f_cardesign_01"
PedModel1[joaat("mp_f_chbar_01")] = "mp_f_chbar_01"
PedModel1[joaat("mp_f_cocaine_01")] = "mp_f_cocaine_01"
PedModel1[joaat("mp_f_counterfeit_01")] = "mp_f_counterfeit_01"
PedModel1[joaat("mp_f_deadhooker")] = "mp_f_deadhooker"
PedModel1[joaat("mp_f_execpa_01")] = "mp_f_execpa_01"
PedModel1[joaat("mp_f_execpa_02")] = "mp_f_execpa_02"
PedModel1[joaat("mp_f_forgery_01")] = "mp_f_forgery_01"
PedModel1[joaat("mp_f_helistaff_01")] = "mp_f_helistaff_01"
PedModel1[joaat("mp_f_meth_01")] = "mp_f_meth_01"
PedModel1[joaat("mp_f_misty_01")] = "mp_f_misty_01"
PedModel1[joaat("mp_f_stripperlite")] = "Nikki"
PedModel1[joaat("mp_f_weed_01")] = "mp_f_weed_01"
PedModel1[joaat("mp_g_m_pros_01")] = "mp_g_m_pros_01"
PedModel1[joaat("mp_headtargets")] = "mp_headtargets"
PedModel1[joaat("mp_m_avongoon")] = "mp_m_avongoon"
PedModel1[joaat("mp_m_boatstaff_01")] = "mp_m_boatstaff_01"
PedModel1[joaat("mp_m_bogdangoon")] = "mp_m_bogdangoon"
PedModel1[joaat("mp_m_claude_01")] = "mp_m_claude_01"
PedModel1[joaat("mp_m_cocaine_01")] = "mp_m_cocaine_01"
PedModel1[joaat("mp_m_counterfeit_01")] = "mp_m_counterfeit_01"
PedModel1[joaat("mp_m_exarmy_01")] = "mp_m_exarmy_01"
PedModel1[joaat("mp_m_execpa_01")] = "mp_m_execpa_01"
PedModel1[joaat("mp_m_famdd_01")] = "mp_m_famdd_01"
PedModel1[joaat("mp_m_fibsec_01")] = "mp_m_fibsec_01"
PedModel1[joaat("mp_m_forgery_01")] = "mp_m_forgery_01"
PedModel1[joaat("mp_m_g_vagfun_01")] = "mp_m_g_vagfun_01"
PedModel1[joaat("mp_m_marston_01")] = "mp_m_marston_01"
PedModel1[joaat("mp_m_meth_01")] = "mp_m_meth_01"
PedModel1[joaat("mp_m_niko_01")] = "mp_m_niko_01"
PedModel1[joaat("mp_m_securoguard_01")] = "mp_m_securoguard_01"
PedModel1[joaat("mp_m_shopkeep_01")] = "mp_m_shopkeep_01"
PedModel1[joaat("mp_m_waremech_01")] = "mp_m_waremech_01"
PedModel1[joaat("mp_m_weapexp_01")] = "mp_m_weapexp_01"
PedModel1[joaat("mp_m_weapwork_01")] = "mp_m_weapwork_01"
PedModel1[joaat("mp_m_weed_01")] = "mp_m_weed_01"
PedModel1[joaat("mp_s_m_armoured_01")] = "mp_s_m_armoured_01"
PedModel1[joaat("s_f_m_fembarber")] = "s_f_m_fembarber"
PedModel1[joaat("s_f_m_maid_01")] = "s_f_m_maid_01"
PedModel1[joaat("s_f_m_shop_high")] = "s_f_m_shop_high"
PedModel1[joaat("s_f_m_sweatshop_01")] = "s_f_m_sweatshop_01"
PedModel1[joaat("s_f_y_airhostess_01")] = "s_f_y_airhostess_01"
PedModel1[joaat("s_f_y_bartender_01")] = "s_f_y_bartender_01"
PedModel1[joaat("s_f_y_baywatch_01")] = "s_f_y_baywatch_01"
PedModel1[joaat("s_f_y_beachbarstaff_01")] = "s_f_y_beachbarstaff_01"
PedModel1[joaat("s_f_y_casino_01")] = "s_f_y_casino_01"
PedModel1[joaat("s_f_y_clubbar_01")] = "s_f_y_clubbar_01"
PedModel1[joaat("s_f_y_clubbar_02")] = "s_f_y_clubbar_02"
PedModel1[joaat("s_f_y_cop_01")] = "s_f_y_cop_01"
PedModel1[joaat("s_f_y_factory_01")] = "s_f_y_factory_01"
PedModel1[joaat("s_f_y_hooker_01")] = "s_f_y_hooker_01"
PedModel1[joaat("s_f_y_hooker_02")] = "s_f_y_hooker_02"
PedModel1[joaat("s_f_y_hooker_03")] = "s_f_y_hooker_03"
PedModel1[joaat("s_f_y_migrant_01")] = "s_f_y_migrant_01"
PedModel1[joaat("s_f_y_movprem_01")] = "s_f_y_movprem_01"
PedModel1[joaat("s_f_y_ranger_01")] = "s_f_y_ranger_01"
PedModel1[joaat("s_f_y_scrubs_01")] = "s_f_y_scrubs_01"
PedModel1[joaat("s_f_y_sheriff_01")] = "s_f_y_sheriff_01"
PedModel1[joaat("s_f_y_shop_low")] = "s_f_y_shop_low"
PedModel1[joaat("s_f_y_shop_mid")] = "s_f_y_shop_mid"
PedModel1[joaat("s_f_y_stripper_01")] = "s_f_y_stripper_01"
PedModel1[joaat("s_f_y_stripper_02")] = "s_f_y_stripper_02"
PedModel1[joaat("s_f_y_stripperlite")] = "s_f_y_stripperlite"
PedModel1[joaat("s_f_y_sweatshop_01")] = "s_f_y_sweatshop_01"
PedModel1[joaat("s_m_m_ammucountry")] = "s_m_m_ammucountry"
PedModel1[joaat("s_m_m_armoured_01")] = "s_m_m_armoured_01"
PedModel1[joaat("s_m_m_armoured_02")] = "s_m_m_armoured_02"
PedModel1[joaat("s_m_m_autoshop_01")] = "s_m_m_autoshop_01"
PedModel1[joaat("s_m_m_autoshop_02")] = "s_m_m_autoshop_02"
PedModel1[joaat("s_m_m_bouncer_01")] = "s_m_m_bouncer_01"
PedModel1[joaat("s_m_m_bouncer_02")] = "s_m_m_bouncer_02"
PedModel1[joaat("s_m_m_ccrew_01")] = "s_m_m_ccrew_01"
PedModel1[joaat("s_m_m_chemsec_01")] = "s_m_m_chemsec_01"
PedModel1[joaat("s_m_m_ciasec_01")] = "s_m_m_ciasec_01"
PedModel1[joaat("s_m_m_cntrybar_01")] = "s_m_m_cntrybar_01"
PedModel1[joaat("s_m_m_dockwork_01")] = "s_m_m_dockwork_01"
PedModel1[joaat("s_m_m_doctor_01")] = "s_m_m_doctor_01"
PedModel1[joaat("s_m_m_drugprocess_01")] = "s_m_m_drugprocess_01"
PedModel1[joaat("s_m_m_fiboffice_01")] = "s_m_m_fiboffice_01"
PedModel1[joaat("s_m_m_fiboffice_02")] = "s_m_m_fiboffice_02"
PedModel1[joaat("s_m_m_fibsec_01")] = "s_m_m_fibsec_01"
PedModel1[joaat("s_m_m_fieldworker_01")] = "s_m_m_fieldworker_01"
PedModel1[joaat("s_m_m_gaffer_01")] = "s_m_m_gaffer_01"
PedModel1[joaat("s_m_m_gardener_01")] = "s_m_m_gardener_01"
PedModel1[joaat("s_m_m_gentransport")] = "s_m_m_gentransport"
PedModel1[joaat("s_m_m_hairdress_01")] = "s_m_m_hairdress_01"
PedModel1[joaat("s_m_m_highsec_01")] = "s_m_m_highsec_01"
PedModel1[joaat("s_m_m_highsec_02")] = "s_m_m_highsec_02"
PedModel1[joaat("s_m_m_highsec_03")] = "s_m_m_highsec_03"
PedModel1[joaat("s_m_m_highsec_04")] = "s_m_m_highsec_04"
PedModel1[joaat("s_m_m_janitor")] = "s_m_m_janitor"
PedModel1[joaat("s_m_m_lathandy_01")] = "s_m_m_lathandy_01"
PedModel1[joaat("s_m_m_lifeinvad_01")] = "s_m_m_lifeinvad_01"
PedModel1[joaat("s_m_m_linecook")] = "s_m_m_linecook"
PedModel1[joaat("s_m_m_lsmetro_01")] = "s_m_m_lsmetro_01"
PedModel1[joaat("s_m_m_mariachi_01")] = "s_m_m_mariachi_01"
PedModel1[joaat("s_m_m_marine_01")] = "s_m_m_marine_01"
PedModel1[joaat("s_m_m_marine_02")] = "s_m_m_marine_02"
PedModel1[joaat("s_m_m_migrant_01")] = "s_m_m_migrant_01"
PedModel1[joaat("s_m_m_movalien_01")] = "s_m_m_movalien_01"
PedModel1[joaat("s_m_m_movprem_01")] = "s_m_m_movprem_01"
PedModel1[joaat("s_m_m_movspace_01")] = "s_m_m_movspace_01"
PedModel1[joaat("s_m_m_paramedic_01")] = "s_m_m_paramedic_01"
PedModel1[joaat("s_m_m_pilot_01")] = "s_m_m_pilot_01"
PedModel1[joaat("s_m_m_pilot_02")] = "s_m_m_pilot_02"
PedModel1[joaat("s_m_m_postal_01")] = "s_m_m_postal_01"
PedModel1[joaat("s_m_m_postal_02")] = "s_m_m_postal_02"
PedModel1[joaat("s_m_m_prisguard_01")] = "s_m_m_prisguard_01"
PedModel1[joaat("s_m_m_scientist_01")] = "s_m_m_scientist_01"
PedModel1[joaat("s_m_m_security_01")] = "s_m_m_security_01"
PedModel1[joaat("s_m_m_snowcop_01")] = "s_m_m_snowcop_01"
PedModel1[joaat("s_m_m_strperf_01")] = "s_m_m_strperf_01"
PedModel1[joaat("s_m_m_strpreach_01")] = "s_m_m_strpreach_01"
PedModel1[joaat("s_m_m_strvend_01")] = "s_m_m_strvend_01"
PedModel1[joaat("s_m_m_trucker_01")] = "s_m_m_trucker_01"
PedModel1[joaat("s_m_m_ups_01")] = "s_m_m_ups_01"
PedModel1[joaat("s_m_m_ups_02")] = "s_m_m_ups_02"
PedModel1[joaat("s_m_o_busker_01")] = "s_m_o_busker_01"
PedModel1[joaat("s_m_y_airworker")] = "s_m_y_airworker"
PedModel1[joaat("s_m_y_ammucity_01")] = "s_m_y_ammucity_01"
PedModel1[joaat("s_m_y_armymech_01")] = "s_m_y_armymech_01"
PedModel1[joaat("s_m_y_autopsy_01")] = "s_m_y_autopsy_01"
PedModel1[joaat("s_m_y_barman_01")] = "s_m_y_barman_01"
PedModel1[joaat("s_m_y_baywatch_01")] = "s_m_y_baywatch_01"
PedModel1[joaat("s_m_y_blackops_01")] = "s_m_y_blackops_01"
PedModel1[joaat("s_m_y_blackops_02")] = "s_m_y_blackops_02"
PedModel1[joaat("s_m_y_blackops_03")] = "s_m_y_blackops_03"
PedModel1[joaat("s_m_y_busboy_01")] = "s_m_y_busboy_01"
PedModel1[joaat("s_m_y_casino_01")] = "s_m_y_casino_01"
PedModel1[joaat("s_m_y_chef_01")] = "s_m_y_chef_01"
PedModel1[joaat("s_m_y_clown_01")] = "s_m_y_clown_01"
PedModel1[joaat("s_m_y_clubbar_01")] = "s_m_y_clubbar_01"
PedModel1[joaat("s_m_y_construct_01")] = "s_m_y_construct_01"
PedModel1[joaat("s_m_y_construct_02")] = "s_m_y_construct_02"
PedModel1[joaat("s_m_y_cop_01")] = "s_m_y_cop_01"
PedModel1[joaat("s_m_y_dealer_01")] = "s_m_y_dealer_01"
PedModel1[joaat("s_m_y_devinsec_01")] = "s_m_y_devinsec_01"
PedModel1[joaat("s_m_y_dockwork_01")] = "s_m_y_dockwork_01"
PedModel1[joaat("s_m_y_doorman_01")] = "s_m_y_doorman_01"
PedModel1[joaat("s_m_y_dwservice_01")] = "s_m_y_dwservice_01"
PedModel1[joaat("s_m_y_dwservice_02")] = "s_m_y_dwservice_02"
PedModel1[joaat("s_m_y_factory_01")] = "s_m_y_factory_01"
PedModel1[joaat("s_m_y_fireman_01")] = "s_m_y_fireman_01"
PedModel1[joaat("s_m_y_garbage")] = "s_m_y_garbage"
PedModel1[joaat("s_m_y_grip_01")] = "s_m_y_grip_01"
PedModel1[joaat("s_m_y_hwaycop_01")] = "s_m_y_hwaycop_01"
PedModel1[joaat("s_m_y_marine_01")] = "s_m_y_marine_01"
PedModel1[joaat("s_m_y_marine_02")] = "s_m_y_marine_02"
PedModel1[joaat("s_m_y_marine_03")] = "s_m_y_marine_03"
PedModel1[joaat("s_m_y_mime")] = "s_m_y_mime"
PedModel1[joaat("s_m_y_pestcont_01")] = "s_m_y_pestcont_01"
PedModel1[joaat("s_m_y_pilot_01")] = "s_m_y_pilot_01"
PedModel1[joaat("s_m_y_prismuscl_01")] = "s_m_y_prismuscl_01"
PedModel1[joaat("s_m_y_prisoner_01")] = "s_m_y_prisoner_01"
PedModel1[joaat("s_m_y_ranger_01")] = "s_m_y_ranger_01"
PedModel1[joaat("s_m_y_robber_01")] = "s_m_y_robber_01"
PedModel1[joaat("s_m_y_sheriff_01")] = "s_m_y_sheriff_01"
PedModel1[joaat("s_m_y_shop_mask")] = "s_m_y_shop_mask"
PedModel1[joaat("s_m_y_strvend_01")] = "s_m_y_strvend_01"
PedModel1[joaat("s_m_y_swat_01")] = "s_m_y_swat_01"
PedModel1[joaat("s_m_y_uscg_01")] = "s_m_y_uscg_01"
PedModel1[joaat("s_m_y_valet_01")] = "s_m_y_valet_01"
PedModel1[joaat("s_m_y_waiter_01")] = "s_m_y_waiter_01"
PedModel1[joaat("s_m_y_waretech_01")] = "s_m_y_waretech_01"
PedModel1[joaat("s_m_y_westsec_01")] = "s_m_y_westsec_01"
PedModel1[joaat("s_m_y_westsec_02")] = "s_m_y_westsec_02"
PedModel1[joaat("s_m_y_winclean_01")] = "s_m_y_winclean_01"
PedModel1[joaat("s_m_y_xmech_01")] = "s_m_y_xmech_01"
PedModel1[joaat("s_m_y_xmech_02")] = "s_m_y_xmech_02"
PedModel1[joaat("s_m_y_xmech_02_mp")] = "s_m_y_xmech_02_mp"
PedModel1[joaat("u_f_m_casinocash_01")] = "u_f_m_casinocash_01"
PedModel1[joaat("u_f_m_casinoshop_01")] = "u_f_m_casinoshop_01"
PedModel1[joaat("u_f_m_corpse_01")] = "u_f_m_corpse_01"
PedModel1[joaat("u_f_m_debbie_01")] = "u_f_m_debbie_01"
PedModel1[joaat("u_f_m_drowned_01")] = "u_f_m_drowned_01"
PedModel1[joaat("u_f_m_miranda")] = "u_f_m_miranda"
PedModel1[joaat("u_f_m_miranda_02")] = "u_f_m_miranda_02"
PedModel1[joaat("u_f_m_promourn_01")] = "u_f_m_promourn_01"
PedModel1[joaat("u_f_o_carol")] = "u_f_o_carol"
PedModel1[joaat("u_f_o_eileen")] = "u_f_o_eileen"
PedModel1[joaat("u_f_o_moviestar")] = "u_f_o_moviestar"
PedModel1[joaat("u_f_o_prolhost_01")] = "u_f_o_prolhost_01"
PedModel1[joaat("u_f_y_beth")] = "u_f_y_beth"
PedModel1[joaat("u_f_y_bikerchic")] = "u_f_y_bikerchic"
PedModel1[joaat("u_f_y_comjane")] = "u_f_y_comjane"
PedModel1[joaat("u_f_y_corpse_01")] = "u_f_y_corpse_01"
PedModel1[joaat("u_f_y_corpse_02")] = "u_f_y_corpse_02"
PedModel1[joaat("u_f_y_danceburl_01")] = "u_f_y_danceburl_01"
PedModel1[joaat("u_f_y_dancelthr_01")] = "u_f_y_dancelthr_01"
PedModel1[joaat("u_f_y_dancerave_01")] = "u_f_y_dancerave_01"
PedModel1[joaat("u_f_y_hotposh_01")] = "u_f_y_hotposh_01"
PedModel1[joaat("u_f_y_jewelass_01")] = "u_f_y_jewelass_01"
PedModel1[joaat("u_f_y_lauren")] = "u_f_y_lauren"
PedModel1[joaat("u_f_y_mistress")] = "u_f_y_mistress"
PedModel1[joaat("u_f_y_poppymich")] = "u_f_y_poppymich"
PedModel1[joaat("u_f_y_poppymich_02")] = "u_f_y_poppymich_02"
PedModel1[joaat("u_f_y_princess")] = "u_f_y_princess"
PedModel1[joaat("u_f_y_spyactress")] = "u_f_y_spyactress"
PedModel1[joaat("u_f_y_taylor")] = "u_f_y_taylor"
PedModel1[joaat("u_m_m_aldinapoli")] = "u_m_m_aldinapoli"
PedModel1[joaat("u_m_m_bankman")] = "u_m_m_bankman"
PedModel1[joaat("u_m_m_bikehire_01")] = "u_m_m_bikehire_01"
PedModel1[joaat("u_m_m_blane")] = "u_m_m_blane"
PedModel1[joaat("u_m_m_curtis")] = "u_m_m_curtis"
PedModel1[joaat("u_m_m_doa_01")] = "u_m_m_doa_01"
PedModel1[joaat("u_m_m_edtoh")] = "u_m_m_edtoh"
PedModel1[joaat("u_m_m_fibarchitect")] = "u_m_m_fibarchitect"
PedModel1[joaat("u_m_m_filmdirector")] = "u_m_m_filmdirector"
PedModel1[joaat("u_m_m_glenstank_01")] = "u_m_m_glenstank_01"
PedModel1[joaat("u_m_m_griff_01")] = "u_m_m_griff_01"
PedModel1[joaat("u_m_m_jesus_01")] = "u_m_m_jesus_01"
PedModel1[joaat("u_m_m_jewelsec_01")] = "u_m_m_jewelsec_01"
PedModel1[joaat("u_m_m_jewelthief")] = "u_m_m_jewelthief"
PedModel1[joaat("u_m_m_markfost")] = "u_m_m_markfost"
PedModel1[joaat("u_m_m_prolsec_01")] = "u_m_m_prolsec_01"
PedModel1[joaat("u_m_m_promourn_01")] = "u_m_m_promourn_01"
PedModel1[joaat("u_m_m_rivalpap")] = "u_m_m_rivalpap"
PedModel1[joaat("u_m_m_spyactor")] = "u_m_m_spyactor"
PedModel1[joaat("u_m_m_streetart_01")] = "u_m_m_streetart_01"
PedModel1[joaat("u_m_m_vince")] = "u_m_m_vince"
PedModel1[joaat("u_m_m_willyfist")] = "u_m_m_willyfist"
PedModel1[joaat("u_m_o_dean")] = "u_m_o_dean"
PedModel1[joaat("u_m_o_filmnoir")] = "u_m_o_filmnoir"
PedModel1[joaat("u_m_o_finguru_01")] = "u_m_o_finguru_01"
PedModel1[joaat("u_m_o_taphillbilly")] = "u_m_o_taphillbilly"
PedModel1[joaat("u_m_o_tramp_01")] = "u_m_o_tramp_01"
PedModel1[joaat("u_m_y_abner")] = "u_m_y_abner"
PedModel1[joaat("u_m_y_antonb")] = "u_m_y_antonb"
PedModel1[joaat("u_m_y_babyd")] = "u_m_y_babyd"
PedModel1[joaat("u_m_y_baygor")] = "u_m_y_baygor"
PedModel1[joaat("u_m_y_burgerdrug_01")] = "u_m_y_burgerdrug_01"
PedModel1[joaat("u_m_y_caleb")] = "u_m_y_caleb"
PedModel1[joaat("u_m_y_cyclist_01")] = "u_m_y_cyclist_01"
PedModel1[joaat("u_m_y_dancerave_01")] = "u_m_y_dancerave_01"
PedModel1[joaat("u_m_y_fibmugger_01")] = "u_m_y_fibmugger_01"
PedModel1[joaat("u_m_y_gabriel")] = "u_m_y_gabriel"
PedModel1[joaat("u_m_y_guido_01")] = "u_m_y_guido_01"
PedModel1[joaat("u_m_y_gunvend_01")] = "u_m_y_gunvend_01"
PedModel1[joaat("u_m_y_hippie_01")] = "u_m_y_hippie_01"
PedModel1[joaat("u_m_y_imporage")] = "u_m_y_imporage"
PedModel1[joaat("u_m_y_juggernaut_01")] = "u_m_y_juggernaut_01"
PedModel1[joaat("u_m_y_justin")] = "u_m_y_justin"
PedModel1[joaat("u_m_y_mani")] = "u_m_y_mani"
PedModel1[joaat("u_m_y_militarybum")] = "u_m_y_militarybum"
PedModel1[joaat("u_m_y_paparazzi")] = "u_m_y_paparazzi"
PedModel1[joaat("u_m_y_party_01")] = "u_m_y_party_01"
PedModel1[joaat("u_m_y_pogo_01")] = "u_m_y_pogo_01"
PedModel1[joaat("u_m_y_prisoner_01")] = "u_m_y_prisoner_01"
PedModel1[joaat("u_m_y_proldriver_01")] = "u_m_y_proldriver_01"
PedModel1[joaat("u_m_y_rsranger_01")] = "Space Ranger"
PedModel1[joaat("u_m_y_sbike")] = "u_m_y_sbike"
PedModel1[joaat("u_m_y_smugmech_01")] = "u_m_y_smugmech_01"
PedModel1[joaat("u_m_y_staggrm_01")] = "u_m_y_staggrm_01"
PedModel1[joaat("u_m_y_tattoo_01")] = "u_m_y_tattoo_01"
PedModel1[joaat("u_m_y_ushi")] = "u_m_y_ushi"
PedModel1[joaat("u_m_y_zombie_01")] = "u_m_y_zombie_01"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local animal_hash = joaat("a_c_cat_01")
local ped_hash = joaat("player_one")
local bird_hash = joaat("a_c_seagull")
local sea_hash = joaat("a_c_dolphin")
local self_hash = joaat("mp_m_freemode_01")
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
appMenu:add_array_item("Pon Delay Primero", {"1", "2", "3", "4", "5", "6", "7", "8"}, function() return xox_31 end, function(value) xox_31 = value if value == 1 then duFF = 0.01 elseif value == 2 then duFF = 0.05 elseif value == 3 then duFF = 0.08 elseif value == 4 then duFF = 0.1 elseif value == 5 then duFF = 0.15 elseif value == 6 then duFF = 0.2 elseif value == 7 then duFF = 0.25 else duFF = 0.3 end end) appMenu:add_action("---", function() end)
appMenu:add_array_item("Skin Normal", PedSelf, function() return self_hash end, function(value) self_hash = value globals.set_int(2671449+59, 1) globals.set_int(2671449+46, value) sleep(duFF) globals.set_int(2671449+59, 0) end)
appMenu:add_array_item("Animales", PedModelAnimal, function() return animal_hash end, function(value) animal_hash = value globals.set_int(2671449+59, 1) globals.set_int(2671449+46, value) sleep(duFF) globals.set_int(2671449+59, 0) end)
appMenu:add_array_item("Peds", PedModel1, function() return ped_hash end, function(value) ped_hash = value globals.set_int(2671449+59, 1) globals.set_int(2671449+46, value) sleep(duFF) globals.set_int(2671449+59, 0) end) 
appMenu:add_array_item("Pajaroz", PedModelBird, function() return bird_hash end, function(value) bird_hash = value globals.set_int(2671449+59, 1) globals.set_int(2671449+46, value) sleep(duFF) globals.set_int(2671449+59, 0) end)
appMenu:add_array_item("Animales De Awa Grande", PedModelSeaAnimal, function() return sea_hash end, function(value) sea_hash = value globals.set_int(2671449+59, 1) globals.set_int(2671449+46, value) sleep(duFF) globals.set_int(2671449+59, 0) end)
appMenu:add_action("Bolberse Bigfoot", function()	globals.set_int(2671449+59, 1) globals.set_int(2671449+46, -1389097126) sleep(duFF) globals.set_int(2671449+59, 0) end)
appMenu:add_action("      ---[Cambia el Delay si no funca]---", function() end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ANM = {}
--ANM[-832573324] = "Javali"
--ANM[1462895032] = "Gato"
--ANM[-1469565163] = "Sammy"
--ANM[351016938] = "Perro Negro"
--ANM[-50684386] = "Vicente"
--ANM[1682622302] = "Coyote"
--ANM[-664053099] = "Cierbo"
--ANM[-1318032802] = "Husky"
--ANM[307287994] = "Un LEON"
--ANM[-1323586730] = "Cerdo"
--ANM[1125994524] = "Poodle"
--ANM[1832265812] = "Pug"
--ANM[-541762431] = "Conejo"
--ANM[-1011537562] = "Rata"
--ANM[882848737] = "Retriever"
--ANM[1126154828] = "Shepherd"
--ANM[-1026527405] = "Rhesus"
--ANM[-1384627013] = "Westy"
--appMenu:add_array_item("Bolberse Animal", ANM, function() return 351016938 end, function(Anm)
--	set_model_hash(Anm)
--	player:set_godmode(true)
--end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CosP ={}
--CosP[71929310] = "Paiaso"
--CosP[880829941] = "ImpoRage"
--CosP[-835930287] = "Jesus01"
--CosP[1684083350] = "MovAlien01"
--CosP[-407694286] = "MovSpace01SMM"
--CosP[-598109171] = "Pogo01"
--CosP[1681385341] = "Priest"
--CosP[1011059922] = "RsRanger01AMO"
--CosP[-1404353274] = "Zombie01"
--CosP[-2016771922] = "JohnnyKlebitz"
--CosP[1021093698] = "MimeSMY"
--CosP[-1389097126] = "Orleans"
--appMenu:add_array_item("Bolberse ....", CosP, function() return -1389097126 end, function(Brd)
--	set_model_hash(Brd)
--end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--BRD = {}
--BRD[1794449327] = "Polla Digo Pollo"
--BRD[-1430839454] = "Gallo"
--BRD[1457690978] = "Comorant-swan like"
--BRD[-1469565163] = "Cuerbo"
--BRD[1794449327] = "Polla"
--BRD[-745300483] = "Larry"
--appMenu:add_array_item("Bolberse abe", BRD, function() return -1469565163 end, function(Brd)
--	set_model_hash(Brd)
--end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--SCRe = {}
--SCRe[1015224100] = "Tiburon Marti"
--SCRe[-1920284487] = "Ba-Llena"
--SCRe[113504370] = "Tiburon Tigre"
--SCRe[-1528782338] = "Manta-Raya"
--SCRe[1193010354] = "Pene"
--SCRe[-1950698411] = "Delfin"
--appMenu:add_array_item("Bolberse An De Mar", SCRe, function() return -1950698411 end, function(SAn)
--	set_model_hash(SAn)
--	player:set_godmode(true)
--end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--LAW = {}
--LAW[1096929346] = "Sheriff01SFY"
--LAW[-1275859404] = "BlackOps01SMY"
--LAW[2047212121] = "BlackOps02SMY"
--LAW[1349953339] = "BlackOps03SMY"
--LAW[-520477356] = "Casey"
--LAW[1650288984] = "CIASec01SMM"
--LAW[1581098148] = "Cop01SMY"
--LAW[368603149] = "Cop01SFY"
--LAW[-1699520669] = "CopCutscene"
--LAW[988062523] = "FBISuit01"
--LAW[874722259] = "FIBArchitect"
--LAW[-2051422616] = "FIBMugger01"
--LAW[-306416314] = "FIBOffice01SMM"
--LAW[653289389] = "FIBOffice02SMM"
--LAW[1558115333] = "FIBSec01"
--LAW[2072724299] = "FIBSec01SMM"
--LAW[245247470] = "HighSec01SMM"
--LAW[691061163] = "HighSec02SMM"
--LAW[1939545845] = "HWayCop01SMY"
--LAW[-220552467] = "Marine01SMM"
--LAW[1702441027] = "Marine01SMY"
--LAW[-265970301] = "Marine02SMM"
--LAW[1490458366] = "Marine02SMY"
--LAW[1925237458] = "Marine03SMY"
--LAW[1631478380] = "MerryWeatherCutscene"
--LAW[1822283721] = "MPros01"
--LAW[1456041926] = "PrisGuard01SMM"
--LAW[-1614285257] = "Ranger01SFY"
--LAW[-277793362] = "Ranger01SMY"
--LAW[-681004504] = "Security01SMM"
--LAW[451459928] = "SnowCop01SMM"
--LAW[-1920001264] = "SWAT01SMY"
--LAW[-277325206] = "UndercoverCopCutscene"
--appMenu:add_array_item("Bolberse Omvre de la lei", LAW, function() return 1096929346 end, function(Lw)
--	set_model_hash(Lw)
--end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local repMenu = modelMenu:add_submenu("Ver reportez")
repMenu:add_bare_item("", function() return "Grifear:".. (string.format("%03d", stats.get_int("MPPLY_GRIEFING"))) end, function() end, function()end, function() return end)
repMenu:add_bare_item("", function() return "Hacks:".. (string.format("%03d", stats.get_int("MPPLY_EXPLOITS"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Bugs:".. (string.format("%03d", stats.get_int("MPPLY_GAME_EXPLOITS"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Acoso textual:".. (string.format("%03d", stats.get_int("MPPLY_TC_ANNOYINGME"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal hablado:".. (string.format("%03d", stats.get_int("MPPLY_TC_HATE"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal hablado x2:".. (string.format("%03d", stats.get_int("MPPLY_VC_ANNOYINGME"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal hablado x3:".. (string.format("%03d", stats.get_int("MPPLY_VC_HATE"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Lenguaje ofenzivo:".. (string.format("%03d", stats.get_int("MPPLY_OFFENSIVE_LANGUAGE"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Id ofenzivo:".. (string.format("%03d", stats.get_int("MPPLY_OFFENSIVE_TAGPLATE"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Contenido ofenzivo:".. (string.format("%03d", stats.get_int("MPPLY_OFFENSIVE_UGC"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal nombre de crew:".. (string.format("%03d", stats.get_int("MPPLY_BAD_CREW_NAME"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal nombre de MC:".. (string.format("%03d", stats.get_int("MPPLY_BAD_CREW_MOTTO"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal estado de crew:".. (string.format("%03d", stats.get_int("MPPLY_BAD_CREW_STATUS"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal emblema de crew:".. (string.format("%03d", stats.get_int("MPPLY_BAD_CREW_EMBLEM"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Amiwito:".. (string.format("%03d", stats.get_int("MPPLY_FRIENDLY"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Ayudante:".. (string.format("%03d", stats.get_int("MPPLY_HELPFUL"))) end, function() end, function()end, function()end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local OnlMenu = mainMenu:add_submenu("Online")
OnlMenu:add_array_item("Sesiones Online", {"Unirse Sezion publica", "Iniciar Sezion Publica", "Sezion de invitacion", "Sezion cerrada de crew", "Sezion por crew", "Sezion cerrrada de amigos", "Encontrar Sezion por jugadores", "Sezion Solo"}, function() return xox_00 end, function(value) xox_00 = value if value == 1 then globals.set_int(1575015, 0) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 2 then globals.set_int(1575015, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 3 then globals.set_int(1575015, 11) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 4 then globals.set_int(1575015, 2) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 5 then globals.set_int(1575015, 3) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 6 then globals.set_int(1575015, 6) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 7 then globals.set_int(1575015, 9) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 8 then globals.set_int(1575015, 8) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end end)
OnlMenu:add_action("Bypasear Error De Transaxion", function() if globals.get_int(4535612) == 20 or globals.get_int(4535612) == 4 then globals.set_int(4535606, 0) end end)
OnlMenu:add_action("Remover tiempo de espera de VIP O MC", function() stats.set_int("MPPLY_VIPGAMEPLAYDISABLEDTIMER", 0) end)
OnlMenu:add_action("Saltar misiones de Lamar", function() stats.set_bool(mpx .. "LOW_FLOW_CS_DRV_SEEN", true) stats.set_bool(mpx .. "LOW_FLOW_CS_TRA_SEEN", true) stats.set_bool(mpx .. "LOW_FLOW_CS_FUN_SEEN", true) stats.set_bool(mpx .. "LOW_FLOW_CS_PHO_SEEN", true) stats.set_bool(mpx .. "LOW_FLOW_CS_FIN_SEEN", true) stats.set_bool(mpx .. "LOW_BEN_INTRO_CS_SEEN", true) stats.set_int(mpx .. "LOWRIDER_FLOW_COMPLETE", 4) stats.set_int(mpx .. "LOW_FLOW_CURRENT_PROG", 9) stats.set_int(mpx .. "LOW_FLOW_CURRENT_CALL", 9) stats.set_int(mpx .. "LOW_FLOW_CS_HELPTEXT", 66) end) OnlMenu:add_action("Skipear Misiones Yate", function() stats.set_int(mpx .. "YACHT_MISSION_PROG", 0) stats.set_int(mpx .. "YACHT_MISSION_FLOW", 21845) stats.set_int(mpx .. "CASINO_DECORATION_GIFT_1", -1) end)
OnlMenu:add_action("Saltar misiones de ULP", function() stats.set_int(mpx .. "ULP_MISSION_PROGRESS", 127) stats.set_int(mpx .. "ULP_MISSION_CURRENT", 0) end)
OnlMenu:add_toggle("TPRapido(NumDel)", function()
	return enable2
end, function()
	enable2 = not enable2
	TPHkS(enable2)
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--local WepMenu = mainMenu:add_submenu("Armaz")
--WepCD = WepMenu:add_submenu("Extras De Armaz")
--local function WpCD(e)
--	if e then
--		WCD = menu:register_callback('OnWeaponChanged', OnWeaponChanged)
--	else
--		menu:remove_callback(WCD)
--		bT = 0
--		WR = 0
--	end
--end

--WepCD:add_toggle("Fuego Rapido, Misc", function()
--	return enable
--end, function()
--	enable = not enable 
--	WpCD(enable)
--end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local TrolMenu = mainMenu:add_submenu("Trolio")
TrolMenu:add_action("En un futuro no muy lejano...", function() end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetUndeadOffradar()
	if localplayer == nil then
		return nil
	end
	max_health = localplayer:get_max_health()
	return max_health < 100.0
end
local function SetUndeadOffradar(value)
	if value == nil or localplayer == nil then
		return
	end
	if value then
		max_health = localplayer:get_max_health()
		if max_health >= 100.0 then
			original_max_health = max_health
		end
		localplayer:set_max_health(0.0)
	else
		if original_max_health >= 100 then
			localplayer:set_max_health(original_max_health)
		else
			localplayer:set_max_health(328.0)
		end
	end
end
OnlMenu:add_toggle("Fuera Del Riedar (Beta XD)", GetUndeadOffradar, SetUndeadOffradar)
local function ToggleUndeadOffradar()
	value = GetUndeadOffradar()
	if value ~= nil then
		SetUndeadOffradar(not value)
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

OnlMenu:add_int_range("RP (Correxion)", 1, 0, 8000, function()
	local mpIndex = globals.get_int(1574907)
	if mpIndex > 1 or mpIndex < 0 then
		return
	end
	
	local currentRP = 0
	
	if mpIndex == 0 then
		currentRP = stats.get_int("MP0_CHAR_SET_RP_GIFT_ADMIN")
	else
		currentRP = stats.get_int("MP1_CHAR_SET_RP_GIFT_ADMIN")
	end
	
	if currentRP <= 0 then
		currentRP = globals.get_int(1655629 + mpIndex)
	end
 
	local rpLevel = 0
	for i = 0,8000 do
		if currentRP < globals.get_int(294329 + i) then
			break
		else
			rpLevel = i
		end
	end
	
	return rpLevel
end, function(value)
	local mpIndex = globals.get_int(1574907)
	if mpIndex > 1 or mpIndex < 0 then
		return
	end
	
	local newRP = globals.get_int(294329 + value) + 100
	
	if mpIndex == 0 then
		stats.set_int("MP0_CHAR_SET_RP_GIFT_ADMIN", newRP)
	else
		stats.set_int("MP1_CHAR_SET_RP_GIFT_ADMIN", newRP)
	end
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
OnlMenu:add_action("Bypasiar Canion Orvital", function()
	mpIndex = globals.get_int(1574907)
	if mpIndex == 0 then
		stats.set_int("MP0_ORBITAL_CANNON_COOLDOWN", 0)
	else
		stats.set_int("MP1_ORBITAL_CANNON_COOLDOWN", 0)
	end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local statMenu = OnlMenu:add_submenu("Editor de stat")
statMenu:add_float_range("Estado mental", 1.0, 0.0, 100, function() return stats.get_float("MPPLY_PLAYER_MENTAL_STATE") end, function(value) stats.set_float(mpx .. "PLAYER_MENTAL_STATE", value) stats.set_float("MPPLY_PLAYER_MENTAL_STATE", value) end)
statMenu:add_int_range("Dinero conseguido total", 500000, 0, 1000000000, function() return stats.get_int("MPPLY_TOTAL_EVC") end, function(value) stats.set_int("MPPLY_TOTAL_EVC",value) end)
statMenu:add_int_range("Dinero gastado", 500000, 0, 1000000000, function() return stats.get_int("MPPLY_TOTAL_SVC") end, function(value) stats.set_int("MPPLY_TOTAL_SVC",value) end)
statMenu:add_int_range("Jugadores moridos", 10, 0, 999999, function() return stats.get_int("MPPLY_KILLS_PLAYERS") end, function(value) stats.set_int("MPPLY_KILLS_PLAYERS", value) end)
statMenu:add_int_range("Cuantas veces has muerto por j", 10, 0, 999999, function() return stats.get_int("MPPLY_DEATHS_PLAYER") end, function(value) stats.set_int("MPPLY_DEATHS_PLAYER", value) end)
statMenu:add_float_range("PvP K/D Ratio", 0.01, 0, 9999, function() return stats.get_float("MPPLY_KILL_DEATH_RATIO") end, function(value) stats.set_float("MPPLY_KILL_DEATH_RATIO", value) end)
statMenu:add_int_range("Deathmatches Publicados", 10, 0, 999999, function() return stats.get_int("MPPLY_AWD_FM_CR_DM_MADE") end, function(value) stats.set_int("MPPLY_AWD_FM_CR_DM_MADE", value) end)
statMenu:add_int_range("carreras Publicadas", 10, 0, 999999, function() return stats.get_int("MPPLY_AWD_FM_CR_RACES_MADE") end, function(value) stats.set_int("MPPLY_AWD_FM_CR_RACES_MADE", value) end)
statMenu:add_int_range("Capturas publicadas", 10, 0, 999999, function() return stats.get_int("MPPLY_NUM_CAPTURES_CREATED") end, function(value) stats.set_int("MPPLY_NUM_CAPTURES_CREATED", value) end)
statMenu:add_int_range("LTS Publicadas", 10, 0, 999999, function() return stats.get_int("MPPLY_LTS_CREATED") end, function(value) stats.set_int("MPPLY_LTS_CREATED", value) end)
statMenu:add_int_range("Personas que han jugado tus M", 10, 0, 999999, function() return stats.get_int("MPPLY_AWD_FM_CR_PLAYED_BY_PEEP") end, function(value) stats.set_int("MPPLY_AWD_FM_CR_PLAYED_BY_PEEP", value) end)
statMenu:add_int_range("Likes a tus contenidos", 10, 0, 999999, function() return stats.get_int("MPPLY_AWD_FM_CR_MISSION_SCORE") end, function(value) stats.set_int("MPPLY_AWD_FM_CR_MISSION_SCORE", value) end)
statMenu:add_int_range("Reiniciar LSCM (No para desbloquear)", 1, 1, 11, function() return 0 end, function(V) if V == 1 then vt = 5 elseif V == 2 then vt = 415 elseif V == 3 then vt = 1040 elseif V == 4 then vt = 3665 elseif V == 5 then vt = 10540 elseif V == 6 then vt = 20540 elseif V == 7 then vt = 33665 elseif V == 8 then vt = 49915 elseif V == 9 then vt = 69290 elseif V == 10 then vt = 91790 else vt = 117430 end stats.set_int(mpx .. "CAR_CLUB_REP", vt) end) statMenu:add_action("~[1/5/10/25/50/75/100/125/150/175/200]", function() end) statMenu:add_action("-{Cambia de sesion para aplicar}", function() end)
statMenu:add_action("-----------------------------------------", function() end)
statMenu:add_int_range("Remover varo", 1000000, 1000000, 2000000000, function() return globals.get_int(282478) end, function(value) globals.set_int(282478, value) end) statMenu:add_action("Set the value then buy ballistic armour", function() end)
statMenu:add_action("-----------------------------------------", function() end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local distMenu = OnlMenu:add_submenu("Stats de distansia")
distMenu:add_float_range("Viajado(metros)", 10.00, 0.00, 99999.00, function() return stats.get_float("MPPLY_CHAR_DIST_TRAVELLED")/1000 end, function(value) stats.set_float("MPPLY_CHAR_DIST_TRAVELLED", value*1000) end)
distMenu:add_float_range("Nadado", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_SWIMMING")/1000 end, function(value) stats.set_float(mpx.."DIST_SWIMMING", value*1000) end)
distMenu:add_float_range("Caminando", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_WALKING")/1000 end, function(value) stats.set_float(mpx.."DIST_WALKING", value*1000) end)
distMenu:add_float_range("Corriendo", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_RUNNING")/1000 end, function(value) stats.set_float(mpx.."DIST_RUNNING", value*1000) end)
distMenu:add_float_range("Caida libre mas sobrevivida", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."LONGEST_SURVIVED_FREEFALL") end, function(value) stats.set_float(mpx.."LONGEST_SURVIVED_FREEFALL", value) end)
distMenu:add_float_range("Conduccion de coches", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_CAR")/1000 end, function(value) stats.set_float(mpx.."DIST_CAR", value*1000) end)
distMenu:add_float_range("Conducir motos", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_BIKE")/1000 end, function(value) stats.set_float(mpx.."DIST_BIKE", value*1000) end)
distMenu:add_float_range("Volando helis", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_HELI")/1000 end, function(value) stats.set_float(mpx.."DIST_HELI", value*1000) end)
distMenu:add_float_range("Volando aviones", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_PLANE")/1000 end, function(value) stats.set_float(mpx.."DIST_PLANE", value*1000) end)
distMenu:add_float_range("Conduciendo botes", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_BOAT")/1000 end, function(value) stats.set_float(mpx.."DIST_BOAT", value*1000) end)
distMenu:add_float_range("Conduciendo ATVs", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_QUADBIKE")/1000 end, function(value) stats.set_float(mpx.."DIST_QUADBIKE", value*1000) end)
distMenu:add_float_range("Conduciendo Bicycletas", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_BICYCLE")/1000 end, function(value) stats.set_float(mpx.."DIST_BICYCLE", value*1000) end)
distMenu:add_float_range("Parada mas lejana", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."LONGEST_STOPPIE_DIST")/1000 end, function(value) stats.set_float(mpx.."LONGEST_STOPPIE_DIST", value*1000) end)
distMenu:add_float_range("Sobre 1 rueda mas lejana", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."LONGEST_WHEELIE_DIST")/1000 end, function(value) stats.set_float(mpx.."LONGEST_WHEELIE_DIST", value*1000) end)
distMenu:add_float_range("Conduccion mas larga sin estrellarte", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."LONGEST_DRIVE_NOCRASH")/1000 end, function(value) stats.set_float(mpx.."LONGEST_DRIVE_NOCRASH", value*1000) end)
distMenu:add_float_range("Salto mas largo en veh", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."FARTHEST_JUMP_DIST") end, function(value) stats.set_float(mpx.."FARTHEST_JUMP_DIST", value) end)
distMenu:add_float_range("Salto mas alto en veh", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."HIGHEST_JUMP_REACHED") end, function(value) stats.set_float(mpx.."HIGHEST_JUMP_REACHED", value) end)
distMenu:add_float_range("Salto hidraulico mas alto", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."LOW_HYDRAULIC_JUMP") end, function(value) stats.set_float(mpx.."LOW_HYDRAULIC_JUMP", value) end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local timeMenu = OnlMenu:add_submenu("Stats de tienpo (Diaz)")
timeMenu:add_int_range("Tiempo en primera persona", 1, 0, 24, function() return math.floor(stats.get_int("MP_FIRST_PERSON_CAM_TIME")/86400000) end, function(value) stats.set_int("MP_FIRST_PERSON_CAM_TIME", value*86400000) end)
timeMenu:add_int_range("Tiempo en gta online", 1, 0, 24, function() return math.floor(stats.get_int("MP_PLAYING_TIME")/86400000) end, function(value) stats.set_int("MP_PLAYING_TIME", value*86400000) end)
timeMenu:add_int_range("Tiempo en dm's", 1, 0, 24, function() return math.floor(stats.get_int("MPPLY_TOTAL_TIME_SPENT_DEATHMAT")/86400000) end, function(value) stats.set_int("MPPLY_TOTAL_TIME_SPENT_DEATHMAT", value*86400000) end)
timeMenu:add_int_range("Tiempo en carreras", 1, 0, 24, function() return math.floor(stats.get_int("MPPLY_TOTAL_TIME_SPENT_RACES")/86400000) end, function(value) stats.set_int("MPPLY_TOTAL_TIME_SPENT_RACES", value*86400000) end)
timeMenu:add_int_range("Tiempo en modo creador", 1, 0, 24, function() return math.floor(stats.get_int("MPPLY_TOTAL_TIME_MISSION_CREATO")/86400000) end, function(value) stats.set_int("MPPLY_TOTAL_TIME_MISSION_CREATO", value*86400000) end)
timeMenu:add_int_range("Sesion mas larga solo", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."LONGEST_PLAYING_TIME")/86400000) end, function(value) stats.set_int(mpx.."LONGEST_PLAYING_TIME", value*86400000) end)
timeMenu:add_int_range("Tiempo como personaje", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TOTAL_PLAYING_TIME")/86400000) end, function(value) stats.set_int(mpx.."TOTAL_PLAYING_TIME", value*86400000) end)
timeMenu:add_int_range("Tiempo promedio en sesiones", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."AVERAGE_TIME_PER_SESSON")/86400000) end, function(value) stats.set_int(mpx.."AVERAGE_TIME_PER_SESSON", value*86400000) end)
timeMenu:add_int_range("Tiempo nadando", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_SWIMMING")/86400000) end, function(value) stats.set_int(mpx.."TIME_SWIMMING", value*86400000) end)
timeMenu:add_int_range("Tiempo bajo el awa", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_UNDERWATER")/86400000) end, function(value) stats.set_int(mpx.."TIME_UNDERWATER", value*86400000) end)
timeMenu:add_int_range("Tiempo caminando", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_WALKING")/86400000) end, function(value) stats.set_int(mpx.."TIME_WALKING", value*86400000) end)
timeMenu:add_int_range("Tiempo en covertura", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_IN_COVER")/86400000) end, function(value) stats.set_int(mpx.."TIME_IN_COVER", value*86400000) end)
timeMenu:add_int_range("Tiempo con estreias", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TOTAL_CHASE_TIME")/86400000) end, function(value) stats.set_int(mpx.."TOTAL_CHASE_TIME", value*86400000) end)
timeMenu:add_float_range("Ultima duracion wantiado", 1.0, 0.0, 24.0, function() return math.floor(stats.get_float(mpx.."LAST_CHASE_TIME")/86400000) end, function(value) stats.set_float(mpx.."LAST_CHASE_TIME", value*86400000) end)
timeMenu:add_float_range("Duracion wantiada mas larga", 1.0, 0.0, 24.0, function() return math.floor(stats.get_float(mpx.."LONGEST_CHASE_TIME")/86400000) end, function(value) stats.set_float(mpx.."LONGEST_CHASE_TIME", value*86400000) end)
timeMenu:add_float_range("5 estreias", 1.0, 0.0, 24.0, function() return math.floor(stats.get_float(mpx.."TOTAL_TIME_MAX_STARS")/86400000) end, function(value) stats.set_float(mpx.."TOTAL_TIME_MAX_STARS", value*86400000) end)
timeMenu:add_action("Me dio pereza, es tiempo", function() end)
timeMenu:add_int_range("Condusiendo coches", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_CAR")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_CAR", value*86400000) end)
timeMenu:add_int_range("En moto", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_BIKE")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_BIKE", value*86400000) end)
timeMenu:add_int_range("En chop-chops", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_HELI")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_HELI", value*86400000) end)
timeMenu:add_int_range("En aviones", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_PLANE")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_PLANE", value*86400000) end)
timeMenu:add_int_range("En botes", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_BOAT")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_BOAT", value*86400000) end)
timeMenu:add_int_range("Conduciendo ATVs", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_QUADBIKE")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_QUADBIKE", value*86400000) end)
timeMenu:add_int_range("En motos", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_BICYCLE")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_BICYCLE", value*86400000) end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local heistMenu = OnlMenu:add_submenu("Golpes")
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local cayoPericoMenu = heistMenu:add_submenu("Golpe a la isla del pendejo") cayoPericoMenu:add_array_item("Configs", {"H.Panther Only", "H.PinkD Only", "H.B.Bonds Only", "H.R.Necklace Only", "H.Tequila Only", "N.Panther Only", "N.PinkD Only", "N.B.Bonds Only", "N.R.Necklace Only", "N.Tequila Only"}, function() return xox_15 end, function(v) if v == 1 then stats.set_int(mpx.."H4_PROGRESS", 131055) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 5) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT_V", 403500) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 2 then stats.set_int(mpx.."H4_PROGRESS", 131055) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 3) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 3 then stats.set_int(mpx.."H4_PROGRESS", 131055) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 2) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 4 then stats.set_int(mpx.."H4_PROGRESS", 131055) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 1) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 5 then stats.set_int(mpx.."H4_PROGRESS", 131055) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 0) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 6 then stats.set_int(mpx.."H4_PROGRESS", 126823) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 5) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 7 then stats.set_int(mpx.."H4_PROGRESS", 126823) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 3) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 8 then stats.set_int(mpx.."H4_PROGRESS", 126823) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 2) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 9 then stats.set_int(mpx.."H4_PROGRESS", 126823) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 1) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT_V", 403500) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 10 then stats.set_int(mpx.."H4_PROGRESS", 126823) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 0) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) end xox_15 = v end)
cayoPericoMenu:add_array_item("Objetivos principales", {"Tequila", "Ruby Necklace", "Bearer Bonds", "Pink Diamond", "Panther Statue"}, function() return xox_0 end, function(value) xox_0 = value if value == 1 then stats.set_int(mpx .. "H4CNF_TARGET", 0) elseif value == 2 then stats.set_int(mpx .. "H4CNF_TARGET", 1) elseif value == 3 then stats.set_int(mpx .. "H4CNF_TARGET", 2) elseif value == 4 then stats.set_int(mpx .. "H4CNF_TARGET", 3) elseif value == 5 then stats.set_int(mpx .. "H4CNF_TARGET", 5) end end)
local StMenu = cayoPericoMenu:add_submenu("Objetivos secundarios") StMenu:add_array_item("All Compound Storages", {"Gold", "Paintings", "Cocaine", "Weed", "Cash"}, function() return xox_1 end, function(value) if value == 1 then stats.set_int(mpx .. "H4LOOT_GOLD_C", -1) stats.set_int(mpx .. "H4LOOT_GOLD_C_SCOPED", -1) elseif value == 2 then stats.set_int(mpx .. "H4LOOT_PAINT", -1) stats.set_int(mpx .. "H4LOOT_PAINT_SCOPED", -1) stats.set_int(mpx .. "H4LOOT_PAINT_V", 403500) elseif value == 3 then stats.set_int(mpx .. "H4LOOT_COKE_C", -1) stats.set_int(mpx .. "H4LOOT_COKE_C_SCOPED", -1) elseif value == 4 then stats.set_int(mpx .. "H4LOOT_WEED_C", -1) stats.set_int(mpx .. "H4LOOT_WEED_C_SCOPED", -1) elseif value == 5 then stats.set_int(mpx .. "H4LOOT_CASH_C", -1) stats.set_int(mpx .. "H4LOOT_CASH_C_SCOPED", -1) end xox_1 = value end)
cayoPericoMenu:add_action("Todas las preparativas", function() stats.set_int(mpx .. "H4CNF_BS_GEN", -1) stats.set_int(mpx .. "H4CNF_BS_ENTR", 63) stats.set_int(mpx .. "H4CNF_APPROACH", -1) end) cayoPericoMenu:add_action("---", function() end)
cayoPericoMenu:add_toggle("Remover camaras", function() return e6 end, function() e6 = not e6 Cctv(e6) end) cayoPericoMenu:add_action("Skipiar escena del drenaje", function() if fmC2020:is_active() then if fmC2020:get_int(27500) >= 3 or fmC2020:get_int(27500) <= 6 then fmC2020:set_int(27500, 6) end end end) cayoPericoMenu:add_action("Bypasiar clonasion de weyas ", function() if fmC2020 and fmC2020:is_active() then if fmC2020:get_int(23385) == 4 then fmC2020:set_int(23385, 5) end end end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- This are currently enabled in beta
local casinoHeistMenu = heistMenu:add_submenu("Diamond Casino Heist") casinoHeistMenu:add_array_item("Configs", {"H.SnS-Best Crew|Diamonds", "H.SnS-Worst Crew|Diamonds", "H.SnS-Best Crew|Gold", "H.SnS-Worst Crew|Gold", "H.SnS-Best Crew|Painting", "H.SnS-Worst Crew|Painting", "H.BigCon-Best Crew|Diamonds", "H.BigCon-No Crew|Diamonds", "H.BigCon-Best Crew|Gold", "H.BigCon-No Crew|Gold", "H.BigCon-Best Crew|Painting", "H.BigCon-No Crew|Painting", "H.Agrsv-Best Crew|Diamonds", "H.Agrsv-Worst Crew|Diamonds", "H.Agrsv-Best Crew|Gold", "H.Agrsv-Worst Crew|Gold", "H.Agrsv-Best Crew|Painting", "H.Agrsv-Worst Crew|Painting", "N.SnS-Best Crew|Diamonds", "N.SnS-Worst Crew|Diamonds", "N.SnS-Best Crew|Gold", "N.SnS-Worst Crew|Gold", "N.SnS-Best Crew|Painting", "N.SnS-Worst Crew|Painting", "N.BigCon-Best Crew|Diamonds", "N.BigCon-No Crew|Diamonds", "N.BigCon-Best Crew|Gold", "N.BigCon-No Crew|Gold", "N.BigCon-Best Crew|Painting", "N.BigCon-No Crew|Painting", "N.Agrsv-Best Crew|Diamonds", "N.Agrsv-Worst Crew|Diamonds", "N.Agrsv-Best Crew|Gold", "N.Agrsv-Worst Crew|Gold", "N.Agrsv-Best Crew|Painting", "N.Agrsv-Worst Crew|Painting"}, function() return xox_16 end, function(v) if v == 1 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 2 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 3 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 4 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 5 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 6 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 7 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx.."H3_LAST_APPROACH", 3) stats.set_int(mpx.."H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 8 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx.."H3_LAST_APPROACH", 3) stats.set_int(mpx.."H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 9 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx.."H3_LAST_APPROACH", 3) stats.set_int(mpx.."H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 10 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 11 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 12 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 13 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 14 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 15 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 16 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 17 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 18 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 19 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 20 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 21 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1)stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 22 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1)stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 23 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 24 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 25 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4)  stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 26 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 27 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx.."H3_LAST_APPROACH", 3) stats.set_int(mpx.."H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 28 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 29 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 30 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 31 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 32 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 33 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 34 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 35 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 36 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) end xox_16 = v end)
--casinoHeistMenu:add_array_item("Objetivo", {"Cash", "Gold", "Art", "Diamonds"}, function() return xox_8 end, function(v) if v == 1 then stats.set_int(mpx .. "H3OPT_TARGET", 0) elseif v == 2 then stats.set_int(mpx .. "H3OPT_TARGET", 1) elseif v == 3 then stats.set_int(mpx .. "H3OPT_TARGET", 2) elseif v == 4 then stats.set_int(mpx .. "H3OPT_TARGET", 3) end xox_8 = v end)
--casinoHeistMenu:add_array_item("Idea", {"Normal-Silent n Sneaky", "Normal-Big Con", "Normal-Aggressive", "Hard-Silent n Sneaky", "Hard-Big Con", "Hard-Aggressive"}, function() return xox_9 end, function(f) if f == 1 then stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1) elseif f == 2 then stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 2) elseif f == 3 then stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) elseif f == 4 then stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) elseif f == 5 then stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 2) elseif f == 6 then stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) end xox_9 = f end)
--casinoHeistMenu:add_array_item("Dealer", {"Karl Abolaji", "Gustavo Mota", "Charlie Reed", "Chester McCoy", "Patrick McReary", "None"}, function() return xox_10 end, function(d) if d == 1 then stats.set_int(mpx .. "H3OPT_CREWWEAP", 1) elseif d == 2 then stats.set_int(mpx .. "H3OPT_CREWWEAP", 2) elseif d == 3 then stats.set_int(mpx .. "H3OPT_CREWWEAP", 3) elseif d == 4 then stats.set_int(mpx .. "H3OPT_CREWWEAP", 4) elseif d == 5 then stats.set_int(mpx .. "H3OPT_CREWWEAP", 5) elseif d == 6 then stats.set_int(mpx .. "H3OPT_CREWWEAP", 6) end xox_10 = d end)
--casinoHeistMenu:add_array_item("Conductor", {"Karim Deniz", "Taliana Martinez", "Eddie Toh", "Zach Nelson", "Chester McCoy", "None"}, function() return xox_11 end, function(a) if a == 1 then stats.set_int(mpx .. "H3OPT_CREWDRIVER", 1) elseif a == 2 then stats.set_int(mpx .. "H3OPT_CREWDRIVER", 2) elseif a == 3 then stats.set_int(mpx .. "H3OPT_CREWDRIVER", 3) elseif a == 4 then stats.set_int(mpx .. "H3OPT_CREWDRIVER", 4) elseif a == 5 then stats.set_int(mpx .. "H3OPT_CREWDRIVER", 5) elseif a == 6 then stats.set_int(mpx .. "H3OPT_CREWDRIVER", 6) end xox_11 = a end)
--casinoHeistMenu:add_array_item("Hacker", {"Rickie Lukens", "Christian Feltz", "Yohan Blair", "Avi Schwartzman", "Page Harris", "None"}, function() return xox_12 end, function(value) if value == 1 then stats.set_int(mpx .. "H3OPT_CREWHACKER", 1) elseif value == 2 then stats.set_int(mpx .. "H3OPT_CREWHACKER", 2) elseif value == 3 then stats.set_int(mpx .. "H3OPT_CREWHACKER", 3) elseif value == 4 then stats.set_int(mpx .. "H3OPT_CREWHACKER", 4) elseif value == 5 then stats.set_int(mpx .. "H3OPT_CREWHACKER", 5) elseif value == 6 then stats.set_int(mpx .. "H3OPT_CREWHACKER", 6) end xox_12 = value end)
--casinoHeistMenu:add_array_item("Maskaras", {"Geometic Set", "Hunter Set", "Oni Half Mask Set", "Emoji Set", "Ornate Skull Set", "Lucky Fruit Set", "Guerilla Set", "Clown Set", "Animal Set", "Riot Set", "Oni Full Mask Set", "Hockey Set" }, function() return xox_13 end, function(value) if value == 1 then stats.set_int(mpx .. "H3OPT_MASKS", 1) elseif value == 2 then stats.set_int(mpx .. "H3OPT_MASKS", 2) elseif value == 3 then stats.set_int(mpx .. "H3OPT_MASKS", 3) elseif value == 4 then stats.set_int(mpx .. "H3OPT_MASKS", 4) elseif value == 5 then stats.set_int(mpx .. "H3OPT_MASKS", 5) elseif value == 6 then stats.set_int(mpx .. "H3OPT_MASKS", 6) elseif value == 7 then stats.set_int(mpx .. "H3OPT_MASKS", 7) elseif value == 8 then stats.set_int(mpx .. "H3OPT_MASKS", 8) elseif value == 9 then stats.set_int(mpx .. "H3OPT_MASKS", 9) elseif value == 10 then stats.set_int(mpx .. "H3OPT_MASKS", 10) elseif value == 11 then stats.set_int(mpx .. "H3OPT_MASKS", 11) elseif value == 12 then stats.set_int(mpx .. "H3OPT_MASKS", 12) end xox_13 = value end)
--casinoHeistMenu:add_action("       ---[[Completar Preparativas]]---", function() stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx .. "H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx .. "H3OPT_BITSET0", -1) stats.set_int(mpx .. "H3OPT_BITSET1", -1) stats.set_int(mpx .. "H3OPT_COMPLETEDPOSIX", -1) end)
--casinoHeistMenu:add_action("                 ---[[Reinisiar Golpe]]---", function() stats.set_int(mpx .. "H3OPT_BITSET1", 0) stats.set_int(mpx .. "H3OPT_BITSET0", 0) end) casinoHeistMenu:add_action("-----------------------------------------------------", function() end)
--casinoHeistMenu:add_action("~Todos Los Accesos", function() stats.set_int(mpx .. "H3OPT_POI", -1) stats.set_int(mpx .. "H3OPT_ACCESSPOINTS", -1) end)
--casinoHeistMenu:add_action("~Remover Culdown De golpe", function() stats.set_int(mpx .. "H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) end)
--casinoHeistMenu:add_action("~Escoje entre el primero/Desbloquear Cancelamiento lester", function() stats.set_int(mpx .. "CAS_HEIST_NOTS", -1) stats.set_int(mpx .. "CAS_HEIST_FLOW", -1) end) local function DCHC(e) if not localplayer then return end if e then for i = 290626, 290640 do globals.set_int(i, 0) end globals.set_int(290600, 0) else globals.set_int(290600, 5) globals.set_int(290626, 5) globals.set_int(290627, 9) globals.set_int(290628, 7) globals.set_int(290629, 10) globals.set_int(290630, 8) globals.set_int(290631, 5) globals.set_int(290632, 7) globals.set_int(290633, 9) globals.set_int(290634, 6) globals.set_int(290635, 10) globals.set_int(290636, 3) globals.set_int(290637, 7) globals.set_int(290638, 5) globals.set_int(290639, 10) globals.set_int(290640, 9) end end casinoHeistMenu:add_toggle("Remove Lester+Crew Cuts", function() return e8 end, function() e8 = not e8 DCHC(e8) end) casinoHeistMenu:add_action("---", function() end)
--casinoHeistMenu:add_int_range("Vidas Del Host", 1, 1, 10, function() return casinolifes:get_int(26077 + 1322 + 1) end, function(life) if casinolifes and casinolifes:is_active() then casinolifes:set_int(26077 + 1322 + 1,life) end end)
--casinoHeistMenu:add_action("Suicidar", function() menu.suicide_player() end) casinoHeistMenu:add_action("^^^[Useful for Blackscreen Bug]", function() end) casinoHeistMenu:add_action("---", function() end)
--casinoHeistMenu:add_action("Bypasiar Gueyas ", function() if casinolifes and casinolifes:is_active() then if casinolifes:get_int(52899) == 4 then casinolifes:set_int(52899, 5) end end end)
--casinoHeistMenu:add_action("Bypasiar Hack De Puertas ", function() if casinolifes and casinolifes:is_active() then if casinolifes:get_int(53729) ~= 4 then casinolifes:set_int(53729, 5) end end end)
--casinoHeistMenu:add_action("Taladro Rapido", function() if casinolifes:is_active() then casinolifes:set_int(10068 + 7, 4) sleep(0.01) casinolifes:set_int(10068 + 7, 6) menu.send_key_press(1) end end)
--local VLzr = casinolifes:get_int(10105) casinoHeistMenu:add_action("Lazer Rapido ", function() if casinolifes and casinolifes:is_active() then casinolifes:set_int(10075, VLzr) sleep(0.02) casinolifes:set_int(10075, 0) end end)
--local function casCctv(e) if not localplayer then return end if e then menu.remove_cctvs() else menu.remove_cctvs(nil) end end casinoHeistMenu:add_toggle("Remove CCTV", function() return e7 end, function() e7 = not e7 casCctv(e7) end) casinoHeistMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) casinoHeistMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end)
--casinoHeistMenu:add_int_range("Dineroz", 100000, 1000000, 10000000, function() return casinolifes:get_int(22337) end, function(v) casinolifes:set_int(22337, v) end)
--local CDNCMenu = casinoHeistMenu:add_submenu("Cuts") CDNCMenu:add_array_item("Presets", {"85 all", "100 all"}, function() return xox_34 end, function(G) if G == 1 then for i = 1969065, 1969068 do globals.set_int(i, 85) end elseif G == 2 then for i = 1969065, 1969068 do globals.set_int(i, 100) end end xox_34 = value end)
--CDNCMenu:add_int_range("Jugador 1", 5, 15, 300, function() return globals.get_int(1969065) end, function(value) globals.set_int(1969065, value) end) CDNCMenu:add_int_range("Jugador 2", 5, 15, 300, function() return globals.get_int(1969066) end, function(value) globals.set_int(1969066, value) end) CDNCMenu:add_int_range("Jugador 3", 5, 15, 300, function() return globals.get_int(1969067) end, function(value) globals.set_int(1969067, value) end) CDNCMenu:add_int_range("Player 4", 5, 15, 300, function() return globals.get_int(1969068) end, function(value) globals.set_int(1969068, value) end) CDNCMenu:add_action("-----", function() end) CDNCMenu:add_int_range("Non-Host Self Cut", 5, 15, 300, function() return globals.get_int(2722097) end, function(value) globals.set_int(2722097, value) end)
--local CDNPMenu = casinoHeistMenu:add_submenu("Potensial Editor") CDNPMenu:add_int_range("Dineroz Potensial", 1000000000.0, 2115000, 1000000000, function() return globals.get_int(290614) end, function(value) globals.set_int(290614, value) end) CDNPMenu:add_int_range("Art Potential", 1000000000.0, 2350000, 1000000000, function() return globals.get_int(290615) end, function(value) globals.set_int(290615, value) end) CDNPMenu:add_int_range("Gold Potential", 1000000000.0, 2580000, 1000000000, function() return globals.get_int(290616) end, function(value) globals.set_int(290616, value) end) CDNPMenu:add_int_range("Diamond Potential", 1000000000.0, 3290000, 1000000000, function() return globals.get_int(290617) end, function(value) globals.set_int(290617, value) end) 
--casinoHeistMenu:add_array_item("Teleports", {"Vault swipe", "Staff Door Exit", "Laundry room", "Bonus room", "Roof exit"}, function() return xox_14 end, function(value) if value == 1 then localplayer:set_rotation(-1.083554, 0.000000, 0.000000) localplayer:set_position(2468.646973, -279.083374, -71.994194) elseif value == 2 then localplayer:set_rotation(0.069543, -0.000000, -0.000000) localplayer:set_position(2547.803711, -273.988434, -60.022980) elseif value == 3 then localplayer:set_rotation(0.000000, 0.000000, 0.000000) localplayer:set_position(2536.455078, -300.772522, -60.022968) elseif value == 4 then localplayer:set_rotation(0.000000, 0.000000, 0.000000) localplayer:set_position(2521.906494, -287.172882, -60.022964) elseif value == 5 then localplayer:set_rotation(0.000000, 0.000000, 0.000000) localplayer:set_position(2522.338379, -248.534760, -25.414972) end xox_14 = value end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--local ddHeistMenu = heistMenu:add_submenu("Doomsday Heist") ddHeistMenu:add_array_item("Doomsday Act", {"I:Data Breaches", "II:Bogdan Problem", "III:Doomsday Senario"}, function() return xox_22 end, function(value) xox_22 = value if value == 1 then GGP = 503 GGS = 229383 elseif value == 2 then GGP = 240 GGS = 229378 elseif value == 3 then GGP = 16368 GGS = 229380 end stats.set_int(mpx .. "GANGOPS_FLOW_MISSION_PROG", GGP) stats.set_int(mpx .. "GANGOPS_HEIST_STATUS", GGS) stats.set_int(mpx .. "GANGOPS_FLOW_NOTIFICATIONS", 1557) end) ddHeistMenu:add_action("Complete All", function() stats.set_int(mpx.."GANGOPS_FM_MISSION_PROG", -1) end) ddHeistMenu:add_action("Reset Heist", function() stats.set_int(mpx.."GANGOPS_FLOW_MISSION_PROG", 240) stats.set_int(mpx.."GANGOPS_HEIST_STATUS", 0) stats.set_int(mpx.."GANGOPS_FLOW_NOTIFICATIONS", 1557) end) ddHeistMenu:add_action("-----", function() end) ddHeistMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) ddHeistMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end)
--local ddCMenu = ddHeistMenu:add_submenu("Cuts") ddCMenu:add_array_item("Max $ Cuts% All", {"I:Data Breaches", "II:Bogdan Problem", "III:Doomsday Senario"}, function() return xox_23 end, function(value) if value == 1 then globals.set_int(1963626, 313) globals.set_int(1963627, 313) globals.set_int(1963628, 313) globals.set_int(1963629, 313) elseif value == 2 then globals.set_int(1963626, 214) globals.set_int(1963627, 214) globals.set_int(1963628, 214) globals.set_int(1963629, 214) elseif value == 3 then globals.set_int(1963626, 170) globals.set_int(1963627, 170) globals.set_int(1963628, 170) globals.set_int(1963629, 170) end xox_23 = value end)
--ddCMenu:add_action("                      ~Manual %~ ", function() end) ddCMenu:add_int_range("Doomsday Player 1", 1.0, 15, 313, function() return globals.get_int(1963626) end, function(value) globals.set_int(1963626, value) end) ddCMenu:add_int_range("Doomsday Player 2", 1.0, 15, 313, function() return globals.get_int(1963627) end, function(value) globals.set_int(1963627, value) end) ddCMenu:add_int_range("Doomsday Player 3", 1.0, 15, 313, function() return globals.get_int(1963628) end, function(value) globals.set_int(1963628, value) end) ddCMenu:add_int_range("Doomsday Player 4", 1.0, 15, 313, function() return globals.get_int(1963629) end, function(value) globals.set_int(1963629, value) end)
--local appHeistMenu = heistMenu:add_submenu("Appartment Heist") appHeistMenu:add_action("Skip to Current Heist Finale", function() stats.set_int(mpx .. "HEIST_PLANNING_STAGE", -1) end) appHeistMenu:add_action("-----", function() end) appHeistMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) appHeistMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end) appHeistMenu:add_action("-----", function() end)
--local ahMmMenu = appHeistMenu:add_submenu("$$$ Method (Self only)") ahMmMenu:add_array_item(" ~Fleeca", {"5 Mil", "10 Mil", "15 Mil"}, function() return xox_24 end, function(value) if value == 1 then globals.set_int(1934636 + 3008 +1, 3500) elseif value == 2 then globals.set_int(1934636 + 3008 +1, 7000) elseif value == 3 then globals.set_int(1934636 + 3008 +1, 10434) end xox_24 = value end) ahMmMenu:add_array_item(" ~Prison Break", {"5 Mil", "10 Mil", "15 Mil"}, function() return xox_27 end, function(value) if value == 1 then globals.set_int(1934636 + 3008 +1, 1000) elseif value == 2 then globals.set_int(1934636 + 3008 +1, 2000) elseif value == 3 then globals.set_int(1934636 + 3008 +1, 3000) end xox_27 = value end) ahMmMenu:add_array_item(" ~Humane Labs Raid", {"5 Mil", "10 Mil", "15 Mil"}, function() return xox_28 end, function(value) if value == 1 then globals.set_int(1934636 + 3008 +1, 750) elseif value == 2 then globals.set_int(1934636 + 3008 +1, 1482) elseif value == 3 then globals.set_int(1934636 + 3008 +1, 2220) end xox_28 = value end) ahMmMenu:add_array_item(" ~Series A Funding", {"5 Mil", "10 Mil", "15 Mil"}, function() return xox_29 end, function(value) if value == 1 then globals.set_int(1934636 + 3008 +1, 991) elseif value == 2 then globals.set_int(1934636 + 3008 +1, 1981) elseif value == 3 then globals.set_int(1934636 + 3008 +1, 2970) end xox_29 = value end) ahMmMenu:add_array_item(" ~The Pacific Standard", {"5 Mil", "10 Mil", "15 Mil"}, function() return xox_30 end, function(value) if value == 1 then globals.set_int(1934636 + 3008 +1, 400) elseif value == 2 then globals.set_int(1934636 + 3008 +1, 800) elseif value == 3 then globals.set_int(1934636 + 3008 +1, 1200) end xox_30 = value end)
--local ahCMenu = appHeistMenu:add_submenu("Cuts") ahCMenu:add_int_range("Apt Player 1", 1.0, 15, 10434, function() return globals.get_int(1937645) end, function(value) globals.set_int(1937645, value) end) ahCMenu:add_int_range("Apt Player 2", 1.0, 15, 10434, function() return globals.get_int(1937646) end, function(value) globals.set_int(1937646, value) end) ahCMenu:add_int_range("Apt Player 3", 1.0, 15, 10434, function() return globals.get_int(1937647) end, function(value) globals.set_int(1937647, value) end) ahCMenu:add_int_range("Apt Player 4", 1.0, 15, 10434, function() return globals.get_int(1937648) end, function(value) globals.set_int(1937648, value) end) ahCMenu:add_action("All 100", function() for i = 1937645, 1937648 do globals.set_int(i, 100) end end)
--local CMMenu = mainMenu:add_submenu("Contracts") local agencyMenu = CMMenu:add_submenu("Agency") local secMenu = agencyMenu:add_submenu("Security Contracts") secMenu:add_int_range("Contract 1", 5000, 35000, 130000, function() return globals.get_int(1977270) end, function(value) globals.set_int(1977270, value) end) secMenu:add_int_range("Contract 2", 5000, 35000, 130000, function() return globals.get_int(1977273) end, function(value) globals.set_int(1977273, value) end) secMenu:add_int_range("Contract 3", 5000, 35000, 130000, function() return globals.get_int(1977276) end, function(value) globals.set_int(1977276, value) end) local function SecCooldown(e) if not localplayer then return end if e then globals.set_int(293474, 0) else globals.set_int(293474, 300000) end end secMenu:add_toggle("Remove Cooldown", function() return e9 end, function() e9 = not e9 SecCooldown(e9) end) secMenu:add_action("-----", function() end) secMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) secMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end) secMenu:add_action("-------No. of security contracts done---------", function() end) secMenu:add_int_range("Asset Protection", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_ASSETS_PROTECTED") end, function(v) stats.set_int(mpx.."FIXER_SC_ASSETS_PROTECTED", v) end) secMenu:add_int_range("Gang Termination", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_GANG_TERMINATED") end, function(v) stats.set_int(mpx.."FIXER_SC_GANG_TERMINATED", v) end) secMenu:add_int_range("Liquidize Assets", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_EQ_DESTROYED") end, function(v) stats.set_int(mpx.."FIXER_SC_EQ_DESTROYED", v) end) secMenu:add_int_range("Recover Valuables", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_VAL_RECOVERED") end, function(v) stats.set_int(mpx.."FIXER_SC_VAL_RECOVERED", v) end) secMenu:add_int_range("Rescue Operation", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_VIP_RESCUED") end, function(v) stats.set_int(mpx.."FIXER_SC_VIP_RESCUED", v) end) secMenu:add_int_range("Vehicle Recovery", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_VEH_RECOVERED") end, function(v) stats.set_int(mpx.."FIXER_SC_VEH_RECOVERED", v) end) secMenu:add_int_range("Contract Earnings", 250000, 0, 20000000, function() return stats.get_int(mpx.."FIXER_EARNINGS") end, function(v) stats.set_int(mpx.."FIXER_EARNINGS", v) end) local vipMenu = agencyMenu:add_submenu("VIP Contracts") vipMenu:add_array_item("Skip Prep", {"The Nightclub", "The Marina", "Nightlife Leak", "The Country Club", "Guest List", "High Society Leak", "Davis", "The Ballas", "The South Central Leak", "Studio Time", "Dont F*ck With Dre"}, function() return xox_25 end, function(value) if value == 1 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 3) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 2 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 4) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 3 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 12) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 4 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 28) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 5 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 60) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 6 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 124) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 7 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 252) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 8 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 508) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 9 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 2044) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 10 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", -1) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) stats.set_int(mpx .. "FIXER_STORY_STRAND", -1) end xox_25 = value end) local function VipMod(e) if not localplayer then return end if e then  globals.set_int(293534, 2400000) else globals.set_int(293534, 1000000) end end vipMenu:add_toggle("2.4M Finale", function() return e10 end, function() e10 = not e10 VipMod(e10) end) local function VipCD(e) if not localplayer then return end if e then globals.set_int(293490, 0) else globals.set_int(293490, 300000) end end vipMenu:add_toggle("Remove Cooldown", function() return e11 end, function() e11 = not e11 VipCD(e11) end) vipMenu:add_action("-----", function() end) vipMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) vipMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end)
--local phMenu = agencyMenu:add_submenu("Payphone Hits") phMenu:add_int_range("Payphone Bonus", 35000, 0, 105000, function() return globals.get_int(293517) end, function(value) globals.set_int(293517, value) end) phMenu:add_int_range("Payphone Payment", 22500, 0, 100000, function() return globals.get_int(293516) end, function(value) globals.set_int(293516, value) end) local function pCD(e) if not localplayer then return end if e then globals.set_int(293568, 0) else globals.set_int(293568, 1200000) end end phMenu:add_toggle("Remove Cooldown", function() return e12 end, function() e12 = not e12 pCD(e12) end) phMenu:add_action("-----", function() end) phMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) phMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end) phMenu:add_action("------------Payphone Hits Stats-------------", function() end) phMenu:add_int_range("Payphone hits Completed", 1, 0, 999, function() return stats.get_int(mpx.."FIXERTELEPHONEHITSCOMPL") end, function(v) stats.set_int(mpx.."FIXERTELEPHONEHITSCOMPL", v) end)
--local LSTMenu = CMMenu:add_submenu("Autoshop") LSTMenu:add_action("The Union Depository Contract", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 0) end) LSTMenu:add_action("The Superdollar Deal", function() stats.set_int(mpx .. "TUNER_GEN_BS", 4351) stats.set_int(mpx .. "TUNER_CURRENT", 1) end) LSTMenu:add_action("The Bank Contract", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 2) end) LSTMenu:add_action("The ECU Job", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 3) end) LSTMenu:add_action("The Prison Contract", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 4) end) LSTMenu:add_action("The Agency Deal", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 5) end) LSTMenu:add_action("The Lost Contract", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 6) end) LSTMenu:add_action("The Data Contract", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 7) end) LSTMenu:add_action("---", function() end) LSTMenu:add_action(" -[Modify Payout]-", function()	globals.set_int(292836,1000000) globals.set_int(292837,1000000) globals.set_int(292838,1000000) globals.set_int(292839,1000000) globals.set_int(292840,1000000) globals.set_int(292841,1000000) globals.set_int(292842,1000000) globals.set_int(292843,1000000) globals.set_int(292835,1000000) globals.set_float(292832,0) end) LSTMenu:add_action(" ~ ^Choose the above to get 1m", function() end) LSTMenu:add_action("---------------Contracts Stats-----------------", function() end) LSTMenu:add_int_range("Contracts Done", 1, 0, 9999, function() return stats.get_int(mpx.."TUNER_COUNT") end, function(v) stats.set_int(mpx.."TUNER_COUNT", v) end) LSTMenu:add_int_range("Contracts Earnings", 500000, 0, 1000000000, function() return stats.get_int(mpx.."TUNER_EARNINGS") end, function(v) stats.set_int(mpx.."TUNER_EARNINGS", v) end) LSTMenu:add_action("-----", function() end) LSTMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) LSTMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end)
--local MMMenu = mainMenu:add_submenu("Money Methods") local mmCmenu = MMMenu:add_submenu("Ceo Crate $$$")
--mmCmenu:add_int_range("Set $$", 100000, 10000, 5900000, function() return globals.get_int(277741) end, function(Val) local a = Val local b = math.floor(Val / 2) local c = math.floor(Val / 3) local d = math.floor(Val / 4) local e = math.floor(Val / 5) local f = math.floor(Val / 6) local g = math.floor(Val / 7) local h = math.floor(Val / 8) local i = math.floor(Val / 9) local j = math.floor(Val / 10) local k = math.floor(Val / 11) local l = math.floor(Val / 12) local m = math.floor(Val / 13) local n = math.floor(Val / 14) local o = math.floor(Val / 15) local p = math.floor(Val / 16) local q = math.floor(Val / 17) local r = math.floor(Val / 18) local s = math.floor(Val / 19) local t = math.floor(Val / 20) local u = math.floor(Val / 21) globals.set_int(277741, a) globals.set_int(277742, b) globals.set_int(277743, c) globals.set_int(277744, d) globals.set_int(277745, e) globals.set_int(277746, f) globals.set_int(277747, g) globals.set_int(277748, h) globals.set_int(277749, i) globals.set_int(277750, j) globals.set_int(277751, k) globals.set_int(277752, l) globals.set_int(277753, m) globals.set_int(277754, n) globals.set_int(277755, o) globals.set_int(277756, p) globals.set_int(277757, q) globals.set_int(277758, r) globals.set_int(277759, s) globals.set_int(277760, t) globals.set_int(277761, u) if Val > 5400000 then menu.empty_session() end end)
--function CCooldown(e) if not localplayer then return end if e then globals.set_int(277506, 0) globals.set_int(277507, 0) else globals.set_int(277506, 300000) globals.set_int(277507, 1800000) end end
--mmCmenu:add_toggle("Remove Cooldowns", function() return e13 end, function() e13 = not e13 CCooldown(e13) end)
--mmCmenu:add_toggle("Random Unique Cargo Toggle", function() return globals.get_boolean(1946798) end, function(value) globals.set_boolean(1946798, value) end) mmCmenu:add_array_item("Select Unique Cargo", {"Ornamental Egg", "Gold Minigun", "Large Diamond", "Rage Hide", "Film Reel", "Rare Pocket Watch"}, function() return xox_33 end, function(value) xox_33 = value if value == 1 then globals.set_int(1946798, 1) globals.set_int(1946644, 2) elseif value == 2 then globals.set_int(1946798, 1) globals.set_int(1946644, 4) elseif value == 3 then globals.set_int(1946798, 1) globals.set_int(1946644, 6) elseif value == 4 then globals.set_int(1946798, 1) globals.set_int(1946644, 7) elseif value == 5 then globals.set_int(1946798, 1) globals.set_int(1946644, 8) else globals.set_int(1946798, 1) globals.set_int(1946644, 9) end end) mmCmenu:add_action("---", function() end)
--mmCmenu:add_action("Auto-Reset stats-20M/1000Sales", function() stats.set_int(mpx .. "LIFETIME_BUY_COMPLETE", 1000) stats.set_int(mpx .. "LIFETIME_BUY_UNDERTAKEN", 1000) stats.set_int(mpx .. "LIFETIME_SELL_COMPLETE", 1000) stats.set_int(mpx .. "LIFETIME_SELL_UNDERTAKEN", 1000) stats.set_int(mpx .. "LIFETIME_CONTRA_EARNINGS", 20000000) globals.set_int(1575012, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)
--mmCmenu:add_int_range("Manually Reset stats-No. of Sales", 1, 0, 1000, function() return stats.get_int(mpx .. "LIFETIME_SELL_COMPLETE") end, function(value) stats.set_int(mpx .. "LIFETIME_BUY_COMPLETE", value) stats.set_int(mpx .. "LIFETIME_BUY_UNDERTAKEN", value) stats.set_int(mpx .. "LIFETIME_SELL_COMPLETE", value) stats.set_int(mpx .. "LIFETIME_SELL_UNDERTAKEN", value) stats.set_int(mpx .. "LIFETIME_CONTRA_EARNINGS", value * 20000) globals.set_int(1575012, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--local ddHeistMenu = heistMenu:add_submenu("Golpe Final") ddHeistMenu:add_array_item("Doomsday Act", {"I:Data Breaches", "II:Bogdan Problem", "III:Doomsday Senario"}, function() return xox_22 end, function(value) xox_22 = value if value == 1 then GGP = 503 GGS = 229383 elseif value == 2 then GGP = 240 GGS = 229378 elseif value == 3 then GGP = 16368 GGS = 229380 end stats.set_int(mpx .. "GANGOPS_FLOW_MISSION_PROG", GGP) stats.set_int(mpx .. "GANGOPS_HEIST_STATUS", GGS) stats.set_int(mpx .. "GANGOPS_FLOW_NOTIFICATIONS", 1557) end) ddHeistMenu:add_action("Complete All", function() stats.set_int(mpx.."GANGOPS_FM_MISSION_PROG", -1) end) ddHeistMenu:add_action("Reset Heist", function() stats.set_int(mpx.."GANGOPS_FLOW_MISSION_PROG", 240) stats.set_int(mpx.."GANGOPS_HEIST_STATUS", 0) stats.set_int(mpx.."GANGOPS_FLOW_NOTIFICATIONS", 1557) end) ddHeistMenu:add_action("-----", function() end) ddHeistMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) ddHeistMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end)
--local ddCMenu = ddHeistMenu:add_submenu("Cortes") ddCMenu:add_array_item("Max $ Cuts% All", {"I:Data Breaches", "II:Bogdan Problem", "III:Doomsday Senario"}, function() return xox_23 end, function(value) if value == 1 then globals.set_int(1963626, 313) globals.set_int(1963627, 313) globals.set_int(1963628, 313) globals.set_int(1963629, 313) elseif value == 2 then globals.set_int(1963626, 214) globals.set_int(1963627, 214) globals.set_int(1963628, 214) globals.set_int(1963629, 214) elseif value == 3 then globals.set_int(1963626, 170) globals.set_int(1963627, 170) globals.set_int(1963628, 170) globals.set_int(1963629, 170) end xox_23 = value end)
--ddCMenu:add_action("                      ~Manual %~ ", function() end) ddCMenu:add_int_range("Doomsday Player 1", 1.0, 15, 313, function() return globals.get_int(1963626) end, function(value) globals.set_int(1963626, value) end) ddCMenu:add_int_range("Doomsday Player 2", 1.0, 15, 313, function() return globals.get_int(1963627) end, function(value) globals.set_int(1963627, value) end) ddCMenu:add_int_range("Doomsday Player 3", 1.0, 15, 313, function() return globals.get_int(1963628) end, function(value) globals.set_int(1963628, value) end) ddCMenu:add_int_range("Doomsday Player 4", 1.0, 15, 313, function() return globals.get_int(1963629) end, function(value) globals.set_int(1963629, value) end)
--local appHeistMenu = heistMenu:add_submenu("Golpe a Apartamento") appHeistMenu:add_action("Skip to Current Heist Finale", function() stats.set_int(mpx .. "HEIST_PLANNING_STAGE", -1) end) appHeistMenu:add_action("-----", function() end) appHeistMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) appHeistMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end) appHeistMenu:add_action("-----", function() end)
--local ahMmMenu = appHeistMenu:add_submenu("$$$ Metodo (Tu Solo)") ahMmMenu:add_array_item(" ~Fleeca", {"5 Mil", "10 Mil", "15 Mil"}, function() return xox_24 end, function(value) if value == 1 then globals.set_int(1934636 + 3008 +1, 3500) elseif value == 2 then globals.set_int(1934636 + 3008 +1, 7000) elseif value == 3 then globals.set_int(1934636 + 3008 +1, 10434) end xox_24 = value end) ahMmMenu:add_array_item(" ~Prison Break", {"5 Mil", "10 Mil", "15 Mil"}, function() return xox_27 end, function(value) if value == 1 then globals.set_int(1934636 + 3008 +1, 1000) elseif value == 2 then globals.set_int(1934636 + 3008 +1, 2000) elseif value == 3 then globals.set_int(1934636 + 3008 +1, 3000) end xox_27 = value end) ahMmMenu:add_array_item(" ~Humane Labs Raid", {"5 Mil", "10 Mil", "15 Mil"}, function() return xox_28 end, function(value) if value == 1 then globals.set_int(1934636 + 3008 +1, 750) elseif value == 2 then globals.set_int(1934636 + 3008 +1, 1482) elseif value == 3 then globals.set_int(1934636 + 3008 +1, 2220) end xox_28 = value end) ahMmMenu:add_array_item(" ~Series A Funding", {"5 Mil", "10 Mil", "15 Mil"}, function() return xox_29 end, function(value) if value == 1 then globals.set_int(1934636 + 3008 +1, 991) elseif value == 2 then globals.set_int(1934636 + 3008 +1, 1981) elseif value == 3 then globals.set_int(1934636 + 3008 +1, 2970) end xox_29 = value end) ahMmMenu:add_array_item(" ~The Pacific Standard", {"5 Mil", "10 Mil", "15 Mil"}, function() return xox_30 end, function(value) if value == 1 then globals.set_int(1934636 + 3008 +1, 400) elseif value == 2 then globals.set_int(1934636 + 3008 +1, 800) elseif value == 3 then globals.set_int(1934636 + 3008 +1, 1200) end xox_30 = value end)
--local ahCMenu = appHeistMenu:add_submenu("Cortes") ahCMenu:add_int_range("Apt Player 1", 1.0, 15, 10434, function() return globals.get_int(1937645) end, function(value) globals.set_int(1937645, value) end) ahCMenu:add_int_range("Apt Player 2", 1.0, 15, 10434, function() return globals.get_int(1937646) end, function(value) globals.set_int(1937646, value) end) ahCMenu:add_int_range("Apt Player 3", 1.0, 15, 10434, function() return globals.get_int(1937647) end, function(value) globals.set_int(1937647, value) end) ahCMenu:add_int_range("Apt Player 4", 1.0, 15, 10434, function() return globals.get_int(1937648) end, function(value) globals.set_int(1937648, value) end) ahCMenu:add_action("All 100", function() for i = 1937645, 1937648 do globals.set_int(i, 100) end end)
--local CMMenu = mainMenu:add_submenu("Contractos") local agencyMenu = CMMenu:add_submenu("Agency") local secMenu = agencyMenu:add_submenu("Security Contracts") secMenu:add_int_range("Contract 1", 5000, 35000, 130000, function() return globals.get_int(1977270) end, function(value) globals.set_int(1977270, value) end) secMenu:add_int_range("Contract 2", 5000, 35000, 130000, function() return globals.get_int(1977273) end, function(value) globals.set_int(1977273, value) end) secMenu:add_int_range("Contract 3", 5000, 35000, 130000, function() return globals.get_int(1977276) end, function(value) globals.set_int(1977276, value) end) local function SecCooldown(e) if not localplayer then return end if e then globals.set_int(293474, 0) else globals.set_int(293474, 300000) end end secMenu:add_toggle("Remove Cooldown", function() return e9 end, function() e9 = not e9 SecCooldown(e9) end) secMenu:add_action("-----", function() end) secMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) secMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end) secMenu:add_action("-------No. of security contracts done---------", function() end) secMenu:add_int_range("Asset Protection", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_ASSETS_PROTECTED") end, function(v) stats.set_int(mpx.."FIXER_SC_ASSETS_PROTECTED", v) end) secMenu:add_int_range("Gang Termination", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_GANG_TERMINATED") end, function(v) stats.set_int(mpx.."FIXER_SC_GANG_TERMINATED", v) end) secMenu:add_int_range("Liquidize Assets", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_EQ_DESTROYED") end, function(v) stats.set_int(mpx.."FIXER_SC_EQ_DESTROYED", v) end) secMenu:add_int_range("Recover Valuables", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_VAL_RECOVERED") end, function(v) stats.set_int(mpx.."FIXER_SC_VAL_RECOVERED", v) end) secMenu:add_int_range("Rescue Operation", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_VIP_RESCUED") end, function(v) stats.set_int(mpx.."FIXER_SC_VIP_RESCUED", v) end) secMenu:add_int_range("Vehicle Recovery", 1, 0, 500, function() return stats.get_int(mpx.."FIXER_SC_VEH_RECOVERED") end, function(v) stats.set_int(mpx.."FIXER_SC_VEH_RECOVERED", v) end) secMenu:add_int_range("Contract Earnings", 250000, 0, 20000000, function() return stats.get_int(mpx.."FIXER_EARNINGS") end, function(v) stats.set_int(mpx.."FIXER_EARNINGS", v) end) local vipMenu = agencyMenu:add_submenu("VIP Contracts") vipMenu:add_array_item("Skip Prep", {"The Nightclub", "The Marina", "Nightlife Leak", "The Country Club", "Guest List", "High Society Leak", "Davis", "The Ballas", "The South Central Leak", "Studio Time", "Dont F*ck With Dre"}, function() return xox_25 end, function(value) if value == 1 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 3) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 2 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 4) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 3 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 12) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 4 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 28) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 5 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 60) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 6 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 124) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 7 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 252) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 8 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 508) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 9 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", 2044) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) elseif value == 10 then stats.set_int(mpx .. "FIXER_GENERAL_BS", -1) stats.set_int(mpx .. "FIXER_COMPLETED_BS", -1) stats.set_int(mpx .. "FIXER_STORY_BS", -1) stats.set_int(mpx .. "FIXER_STORY_COOLDOWN", -1) stats.set_int(mpx .. "FIXER_STORY_STRAND", -1) end xox_25 = value end) local function VipMod(e) if not localplayer then return end if e then  globals.set_int(293534, 2400000) else globals.set_int(293534, 1000000) end end vipMenu:add_toggle("2.4M Finale", function() return e10 end, function() e10 = not e10 VipMod(e10) end) local function VipCD(e) if not localplayer then return end if e then globals.set_int(293490, 0) else globals.set_int(293490, 300000) end end vipMenu:add_toggle("Remove Cooldown", function() return e11 end, function() e11 = not e11 VipCD(e11) end) vipMenu:add_action("-----", function() end) vipMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) vipMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end)
--local phMenu = agencyMenu:add_submenu("Hits De Telefono") phMenu:add_int_range("Payphone Bonus", 35000, 0, 105000, function() return globals.get_int(293517) end, function(value) globals.set_int(293517, value) end) phMenu:add_int_range("Payphone Payment", 22500, 0, 100000, function() return globals.get_int(293516) end, function(value) globals.set_int(293516, value) end) local function pCD(e) if not localplayer then return end if e then globals.set_int(293568, 0) else globals.set_int(293568, 1200000) end end phMenu:add_toggle("Remove Cooldown", function() return e12 end, function() e12 = not e12 pCD(e12) end) phMenu:add_action("-----", function() end) phMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) phMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end) phMenu:add_action("------------Payphone Hits Stats-------------", function() end) phMenu:add_int_range("Payphone hits Completed", 1, 0, 999, function() return stats.get_int(mpx.."FIXERTELEPHONEHITSCOMPL") end, function(v) stats.set_int(mpx.."FIXERTELEPHONEHITSCOMPL", v) end)
--local LSTMenu = CMMenu:add_submenu("Auto-compra") LSTMenu:add_action("The Union Depository Contract", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 0) end) LSTMenu:add_action("The Superdollar Deal", function() stats.set_int(mpx .. "TUNER_GEN_BS", 4351) stats.set_int(mpx .. "TUNER_CURRENT", 1) end) LSTMenu:add_action("The Bank Contract", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 2) end) LSTMenu:add_action("The ECU Job", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 3) end) LSTMenu:add_action("The Prison Contract", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 4) end) LSTMenu:add_action("The Agency Deal", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 5) end) LSTMenu:add_action("The Lost Contract", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 6) end) LSTMenu:add_action("The Data Contract", function() stats.set_int(mpx .. "TUNER_GEN_BS", 12543) stats.set_int(mpx .. "TUNER_CURRENT", 7) end) LSTMenu:add_action("---", function() end) LSTMenu:add_action(" -[Modify Payout]-", function()	globals.set_int(292836,1000000) globals.set_int(292837,1000000) globals.set_int(292838,1000000) globals.set_int(292839,1000000) globals.set_int(292840,1000000) globals.set_int(292841,1000000) globals.set_int(292842,1000000) globals.set_int(292843,1000000) globals.set_int(292835,1000000) globals.set_float(292832,0) end) LSTMenu:add_action(" ~ ^Choose the above to get 1m", function() end) LSTMenu:add_action("---------------Contracts Stats-----------------", function() end) LSTMenu:add_int_range("Contracts Done", 1, 0, 9999, function() return stats.get_int(mpx.."TUNER_COUNT") end, function(v) stats.set_int(mpx.."TUNER_COUNT", v) end) LSTMenu:add_int_range("Contracts Earnings", 500000, 0, 1000000000, function() return stats.get_int(mpx.."TUNER_EARNINGS") end, function(v) stats.set_int(mpx.."TUNER_EARNINGS", v) end) LSTMenu:add_action("-----", function() end) LSTMenu:add_action("Kill mission npcs", function() menu.kill_all_mission_peds() end) LSTMenu:add_action("Kill all npcs", function() menu.kill_all_npcs() end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local protMenu = OnlMenu:add_submenu("Protexiones")

local function Text(text)
	protMenu:add_action(text, function() end)
end

Text("Protexiones")
Text("----------")
local function CeoKick(bool)
	if bool then 
		globals.set_bool(1664101, true) 
	else
		globals.set_bool(1664101, false)
	end
end

local function CeoBan(bool)
	if bool then 
		globals.set_bool(1664123, true) 
	else
		globals.set_bool(1664123, false)
	end
end

local function SoundSpam(bool)
	if bool then 
		globals.set_bool(1663996, true)
		globals.set_bool(1664365, true)
		globals.set_bool(1663509, true)
		globals.set_bool(1664649, true)
		globals.set_bool(1664175, true)
		globals.set_bool(1663536, true)

	else
		globals.set_bool(1663996, false)
		globals.set_bool(1664365, false)
		globals.set_bool(1663509, false)
		globals.set_bool(1664649, false)
		globals.set_bool(1664175, false)
		globals.set_bool(1663536, false)
	end
end

local function InfiniteLoad(bool)
	if bool then 		
		globals.set_bool(1664064, true) 
		globals.set_bool(1664201, true)
	else
		globals.set_bool(1664064, false)
		globals.set_bool(1664201, false)
	end
end


local function Collectibles(bool)
	if bool then 
		globals.set_bool(1664330, true)
	else
		globals.set_bool(1664330, false)
	end
end

local function PassiveMode(bool)
	if bool then 
		globals.set_bool(1664113, true)
	else
		globals.set_bool(1664113, false)
	end
end

local function TransactionError(bool) 
	if bool then 
		globals.set_bool(1663914, true)
	else
		globals.set_bool(1663914, false)
	end
end

local function RemoveMoneyMessage(bool) 
	if bool then 
		globals.set_bool(1663997, true)
		globals.set_bool(1663543, true)
		globals.set_bool(1663541, true)
		globals.set_bool(1664174, true)

	else
		globals.set_bool(1663997, false)
		globals.set_bool(1663543, false)
		globals.set_bool(1663541, false)
		globals.set_bool(1664174, false)

	end
end

local function Bounty(bool) 
	if bool then 
		globals.set_bool(1663583, true)
	else
		globals.set_bool(1663583, false)
	end
end

local function ExtraTeleport(bool) 
	if bool then 
		globals.set_bool(1664355, true) 
		globals.set_bool(1664359, true) 
	else
		globals.set_bool(1664355, false) 
		globals.set_bool(1664359, false) 
	end
end


local function ClearWanted(bool) 
	if bool then 
		globals.set_bool(1664055, true)
	else
		globals.set_bool(1664055, false)
	end
end

local function OffTheRadar(bool) 
	if bool then 
		globals.set_bool(1664057, true)
	else
		globals.set_bool(1664057, false)
	end
end

local function SendCutscene(bool) 
	if bool then 
		globals.set_bool(1664320, true)
	else
		globals.set_bool(1664320, false)
	end
end

local function Godmode(bool) 
	if bool then 
		globals.set_bool(1664419, true)
	else
		globals.set_bool(1664419, false)
	end
end

local function PersonalVehicleDestroy(bool) 
	if bool then 
		globals.set_bool(1663592, true)
		globals.set_bool(1664180, true) 
		globals.set_bool(1664064, true)
		
	else
		globals.set_bool(1663592, false)
		globals.set_bool(1664180, false) 
		globals.set_bool(1664064, false) 
	end
end

local function SeKick(bool) 
	if bool then 
		globals.set_bool(1664153, true)
		globals.set_bool(1664270, true) 
		globals.set_bool(1664168, true)
		
	else
		globals.set_bool(1663592, false)
		globals.set_bool(1664270, false) 
		globals.set_bool(1664168, false) 
	end
end

local function SeCrash(bool) 
	if bool then 
		globals.set_bool(1664068, true)
		globals.set_bool(1664180, true) 
		globals.set_bool(1664145, true)
		globals.set_bool(1664360, true)
		
	else
		globals.set_bool(1664068, false)
		globals.set_bool(1664180, false) 
		globals.set_bool(1664145, false) 
		globals.set_bool(1664360, false)
	end
end

local function All(bool) 
	CeoKick(bool)
	CeoBan(bool)
	SoundSpam(bool)
	InfiniteLoad(bool)
	PassiveMode(bool)
	TransactionError(bool)
	RemoveMoneyMessage(bool)
	Bounty(bool)
	ClearWanted(bool)
	OffTheRadar(bool)
	PersonalVehicleDestroy(bool)
	SendCutscene(bool)
	Godmode(bool)
	Collectibles(bool)
	ExtraTeleport(bool)
	SeCrash(bool)
	SeKick(bool)
end

pro:add_toggle("Aktivar todo", function()
	return boolall
end, function()
	boolall = not boolall
	All(boolall)
	
end)
Text("--")

pro:add_toggle("Blokiar SE-Kick", function()
	return sek
end, function()
	sek = not sek
	SeKick(boolsek)
	
end)

pro:add_toggle("Blokiar SE-Crash", function()
	return boolsec
end, function()
	boolsec = not boolsec
	SeCrash(boolsec)
	
end)

pro:add_toggle("Blokiar Ceo Kick", function()
	return boolktsp
end, function()
	boolktsp = not boolktsp
	CeoKick(boolktsp)
	
end)

pro:add_toggle("Blokiar Ceo Ban", function()
	return boolcb
end, function()
	boolcb = not boolcb
	CeoBan(boolcb)
	
end)

pro:add_toggle("Blokiar sonido no deseado", function()
	return boolsps
end, function()
	boolsps = not boolsps
	SoundSpam(boolsps)
	
end)

pro:add_toggle("Blokiar pantalla de carga infinita", function()
	return boolil
end, function()
	boolil = not boolil
	InfiniteLoad(boolil)
	
end)

pro:add_toggle("Blokiar modo pasivo", function()
	return boolb
end, function()
	boolb = not boolb
	PassiveMode(boolb)
	
end)

pro:add_toggle("Blokiar error de transacción", function()
	return boolte
end, function()
	boolte = not boolte
	TransactionError(boolte)
	
end)

pro:add_toggle("Blokiar notificaciones modificadas/SMS", function()
	return boolrm
end, function()
	boolrm = not boolrm
	RemoveMoneyMessage(boolrm)
	
end)

pro:add_toggle("Blokiar recompensa", function()
	return boolbo
end, function()
	boolbo = not boolbo
	Bounty(boolbo)
	
end)

pro:add_toggle("Blokiar Borrar buscado", function()
	return boolclw
end, function()
	boolclw = not boolclw
	ClearWanted(boolclw)
	
end)

pro:add_toggle("Blokiar fuera del radar", function()
	return boolotr
end, function()
	boolotr = not boolotr
	OffTheRadar(boolotr)
	
end)

pro:add_toggle("Blokiar destrucción de vehículos personales", function()
	return boolpvd
end, function()
	boolpvd = not boolpvd
	PersonalVehicleDestroy(boolpvd)
	
end)

pro:add_toggle("Blokiar enviar a escena", function()
	return boolstc
end, function()
	boolstc = not boolstc
	SendCutscene(boolstc)
	
end)

pro:add_toggle("Blokiar Eliminar Modo Dios", function()
	return boolgod
end, function()
	boolgod = not boolgod
	Godmode(boolgod)
	
end)

pro:add_toggle("Blokiar dar coleccionables", function()
	return boolgc
end, function()
	boolgc = not boolgc
	Collectibles(boolgc)
	
end)

pro:add_toggle("Blokiar Cayo perico y tp a la playa", function()
	return boolcbt
end, function()
	boolcbt = not boolcbt
	ExtraTeleport(boolcbt)
	
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--local vehMenu = mainMenu:add_submenu("Vehiculos")
--vehMenu:add_action("En un futuro no muy lejano...", function() end)
--vehMenu:add_action("Me dio weba la verdad, putos nativos de", function() end)
--vehMenu:add_action("los coches <333", function() end)

--local function OnVehicleChanged(oldVehicle, newVehicle)
--	if newVehicle ~= nil then
--		if newVehicle:get_model_hash() == 0x586765fb then
--			newVehicle:set_number_plate_text('borrar')
--		end
--	
--		newVehicle:set_health(1000)
--	end
--end

--vehMenu:add_toggle("Borrar Veh Cercanos", OnVehicleChanged)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local recMenu = mainMenu:add_submenu("Recovery $$$")
recMenu:add_action("Fase de testeo", function() end)
recMenu:add_action("No me hago responsable", function() end)
recMenu:add_action("De mal uzo <3", function() end)

recMenu:add_action("Unlocks <--|", function()
for i = 293419, 293446 do globals.set_float(i,100000) end end)

local rec2Menu = recMenu:add_submenu("Desblokeos De Bools")
rec2Menu:add_action("ARENAWARSPSTAT_BOOL", function()	for j = 0, 63 do for i = 0, 8 do stats.set_bool_masked(mpx.."ARENAWARSPSTAT_BOOL"..i, true, j, mpx) end end end)
rec2Menu:add_action("BUSINESSBATPSTAT_BOOL", function() for j = 0, 63 do for b = 0, 1 do stats.set_bool_masked(mpx.."BUSINESSBATPSTAT_BOOL"..b, true, j, mpx) end end end)
rec2Menu:add_action("CASINOHSTPSTAT_BOOL", function()	for j = 0, 63 do for f = 0, 4 do stats.set_bool_masked(mpx.."CASINOHSTPSTAT_BOOL"..f, true, j, mpx) end end end)
rec2Menu:add_action("CASINOPSTAT_BOOL", function() for j = 0, 63 do for h = 0, 6 do stats.set_bool_masked(mpx.."CASINOPSTAT_BOOL"..h, true, j, mpx) end end end)
rec2Menu:add_action("DLCSMUGCHARPSTAT_BOOL", function() for j = 0, 63 do stats.set_bool_masked(mpx.."DLCSMUGCHARPSTAT_BOOL0", true, j, mpx) end end)
rec2Menu:add_action("DLCGUNPSTAT_BOOL", function() for j = 0, 63 do for c = 0, 2 do stats.set_bool_masked(mpx.."DLCGUNPSTAT_BOOL"..c, true, j, mpx) end end end)
rec2Menu:add_action("DLCBIKEPSTAT_BOOL", function() for j = 0, 63 do for c = 0, 2 do stats.set_bool_masked(mpx.."DLCBIKEPSTAT_BOOL"..c, true, j, mpx) end end end)
rec2Menu:add_action("FIXERTATTOOSTAT_BOOL", function() for j = 0, 63 do stats.set_bool_masked(mpx.."FIXERTATTOOSTAT_BOOL0", true, j, mpx) end end)
rec2Menu:add_action("FIXERPSTAT_BOOL", function()	for j = 0, 63 do for b = 0, 1 do stats.set_bool_masked(mpx.."FIXERPSTAT_BOOL"..b, true, j, mpx) end end end)
rec2Menu:add_action("GANGOPSPSTAT_BOOL", function() for j = 0, 63 do stats.set_bool_masked(mpx.."GANGOPSPSTAT_BOOL0", true, j, mpx) end end) 
rec2Menu:add_action("GUNTATPSTAT_BOOL", function() for j = 0, 63 do for g = 0, 5 do stats.set_bool_masked(mpx.."GUNTATPSTAT_BOOL"..g, true, j, mpx) end end end)
rec2Menu:add_action("HEIST3TATTOOSTAT_BOOL", function() for j = 0, 63 do for b = 0, 1 do stats.set_bool_masked(mpx.."HEIST3TATTOOSTAT_BOOL"..b, true, j, mpx) end end end)
rec2Menu:add_action("HISLANDPSTAT_BOOL", function() for j = 0, 63 do for c = 0, 2 do stats.set_bool_masked(mpx.."HISLANDPSTAT_BOOL"..c, true, j, mpx) end end end)
rec2Menu:add_action("MP_NGDLCPSTAT_BOOL", function() for j = 0, 63 do stats.set_bool_masked(mpx.."MP_NGDLCPSTAT_BOOL0", true, j, mpx) end end)
rec2Menu:add_action("MP_NGPSTAT_BOOL", function()	for j = 0, 63 do stats.set_bool_masked(mpx.."MP_NGPSTAT_BOOL0", true, j, mpx) end end)
rec2Menu:add_action("MP_PSTAT_BOOL", function() for j = 0, 63 do for c = 0, 2 do stats.set_bool_masked(mpx.."MP_PSTAT_BOOL"..c, true, j, mpx) end end end)
rec2Menu:add_action("MP_TUPSTAT_BOOL", function()	for j = 0, 63 do stats.set_bool_masked(mpx.."MP_TUPSTAT_BOOL0", true, j, mpx) end end)
rec2Menu:add_action("NGDLCPSTAT_BOOL", function()	for j = 0, 63 do for e = 0, 3 do stats.set_bool_masked(mpx.."NGDLCPSTAT_BOOL"..e, true, j, mpx) end end end)
rec2Menu:add_action("NGTATPSTAT_BOOL", function()	for j = 0, 63 do for g = 0, 5 do stats.set_bool_masked(mpx.."NGTATPSTAT_BOOL"..g, true, j, mpx) end end end) 
rec2Menu:add_action("NGPSTAT_BOOL", function() for j = 0, 63 do for b = 0, 1 do stats.set_bool_masked(mpx.."NGPSTAT_BOOL"..b, true, j, mpx) end end end)
rec2Menu:add_action("PSTAT_BOOL", function() for j = 0, 63 do for d = 1, 2 do stats.set_bool_masked(mpx.."PSTAT_BOOL"..d, true, j, mpx) end end end) 
rec2Menu:add_action("SU20TATTOOSTAT_BOOL", function()	for j = 0, 63 do for b = 0, 1 do stats.set_bool_masked(mpx.."SU20TATTOOSTAT_BOOL"..b, true, j, mpx) end end end)
rec2Menu:add_action("SU20PSTAT_BOOL", function() for j = 0, 63 do for b = 0, 1 do stats.set_bool_masked(mpx.."SU20PSTAT_BOOL"..b, true, j, mpx) end end end)
rec2Menu:add_action("TUNERPSTAT_BOOL", function()	for j = 0, 63 do for i = 0, 8 do stats.set_bool_masked(mpx.."TUNERPSTAT_BOOL"..i, true, j, mpx) end end end)
rec2Menu:add_action("TUPSTAT_BOOL", function() for j = 0, 63 do for z = 0, 11 do stats.set_bool_masked(mpx.."TUPSTAT_BOOL"..z, true, j, mpx) end end end)

recMenu:add_action("Desblokear Inve De Bunqer", function()
	for j = 0, 63 do
		stats.set_bool_masked(mpx.."DLCGUNPSTAT_BOOL0", true, j, mpx)
		stats.set_bool_masked(mpx.."DLCGUNPSTAT_BOOL1", true, j, mpx)
		stats.set_bool_masked(mpx.."DLCGUNPSTAT_BOOL2", true, j, mpx)
		stats.set_bool_masked(mpx.."GUNTATPSTAT_BOOL0", true, j, mpx)
		stats.set_bool_masked(mpx.."GUNTATPSTAT_BOOL1", true, j, mpx)
		stats.set_bool_masked(mpx.."GUNTATPSTAT_BOOL2", true, j, mpx)
		stats.set_bool_masked(mpx.."GUNTATPSTAT_BOOL3", true, j, mpx)
		stats.set_bool_masked(mpx.."GUNTATPSTAT_BOOL4", true, j, mpx)
		stats.set_bool_masked(mpx.."GUNTATPSTAT_BOOL5", true, j, mpx)
	end
	local bitSize = 8 for j = 0, 64 / bitSize - 1 do
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT0", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT1", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT2", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT3", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT4", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT5", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT6", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT7", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT8", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT9", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT10", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT11", -1, j * bitSize, bitSize)
	 stats.set_masked_int(mpx.."GUNRPSTAT_INT12", -1, j * bitSize, bitSize)
	end
end)

recMenu:add_array_item("Inve De Bunker", {"Acelerar", "Resetiar"}, function() return xox_26 end, function(value) if value == 1 then globals.set_int(283484, 1) globals.set_int(283736, 1) globals.set_int(283737, 1) globals.set_int(283738, 1) menu.trigger_bunker_research() elseif value == 2 then globals.set_int(283484, 60) globals.set_int(283737, 45000) globals.set_int(283736, 300000) globals.set_int(283738, 45000) end xox_26 = value end)

recMenu:add_action("Desblokear Contaktos", function()
	stats.set_int(mpx .. "FM_ACT_PHN", -1)
	stats.set_int(mpx .. "FM_ACT_PH2", -1)
	stats.set_int(mpx .. "FM_ACT_PH3", -1)
	stats.set_int(mpx .. "FM_ACT_PH4", -1)
	stats.set_int(mpx .. "FM_ACT_PH5", -1)
	stats.set_int(mpx .. "FM_VEH_TX1", -1)
	stats.set_int(mpx .. "FM_ACT_PH6", -1)
	stats.set_int(mpx .. "FM_ACT_PH7", -1)
	stats.set_int(mpx .. "FM_ACT_PH8", -1)
	stats.set_int(mpx .. "FM_ACT_PH9", -1)
	stats.set_int(mpx .. "FM_CUT_DONE", -1)
	stats.set_int(mpx .. "FM_CUT_DONE_2", -1)
end)

recMenu:add_action("Desblokear Pituraz/Cosas De LSC", function()
	stats.set_int(mpx .. "CHAR_FM_CARMOD_1_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_FM_CARMOD_2_UNLCK",-1)
	stats.set_int(mpx .. "CHAR_FM_CARMOD_3_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_FM_CARMOD_4_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_FM_CARMOD_5_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_FM_CARMOD_6_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_FM_CARMOD_7_UNLCK", -1)
	stats.set_int(mpx .. "AWD_WIN_CAPTURES", 50)
	stats.set_int(mpx .. "AWD_DROPOFF_CAP_PACKAGES", 100)
	stats.set_int(mpx .. "AWD_KILL_CARRIER_CAPTURE", 100)
	stats.set_int(mpx .. "AWD_FINISH_HEISTS", 50)
	stats.set_int(mpx .. "AWD_FINISH_HEIST_SETUP_JOB", 50)
	stats.set_int(mpx .. "AWD_NIGHTVISION_KILLS", 100)
	stats.set_int(mpx .. "AWD_WIN_LAST_TEAM_STANDINGS", 50)
	stats.set_int(mpx .. "AWD_ONLY_PLAYER_ALIVE_LTS", 50)
	stats.set_int(mpx .. "AWD_FMRALLYWONDRIVE", 25)
	stats.set_int(mpx .. "AWD_FMRALLYWONNAV", 25)
	stats.set_int(mpx .. "AWD_FMWINSEARACE", 25)
	stats.set_int(mpx .. "AWD_RACES_WON", 50)
	stats.set_int(mpx .. "MOST_FLIPS_IN_ONE_JUMP", 5)
	stats.set_int(mpx .. "MOST_SPINS_IN_ONE_JUMP", 5)
	stats.set_int(mpx .. "NUMBER_SLIPSTREAMS_IN_RACE", 100)
	stats.set_int(mpx .. "NUMBER_TURBO_STARTS_IN_RACE", 50)
	stats.set_int(mpx .. "RACES_WON", 50)
	stats.set_int(mpx .. "USJS_COMPLETED", 50)
	stats.set_int(mpx .. "AWD_FM_GTA_RACES_WON", 50)
	stats.set_int(mpx .. "AWD_FM_RACE_LAST_FIRST", 25)
	stats.set_int(mpx .. "AWD_FM_RACES_FASTEST_LAP", 50)
	stats.set_int(mpx .. "AWD_FMBASEJMP", 25)
	stats.set_int(mpx .. "AWD_FMWINAIRRACE", 25)
	stats.set_int("MPPLY_TOTAL_RACES_WON", 50)
end)

recMenu:add_action("Armas", function()
	stats.set_int(mpx .. "CHAR_WEAP_UNLOCKED", -1)
	stats.set_int(mpx .. "CHAR_WEAP_UNLOCKED2", -1)
	stats.set_int(mpx .. "CHAR_WEAP_UNLOCKED3", -1)
	stats.set_int(mpx .. "CHAR_WEAP_UNLOCKED4", -1)
	stats.set_int(mpx .. "CHAR_WEAP_ADDON_1_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_WEAP_ADDON_2_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_WEAP_ADDON_3_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_WEAP_ADDON_4_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_WEAP_FREE", -1)
	stats.set_int(mpx .. "CHAR_WEAP_FREE2", -1)
	stats.set_int(mpx .. "CHAR_FM_WEAP_FREE", -1)
	stats.set_int(mpx .. "CHAR_FM_WEAP_FREE2", -1)
	stats.set_int(mpx .. "CHAR_FM_WEAP_FREE3", -1)
	stats.set_int(mpx .. "CHAR_FM_WEAP_FREE4", -1)
	stats.set_int(mpx .. "CHAR_WEAP_PURCHASED", -1)
	stats.set_int(mpx .. "CHAR_WEAP_PURCHASED2", -1)
	stats.set_int(mpx .. "WEAPON_PICKUP_BITSET", -1)
	stats.set_int(mpx .. "WEAPON_PICKUP_BITSET2", -1)
	stats.set_int(mpx .. "CHAR_FM_WEAP_UNLOCKED", -1)
	stats.set_int(mpx .. "NO_WEAPONS_UNLOCK", -1)
	stats.set_int(mpx .. "NO_WEAPON_MODS_UNLOCK", -1)
	stats.set_int(mpx .. "NO_WEAPON_CLR_MOD_UNLOCK", -1) 
	stats.set_int(mpx .. "CHAR_FM_WEAP_UNLOCKED2", -1)
	stats.set_int(mpx .. "CHAR_FM_WEAP_UNLOCKED3", -1)
	stats.set_int(mpx .. "CHAR_FM_WEAP_UNLOCKED4", -1)
	stats.set_int(mpx .. "CHAR_KIT_1_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_2_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_3_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_4_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_5_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_6_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_7_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_8_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_9_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_10_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_11_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_12_FM_UNLCK", -1)
	stats.set_int(mpx .. "CHAR_KIT_FM_PURCHASE", -1)
	stats.set_int(mpx .. "CHAR_WEAP_FM_PURCHASE", -1)
	stats.set_int(mpx .. "CHAR_WEAP_FM_PURCHASE2", -1)
	stats.set_int(mpx .. "CHAR_WEAP_FM_PURCHASE3", -1)
	stats.set_int(mpx .. "CHAR_WEAP_FM_PURCHASE4", -1)
	stats.set_int(mpx .. "FIREWORK_TYPE_1_WHITE", 1000)
	stats.set_int(mpx .. "FIREWORK_TYPE_1_RED", 1000)
	stats.set_int(mpx .. "FIREWORK_TYPE_1_BLUE", 1000)
	stats.set_int(mpx .. "FIREWORK_TYPE_2_WHITE", 1000)
	stats.set_int(mpx .. "FIREWORK_TYPE_2_RED", 1000)
	stats.set_int(mpx .. "FIREWORK_TYPE_2_BLUE", 1000)
	stats.set_int(mpx .. "FIREWORK_TYPE_3_WHITE", 1000)
	stats.set_int(mpx .. "FIREWORK_TYPE_3_RED", 1000)
	stats.set_int(mpx .. "FIREWORK_TYPE_3_BLUE", 1000)
	stats.set_int(mpx .. "FIREWORK_TYPE_4_WHITE", 1000)
	stats.set_int(mpx .. "FIREWORK_TYPE_4_RED", 1000)
	stats.set_int(mpx .. "FIREWORK_TYPE_4_BLUE", 1000)
	stats.set_int(mpx .. "WEAP_FM_ADDON_PURCH", -1)
   for i = 2, 19 do stats.set_int(mpx .. "WEAP_FM_ADDON_PURCH"..i, -1) end
   for j = 1, 19 do stats.set_int(mpx .. "CHAR_FM_WEAP_ADDON_"..j.."_UNLCK", -1) end
   for m = 1, 41 do stats.set_int(mpx .. "CHAR_KIT_"..m.."_FM_UNLCK", -1) end
   for l = 2, 41 do stats.set_int(mpx .. "CHAR_KIT_FM_PURCHASE"..l, -1) end
end)

recMenu:add_action("Desbloquear Librerias Ocultas", function()
	stats.set_int("MPPLY_XMASLIVERIES", -1) for i = 1, 20 do stats.set_int("MPPLY_XMASLIVERIES"..i, -1) end end)

recMenu:add_action("Escuela De Viaje", function() stats.set_int("MPPLY_NUM_CAPTURES_CREATED", 100) for i = 0, 9 do stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_"..i, -1) stats.set_int(mpx.. "PILOT_SCHOOL_MEDAL_"..i, -1) stats.set_bool(mpx .. "PILOT_ASPASSEDLESSON_"..i, true) end end)
recMenu:add_action("Campo De Tiro", function() stats.set_int(mpx .. "SR_HIGHSCORE_1", 690) stats.set_int(mpx .. "SR_HIGHSCORE_2", 1860) stats.set_int(mpx .. "SR_HIGHSCORE_3", 2690) stats.set_int(mpx .. "SR_HIGHSCORE_4", 2660) stats.set_int(mpx .. "SR_HIGHSCORE_5", 2650) stats.set_int(mpx .. "SR_HIGHSCORE_6", 450) stats.set_int(mpx .. "SR_TARGETS_HIT", 269) stats.set_int(mpx .. "SR_WEAPON_BIT_SET", -1) stats.set_bool(mpx .. "SR_TIER_1_REWARD", true) stats.set_bool(mpx .. "SR_TIER_3_REWARD", true) stats.set_bool(mpx .. "SR_INCREASE_THROW_CAP", true) end)
recMenu:add_action("Vanilla Unicorn", function() stats.set_int(mpx .. "LAP_DANCED_BOUGHT", 0) stats.set_int(mpx .. "LAP_DANCED_BOUGHT", 5) stats.set_int(mpx .. "LAP_DANCED_BOUGHT", 10) stats.set_int(mpx .. "LAP_DANCED_BOUGHT", 15) stats.set_int(mpx .. "LAP_DANCED_BOUGHT", 25) stats.set_int(mpx .. "PROSTITUTES_FREQUENTED", 1000) end)
recMenu:add_action("Desblokear Tatus", function() stats.set_int(mpx .. "TATTOO_FM_CURRENT_32", -1) for i = 0, 47 do stats.set_int(mpx .. "TATTOO_FM_UNLOCKS_"..i, -1) end end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local dinMenu = mainMenu:add_submenu("Dineroz $$$")

local function Text(text)
	dinMenu:add_action(text, function() end)
end
Text("No zoi responzable del uso o algun")
Text(" baneo, es seguro hasta sierto punto")
Text("Loz quiero, picho <3")
Text("-------------------------------------------")

local ccMenu = dinMenu:add_submenu("Cagas de CEO$$$")
ccMenu:add_int_range("Pon cantidad de $$", 100000, 10000, 5900000, function() return globals.get_int(277988) end, function(Val) local a = Val local b = math.floor(Val / 2) local c = math.floor(Val / 3) local d = math.floor(Val / 4) local e = math.floor(Val / 5) local f = math.floor(Val / 6) local g = math.floor(Val / 7) local h = math.floor(Val / 8) local i = math.floor(Val / 9) local j = math.floor(Val / 10) local k = math.floor(Val / 11) local l = math.floor(Val / 12) local m = math.floor(Val / 13) local n = math.floor(Val / 14) local o = math.floor(Val / 15) local p = math.floor(Val / 16) local q = math.floor(Val / 17) local r = math.floor(Val / 18) local s = math.floor(Val / 19) local t = math.floor(Val / 20) local u = math.floor(Val / 21) globals.set_int(277988, a) globals.set_int(277989, b) globals.set_int(277990, c) globals.set_int(277991, d) globals.set_int(277992, e) globals.set_int(277993, f) globals.set_int(277994, g) globals.set_int(277995, h) globals.set_int(277996, i) globals.set_int(277997, j) globals.set_int(277998, k) globals.set_int(277999, l) globals.set_int(278000, m) globals.set_int(278001, n) globals.set_int(278002, o) globals.set_int(278003, p) globals.set_int(278004, q) globals.set_int(278005, r) globals.set_int(278006, s) globals.set_int(278007, t) globals.set_int(278008, u) if Val > 5400000 then menu.empty_session() end end)
local function CCooldown(e) if not localplayer then return end if e then globals.set_int(277753, 0) globals.set_int(277754, 0) else globals.set_int(277753, 300000) globals.set_int(277754, 1800000) end end ccMenu:add_toggle("Remover CulDouns", function() return e13 end, function() e13 = not e13 CCooldown(e13) end)
ccMenu:add_toggle("Cargo Random uwu", function() return globals.get_boolean(1946111) end, function(value) globals.set_boolean(1946111, value) end) ccMenu:add_array_item("Select Unique Cargo", {"Guebo alien", "Minigun chapiza", "Un diamond", "Pielesita", "Hilo", "Reloj raro"}, function() return xox_33 end, function(value) xox_33 = value if value == 1 then globals.set_int(1946111, 1) globals.set_int(1945957, 2) elseif value == 2 then globals.set_int(1946111, 1) globals.set_int(1945957, 4) elseif value == 3 then globals.set_int(1946111, 1) globals.set_int(1945957, 6) elseif value == 4 then globals.set_int(1946111, 1) globals.set_int(1945957, 7) elseif value == 5 then globals.set_int(1946111, 1) globals.set_int(1945957, 8) else globals.set_int(1946111, 1) globals.set_int(1945957, 9) end end) ccMenu:add_action("---", function() end)
ccMenu:add_action("Resetiar stats cada venta-20M/1000$", function() stats.set_int(mpx .. "LIFETIME_BUY_COMPLETE", 1000) stats.set_int(mpx .. "LIFETIME_BUY_UNDERTAKEN", 1000) stats.set_int(mpx .. "LIFETIME_SELL_COMPLETE", 1000) stats.set_int(mpx .. "LIFETIME_SELL_UNDERTAKEN", 1000) stats.set_int(mpx .. "LIFETIME_CONTRA_EARNINGS", 20000000) globals.set_int(1575015, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)
ccMenu:add_int_range("Resetear manualmente las ventas.", 1, 0, 1000, function() return stats.get_int(mpx .. "LIFETIME_SELL_COMPLETE") end, function(value) stats.set_int(mpx .. "LIFETIME_BUY_COMPLETE", value) stats.set_int(mpx .. "LIFETIME_BUY_UNDERTAKEN", value) stats.set_int(mpx .. "LIFETIME_SELL_COMPLETE", value) stats.set_int(mpx .. "LIFETIME_SELL_UNDERTAKEN", value) stats.set_int(mpx .. "LIFETIME_CONTRA_EARNINGS", value * 20000) globals.set_int(1575015, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ncMenu = dinMenu:add_submenu("Cluv Noctugno$$$")
local function NCooldown(e) if not localplayer then return end if e then globals.set_int(286620, 0) else globals.set_int(286620, 300000) end end ncMenu:add_toggle("Remover culdouns", function() return e14 end, function() e14 = not e14 NCooldown(e14) end)
ncMenu:add_float_range("Multiplicador TTP", 0.5, 0.5, 1000, function() return globals.get_float(286546) end, function(value) globals.set_float(286546, value) end)
ncMenu:add_array_item("Produxion", {"Aumentar", "DIzminuir"}, function() return xox_17 end, function(v) if v == 1 then for i = 286280, 286286 do globals.set_int(i, 1) end menu.trigger_nightclub_production() else globals.set_int(286280, 4800000) globals.set_int(286281, 14400000) globals.set_int(286282, 7200000) globals.set_int(286283, 2400000) globals.set_int(286284, 1800000) globals.set_int(286285, 3600000) globals.set_int(286286, 8400000) end xox_17 = v end) ncMenu:add_action("---", function() end)
ncMenu:add_action("Popularida Al Matsimo", function()
	mpIndex = globals.get_int(1574907)
	if mpIndex == 0 then
		stats.set_int("MP0_CLUB_POPULARTY", 1000)
	else
		stats.set_int("MP1_CLUB_POPULARTY", 1000)
	end
end)
ncMenu:add_int_range("Valor de cargo sport", 5000, 5000, 4000000, function() return globals.get_int(286554) end, function(value) globals.set_int(286554, value) end)
ncMenu:add_int_range("Valor cargo S.A", 10000, 27000, 4000000, function() return globals.get_int(286555) end, function(value) globals.set_int(286555, value) end)
ncMenu:add_int_range("Valor farmasia", 10000, 11475, 4000000, function() return globals.get_int(286556) end, function(value) globals.set_int(286556, value) end)
ncMenu:add_int_range("Valor organico", 10000, 2025, 4000000, function() return globals.get_int(286557) end, function(value) globals.set_int(286557, value) end)
ncMenu:add_int_range("Valor copirait", 10000, 1350, 4000000, function() return globals.get_int(286558) end, function(value) globals.set_int(286558, value) end)
ncMenu:add_int_range("Valor dinero feik", 10000, 4725, 4000000, function() return globals.get_int(286559) end, function(value) globals.set_int(286559, value) end)
ncMenu:add_int_range("Valor cargo nose", 10000, 10000, 4000000, function() return globals.get_int(286560) end, function(value) globals.set_int(286560, value) end)
local function tonyC(e) if not localplayer then return end if e then globals.set_float(286669, 0) else globals.set_float(286669, 0.1) end end ncMenu:add_toggle("Remover iva de tony", function() return e29 end, function() e29 = not e29 tonyC(e29) end) ncMenu:add_action("-------Testeado:solo public; ~Max=4M------------", function() end)
ncMenu:add_int_range("Resetiar ventas", 1, 0, 1000, function() return stats.get_int(mpx .. "HUB_SALES_COMPLETED") end, function(value) stats.set_int(mpx .. "HUB_SALES_COMPLETED", value) end) ncMenu:add_int_range("Resetiar ingresos", 500000, 0, 30000000, function() return stats.get_int(mpx .. "HUB_EARNINGS") end, function(value) stats.set_int(mpx .. "HUB_EARNINGS", value) globals.set_int(1575015, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local mcMenu = dinMenu:add_submenu("Cluv de moteros$$$") local function Speed(e) if not localplayer then return end if e then for i = 279591, 279595 do globals.set_int(i, 0) globals.set_int(i, 1) end else globals.set_int(279594, 300000) globals.set_int(279595, 720000) globals.set_int(279593, 3000000) globals.set_int(279592, 1800000) globals.set_int(279591, 360000) end end mcMenu:add_toggle("Aumentar produxion", function() return e16 end, function() e16 = not e16 Speed(e16) end)
local function VRC(e) if not localplayer then return end if e then globals.set_int(281143, 1000) else globals.set_int(281143, 1000) end end mcMenu:add_toggle("Remover costo de suministroz", function() return e22 end, function() e22 = not e22 VRC(e22) end)
local function MCrr(e) if not localplayer then return end if e then for i = 0, 4 do stats.set_int(mpx.."PAYRESUPPLYTIMER"..i, 1) sleep(0.1) end else for i = 0, 4 do stats.set_int(mpx.."PAYRESUPPLYTIMER"..i, 0) end end end mcMenu:add_toggle("Reienar suminiztroz(beta)", function() return e25 end, function() e25 = not e25 MCrr(e25) end)
local function MCgs(e) if not localplayer then return end if e then globals.set_int(280439, 0) else globals.set_int(280439, 40000) end end mcMenu:add_toggle("Remover senial global", function() return e24 end, function() e24 = not e24 MCgs(e24) end)
mcMenu:add_float_range("Multiplicador de venta", 0.5, 1, 1000, function() return globals.get_float(281256) end, function(value) globals.set_float(281256, value) globals.set_float(281257, value) end) mcMenu:add_action(" ~Utiliza esa mielda pal obtenel~ ", function() end)
mcMenu:add_action(" ~maximo 2.5M~ ", function() end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local mmVmenu = dinMenu:add_submenu("Cargamento veh$$$") local function Max(e) if not localplayer then return end if e then globals.set_int(281602, 155000) globals.set_int(281603, 155000) globals.set_int(281604, 155000) globals.set_float(281606, 0) globals.set_float(281607, 0) else globals.set_int(281602, 40000) globals.set_int(281603, 25000) globals.set_int(281604, 15000) globals.set_float(281606, 0.25) globals.set_float(281607, 0.5) end end mmVmenu:add_toggle("Maxear los rangos", function() return e17 end, function() e17 = not e17 Max(e17) end)
local function VCD(e) if not localplayer then return end if e then for i = 281622, 281625 do globals.set_int(i, 0) sleep(1) globals.set_int(i, 1) end else globals.set_int(281622, 1200000) globals.set_int(281623, 1680000) globals.set_int(281624, 2340000) globals.set_int(281625, 2880000) end end mmVmenu:add_toggle("Remover culdown", function() return e18 end, function() e18 = not e18 VCD(e18) end)
local function VRC(e) if not localplayer then return end if e then for i = 281601, 281603 do globals.set_int(i, 0) end else globals.set_int(281601, 34000) globals.set_int(281602, 21250) globals.set_int(281603, 12750) end end mmVmenu:add_toggle("Remover costo de jimmy", function() return e21 end, function() e21 = not e21 VRC(e21) end) mmVmenu:add_action("---", function() end)
mmVmenu:add_int_range("Auto god", 1000, 40000, 4000000, function() return globals.get_int(281602) end, function(value) globals.set_int(281602, value) end)
mmVmenu:add_int_range("Auto meh", 1000, 25000, 4000000, function() return globals.get_int(281603) end, function(value) globals.set_int(281603, value) end)
mmVmenu:add_int_range("Auto mierda", 1000, 15000, 4000000, function() return globals.get_int(281604) end, function(value) globals.set_int(281604, value) end)
mmVmenu:add_float_range("Sale Showroom", 0.5, 1.5, 1000, function() return globals.get_float(281608) end, function(value) globals.set_float(281608, value) end)
mmVmenu:add_float_range("Sale Specialist Dealer", 0.5, 2, 1000, function() return globals.get_float(281609) end, function(value) globals.set_float(281609, value) end)
mmVmenu:add_float_range("Upgrade Cost Showroom", 0.25, 0, 1000, function() return globals.get_float(281606) end, function(value) globals.set_float(281606, value) end)
mmVmenu:add_float_range("Upgrade Cost Specialist Dealer", 0.25, 0, 1000, function() return globals.get_float(281607) end, function(value) globals.set_float(281607, value) end)
mmVmenu:add_action("-----Testeado:solo public; ~Max=310k------------", function() end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local monMenu = dinMenu:add_submenu("Lup De Dineroz$$$")
monMenu:add_action("Super Inzeguro tu, Cuidao", function() end)
monMenu:add_action("No selexionar muxhas al mismo tienpo", function() end)
monMenu:add_action("Despues de una esperar 2m", function() end)
monMenu:add_action("para la siguiente", function() end)
monMenu:add_toggle("500k/ 30s", function() return enable1 end, function() enable1 = not enable1 while enable1 == true do Loop1(enable1) end end) local function Loop2(e) if not localplayer then return end if e then g(m, y) s(z) g(m, k) s(p) end end
monMenu:add_toggle("750k/ 30s", function() return enable2 end, function() enable2 = not enable2 while enable2 == true do Loop2(enable2) end end) local function Loop3(e) if not localplayer then return end if e then g(m, x) s(z) g(m, k) s(z) g(m, x) s(z) g(m, k) s(q) end end
monMenu:add_toggle("1M/ 60s", function() return enable3 end, function() enable3 = not enable3 while enable3 == true do Loop3(enable3) end end) local function Loop4(e) if not localplayer then return end if e then g(m, y) s(z) g(m, k) s(z) g(m, y) s(z) g(m, k) s(q) end end
monMenu:add_toggle("1.5M/ 60s", function() return enable4 end, function() enable4 = not enable4 while enable4 == true do Loop4(enable4) end end) local function Loop5(e) if not localplayer then return end if e then g(m, y) s(z) g(m, k) s(z) g(m, y) s(z) g(m, k) s(z) g(m, y) s(z) g(m, k) s(z) g(m, y) s(z) g(m, k) s(r) end end
monMenu:add_toggle("3M/ 120s", function() return enable5 end, function() enable5 = not enable5 while enable5 == true do Loop5(enable5) end end)
monMenu:add_action("-----Testeado:solo public, INZEGURO!!!------------", function() end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local mmHmenu = dinMenu:add_submenu("Cargo De Hangar$$$")
function Cooldown(e) if not localplayer then return end if e then for i = 284924, 284928 do globals.set_int(i, 0) globals.set_int(i, 1) end else globals.set_int(284924, 120000) globals.set_int(284925, 180000) globals.set_int(284926, 240000) globals.set_int(284927, 60000) globals.set_int(284928, 2000) end end mmHmenu:add_toggle("Remove Cooldowns", function() return e15 end, function() e15 = not e15 Cooldown(e15) end)
mmHmenu:add_int_range("Cargamento Mixto", 50000, 10000, 3100000, function() return globals.get_int(284984) end, function(value) globals.set_int(284984, value) end)
mmHmenu:add_int_range("Cargamento Animal", 50000, 10000, 3100000, function() return globals.get_int(284985) end, function(value) globals.set_int(284985, value) end)
mmHmenu:add_int_range("Antiguedades y Arte", 50000, 10000, 3100000, function() return globals.get_int(284986) end, function(value) globals.set_int(284986, value) end)
mmHmenu:add_int_range("Cargamento Quimico", 50000, 10000, 3100000, function() return globals.get_int(284987) end, function(value) globals.set_int(284987, value) end)
mmHmenu:add_int_range("Dinero Falsificado", 50000, 10000, 3100000, function() return globals.get_int(284988) end, function(value) globals.set_int(284988, value) end)
mmHmenu:add_int_range("Joyeria", 50000, 10000, 3100000, function() return globals.get_int(284989) end, function(value) globals.set_int(284989, value) end)
mmHmenu:add_int_range("Cargamentos Medicos", 50000, 10000, 3100000, function() return globals.get_int(284990) end, function(value) globals.set_int(284990, value) end)
mmHmenu:add_int_range("Cargamentos De Narcotico", 50000, 10000, 3100000, function() return globals.get_int(284991) end, function(value) globals.set_int(284991, value) end)
mmHmenu:add_int_range("Tabacco Value", 50000, 10000, 3100000, function() return globals.get_int(284992) end, function(value) globals.set_int(284992, value) end)
function ronC(e) if not localplayer then return end if e then globals.set_float(284966, 0) else globals.set_float(284966, 0.025) end end mmHmenu:add_toggle("Remove Rons's cut", function() return e30 end, function() e30 = not e30 ronC(e30) end)
mmHmenu:add_int_range("Resetiar Stats De Ventas", 1, 0, 500, function() return stats.get_int(mpx .. "LFETIME_HANGAR_SEL_COMPLET") end, function(value) stats.set_int(mpx .. "LFETIME_HANGAR_BUY_UNDETAK", value) stats.set_int(mpx .. "LFETIME_HANGAR_BUY_COMPLET", value) stats.set_int(mpx .. "LFETIME_HANGAR_SEL_UNDETAK", value) stats.set_int(mpx .. "LFETIME_HANGAR_SEL_COMPLET", value) stats.set_int(mpx .. "LFETIME_HANGAR_EARNINGS", value * 40000) globals.set_int(1575015, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local CREDMenu = mainMenu:add_submenu("Creditos") CREDMenu:add_action("Kiddions ", function() end) CREDMenu:add_action("Pichocles", function() end) CREDMenu:add_action("Pepe ", function() end) CREDMenu:add_action("Sammy ", function() end) CREDMenu:add_action("Vicente ", function() end) CREDMenu:add_action("Ady", function() end) CREDMenu:add_action("En Especial ", function() end) CREDMenu:add_action("Emir <3 ", function() end)
