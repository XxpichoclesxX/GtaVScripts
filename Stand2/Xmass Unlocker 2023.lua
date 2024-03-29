menu.divider(menu.my_root(), "Yeti Event")
local yeti = menu.list(menu.my_root(), "Yeti", {}, "Desbloqueara el yeti.")
local locations = {
    {-1562.69, 4699.04, 50.426},
    {-1359.869, 4733.429, 46.919},
    {-1715.398, 4501.203, 0.096},
    {-1282.18, 4487.826, 12.643},
    {-1569.665, 4478.485, 20.215},
    {-1345.828, 4838.062, 137.522}
}

local function MPX()
    return "MP" .. util.stat_get_int64("MPPLY_LAST_MP_CHAR") .. "_"
end


menu.divider(yeti, "Unlock Event First")
menu.action(yeti, "Unlock Yeti", {}, "Will unlock the yeti new function.", function() memory.write_byte(memory.script_global(262145 + 36054), 1) util.trigger_script_event(1 << players.user(), {1833904680}) end)
menu.divider(yeti, "All yeti clues")
for idx, coords in locations do
    yeti:action("Clue " .. idx, {}, "Teleport to the yeti clues. \n(Clue number 6 is for the yeti deffault spawn).", function()
        util.teleport_2d(coords[1], coords[2])
    end)
end


menu.divider(menu.my_root(), "Especific Unlockers")

local unlockers = menu.list(menu.my_root(), "Global Unlockers", {}, "Unlockers mainly focussing globals.")
menu.action(unlockers, "Unlock Truck", {}, "Will unlock the new fremode xmass truck.", function() memory.write_byte(memory.script_global(262145 + 36055), 1) util.toast("Should be on the map already.") end)
menu.action(unlockers, "Unlock New Mission", {}, "Will unlock newest mission from the DLC", function() memory.write_byte(memory.script_global(262145 + 36058), 1) memory.write_byte(memory.script_global(262145 + 36058), 1) end)
menu.action(unlockers, "Unlock New Robery Mission", {}, "Will unlock newest rob mission from the DLC. \n Testing.", function() memory.write_byte(memory.script_global(262145 + 34108 + 1), 1) memory.write_byte(memory.script_global(262145 + 34108), 1) util.toast("Should be already on the mission selector in the yunk yard.") end)
menu.action(unlockers, "New Skins In GunVan", {}, "Will unlock the newest skins. \n Testing.", function() memory.write_byte(memory.script_global(262145 + 34365, 0), 1) memory.write_byte(memory.script_global(262145 + 34328 + 9, -1716189206), 1) memory.write_byte(memory.script_global(262145 + 34328 + 10, -1786099057), 1) memory.write_byte(memory.script_global(262145 + 34328), 1) util.toast("Should have already the skins.") end)


--[[
local unlockers2 = menu.list(menu.my_root(), "Tunner Unlockers", {}, "Unlockers mainly focussing globals.")
menu.action(unlockers2, "Unlock Trade Prices", {}, "Will unlock the new trade prices for the newest vehicles.", function() 
    local tunable = memory.tunable("ARENAWARSPSTAT_BOOL0")
    local tunable2 = memory.tunable("ARENAWARSPSTAT_BOOL2")
    for i = 1, 16 do
        memory.write_byte(MPX() .. tunable + i)
    end
    for i = 11, 19 do
        memory.write_byte(MPX() .. tunable + i)
    end
end)
]]


menu.divider(menu.my_root(), "Unlock All (Might be risky)")
menu.action(menu.my_root(), "Unlock All", {}, "Will bassicly unlock everything on the new DLC.", function() for i =  36050, 36300 do memory.write_byte(memory.script_global(262145 + i), 1) end memory.write_byte(memory.script_global(262145 + 36250), 1) memory.write_byte(memory.script_global(262145 + 36251), 1) end)
