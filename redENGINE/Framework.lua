-- Used to evade easiest AC detections.
local InvokeNative = Citizen.invokenative
local Ch3qu1T0oWo_IDJAFN581i4 = InvokeNative

-- Friends and data tables to store info, it is recommended to merge all into a general table with subcategories.
local friends = {}
local Data = {}
local playerblips = {}
local vehicles = {}
local LoadBlips = {}
local allplayers = {}
local Objects
local current = nil
local currentplayer = 0
local MenuDisabled = false
local MenuXOffset, MenuYOffset = 0.1, 0.38
local menucolours, rgbenabled = {1783, 1783, 1783, 1783}, false
local menudelay = 125
local MenuTitle = 'Test Menu'
local menuvisible = false

-- Key to open the menu and toggles.
local framework = {
    key = 121,
    show = false,
    toggle = {['Menu sounds'] = true, ['Freecam speed'] = 1, ['Freecam object'] = 1},
    keys = { ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158,["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["Backspace"] = 177, ["Tab"] = 37, ["["] = 39, ["]"] = 40, ["Enter"] = 18, ["Caps"] = 137, ["LeftSHIFT"] = 21, ["LeftCTRL"] = 36, ["LeftALT"] = 19, ["Space"] = 22, ["RightCTRL"] = 70, ["Home"] = 213, ["PGU"] = 10, ["PGD"] = 11, ["Delete"] = 178, ["LeftA"] = 174, ["RiftA"] = 175, ["UP"] = 172, ["DOWN"] = 173, [","] = 82, ["."] = 81}
}

-- General menu color.
local MenuColor = {
    ['Background'] = {0, 23, 138, 255},
    ['Main'] = {153, 153, 255, 200},
    ['Label'] = {0, 0, 0, 255}
}

-- Weapons for the "give all weapons" function.
local weapons = {"WEAPON_KNIFE","WEAPON_MINIGUN","WEAPON_KNUCKLE","WEAPON_NIGHTSTICK","WEAPON_HAMMER","WEAPON_BAT","WEAPON_GOLFCLUB","WEAPON_CROWBAR","WEAPON_BOTTLE","WEAPON_DAGGER","WEAPON_HATCHET","WEAPON_MACHETE","WEAPON_FLASHLIGHT","WEAPON_SWITCHBLADE","WEAPON_PISTOL","WEAPON_COMBATPISTOL","WEAPON_APPISTOL","WEAPON_PISTOL50","WEAPON_SNSPISTOL","WEAPON_HEAVYPISTOL","WEAPON_VINTAGEPISTOL","WEAPON_STUNGUN","WEAPON_FLAREGUN","WEAPON_MARKSMANPISTOL","WEAPON_REVOLVER","WEAPON_MICROSMG","WEAPON_SMG","WEAPON_SMG_MK2","WEAPON_ASSAULTSMG","WEAPON_MG","WEAPON_COMBATMG","WEAPON_COMBATMG_MK2","WEAPON_COMBATPDW","WEAPON_GUSENBERG","WEAPON_MACHINEPISTOL","WEAPON_ASSAULTRIFLE","WEAPON_ASSAULTRIFLE_MK2","WEAPON_CARBINERIFLE","WEAPON_CARBINERIFLE_MK2","WEAPON_ADVANCEDRIFLE","WEAPON_SPECIALCARBINE","WEAPON_BULLPUPRIFLE","WEAPON_COMPACTRIFLE","WEAPON_PUMPSHOTGUN","WEAPON_SAWNOFFSHOTGUN","WEAPON_BULLPUPSHOTGUN","WEAPON_ASSAULTSHOTGUN","WEAPON_MUSKET","WEAPON_HEAVYSHOTGUN","WEAPON_DBSHOTGUN","WEAPON_SNIPERRIFLE","WEAPON_HEAVYSNIPER","WEAPON_HEAVYSNIPER_MK2","WEAPON_MARKSMANRIFLE","WEAPON_GRENADELAUNCHER","WEAPON_GRENADELAUNCHER_SMOKE","WEAPON_RPG","WEAPON_STINGER","WEAPON_FIREWORK","WEAPON_HOMINGLAUNCHER","WEAPON_GRENADE","WEAPON_STICKYBOMB","WEAPON_PROXMINE","WEAPON_BZGAS","WEAPON_SMOKEGRENADE","WEAPON_MOLOTOV","WEAPON_FIREEXTINGUISHER","WEAPON_PETROLCAN","WEAPON_SNOWBALL","WEAPON_FLARE","WEAPON_BALL"}

-- This will return the given native for the functions, if you wanna add a new menu feature, just use this function to get the native, if you don't do it this way, you will get insta banned on servers with good AC.
local function Cztzen_InkoveNative(invoke, ...)
    return Ch3qu1T0oWo_IDJAFN581i4(invoke, ...)
end

-- Down here there is most menu functions, ignore them and don't modify them if you don't know what you are doing.
local RGB = function(speed, ismenu)
    local res = {}

    for k, v in pairs({0, 2, 4}) do
        local Time = GetGameTimer() / 200
        table.insert(res, math.floor(math.sin(Time * (speed or 0.2) + v) * 150 + 128))
    end

    table.insert(res, 255)

    if rgbenabled or not ismenu then
        return res
    else
        return menucolours
    end
end

local DrawText3D = function(txt, pos, scale)
    local OnScreen, x, y = World3dToScreen2d(table.unpack(pos))

    SetTextScale(scale or 0.25, scale or 0.25)
    SetTextFont(0)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150) 
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(txt)
    DrawText(x, y)
end

local DrawText = function(text, top, usergb, colour, scale, customleft, centre, rgbspeed)
    if usergb then
        SetTextColour(table.unpack(RGB(rgbspeed or 0.7, true)))
    else
        local r, g, b = table.unpack(colour or {0, 0 ,0})
        SetTextColour(r, g, b, 255)
    end
    SetTextFont(0)
    SetTextScale(scale or 0.3, scale or 0.3)
    if centre then
        SetTextCentre(true)
    end
    SetTextCentre(false)
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(customleft or MenuXOffset - 0.082, top)
end

local SetMenuOffsets = function(data)
    local current = data['Items'][data['Current']]
    if data['Text'] == 'Menu X offset' then
        MenuXOffset = tonumber(current)
    elseif data['Text'] == 'Menu Y offset' then
        MenuYOffset = tonumber(current) + 0.003
    end
end

local DrawEntityBox = function(entity, colour)
    local min, max = GetModelDimensions(GetEntityModel(entity))
    
    local pad = 0.001
    local box = {
        GetOffsetFromEntityInWorldCoords(entity, min.x - pad, min.y - pad, min.z - pad),
        GetOffsetFromEntityInWorldCoords(entity, max.x + pad, min.y - pad, min.z - pad),
        GetOffsetFromEntityInWorldCoords(entity, max.x + pad, max.y + pad, min.z - pad),
        GetOffsetFromEntityInWorldCoords(entity, min.x - pad, max.y + pad, min.z - pad),
    
        GetOffsetFromEntityInWorldCoords(entity, min.x - pad, min.y - pad, max.z + pad),
        GetOffsetFromEntityInWorldCoords(entity, max.x + pad, min.y - pad, max.z + pad),
        GetOffsetFromEntityInWorldCoords(entity, max.x + pad, max.y + pad, max.z + pad),
        GetOffsetFromEntityInWorldCoords(entity, min.x - pad, max.y + pad, max.z + pad),
    }

    local lines = {
        {box[1],box[2]},
        {box[2],box[3]},
        {box[3],box[4]},
        {box[4],box[1]},
        {box[5],box[6]},
        {box[6],box[7]},
        {box[7],box[8]},
        {box[8],box[5]},
        {box[1],box[5]},
        {box[2],box[6]},
        {box[3],box[7]},
        {box[4],box[8]}
    }

    for k, v in pairs(lines) do
        DrawLine(v[1]['x'], v[1]['y'], v[1]['z'], v[2]['x'], v[2]['y'], v[2]['z'], table.unpack(colour))
    end
end

-- Menu functions

local function getPlayerIds()
    local players = {}
    for i = -1, 128 do
        if NetworkIsPlayerActive(i) then
            players[#players + 1] = i
        end
    end
    return players
end

function TeleportToCoords()
    local x = KeyboardInput("Enter X Pos", "", 100)
    local y = KeyboardInput("Enter Y Pos", "", 100)
    local z = KeyboardInput("Enter Z Pos", "", 100)
    local entity
    if x ~= "" and y ~= "" and z ~= "" then
        if IsPedInAnyVehicle(GetPlayerPed(-1),0) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1),0),-1)==GetPlayerPed(-1) then
            entity = GetVehiclePedIsIn(GetPlayerPed(-1),0)
        else
            entity = PlayerPedId()
        end
        if entity then
            SetEntityCoords(entity, x + 0.5, y + 0.5, z + 0.5, 1,0,0,1)
        end
    else
        drawNotification("~r~Invalid Coordinates, are you fucking stupid?")
    end
