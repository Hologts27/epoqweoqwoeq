-- settings, if you want to change some settings just re-execute.
_G.whitelist = {
    "Player1",
    "Player2"
}
_G.friendsListIsWhitelisted = true -- change if you don't want to lock onto your friends
_G.targetPart = "Head"
_G.bindEnabled = false
_G.bind = Enum.KeyCode.KeypadMultiply -- use the keycode reference: https://developer.roblox.com/en-us/api-reference/enum/KeyCode, this keydisables aimbot

_G.FOV = 60

-- This is primarily useful in first person shooters, note, wallbang will not work when you disable this.
local RAYCAST_ENABLED = true
-- -- This is rarely useful, however in some cases you might want it.
local MOUSE_TARGET_ENABLED = false
-- This is useful for most third person shooters.  It will function very well if you're having bugs, switch to mouse position.
local MOUSE_HIT_ENABLED = false
-- If you want to spoof the mouse's x and y coordinated on the screen.  usually if it's a 3rd person shooter it will use this or mouse hit.
local MOUSE_POSITION_ENABLED = true
-- I'm not sure what you're going to use this for, but it works I guess
local MOUSE_ORIGIN_ENABLED = false

_G.indexTable = {
    -- mainly for scripters, but basically these are mouse properties that you might want to enable/disable if it's bugging out.
    ["Mouse"] = {
        ["target"] = {
            Function = function(self, value)
                return _G.closestCharacter[_G.targetPart]
            end,
            Enabled = MOUSE_TARGET_ENABLED
        },
        ["hit"] = {
            Function = function(self, value)
                return _G.closestCharacter[_G.targetPart].CFrame
            end,
            Enabled = MOUSE_HIT_ENABLED
        },
        ["origin"] = {
            Function = function(self, value)
                return CFrame.new(value.Position, _G.closestCharacter[_G.targetPart].Position)
            end,
            Enabled = MOUSE_ORIGIN_ENABLED
        },
        ["x"] = {
            Function = function(self, value)
                return uis:GetMouseLocation().X
            end,
            Enabled = MOUSE_POSITION_ENABLED
        },
        ["y"] = {
            Function = function(self, value)
                return uis:GetMouseLocation().Y
            end,
            Enabled = MOUSE_POSITION_ENABLED
        },
        ["unitray"] = {
            Function = function(self, value)
                return Ray.new(
                    self.Origin.Position,
                    (_G.closestCharacter[_G.targetPart].Position - self.Origin.Position).Unit
                )
            end,
            Enabled = RAYCAST_ENABLED
        }
    },
    ["Humanoid"] = {
        ["targetpoint"] = {
            Function = function(self, value)
                return _G.closestCharacter[_G.targetPart].Position
            end,
            Enabled = MOUSE_HIT_ENABLED
        }
    }
}

_G.namecallTable = {
    ["getmouselocation"] = {
        Function = function(self, returns, args)
            local vector =
                workspace.CurrentCamera.WorldToViewportPoint(
                workspace.CurrentCamera,
                _G.closestCharacter[_G.targetPart].Position
            )
            returns[1] = Vector2.new(vector.X, vector.Y)
            return returns
        end,
        Enabled = MOUSE_POSITION_ENABLED
    },
    ["findpartonraywithignorelist"] = {
        Function = function(self, returns, args)
            args[1] =
                Ray.new(
                mouse.Origin.Position,
                (_G.closestCharacter[_G.targetPart].Position +
                    Vector3.new(
                        0,
                        (mouse.Origin.Position - _G.closestCharacter[_G.targetPart].Position).Magnitude / 500,
                        0
                    ) -
                    mouse.Origin.Position).unit * 500
            )
            if not _G.wallbang then
                returns = table.pack(self.FindPartOnRayWithIgnoreList(self, unpack(args)))
            else
                args[2] = {}
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Character then
                        table.insert(args[2], player.Character)
                    end
                end
                returns = table.pack(self.FindPartOnRayWithWhitelist(self, unpack(args)))
            end
            return returns
        end,
        Enabled = RAYCAST_ENABLED
    },
    ["findpartonray"] = {
        Function = function(self, returns, args)
            args[1] =
                Ray.new(
                mouse.Origin.Position,
                (_G.closestCharacter[_G.targetPart].Position +
                    Vector3.new(
                        0,
                        (mouse.Origin.Position - _G.closestCharacter[_G.targetPart].Position).Magnitude / 500,
                        0
                    ) -
                    mouse.Origin.Position).unit * 500
            )
            if not args[2] then
                args[2] = {}
            end
            if not _G.wallbang then
                returns = table.pack(self.FindPartOnRayWithIgnoreList(self, unpack(args)))
            else
                args[2] = {}
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Character then
                        table.insert(args[2], player.Character)
                    end
                end
                returns = table.pack(self.FindPartOnRayWithWhitelist(self, unpack(args)))
            end
            return returns
        end,
        Enabled = RAYCAST_ENABLED
    },
    ["findpartonraywithwhitelist"] = {
        Function = function(self, returns, args)
            args[1] =
                Ray.new(
                mouse.Origin.Position,
                (_G.closestCharacter[_G.targetPart].Position +
                    Vector3.new(
                        0,
                        (mouse.Origin.Position - _G.closestCharacter[_G.targetPart].Position).Magnitude / 500,
                        0
                    ) -
                    mouse.Origin.Position).unit * 500
            )
            if not _G.wallbang then
                returns = table.pack(self.FindPartOnRayWithIgnoreList(self, unpack(args)))
            else
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Character then
                        table.insert(args[2], player.Character)
                    end
                end
                returns = table.pack(self.FindPartOnRayWithWhitelist(self, unpack(args)))
            end

            return returns
        end,
        Enabled = RAYCAST_ENABLED
    },
    ["raycast"] = {
        Function = function(self, returns, args)
            args[1], args[2] =
                mouse.Origin.Position,
                (_G.closestCharacter[_G.targetPart].Position +
                    Vector3.new(
                        0,
                        (mouse.Origin.Position - _G.closestCharacter[_G.targetPart].Position).Magnitude / 500,
                        0
                    ) -
                    mouse.Origin.Position).unit * 500

            if not _G.wallbang then
                returns = table.pack(self.Raycast(self, unpack(args)))
            else
                local FilterDescendantsInstances = args[3].FilterDescendantsInstances
                local FilterType = Enum.RaycastFilterType.Whitelist
                local IgnoreWater = args[3].IgnoreWater
                local CollisionGroup = args[3].CollisionGroup
                args[3] =
                    RaycastParams.new(
                    {
                        FilterDescendantsInstances = FilterDescendantsInstances,
                        FilterType = FilterType,
                        IgnoreWater = IgnoreWater,
                        CollisionGroup = CollisionGroup
                    }
                )
                returns = table.pack(self.Raycast(self, unpack(args)))
            end

            return returns
        end,
        Enabled = RAYCAST_ENABLED
    }
}

