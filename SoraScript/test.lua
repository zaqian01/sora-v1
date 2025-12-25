-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer

-- ================= GUI ROOT =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 350)
frame.Position = UDim2.fromScale(0.05, 0.2)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0,10)

-- ================= HEADER + MINIMIZE =================
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,40)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0,10)

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
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 22
minimize.TextColor3 = Color3.new(1,1,1)

local minCorner = Instance.new("UICorner", minimize)
minCorner.CornerRadius = UDim.new(0,6)

-- ================= CONTENT =================
local contentFrame = Instance.new("Frame", frame)
contentFrame.Position = UDim2.fromOffset(0,40)
contentFrame.Size = UDim2.new(1,0,1,-40)
contentFrame.BackgroundTransparency = 1

local list = Instance.new("UIListLayout", contentFrame)
list.Padding = UDim.new(0,8)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- UTILS
local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function btn(text)
    local b = Instance.new("TextButton", contentFrame)
    b.Size = UDim2.fromOffset(280, 38)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

-- INFO DISPLAY
local infoFrame = Instance.new("Frame", contentFrame)
infoFrame.Size = UDim2.new(1, 0, 0, 55)
infoFrame.BackgroundTransparency = 1

local coord = Instance.new("TextLabel", infoFrame)
coord.Size = UDim2.new(1,0,0,25)
coord.BackgroundTransparency = 1
coord.TextColor3 = Color3.fromRGB(200,200,200)
coord.Font = Enum.Font.GothamBold
coord.TextSize = 13

local pingLabel = Instance.new("TextLabel", infoFrame)
pingLabel.Size = UDim2.new(1,0,0,25)
pingLabel.Position = UDim2.fromOffset(0, 22)
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 16

-- ================= FEATURES LOGIC =================

-- MINIMIZE
local minimized = false
local fullSize = frame.Size
local miniSize = UDim2.fromOffset(300, 40)

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame:TweenSize(minimized and miniSize or fullSize, "Out", "Quad", 0.2, true)
    contentFrame.Visible = not minimized
    minimize.Text = minimized and "+" or "–"
end)

-- PROPER FLY LOGIC (Pake yang baru kamu kirim)
local fly = false
local speed = 60
local bv, bg
local keys = {W=false, A=false, S=false, D=false, Space=false, Ctrl=false}

UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.W then keys.W = true end
    if i.KeyCode == Enum.KeyCode.S then keys.S = true end
    if i.KeyCode == Enum.KeyCode.A then keys.A = true end
    if i.KeyCode == Enum.KeyCode.D then keys.D = true end
    if i.KeyCode == Enum.KeyCode.Space then keys.Space = true end
    if i.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = true end
end)

UIS.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.W then keys.W = false end
    if i.KeyCode == Enum.KeyCode.S then keys.S = false end
    if i.KeyCode == Enum.KeyCode.A then keys.A = false end
    if i.KeyCode == Enum.KeyCode.D then keys.D = false end
    if i.KeyCode == Enum.KeyCode.Space then keys.Space = false end
    if i.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = false end
end)

local flyBtn = btn("Fly: OFF")
flyBtn.MouseButton1Click:Connect(function()
    fly = not fly
    flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
    local hrp = HRP()
    if not hrp then return end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = fly end
    if fly then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- NOCLIP
local noclip = false
local noclipBtn = btn("Noclip: OFF")
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

-- HIDE UI
local hidden = false
btn("Hide Game UI").MouseButton1Click:Connect(function()
    hidden = not hidden
    for _, ui in pairs(player.PlayerGui:GetChildren()) do
        if ui ~= gui and ui:IsA("ScreenGui") then ui.Enabled = not hidden end
    end
end)

-- AUTO CHRISTMAS
local autoXmas = false
local xmasBtn = btn("Auto Christmas: OFF")
local ORIGINAL_CFRAME = CFrame.new(1173.1, 23.4, 1565.1)
local EVENT_CFRAME    = CFrame.new(606.0, -580.6, 8923.3)
local EVENT_HOURS = {[0]=true,[2]=true,[4]=true,[6]=true,[8]=true,[10]=true}
local teleported, returned = false, false

xmasBtn.MouseButton1Click:Connect(function()
    autoXmas = not autoXmas
    xmasBtn.Text = autoXmas and "Auto Christmas: ON" or "Auto Christmas: OFF"
end)

-- ================= LOOPS =================

RunService.RenderStepped:Connect(function()
    local hrp = HRP()
    -- Fly Movement
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
    -- Update Labels
    if hrp then
        coord.Text = string.format("POS: X: %.1f | Y: %.1f | Z: %.1f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
    end
    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    pingLabel.Text = string.format("PING: %d ms", ping)
    pingLabel.TextColor3 = ping < 80 and Color3.fromRGB(0,255,120) or (ping < 150 and Color3.fromRGB(255,200,0) or Color3.fromRGB(255,80,80))
end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    -- Auto Event
    if autoXmas then
        local hrp = HRP()
        if hrp then
            local t = os.date("!*t", workspace:GetServerTimeNow())
            if EVENT_HOURS[t.hour] and t.min == 0 and t.sec >= 30 and not teleported then
                hrp.CFrame = EVENT_CFRAME
                teleported, returned = true, false
            elseif EVENT_HOURS[t.hour] and t.min == 29 and t.sec >= 30 and teleported and not returned then
                hrp.CFrame = ORIGINAL_CFRAME
                returned = true
            elseif not EVENT_HOURS[t.hour] then
                teleported, returned = false, false
            end
        end
    end
end)