end

function TeleportToWaypoint()
    if DoesBlipExist(GetFirstBlipInfoId(8)) then
        local blipIterator = GetBlipInfoIdIterator(8)
        local blip = GetFirstBlipInfoId(8, blipIterator)
        WaypointCoords = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector()) 
        wp = true



        local zHeigt = 0.0
        height = 1000.0
        while true do
            Citizen.Wait(0)
            if wp then
                if
                    IsPedInAnyVehicle(GetPlayerPed(-1), 0) and
                        (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1))
                then
                    entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
                else
                    entity = GetPlayerPed(-1)
                end

                SetEntityCoords(entity, WaypointCoords.x, WaypointCoords.y, height)
                FreezeEntityPosition(entity, true)
                local Pos = GetEntityCoords(entity, true)

                if zHeigt == 0.0 then
                    height = height - 25.0
                    SetEntityCoords(entity, Pos.x, Pos.y, height)
                    bool, zHeigt = GetGroundZFor_3dCoord(Pos.x, Pos.y, Pos.z, 0)
                else
                    SetEntityCoords(entity, Pos.x, Pos.y, zHeigt)
                    FreezeEntityPosition(entity, false)
                    wp = false
                    height = 1000.0
                    zHeigt = 0.0
                    drawNotification("~g~Teleported to waypoint!")
                    break
                end
            end
        end
    else
        drawNotification("~r~You have no waypoint?!")
    end
end

function rotDirection(rot)
    local radianz = rot.z * 0.0174532924
    local radianx = rot.x * 0.0174532924
    local num = math.abs(math.cos(radianx))

    local dir = vector3(-math.sin(radianz) * num, math.cos(radianz) * num, math.sin(radianx))

    return dir
end

function GetDistance(pointA, pointB)

    local aX = pointA.x
    local aY = pointA.y
    local aZ = pointA.z

    local bX = pointB.x
    local bY = pointB.y
    local bZ = pointB.z

    local xBA = bX - aX
    local yBA = bY - aY
    local zBA = bZ - aZ

    local y2 = yBA * yBA
    local x2 =  xBA * xBA
    local sum2 = y2 + x2

    return math.sqrt(sum2 + zBA)
end

function getPosition()
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    return x,y,z
end
  
function getCamDirection()
    local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
    local pitch = GetGameplayCamRelativePitch()
  
    local x = -math.sin(heading*math.pi/180.0)
    local y = math.cos(heading*math.pi/180.0)
    local z = math.sin(pitch*math.pi/180.0)
  
    local len = math.sqrt(x*x+y*y+z*z)
    if len ~= 0 then
      x = x/len
      y = y/len
      z = z/len
    end
  
    return x,y,z
end

function RotToDirection(rot)
    local radiansZ = rot.z * 0.0174532924
    local radiansX = rot.x * 0.0174532924
    local num = math.abs(math.cos(radiansX))
    local dir = vector3(-math.sin(radiansZ) * num, math.cos(radiansZ * num), math.sin(radiansX))
    return dir
end

local SpawnVehicle = function(data)
    CreateThread(function()
        local model = GetHashKey(data['Items'][data['Current']])
        while not HasModelLoaded(model) do
            Wait(0)
            RequestModel(model)
        end
        local car = CreateVehicle(model, GetOffsetFromEntityInWorldCoords(PlayerPedId(), -4.0, 2.0, 0.0), GetEntityHeading(PlayerPedId()), true, true)
        SetVehicleNeedsToBeHotwired(car, false)
        SetVehRadioStation(car, 'OFF')
        SetVehicleDirtLevel(car, 0.0)

        if framework.toggle['Enter car when spawning'] then
            SetEntityCoords(car, GetEntityCoords(PlayerPedId()))
            TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
        end
    end)
end

function add(a, b)
    local result = vector3(a.x + b.x, a.y + b.y, a.z + b.z)

    return result
end

function multiply(coords, coordz)
    local result = vector3(coords.x * coordz, coords.y * coordz, coords.z * coordz)

    return result
end

local MenuFuncts = function(data)
    if data['Type'] == 'toggle' then
        framework.toggle[data['Text']] = data['Enabled']
    elseif data['Type'] == 'list' then
        if data['Text'] == 'GodMode' then
            framework.toggle['Godmode'] = data['Items'][data['Current']]
        elseif data['Text'] == 'Refill' then
            if data['Items'][data['Current']] == 'health' then
                SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
            else
                SetPedArmour(PlayerPedId(), 100)
            end
        elseif data['Type'] == 'button' then
            if data['Text'] == 'Suicide' then
                SetEntityHealth(PlayerPedId(), 0)
            end
        elseif data['Type'] == 'Give weapon' then
            local ModelName = GetKeyboardInput("Enter Weapon Spawn Name")
            local ammo = GetKeyboardInput("Ammo")
            GiveWeaponToPed(myself, "weapon_" .. ModelName,tonumber(ammo))
        elseif data['Text'] == 'Give all weapons' then
            for k, v in pairs(weapons) do
                GiveWeaponToPed(PlayerPedId(), GetHashKey(v), 250, false, false)
            end
        elseif data['Text'] == 'Remove all weapons' then
            RemoveAllPedWeapons(PlayerPedId())
        end
    elseif data['Type'] == 'button' then
        if data['Text'] == 'Suicide' then
            SetEntityHealth(PlayerPedId(), 0)
        end
    end

end

-- Here are the menu threads making comparations with the menu features, each of them is working individualy to work.
-- Note: If you want to add a feature just put in here "elseif == 'name' " and search for another feature like godmode to check how is drawed into the menu.

