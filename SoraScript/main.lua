-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- ================= ANTI AFK =================
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= GUI ROOT =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA_FINAL"
gui.ResetOnSpawn = false

-- ================= FLOATING LOGO =================
local openLogo = Instance.new("ImageButton", gui)
openLogo.Name = "SoraLogo"
openLogo.Size = UDim2.fromOffset(60, 60)
openLogo.Position = UDim2.fromScale(0.02, 0.5)
openLogo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
openLogo.Visible = false 
openLogo.Active = true
openLogo.Draggable = true 
openLogo.Image = "rbxassetid://86170889168529" -- LOGO BARU

local logoCorner = Instance.new("UICorner", openLogo)
logoCorner.CornerRadius = UDim.new(1, 0)
local logoStroke = Instance.new("UIStroke", openLogo)
logoStroke.Color = Color3.fromRGB(0, 255, 180)
logoStroke.Thickness = 2

-- ================= MAIN PANEL =================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 480)
frame.Position = UDim2.fromScale(0.35, 0.2)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- HEADER
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,40)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", header).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-50,1,0)
title.Position = UDim2.fromOffset(12,0)
title.BackgroundTransparency = 1
title.Text = "SORA HUB"
title.TextColor3 = Color3.fromRGB(0,255,180)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local minimize = Instance.new("TextButton", header)
minimize.Size = UDim2.fromOffset(36,26)
minimize.Position = UDim2.new(1, -10, 0.5, 0)
minimize.AnchorPoint = Vector2.new(1,0.5)
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.Text = "–"
minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,6)

-- INFO DISPLAY
local infoFrame = Instance.new("Frame", frame)
infoFrame.Size = UDim2.new(1, 0, 0, 80)
infoFrame.Position = UDim2.fromOffset(0, 40)
infoFrame.BackgroundTransparency = 1

local coordLabel = Instance.new("TextLabel", infoFrame)
coordLabel.Size = UDim2.new(1,0,0,25); coordLabel.BackgroundTransparency = 1; coordLabel.TextColor3 = Color3.fromRGB(200,200,200); coordLabel.Font = Enum.Font.Code; coordLabel.TextSize = 12
local pingLabel = Instance.new("TextLabel", infoFrame)
pingLabel.Size = UDim2.new(1,0,0,25); pingLabel.Position = UDim2.fromOffset(0, 22); pingLabel.BackgroundTransparency = 1; pingLabel.TextColor3 = Color3.fromRGB(0,255,180); pingLabel.Font = Enum.Font.GothamBold; pingLabel.TextSize = 13
local xmasCountdown = Instance.new("TextLabel", infoFrame)
xmasCountdown.Size = UDim2.new(1,0,0,25); xmasCountdown.Position = UDim2.fromOffset(0, 45); xmasCountdown.BackgroundTransparency = 1; xmasCountdown.TextColor3 = Color3.fromRGB(255,200,0); xmasCountdown.Font = Enum.Font.GothamBold; xmasCountdown.TextSize = 13

-- ================= SIDE PANEL: SPOTS (LEFT) =================
local spotFrame = Instance.new("Frame", frame)
spotFrame.Size = UDim2.fromOffset(180, 200)
spotFrame.Position = UDim2.new(0, -190, 0, 0)
spotFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
spotFrame.Visible = false
Instance.new("UICorner", spotFrame).CornerRadius = UDim.new(0,8)

local spotTitle = Instance.new("TextLabel", spotFrame)
spotTitle.Size = UDim2.new(1,0,0,35); spotTitle.Text = "Event Spots"; spotTitle.TextColor3 = Color3.fromRGB(0,255,180); spotTitle.Font = Enum.Font.GothamBold; spotTitle.BackgroundTransparency = 1

local spotList = Instance.new("ScrollingFrame", spotFrame)
spotList.Position = UDim2.fromOffset(5,35); spotList.Size = UDim2.new(1,-10,1,-45); spotList.BackgroundTransparency = 1; spotList.ScrollBarThickness = 0
local spotLayout = Instance.new("UIListLayout", spotList); spotLayout.Padding = UDim.new(0,5)

