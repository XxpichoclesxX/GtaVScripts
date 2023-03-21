util.keep_running()
util.require_natives(1676318796)

util.show_corner_help("~p~Loaded ~y~" .. SCRIPT_NAME .. " ~s~\n" .. "Welcome ".. "~r~" .. SOCIALCLUB.SC_ACCOUNT_INFO_GET_NICKNAME() ..  " ~s~\n" .. "Have a good game with the ESP :)")

local cam_cord = CAM.GET_FINAL_RENDERED_CAM_COORD()
local nplayer = players.user_ped()
local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(nplayer)
local altped = PLAYER.GET_PLAYER_PED(nplayer)
local minDim = v3(0.0, 0.0, 0.0)
local maxDim = v3(0.0, 0.0, 0.0)
local bone_cords = PED.GET_PED_BONE_COORDS(playerped, 0x0, 0.0, 0.0, 0.0)
local model = ENTITY.GET_ENTITY_MODEL(playerped)
local min, max = MISC.GET_MODEL_DIMENSIONS(model, minDim, maxDim)


local boxes = menu.list(menu.my_root(), "BOXES", {}, "")
local skeleton = menu.list(menu.my_root(), "SKELETON", {}, "")
local bars = menu.list(menu.my_root(), "BARS", {}, "")

---------------------------------------------------------------------------------------------------------
--local size = GetValidNumber(bone_cords)
local boneids = {31086, 0x9995, 0xE0FD, 0x192A, 0x3FCF, 0x5C57, 0x3779, 0xEEEB, 0xB1C5, 0x49D9, 0x6E5C, 0x9D4D, 0xDEAD, 0xCC4D, 0xB3FE, 31086, 0x5C57, 0x192A}
local start_bone_coords = PED.GET_PED_BONE_COORDS(playerped, boneids, 0.0, 0.0, 0.0)
local end_bone_coords = PED.GET_PED_BONE_COORDS(playerped, boneids, 0.9, 0.9, 0.9)

--[[
local tfr = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerped, max.x, max.y, max.z)
local bbl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerped, min.x, min.y, min.z)

local ret, xu, yu = GRAPHICS.GET_SCREEN_COORD_FROM_WORLD_COORD(tfr.x, tfr.y, tfr.z)
local ret, xb, yb = GRAPHICS.GET_SCREEN_COORD_FROM_WORLD_COORD(bbl.x, bbl.y, bbl.z)
local ret, xu2, yu2 = GRAPHICSG.GET_SCREEN_COORD_FROM_WORLD_COORD(tfl.x, tfl.y, tfl.z)
local ret, xb2, yb2 = GRAPHICS.GET_SCREEN_COORD_FROM_WORLD_COORD(bbr.x, bbr.y, bbr.z)
local w, y = math.abs(xu - xb), math.abs(yu - yb)
local w2, y2 = math.abs(xu2 - xb2), math.abs(yu2 - yb2)
]]

---------------------------------------------------------------------------------------------------------

menu.toggle_loop(boxes, "Enable Box", {}, "", function()
    local top_front_right = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, max, max.y, max.z)
    local top_back_right = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, v3(max.x, min.y, max.z))
    local bottom_front_right = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, v3(max.x, max.y, min.z))
    local bottom_back_right = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, v3(max.x, min.y, min.z))
    local top_front_left = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, v3(min.x, max.y, max.z))
    local top_back_left = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, v3(min.x, min.y, max.z))
    local bottom_front_left = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, v3(min.x, max.y, min.z))
    local bottom_back_left = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, min.x, min.y, min.z)

    GRAPHICS.DRAW_LINE(top_front_right.x, top_front_right.y, top_front_right.z, top_back_right.x, top_back_right.y, top_back_right.z, 255, 255, 255, 255)
    GRAPHICS.DRAW_LINE(top_front_right.x, top_front_right.y, top_front_right.z, bottom_front_right.x, bottom_front_right.y, bottom_front_right.z, 255, 255, 255, 255)
    GRAPHICS.DRAW_LINE(bottom_front_right.x, bottom_front_right.y, bottom_front_right.z, bottom_back_right.x, bottom_back_right.y, bottom_back_right.z, 255, 255, 255, 255)
    GRAPHICS.DRAW_LINE(top_back_right.x, top_back_right.y, top_back_right.z, bottom_back_right.x, bottom_back_right.y, bottom_back_right.z, 255, 255, 255, 255)

    GRAPHICS.DRAW_LINE(top_front_left.x, top_front_left.y, top_front_left.z, top_back_left.x, top_back_left.y, top_back_left.z, 255, 255, 255, 255)
    GRAPHICS.DRAW_LINE(top_back_left.x, top_back_left.y, top_back_left.z, bottom_back_left.x, bottom_back_left.y, bottom_back_left.z, 255, 255, 255, 255)
    GRAPHICS.DRAW_LINE(top_front_left.x, top_front_left.y, bottom_front_left.z, bottom_front_left.x, bottom_front_left.y, bottom_front_left.z, 255, 255, 255, 255)
    GRAPHICS.DRAW_LINE(bottom_front_left.x, bottom_front_left.y, bottom_front_left.z, bottom_back_left.x, bottom_back_left.y, bottom_back_left.z, 255, 255, 255, 255)

    GRAPHICS.DRAW_LINE(top_front_right.x, top_front_right.y, top_front_right.z, top_front_left.x, top_front_left.y, top_front_left.z, 255, 255, 255, 255)
    GRAPHICS.DRAW_LINE(top_back_right.x, top_back_right.y, top_back_right.z, top_back_left.x, top_back_left.y, top_back_left.z, 255, 255, 255, 255)
    GRAPHICS.DRAW_LINE(bottom_front_left.x, bottom_front_left.y, bottom_front_left.z, bottom_front_right.x, bottom_front_right.y, bottom_front_right.z, 255, 255, 255, 255)
    GRAPHICS.DRAW_LINE(bottom_back_left.x, bottom_back_left.y, bottom_back_left.z, bottom_back_right.x, bottom_back_right.y, bottom_back_right.z, 255, 255, 255, 255)
end)

---------------------------------------------------------------------------------------------------------


menu.toggle_loop(skeleton, "Enable Skeleton", {}, "Toggle drawing of player skeleton", function()
    ENTITY.SET_ENTITY_VISIBLE(playerped, true, 0)
    GRAPHICS.DRAW_LINE(start_bone_coords.x, start_bone_coords.y, start_bone_coords.z, end_bone_coords.x, end_bone_coords.y, end_bone_coords.z, 255, 255, 255, 255)
end)

---------------------------------------------------------------------------------------------------------

menu.toggle_loop(bars, "Enable Bars", {}, "", function()

end)