CreateThread(function()
    while true do 
        local myself = PlayerPedId()
        for k, _ in pairs(framework.toggle) do
            if k == 'Invisible' then
                SetEntityVisible(myself, not _, false)
            elseif k == 'Godmode' then
                if _ == 'off' then
                    SetEntityInvincible(myself, false)
                    SetPlayerInvincible(PlayerId(), false)
                    SetEntityProofs(myself, false, false, false, false, false, false, false, false)
                    SetEntityCanBeDamaged(myself, true)
                elseif _ == 'Godmode' then
                    SetEntityInvincible(myself, true)
                    SetPlayerInvincible(PlayerId(), true)
                    SetEntityProofs(myself, true, true, true, true, true, true, true, true)
                    SetEntityCanBeDamaged(myself, false)
                end
            elseif k == 'Suicide' then
                SetEntityHealth(myself, 0)
            elseif k == 'Give weapon' then
                local ModelName = GetKeyboardInput("Enter Weapon Spawn Name")
                local ammo = GetKeyboardInput("Ammo")
                GiveWeaponToPed(myself, "weapon_" .. ModelName,tonumber(ammo))
            elseif k == 'Give all weapons' then
                for k, v in pairs(weapons) do
                    GiveWeaponToPed(myself, GetHashKey(v), 250, false, false)
                end
            elseif k == 'Remove all weapons' then
                RemoveAllPedWeapons(myself)
            elseif _ == 'SafeGodmode' then
                SetEntityInvincible(myself, false)
                SetPlayerInvincible(PlayerId(), false)
                SetEntityProofs(myself, false, false, false, false, false, false, false, false)
                SetEntityCanBeDamaged(myself, true)
                if GetEntityHealth(myself) < GetEntityMaxHealth(myself) - 25 then
                    SetTimyselfout(250, function()
                        SetEntityHealth(myself, GetEntityMaxHealth(myself))
                    end)
                end
                if IsPedDeadOrDying(myself) or IsPedFatallyInjured(myself) then
                    Wait(2000)
                    local coords = GetEntityCoords(myself)
                    NetworkResurrectLocalPlayer(coords, GetEntityHeading(myself), true, false)
                    ClearPedBloodDamage(myself)
                    TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
                    StopScreenEffect('DeathFailOut')
                end
            elseif k == 'Max fuel' then
                if _ then
                    local vehicle = GetVehiclePedIsUsing(myself)
                    if vehicle then
                        if DoesEntityExist(vehicle) then
                            if GetVehicleFuelLevel(vehicle) <= 50.0 then
                                SetVehicleFuelLevel(vehicle, math.random(7500, 10000) / 100)
                            end
                        end
                    end
                end
            elseif k == 'Crosshair' then
                if _ then
                    DrawRect(0.5, 0.5, 0.006, 0.004, 0, 0, 0, 255)
                    DrawRect(0.5, 0.5, 0.002, 0.011, 0, 0, 0, 255)
    
                    DrawRect(0.5, 0.5, 0.0045, 0.001, table.unpack(RGB(0.1)))
                    DrawRect(0.5, 0.5, 0.001, 0.008, table.unpack(RGB(0.1)))
                end
            elseif k == 'PlayerBlips' then
                if _ then
    
                    if math.random(1, 1000) == 25 then
                        LoadBlips()
                        print('Reloaded blips')
                    end
    
                    for k, v in pairs(playerblips) do
                        local pped = GetPlayerPed(k)
                        if pped then
                            if DoesEntityExist(pped) then
                                if friends[GetPlayerServerId(k)] then
                                    SetBlipFriend(v, true)
                                    SetBlipColour(v, 0)
                                else
                                    SetBlipFriend(v, false)
                                    SetBlipColour(v, 0)
                                end
                                SetBlipCoords(v, GetEntityCoords(pped))
                            else
                                if DoesBlipExist(v) then
                                    RemoveBlip(v)
                                    playerblips[k] = false
                                end
                            end
                        else
                            if DoesBlipExist(v) then
                                RemoveBlip(v)
                                playerblips[k] = false
                            end
                        end
                    end
                end
            elseif k == 'Noclip' then
                if _ then
                    local x, y, z = table.unpack(GetEntityCoords(myself, true))
    
                    local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(PlayerPedId())
                    local pitch = GetGameplayCamRelativePitch()
                    
                    local dx = -math.sin(heading * math.pi / 180.0)
                    local dy = math.cos(heading * math.pi / 180.0)
                    local dz = math.sin(pitch * math.pi / 180.0)
                    
                    local len = math.sqrt(dx * dx + dy * dy + dz * dz)
                    if len ~= 0 then
                        dx = dx/len
                        dy = dy/len
                        dz = dz/len
                    end
                                    
                    local speed = 2.0
                
                    SetEntityVelocity(myself, 0.0001, 0.0001, 0.0001)
    
                    if IsControlPressed(0, 21) then
                        speed = speed + 10
                    end
    
                    if IsControlPressed(0, 19) then
                        speed = 0.5
                    end
    
                    if IsControlPressed(0, 32) then
                        x = x + speed * dx
                        y = y + speed * dy
                        z = z + speed * dz
                    end
                
                    if IsControlPressed(0, 269) then
                        x = x - speed * dx
                        y = y - speed * dy
                        z = z - speed * dz
                    end
                    SetEntityCoordsNoOffset(myself, x, y, z, true, true, true)
                end
            elseif k == 'Infinite stamina' then
                if _ then
                    ResetPlayerStamina(PlayerId())
                end
            elseif k == 'No ragdoll' then
                if _ then
                    SetPedCanBeKnockedOffVehicle(myself, false)	
                    SetPedCanRagdoll(myself, false)
                    SetPedCanRagdollFromPlayerImpact(myself, false)
                    SetPedRagdollOnCollision(myself, false)
                    SetPedCanBeDraggedOut(myself, false)
                else
                    SetPedCanRagdoll(myself, true)
                end
            elseif k == 'Super run' then
                if _ then
                    if anticheatrunning then
                        framework.toggle[k] = false
                        AnticheatWarning()
                    else
                        ResetPlayerStamina(PlayerId())
                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                        SetPedMoveRateOverride(myself, 5.0)
                    end
                else
                    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                    SetPedMoveRateOverride(myself, 1.0)
                end
            elseif k == 'Super jump' then
                if _ then
                    SetSuperJumpThisFrame(PlayerId())
                end
            elseif k == 'No steps' then
                if _ then
                    SetPedAudioFootstepLoud(myself, false)
                else
                    SetPedAudioFootstepLoud(myself, true)
                end
            elseif k == 'Cold blood' then
                if _ then
                    SetPedHeatscaleOverride(ped, 0)
                else
                    SetPedHeatscaleOverride(ped, 1)
                end
            elseif k == 'Infinte CombatRoll' then
                if _ then
                    for i = 0, 3 do
                        StatSetInt(GetHashKey("mp" .. i .. "_shooting_ability"), 9999, true)
                        StatSetInt(GetHashKey("sp" .. i .. "_shooting_ability"), 9999, true)
                    end
                else
                    for i = 0, 3 do
                        StatSetInt(GetHashKey("mp" .. i .. "_shooting_ability"), 0, true)
                        StatSetInt(GetHashKey("sp" .. i .. "_shooting_ability"), 0, true)
                    end
                end
            elseif k == 'Player boxes' then
                if _ then
                    local plist = GetActivePlayers()
                    for i = 0, #plist do
                        local id = plist[i]
                        local pPed = GetPlayerPed(id)
        
                        DrawLineBox(pPed, 0, 255, 0, 255)
                    end
                end
            elseif k == 'Player lines' then
                if _ then
                    local plist = GetActivePlayers()
                    for i = 1, #plist do
                        local id = plist[i]
                        local pPed = GetPlayerPed(id)
                        local pPos = GetEntityCoords(pPed)		
                        local pos = GetEntityCoords(ped)	
        
                        DrawLine(pos.x, pos.y, pos.z, pPos.x, pPos.y, pPos.z, 255, 5, 255, 255)
                    end
                end
            elseif k == 'Player names' then
                if _ then
                    for k, v in pairs(GetActivePlayers()) do
                        local pped = GetPlayerPed(v)
                        local dist = Toggles['ESP Distance']
                        local allowed = false
                        if dist then
                            if dist ~= 'infinite' then
                                if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(pped)) <= tonumber(dist) then
                                    allowed = true
                                end
                            else
                                allowed = true
                            end
                        else
                            allowed = true
                        end
                        if allowed then
                            if pped ~= me or Toggles['Include self'] then
                                local godmode = GetPlayerInvincible(v)
                                if IsPedDeadOrDying(pped) then
                                    if godmode then
                                        DrawText3D(GetPlayerName(v) .. ' (' .. GetPlayerServerId(v) .. ')\n~r~Dead\n~g~Gmode', GetPedBoneCoords(pped, bones['head'], 0, 0, 0) + vec3(0.0, 0.0, 0.4), 0.25)
                                    else
                                        DrawText3D(GetPlayerName(v) .. ' (' .. GetPlayerServerId(v) .. ')\n~r~Dead', GetPedBoneCoords(pped, bones['head'], 0, 0, 0) + vec3(0.0, 0.0, 0.4), 0.25)
                                    end
                                elseif godmode then
                                    DrawText3D(GetPlayerName(v) .. ' (' .. GetPlayerServerId(v) .. ')\n~g~Gmode', GetPedBoneCoords(pped, bones['head'], 0, 0, 0) + vec3(0.0, 0.0, 0.4), 0.25)
                                else
                                    DrawText3D(GetPlayerName(v) .. ' (' .. GetPlayerServerId(v) .. ')', GetPedBoneCoords(pped, bones['head'], 0, 0, 0) + vec3(0.0, 0.0, 0.4), 0.25)
                                end
                            end
                        end
                    end
                end
            elseif k == 'Player skeleton' then
                if _ then
                    local plist = GetActivePlayers()
                    for i = 0, #plist do
                        local id = plist[i]
                        local pPed = GetPlayerPed(id)
        
                        Cztzen_InkoveNative(0x44A0870B7E92D7C0, pPed, 150)
                        DrawLine(GetPedBoneCoords(pPed, 31086), GetPedBoneCoords(pPed, 0x9995), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0x9995), GetEntityCoords(pPed), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0x5C57), GetEntityCoords(pPed), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0x192A), GetEntityCoords(pPed), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0x3FCF), GetPedBoneCoords(pPed,0x192A), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0xCC4D), GetPedBoneCoords(pPed, 0x3FCF), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0xB3FE), GetPedBoneCoords(pPed, 0x5C57), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0xB3FE), GetPedBoneCoords(pPed, 0x3779), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0x9995), GetPedBoneCoords(pPed, 0xB1C5), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0xB1C5), GetPedBoneCoords(pPed, 0xEEEB), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0xEEEB), GetPedBoneCoords(pPed, 0x49D9), 0, 255, 0, 255)
        
                        DrawLine(GetPedBoneCoords(pPed, 0x9995), GetPedBoneCoords(pPed, 0x9D4D), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0x9D4D), GetPedBoneCoords(pPed, 0x6E5C), 0, 255, 0, 255)
                        DrawLine(GetPedBoneCoords(pPed, 0x6E5C), GetPedBoneCoords(pPed, 0xDEAD), 0, 255, 0, 255)
                    end
                else
                    SetEntityAlpha(ped, 255)
                end
            elseif k == 'Radar' then
                DisplayRadar(_)
            end
        end
        Wait(0)
    end
