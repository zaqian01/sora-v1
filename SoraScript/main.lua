-- SORA V1 | Main (Status Panel Version) - Teleport Removed, UI Enhanced
-- Bunny Executor Ready

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local DIST = 50 -- Meskipun tidak digunakan untuk TP, variabel tetap ada.
local HEADER_HEIGHT = 35 -- Ditingkatkan
local INFO_HEIGHT = 70 -- Ditingkatkan
local INITIAL_HEIGHT = 480 
local FRAME_WIDTH = 300

-- ===== UTILS =====
local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- Fungsi teleport dihapus

-- ===== GUI (STRUCTURE FIXED & ENHANCED) =====
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SoraV1_Status"

-- 1. MainFrame (Frame utama yang draggable)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(FRAME_WIDTH, INITIAL_HEIGHT)
frame.Position = UDim2.fromOffset(200, 200)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
frame.ClipsDescendants = true 

-- 2. Header (Title Bar)
local title = Instance.new("TextLabel", frame)
title.Name = "Header"
title.Size = UDim2.new(1,0,0,HEADER_HEIGHT)
title.Text = "SORA V1 "
title.TextColor3 = Color3.fromRGB(0,255,180)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.Font = Enum.Font.Code
title.TextSize = 18 -- Ditingkatkan
title.BorderSizePixel = 0

-- 3. ContentFrame (Container untuk semua tombol dan info)
local contentFrame = Instance.new("Frame", frame)
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1,0,1,-HEADER_HEIGHT)
contentFrame.Position = UDim2.fromOffset(0, HEADER_HEIGHT) 
contentFrame.BackgroundTransparency = 1

local list = Instance.new("UIListLayout", contentFrame)
list.Padding = UDim.new(0,8) -- Padding ditingkatkan
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder
list.FillDirection = Enum.FillDirection.Vertical
list.VerticalAlignment = Enum.VerticalAlignment.Top


-- Function to create buttons (ditempatkan di ContentFrame)
local function btn(text, cb)
    local b = Instance.new("TextButton", contentFrame)
    b.Size = UDim2.fromOffset(FRAME_WIDTH - 20,40) -- Tinggi tombol ditingkatkan
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 18 -- Ditingkatkan
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(cb)
    return b
end

-- 4. InfoFrame (FPS & Koordinat) - Status Panel
local infoFrame = Instance.new("Frame", contentFrame)
infoFrame.Name = "InfoFrame"
infoFrame.Size = UDim2.fromOffset(FRAME_WIDTH - 20, INFO_HEIGHT)
infoFrame.BackgroundTransparency = 1
infoFrame.LayoutOrder = 1 

local infoList = Instance.new("UIListLayout", infoFrame)
infoList.HorizontalAlignment = Enum.HorizontalAlignment.Left
infoList.SortOrder = Enum.SortOrder.LayoutOrder
infoList.Padding = UDim.new(0,5)

local coord = Instance.new("TextLabel", infoFrame)
coord.Size = UDim2.new(1,0,0,30)
coord.BackgroundTransparency = 1
coord.TextWrapped = true
coord.TextXAlignment = Enum.TextXAlignment.Left
coord.Text = "POS: X: 0.0 | Y: 0.0 | Z: 0.0"
coord.TextSize = 16 -- Sesuai permintaan
coord.Font = Enum.Font.GothamBold -- Sesuai permintaan
coord.TextColor3 = Color3.fromRGB(220,220,220) -- Sesuai permintaan

local fpsLabel = Instance.new("TextLabel", infoFrame)
fpsLabel.Size = UDim2.new(1,0,0,25) -- Diperbesar
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "FPS: 0"
local last = tick()
fpsLabel.TextSize = 18 -- Sesuai permintaan
fpsLabel.Font = Enum.Font.GothamBold -- Sesuai permintaan
fpsLabel.TextColor3 = Color3.fromRGB(0,255,180) -- Sesuai permintaan

local separator = Instance.new("Frame", contentFrame) 
separator.Size = UDim2.fromOffset(FRAME_WIDTH - 20, 2)
separator.BackgroundColor3 = Color3.fromRGB(60,60,60)
separator.LayoutOrder = 2

-- Main Buttons start here
local buttonStartOrder = 3 

-- LOGIKA TELEPORT DIHAPUS

-- ===== PROPER FLY (LOGIC UNCHANGED) =====
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
        hum.PlatformStand = fly 
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
    frame.Size = minimized and UDim2.fromOffset(FRAME_WIDTH, HEADER_HEIGHT) or UDim2.fromOffset(FRAME_WIDTH, INITIAL_HEIGHT)
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1


-- ===== RENDERSTEPPED LOOP (LOGIC UNCHANGED) =====
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

        bv.Velocity = dir.Magnitude > 0 and dir.Unit * speed or Vector3.zero
        bg.CFrame = cam.CFrame
    end

    -- Coordinate Display logic (Status Panel)
    local hrp = HRP()
    if hrp then
        local p = hrp.Position
        coord.Text = string.format(
            "POS: X: %.1f | Y: %.1f | Z: %.1f", -- Tambahkan label POS
            p.X, p.Y, p.Z
        )
    end
    
    -- FPS Counter logic
    local now = tick()
    local currentFps = math.floor(1 / (now - last))
    last = now
    fpsLabel.Text = "FPS: " .. currentFps
end)