local SPOTS = {
    ["Spot 1"] = CFrame.new(606.0, -580.6, 8923.3),
    ["Spot 2"] = CFrame.new(603.4, -580.6, 8886.0),
    ["Spot 3"] = CFrame.new(576.8, -580.7, 8845.8),
    ["Spot 4"] = CFrame.new(774.6, -487.2, 8923.0)
}
local selectedSpot = SPOTS["Spot 1"]

for name, cf in pairs(SPOTS) do
    local b = Instance.new("TextButton", spotList)
    b.Size = UDim2.new(1, 0, 0, 30); b.BackgroundColor3 = Color3.fromRGB(45,45,45); b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
    b.MouseButton1Click:Connect(function() 
        selectedSpot = cf
        spotTitle.Text = "Active: " .. name
    end)
end

-- ================= PLAYER LIST PANEL (RIGHT) =================
local playerListFrame = Instance.new("Frame", frame)
playerListFrame.Size = UDim2.fromOffset(200, 300)
playerListFrame.Position = UDim2.new(1, 15, 0, 0) 
playerListFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
playerListFrame.Visible = false
Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0,8)

local scroll = Instance.new("ScrollingFrame", playerListFrame)
scroll.Position = UDim2.fromOffset(5,35); scroll.Size = UDim2.new(1,-10,1,-45); scroll.BackgroundTransparency = 1; scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", scroll).Padding = UDim.new(0,5)

-- ================= UTILS & FLY SPEED =================
local fly, flySpeed, noclip, autoXmas = false, 60, false, false
local lastFishingPos = nil
local teleported, returned = false, false

local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ================= FEATURES AREA =================
local contentScroll = Instance.new("ScrollingFrame", frame)
contentScroll.Position = UDim2.fromOffset(0, 130); contentScroll.Size = UDim2.new(1,0,1,-140); contentScroll.BackgroundTransparency = 1; contentScroll.ScrollBarThickness = 0
Instance.new("UIListLayout", contentScroll).HorizontalAlignment = Enum.HorizontalAlignment.Center; Instance.new("UIListLayout", contentScroll).Padding = UDim.new(0,8)

local function createBtn(text)
    local b = Instance.new("TextButton", contentScroll)
    b.Size = UDim2.new(0, 270, 0, 36); b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.Text = text; b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

-- FLY SPEED SLIDER UI
local sliderFrame = Instance.new("Frame", contentScroll)
sliderFrame.Size = UDim2.new(0, 270, 0, 45); sliderFrame.BackgroundTransparency = 1
local sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.new(1,0,0,20); sliderLabel.Text = "Fly Speed: " .. flySpeed; sliderLabel.TextColor3 = Color3.new(1,1,1); sliderLabel.BackgroundTransparency = 1; sliderLabel.Font = Enum.Font.Gotham
local sliderBar = Instance.new("TextButton", sliderFrame)
sliderBar.Size = UDim2.new(0, 250, 0, 6); sliderBar.Position = UDim2.fromOffset(10, 25); sliderBar.BackgroundColor3 = Color3.fromRGB(50,50,50); sliderBar.Text = ""
local sliderFill = Instance.new("Frame", sliderBar)
sliderFill.Size = UDim2.fromScale(flySpeed/200, 1); sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 180); sliderFill.BorderSizePixel = 0

sliderBar.MouseButton1Down:Connect(function()
    local moveCon
    moveCon = UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            flySpeed = math.floor(relativeX * 200)
            sliderFill.Size = UDim2.fromScale(relativeX, 1)
            sliderLabel.Text = "Fly Speed: " .. flySpeed
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then moveCon:Disconnect() end
    end)
end)