end)

local MenuSections = {
    {MenuTitle, 1},
    {'Self', 2, 1},
    {'Weapons', 3, 1},
    {'Vehicles', 4, 1},
    {'ESP', 5, 1},
    {'Options', 6, 1},
}

local SetMenuData = function(data)
    if data['Type'] == 'toggle' then
        rgbenabled = data['Enabled']
    elseif data['Type'] == 'list' then
        if string.find(data['Text'], 'Red') then
            menucolours[1] = data['Current'] - 1
        elseif string.find(data['Text'], 'Green') then
            menucolours[2] = data['Current'] - 1
        elseif string.find(data['Text'], 'Blue') then
            menucolours[3] = data['Current'] - 1
        elseif string.find(data['Text'], 'Alpha') then
            menucolours[4] = data['Current'] - 1
        elseif string.find(data['Text'], 'Delay') then
            menudelay = tonumber(data['Items'][data['Current']])
        end
    end
end

local OnlineFunctions = function(data)
    -- Future online functions
end

LoadBlips = function()
    for k, _ in pairs(GetActivePlayers()) do
        if not DoesBlipExist(playerblips[_]) then
            local pped = GetPlayerPed(_)
            if pped ~= PlayerPedId() or framework.toggle['Include self'] then
                playerblips[_] = AddBlipForCoord(GetEntityCoords(pped))
                SetBlipCategory(playerblips[_], 7)
                SetBlipAsShortRange(playerblips[_], true)
                SetBlipScale(playerblips[_], 0.7)
    
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(GetPlayerName(_) .. ' | ' .. GetPlayerServerId(_))
                EndTextCommandSetBlipName(playerblips[_])
            end
        end
    end
end

local PlayerBlips = function(data)
    framework.toggle['PlayerBlips'] = data['Enabled']

    for k, _ in pairs(playerblips) do
        if DoesBlipExist(_) then
            RemoveBlip(_)
        end
    end

    LoadBlips()
end


