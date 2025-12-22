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
gui.Name = "SORA"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 450)
frame.Position = UDim2.fromScale(0.05, 0.2)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- ================= HEADER =================
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,40)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", header).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-50,1,0)
title.Position = UDim2.fromOffset(12,0)
title.BackgroundTransparency = 1
title.Text = "SORA"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0,255,180)

local minimize = Instance.new("TextButton", header)
minimize.Size = UDim2.fromOffset(36,26)
minimize.Position = UDim2.new(1, -10, 0.5, 0)
minimize.AnchorPoint = Vector2.new(1,0.5)
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.Text = "–"
minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,6)

-- ================= INFO DISPLAY =================
local infoFrame = Instance.new("Frame", frame)
infoFrame.Size = UDim2.new(1, 0, 0, 80)
infoFrame.Position = UDim2.fromOffset(0, 40)
infoFrame.BackgroundTransparency = 1

local coordLabel = Instance.new("TextLabel", infoFrame)
coordLabel.Size = UDim2.new(1,0,0,25)
coordLabel.BackgroundTransparency = 1
coordLabel.TextColor3 = Color3.fromRGB(200,200,200)
coordLabel.Font = Enum.Font.Code
coordLabel.TextSize = 13

local pingLabel = Instance.new("TextLabel", infoFrame)
pingLabel.Size = UDim2.new(1,0,0,25)
pingLabel.Position = UDim2.fromOffset(0, 22)
pingLabel.BackgroundTransparency = 1
pingLabel.TextColor3 = Color3.fromRGB(0,255,180)
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 14

local xmasCountdown = Instance.new("TextLabel", infoFrame)
xmasCountdown.Size = UDim2.new(1,0,0,25)
xmasCountdown.Position = UDim2.fromOffset(0, 45)
xmasCountdown.BackgroundTransparency = 1
xmasCountdown.TextColor3 = Color3.fromRGB(255,200,0)
xmasCountdown.Font = Enum.Font.GothamBold
xmasCountdown.TextSize = 13
xmasCountdown.Text = "Next Event: --:--:--"

-- ================= PLAYER LIST PANEL (DI SEBELAH KANAN) =================
local playerListFrame = Instance.new("Frame", frame)
playerListFrame.Size = UDim2.fromOffset(200, 300)
playerListFrame.Position = UDim2.new(1, 10, 0, 0) -- Berada di kanan Panel Sora
playerListFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
playerListFrame.Visible = false
Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0,8)

