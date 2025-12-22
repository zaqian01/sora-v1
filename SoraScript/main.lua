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
frame.Size = UDim2.fromOffset(300, 350) -- Sedikit lebih tinggi untuk info ping
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
header.BorderSizePixel = 0

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
minimize.BorderSizePixel = 0

local minCorner = Instance.new("UICorner", minimize)
minCorner.CornerRadius = UDim.new(0,6)

-- ================= CONTENT FRAME =================
local contentFrame = Instance.new("Frame", frame)
contentFrame.Position = UDim2.fromOffset(0,40)
contentFrame.Size = UDim2.new(1,0,1,-40)
contentFrame.BackgroundTransparency = 1

local list = Instance.new("UIListLayout", contentFrame)
list.Padding = UDim.new(0,8)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ================= UTILS & HELPER =================
local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function createBtn(text, order)
    local b = Instance.new("TextButton", contentFrame)
    b.Size = UDim2.fromOffset(280, 35)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.LayoutOrder = order
    
    local bCorner = Instance.new("UICorner", b)
    bCorner.CornerRadius = UDim.new(0,6)
    return b
end

-- ================= INFO LABELS =================
local infoFrame = Instance.new("Frame", contentFrame)
infoFrame.Size = UDim2.new(1,0,0,50)
infoFrame.BackgroundTransparency = 1
infoFrame.LayoutOrder = 0

local coord = Instance.new("TextLabel", infoFrame)
coord.Size = UDim2.new(1,0,0,25)
coord.BackgroundTransparency = 1
coord.TextColor3 = Color3.fromRGB(200,200,200)
coord.Text = "POS: --"
coord.Font = Enum.Font.Gotham

local pingLabel = Instance.new("TextLabel", infoFrame)
pingLabel.Size = UDim2.new(1,0,0,25)
pingLabel.Position = UDim2.fromOffset(0,20)
pingLabel.BackgroundTransparency = 1
pingLabel.TextColor3 = Color3.fromRGB(0,255,180)
pingLabel.Text = "PING: --"
pingLabel.Font = Enum.Font.Gotham

-- ================= FEATURE LOGIC =================

-- 1. MINIMIZE LOGIC
local minimized = false
local fullSize = frame.Size
local miniSize = UDim2.fromOffset(300, 40)

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame:TweenSize(miniSize, "Out", "Quad", 0.2, true)
        contentFrame.Visible = false
        minimize.Text = "+"
    else
        frame:TweenSize(fullSize, "Out", "Quad", 0.2, true)
        contentFrame.Visible = true
        minimize.Text = "–"
    end
end)

-- 2. FLY (Original)
local fly = false
local bv, bg
local flyBtn = createBtn("Fly: OFF", 1)

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

-- 3. NOCLIP
local noclip = false
local noclipBtn = createBtn("Noclip: OFF", 2)
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

-- 4. HIDE UI
local hidden = false
createBtn("Hide Other UIs", 3).MouseButton1Click:Connect(function()
    hidden = not hidden
    for _,ui in pairs(player.PlayerGui:GetChildren()) do
        if ui ~= gui and ui:IsA("ScreenGui") then ui.Enabled = not hidden end
    end
end)

-- 5. AUTO CHRISTMAS
local autoXmas = false
local xmasBtn = createBtn("Auto Christmas: OFF", 4)
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
    if hrp then
        coord.Text = string.format("X: %.1f | Y: %.1f | Z: %.1f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
    end
    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    pingLabel.Text = string.format("PING: %d ms", ping)
end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    
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
