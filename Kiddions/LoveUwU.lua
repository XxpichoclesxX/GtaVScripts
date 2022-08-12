--This was coded and rebuild by XxpichoclesxX#0427
--Love ya this is a rebuild of past codes and some improovements that some friends helped me with
-- Enjoy this and if you find any bug just write me on discord (XxpichoclesxX#0427)
--With love Picho <3

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
modelMenu:add_action("Reienar Inv y Armadula", function()	stats.set_int(mpx .. "NO_BOUGHT_YUM_SNACKS", 30) stats.set_int(mpx .. "NO_BOUGHT_HEALTH_SNACKS", 15) stats.set_int(mpx .. "NO_BOUGHT_EPIC_SNACKS", 5) stats.set_int(mpx .. "NUMBER_OF_CHAMP_BOUGHT", 5) stats.set_int(mpx .. "NUMBER_OF_ORANGE_BOUGHT", 11) stats.set_int(mpx .. "NUMBER_OF_BOURGE_BOUGHT", 10) stats.set_int(mpx .. "CIGARETTES_BOUGHT", 20) stats.set_int(mpx .. "MP_CHAR_ARMOUR_1_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_2_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_3_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_4_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_5_COUNT", 10) stats.set_int(mpx .. "BREATHING_APPAR_BOUGHT", 20) end) modelMenu:add_action("Reienar Inv x1000", function() stats.set_int(mpx .. "NO_BOUGHT_YUM_SNACKS", 1000) stats.set_int(mpx .. "NO_BOUGHT_HEALTH_SNACKS", 1000) stats.set_int(mpx .. "NO_BOUGHT_EPIC_SNACKS", 1000) stats.set_int(mpx .. "NUMBER_OF_CHAMP_BOUGHT", 1000) stats.set_int(mpx .. "NUMBER_OF_ORANGE_BOUGHT", 1000) stats.set_int(mpx .. "NUMBER_OF_BOURGE_BOUGHT", 1000) stats.set_int(mpx .. "CIGARETTES_BOUGHT", 1000) stats.set_int(mpx .. "MP_CHAR_ARMOUR_1_COUNT", 1000) stats.set_int(mpx .. "MP_CHAR_ARMOUR_2_COUNT", 1000) stats.set_int(mpx .. "MP_CHAR_ARMOUR_3_COUNT", 1000) stats.set_int(mpx .. "MP_CHAR_ARMOUR_4_COUNT", 1000) stats.set_int(mpx .. "MP_CHAR_ARMOUR_5_COUNT", 1000) stats.set_int(mpx .. "BREATHING_APPAR_BOUGHT", 1000) end) modelMenu:add_action("Cambiar Genero (Trigger)", function() stats.set_int(mpx.."ALLOW_GENDER_CHANGE", 52) globals.set_int(281050, 0) end) local enable = false local speed = 2 local function up() if not enable then return end local newpos = localplayer:get_position() + vector3(0,0,speed) if not localplayer:is_in_vehicle() then localplayer:set_position(newpos) else vehicle=localplayer:get_current_vehicle() vehicle:set_position(newpos) end end local function down() if not enable then return end local newpos = localplayer:get_position() + vector3(0,0,speed * -1) if not localplayer:is_in_vehicle() then localplayer:set_position(newpos) else vehicle=localplayer:get_current_vehicle() vehicle:set_position(newpos) end end local function forward() if not enable then return end local dir = localplayer:get_heading() local newpos = localplayer:get_position() + (dir * speed) if not localplayer:is_in_vehicle() then localplayer:set_position(newpos) else vehicle=localplayer:get_current_vehicle() vehicle:set_position(newpos) end end local function backward() if not enable then return end local dir = localplayer:get_heading() local newpos = localplayer:get_position() + (dir * speed * -1) if not localplayer:is_in_vehicle() then localplayer:set_position(newpos) else vehicle=localplayer:get_current_vehicle() vehicle:set_position(newpos) end end local function turnleft() if not enable then return end local dir = localplayer:get_rotation() if not localplayer:is_in_vehicle() then localplayer:set_rotation(dir + vector3(0.25,0,0)) else vehicle=localplayer:get_current_vehicle() vehicle:set_rotation(dir + vector3(0.25,0,0)) end end local function turnright() if not enable then return end local dir = localplayer:get_rotation() if not localplayer:is_in_vehicle() then localplayer:set_rotation(dir + vector3(0.25 * -1,0,0)) else vehicle=localplayer:get_current_vehicle() vehicle:set_rotation(dir + vector3(0.25 * -1,0,0)) end end local function increasespeed() speed = speed + 1 end local function decreasespeed() speed = speed - 1 end local up_hotkey local down_hotkey local forward_hotkey local backward_hotkey local turnleft_hotkey local turnright_hotkey local increasespeed_hotkey local decreasespeed_hotkey local function NoClip(e) if not localplayer then return end if e then localplayer:set_freeze_momentum(true) localplayer:set_no_ragdoll(true) localplayer:set_config_flag(292,true) up_hotkey = menu.register_hotkey(go_up, up) down_hotkey = menu.register_hotkey(go_down, down) forward_hotkey = menu.register_hotkey(go_forward, forward) backward_hotkey = menu.register_hotkey(go_back, backward) turnleft_hotkey = menu.register_hotkey(turn_left, turnleft) turnright_hotkey = menu.register_hotkey(turn_right, turnright) increasespeed_hotkey = menu.register_hotkey(inc_speed, increasespeed) decreasespeed_hotkey = menu.register_hotkey(dec_speed, decreasespeed) else localplayer:set_freeze_momentum(false) localplayer:set_no_ragdoll(false) localplayer:set_config_flag(292,false) menu.remove_hotkey(up_hotkey) menu.remove_hotkey(down_hotkey) menu.remove_hotkey(forward_hotkey) menu.remove_hotkey(backward_hotkey) menu.remove_hotkey(turnleft_hotkey) menu.remove_hotkey(turnright_hotkey) menu.remove_hotkey(increasespeed_hotkey) menu.remove_hotkey(decreasespeed_hotkey) end end
local appMenu = modelMenu:add_submenu("Aparienzia")
local MP = {}
MP[-1667301416] = "Mujer"
MP[1885233650] = "Homvre"
appMenu:add_array_item("Volverse", MP, function() return 1885233650 end, function(Mp)
	set_model_hash(Mp)
	localplayer:set_godmode(false)
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ANM = {}
ANM[-832573324] = "Javali"
ANM[1462895032] = "Gato"
ANM[-1469565163] = "Sammy"
ANM[351016938] = "Perro Negro"
ANM[-50684386] = "Vicente"
ANM[1682622302] = "Coyote"
ANM[-664053099] = "Cierbo"
ANM[-1318032802] = "Husky"
ANM[307287994] = "Un LEON"
ANM[-1323586730] = "Cerdo"
ANM[1125994524] = "Poodle"
ANM[1832265812] = "Pug"
ANM[-541762431] = "Conejo"
ANM[-1011537562] = "Rata"
ANM[882848737] = "Retriever"
ANM[1126154828] = "Shepherd"
ANM[-1026527405] = "Rhesus"
ANM[-1384627013] = "Westy"
appMenu:add_array_item("Bolberse Animal", ANM, function() return 351016938 end, function(Anm)
	set_model_hash(Anm)
	localplayer:set_godmode(true)
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local CosP ={}
CosP[71929310] = "Paiaso"
CosP[880829941] = "ImpoRage"
CosP[-835930287] = "Jesus01"
CosP[1684083350] = "MovAlien01"
CosP[-407694286] = "MovSpace01SMM"
CosP[-598109171] = "Pogo01"
CosP[1681385341] = "Priest"
CosP[1011059922] = "RsRanger01AMO"
CosP[-1404353274] = "Zombie01"
CosP[-2016771922] = "JohnnyKlebitz"
CosP[1021093698] = "MimeSMY"
CosP[-1389097126] = "Orleans"
appMenu:add_array_item("Bolberse ....", CosP, function() return -1389097126 end, function(Brd)
	set_model_hash(Brd)
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local BRD = {}
BRD[1794449327] = "Polla Digo Pollo"
BRD[-1430839454] = "Gallo"
BRD[1457690978] = "Comorant-swan like"
BRD[-1469565163] = "Cuerbo"
BRD[1794449327] = "Polla"
BRD[-745300483] = "Larry"
appMenu:add_array_item("Bolberse abe", BRD, function() return -1469565163 end, function(Brd)
	set_model_hash(Brd)
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local SCRe = {}
SCRe[1015224100] = "Tiburon Marti"
SCRe[-1920284487] = "Ba-Llena"
SCRe[113504370] = "Tiburon Tigre"
SCRe[-1528782338] = "Manta-Raya"
SCRe[1193010354] = "Pene"
SCRe[-1950698411] = "Delfin"
appMenu:add_array_item("Bolberse An De Mar", SCRe, function() return -1950698411 end, function(SAn)
	set_model_hash(SAn)
	localplayer:set_godmode(true)
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local LAW = {}
LAW[1096929346] = "Sheriff01SFY"
LAW[-1275859404] = "BlackOps01SMY"
LAW[2047212121] = "BlackOps02SMY"
LAW[1349953339] = "BlackOps03SMY"
LAW[-520477356] = "Casey"
LAW[1650288984] = "CIASec01SMM"
LAW[1581098148] = "Cop01SMY"
LAW[368603149] = "Cop01SFY"
LAW[-1699520669] = "CopCutscene"
LAW[988062523] = "FBISuit01"
LAW[874722259] = "FIBArchitect"
LAW[-2051422616] = "FIBMugger01"
LAW[-306416314] = "FIBOffice01SMM"
LAW[653289389] = "FIBOffice02SMM"
LAW[1558115333] = "FIBSec01"
LAW[2072724299] = "FIBSec01SMM"
LAW[245247470] = "HighSec01SMM"
LAW[691061163] = "HighSec02SMM"
LAW[1939545845] = "HWayCop01SMY"
LAW[-220552467] = "Marine01SMM"
LAW[1702441027] = "Marine01SMY"
LAW[-265970301] = "Marine02SMM"
LAW[1490458366] = "Marine02SMY"
LAW[1925237458] = "Marine03SMY"
LAW[1631478380] = "MerryWeatherCutscene"
LAW[1822283721] = "MPros01"
LAW[1456041926] = "PrisGuard01SMM"
LAW[-1614285257] = "Ranger01SFY"
LAW[-277793362] = "Ranger01SMY"
LAW[-681004504] = "Security01SMM"
LAW[451459928] = "SnowCop01SMM"
LAW[-1920001264] = "SWAT01SMY"
LAW[-277325206] = "UndercoverCopCutscene"
appMenu:add_array_item("Bolberse Omvre de la lei", LAW, function() return 1096929346 end, function(Lw)
	set_model_hash(Lw)
end)
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
local casinoHeistMenu = heistMenu:add_submenu("Diamond Casino Heist") casinoHeistMenu:add_array_item("Configs", {"H.SnS-Best Crew|Diamonds", "H.SnS-Worst Crew|Diamonds", "H.SnS-Best Crew|Gold", "H.SnS-Worst Crew|Gold", "H.SnS-Best Crew|Painting", "H.SnS-Worst Crew|Painting", "H.BigCon-Best Crew|Diamonds", "H.BigCon-No Crew|Diamonds", "H.BigCon-Best Crew|Gold", "H.BigCon-No Crew|Gold", "H.BigCon-Best Crew|Painting", "H.BigCon-No Crew|Painting", "H.Agrsv-Best Crew|Diamonds", "H.Agrsv-Worst Crew|Diamonds", "H.Agrsv-Best Crew|Gold", "H.Agrsv-Worst Crew|Gold", "H.Agrsv-Best Crew|Painting", "H.Agrsv-Worst Crew|Painting", "N.SnS-Best Crew|Diamonds", "N.SnS-Worst Crew|Diamonds", "N.SnS-Best Crew|Gold", "N.SnS-Worst Crew|Gold", "N.SnS-Best Crew|Painting", "N.SnS-Worst Crew|Painting", "N.BigCon-Best Crew|Diamonds", "N.BigCon-No Crew|Diamonds", "N.BigCon-Best Crew|Gold", "N.BigCon-No Crew|Gold", "N.BigCon-Best Crew|Painting", "N.BigCon-No Crew|Painting", "N.Agrsv-Best Crew|Diamonds", "N.Agrsv-Worst Crew|Diamonds", "N.Agrsv-Best Crew|Gold", "N.Agrsv-Worst Crew|Gold", "N.Agrsv-Best Crew|Painting", "N.Agrsv-Worst Crew|Painting"}, function() return xox_16 end, function(v) if v == 1 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 2 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 3 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 4 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 5 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 6 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 7 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx.."H3_LAST_APPROACH", 3) stats.set_int(mpx.."H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 8 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx.."H3_LAST_APPROACH", 3) stats.set_int(mpx.."H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 9 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx.."H3_LAST_APPROACH", 3) stats.set_int(mpx.."H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 10 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 11 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 12 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_HARD_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 13 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 14 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 15 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 16 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 17 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 18 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_HARD_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 19 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 20 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 21 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1)stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 22 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1)stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 23 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 24 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 1) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 25 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4)  stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 26 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 27 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx.."H3_LAST_APPROACH", 3) stats.set_int(mpx.."H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 28 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 29 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 4) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 30 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 3) stats.set_int(mpx .. "H3_APPROACH", 2) stats.set_int(mpx.."H3OPT_CREWWEAP", 6) stats.set_int(mpx.."H3OPT_CREWDRIVER", 6) stats.set_int(mpx.."H3OPT_CREWHACKER", 6) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 31 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 32 then stats.set_int(mpx.."H3OPT_TARGET", 3) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 33 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 34 then stats.set_int(mpx.."H3OPT_TARGET", 1) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 35 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 5) stats.set_int(mpx.."H3OPT_CREWDRIVER", 5) stats.set_int(mpx.."H3OPT_CREWHACKER", 4) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) elseif v == 36 then stats.set_int(mpx.."H3OPT_TARGET", 2) stats.set_int(mpx .. "H3_LAST_APPROACH", 1) stats.set_int(mpx .. "H3_APPROACH", 3) stats.set_int(mpx.."H3OPT_CREWWEAP", 1) stats.set_int(mpx.."H3OPT_CREWDRIVER", 1) stats.set_int(mpx.."H3OPT_CREWHACKER", 1) stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx.."H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 1) stats.set_int(mpx.."H3OPT_BITSET0", -1) stats.set_int(mpx.."H3OPT_BITSET1", -1) stats.set_int(mpx.."H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) end xox_16 = v end)
casinoHeistMenu:add_action("Mas proximamente...", function() end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local protMenu = OnlMenu:add_submenu("Protexiones")

local function Text(text)
	protMenu:add_action(text, function() end)
end

Text("Protexiones")
Text("----------")
local function SoundSpam(bool)
	if bool then 
		globals.set_bool(1659419, true)
	else
		globals.set_bool(1659419, false)
	end
end

local function Kick(bool)
	if bool then 
		globals.set_bool(1660149, true)  
		globals.set_bool(1660054, true)
		globals.set_bool(1659403, true)
		globals.set_bool(1659406, true)
		globals.set_bool(1659407, true)
		globals.set_bool(1659408, true)
		globals.set_bool(1659409, true)
		globals.set_bool(1659410, true)
		globals.set_bool(1659438, true)
		globals.set_bool(1659733, true)
		globals.set_bool(1659772, true)
		globals.set_bool(1659775, true)
		globals.set_bool(1659885, true)
		globals.set_bool(1659889, true)
		globals.set_bool(1659895, true)
		globals.set_bool(1659897, true)
		globals.set_bool(1659905, true)
		globals.set_bool(1659906, true)
		globals.set_bool(1659935, true)
		globals.set_bool(1659943, true)
		globals.set_bool(1659972, true)
		globals.set_bool(1659974, true)
		globals.set_bool(1659979, true)
		globals.set_bool(1660004, true)
		globals.set_bool(1660019, true)
		globals.set_bool(1660020, true)
		globals.set_bool(1660025, true)
		globals.set_bool(1660027, true)
		globals.set_bool(1660040, true)
		globals.set_bool(1660041, true)
		globals.set_bool(1660042, true)
		globals.set_bool(1660043, true)
		globals.set_bool(1660047, true)
		globals.set_bool(1660048, true)
		globals.set_bool(1660054, true)
		globals.set_bool(1660055, true)
		globals.set_bool(1660056, true)
		globals.set_bool(1660106, true)
		globals.set_bool(1660141, true)
		globals.set_bool(1660144, true)
		globals.set_bool(1660146, true)
		globals.set_bool(1660149, true)
		globals.set_bool(1660150, true)
		globals.set_bool(1660183, true)
		globals.set_bool(1659857, true)	
		globals.set_bool(1660133, true)
		globals.set_bool(1659934, true)	
		globals.set_bool(1659939, true)
	else
		globals.set_bool(1659996, false)
		globals.set_bool(1660054, false)
		globals.set_bool(1659403, false)
		globals.set_bool(1659406, false)
		globals.set_bool(1659407, false)
		globals.set_bool(1659408, false)
		globals.set_bool(1659409, false)
		globals.set_bool(1659410, false)
		globals.set_bool(1659438, false)
		globals.set_bool(1659733, false)
		globals.set_bool(1659775, false)
		globals.set_bool(1659885, false)
		globals.set_bool(1659889, false)
		globals.set_bool(1659895, false)
		globals.set_bool(1659897, false)
		globals.set_bool(1659905, false)
		globals.set_bool(1659906, false)
		globals.set_bool(1659935, false)
		globals.set_bool(1659943, false)
		globals.set_bool(1659972, false)
		globals.set_bool(1659974, false)
		globals.set_bool(1659979, false)
		globals.set_bool(1660004, false)
		globals.set_bool(1660019, false) 
		globals.set_bool(1660020, false)
		globals.set_bool(1660025, false)		
		globals.set_bool(1660027, false)	
		globals.set_bool(1660040, false)	
		globals.set_bool(1660041, false)
		globals.set_bool(1660042, false)
		globals.set_bool(1660043, false)
		globals.set_bool(1660047, false)
		globals.set_bool(1660048, false)
		globals.set_bool(1660054, false) 
		globals.set_bool(1660055, false)
		globals.set_bool(1660056, false)
		globals.set_bool(1660106, false)
		globals.set_bool(1660141, false)
		globals.set_bool(1660144, false)
		globals.set_bool(1660146, false)
		globals.set_bool(1660149, false) 
		globals.set_bool(1660150, false)
		globals.set_bool(1660183, false)
		globals.set_bool(1659857, false)
		globals.set_bool(1660133, false)
		globals.set_bool(1659934, false)
		globals.set_bool(1659939, false)
	end
end

local function Spectate(bool) 
	if bool then 
		globals.set_bool(1660461, true)
	else
		globals.set_bool(1660461, false)
	end
end

protMenu:add_toggle("Bloqear SpamDeSonido", function()
	return boolsps
end, function()
	boolsps = not boolsps
	SoundSpam(boolsps)
	
end)

protMenu:add_toggle("Bloqear kickeos (Beta XD)", function()
	return boolk
end, function()
	boolk = not boolk
	Kick(boolk)
	
end)

protMenu:add_toggle("Bloqear spectear (puede buguearte)", function()
	return boolspe
end, function()
	boolspe = not boolspe
	Spectate(boolspe)
	
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local vehMenu = mainMenu:add_submenu("Vehiculos")
vehMenu:add_action("En un futuro no muy lejano...", function() end)
vehMenu:add_action("Me dio weba la verdad, putos nativos de", function() end)
vehMenu:add_action("los coches <333", function() end)

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
