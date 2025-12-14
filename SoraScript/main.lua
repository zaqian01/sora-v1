-- SORA V1 | Main (Relative Teleport Version) - UI & Proper Fly Updated
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

-- ===== GUI (KOREKSI LAYOUT) =====
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SoraV1_Updated"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 480) -- Ukuran Frame awal
frame.Position = UDim2.fromOffset(200, 200)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
frame.ClipsDescendants = false -- Pastikan tidak ada yang terpotong secara tidak sengaja

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "SORA V1 | Bunny Executor"
title.TextColor3 = Color3.fromRGB(0,255,180)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.Font = Enum.Font.Code
title.BorderSizePixel = 0

-- Container untuk semua tombol dan info di bawah title
local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(1,0,1,-30) -- Ambil sisa ruang Frame (Frame.Size - Title.Height)
contentFrame.Position = UDim2.fromOffset(0, 30) -- Posisikan di bawah Title
contentFrame.BackgroundTransparency = 1

local list = Instance.new("UIListLayout", contentFrame)
list.Padding = UDim.new(0,6)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder
list.FillDirection = Enum.FillDirection.Vertical
list.VerticalAlignment = Enum.VerticalAlignment.Top


-- Function to create buttons
local function btn(text, cb)
    local b = Instance.new("TextButton", contentFrame)
    b.Size = UDim2.fromOffset(280,35)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(cb)
    return b
end

-- ===== COORDINATE DISPLAY & FPS COUNTER (TOP/INFO SECTION) =====
local infoFrame = Instance.new("Frame", contentFrame)
infoFrame.Size = UDim2.fromOffset(280, 65)
infoFrame.BackgroundTransparency = 1
infoFrame.LayoutOrder = 1 -- Paling atas di ContentFrame

local infoList = Instance.new("UIListLayout", infoFrame)
infoList.HorizontalAlignment = Enum.HorizontalAlignment.Left
infoList.SortOrder = Enum.SortOrder.LayoutOrder
infoList.Padding = UDim.new(0,5)

local coord = Instance.new("TextLabel", infoFrame)
coord.Size = UDim2.new(1,0,0,30)
coord.TextColor3 = Color3.fromRGB(0,255,180)
coord.BackgroundTransparency = 1
coord.TextWrapped = true
coord.TextXAlignment = Enum.TextXAlignment.Left
coord.Font = Enum.Font.Code
coord.Text = "X: 0.0 | Y: 0.0 | Z: 0.0"

local fpsLabel = Instance.new("TextLabel", infoFrame)
fpsLabel.Size = UDim2.new(1,0,0,20)
fpsLabel.TextColor3 = Color3.fromRGB(255,255,255)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Font = Enum.Font.Code
fpsLabel.Text = "FPS: 0"
local last = tick()

local separator = Instance.new("Frame", contentFrame) -- Visual Separator
separator.Size = UDim2.fromOffset(280, 2)
separator.BackgroundColor3 = Color3.fromRGB(60,60,60)
separator.LayoutOrder = 2

-- Main Buttons start here
local buttonStartOrder = 3 

-- ===== RELATIVE TELEPORT BUTTONS =====
btn("TP Forward (+Z)", function()
    local hrp = HRP()
    if hrp then teleport(hrp.CFrame.LookVector * DIST) end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

btn("TP Backward (-Z)", function()
    local hrp = HRP()
    if hrp then teleport(-hrp.CFrame.LookVector * DIST) end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

btn("TP Right (+X)", function()
    local hrp = HRP()
    if hrp then teleport(hrp.CFrame.RightVector * DIST) end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

btn("TP Left (-X)", function()
    local hrp = HRP()
    if hrp then teleport(-hrp.CFrame.RightVector * DIST) end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

btn("TP Up (+Y)", function()
    teleport(Vector3.new(0, DIST, 0))
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

btn("TP Down (-Y)", function()
    teleport(Vector3.new(0, -DIST, 0))
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

-- ===== PROPER FLY LOGIC (MODIFIED) =====
local fly = false
local speed = 60
local bv, bg
local keys = {W=false,A=false,S=false,D=false,Space=false,Ctrl=false}

UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.W then keys.W=true end
    if i.KeyCode == Enum.KeyCode.S then keys.S=true end
    if i.KeyCode == Enum.KeyCode.A then keys.A=true end
    if i.KeyCode == Enum.KeyCode.D then keys.D=true end
    if i.KeyCode == Enum.KeyCode.Space then keys.Space=true end
    if i.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl=true end
end)

UIS.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.W then keys.W=false end
    if i.KeyCode == Enum.KeyCode.S then keys.S=false end
    if i.KeyCode == Enum.KeyCode.A then keys.A=false end
    if i.KeyCode == Enum.KeyCode.D then keys.D=false end
    if i.KeyCode == Enum.KeyCode.Space then keys.Space=false end
    if i.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl=false end
end)

btn("Fly ON / OFF", function()
    fly = not fly
    local hrp = HRP()
    if not hrp then return end
    
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = fly -- Pastikan Humanoid berada dalam PlatformStand
    end

    if fly then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.zero

        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        bg.CFrame = hrp.CFrame
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

-- ===== NOCLIP (Logic Unchanged) =====
local noclip = false
btn("Noclip ON / OFF", function()
    noclip = not noclip
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ===== SPEED (Logic Unchanged) =====
local speedOn = false
btn("Speed x2 ON / OFF", function()
    speedOn = not speedOn
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = speedOn and 32 or 16
    end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

-- ===== HIDE GAME UI (Logic Unchanged) =====
local hidden = false
btn("Hide Game UI ON / OFF", function()
    hidden = not hidden
    for _,ui in pairs(player.PlayerGui:GetChildren()) do
        if ui ~= gui and ui:IsA("ScreenGui") then
            ui.Enabled = not hidden
        end
    end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

-- ===== MINIMIZE (Logic Unchanged) =====
local minimized = false
btn("Minimize UI", function()
    minimized = not minimized
    frame.Size = minimized and UDim2.fromOffset(300,40) or UDim2.fromOffset(300, 480) -- Sesuaikan ukuran minimized
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1


-- ===== RENDERSTEPPED LOOP (DIGABUNGKAN & LOGIC FLY DIUBAH) =====
RunService.RenderStepped:Connect(function()
    -- Proper Fly logic
    if fly and bv and bg then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if keys.W then dir += cam.CFrame.LookVector end
        if keys.S then dir -= cam.CFrame.LookVector end
        if keys.A then dir -= cam.CFrame.RightVector end
        if keys.D then dir += cam.CFrame.RightVector end
        if keys.Space then dir += Vector3.new(0,1,0) end
        if keys.Ctrl then dir -= Vector3.new(0,1,0) end

        -- Normalize vector for consistent speed
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * speed or Vector3.zero
        bg.CFrame = cam.CFrame
    end

    -- Coordinate Display logic
    local hrp = HRP()
    if hrp then
        local p = hrp.Position
        coord.Text = string.format(
            "X: %.1f | Y: %.1f | Z: %.1f", -- Format 1 baris untuk estetika UI
            p.X, p.Y, p.Z
        )
    end
    
    -- FPS Counter logic
    local now = tick()
    local currentFps = math.floor(1 / (now - last))
    last = now
    fpsLabel.Text = "FPS: " .. currentFps
end)
