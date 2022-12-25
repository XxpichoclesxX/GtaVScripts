util.require_natives("natives-1663599433")

local snowmen = {
    { -959.2467, -780.8681, 17.83611 },
    { -819.9067, 165.35524, 71.26295 },
    { -251.52495, -1561.682, 31.939138 },
    { 901.7144, -286.2657, 65.673515 },
    { 1270.7291, -645.9963, 68.00145 },
    { 1993.1008, 3829.6396, 32.167336 },
    { -375.47916, 6230.158, 31.490055 },
    { -1414.2078, 5101.0576, 60.303204 },
    { -1938.8783, 589.47314, 119.70296 },
    { -1100.889, -1401.0138, 5.215467 },
    { -778.11993, 878.8288, 203.31508 },
    { -455.0701, 1129.6311, 325.88016 },
    { 219.26233, -104.535065, 69.743095 },
    { 1559.2108, 6449.2827, 23.849245},
    { 3313.9011, 5164.719, 18.415358 },
    { 1708.7146, 4679.3745, 42.977077 },
    { 234.04605, 3103.639, 42.46318},
    { 2359.1873, 2524.3604, 46.585716 },
    { 1514.7108, 1721.1183, 110.25117 },
    { -48.133442, 1963.3002, 189.96031 },
    { -1516.2083, 2140.2168, 56.11924 },
    { -2830.0112, 1421.0872, 100.90339 },
    { -2974.723, 714.6455, 28.35867 },
    { 1341.4302, -1583.5093, 54.135414 },
    { 180.52608, -903.90607, 30.693544 }
}

-- Credits to blackn't to add explode snowmen

local snow_loca = menu.my_root()
local explode_snowmen = true
local god_path = menu.ref_by_path("Self>Immortality")

snow_loca:divider("Snowmen Teleports")

auto_exp_toggle= true
auto_exp_toggle = snow_loca:toggle("Auto Explode Snowmen on Tp", {}, "", function(toggle)
    if toggle then
        explode_snowmen = true
        util.toast("Enabled Auto Explode Snowmen")
    else
        explode_snowmen = false
        util.toast("Disabled Auto Explode Snowmen")
    end
end, true)

for idx, coords in snowmen do
    snow_loca:action("Snowman #" .. idx, {}, "Teleport to Snowman #".. idx, function()
        util.teleport_2d(coords[1], coords[2])
        util.yield(100)
        if explode_snowmen == true then
            menu.trigger_command(god_path, "on")
            util.yield(750)
            for i = 1, 10 do
            FIRE.ADD_OWNED_EXPLOSION(PLAYER.PLAYER_PED_ID(),coords[1], coords[2], coords[3] + 1, EXP_TAG_STICKYBOMB, 100.0, true, true, 0.0)
            util.yield(100)
            end
        end
    end)
end
util.keep_running()
