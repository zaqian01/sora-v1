-- SORA V1 | Main (Relative Teleport Version)
-- Bunny Executor Ready

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local DIST = 50

-- ===== UTILS =====
local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function teleport(offset)
    local hrp = HRP()
    if not hrp then return end
    hrp.CFrame = hrp.CFrame + offset
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SoraV1"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260, 360)
frame.Position = UDim2.fromOffset(200, 200)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "SORA V1"
title.TextColor3 = Color3.fromRGB(0,255,180)
title.BackgroundTransparency = 1

local list = Instance.new("UIListLayout", frame)
list.Padding = UDim.new(0,6)

local function btn(text, cb)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.fromOffset(240,30)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(cb)
end

-- ===== COORDINATE DISPLAY (DIMASUKKAN DI SINI) =====
local coord = Instance.new("TextLabel", frame)
coord.Size = UDim2.fromOffset(240, 40)
coord.TextColor3 = Color3.fromRGB(0,255,180)
coord.BackgroundTransparency = 1
coord.TextWrapped = true

-- ===== FPS COUNTER (DIMASUKKAN DI SINI) =====
local fpsLabel = Instance.new("TextLabel", frame)
fpsLabel.Size = UDim2.fromOffset(240, 20)
fpsLabel.TextColor3 = Color3.fromRGB(255,255,255)
fpsLabel.BackgroundTransparency = 1
local last = tick()
local fps = 0

-- ===== RELATIVE TELEPORT BUTTONS =====
btn("TP Forward (+Z)", function()
    local hrp = HRP()
    if hrp then teleport(hrp.CFrame.LookVector * DIST) end
end)

btn("TP Backward (-Z)", function()
    local hrp = HRP()
    if hrp then teleport(-hrp.CFrame.LookVector * DIST) end
end)

btn("TP Right (+X)", function()
    local hrp = HRP()
    if hrp then teleport(hrp.CFrame.RightVector * DIST) end
end)

btn("TP Left (-X)", function()
    local hrp = HRP()
    if hrp then teleport(-hrp.CFrame.RightVector * DIST) end
end)

btn("TP Up (+Y)", function()
    teleport(Vector3.new(0, DIST, 0))
end)

btn("TP Down (-Y)", function()
    teleport(Vector3.new(0, -DIST, 0))
end)

-- ===== FLY =====
local flying = false
local bv, bg

btn("Fly ON / OFF", function()
    flying = not flying
    local hrp = HRP()
    if not hrp then return end

    if flying then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- ===== NOCLIP =====
local noclip = false
btn("Noclip ON / OFF", function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ===== SPEED =====
local speedOn = false
btn("Speed x2 ON / OFF", function()
    speedOn = not speedOn
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = speedOn and 32 or 16
    end
end)

-- ===== HIDE GAME UI =====
local hidden = false
btn("Hide Game UI ON / OFF", function()
    hidden = not hidden
    for _,ui in pairs(player.PlayerGui:GetChildren()) do
        if ui ~= gui and ui:IsA("ScreenGui") then
            ui.Enabled = not hidden
        end
    end
end)

-- ===== MINIMIZE =====
local minimized = false
btn("Minimize UI", function()
    minimized = not minimized
    frame.Size = minimized and UDim2.fromOffset(260,40) or UDim2.fromOffset(260,360)
end)


-- ===== RENDERSTEPPED LOOP (DIGABUNGKAN) =====
RunService.RenderStepped:Connect(function()
    -- Fly logic
    if flying and bv and bg then
        local cam = workspace.CurrentCamera
        bv.Velocity = cam.CFrame.LookVector * 60
        bg.CFrame = cam.CFrame
    end

    -- Coordinate Display logic
    local hrp = HRP()
    if hrp then
        local p = hrp.Position
        coord.Text = string.format(
            "X: %.1f\nY: %.1f\nZ: %.1f",
            p.X, p.Y, p.Z
        )
    end
    
    -- FPS Counter logic
    local now = tick()
    fps = math.floor(1 / (now - last))
    last = now
    fpsLabel.Text = "FPS: " .. fps
end)
