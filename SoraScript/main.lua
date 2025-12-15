local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats") 
local TweenService = game:GetService("TweenService") -- Ditambahkan

local player = Players.LocalPlayer
local DIST = 50 
local HEADER_HEIGHT = 35 
local INFO_HEIGHT = 70 
-- Tinggi disesuaikan untuk tombol kamera baru
local INITIAL_HEIGHT = 580 
local FRAME_WIDTH = 300

-- UTILS
local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA"

-- ===== FADE SCREEN =====
local fadeGui = Instance.new("ScreenGui", player.PlayerGui)
fadeGui.Name = "Soraboy"
fadeGui.IgnoreGuiInset = true
fadeGui.ResetOnSpawn = false
local fadeFrame = Instance.new("Frame", fadeGui)
fadeFrame.Size = UDim2.fromScale(1,1)
fadeFrame.BackgroundColor3 = Color3.new(0,0,0)
fadeFrame.BackgroundTransparency = 1
fadeFrame.ZIndex = 999

local function FadeIn(time)
	fadeFrame.BackgroundTransparency = 0
	TweenService:Create(
		fadeFrame,
		TweenInfo.new(time, Enum.EasingStyle.Sine),
		{BackgroundTransparency = 1}
	):Play()
end
local function FadeOut(time)
	fadeFrame.BackgroundTransparency = 1
	TweenService:Create(
		fadeFrame,
		TweenInfo.new(time, Enum.EasingStyle.Sine),
		{BackgroundTransparency = 0}
	):Play()
end
-- =======================

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(FRAME_WIDTH, INITIAL_HEIGHT)
frame.Position = UDim2.fromOffset(200, 200)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
frame.ClipsDescendants = true 

local title = Instance.new("TextLabel", frame)
title.Name = "Header"
title.Size = UDim2.new(1,0,0,HEADER_HEIGHT)
title.Text = "SORA"
title.TextColor3 = Color3.fromRGB(0,255,180)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.Font = Enum.Font.Code
title.TextSize = 18 
title.BorderSizePixel = 0

local contentFrame = Instance.new("Frame", frame)
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1,0,1,-HEADER_HEIGHT)
contentFrame.Position = UDim2.fromOffset(0, HEADER_HEIGHT) 
contentFrame.BackgroundTransparency = 1

local list = Instance.new("UIListLayout", contentFrame)
list.Padding = UDim.new(0,8) 
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder
list.FillDirection = Enum.FillDirection.Vertical
list.VerticalAlignment = Enum.VerticalAlignment.Top

local function btn(text, cb)
    local b = Instance.new("TextButton", contentFrame)
    b.Size = UDim2.fromOffset(FRAME_WIDTH - 20,40) 
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 18 
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(cb)
    return b
end

-- INFO DISPLAY
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
coord.TextSize = 16 
coord.Font = Enum.Font.GothamBold 
coord.TextColor3 = Color3.fromRGB(220,220,220) 

local pingLabel = Instance.new("TextLabel", infoFrame)
pingLabel.Name = "PingLabel"
pingLabel.Size = UDim2.new(1,0,0,25) 
pingLabel.BackgroundTransparency = 1
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Text = "PING: -- ms"
pingLabel.TextSize = 20 
pingLabel.Font = Enum.Font.GothamBold 
pingLabel.TextColor3 = Color3.fromRGB(0,255,180) 

local separator = Instance.new("Frame", contentFrame) 
separator.Size = UDim2.fromOffset(FRAME_WIDTH - 20, 2)
separator.BackgroundColor3 = Color3.fromRGB(60,60,60)
separator.LayoutOrder = 2

local buttonStartOrder = 3 

-- FADE BUTTONS
btn("Fade In", function()
	FadeIn(1.5)
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

btn("Fade Out", function()
	FadeOut(1.5)
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

-- PROPER FLY
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

-- NOCLIP
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

-- SMOOTH CAMERA MOVE UTILS
local cam = workspace.CurrentCamera
local function SmoothMove(targetCF, time)
	local start = cam.CFrame
	local t = 0
	while t < 1 do
		local dt = RunService.RenderStepped:Wait()
		t += dt / time
		cam.CFrame = start:Lerp(targetCF, math.clamp(t,0,1))
	end
end

-- CAMERA DOLLY / PUSH
btn("Cinematic Push Forward", function()
	local cf = cam.CFrame * CFrame.new(0,0,-40)
	SmoothMove(cf, 2)
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

-- DOLLY ZOOM
btn("Dolly Zoom In", function()
	for i = 1,40 do
		cam.FieldOfView -= 0.5
		cam.CFrame *= CFrame.new(0,0,-1)
		RunService.RenderStepped:Wait()
	end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

btn("Dolly Zoom Out", function()
	for i = 1,40 do
		cam.FieldOfView += 0.5
		cam.CFrame *= CFrame.new(0,0,1)
		RunService.RenderStepped:Wait()
	end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

-- ORBIT MODE
local orbitOn = false
local orbitAngle = 0
local orbitRadius = 60

btn("Orbit Camera ON / OFF", function()
	orbitOn = not orbitOn
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

-- HIDE GAME UI (SAFE)
local hidden = false
btn("Hide Game UI (Safe)", function()
	hidden = not hidden
	for _,ui in pairs(player.PlayerGui:GetChildren()) do
		if ui ~= gui and ui ~= fadeGui and ui:IsA("ScreenGui") and not ui.Name:lower():find("chat") then
			ui.Enabled = not hidden
		end
	end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1


-- RENDERSTEPPED LOOP
RunService.RenderStepped:Connect(function(dt) -- Ambil Delta Time (dt)
    local hrp = HRP()

    -- Proper Fly logic
    if fly and bv and bg then
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

    -- Orbit logic
    if orbitOn then
	    orbitAngle += 0.5 * dt
	    local center = cam.CFrame.Position
	    local x = math.cos(orbitAngle) * orbitRadius
	    local z = math.sin(orbitAngle) * orbitRadius
	    cam.CFrame = CFrame.new(center + Vector3.new(x, 15, z), center)
    end

    -- Coordinate Display logic (Status Panel)
    if hrp then
        local p = hrp.Position
        coord.Text = string.format(
            "POS: X: %.1f | Y: %.1f | Z: %.1f", 
            p.X, p.Y, p.Z
        )
    end
    
    -- PING logic
    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    pingLabel.Text = string.format("PING: %d ms", ping)

    -- Warna berdasarkan Ping
    if ping < 80 then
        pingLabel.TextColor3 = Color3.fromRGB(0,255,120) 
    elseif ping < 150 then
        pingLabel.TextColor3 = Color3.fromRGB(255,200,0) 
    else
        pingLabel.TextColor3 = Color3.fromRGB(255,80,80) 
    end
end)

