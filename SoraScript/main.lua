local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats") 

local player = Players.LocalPlayer
local DIST = 50 
local HEADER_HEIGHT = 35 
local INFO_HEIGHT = 70 
local INITIAL_HEIGHT = 440 -- Disesuaikan karena tombol speed berkurang dan minimize dihapus
local FRAME_WIDTH = 300

-- UTILS
local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA_V1"

-- 1. MainFrame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(FRAME_WIDTH, INITIAL_HEIGHT)
frame.Position = UDim2.fromOffset(200, 200)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
frame.ClipsDescendants = true 

-- 2. Header
local title = Instance.new("TextLabel", frame)
title.Name = "Header"
title.Size = UDim2.new(1,0,0,HEADER_HEIGHT)
title.Text = "SORA V1" -- Disingkat
title.TextColor3 = Color3.fromRGB(0,255,180)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.Font = Enum.Font.Code
title.TextSize = 18 
title.BorderSizePixel = 0

-- 3. ContentFrame
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


-- Function to create buttons
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

-- 4. InfoFrame (PING & Koordinat)
local infoFrame = Instance.new("Frame", contentFrame)
infoFrame.Name = "InfoFrame"
infoFrame.Size = UDim2.fromOffset(FRAME_WIDTH - 20, INFO_HEIGHT)
infoFrame.BackgroundTransparency = 1
infoFrame.LayoutOrder = 1 

local infoList = Instance.new("UIListLayout", infoFrame)
infoList.HorizontalAlignment = Enum.HorizontalAlignment.Left
infoList.SortOrder = Enum.SortOrder.LayoutOrder
infoList.Padding = UDim.new(0,5)

-- COORDINATE LABEL 
local coord = Instance.new("TextLabel", infoFrame)
coord.Size = UDim2.new(1,0,0,30)
coord.BackgroundTransparency = 1
coord.TextWrapped = true
coord.TextXAlignment = Enum.TextXAlignment.Left
coord.Text = "POS: X: 0.0 | Y: 0.0 | Z: 0.0 | WS: 16"
coord.TextSize = 16 
coord.Font = Enum.Font.GothamBold 
coord.TextColor3 = Color3.fromRGB(220,220,220) 

-- PING LABEL
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

-- Main Buttons start here
local buttonStartOrder = 3 

-- ===== WALK SPEED (TEXTBOX BARU) =====
local speedEnabled = true
local speedValue = 16
local speedBox = Instance.new("TextBox", contentFrame)
speedBox.Size = UDim2.fromOffset(FRAME_WIDTH - 20, 40) -- Tinggi disesuaikan
speedBox.PlaceholderText = "Set Speed (default 16)"
speedBox.Text = "16"
speedBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Code
speedBox.TextSize = 18 -- Disesuaikan
speedBox.ClearTextOnFocus = false
speedBox.LayoutOrder = buttonStartOrder
buttonStartOrder += 1

local function applySpeed()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = speedEnabled and speedValue or 16
	end
end

speedBox.FocusLost:Connect(function(enter)
	if not enter then return end
	local val = tonumber(speedBox.Text)
	if val and val >= 5 and val < 500 then -- Batas minimal 5
		speedValue = val
		applySpeed()
		speedBox.Text = "Speed: "..val
	else
		speedBox.Text = "Invalid"
	end
end)

btn("Speed ON / OFF", function()
	speedEnabled = not speedEnabled
	applySpeed()
end).LayoutOrder = buttonStartOrder
buttonStartOrder = buttonStartOrder + 1

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

-- ===== WALK ON WATER (LOGIC BARU) =====
local waterWalk = false
local lockedY = nil

btn("Walk On Water ON / OFF", function()
	waterWalk = not waterWalk
	lockedY = nil
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


-- ===== RENDERSTEPPED LOOP (FINAL LOGIC) =====
RunService.RenderStepped:Connect(function()
    local hrp = HRP()

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

    -- Walk On Water logic
	if waterWalk and hrp then
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {player.Character}
		rayParams.FilterType = Enum.RaycastFilterType.Blacklist

		local result = workspace:Raycast(
			hrp.Position,
			Vector3.new(0, -10, 0),
			rayParams
		)

		if result and result.Material == Enum.Material.Water then
			if not lockedY then
				lockedY = result.Position.Y + 3
			end

			-- Mengunci posisi Y sambil mempertahankan rotasi
			hrp.CFrame = CFrame.new(
				hrp.Position.X,
				lockedY,
				hrp.Position.Z
			) * (hrp.CFrame - hrp.CFrame.Position)
		else
			lockedY = nil
		end
	end

    -- Coordinate Display logic (Status Panel)
    if hrp then
        local p = hrp.Position
        coord.Text = string.format(
            "POS: X: %.1f | Y: %.1f | Z: %.1f | WS: %d", 
            p.X, p.Y, p.Z, speedValue
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