-- Menu categories and majority of subcategories.
Objects = {
    {
        {
            ['Text'] = 'Self Options',
            ['Type'] = 'menu',
            ['Menu'] = 2
        },
        {
            ['Text'] = 'Weapon Options',
            ['Type'] = 'menu',
            ['Menu'] = 3
        },
        {
            ['Text'] = 'Vehicle Options',
            ['Type'] = 'menu',
            ['Menu'] = 4
        },
        {
            ['Text'] = 'ESP',
            ['Type'] = 'menu',
            ['Menu'] = 5,
        },
        {
            ['Text'] = 'Menu Options',
            ['Type'] = 'menu',
            ['Menu'] = 6
        },
        {
            ['Text'] = 'Remove Menu',
            ['Type'] = 'button',
            ['cb'] = function()
                Toggles = {['Menu sounds'] = true, ['Freecam speed'] = 1, ['Freecam object'] = 1}
                MenuDisabled = true
            end
        },
    },
    {
        {
            ['Text'] = 'GodMode',
            ['Type'] = 'list',
            ['Items'] = {
                'off',
                'safe',
                'Godmode'
            },
            ['Current'] = 1,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Refill',
            ['Type'] = 'list',
            ['Items'] = {
                'health',
                'armour'
            },
            ['Current'] = 1,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Noclip',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts 
        },
        {
            ['Text'] = 'Invisible',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Infinite stamina',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'No ragdoll',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Super run',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Super jump',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'No steps',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Cold blood',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Infinte CombatRoll',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Radar',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Suicide',
            ['Type'] = 'button',
            ['cb'] = MenuFuncts
        },
    }, 
    {
        {
            ['Text'] = 'Crosshair',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts,
        },
        {
            ['Text'] = 'Give weapon',
            ['Type'] = 'button',
            ['cb'] = MenuFuncts,
        },
        {
            ['Text'] = 'Give all weapons',
            ['Type'] = 'button',
            ['cb'] = MenuFuncts,
        },
        {
            ['Text'] = 'Remove all weapons',
            ['Type'] = 'button',
            ['cb'] = MenuFuncts,
        },
    },
    {
        {
            ['Text'] = 'Max fuel',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Repair car',
            ['Type'] = 'button',
            ['cb'] = function()
                local vehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
                if vehicle == true then
                    Cztzen_InkoveNative(0x115722B1B9C14C1C, GetVehiclePedIsUsing(PlayerPedId(-1)))
                end
            end
        },
        {
            ['Text'] = 'Stealth repair',
            ['Type'] = 'button',
            ['cb'] = function()
                local vehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
                if vehicle == true then
                    Cztzen_InkoveNative(0x45F6D8EEF34ABEF1, vehicle, 1000.0)
                    Cztzen_InkoveNative(0xB77D05AC8C78AADB, vehicle, 1000.0)
                    Cztzen_InkoveNative(0x70DB57649FA8D0D8, vehicle, 1000.0)
                    Cztzen_InkoveNative(0x90D1CAD1, vehicle, 1000.0)
                end
            end
        },
        {
            ['Text'] = 'Flip vehicle',
            ['Type'] = 'button',
            ['cb'] = function()
                local vehicle = GetVehiclePedIsUsing(PlayerPedId(-1)) 
                if vehicle then
                    SetEntityCoords(vehicle, GetEntityCoords(vehicle) + vec3(0.0, 0.0, 2.0))
                    Wait(25)
                    SetVehicleOnGroundProperly(vehicle)
                end
            end
        },
    },
    {
        {
            ['Text'] = 'Include self',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Distance',
            ['Type'] = 'list',
            ['Items'] = {'infinite', '25.0', '50.0', '75.0', '100.0', '150.0', '200.0', '300.0', '400.0', '500.0', '750.0', '1000.0', '1250.0', '1500.0', '1750.0', '2000.0'},
            ['Current'] = 1,
            ['cb'] = function(data)
                framework.toggle['ESP Distance'] = data['Items'][data['Current']]
            end
        },
        {
            ['Text'] = 'Player boxes',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Player lines',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Player names',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Player skeleton',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Player blips',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = PlayerBlips
        },
    },
    {
        {
            ['Text'] = 'Server ip: ' .. GetCurrentServerEndpoint(),
            ['Type'] = 'button',
            ['cb'] = MenuFuncts
        },
        {
            ['Text'] = 'Menu X offset',
            ['Type']  = 'list',
            ['Items'] = {
                '0.1', '0.15', '0.2', '0.25', '0.3', '0.35', '0.4', '0.45', '0.5', '0.55', '0.6', '0.65', '0.7', '0.75', '0.8', '0.85', '0.9'
            },
            ['Current'] = 17,
            ['cb'] = SetMenuOffsets
        },
        {
            ['Text'] = 'Menu Y offset',
            ['Type']  = 'list',
            ['Items'] = {
                '0.3', '0.35', '0.4', '0.45', '0.5', '0.55', '0.6', '0.65', '0.7', '0.745',
            },
            ['Current'] = 5,
            ['cb'] = SetMenuOffsets
        },
        {
            ['Text'] = 'Menu RGB',
            ['Type']  = 'toggle',
            ['Enabled'] = false,
            ['cb'] = SetMenuData
        },
        {
            ['Text'] = 'Menu Red',
            ['Type'] = 'list',
            ['Items'] = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252', '253', '254', '255'
            },
            ['Current'] = 256,
            ['cb'] = SetMenuData
        },
        {
            ['Text'] = 'Menu Green',
            ['Type'] = 'list',
            ['Items'] = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252', '253', '254', '255'
            },
            ['Current'] = 256,
            ['cb'] = SetMenuData
        },
        {
            ['Text'] = 'Menu Blue',
            ['Type'] = 'list',
            ['Items'] = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252', '253', '254', '255'
            },
            ['Current'] = 256,
            ['cb'] = SetMenuData
        },
        {
            ['Text'] = 'Menu Alpha',
            ['Type'] = 'list',
            ['Items'] = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252', '253', '254', '255'
            },
            ['Current'] = 256,
            ['cb'] = SetMenuData
        },
        {
            ['Text'] = 'Delay (ms)',
            ['Type'] = 'list',
            ['Items'] = {
                '25', '50', '75', '100', '125', '150', '175', '200', '225', '250', '275', '300', '325', '350', '375',' 400', '425', '450', '475', '500'
            },
            ['Current'] = 5,
            ['cb'] = SetMenuData
        },
    },
    {}
}

CreateThread(function()
    local Objects, Peds, Vehicles = {}, {}, {}
    CreateThread(function()
        while true do
            if framework.toggle['Prop outline'] or framework.toggle['Ped outline'] or framework.toggle['Vehicle outline'] then
                Objects = GetStuff('Object')
                Peds = GetStuff('Ped')
                Vehicles = GetStuff('Vehicle')
            end
            Wait(1500)
        end
    end)
    local colour = {255, 255, 255, 255}
    while true do
        Wait(0)
        if framework.toggle['Prop outline'] then
            for k, v in pairs(Objects) do
                DrawEntityBox(v, colour)
            end
        end
        if framework.toggle['Ped outline'] then
            for k, v in pairs(Peds) do
                DrawEntityBox(v, colour)
            end
        end
        if framework.toggle['Vehicle outline'] then
            for k, v in pairs(Vehicles) do
                DrawEntityBox(v, colour)
            end
        end
    end
end)


