--[[
    This was coded and rebuild by Pichocles#0427
    Love ya this is a rebuild of past codes and some improovements that some friends helped me with
    Enjoy this and if you find any bug just write me on discord (Pichocles#0427)
    With love Picho <3
]]

require_game_build(2944) -- (V1.67)

-- Menu features functions

local function SMcd(e)
	if not localplayer then
		return
	end

	if e then 
		globals.set_int(281557, 0)
		globals.set_int(283279, 99999)
	else
		globals.set_int(281557, 60000)
		globals.set_int(283279, 4000)
	end
end

local function casCctv(e)
	if not localplayer then
		return
	end 

	if e then
		menu.remove_cctvs()
	else
		menu.remove_cctvs(nil)
	end
end

local function FCv(e)
	if not localplayer then
		return
	end

	if e then
		for i = 296022, 275164 do
			globals.set_int(i, 0) 
		end

		for j = DOCT3, 293272 do 
			globals.set_int(j, 0)
		end

		globals.set_int(281827, 0)
		globals.set_int(283264, 0)
	else
		globals.set_int(296022, 20000) 

		for i = 286362, 286889 do
			globals.set_int(i, 5000)
		end
		globals.set_int(275164, 25000) 
		globals.set_int(DOCT3, 10000) 
		globals.set_int(283818, 7000) 
		globals.set_int(293277, 9000)

		for j = XM28, RBD1 do
			globals.set_int(j, 5000)
		end 

		globals.set_int(281827, 5000) 
		globals.set_int(283264, 10000)

	end
end

local function orb(e)
	if not localplayer then
		return
	end
	if e then 
		stats.set_int(mpx .. "ORBITAL_CANON_COOLDOWN", 0)
	else
		stts.get_int(mpx .. "ORBITAL_CANON_COOLDOWN")
	end
end

local function Cctv(e)
	if not localplayer then
		return
	end
	if e then
		menu.remove_cctvs()
	else
		menu.remove_cctvs(nil)
	end
end

local function TeleportPlayer(x, y, z, yaw, roll, pitch)
	if localplayer:is_in_vehicle() then
		localplayer:get_current_vehicle():set_position(x, y, z)
		localplayer:get_current_vehicle():set_rotation(yaw, roll, pitch) 
	else 
		localplayer:set_position(x, y, z)
		localplayer:set_rotation(yaw, roll, pitch)
	end
end

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

local function ToggleUndeadOffradar()
	value = GetUndeadOffradar()
	if value ~= nil then
		SetUndeadOffradar(not value)
	end
end

local Config = {}
Config.SubmenuStyle = false
Config.SlamType = 1
Config.SlamHeight = 1
Config.SlamTypes = {"Rhino", "Khanjali", "Halftrack"}
Config.VehicleSpawnGlobal = 2671449
Config.VehicleTypes = {}
Config.VehicleTypes["Super"] = {"Krieger", "Prototipo", "T20"}
Config.VehicleTypes["Sports"] = {"Kuruma", "Kuruma2"}
Config.VehicleTypes["Sports Classic"] = {"Toreador", "Artdent"}
Config.VehicleTypes["Millitary"] = {"Rhino", "Khanjali", "Halftrack"}
Config.VehicleTypes["Bikes"] = {"Oppressor", "Oppressor2", "Akuma"}
Config.VehicleTypes["Planes"] = {"Hydra", "Lazer", "Titan", "Cargoplane"}

local function safeLoop(state)
    while state do
        stats.set_int("MP0_CLUB_POPULARITY", 1000)
        stats.set_int("MP0_CLUB_PAY_TIME_LEFT", -1)
        sleep(1.5)
        stats.set_int("MP0_CLUB_POPULARITY", 1000)
        stats.set_int("MP0_CLUB_PAY_TIME_LEFT", -1)
        sleep(1.5)
        stats.set_int("MP0_CLUB_POPULARITY", 1000)
        stats.set_int("MP0_CLUB_PAY_TIME_LEFT", -1)
        sleep(1.5)
        stats.set_int("MP0_CLUB_POPULARITY", 1000)
        stats.set_int("MP0_CLUB_PAY_TIME_LEFT", -1)
        sleep(1.5)
        stats.set_int("MP0_CLUB_POPULARITY", 1000)
        stats.set_int("MP0_CLUB_PAY_TIME_LEFT", -1)
        sleep(4)
    end
end

global_overridebase = 262145
fmC2020 = script("fm_mission_controller_2020") 
fmC = script("fm_mission_controller") 
local PlayerIndex = stats.get_int("MPPLY_LAST_MP_CHAR") 
mpx = PlayerIndex if PlayerIndex == 0 then mpx = "MP0_" else mpx = "MP1_" end xox_00 = 1 xox_01 = 1 xox_0 = 1 xox_1 = 1 xox_2 = 1 xox_3 = 1 xox_4 = 1 xox_5 = 1 xox_6 = 1 xox_7 = 1 xox_8 = 1 xox_9 = 1 xox_10 = 1 xox_11 = 1 xox_12 = 1 xox_13 = 1 xox_14 = 1 xox_15 = 1 xox_16 = 1 xox_17 = 1 xox_18 = 1 xox_19 = 1 xox_20 = 1 xox_21 = 1 xox_22 = 1 xox_23 = 1 xox_24 = 1 xox_25 = 1 xox_26 = 1 xox_27 = 1 xox_28 = 1 xox_29 = 1 xox_30 = 1 xox_31 = 1 xox_32 = 1 xox_33 = 1 xox_34 = 1 xox_35 = 1 e0 = false e1 = false e2 = false e3 = false e4 = false e5 = false e6 = false e7 = false e8 = false e9 = false e10 = false e11 = false e12 = false e13 = false e14 = false e15 = false e16 = false e17 = false e18 = false e19 = false e20 = false e21 = false e22 = false e23 = false e24 = false e25 = false e26 = false e27 = false e28 = false e29 = false e30 = false e31 = false e32 = false e33 = false e34 = false e35 = false e36 = false e37 = false e38 = false e39 = false e40 = false e41 = false e42 = false e43 = false e44 = false e45 = false e46 = false e47 = false e48 = false e49 = false e50 = false 

local function Text(text) menu.add_action(text, function() end) end 
local fmC2020 = script("fm_mission_controller_2020") 
local fmC = script("fm_mission_controller") 
local mpx = PlayerIndex if PlayerIndex == 0 then mpx = "MP0_" else mpx = "MP1_" end local xox_00 = 1 local xox_01 = 1 local xox_0 = 1 local xox_1 = 1 local xox_2 = 1 local xox_3 = 1 local xox_4 = 1 local xox_5 = 1 local xox_6 = 1 local xox_7 = 1 local xox_8 = 1 local xox_9 = 1 local xox_10 = 1 local xox_11 = 1 local xox_12 = 1 local xox_13 = 1 local xox_14 = 1 local xox_15 = 1 local xox_16 = 1 local xox_17 = 1 local xox_18 = 1 local xox_19 = 1 local xox_20 = 1 local xox_21 = 1 local xox_22 = 1 local xox_23 = 1 local xox_24 = 1 local xox_25 = 1 local xox_26 = 1 local xox_27 = 1 local xox_28 = 1 local xox_29 = 1 local xox_30 = 1 local xox_31 = 1 local xox_32 = 1 local xox_33 = 1 local xox_34 = 1 local xox_35 = 1 local e0 = false local e1 = false local e2 = false local e3 = false local e4 = false local e5 = false local e6 = false local e7 = false local e8 = false local e9 = false local e10 = false local e11 = false local e12 = false local e13 = false local e14 = false local e15 = false local e16 = false local e17 = false local e18 = false local e19 = false local e20 = false local e21 = false local e22 = false local e23 = false local e24 = false local e25 = false local e26 = false local e27 = false local e28 = false local e29 = false local e30 = false local e31 = false local e32 = false local e33 = false local e34 = false local e35 = false local e36 = false local e37 = false local e38 = false local e39 = false local e40 = false local 

local mainMenu = menu.add_submenu("Ryze Script ")

modelMenu = mainMenu:add_submenu("Self")

modelMenu:add_action("----------------- Self ----------------", function() end)

badSp = modelMenu:add_submenu("Malos Perdedores (MU)")
modSp = modelMenu:add_submenu("Modificaciones (MU)")

modSp:add_action("Correr Rapido Y Recargar", function() stats.set_int(mpx .. "CHAR_ABILITY_1_UNLCK", -1) stats.set_int(mpx .. "CHAR_ABILITY_2_UNLCK", -1) stats.set_int(mpx .. "CHAR_ABILITY_3_UNLCK", -1) stats.set_int(mpx .. "CHAR_FM_ABILITY_1_UNLCK", -1) stats.set_int(mpx .. "CHAR_FM_ABILITY_2_UNLCK", -1) stats.set_int(mpx .. "CHAR_FM_ABILITY_3_UNLCK", -1) globals.set_int(1575020, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end) 
modSp:add_action("Reiniciar Estado", function() stats.set_int(mpx .. "CHAR_ABILITY_1_UNLCK", 0) stats.set_int(mpx .. "CHAR_ABILITY_2_UNLCK", 0) stats.set_int(mpx .. "CHAR_ABILITY_3_UNLCK", 0) stats.set_int(mpx .. "CHAR_FM_ABILITY_1_UNLCK", 0) stats.set_int(mpx .. "CHAR_FM_ABILITY_2_UNLCK", 0) stats.set_int(mpx .. "CHAR_FM_ABILITY_3_UNLCK", 0) globals.set_int(1575020, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)

modSp:add_action("Rellenar Inv y Armadura", function()	stats.set_int(mpx .. "NO_BOUGHT_YUM_SNACKS", 30) stats.set_int(mpx .. "NO_BOUGHT_HEALTH_SNACKS", 15) stats.set_int(mpx .. "NO_BOUGHT_EPIC_SNACKS", 5) stats.set_int(mpx .. "NUMBER_OF_CHAMP_BOUGHT", 5) stats.set_int(mpx .. "NUMBER_OF_ORANGE_BOUGHT", 11) stats.set_int(mpx .. "NUMBER_OF_BOURGE_BOUGHT", 10) stats.set_int(mpx .. "CIGARETTES_BOUGHT", 20) stats.set_int(mpx .. "MP_CHAR_ARMOUR_1_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_2_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_3_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_4_COUNT", 10) stats.set_int(mpx .. "MP_CHAR_ARMOUR_5_COUNT", 10) stats.set_int(mpx .. "BREATHING_APPAR_BOUGHT", 20) end) 

badSp:add_action("Añadir BadSports", function() stats.set_int("MPPLY_BADSPORT_MESSAGE", -1) stats.set_int("MPPLY_BECAME_BADSPORT_NUM", -1) stats.set_float("MPPLY_OVERALL_BADSPORT", 60000) stats.set_bool("MPPLY_CHAR_IS_BADSPORT", true) globals.set_int(1575015, 0) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)
badSp:add_action("Remover BadSports", function() stats.set_int("MPPLY_BADSPORT_MESSAGE", 0) stats.set_int("MPPLY_BECAME_BADSPORT_NUM", 0) stats.set_float("MPPLY_OVERALL_BADSPORT", 0) stats.set_bool("MPPLY_CHAR_IS_BADSPORT", false) globals.set_int(1575015, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)

modelMenu:add_action("----------------- Misc ----------------", function() end)

appMenu = modelMenu:add_submenu("Apariencia")

local PedSelf = {}
PedSelf[joaat("mp_m_freemode_01")] = "Hombre"
PedSelf[joaat("mp_f_freemode_01")] = "Mujer"

appMenu:add_array_item("Cambio de Genero", {"OFF", "ON"}, function() 
	return xox_15 end, function(aph) 
		if aph == 1 then stats.set_int(mpx .. "ALLOW_GENDER_CHANGE", 0)
	elseif aph == 2 then stats.set_int(mpx .. "ALLOW_GENDER_CHANGE", 52)
	end xox15 = aph 
end)

OnlMenu = mainMenu:add_submenu("Online")

OnlMenu:add_array_item("Sesiones Online", {"Unirse Sesion publica", "Iniciar Sesion Publica", "Sesion de invitacion", "Sesion cerrada de crew", "Sesion por crew", "Sesion cerrrada de amigos", "Encontrar Sesion por jugadores", "Sesion Solo"}, function() return xox_00 end, function(value) xox_00 = value if value == 1 then globals.set_int(1575020, 0) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 2 then globals.set_int(1575020, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 3 then globals.set_int(1575020, 11) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 4 then globals.set_int(1575020, 2) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 5 then globals.set_int(1575020, 3) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 6 then globals.set_int(1575020, 6) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 7 then globals.set_int(1575020, 9) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 8 then globals.set_int(1575020, 8) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) elseif value == 9 then globals.set_int(1575020, -1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end end)

repMenu = OnlMenu:add_submenu("Ver Reportes")

repMenu:add_action("Borrar Reportes Activos", function() stats.set_int("MPPLY_REPORT_STRENGTH", 0) stats.set_int("MPPLY_COMMEND_STRENGTH", 0) stats.set_int("MPPLY_GRIEFING", 0) stats.set_int("MPPLY_VC_ANNOYINGME", 0) stats.set_int("MPPLY_VC_HATE", 0) stats.set_int("MPPLY_TC_ANNOYINGME", 0) stats.set_int("MPPLY_TC_HATE", 0) stats.set_int("MPPLY_OFFENSIVE_LANGUAGE", 0) stats.set_int("MPPLY_OFFENSIVE_TAGPLATE", 0) stats.set_int("MPPLY_OFFENSIVE_UGC", 0) stats.set_int("MPPLY_BAD_CREW_NAME", 0) stats.set_int("MPPLY_BAD_CREW_MOTTO", 0) stats.set_int("MPPLY_BAD_CREW_STATUS", 0) stats.set_int("MPPLY_BAD_CREW_EMBLEM", 0) stats.set_int("MPPLY_EXPLOITS", 0) stats.set_int("MPPLY_BECAME_BADSPORT_NUM", 0) stats.set_int("MPPLY_DESTROYED_PVEHICLES", 0) stats.set_int("MPPLY_BADSPORT_MESSAGE", 0) stats.set_int("MPPLY_GAME_EXPLOITS", 0) stats.set_int("MPPLY_PLAYER_MENTAL_STATE", 0) stats.set_int("MPPLY_PLAYERMADE_TITLE", 0) stats.set_int("MPPLY_PLAYERMADE_DESC", 0) stats.set_int("MPPLY_ISPUNISHED", 0) stats.set_int("MPPLY_WAS_I_BAD_SPORT", 0) stats.set_int("MPPLY_WAS_I_CHEATER", 0) stats.set_int("MPPLY_CHAR_IS_BADSPORT", 0) stats.set_int("MPPLY_OVERALL_BADSPORT", 0) stats.set_int("MPPLY_OVERALL_CHEAT", 0) end)
repMenu:add_action("--------------------------------------", function() end)
repMenu:add_bare_item("", function() return "Grifear:".. (string.format("%03d", stats.get_int("MPPLY_GRIEFING"))) end, function() end, function()end, function() return end)
repMenu:add_bare_item("", function() return "Hacks:".. (string.format("%03d", stats.get_int("MPPLY_EXPLOITS"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Acoso textual:".. (string.format("%03d", stats.get_int("MPPLY_TC_ANNOYINGME"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal hablado:".. (string.format("%03d", stats.get_int("MPPLY_TC_HATE"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal hablado x2:".. (string.format("%03d", stats.get_int("MPPLY_VC_ANNOYINGME"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal hablado x3:".. (string.format("%03d", stats.get_int("MPPLY_VC_HATE"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Lenguaje ofensivo:".. (string.format("%03d", stats.get_int("MPPLY_OFFENSIVE_LANGUAGE"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Id ofensivo:".. (string.format("%03d", stats.get_int("MPPLY_OFFENSIVE_TAGPLATE"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Contenido ofensivo:".. (string.format("%03d", stats.get_int("MPPLY_OFFENSIVE_UGC"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal nombre de crew:".. (string.format("%03d", stats.get_int("MPPLY_BAD_CREW_NAME"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal nombre de MC:".. (string.format("%03d", stats.get_int("MPPLY_BAD_CREW_MOTTO"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal estado de crew:".. (string.format("%03d", stats.get_int("MPPLY_BAD_CREW_STATUS"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Mal emblema de crew:".. (string.format("%03d", stats.get_int("MPPLY_BAD_CREW_EMBLEM"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Amiwito:".. (string.format("%03d", stats.get_int("MPPLY_FRIENDLY"))) end, function() end, function()end, function()end)
repMenu:add_bare_item("", function() return "Ayudante:".. (string.format("%03d", stats.get_int("MPPLY_HELPFUL"))) end, function() end, function()end, function()end)

OnlMenu:add_action("----------------- Misiones/Online ----------------", function() end)

OnlMenu:add_array_item("Pedir Servicios", {"M.O.C", "Avenger", "TerrorByte", "Kosatka", "Bote", "Armadura Balistica"}, function() return xox_01 end, function(v) if v == 1 then globals.set_int(2793046 + 925, 1) elseif v == 2 then globals.set_int(2793046 + 933, 1) elseif v == 3 then globals.set_int(2793046 + 937, 1) elseif v == 4 then globals.set_int(2793046 + 954, 1) elseif v == 5 then globals.set_int(2793046 + 966, 1) else globals.set_int(2793046 + 886, 1) end xox_01 = v end)

repvehmenu = OnlMenu:add_submenu("Opciones Para Autos")
 
repvehmenu:add_action("Destruir Todos Los Carros", function() for v in replayinterface.get_vehicles() do if v ~= nil then v:set_health(0) end end end)
repvehmenu:add_action("Reparar Todos Los Carros", function() for v in replayinterface.get_vehicles() do if v ~= nil then v:set_health(1000) end end end)

OnlMenu:add_action("Quitar Delay Cañon Orbital", function() return e2 end, function() e2 = not e2 orb(e2) end)

OnlMenu:add_action("Remover Error De Transaccion", function() for i = 4536677, 4536679 do globals.set_int(i, 0) end end)
OnlMenu:add_action("Remove CEO Cooldown", function() stats.set_int("MPPLY_VIPGAMEPLAYDISABLETIMER", 0) end)
OnlMenu:add_toggle("Remover Cooldown Del Misil (sub)", function() return e4 end, function() e4 = not e4 SMcd(e4) end)
OnlMenu:add_action("Saltar misiones de Lamar", function() stats.set_bool(mpx .. "LOW_FLOW_CS_DRV_SEEN", true) stats.set_bool(mpx .. "LOW_FLOW_CS_TRA_SEEN", true) stats.set_bool(mpx .. "LOW_FLOW_CS_FUN_SEEN", true) stats.set_bool(mpx .. "LOW_FLOW_CS_PHO_SEEN", true) stats.set_bool(mpx .. "LOW_FLOW_CS_FIN_SEEN", true) stats.set_bool(mpx .. "LOW_BEN_INTRO_CS_SEEN", true) stats.set_int(mpx .. "LOWRIDER_FLOW_COMPLETE", 4) stats.set_int(mpx .. "LOW_FLOW_CURRENT_PROG", 9) stats.set_int(mpx .. "LOW_FLOW_CURRENT_CALL", 9) stats.set_int(mpx .. "LOW_FLOW_CS_HELPTEXT", 66) end) 
OnlMenu:add_action("Saltar Misiones Yate", function() stats.set_int(mpx .. "YACHT_MISSION_PROG", 0) stats.set_int(mpx .. "YACHT_MISSION_FLOW", 21845) stats.set_int(mpx .. "CASINO_DECORATION_GIFT_1", -1) end)
OnlMenu:add_toggle("Habilitar Peyote", function() return globals.get_boolean(262145+8352) end, function(v) globals.set_boolean(262145+8352, v) globals.set_boolean(262145+21697, v) end)
OnlMenu:add_toggle("Vehiculos De CEO Gratis", function() return e40 end, function() e40 = not e40 FCv(e40) end)

OnlMenu:add_toggle("Fuera Del Radar", GetUndeadOffradar, SetUndeadOffradar)



OnlMenu:add_action("----------------- Recovery ----------------", function() end)

OnlMenu:add_action("Habilidades 100%", function()
	stats.set_int(mpx .. "SCRIPT_INCREASE_DRIV", 100)
	stats.set_int(mpx .. "SCRIPT_INCREASE_FLY", 100)
	stats.set_int(mpx .. "SCRIPT_INCREASE_LUNG", 100)
	stats.set_int(mpx .. "SCRIPT_INCREASE_SHO", 100)
	stats.set_int(mpx .. "SCRIPT_INCREASE_STAM", 100)
	stats.set_int(mpx .. "SCRIPT_INCREASE_STL", 100)
	stats.set_int(mpx .. "SCRIPT_INCREASE_STRN", 100)
end)

OnlMenu:add_int_range("Dar Nivel (RP Correction)", 1, 0, 8000, function()
	local mpIndex = globals.get_int(1574918)
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
		currentRP = globals.get_int(1659760 + mpIndex)
	end
 
	local rpLevel = 0
	for i = 0,8000 do
		if currentRP < globals.get_int(297012 + i) then
			break
		else
			rpLevel = i
		end
	end
	
	return rpLevel
end, function(value)
	local mpIndex = globals.get_int(1574918)
	if mpIndex > 1 or mpIndex < 0 then
		return
	end
	
	local newRP = globals.get_int(297012 + value) + 100
	
	if mpIndex == 0 then
		stats.set_int("MP0_CHAR_SET_RP_GIFT_ADMIN", newRP)
	else
		stats.set_int("MP1_CHAR_SET_RP_GIFT_ADMIN", newRP)
	end
end)

OnlMenu:add_action("Completar Objetivos", function() stats.set_int(mpx .. "COMPLETEDAILYOBJ", 100) stats.set_int(mpx .. "COMPLETEDAILYOBJTOTAL", 100) stats.set_int(mpx .. "TOTALDAYCOMPLETED", 100) stats.set_int(mpx .. "TOTALWEEKCOMPLETED", 400) stats.set_int(mpx .. "TOTALMONTHCOMPLETED", 1800) stats.set_int(mpx .. "CONSECUTIVEDAYCOMPLETED", 30) stats.set_int(mpx .. "CONSECUTIVEWEEKCOMPLETED", 4) stats.set_int(mpx .. "CONSECUTIVEMONTHCOMPLETE", 1) stats.set_int(mpx .. "COMPLETEDAILYOBJSA", 100) stats.set_int(mpx .. "COMPLETEDAILYOBJTOTALSA", 100) stats.set_int(mpx .. "TOTALDAYCOMPLETEDSA", 100) stats.set_int(mpx .. "TOTALWEEKCOMPLETEDSA", 400) stats.set_int(mpx .. "TOTALMONTHCOMPLETEDSA", 1800) stats.set_int(mpx .. "CONSECUTIVEDAYCOMPLETEDSA", 30) stats.set_int(mpx .. "CONSECUTIVEWEEKCOMPLETEDSA", 4) stats.set_int(mpx .. "CONSECUTIVEMONTHCOMPLETESA", 1) stats.set_int(mpx .. "AWD_DAILYOBJCOMPLETEDSA", 100) stats.set_int(mpx .. "AWD_DAILYOBJCOMPLETED", 100) stats.set_bool(mpx .. "AWD_DAILYOBJMONTHBONUS", true) stats.set_bool(mpx .. "AWD_DAILYOBJWEEKBONUS", true) stats.set_bool(mpx .. "AWD_DAILYOBJWEEKBONUSSA", true) stats.set_bool(mpx .. "AWD_DAILYOBJMONTHBONUSSA", true) end) 

WepMenu = OnlMenu:add_submenu("Desbloquear Armas")

WepMenu:add_action("Revolver de Doble Accion",function()
	if (stats.get_masked_int(mpx.."GANGOPSPSTAT_INT102", 24, 8)<3) then
		stats.set_masked_int(mpx.."GANGOPSPSTAT_INT102", 3, 24, 8)
	end

	if (stats.get_masked_int(mpx.."GANGOPSPSTAT_INT102", 24, 8) > 3) then
		stats.set_masked_int(mpx.."GANGOPSPSTAT_INT102", 0, 24, 8)
	end
end)
	
WepMenu:add_action("Hacha de Piedra",function()
	if (stats.get_masked_int("MP_NGDLCPSTAT_INT0", 16, 8)<5) then
		stats.set_masked_int("MP_NGDLCPSTAT_INT0", 5, 16, 8)
	end
	if (stats.get_masked_int("MP_NGDLCPSTAT_INT0", 16, 8)>5) then
		stats.set_masked_int("MP_NGDLCPSTAT_INT0", 0, 16, 8)
    end	
end)

WepMenu:add_toggle("Poder Acha De Piedra Infinita", function() return e1 end, function() e1 = not e1 iSH(e1) end)

statMenu = OnlMenu:add_submenu("Editor de stat")
normalstat = statMenu:add_submenu("Personaje")
distancestat = statMenu:add_submenu("Distancia")
timestat = statMenu:add_submenu("Tiempo")

normalstat:add_float_range("Estado mental", 1.0, 0.0, 100, function() return stats.get_float("MPPLY_PLAYER_MENTAL_STATE") end, function(value) stats.set_float(mpx .. "PLAYER_MENTAL_STATE", value) stats.set_float("MPPLY_PLAYER_MENTAL_STATE", value) end)
normalstat:add_int_range("Dinero conseguido total", 500000, 0, 1000000000, function() return stats.get_int("MPPLY_TOTAL_EVC") end, function(value) stats.set_int("MPPLY_TOTAL_EVC",value) end)
normalstat:add_int_range("Dinero gastado", 500000, 0, 1000000000, function() return stats.get_int("MPPLY_TOTAL_SVC") end, function(value) stats.set_int("MPPLY_TOTAL_SVC",value) end)
normalstat:add_int_range("Jugadores moridos", 10, 0, 999999, function() return stats.get_int("MPPLY_KILLS_PLAYERS") end, function(value) stats.set_int("MPPLY_KILLS_PLAYERS", value) end)
normalstat:add_int_range("Cuantas veces has muerto por j", 10, 0, 999999, function() return stats.get_int("MPPLY_DEATHS_PLAYER") end, function(value) stats.set_int("MPPLY_DEATHS_PLAYER", value) end)
normalstat:add_float_range("PvP K/D Ratio", 0.01, 0, 9999, function() return stats.get_float("MPPLY_KILL_DEATH_RATIO") end, function(value) stats.set_float("MPPLY_KILL_DEATH_RATIO", value) end)
normalstat:add_int_range("Deathmatches Publicados", 10, 0, 999999, function() return stats.get_int("MPPLY_AWD_FM_CR_DM_MADE") end, function(value) stats.set_int("MPPLY_AWD_FM_CR_DM_MADE", value) end)
normalstat:add_int_range("carreras Publicadas", 10, 0, 999999, function() return stats.get_int("MPPLY_AWD_FM_CR_RACES_MADE") end, function(value) stats.set_int("MPPLY_AWD_FM_CR_RACES_MADE", value) end)
normalstat:add_int_range("Capturas publicadas", 10, 0, 999999, function() return stats.get_int("MPPLY_NUM_CAPTURES_CREATED") end, function(value) stats.set_int("MPPLY_NUM_CAPTURES_CREATED", value) end)
normalstat:add_int_range("LTS Publicadas", 10, 0, 999999, function() return stats.get_int("MPPLY_LTS_CREATED") end, function(value) stats.set_int("MPPLY_LTS_CREATED", value) end)
normalstat:add_int_range("Personas que han jugado tus M", 10, 0, 999999, function() return stats.get_int("MPPLY_AWD_FM_CR_PLAYED_BY_PEEP") end, function(value) stats.set_int("MPPLY_AWD_FM_CR_PLAYED_BY_PEEP", value) end)
normalstat:add_int_range("Likes a tus contenidos", 10, 0, 999999, function() return stats.get_int("MPPLY_AWD_FM_CR_MISSION_SCORE") end, function(value) stats.set_int("MPPLY_AWD_FM_CR_MISSION_SCORE", value) end)
normalstat:add_int_range("Reiniciar LSCM (No para desbloquear)", 1, 1, 11, function() return 0 end, function(V) if V == 1 then vt = 5 elseif V == 2 then vt = 415 elseif V == 3 then vt = 1040 elseif V == 4 then vt = 3665 elseif V == 5 then vt = 10540 elseif V == 6 then vt = 20540 elseif V == 7 then vt = 33665 elseif V == 8 then vt = 49915 elseif V == 9 then vt = 69290 elseif V == 10 then vt = 91790 else vt = 117430 end stats.set_int(mpx .. "CAR_CLUB_REP", vt) end) 
normalstat:add_action("~[1/5/10/25/50/75/100/125/150/175/200]", function() end) 
normalstat:add_action("-{Cambia de sesion para aplicar}", function() end)

normalstat:add_action("-----------------------------------------", function() end)
normalstat:add_int_range("Remover Dinero", 1000000, 1000000, 2000000000, function() return globals.get_int(282613) end, function(value) globals.set_int(282613, value) end) 
normalstat:add_action("Pon el valor y despues compra algo.", function() end)
normalstat:add_action("-----------------------------------------", function() end)

distancestat:add_float_range("Viajado (metros)", 10.00, 0.00, 99999.00, function() return stats.get_float("MPPLY_CHAR_DIST_TRAVELLED")/1000 end, function(value) stats.set_float("MPPLY_CHAR_DIST_TRAVELLED", value*1000) end)
distancestat:add_float_range("Nadado", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_SWIMMING")/1000 end, function(value) stats.set_float(mpx.."DIST_SWIMMING", value*1000) end)
distancestat:add_float_range("Caminando", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_WALKING")/1000 end, function(value) stats.set_float(mpx.."DIST_WALKING", value*1000) end)
distancestat:add_float_range("Corriendo", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_RUNNING")/1000 end, function(value) stats.set_float(mpx.."DIST_RUNNING", value*1000) end)
distancestat:add_float_range("Caida libre mas sobrevivida", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."LONGEST_SURVIVED_FREEFALL") end, function(value) stats.set_float(mpx.."LONGEST_SURVIVED_FREEFALL", value) end)
distancestat:add_float_range("Conduccion de coches", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_CAR")/1000 end, function(value) stats.set_float(mpx.."DIST_CAR", value*1000) end)
distancestat:add_float_range("Conducir motos", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_BIKE")/1000 end, function(value) stats.set_float(mpx.."DIST_BIKE", value*1000) end)
distancestat:add_float_range("Volando helis", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_HELI")/1000 end, function(value) stats.set_float(mpx.."DIST_HELI", value*1000) end)
distancestat:add_float_range("Volando aviones", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_PLANE")/1000 end, function(value) stats.set_float(mpx.."DIST_PLANE", value*1000) end)
distancestat:add_float_range("Conduciendo botes", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_BOAT")/1000 end, function(value) stats.set_float(mpx.."DIST_BOAT", value*1000) end)
distancestat:add_float_range("Conduciendo ATVs", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_QUADBIKE")/1000 end, function(value) stats.set_float(mpx.."DIST_QUADBIKE", value*1000) end)
distancestat:add_float_range("Conduciendo Bicycletas", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."DIST_BICYCLE")/1000 end, function(value) stats.set_float(mpx.."DIST_BICYCLE", value*1000) end)
distancestat:add_float_range("Parada mas lejana", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."LONGEST_STOPPIE_DIST")/1000 end, function(value) stats.set_float(mpx.."LONGEST_STOPPIE_DIST", value*1000) end)
distancestat:add_float_range("Sobre 1 rueda mas lejana", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."LONGEST_WHEELIE_DIST")/1000 end, function(value) stats.set_float(mpx.."LONGEST_WHEELIE_DIST", value*1000) end)
distancestat:add_float_range("Conduccion mas larga sin estrellarte", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."LONGEST_DRIVE_NOCRASH")/1000 end, function(value) stats.set_float(mpx.."LONGEST_DRIVE_NOCRASH", value*1000) end)
distancestat:add_float_range("Salto mas largo en veh", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."FARTHEST_JUMP_DIST") end, function(value) stats.set_float(mpx.."FARTHEST_JUMP_DIST", value) end)
distancestat:add_float_range("Salto mas alto en veh", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."HIGHEST_JUMP_REACHED") end, function(value) stats.set_float(mpx.."HIGHEST_JUMP_REACHED", value) end)
distancestat:add_float_range("Salto hidraulico mas alto", 10.00, 0.00, 99999.00, function() return stats.get_float(mpx.."LOW_HYDRAULIC_JUMP") end, function(value) stats.set_float(mpx.."LOW_HYDRAULIC_JUMP", value) end)

timestat:add_int_range("Tiempo en primera persona", 1, 0, 24, function() return math.floor(stats.get_int("MP_FIRST_PERSON_CAM_TIME")/86400000) end, function(value) stats.set_int("MP_FIRST_PERSON_CAM_TIME", value*86400000) end)
timestat:add_int_range("Tiempo en gta online", 1, 0, 24, function() return math.floor(stats.get_int("MP_PLAYING_TIME")/86400000) end, function(value) stats.set_int("MP_PLAYING_TIME", value*86400000) end)
timestat:add_int_range("Tiempo en dm's", 1, 0, 24, function() return math.floor(stats.get_int("MPPLY_TOTAL_TIME_SPENT_DEATHMAT")/86400000) end, function(value) stats.set_int("MPPLY_TOTAL_TIME_SPENT_DEATHMAT", value*86400000) end)
timestat:add_int_range("Tiempo en carreras", 1, 0, 24, function() return math.floor(stats.get_int("MPPLY_TOTAL_TIME_SPENT_RACES")/86400000) end, function(value) stats.set_int("MPPLY_TOTAL_TIME_SPENT_RACES", value*86400000) end)
timestat:add_int_range("Tiempo en modo creador", 1, 0, 24, function() return math.floor(stats.get_int("MPPLY_TOTAL_TIME_MISSION_CREATO")/86400000) end, function(value) stats.set_int("MPPLY_TOTAL_TIME_MISSION_CREATO", value*86400000) end)
timestat:add_int_range("Sesion mas larga solo", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."LONGEST_PLAYING_TIME")/86400000) end, function(value) stats.set_int(mpx.."LONGEST_PLAYING_TIME", value*86400000) end)
timestat:add_int_range("Tiempo como personaje", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TOTAL_PLAYING_TIME")/86400000) end, function(value) stats.set_int(mpx.."TOTAL_PLAYING_TIME", value*86400000) end)
timestat:add_int_range("Tiempo promedio en sesiones", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."AVERAGE_TIME_PER_SESSON")/86400000) end, function(value) stats.set_int(mpx.."AVERAGE_TIME_PER_SESSON", value*86400000) end)
timestat:add_int_range("Tiempo nadando", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_SWIMMING")/86400000) end, function(value) stats.set_int(mpx.."TIME_SWIMMING", value*86400000) end)
timestat:add_int_range("Tiempo bajo el awa", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_UNDERWATER")/86400000) end, function(value) stats.set_int(mpx.."TIME_UNDERWATER", value*86400000) end)
timestat:add_int_range("Tiempo caminando", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_WALKING")/86400000) end, function(value) stats.set_int(mpx.."TIME_WALKING", value*86400000) end)
timestat:add_int_range("Tiempo en cobertura", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_IN_COVER")/86400000) end, function(value) stats.set_int(mpx.."TIME_IN_COVER", value*86400000) end)
timestat:add_int_range("Tiempo con estreias", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TOTAL_CHASE_TIME")/86400000) end, function(value) stats.set_int(mpx.."TOTAL_CHASE_TIME", value*86400000) end)
timestat:add_float_range("Ultima duracion wantiado", 1.0, 0.0, 24.0, function() return math.floor(stats.get_float(mpx.."LAST_CHASE_TIME")/86400000) end, function(value) stats.set_float(mpx.."LAST_CHASE_TIME", value*86400000) end)
timestat:add_float_range("Duracion wantiada mas larga", 1.0, 0.0, 24.0, function() return math.floor(stats.get_float(mpx.."LONGEST_CHASE_TIME")/86400000) end, function(value) stats.set_float(mpx.."LONGEST_CHASE_TIME", value*86400000) end)
timestat:add_float_range("5 estreias", 1.0, 0.0, 24.0, function() return math.floor(stats.get_float(mpx.."TOTAL_TIME_MAX_STARS")/86400000) end, function(value) stats.set_float(mpx.."TOTAL_TIME_MAX_STARS", value*86400000) end)
timestat:add_action("Me dio pereza, es tiempo", function() end)
timestat:add_int_range("Condusiendo coches", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_CAR")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_CAR", value*86400000) end)
timestat:add_int_range("En moto", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_BIKE")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_BIKE", value*86400000) end)
timestat:add_int_range("En chop-chops", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_HELI")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_HELI", value*86400000) end)
timestat:add_int_range("En aviones", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_PLANE")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_PLANE", value*86400000) end)
timestat:add_int_range("En botes", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_BOAT")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_BOAT", value*86400000) end)
timestat:add_int_range("Conduciendo ATVs", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_QUADBIKE")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_QUADBIKE", value*86400000) end)
timestat:add_int_range("En motos", 1, 0, 24, function() return math.floor(stats.get_int(mpx.."TIME_DRIVING_BICYCLE")/86400000) end, function(value) stats.set_int(mpx.."TIME_DRIVING_BICYCLE", value*86400000) end)

multMenu = OnlMenu:add_submenu("Multiplicadores")
multMenu:add_float_range("RP", 1, 1, 100000, function() return globals.get_float(262146) end, function(v) globals.set_float(262146, v) end)
multMenu:add_float_range("AP", 1, 1, 100000, function() return globals.get_float(288060) end, function(v) globals.set_float(288060, v) end)
multMenu:add_float_range("Carreras Callejeras", 1, 1, 100000, function() return globals.get_float(293783) end, function(v) globals.set_float(293783, v) end)
multMenu:add_float_range("Persecuciones", 1, 1, 100000, function() return globals.get_float(293784) end, function(v) globals.set_float(293784, v) end)
multMenu:add_float_range("Face2Face", 1, 1, 100000, function() return globals.get_float(293786) end, function(v) globals.set_float(293786, v) end)
multMenu:add_float_range("LS Juntada De Coches", 1, 1, 100000, function() return globals.get_float(293787) end, function(v) globals.set_float(293787, v) end)
multMenu:add_float_range("LS Juntada De Coches Drift", 1, 1, 100000, function() return globals.get_float(293788) end, function(v) globals.set_float(293788, v) end) local awa = 0 local awc = 0 local awr = 0
multMenu:add_int_range("AP Arena Wars", 5000, 0, 500000, function() return awa end, function(v) for i = 286232, 286234 do globals.set_int(i, v) end for j = 286241, 286243 do globals.set_int(j, v) end awa = v end)

OnlMenu:add_action("--------------- Recovery / Misiones ----------------", function() end)

cayoPericoMenu = OnlMenu:add_submenu("Cayo Perico (MU)") 
cayoPericoMenu:add_array_item("Configs", {"H.Panther Only", "H.PinkD Only", "H.B.Bonds Only", "H.R.Necklace Only", "H.Tequila Only", "N.Panther Only", "N.PinkD Only", "N.B.Bonds Only", "N.R.Necklace Only", "N.Tequila Only"}, function() return xox_15 end, function(v) if v == 1 then stats.set_int(mpx.."H4_PROGRESS", 131055) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 5) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT_V", 403500) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 2 then stats.set_int(mpx.."H4_PROGRESS", 131055) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 3) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 3 then stats.set_int(mpx.."H4_PROGRESS", 131055) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 2) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 4 then stats.set_int(mpx.."H4_PROGRESS", 131055) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 1) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 5 then stats.set_int(mpx.."H4_PROGRESS", 131055) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 0) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 6 then stats.set_int(mpx.."H4_PROGRESS", 126823) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 5) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 7 then stats.set_int(mpx.."H4_PROGRESS", 126823) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 3) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 8 then stats.set_int(mpx.."H4_PROGRESS", 126823) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 2) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 9 then stats.set_int(mpx.."H4_PROGRESS", 126823) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 1) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT_V", 403500) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) stats.set_int(mpx.."H4LOOT_COKE_I", 0) elseif v == 10 then stats.set_int(mpx.."H4_PROGRESS", 126823) stats.set_int(mpx.."H4_MISSIONS", 65535) stats.set_int(mpx.."H4CNF_TARGET", 0) stats.set_int(mpx.."H4CNF_WEAPONS", 2) stats.set_int(mpx.."H4CNF_UNIFORM", -1) stats.set_int(mpx.."H4CNF_TROJAN", 5) stats.set_int(mpx.."H4LOOT_GOLD_C", 0) stats.set_int(mpx.."H4LOOT_GOLD_C_SCOPED", 0) stats.set_int(mpx.."H4LOOT_PAINT", 0) stats.set_int(mpx.."H4LOOT_PAINT_SCOPED", 0) stats.set_int(mpx.."H4LOOT_CASH_I", 0) stats.set_int(mpx.."H4LOOT_CASH_C", 0) stats.set_int(mpx.."H4LOOT_WEED_I", 0) end xox_15 = v end)
cayoPericoMenu:add_array_item("Objetivos principales", {"Tequila", "Ruby Necklace", "Bearer Bonds", "Pink Diamond", "Panther Statue"}, function() return xox_0 end, function(value) xox_0 = value if value == 1 then stats.set_int(mpx .. "H4CNF_TARGET", 0) elseif value == 2 then stats.set_int(mpx .. "H4CNF_TARGET", 1) elseif value == 3 then stats.set_int(mpx .. "H4CNF_TARGET", 2) elseif value == 4 then stats.set_int(mpx .. "H4CNF_TARGET", 3) elseif value == 5 then stats.set_int(mpx .. "H4CNF_TARGET", 5) end end)
StMenu = cayoPericoMenu:add_submenu("Objetivos secundarios") 
StMenu:add_array_item("Almacenes de la isla", {"Gold", "Paintings", "Cocaine", "Weed", "Cash"}, function() return xox_1 end, function(value) if value == 1 then stats.set_int(mpx .. "H4LOOT_GOLD_C", -1) stats.set_int(mpx .. "H4LOOT_GOLD_C_SCOPED", -1) elseif value == 2 then stats.set_int(mpx .. "H4LOOT_PAINT", -1) stats.set_int(mpx .. "H4LOOT_PAINT_SCOPED", -1) stats.set_int(mpx .. "H4LOOT_PAINT_V", 403500) elseif value == 3 then stats.set_int(mpx .. "H4LOOT_COKE_C", -1) stats.set_int(mpx .. "H4LOOT_COKE_C_SCOPED", -1) elseif value == 4 then stats.set_int(mpx .. "H4LOOT_WEED_C", -1) stats.set_int(mpx .. "H4LOOT_WEED_C_SCOPED", -1) elseif value == 5 then stats.set_int(mpx .. "H4LOOT_CASH_C", -1) stats.set_int(mpx .. "H4LOOT_CASH_C_SCOPED", -1) end xox_1 = value end)
cayoPericoMenu:add_action("Todas las preparativas", function() stats.set_int(mpx .. "H4CNF_BS_GEN", -1) stats.set_int(mpx .. "H4CNF_BS_ENTR", 63) stats.set_int(mpx .. "H4CNF_APPROACH", -1) end) 
cayoPericoMenu:add_action("-------------------------", function() end)
cayoPericoMenu:add_toggle("Remover camaras", function() return e6 end, function() e6 = not e6 Cctv(e6) end) 
cayoPericoMenu:add_action("Saltar escena del drenaje", function() if fmC2020:is_active() then if fmC2020:get_int(277374) >= 3 or fmC2020:get_int(277374) <= 6 then fmC2020:set_int(277374, 6) end end end) 
cayoPericoMenu:add_action("Saltar escena Clonar Huellas", function() if fmC and fmC:is_active() then if fmC:get_int(22032) == 4 then fmC:set_int(22032, 5) end end end)
cayoPericoMenu:add_action("Saltar escena de hackear puerta", function() if fmC and fmC:is_active() then if fmC:get_int(54024) ~= 4 then fmC:set_int(54024, 5) end end end)
cayoPericoMenu:add_action("Cortador Plasma Rapido", function() fmC2020:set_float(29688, 100) end) 
cayoPericoMenu:add_int_range("Vidas En Cayo - Self", 1.0, 1, 999999999, function() return fmC2020:get_int(49513) end, function(life) if fmC2020 and fmC2020:is_active() then fmC2020:set_int(49512 + 1, life) end end)
cayoPericoMenu:add_action("------------ Rapido -------------", function() end)
cayoPericoMenu:add_action("Completar Las Preparaciones", function() stats.set_int(mpx .. "H4CNF_UNIFORM", -1) stats.set_int(mpx .. "H4CNF_GRAPPEL", -1) stats.set_int(mpx .. "H4CNF_TROJAN", 5) stats.set_int(mpx .. "H4CNF_WEP_DISRP", 3) stats.set_int(mpx .. "H4CNF_ARM_DISRP", 3) stats.set_int(mpx .. "H4CNF_HEL_DISRP", 3) end)
cayoPericoMenu:add_action("Terminar Instantaneamente", function() fmC2020:set_int(19679, 12) fmC2020:set_int(22365, 10000000) fmC2020:set_int(28299, 99999) fmC2020:set_int(31623, 99999) end)
cayoPericoMenuc = cayoPericoMenu:add_submenu("Partes Para Jugadores") 
cayoPericoMenu:add_int_range("Jugador 1", 1, 15, 300, function() return globals.get_int(271541) end, function(value) globals.set_int(271541, value) end) 
cayoPericoMenu:add_int_range("Jugador 2", 1, 15, 300, function() return globals.get_int(283790) end, function(value) globals.set_int(283790, value) end) 

nMenu = OnlMenu:add_submenu("Club Nocturno")
nMenu:add_action("Popularidad al 100%", function() stats.set_int(mpx .. "CLUB_POPULARITY", 1000) end)

cccMenu = OnlMenu:add_submenu("Casino (MU)")

cccMenu:add_array_item("Objetivo", {"Dinero", "Oro", "Arte", "Diamantes"}, function() return xox_8 end, function(v) if v == 1 then stats.set_int(mpx .. "H3OPT_TARGET", 0) elseif v == 2 then stats.set_int(mpx .. "H3OPT_TARGET", 1) elseif v == 3 then stats.set_int(mpx .. "H3OPT_TARGET", 2) elseif v == 4 then stats.set_int(mpx .. "H3OPT_TARGET", 3) end xox_8 = v end)
cccMenu:add_action("---[[Completar preparaciones - Final]]--", function() stats.set_int(mpx .. "H3OPT_DISRUPTSHIP", 3) stats.set_int(mpx .. "H3OPT_KEYLEVELS", 2) stats.set_int(mpx .. "H3OPT_VEHS", 3) stats.set_int(mpx .. "H3OPT_WEAPS", 0) stats.set_int(mpx .. "H3OPT_BITSET0", -1) stats.set_int(mpx .. "H3OPT_BITSET1", -1) stats.set_int(mpx .. "H3OPT_COMPLETEDPOSIX", -1) end)
cccMenu:add_action("---[[Reiniciar Golpes]]---", function() stats.set_int(mpx .. "H3OPT_BITSET1", 0) stats.set_int(mpx .. "H3OPT_BITSET0", 0) end) 
cccMenu:add_action("------------------------------------------", function() end)
cccMenu:add_action("Todos los puntos de acceso", function() stats.set_int(mpx .. "H3OPT_POI", -1) stats.set_int(mpx .. "H3OPT_ACCESSPOINTS", -1) end)
cccMenu:add_action("Remover Cooldown Del Golpe", function() stats.set_int(mpx .. "H3_COMPLETEDPOSIX", -1) stats.set_int("MPPLY_H3_COOLDOWN", -1) end)
--cccMenu:add_action("Primero golpe/Desbloquea lester", function() stats.set_int(mpx .. "CAS_HEIST_NOTS", -1) stats.set_int(mpx .. "CAS_HEIST_FLOW", -1) end) local function DCHC(e) if not localplayer then return end if e then for i = 290950, 290964 do globals.set_int(i, 0) end globals.set_int(290600, 0) else globals.set_int(290600, 5) globals.set_int(290950, 5) globals.set_int(290951, 9) globals.set_int(290952, 7) globals.set_int(290953, 10) globals.set_int(290954, 8) globals.set_int(290955, 5) globals.set_int(290956, 7) globals.set_int(290957, 9) globals.set_int(290958, 6) globals.set_int(290959, 10) globals.set_int(290960, 3) globals.set_int(290961, 7) globals.set_int(290962, 5) globals.set_int(290963, 10) globals.set_int(290964, 9) end end 
cccMenu:add_toggle("Remover Costos De Lester", function() return e8 end, function() e8 = not e8 DCHC(e8) end) 
cccMenu:add_action("--------", function() end) 
cccMenu:add_int_range("Vidas Del Casino - Tu Solo", 1, 1, 10, function() return fmC:get_int(26105 + 1322 + 1) end, function(life) if fmC and fmC:is_active() then fmC:set_int(26105 + 1322 + 1,life) end end)
cccMenu:add_action("Suicidarse", function() menu.suicide_player() end) 
cccMenu:add_action("Quitar Hackeo De Huellas ", function() if fmC and fmC:is_active() then if fmC:get_int(52962) == 4 then fmC:set_int(52962, 5) end end end)
cccMenu:add_action("Quitar Hackeo De Puerta ", function() if fmC and fmC:is_active() then if fmC:get_int(54024) ~= 4 then fmC:set_int(54024, 5) end end end)
--cccMenu:add_action("Quitar Perforar Boveda", function() if fmC:is_active() then fmC:set_int(10098 + 7, 4) sleep(0.01) fmC:set_int(10098 + 7, 6) menu.send_key_press(1) end end)
cccMenu:add_toggle("Quitar CCTV", function() return e7 end, function() e7 = not e7 casCctv(e7) end) 
cccMenu:add_action("Matar NPC De La Mision", function() menu.kill_all_mission_peds() end) 
cccMenu:add_action("Matar Todos los NPC", function() menu.kill_all_npcs() end)
cccMenu:add_int_range("Real Take", 100000, 1000000, 10000000, function() return fmC:get_int(22365) end, function(v) fmC:set_int(22365, v) end)
CDNCMenu = cccMenu:add_submenu("Cantidades") 
CDNCMenu:add_int_range("Jugador 1", 5, 15, 300, function() return globals.get_int(1974022) end, function(value) globals.set_int(1974022, value) end) 
CDNCMenu:add_int_range("Jugador 2", 5, 15, 300, function() return globals.get_int(1974023) end, function(value) globals.set_int(1974023, value) end) 
CDNCMenu:add_int_range("Jugador 3", 5, 15, 300, function() return globals.get_int(1974024) end, function(value) globals.set_int(1974024, value) end) 
CDNCMenu:add_int_range("Jugador 4", 5, 15, 300, function() return globals.get_int(1974025) end, function(value) globals.set_int(1974025, value) end) 
--CDNPMenu = cccMenu:add_submenu("Editor Potencial")
--[[
CDNPMenu:add_int_range("Dinero Potencial", 1000000000.0, 2115000, 1000000000, function() return globals.get_int(290938) end, function(value) globals.set_int(290938, value) end) 
CDNPMenu:add_int_range("Arte Potencial", 1000000000.0, 2350000, 1000000000, function() return globals.get_int(290939) end, function(value) globals.set_int(290939, value) end) 
CDNPMenu:add_int_range("Oro Potencial", 1000000000.0, 2585000, 1000000000, function() return globals.get_int(290940) end, function(value) globals.set_int(290940, value) end) 
CDNPMenu:add_int_range("Diamante Potencial", 1000000000.0, 3290000, 1000000000, function() return globals.get_int(290941) end, function(value) globals.set_int(290941, value) end) 
]]
cccMenu:add_array_item("Teletransportes", {"Vault swipe", "Staff Door Exit", "Laundry room", "Bonus room", "Roof exit"}, function() return xox_14 end, function(value) if value == 1 then TeleportPlayer(2468.646973, -279.083374, -71.994194, -1.083554, 0.000000, 0.000000) elseif value == 2 then TeleportPlayer(2547.458496, -277.744507, -59.741863, -0.071993, 0.005218, -0.113118) elseif value == 3 then TeleportPlayer(2536.455078, -300.772522, -60.022968, 0.000000, 0.000000, 0.000000) elseif value == 4 then TeleportPlayer(2521.906494, -287.172882, -60.022964, 0.000000, 0.000000, 0.000000) elseif value == 5 then TeleportPlayer(2522.338379, -248.534760, -25.414972, 0.000000, 0.000000, 0.000000) end xox_14 = value end)

csMenu = OnlMenu:add_submenu("Contratos")

script_name = "fm_mission_controller_2020"
AutoShop_passed_trigger = 38397
AutoShop_heist_passed_value = 39772

csMenu:add_action("Terminar misiones de DRE", function()
	PlayerIndex = globals.get_int(1574918)
	if PlayerIndex == 0 then
		stats.set_int("MP0_FIXER_STORY_BS", 4092)
		stats.set_int("MP0_FIXER_STORY_STRAND", -1)
	else
		stats.set_int("MP1_FIXER_STORY_BS", 4092)
		stats.set_int("MP1_FIXER_STORY_STRAND", -1)
	end
end)

csMenu:add_action("Saltar Golpe (instantaneo)", function()
    if(script(script_name):is_active()) then
        script(script_name):set_int(AutoShop_passed_trigger, 51338976)
        script(script_name):set_int(AutoShop_heist_passed_value, 101)
    end
end)

protMenu = mainMenu:add_submenu("Protecciones")

local function Text(text)
	protMenu:add_action(text, function() end)
end

Text("Protecciones")
Text("----------")

local function KickCrashes(bool)
	if bool then 
		globals.set_bool(1669936, true)
		globals.set_bool(1669663, true)
		globals.set_bool(1669818, true)
		globals.set_bool(1669833, true)
		globals.set_bool(1669733, true)
		globals.set_bool(1669810, true)
		globals.set_bool(1670028, true)
	else
		globals.set_bool(1669936, false)
		globals.set_bool(1669663, false)
		globals.set_bool(1669818, false)
		globals.set_bool(1669833, false)
		globals.set_bool(1669733, false)
		globals.set_bool(1669810, false)
		globals.set_bool(1670028, false)
	end
end

local function CeoKick(bool)
	if bool then 
		globals.set_bool(1669766, true) 
	else
		globals.set_bool(1669766, false)
	end
end

local function CeoBan(bool)
	if bool then 
		globals.set_bool(1669788, true) 
	else
		globals.set_bool(1669788, false)
	end
end

local function SoundSpam(bool)
	if bool then 
		globals.set_bool(1669661, true)
		globals.set_bool(1670033, true)
		globals.set_bool(1669211, true)
		globals.set_bool(1670529, true)
		globals.set_bool(1669840, true)
		globals.set_bool(1669228, true)

	else
		globals.set_bool(1669661, false)
		globals.set_bool(1670033, false)
		globals.set_bool(1669211, false)
		globals.set_bool(1670529, false)
		globals.set_bool(1669840, false)
		globals.set_bool(1669228, false)
	end
end

local function InfiniteLoad(bool)
	if bool then 		
		globals.set_bool(1669729, true) 
		globals.set_bool(1669858, true)
	else
		globals.set_bool(1669729, false)
		globals.set_bool(1669858, false)
	end
end


local function Collectibles(bool)
	if bool then 
		globals.set_bool(1669998, true) 
	else
		globals.set_bool(1669998, false)
	end
end

local function PassiveMode(bool)
	if bool then 
		globals.set_bool(1669778, true) 
	else
		globals.set_bool(1669778, false)
	end
end

local function TransactionError(bool) 
	if bool then 
		globals.set_bool(1669579, true) 
	else
		globals.set_bool(1669579, false)
	end
end

local function RemoveMoneyMessage(bool) 
	if bool then 
		globals.set_bool(1669662, true)
		globals.set_bool(1669233, true)
		globals.set_bool(1669839, true)
	else
		globals.set_bool(1669662, false)
		globals.set_bool(1669233, false)
		globals.set_bool(1669839, false)
	end
end

local function ExtraTeleport(bool) 
	if bool then 
		globals.set_bool(1669534, true) 
		globals.set_bool(1669928, true) 
		globals.set_bool(1670027, true) 
		globals.set_bool(1670028, true) 
		globals.set_bool(1670023, true) 
	else
		globals.set_bool(1669534, false) 
		globals.set_bool(1669928, false) 
		globals.set_bool(1670027, false) 
		globals.set_bool(1670028, false) 
		globals.set_bool(1670023, false) 
	end
end


local function ClearWanted(bool) 
	if bool then 
		globals.set_bool(1669720, true)
	else
		globals.set_bool(1669720, false)
	end
end

local function OffTheRadar(bool) 
	if bool then 
		globals.set_bool(1669722, true)
	else
		globals.set_bool(1669722, false)
	end
end

local function SendCutscene(bool) 
	if bool then 
		globals.set_bool(1669988, true)
	else
		globals.set_bool(1669988, false)
	end
end

local function Godmode(bool) 
	if bool then 
		globals.set_bool(1669213, true)
	else
		globals.set_bool(1669213, false)
	end
end

local function PersonalVehicleDestroy(bool) 
	if bool then 
		globals.set_bool(1669284, true)
		globals.set_bool(1669845, true) 
		
	else
		globals.set_bool(1669284, false)
		globals.set_bool(1669845, false) 
	end
end

local function SocialClubSpam(bool) 
	if bool then 
		globals.set_bool(1669284, true)
		globals.set_bool(1669845, true) 
		
	else
		globals.set_bool(1669284, false)
		globals.set_bool(1669845, false) 
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
	ClearWanted(bool)
	OffTheRadar(bool)
	PersonalVehicleDestroy(bool)
	SendCutscene(bool)
	Godmode(bool)
	Collectibles(bool)
	ExtraTeleport(bool)
	KickCrashes(bool)
end

protMenu:add_toggle("Activar todo", function()
	return boolall
end, function()
	boolall = not boolall
	All(boolall)
	
end)
Text("--")

protMenu:add_toggle("Blockear SE Crash", function()
	return boolcbt
end, function()
	boolcbt = not boolcbt
	KickCrashes(boolcbt)
	
end)

protMenu:add_toggle("Bloquear Ceo Kick", function()
	return boolktsp
end, function()
	boolktsp = not boolktsp
	CeoKick(boolktsp)
end)

protMenu:add_toggle("Bloquear Ceo Ban", function()
	return boolcb
end, function()
	boolcb = not boolcb
	CeoBan(boolcb)
	
end)

protMenu:add_toggle("Bloquear sonido no deseado", function()
	return boolsps
end, function()
	boolsps = not boolsps
	SoundSpam(boolsps)
	
end)

protMenu:add_toggle("Bloquear pantalla de carga infinita", function()
	return boolil
end, function()
	boolil = not boolil
	InfiniteLoad(boolil)
	
end)

protMenu:add_toggle("Bloquear modo pasivo", function()
	return boolb
end, function()
	boolb = not boolb
	PassiveMode(boolb)
	
end)

protMenu:add_toggle("Bloquear error de transacción", function()
	return boolte
end, function()
	boolte = not boolte
	TransactionError(boolte)
	
end)

protMenu:add_toggle("Bloquear notificaciones modificadas/SMS", function()
	return boolrm
end, function()
	boolrm = not boolrm
	RemoveMoneyMessage(boolrm)
	
end)

protMenu:add_toggle("Bloquear Borrar buscado", function()
	return boolclw
end, function()
	boolclw = not boolclw
	ClearWanted(boolclw)
	
end)

protMenu:add_toggle("Bloquear fuera del radar", function()
	return boolotr
end, function()
	boolotr = not boolotr
	OffTheRadar(boolotr)
	
end)

protMenu:add_toggle("Bloquear destrucción de vehículos personales", function()
	return boolpvd
end, function()
	boolpvd = not boolpvd
	PersonalVehicleDestroy(boolpvd)
	
end)

protMenu:add_toggle("Bloquear enviar a escena", function()
	return boolstc
end, function()
	boolstc = not boolstc
	SendCutscene(boolstc)
	
end)

protMenu:add_toggle("Bloquear Eliminar Modo Dios", function()
	return boolgod
end, function()
	boolgod = not boolgod
	Godmode(boolgod)
	
end)

protMenu:add_toggle("Bloquear dar coleccionables", function()
	return boolgc
end, function()
	boolgc = not boolgc
	Collectibles(boolgc)
	
end)

protMenu:add_toggle("Bloquear Cayo perico y tp a la playa", function()
	return boolcbt
end, function()
	boolcbt = not boolcbt
	ExtraTeleport(boolcbt)
	
end)

vehMenu = mainMenu:add_submenu("Vehiculos")

vehMenu:add_toggle("Modo Dios Vehiculo", function() return vehiclegodmode end, function() if localplayer ~= nil and localplayer:is_in_vehicle() then localplayer:get_current_vehicle():set_godmode(true) end end)

F1Mod = false
OldF1Hash = 0
vehMenu:add_toggle("Ruedas de Formula 1", function()
	return F1Mod
end, function()
	F1Mod = not F1Mod
	if F1Mod then
		if localplayer ~= nil then
			if localplayer:is_in_vehicle() then
				OldF1Hash = localplayer:get_current_vehicle():get_model_hash()
				localplayer:get_current_vehicle():set_model_hash(1492612435)
			end
		end
	else
		if localplayer ~= nil then
			if localplayer:is_in_vehicle() then
				localplayer:get_current_vehicle():set_model_hash(OldF1Hash)
			end
		end
	end
end)

BennyMod = false
OldBennyHash = 0
vehMenu:add_toggle("Ruedas de Bennys", function()
	return BennyMod
end, function()
	BennyMod = not BennyMod
	if BennyMod then
		if localplayer ~= nil then
			if localplayer:is_in_vehicle() then
				OldBennyHash = localplayer:get_current_vehicle():get_model_hash()
				localplayer:get_current_vehicle():set_model_hash(196747873)
			end
		end
	else
		if localplayer ~= nil then
			if localplayer:is_in_vehicle() then
				localplayer:get_current_vehicle():set_model_hash(OldBennyHash)
			end
		end
	end
end)

recMenu = mainMenu:add_submenu("Recovery $$$")
recMenu:add_action("No me hago responsable", function() end)
recMenu:add_action("De mal uso", function() end)

recMenu:add_action("----------------- Desbloqueos ----------------", function() end)

recMenu:add_action("Desbloquear Todo", function()
for i = 293419, 293446 do globals.set_float(i,100000) end end)

rec2Menu = recMenu:add_submenu("Desbloqueos De Bools")
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

recMenu:add_action("----------------- Bunker ----------------", function() end)

recMenu:add_action("Desbloquear Investi De bunker", function()
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
	bitSize = 8 for j = 0, 64 / bitSize - 1 do
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

recMenu:add_array_item("Inve De Bunker", {"Acelerar", "Resetear"}, function() return xox_26 end, function(value) if value == 1 then globals.set_int(286202, 1) globals.set_int(293353, 1) globals.set_int(283737, 1) globals.set_int(283275, 1) menu.trigger_bunker_research() elseif value == 2 then globals.set_int(286202, 60) globals.set_int(283737, 45000) globals.set_int(293353, 300000) globals.set_int(283275, 45000) end xox_26 = value end)

recMenu:add_action("----------------- Misc ----------------", function() end)

recMenu:add_action("Desbloquear Contactos", function()
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

recMenu:add_action("Desbloquear Pinturas/Cosas De LSC", function()
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

recMenu:add_action("Desbloquear Armas", function()
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

recMenu:add_action("Desbloquear Librerias Ocultas", function() stats.set_int("MPPLY_XMASLIVERIES", -1) for i = 1, 20 do stats.set_int("MPPLY_XMASLIVERIES"..i, -1) end end)

recMenu:add_action("Escuela De Viaje", function() stats.set_int("MPPLY_NUM_CAPTURES_CREATED", 100) for i = 0, 9 do stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_"..i, -1) stats.set_int(mpx.. "PILOT_SCHOOL_MEDAL_"..i, -1) stats.set_bool(mpx .. "PILOT_ASPASSEDLESSON_"..i, true) end end)
recMenu:add_action("Campo De Tiro", function() stats.set_int(mpx .. "SR_HIGHSCORE_1", 690) stats.set_int(mpx .. "SR_HIGHSCORE_2", 1860) stats.set_int(mpx .. "SR_HIGHSCORE_3", 2690) stats.set_int(mpx .. "SR_HIGHSCORE_4", 2660) stats.set_int(mpx .. "SR_HIGHSCORE_5", 2650) stats.set_int(mpx .. "SR_HIGHSCORE_6", 450) stats.set_int(mpx .. "SR_TARGETS_HIT", 269) stats.set_int(mpx .. "SR_WEAPON_BIT_SET", -1) stats.set_bool(mpx .. "SR_TIER_1_REWARD", true) stats.set_bool(mpx .. "SR_TIER_3_REWARD", true) stats.set_bool(mpx .. "SR_INCREASE_THROW_CAP", true) end)
recMenu:add_action("Vanilla Unicorn", function() stats.set_int(mpx .. "LAP_DANCED_BOUGHT", 0) stats.set_int(mpx .. "LAP_DANCED_BOUGHT", 5) stats.set_int(mpx .. "LAP_DANCED_BOUGHT", 10) stats.set_int(mpx .. "LAP_DANCED_BOUGHT", 15) stats.set_int(mpx .. "LAP_DANCED_BOUGHT", 25) stats.set_int(mpx .. "PROSTITUTES_FREQUENTED", 1000) end)
recMenu:add_action("Desbloquear Tatuajes", function() stats.set_int(mpx .. "TATTOO_FM_CURRENT_32", -1) for i = 0, 47 do stats.set_int(mpx .. "TATTOO_FM_UNLOCKS_"..i, -1) end end)

dinMenu = mainMenu:add_submenu("Dinero $$$")

local function Text(text)
	dinMenu:add_action(text, function() end)
end
dinMenu:add_action("No soy responsable del uso o algun", function() end)
dinMenu:add_action("baneo, es seguro hasta cierto punto", function() end)
dinMenu:add_action("Los quiero, picho <3", function() end)
dinMenu:add_action("-------------------------------------------", function() end)

cajMenu = dinMenu:add_submenu("Cajas CEO")
local function CCooldown(e) if not localplayer then return end if e then globals.set_int(280702, 0) globals.set_int(283440, 0) else globals.set_int(280702, 300000) globals.set_int(283440, 1800000) end end 
cajMenu:add_toggle("Remover Cooldowns", function() return e13 end, function() e13 = not e13 CCooldown(e13) end)
cajMenu:add_toggle("Cargo Unica", function() return globals.get_boolean(292132) end, function(value) globals.set_boolean(292132, value) end) 
cajMenu:add_array_item("Poner Cargamento Unico 'Sin Testear'", {"Huevito", "Minigun Dorada", "Diamante", "Pieles", "Disco De Peli", "Reloj Cohete"}, function() return xox_33 end, function(value) xox_33 = value if value == 1 then globals.set_int(292132, 1) globals.set_int(UNC2, 2) elseif value == 2 then globals.set_int(292132, 1) globals.set_int(UNC2, 4) elseif value == 3 then globals.set_int(292132, 1) globals.set_int(UNC2, 6) elseif value == 4 then globals.set_int(292132, 1) globals.set_int(UNC2, 7) elseif value == 5 then globals.set_int(292132, 1) globals.set_int(UNC2, 8) else globals.set_int(292132, 1) globals.set_int(UNC2, 9) end end) 
cajMenu:add_action("-------Testeado:solo public; ~Max=6M------------", function() end)

ediCaj = cajMenu:add_submenu("Editor de datos")

--cajMenu:add_int_range("Resetear Estatus De Ventas", 1, 0, 1000, function() return stats.get_int(mpx .. "LIFETIME_SELL_COMPLETE") end, function(value) stats.set_int(mpx .. "LIFETIME_BUY_COMPLETE", value) stats.set_int(mpx .. "LIFETIME_BUY_UNDERTAKEN", value) stats.set_int(mpx .. "LIFETIME_SELL_COMPLETE", value) stats.set_int(mpx .. "LIFETIME_SELL_UNDERTAKEN", value) stats.set_int(mpx .. "LIFETIME_CONTRA_EARNINGS", value * 20000) globals.set_int(SCG1, 1) globals.set_int(SCG2, 1) sleep(0.2) globals.set_int(SCG2, 0) end)

ccMenu = dinMenu:add_submenu("Club Nocturno")


local isRunning = false
ccMenu:add_toggle("Loop De Caja Fuerte $250k/10s (AFK)", function() return isRunning end, function() isRunning = not isRunning safeLoop(isRunning) end)

e51 = false
e52 = false
e53 = false
acidMenu = dinMenu:add_submenu("Laboratorio De Acido $$$")
function AL(e) if not localplayer then return end if e then globals.set_int(279721, 0) else globals.set_int(279721, 135000) end end 
function AC(e) if not localplayer then return end if e then globals.set_int(284958, 0) else globals.set_int(284958, 300000) end end 
function ACL(e) if not localplayer then return end if e then globals.set_int(285557, 0) globals.set_int(277942, 0) else globals.set_int(285557, 12000) globals.set_int(277942, 12000) end end
acidMenu:add_int_range("Poner $$", 50000, 10000, 2000000, function() return globals.get_int(290345) end, function(Val) globals.set_int(290345, Val) end) 
acidMenu:add_toggle("Quitar Delay de produccion", function() return e52 end, function() e52 = not e52 AL(e52) end)
acidMenu:add_toggle("Quitar Delay Suministros", function() return e53 end, function() e53 = not e53 AC(e53) end)
acidMenu:add_toggle("Reducir Costos Suministros", function() return e51 end, function() e51 = not e51 ACL(e51) end)

mmHmenu = dinMenu:add_submenu("Cargo De Hangar $$$")
function Cooldown(e) if not localplayer then return end if e then for i = 284924, 284928 do globals.set_int(i, 0) globals.set_int(i, 1) end else globals.set_int(284924, 120000) globals.set_int(284925, 180000) globals.set_int(284926, 240000) globals.set_int(284927, 60000) globals.set_int(284928, 2000) end end mmHmenu:add_toggle("Remove Cooldowns", function() return e15 end, function() e15 = not e15 Cooldown(e15) end)
mmHmenu:add_int_range("Cargamento Mixto", 50000, 10000, 3100000, function() return globals.get_int(296207) end, function(value) globals.set_int(296207, value) end)
mmHmenu:add_int_range("Cargamento Animal", 50000, 10000, 3100000, function() return globals.get_int(294017) end, function(value) globals.set_int(294017, value) end)
mmHmenu:add_int_range("Antiguedades y Arte", 50000, 10000, 3100000, function() return globals.get_int(292129) end, function(value) globals.set_int(292129, value) end)
mmHmenu:add_int_range("Cargamento Quimico", 50000, 10000, 3100000, function() return globals.get_int(279538) end, function(value) globals.set_int(279538, value) end)
mmHmenu:add_int_range("Dinero Falsificado", 50000, 10000, 3100000, function() return globals.get_int(281459) end, function(value) globals.set_int(281459, value) end)
mmHmenu:add_int_range("Joyeria", 50000, 10000, 3100000, function() return globals.get_int(292446) end, function(value) globals.set_int(292446, value) end)
mmHmenu:add_int_range("Cargamentos Medicos", 50000, 10000, 3100000, function() return globals.get_int(274855) end, function(value) globals.set_int(274855, value) end)
--mmHmenu:add_int_range("Cargamentos De Narcotico", 50000, 10000, 3100000, function() return globals.get_int(284963) end, function(value) globals.set_int(284963, value) end)
mmHmenu:add_int_range("Tabacco Value", 50000, 10000, 3100000, function() return globals.get_int(293281) end, function(value) globals.set_int(293281, value) end)
function ronC(e) if not localplayer then return end if e then globals.set_float(271594, 0) else globals.set_float(271594, 0.025) end end 
mmHmenu:add_toggle("Quitar Parte De Ron", function() return e30 end, function() e30 = not e30 ronC(e30) end)
mmHmenu:add_int_range("Resetear Stats De Ventas", 1, 0, 500, function() return stats.get_int(mpx .. "LFETIME_HANGAR_SEL_COMPLET") end, function(value) stats.set_int(mpx .. "LFETIME_HANGAR_BUY_UNDETAK", value) stats.set_int(mpx .. "LFETIME_HANGAR_BUY_COMPLET", value) stats.set_int(mpx .. "LFETIME_HANGAR_SEL_UNDETAK", value) stats.set_int(mpx .. "LFETIME_HANGAR_SEL_COMPLET", value) stats.set_int(mpx .. "LFETIME_HANGAR_EARNINGS", value * 40000) globals.set_int(1575015, 1) globals.set_int(1574589, 1) sleep(0.2) globals.set_int(1574589, 0) end)

mcMenu = dinMenu:add_submenu("Club De Moteros $$$") local function Speed(e) if not localplayer then return end if e then for i = 279591, 279595 do globals.set_int(i, 0) globals.set_int(i, 1) end else globals.set_int(279594, 300000) globals.set_int(279595, 720000) globals.set_int(279593, 3000000) globals.set_int(279592, 1800000) globals.set_int(279591, 360000) end end 
local function Speed(e) if not localplayer then return end if e then for i = 280715, 283274 do globals.set_int(i, 0) globals.set_int(i, 1) end else globals.set_int(279539, 300000) globals.set_int(283275, 720000) globals.set_int(279538, 3000000) globals.set_int(281211, 1800000) globals.set_int(280715, 360000) end end 
local function EMCdt(e) if not localplayer then return end if e then globals.set_int(294004, 14400000) globals.set_int(278115, 6600000) globals.set_int(293332, 7200000) globals.set_int(281828, 7800000) globals.set_int(293872, 8400000) globals.set_int(279540, 9000000) globals.set_int(CCT4, 9600000) globals.set_int(290480, 10200000) globals.set_int(280170, 10800000) globals.set_int(283269, 11400000) globals.set_int(292136, 12000000) globals.set_int(286592, 12600000) globals.set_int(286205, 13200000) globals.set_int(284964, 13800000) else globals.set_int(294004, 1800000) globals.set_int(278115, 1800000) globals.set_int(293332, 1800000) globals.set_int(281828, 1800000) globals.set_int(293872, 1800000) globals.set_int(279540, 1800000) globals.set_int(CCT4, 1800000) globals.set_int(290480, 1800000) globals.set_int(280170, 900000) globals.set_int(283269, 900000) globals.set_int(292136, 1800000) globals.set_int(286592, 900000) globals.set_int(286205, 900000) globals.set_int(284964, 900000) end end 
local function VRC(e) if not localplayer then return end if e then globals.set_int(274177, 1000) else globals.set_int(274177, 1000) end end 
local function VRD(e) if not localplayer then return end if e then globals.set_int(274187, 10) else globals.set_int(274187, 600) end end 
local function MCrr(e) if not localplayer then return end if e then for i = 0, 4 do stats.set_int(mpx.."PAYRESUPPLYTIMER"..i, 1) sleep(0.1) end else for i = 0, 4 do stats.set_int(mpx.."PAYRESUPPLYTIMER"..i, 0) end end end 
local function MCgs(e) if not localplayer then return end if e then globals.set_int(283700, 0) else globals.set_int(283700, 40000) end end 

mcMenu:add_toggle("Aumentar Produccion", function() return e16 end, function() e16 = not e16 Speed(e16) end)
mcMenu:add_toggle("Aumentar Tiempo De Entrega", function() return e46 end, function() e46 = not e46 EMCdt(e46) end)
mcMenu:add_toggle("Remover Costos Suministros", function() return e22 end, function() e22 = not e22 VRC(e22) end) 
mcMenu:add_toggle("Remover Tiempo Suministros", function() return e42 end, function() e42 = not e42 VRD(e42) end)
mcMenu:add_toggle("Dar Suministros (experimental)", function() return e25 end, function() e25 = not e25 MCrr(e25) end)
mcMenu:add_toggle("Remover Señal Global", function() return e24 end, function() e24 = not e24 MCgs(e24) end)
mcMenu:add_float_range("Multiplicador De Venta", 0.5, 1, 1000, function() return globals.get_float(283262) end, function(value) globals.set_float(283262, value) globals.set_float(283799, value) end) 
mcMenu:add_action(" ~Usalo para obtener maximo 8m~ ", function() end)

mmVmenu = dinMenu:add_submenu("Cargamento Veh $$$") local function Max(e) if not localplayer then return end if e then globals.set_int(281602, 155000) globals.set_int(281603, 155000) globals.set_int(281604, 155000) globals.set_float(281606, 0) globals.set_float(281607, 0) else globals.set_int(281602, 40000) globals.set_int(281603, 25000) globals.set_int(281604, 15000) globals.set_float(281606, 0.25) globals.set_float(281607, 0.5) end end mmVmenu:add_toggle("Maxear los rangos", function() return e17 end, function() e17 = not e17 Max(e17) end)
local function ACCC(e) if not localplayer then return end if e then globals.set_int(290970, 0) else globals.set_int(290970, 2880) end end 
local function etCC(e) if not localplayer then return end if e then globals.set_int(278114, 99999) else globals.set_int(278114, 600) end end 

mmVmenu:add_toggle("Remover Cooldown", function() return e35 end, function() e35 = not e35 ACCC(e35) end)
mmVmenu:add_int_range("% Chance", 5, 0, 100, function() return globals.get_int(277941) end, function(value) globals.set_int(277941, value) end)
mmVmenu:add_float_range("2 Multiplicador De Cooldown", 0.5, 0.0, 100, function() return globals.get_float(281807) end, function(value) globals.set_float(281807, value) end)
mmVmenu:add_toggle("Extender Tiempo", function() return e36 end, function() e36 = not e36 etCC(e36) end)
mmVmenu:add_int_range("Gama Baja", 5000, 20000, 100000, function() return globals.get_int(281261) end, function(value) globals.set_int(281261, value) end)
mmVmenu:add_int_range("Gama Media", 5000, 25000, 125000, function() return globals.get_int(290156) end, function(value) globals.set_int(290156, value) end)
mmVmenu:add_int_range("Gama Alta", 5000, 30000, 150000, function() return globals.get_int(274100) end, function(value) globals.set_int(274100, value) end)

MMmenu = dinMenu:add_submenu("Money Loop 'SUPER RISKY'") local g = globals.set_int local m = 1969112 local x = 1 local y = 2 local z = 3 local k = 0 local s = sleep local p = 30 local q = 60 local r = 120 local enable1 = false local enable2 = false local enable3 = false local enable4 = false local enable5 = false local function Loop1(e) if not localplayer then return end if e then g(m, x) s(z) g(m, k) s(p) end end 

MMmenu:add_toggle("$ 500k/ 30s", function() return enable1 end, function() enable1 = not enable1 while enable1 == true do Loop1(enable1) end end) local function Loop2(e) if not localplayer then return end if e then g(m, y) s(z) g(m, k) s(p) end end 
MMmenu:add_toggle("$ 750k/ 30s", function() return enable2 end, function() enable2 = not enable2 while enable2 == true do Loop2(enable2) end end) local function Loop3(e) if not localplayer then return end if e then g(m, x) s(z) g(m, k) s(z) g(m, x) s(z) g(m, k) s(q) end end
MMmenu:add_toggle("$ 1M/ 60s", function() return enable3 end, function() enable3 = not enable3 while enable3 == true do Loop3(enable3) end end) local function Loop4(e) if not localplayer then return end if e then g(m, y) s(z) g(m, k) s(z) g(m, y) s(z) g(m, k) s(q) end end 
MMmenu:add_toggle("$ 1.5M/ 60s", function() return enable4 end, function() enable4 = not enable4 while enable4 == true do Loop4(enable4) end end) local function Loop5(e) if not localplayer then return end if e then g(m, y) s(z) g(m, k) s(z) g(m, y) s(z) g(m, k) s(z) g(m, y) s(z) g(m, k) s(z) g(m, y) s(z) g(m, k) s(r) end end    
MMmenu:add_toggle("$ 3M/ 120s", function() return enable5 end, function() enable5 = not enable5 while enable5 == true do Loop5(enable5) end end)

MMmenu:add_action("---------------> IMPORTANTE <-----------------", function() end)

MMmenu:add_action("Elija solo 1 opcion a la vez. Para detener", function() end)
MMmenu:add_action("Salga desde la configuración. Si quiere", function() end)
MMmenu:add_action("cambiar la opcion,salga primero Y espere", function() end) 
MMmenu:add_action("2 minutos antes de seleccionar una nueva.", function() end) 

CREDMenu = mainMenu:add_submenu("Creditos") 
CREDMenu:add_action("Kiddions ", function() end) 
CREDMenu:add_action("_picho_", function() end) 
