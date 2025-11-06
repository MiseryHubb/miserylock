-- Main.lua
-- Place this in StarterPlayerScripts (LocalScript)
-- Make sure Config.lua is loaded first or run before this script

if getgenv().miserylockRan then
    return
else
    getgenv().miserylockRan = true
end

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Player = nil -- Target player

-- Optimized GetClosestPlayer
local function GetClosestPlayer()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    for _, P in pairs(Players:GetPlayers()) do
        if P ~= LocalPlayer and P.Character and P.Character:FindFirstChild('HumanoidRootPart') then
            local Root, OnScreen = Camera:WorldToScreenPoint(P.Character.HumanoidRootPart.Position)
            if not OnScreen then continue end
            local Dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Root.X, Root.Y)).Magnitude
            if Dist < ClosestDistance then
                ClosestDistance = Dist
                ClosestPlayer = P
            end
        end
    end
    return ClosestPlayer
end

-- Toggle target on key press
Mouse.KeyDown:Connect(function(key)
    if key:lower() == getgenv().miserylock.Keybind:lower() then
        Player = not Player and GetClosestPlayer() or nil
    end
end)

-- Aim loop
RunService.RenderStepped:Connect(function()
    if not Player or not getgenv().miserylock.Status then return end

    local Hitpart = Player.Character and Player.Character:FindFirstChild(getgenv().miserylock.Hitpart)
    if not Hitpart then return end

    local pred = getgenv().miserylock.Prediction
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Hitpart.Position + Hitpart.Velocity * Vector3.new(pred.X, pred.Y, pred.X))
end)