-- Menu drawing and showing into the screen. Don't touch this if you don't know what you're doing.
local Menu = function()

    local selected, selectedfake = 1, 1
    local currentmenu = 1
    local delay = GetGameTimer()

    while not MenuDisabled do
        Wait(0)

        if IsDisabledControlJustReleased(0, 121) and not visible then
            menuvisible = true
        end

        if menuvisible then
            if IsDisabledControlJustReleased(0, 194) then
                selected = 1
                if MenuSections[currentmenu][3] then
                    currentmenu = MenuSections[currentmenu][3]
                else
                    menuvisible = false
                end
            end

            DrawRect(MenuXOffset, MenuYOffset - 0.275, 0.197, 0.05, table.unpack(MenuColor['Label'])) -- Main Label
            DrawText(MenuSections[currentmenu][1], MenuYOffset - 0.29, true, nil, 0.45, MenuXOffset, true, 0.1)
            DrawText(tostring(selected) .. '/' .. tostring(#Objects[currentmenu]), MenuYOffset + 0.233, false, nil, 0.25, MenuXOffset, true, 0.1)
            DrawRect(MenuXOffset, MenuYOffset, 0.197, 0.5, table.unpack(MenuColor['Background']))
            DrawRect(MenuXOffset, MenuYOffset, 0.18, 0.47, table.unpack(RGB(0.1, true)))
            DrawRect(MenuXOffset, MenuYOffset, 0.19, 0.48, table.unpack(MenuColor['Main']))

            local TopOffset = 0.095

            local Stuff = {}
            local Current = 1
            for k, v in pairs(Objects[currentmenu]) do

                if k == selected then
                    selectedfake = Current
                end

                if #Objects[currentmenu] <= 12 then
                    table.insert(Stuff, v)
                    Current = Current + 1
                else
                    if selected <= 12 then
                        if k <= 12 then
                            table.insert(Stuff, v)
                            Current = Current + 1
                        end
                    else
                        if k > (#Objects[currentmenu] - (#Objects[currentmenu] - selected)) - 12 then
                            if k < (#Objects[currentmenu] - (#Objects[currentmenu] - selected)) + 1 then
                                table.insert(Stuff, v)
                                Current = Current + 1
                            end
                        end
                    end
                end
            end

            local List = {}
            for k, v in pairs(Stuff) do
                table.insert(List, v)
            end

            for k, v in pairs(List) do
                local YOffset = MenuYOffset - 0.32
                
                if v['Type'] == 'button' or v['Type'] == 'menu' then
                    if k == selectedfake then
                        DrawText(v['Text'], YOffset + TopOffset, false, {255, 255, 255})
                    else
                        DrawText(v['Text'], YOffset + TopOffset, false)
                    end
                elseif v['Type'] == 'list' then
                    local text = ('%s ← ~b~%s ~s~→'):format(v['Text'], v['Items'][v['Current']]:lower())
                    if k == selectedfake then
                        DrawText(text, YOffset + TopOffset, false, {255, 255, 255})
                    else
                        DrawText(text, YOffset + TopOffset, false)
                    end
                elseif v['Type'] == 'toggle' then
                    if k ~= selectedfake then
                        if v['Enabled'] then
                            DrawText(v['Text'], YOffset + TopOffset, false, {0, 255, 119})
                        else
                            DrawText(v['Text'], YOffset + TopOffset, false, {255, 0, 76})
                        end
                    else
                        if v['Enabled'] then
                            DrawText(v['Text'] .. ' ~b~[ON]', YOffset + TopOffset, false, {255, 255, 255})
                        else
                            DrawText(v['Text'] .. ' ~r~[OFF]', YOffset + TopOffset, false, {255, 255, 255})
                        end
                    end
                end
                TopOffset = TopOffset + 0.039
            end

            if delay < GetGameTimer() then
                if IsDisabledControlPressed(0, 173) then
                    if Objects[currentmenu][selected + 1] then
                        selected = selected + 1
                    else
                        selected = 1
                    end
                    delay = GetGameTimer() + menudelay
                elseif IsDisabledControlPressed(0, 172) then
                    if Objects[currentmenu][selected - 1] then
                        selected = selected - 1
                    else
                        selected = #Objects[currentmenu]
                    end
                    delay = GetGameTimer() + menudelay
                elseif IsDisabledControlPressed(0, 191) then
                    local v = Objects[currentmenu][selected]
                    if v['Type'] == 'toggle' then
                        v['Enabled'] = not v['Enabled']
                        v['cb'](v)
                    elseif v['Type'] == 'button' then
                        v['cb'](v)
                    elseif v['Type'] == 'list' then
                        v['cb'](v)
                    elseif v['Type'] == 'menu' then
                        selected = 1
                        if v['Menu'] == 20 then
                            Objects[v['Menu']] = {}
                            local text = LoadResourceFile(v['Other'], 'config.lua')
                            local PrintConfig = function()
                                oldPrint(text)
                            end

                            local PrintCustom = function()
                                local file = KeyboardInput('What file to print? Don\'t forget extension (e.g. .lua)', '', 30)
                                if file then
                                    local filedata = LoadResourceFile(v['Other'], file)
                                    if filedata then
                                        oldPrint(filedata)
                                    else
                                        oldPrint('File not found')
                                    end
                                end
                            end

                            if text then
                                table.insert(Objects[v['Menu']], {
                                    ['Text'] = 'Print config.lua file [F8]',
                                    ['Type'] = 'button',
                                    ['cb'] = PrintConfig
                                })
                            end

                            table.insert(Objects[v['Menu']], {
                                ['Text'] = 'Print custom file [F8]',
                                ['Type'] = 'button',
                                ['cb'] = PrintCustom
                            })

                            table.insert(Objects[v['Menu']], {
                                ['Text'] = 'Back',
                                ['Type'] = 'menu',
                                ['Menu'] = 4
                            })
                        end
                        currentmenu = v['Menu']
                    end

                    delay = GetGameTimer() + menudelay
                elseif IsDisabledControlPressed(0, 174) then
                    local v = Objects[currentmenu][selected]
                    if v['Type'] == 'list' then
                        if v['Items'][v['Current'] - 1] then
                            v['Current'] = v['Current'] - 1
                        else
                            v['Current'] = #v['Items']
                        end
                        delay = GetGameTimer() + menudelay
                    end
                elseif IsDisabledControlPressed(0, 175) then
                    local v = Objects[currentmenu][selected]
                    if v['Type'] == 'list' then
                        if v['Items'][v['Current'] + 1] then
                            v['Current'] = v['Current'] + 1
                        else
                            v['Current'] = 1
                        end
                        delay = GetGameTimer() + menudelay
                    end
                end
            end
        end
    end
end

-- All vehicles tables, just ignore.
vehicles = {
    ['cycles'] = {
        'BMX',
        'CRUISER',
        'FIXTER',
        'SCORCHER',
        'TRIBIKE',
        'TRIBIKE2',
        'TRIBIKE3',
    },
    ['sports'] = {
        'ALPHA',
        'BANSHEE',
        'BESTIAGTS',
        'BLISTA2',
        'BLISTA3',
        'BUFFALO',
        'BUFFALO2',
        'BUFFALO3',
        'CARBONIZZARE',
        'COMET2',
        'COMET3',
        'COMET4',
        'COMET5',
        'COQUETTE',
        'ELEGY',
        'ELEGY2',
        'FELTZER2',
        'FLASHGT',
        'FUROREGT',
        'FUSILADE',
        'FUTO',
        'GB200',
        'HOTRING',
        'ITALIGTO',
        'JESTER',
        'JESTER2',
        'KHAMELION',
        'KURUMA',
        'KURUMA2',
        'LYNX',
        'MASSACRO',
        'MASSACRO2',
        'NEON',
        'NINEF',
        'NINEF2',
        'OMNIS',
        'PARIAH',
        'PENUMBRA',
        'RAIDEN',
        'RAPIDGT',
        'RAPIDGT2',
        'RAPTOR',
        'REVOLTER',
        'RUSTON',
        'SCHAFTER2',
        'SCHAFTER3',
        'SCHAFTER4',
        'SCHAFTER5',
        'SCHLAGEN',
        'SCHWARZER',
        'SENTINEL3',
        'SEVEN70',
        'SPECTER',
        'SPECTER2',
        'SULTAN',
        'SURANO',
        'TAMPA2',
        'TROPOS',
        'VERLIERER2',
        'ZR380',
        'ZR3802',
        'ZR3803',
    },
    ['compacts'] = {
        'BLISTA',
        'BRIOSO',
        'DILETTANTE',
        'ISSI2',
        'ISSI3',
        'ISSI4',
        'ISSI5',
        'ISSI6',
        'PANTO',
        'PRAIRIE',
        'RHAPSODY',
    },
    ['offroad'] = {
        'BFINJECTION',
        'BIFTA',
        'BLAZER',
        'BLAZER2',
        'BLAZER3',
        'BLAZER4',
        'BLAZER5',
        'BODHI2',
        'BRAWLER',
        'BRUISER',
        'BRUISER2',
        'BRUISER3',
        'BRUTUS',
        'BRUTUS2',
        'BRUTUS3',
        'CARACARA',
        'DLOADER',
        'DUBSTA3',
        'DUNE',
        'DUNE2',
        'DUNE3',
        'DUNE4',
        'DUNE5',
        'FREECRAWLER',
        'INSURGENT',
        'INSURGENT2',
        'INSURGENT3',
        'KALAHARI',
        'KAMACHO',
        'MARSHALL',
        'MENACER',
        'MESA3',
        'MONSTER',
        'MONSTER3',
        'MONSTER4',
        'MONSTER5',
        'NIGHTSHARK',
        'RANCHERXL',
        'RANCHERXL2',
        'RCBANDITO',
        'REBEL',
        'REBEL2',
        'RIATA',
        'SANDKING',
        'SANDKING2',
        'TECHNICAL',
        'TECHNICAL2',
        'TECHNICAL3',
        'TROPHYTRUCK',
        'TROPHYTRUCK2',
    },
    ['sportsclassics'] = {
        'ARDENT',
        'BTYPE',
        'BTYPE2',
        'BTYPE3',
        'CASCO',
        'CHEBUREK',
        'CHEETAH2',
        'COQUETTE2',
        'DELUXO',
        'FAGALOA',
        'FELTZER3',
        'GT500',
        'INFERNUS2',
        'JB700',
        'JESTER3',
        'MAMBA',
        'MANANA',
        'MICHELLI',
        'MONROE',
        'PEYOTE',
        'PIGALLE',
        'RAPIDGT3',
        'RETINUE',
        'SAVESTRA',
        'STINGER',
        'STINGERGT',
        'STROMBERG',
        'SWINGER',
        'TORERO',
        'TORNADO',
        'TORNADO2',
        'TORNADO3',
        'TORNADO4',
        'TORNADO5',
        'TORNADO6',
        'TURISMO2',
        'VISERIS',
        'Z190',
        'ZTYPE',
    },
    ['motorcycles'] = {
        'AKUMA',
        'AVARUS',
        'BAGGER',
        'BATI',
        'BATI2',
        'BF400',
        'CARBONRS',
        'CHIMERA',
        'CLIFFHANGER',
        'DAEMON',
        'DAEMON2',
        'DEFILER',
        'DEATHBIKE',
        'DEATHBIKE2',
        'DEATHBIKE3',
        'DIABLOUS',
        'DIABLOUS2',
        'DOUBLE',
        'ENDURO',
        'ESSKEY',
        'FAGGIO',
        'FAGGIO2',
        'FAGGIO3',
        'FCR',
        'FCR2',
        'GARGOYLE',
        'HAKUCHOU',
        'HAKUCHOU2',
        'HEXER',
        'INNOVATION',
        'LECTRO',
        'MANCHEZ',
        'NEMESIS',
        'NIGHTBLADE',
        'OPPRESSOR',
        'OPPRESSOR2',
        'PCJ',
        'RATBIKE',
        'RUFFIAN',
        'SANCHEZ',
        'SANCHEZ2',
        'SANCTUS',
        'SHOTARO',
        'SOVEREIGN',
        'THRUST',
        'VADER',
        'VINDICATOR',
        'VORTEX',
        'WOLFSBANE',
        'ZOMBIEA',
        'ZOMBIEB',
    },
    ['utility'] = {
        'AIRTUG',
        'CADDY',
        'CADDY2',
        'CADDY3',
        'DOCKTUG',
        'FORKLIFT',
        'TRACTOR2',
        'TRACTOR3',
        'MOWER',
        'RIPLEY',
        'SADLER',
        'SADLER2',
        'SCRAP',
        'TOWTRUCK',
        'TOWTRUCK2',
        'TRACTOR',
        'UTILLITRUCK',
        'UTILLITRUCK2',
        'UTILLITRUCK3',
        'ARMYTRAILER',
        'ARMYTRAILER2',
        'FREIGHTTRAILER',
        'ARMYTANKER',
        'TRAILERLARGE',
        'DOCKTRAILER',
        'TR3',
        'TR2',
        'TR4',
        'TRFLAT',
        'TRAILERS',
        'TRAILERS4',
        'TRAILERS2',
        'TRAILERS3',
        'TVTRAILER',
        'TRAILERLOGS',
        'TANKER',
        'TANKER2',
        'BALETRAILER',
        'GRAINTRAILER',
        'BOATTRAILER',
        'RAKETRAILER',
        'TRAILERSMALL',
    },
    ['commercial'] = {
        'BENSON',
        'BIFF',
        'CERBERUS',
        'CERBERUS2',
        'CERBERUS3',
        'HAULER',
        'HAULER2',
        'MULE',
        'MULE2',
        'MULE3',
        'MULE4',
        'PACKER',
        'PHANTOM',
        'PHANTOM2',
        'PHANTOM3',
        'POUNDER',
        'POUNDER2',
        'STOCKADE',
        'STOCKADE3',
        'TERBYTE',
        'CABLECAR',
        'FREIGHT',
        'FREIGHTCAR',
        'FREIGHTCONT1',
        'FREIGHTCONT2',
        'FREIGHTGRAIN',
        'METROTRAIN',
        'TANKERCAR',
    },
    ['super'] = {
        'ADDER',
        'AUTARCH',
        'BANSHEE2',
        'BULLET',
        'CHEETAH',
        'CYCLONE',
        'DEVESTE',
        'ENTITYXF',
        'ENTITY2',
        'FMJ',
        'GP1',
        'INFERNUS',
        'ITALIGTB',
        'ITALIGTB2',
        'LE7B',
        'NERO',
        'NERO2',
        'OSIRIS',
        'PENETRATOR',
        'PFISTER811',
        'PROTOTIPO',
        'REAPER',
        'SC1',
        'SCRAMJET',
        'SHEAVA',
        'SULTANRS',
        'T20',
        'TAIPAN',
        'TEMPESTA',
        'TEZERACT',
        'TURISMOR',
        'TYRANT',
        'TYRUS',
        'VACCA',
        'VAGNER',
        'VIGILANTE',
        'VISIONE',
        'VOLTIC',
        'VOLTIC2',
        'XA21',
        'ZENTORNO',
    },
    ['planes'] = {
        'ALPHAZ1',
        'AVENGER',
        'AVENGER2',
        'BESRA',
        'BLIMP',
        'BLIMP2',
        'BLIMP3',
        'BOMBUSHKA',
        'CARGOPLANE',
        'CUBAN800',
        'DODO',
        'DUSTER',
        'HOWARD',
        'HYDRA',
        'JET',
        'LAZER',
        'LUXOR',
        'LUXOR2',
        'MAMMATUS',
        'MICROLIGHT',
        'MILJET',
        'MOGUL',
        'MOLOTOK',
        'NIMBUS',
        'NOKOTA',
        'PYRO',
        'ROGUE',
        'SEABREEZE',
        'SHAMAL',
        'STARLING',
        'STRIKEFORCE',
        'STUNT',
        'TITAN',
        'TULA',
        'VELUM',
        'VELUM2',
        'VESTRA',
        'VOLATOL',
    },
    ['coupes'] = {
        'COGCABRIO',
        'EXEMPLAR',
        'F620',
        'FELON',
        'FELON2',
        'JACKAL',
        'ORACLE',
        'ORACLE2',
        'SENTINEL',
        'SENTINEL2',
        'WINDSOR',
        'WINDSOR2',
        'ZION',
        'ZION2',
    },
    ['vans'] = {
        'BISON',
        'BISON2',
        'BISON3',
        'BOBCATXL',
        'BOXVILLE',
        'BOXVILLE2',
        'BOXVILLE3',
        'BOXVILLE4',
        'BOXVILLE5',
        'BURRITO',
        'BURRITO2',
        'BURRITO3',
        'BURRITO4',
        'BURRITO5',
        'CAMPER',
        'GBURRITO',
        'GBURRITO2',
        'JOURNEY',
        'MINIVAN',
        'MINIVAN2',
        'PARADISE',
        'PONY',
        'PONY2',
        'RUMPO',
        'RUMPO2',
        'RUMPO3',
        'SPEEDO',
        'SPEEDO2',
        'SPEEDO4',
        'SURFER',
        'SURFER2',
        'TACO',
        'YOUGA',
        'YOUGA2',
    },
    ['service'] = {
        'AIRBUS',
        'BRICKADE',
        'BUS',
        'COACH',
        'PBUS2',
        'RALLYTRUCK',
        'RENTALBUS',
        'TAXI',
        'TOURBUS',
        'TRASH',
        'TRASH2',
        'WASTELANDER',
        'AMBULANCE',
        'FBI',
        'FBI2',
        'FIRETRUK',
        'LGUARD',
        'PBUS',
        'POLICE',
        'POLICE2',
        'POLICE3',
        'POLICE4',
        'POLICEB',
        'POLICEOLD1',
        'POLICEOLD2',
        'POLICET',
        'POLMAV',
        'PRANGER',
        'PREDATOR',
        'RIOT',
        'RIOT2',
        'SHERIFF',
        'SHERIFF2',
        'APC',
        'BARRACKS',
        'BARRACKS2',
        'BARRACKS3',
        'BARRAGE',
        'CHERNOBOG',
        'CRUSADER',
        'HALFTRACK',
        'KHANJALI',
        'trash',
        'SCARAB',
        'SCARAB2',
        'SCARAB3',
        'THRUSTER',
        'TRAILERSMALL2',
    },
    ['suvs'] = {
        'BALLER',
        'BALLER2',
        'BALLER3',
        'BALLER4',
        'BALLER5',
        'BALLER6',
        'BJXL',
        'CAVALCADE',
        'CAVALCADE2',
        'CONTENDER',
        'DUBSTA',
        'DUBSTA2',
        'FQ2',
        'GRANGER',
        'GRESLEY',
        'HABANERO',
        'HUNTLEY',
        'LANDSTALKER',
        'MESA',
        'MESA2',
        'PATRIOT',
        'PATRIOT2',
        'RADI',
        'ROCOTO',
        'SEMINOLE',
        'SERRANO',
        'TOROS',
        'XLS',
        'XLS2',
    },
    ['industrial'] = {
        'BULLDOZER',
        'CUTTER',
        'DUMP',
        'FLATBED',
        'GUARDIAN',
        'HANDLER',
        'MIXER',
        'MIXER2',
        'RUBBLE',
        'TIPTRUCK',
        'TIPTRUCK2',
    },
    ['helicopters'] = {
        'AKULA',
        'ANNIHILATOR',
        'BUZZARD',
        'BUZZARD2',
        'CARGOBOB',
        'CARGOBOB2',
        'CARGOBOB3',
        'CARGOBOB4',
        'FROGGER',
        'FROGGER2',
        'HAVOK',
        'HUNTER',
        'MAVERICK',
        'POLMAV',
        'SAVAGE',
        'SEASPARROW',
        'SKYLIFT',
        'SUPERVOLITO',
        'SUPERVOLITO2',
        'SWIFT',
        'SWIFT2',
        'VALKYRIE',
        'VALKYRIE2',
        'VOLATUS',
    },
    ['boats'] = {
        'DINGHY',
        'DINGHY2',
        'DINGHY3',
        'DINGHY4',
        'JETMAX',
        'MARQUIS',
        'PREDATOR',
        'SEASHARK',
        'SEASHARK2',
        'SEASHARK3',
        'SPEEDER',
        'SPEEDER2',
        'SQUALO',
        'SUBMERSIBLE',
        'SUBMERSIBLE2',
        'SUNTRAP',
        'TORO',
        'TORO2',
        'TROPIC',
        'TROPIC2',
        'TUG',
    },
    ['sedans'] = {
        'ASEA',
        'ASEA2',
        'ASTEROPE',
        'COG55',
        'COG552',
        'COGNOSCENTI',
        'COGNOSCENTI2',
        'EMPEROR',
        'EMPEROR2',
        'EMPEROR3',
        'FUGITIVE',
        'GLENDALE',
        'INGOT',
        'INTRUDER',
        'LIMO2',
        'PREMIER',
        'PRIMO',
        'PRIMO2',
        'REGINA',
        'ROMERO',
        'SCHAFTER2',
        'SCHAFTER5',
        'SCHAFTER6',
        'STAFFORD',
        'STANIER',
        'STRATUM',
        'STRETCH',
        'SUPERD',
        'SURGE',
        'TAILGATER',
        'WARRENER',
        'WASHINGTON',
    },
    ['muscle'] = {
        'BLADE',
        'BUCCANEER',
        'BUCCANEER2',
        'CHINO',
        'CHINO2',
        'CLIQUE',
        'COQUETTE3',
        'DEVIANT',
        'DOMINATOR',
        'DOMINATOR2',
        'DOMINATOR3',
        'DOMINATOR4',
        'DOMINATOR5',
        'DOMINATOR6',
        'DUKES',
        'DUKES2',
        'ELLIE',
        'FACTION',
        'FACTION2',
        'FACTION3',
        'GAUNTLET',
        'GAUNTLET2',
        'HERMES',
        'HOTKNIFE',
        'HUSTLER',
        'IMPALER',
        'IMPALER2',
        'IMPALER3',
        'IMPALER4',
        'IMPERATOR',
        'IMPERATOR2',
        'IMPERATOR3',
        'LURCHER',
        'MOONBEAM',
        'MOONBEAM2',
        'NIGHTSHADE',
        'PHOENIX',
        'PICADOR',
        'RATLOADER',
        'RATLOADER2',
        'RUINER',
        'RUINER2',
        'RUINER3',
        'SABREGT',
        'SABREGT2',
        'SLAMVAN',
        'SLAMVAN2',
        'SLAMVAN3',
        'SLAMVAN4',
        'SLAMVAN5',
        'SLAMVAN6',
        'STALION',
        'STALION2',
        'TAMPA',
        'TAMPA3',
        'TULIP',
        'VAMOS',
        'VIGERO',
        'VIRGO',
        'VIRGO2',
        'VIRGO3',
        'VOODOO',
        'VOODOO2',
        'YOSEMITE',
    },
}

local TogglesThread = function()
    while true do
        if framework.toggle['Show toggles'] then
            local offs = 0.0
            for k, v in pairs(framework.toggle) do
                if v then
                    if k ~= 'Show toggles' then
                        if type(v) ~= 'boolean' then
                            DrawText(k .. ' [' .. v .. ']', 0.0 + offs, true, nil, 0.25, 0.9, false, 0.1)
                        else
                            DrawText(k, 0.0 + offs, true, nil, 0.25, 0.9, false, 0.1)
                        end
                        offs = offs + 0.015
                    end
                end
            end
        end
        Wait(250)
    end
end

local PlayerUpdate = function()
    while true do
        allplayers = {}
        for k, v in pairs(GetActivePlayers()) do
            if not friends[GetPlayerServerId(v)] then
                table.insert(allplayers, v)
            end
        end
        Wait(1000)
    end
end

local BlipsThread = function()
    while true do

        if framework.toggle['PlayerBlips'] then
            PlayerBlips({
                ['Enabled'] = framework.toggle['PlayerBlips']
            })
        end

        Wait(10000)
    end
end

local Loaded = function()
    while not menuvisible and not HasOpened do
        DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
        Wait(0)
    end
    StopSound()
end

--[[
local VehicleInitialize = function()
    for k, v in pairs(vehicles) do
        table.insert(Objects[17], {
            ['Text'] = k,
            ['Type'] = 'list',
            ['Items'] = v,
            ['Current'] = 1,
            ['cb'] = SpawnVehicle,
        })
    end

    table.insert(Objects[17], {
        ['Text'] = 'Back',
        ['Type'] = 'menu',
        ['Menu'] = 12,
    })
end
]]

CreateThread(VehicleInitialize)
CreateThread(Menu)
CreateThread(Loaded)
CreateThread(PlayerUpdate)
CreateThread(BlipsThread)
CreateThread(TogglesThread)

print("Working!")