-- the actual script
local getnamecallmethod = getnamecallmethod or getnamecall_method
local newcclosure = newcclosure or hide_me or function(func)
        return func
    end

local checkcaller = checkcaller or is_protosmasher_caller or Cer.isCerus

uis = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
mouse = player:GetMouse()

local mt = getrawmetatable(game)

local mt_index, mt_namecall = mt.__index, mt.__namecall

if setreadonly then
    setreadonly(mt, false)
elseif make_writeable then
    make_writeable(mt, true)
end

function IsTeamMate(Player1, Player2)
    return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and
        Player1.TeamColor == Player2.TeamColor)
end

if not _G.MUTEX then
    _G.MUTEX = true

    local aimbot = true
    function mt:__index(index)
        local value = mt_index(self, index)

        if not checkcaller() then
            if aimbot then
                local table  -- im pretty sure this works like rawget for properties
                for index, value in pairs(_G.indexTable) do
                    if self:IsA(index) then
                        table = value
                        break
                    end
                end

                if table then
                    table = table[index:lower()]
                    if table then
                        if table.Enabled then
                            if _G.closestCharacter then
                                return table.Function(self, value)
                            end
                        end
                    end
                end
            end
        end

        return value
    end

    function mt:__namecall(...)
        local args = {
            ...
        }

        local returns = table.pack(mt_namecall(self, unpack(args)))

        if aimbot then
            local table = _G.namecallTable[getnamecallmethod():lower()]
            if table then
                if table.Enabled then
                    if _G.closestCharacter then
                        returns = table.Function(self, returns, args)
                    end
                end
            end
        end

        return unpack(returns)
    end

    uis.InputBegan:Connect(
        function(input, gameProcessed)
            if not gameProcessed and _G.bindEnabled then
                if input.KeyCode == _G.bind then
                    aimbot = not aimbot
                end
            end
        end
    )

    while wait() do
        pcall(
            function()
                -- because this shit breaks like 24/7
                _G.closestCharacter, closestDistance = nil, math.huge
                for _, currentPlayer in ipairs(game.Players:GetPlayers()) do
                    if not table.find(_G.whitelist, currentPlayer.Name) then
                        if currentPlayer ~= game.Players.LocalPlayer then
                            local character = currentPlayer.Character
                            if character then
                                local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                                if humanoid and humanoid.Health > 0 and not IsTeamMate(player, currentPlayer) then
                                    if
                                        not _G.friendsListIsWhitelisted or
                                            (_G.friendsListIsWhitelisted and
                                                not currentPlayer:IsFriendsWith(player.UserId))
                                     then
                                        local vector, onScreen =
                                            workspace.CurrentCamera:WorldToScreenPoint(
                                            character[_G.targetPart].Position
                                        )
                                        if onScreen then
                                            local magnitude =
                                                (Vector2.new(mouse.X, mouse.Y) - Vector2.new(vector.X, vector.Y)).magnitude
                                            if magnitude < closestDistance then
                                                if magnitude <= _G.FOV then
                                                    _G.closestCharacter, closestDistance = character, magnitude
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        )
    end
end