local flyBtn = createBtn("Fly: OFF")
local noclipBtn = createBtn("Noclip: OFF")
local tpBtn = createBtn("Teleport To Player")
local xmasBtn = createBtn("Auto Christmas: OFF")
local spotBtn = createBtn("Pick Event Spot")
local hideBtn = createBtn("Hide Game UI")

-- HANDLERS
flyBtn.MouseButton1Click:Connect(function()
    fly = not fly; flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
    local hrp = HRP()
    if fly and hrp then
        local bv = Instance.new("BodyVelocity", hrp); bv.Name = "SoraFly"; bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        local bg = Instance.new("BodyGyro", hrp); bg.Name = "SoraGyro"; bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        player.Character.Humanoid.PlatformStand = true
    else
        if HRP() then
            if HRP():FindFirstChild("SoraFly") then HRP().SoraFly:Destroy() end
            if HRP():FindFirstChild("SoraGyro") then HRP().SoraGyro:Destroy() end
        end
        player.Character.Humanoid.PlatformStand = false
    end
end)

noclipBtn.MouseButton1Click:Connect(function() noclip = not noclip; noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF" end)
tpBtn.MouseButton1Click:Connect(function() playerListFrame.Visible = not playerListFrame.Visible; spotFrame.Visible = false end)
spotBtn.MouseButton1Click:Connect(function() spotFrame.Visible = not spotFrame.Visible; playerListFrame.Visible = false end)
xmasBtn.MouseButton1Click:Connect(function() autoXmas = not autoXmas; xmasBtn.Text = autoXmas and "Auto Christmas: ON" or "Auto Christmas: OFF" end)

-- FIXED HIDE UI
local uiHidden = false
hideBtn.MouseButton1Click:Connect(function()
    uiHidden = not uiHidden
    hideBtn.Text = uiHidden and "Show Game UI" or "Hide Game UI"
    for _, v in pairs(player.PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name ~= gui.Name then
            v.Enabled = not uiHidden
        end
    end
end)

minimize.MouseButton1Click:Connect(function() frame.Visible = false; openLogo.Visible = true; spotFrame.Visible = false; playerListFrame.Visible = false end)
openLogo.MouseButton1Click:Connect(function() openLogo.Visible = false; frame.Visible = true end)

-- LOOPS
local EVENT_HOURS = {0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22}

RunService.RenderStepped:Connect(function()
    local hrp = HRP()
    if hrp then coordLabel.Text = string.format("POS: X:%.1f Y:%.1f Z:%.1f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z) end
    pingLabel.Text = string.format("PING: %d ms", Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    
    local t = os.date("!*t", workspace:GetServerTimeNow())
    local nextH = 24
    for _,h in pairs(EVENT_HOURS) do if h > t.hour then nextH = h; break end end
    local diff = os.time({year=t.year, month=t.month, day=t.day, hour=nextH, min=0, sec=0}) - workspace:GetServerTimeNow()
    xmasCountdown.Text = string.format("Next Event: %02d:%02d:%02d", math.floor(diff/3600), math.floor((diff%3600)/60), math.floor(diff%60))

    if fly and hrp and hrp:FindFirstChild("SoraFly") then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        hrp.SoraFly.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
        hrp.SoraGyro.CFrame = cam.CFrame
    end
end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then for _,v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if autoXmas then
        local t = os.date("!*t", workspace:GetServerTimeNow())
        local isEvent = false
        for _,h in pairs(EVENT_HOURS) do if t.hour == h then isEvent = true; break end end
        local hrp = HRP()
        if hrp then
            if isEvent and t.min == 0 and t.sec >= 30 and not teleported then
                lastFishingPos = hrp.CFrame
                hrp.CFrame = selectedSpot -- TP KE SPOT YANG DIPILIH
                teleported = true; returned = false
            elseif t.min == 29 and t.sec >= 30 and teleported and not returned then
                hrp.CFrame = lastFishingPos or CFrame.new(1173.1, 23.4, 1565.1)
                returned = true
            end
            if not isEvent then teleported = false; returned = false end
        end
    end
end)
