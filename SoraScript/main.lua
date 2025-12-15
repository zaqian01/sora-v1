local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats") 
local TweenService = game:GetService("TweenService") 

local player = Players.LocalPlayer
local DIST = 50 
local HEADER_HEIGHT = 35 
local INFO_HEIGHT = 70 
-- Tinggi disesuaikan untuk tombol + slider baru
local INITIAL_HEIGHT = 700 -- Disesuaikan untuk 1 tombol baru
local FRAME_WIDTH = 300

-- UTILS
local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- CAMERA INIT
local cam = workspace.CurrentCamera
local freecam = false
local freecamSpeed = 1 -- Diatur oleh slider
local camCF

-- INPUT MOVEMENT (Freecam)
local camKeys = {W=false,A=false,S=false,D=false,Q=false,E=false}

UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if camKeys[i.KeyCode.Name] ~= nil then
		camKeys[i.KeyCode.Name] = true
	end
end)

UIS.InputEnded:Connect(function(i)
	if camKeys[i.KeyCode.Name] ~= nil then
		camKeys[i.KeyCode.Name] = false
	end
end)


-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA"

-- ===== FADE SCREEN =====
local fadeGui = Instance.new("ScreenGui", player.PlayerGui)
fadeGui.Name = "SoraFade"
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

-- SLIDER FUNCTION
local function slider(name, min, max, default, callback)
	local f = Instance.new("Frame", contentFrame)
	f.Size = UDim2.fromOffset(FRAME_WIDTH-20,40)
	f.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", f)
	label.Size = UDim2.new(1,0,0,20)
	label.Text = name..": "..default
	label.TextColor3 = Color3.new(1,1,1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Code
    label.TextSize = 15 

	local bar = Instance.new("TextButton", f)
	bar.Size = UDim2.new(1,0,0,10)
	bar.Position = UDim2.fromOffset(0,25)
	bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
	bar.Text = ""
    bar.TextSize = 1

	bar.MouseButton1Down:Connect(function()
		local move
		move = UIS.InputChanged:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseMovement then
				local pct = math.clamp(
					(i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
					0,1
				)
				local val = math.floor(min + (max-min)*pct)
				label.Text = name..": "..val
				callback(val)
			end
		end)
		UIS.InputEnded:Wait()
		move:Disconnect()
	end)
    return f 
end
-- END SLIDER FUNCTION

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

-- MINIMIZE
local minimized = false
btn("Minimize UI", function()
	minimized = not minimized
	for _,v in pairs(contentFrame:GetChildren()) do
		if v ~= infoFrame and v:IsA("GuiObject") then 
			v.Visible = not minimized
		end
	end
	frame.Size = minimized
		and UDim2.fromOffset(FRAME_WIDTH, HEADER_HEIGHT + INFO_HEIGHT + 10) 
		or UDim2.fromOffset(FRAME_WIDTH, INITIAL_HEIGHT)
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1


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

-- FREECAM
btn("Freecam ON / OFF", function()
	freecam = not freecam
	if freecam then
		camCF = cam.CFrame
		cam.CameraType = Enum.CameraType.Scriptable
        if fly then
            btn("Fly ON / OFF"):Click() 
        end
	else
		cam.CameraType = Enum.CameraType.Custom
	end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

-- FREECAM SPEED SLIDER
slider("Freecam Speed",1,20,5,function(v) 
	freecamSpeed = v
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

-- HIDE NAME
local namesHidden = false

local function ToggleNameHiding(hide)
    for _,p in pairs(Players:GetPlayers()) do
        if p.Character then
            -- Cari Humanoid NameTag di atas kepala (biasanya BillboardGui di atas HumanoidRootPart)
            local nameTag = p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid"):FindFirstChild("NameDisplay")
            if nameTag then
                nameTag.Visible = not hide
            end
            
            -- Cari BillboardGui lain di karakter yang mungkin berisi nama
            for _, descendant in pairs(p.Character:GetDescendants()) do
                if descendant:IsA("BillboardGui") and descendant.Parent:IsA("Humanoid") then
                    descendant.Enabled = not hide
                end
            end
        end
    end
end

btn("Hide Name ON / OFF", function()
    namesHidden = not namesHidden
    ToggleNameHiding(namesHidden)
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1


-- SMOOTH CAMERA MOVE UTILS
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
local orbitRate = 3 

btn("Orbit Camera ON / OFF", function()
	orbitOn = not orbitOn
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

-- ORBIT SPEED SLIDER
slider("Orbit Speed",1,10,3,function(v)
	orbitRate = v
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

-- HIDE GAME UI (SAFE)
local hidden = false
btn("Hide Game UI", function()
	hidden = not hidden
	for _,ui in pairs(player.PlayerGui:GetChildren()) do
		if ui ~= gui and ui ~= fadeGui and ui:IsA("ScreenGui") then 
			ui.Enabled = not hidden
		end
	end
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1


-- RENDERSTEPPED LOOP
RunService.RenderStepped:Connect(function(dt) 
    local hrp = HRP()

    -- Freecam Movement
    if freecam then
	    local move = Vector3.zero
	    if camKeys.W then move += cam.CFrame.LookVector end
	    if camKeys.S then move -= cam.CFrame.LookVector end
	    if camKeys.A then move -= cam.CFrame.RightVector end
	    if camKeys.D then move += cam.CFrame.RightVector end
	    if camKeys.E then move += Vector3.new(0,1,0) end
	    if camKeys.Q then move -= Vector3.new(0,1,0) end

	    camCF = camCF + move * freecamSpeed
	    cam.CFrame = camCF
    end

    -- Proper Fly logic
    if fly and bv and bg and not freecam then -- Hanya aktif jika Freecam OFF
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
    if orbitOn and not freecam then 
	    orbitAngle += orbitRate * 0.1 * dt
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

-- Pasang listener untuk Name Hiding pada karakter yang baru spawn/ditambahkan
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        if namesHidden then
            ToggleNameHiding(true)
        end
    end)
end)

if namesHidden then
    ToggleNameHiding(true)
end