local plTitle = Instance.new("TextLabel", playerListFrame)
plTitle.Size = UDim2.new(1,0,0,30)
plTitle.Text = "Teleport To"
plTitle.TextColor3 = Color3.fromRGB(0,255,180)
plTitle.Font = Enum.Font.GothamBold
plTitle.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", playerListFrame)
scroll.Position = UDim2.fromOffset(5,35)
scroll.Size = UDim2.new(1,-10,1,-45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", scroll).Padding = UDim.new(0,5)

-- ================= UTILS =================
local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function createBtn(text, parent)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, 280, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

-- ================= PLAYER LIST LOGIC =================
local function refreshPlayerList()
    for _,c in pairs(scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local b = Instance.new("TextButton", scroll)
            b.Size = UDim2.new(1, 0, 0, 30)
            b.BackgroundColor3 = Color3.fromRGB(45,45,45)
            b.Text = " " .. plr.DisplayName
            b.TextColor3 = Color3.new(1,1,1)
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Font = Enum.Font.Gotham
            b.TextSize = 12
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
            b.MouseButton1Click:Connect(function()
                local hrp, th = HRP(), plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp and th then hrp.CFrame = th.CFrame * CFrame.new(0,0,3) end
            end)
        end
    end
end

-- ================= FEATURES =================
local contentScroll = Instance.new("ScrollingFrame", frame)
contentScroll.Position = UDim2.fromOffset(0, 130)
contentScroll.Size = UDim2.new(1,0,1,-140)
contentScroll.BackgroundTransparency = 1
contentScroll.ScrollBarThickness = 0
Instance.new("UIListLayout", contentScroll).HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIListLayout", contentScroll).Padding = UDim.new(0,8)

-- Fly & Noclip & TP
local fly, noclip, autoXmas = false, false, false
local flyBtn = createBtn("Fly: OFF", contentScroll)
local noclipBtn = createBtn("Noclip: OFF", contentScroll)
local tpBtn = createBtn("Teleport To Player", contentScroll)
local xmasBtn = createBtn("Auto Christmas: OFF", contentScroll)
local hideBtn = createBtn("Hide Game UI", contentScroll)

flyBtn.MouseButton1Click:Connect(function()
    fly = not fly
    flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
    local hrp = HRP()
    if fly and hrp then
        local bv = Instance.new("BodyVelocity", hrp); bv.Name = "SoraFly"; bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        local bg = Instance.new("BodyGyro", hrp); bg.Name = "SoraGyro"; bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        if player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true end
    else
        if hrp then
            if hrp:FindFirstChild("SoraFly") then hrp.SoraFly:Destroy() end
            if hrp:FindFirstChild("SoraGyro") then hrp.SoraGyro:Destroy() end
        end
        if player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false end
    end
end)

noclipBtn.MouseButton1Click:Connect(function() noclip = not noclip; noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF" end)
tpBtn.MouseButton1Click:Connect(function() playerListFrame.Visible = not playerListFrame.Visible; if playerListFrame.Visible then refreshPlayerList() end end)
xmasBtn.MouseButton1Click:Connect(function() autoXmas = not autoXmas; xmasBtn.Text = autoXmas and "Auto Christmas: ON" or "Auto Christmas: OFF" end)
hideBtn.MouseButton1Click:Connect(function() for _,ui in pairs(player.PlayerGui:GetChildren()) do if ui ~= gui and ui:IsA("ScreenGui") then ui.Enabled = not ui.Enabled end end end)

minimize.MouseButton1Click:Connect(function()
    local minimized = (minimize.Text == "–")
    frame:TweenSize(minimized and UDim2.fromOffset(300,40) or UDim2.fromOffset(300,450), "Out", "Quad", 0.2, true)
    contentScroll.Visible = not minimized; infoFrame.Visible = not minimized; playerListFrame.Visible = false
    minimize.Text = minimized and "+" or "–"
end)

-- ================= LOOPS & COUNTDOWN =================
local EVENT_HOURS = {0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22}

RunService.RenderStepped:Connect(function()
    local hrp = HRP()
    if hrp then coordLabel.Text = string.format("POS: X:%.1f Y:%.1f Z:%.1f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z) end
    pingLabel.Text = string.format("PING: %d ms", Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    
    -- Countdown Logic
    local t = os.date("!*t", workspace:GetServerTimeNow())
    local nextH = 0
    for _,h in pairs(EVENT_HOURS) do if h > t.hour then nextH = h; break end end
    local diff = os.time({year=t.year, month=t.month, day=t.day, hour=nextH, min=0, sec=0}) - workspace:GetServerTimeNow()
    local ch, cm, cs = math.floor(diff/3600), math.floor((diff%3600)/60), math.floor(diff%60)
    xmasCountdown.Text = string.format("Next Event: %02d:%02d:%02d", ch, cm, cs)

    if fly and hrp and hrp:FindFirstChild("SoraFly") then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        hrp.SoraFly.Velocity = dir.Magnitude > 0 and dir.Unit * 60 or Vector3.zero
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
        if hrp and isEvent then
            if t.min == 0 and t.sec >= 30 then hrp.CFrame = CFrame.new(606.0, -580.6, 8923.3)
            elseif t.min == 29 and t.sec >= 30 then hrp.CFrame = CFrame.new(1173.1, 23.4, 1565.1) end
        end
    end
end)
